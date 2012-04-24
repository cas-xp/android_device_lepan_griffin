/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "TIHardwareRenderer"
#include <utils/Log.h>

#include "TIHardwareRenderer.h"

#include <media/stagefright/MediaDebug.h>
#include <surfaceflinger/ISurface.h>
#include <ui/Overlay.h>
#include <cutils/properties.h>

#include "v4l2_utils.h"

#define UNLIKELY( exp ) (__builtin_expect( (exp) != 0, false ))

namespace android {

static int mDebugFps = 0;

/* To print the FPS, type this command on the console before starting playback:
     setprop debug.video.showfps 1
   To disable the prints, type:
     setprop debug.video.showfps 0
*/

static void debugShowFPS()
{
    static int mFrameCount = 0;
    static int mLastFrameCount = 0;
    static nsecs_t mLastFpsTime = 0;
    static float mFps = 0;
    mFrameCount++;
    if (!(mFrameCount & 0x1F)) {
        nsecs_t now = systemTime();
        nsecs_t diff = now - mLastFpsTime;
        mFps = ((mFrameCount - mLastFrameCount) * float(s2ns(1))) / diff;
        mLastFpsTime = now;
        mLastFrameCount = mFrameCount;
        LOGD("%d Frames, %f FPS", mFrameCount, mFps);
    }
    // XXX: mFPS has the value we want
}

////////////////////////////////////////////////////////////////////////////////

TIHardwareRenderer::TIHardwareRenderer(
        const sp<ISurface> &surface,
        size_t displayWidth, size_t displayHeight,
        size_t decodedWidth, size_t decodedHeight,
        OMX_COLOR_FORMATTYPE colorFormat)
    : mISurface(surface),
      mDisplayWidth(displayWidth),
      mDisplayHeight(displayHeight),
      mDecodedWidth(decodedWidth),
      mDecodedHeight(decodedHeight),
      mColorFormat(colorFormat),
      mInitCheck(NO_INIT),
      mFrameSize(mDecodedWidth * mDecodedHeight * 2),
#ifdef OVERLAY_SUPPORT_USERPTR_BUF
      release_frame_cb(0),
#endif
      nOverlayBuffersQueued(0),
      mIndex(0) {
    CHECK(mISurface.get() != NULL);
    CHECK(mDecodedWidth > 0);
    CHECK(mDecodedHeight > 0);

    if (colorFormat != OMX_COLOR_FormatCbYCrY
            && colorFormat != OMX_COLOR_FormatYUV420Planar) {
        return;
    }

    sp<OverlayRef> ref = mISurface->createOverlay(
            mDecodedWidth, mDecodedHeight, OVERLAY_FORMAT_CbYCrY_422_I, 0);

    if (ref.get() == NULL) {
        LOGE("Unable to create the overlay!");
        return;
    }

    mOverlay = new Overlay(ref);
    mOverlay->setParameter(CACHEABLE_BUFFERS, 0);

#ifdef OVERLAY_SUPPORT_USERPTR_BUF
    if (colorFormat == OMX_COLOR_FormatCbYCrY) {
        for (int i=0; i<NUM_OVERLAY_BUFFERS_REQUESTED; i++)
            buffers_queued_to_dss[i].state = WRD_STATE_UNUSED;
    } else {
        mOverlay->setParameter(BUFFER_TYPE, EMEMORY_MMAP);
#endif
    for (size_t i = 0; i < (size_t)mOverlay->getBufferCount(); ++i) {
        mapping_data_t *data =
            (mapping_data_t *)mOverlay->getBufferAddress((void *)i);

        mOverlayAddresses.push(data->ptr);
    }
#ifdef OVERLAY_SUPPORT_USERPTR_BUF
    }
#endif

    char value[PROPERTY_VALUE_MAX];
    property_get("debug.video.showfps", value, "0");
    mDebugFps = atoi(value);
    LOGD_IF(mDebugFps, "showfps enabled");

    mInitCheck = OK;
}

TIHardwareRenderer::~TIHardwareRenderer() {
    if (mOverlay.get() != NULL) {
        mOverlay->destroy();
        mOverlay.clear();

        // XXX apparently destroying an overlay is an asynchronous process...
        //sleep(1);
    }
}

// return a byte offset from any pointer
static inline const void *byteOffset(const void* p, size_t offset) {
    return ((uint8_t*)p + offset);
}

static void convertYuv420ToYuv422(
        int width, int height, const void *src, void *dst) {
    // calculate total number of pixels, and offsets to U and V planes
    int pixelCount = height * width;
    int srcLineLength = width / 4;
    int destLineLength = width / 2;
    uint32_t* ySrc = (uint32_t*) src;
    const uint16_t* uSrc = (const uint16_t*) byteOffset(src, pixelCount);
    const uint16_t* vSrc = (const uint16_t*) byteOffset(uSrc, pixelCount >> 2);
    uint32_t *p = (uint32_t*) dst;

    // convert lines
    for (int i = 0; i < height; i += 2) {

        // upsample by repeating the UV values on adjacent lines
        // to save memory accesses, we handle 2 adjacent lines at a time
        // convert 4 pixels in 2 adjacent lines at a time
        for (int j = 0; j < srcLineLength; j++) {

            // fetch 4 Y values for each line
            uint32_t y0 = ySrc[0];
            uint32_t y1 = ySrc[srcLineLength];
            ySrc++;

            // fetch 2 U/V values
            uint32_t u = *uSrc++;
            uint32_t v = *vSrc++;

            // assemble first U/V pair, leave holes for Y's
            uint32_t uv = (u | (v << 16)) & 0x00ff00ff;

            // OR y values and write to memory
            p[0] = ((y0 & 0xff) << 8) | ((y0 & 0xff00) << 16) | uv;
            p[destLineLength] = ((y1 & 0xff) << 8) | ((y1 & 0xff00) << 16) | uv;
            p++;

            // assemble second U/V pair, leave holes for Y's
            uv = ((u >> 8) | (v << 8)) & 0x00ff00ff;

            // OR y values and write to memory
            p[0] = ((y0 >> 8) & 0xff00) | (y0 & 0xff000000) | uv;
            p[destLineLength] = ((y1 >> 8) & 0xff00) | (y1 & 0xff000000) | uv;
            p++;
        }

        // skip the next y line, we already converted it
        ySrc += srcLineLength;
        p += destLineLength;
    }
}

void TIHardwareRenderer::render(
        const void *data, size_t size, void *platformPrivate) {
    // CHECK_EQ(size, mFrameSize);

    if (UNLIKELY(mDebugFps)) {
        debugShowFPS();
    }

    if (mOverlay.get() == NULL) {
        return;
    }

    if (mColorFormat == OMX_COLOR_FormatYUV420Planar) {
        convertYuv420ToYuv422(
                mDecodedWidth, mDecodedHeight, data, mOverlayAddresses[mIndex]);
    } else {
#ifdef OVERLAY_SUPPORT_USERPTR_BUF
        overlay_buffer_t overlay_buffer;

        // queue the dsp buffer
        for (mIndex = 0; mIndex < NUM_OVERLAY_BUFFERS_REQUESTED; mIndex++) {
            if (buffers_queued_to_dss[mIndex].state == WRD_STATE_UNUSED)
                break;
        }

        if (mIndex < NUM_OVERLAY_BUFFERS_REQUESTED) {
            int nBuffers_queued_to_dss = mOverlay->queueBuffer((void *)data);

            if (nBuffers_queued_to_dss == ALL_BUFFERS_FLUSHED) {
                nBuffers_queued_to_dss = mOverlay->queueBuffer((void *)data);
            }

            if (release_frame_cb) {
                if (nBuffers_queued_to_dss < 0) {
                    LOGE("Queue buffer [%p] failed", data);
                    release_frame_cb(data, cookie);
                }
                else {
                    nOverlayBuffersQueued++;
                    buffers_queued_to_dss[mIndex].ptr = data;
                    buffers_queued_to_dss[mIndex].state = WRD_STATE_INDSSQUEUE;

                    if (nBuffers_queued_to_dss != nOverlayBuffersQueued) { // STREAM OFF occurred
                        //Release all the buffers that were discarded by DSS upon STREAM OFF
                        for (size_t idx = 0; idx < NUM_OVERLAY_BUFFERS_REQUESTED; idx++) {
                            if (idx == mIndex)
                                continue;
                            if (buffers_queued_to_dss[idx].state == WRD_STATE_INDSSQUEUE) {
                                nOverlayBuffersQueued--;
                                buffers_queued_to_dss[idx].state = WRD_STATE_UNUSED;
                                release_frame_cb(buffers_queued_to_dss[idx].ptr, cookie);
                                LOGD("Reclaiming the buffer [%p] from Overlay", buffers_queued_to_dss[idx].ptr);
                            }
                        }
                    }
                }
            }
        } else if (release_frame_cb) {
            LOGW("DSS Queue is full");
            release_frame_cb(data, cookie);
        }

        // dequeue the dsp buffer
        int err = mOverlay->dequeueBuffer(&overlay_buffer);
        if (err == 0) {
            for (mIndex = 0; mIndex < NUM_OVERLAY_BUFFERS_REQUESTED; mIndex++) {
                if (buffers_queued_to_dss[mIndex].ptr == (void *)overlay_buffer)
                    break;
            }

            if (mIndex == NUM_OVERLAY_BUFFERS_REQUESTED) {
                LOGE("Dequeued buffer is not in the record");
                return;
            }

            nOverlayBuffersQueued--;
            buffers_queued_to_dss[mIndex].state = WRD_STATE_UNUSED;
            if (release_frame_cb) {
                release_frame_cb(buffers_queued_to_dss[mIndex].ptr, cookie);
            }
        } else if (nOverlayBuffersQueued >= NUM_QUEUED_BUFFERS_OPTIMAL) {
            LOGE("Dequeue buffer failed");
        }

        return;
#else
        CHECK_EQ(mColorFormat, OMX_COLOR_FormatCbYCrY);

        memcpy(mOverlayAddresses[mIndex], data, size);
#endif
    }

    if (mOverlay->queueBuffer((void *)mIndex) == ALL_BUFFERS_FLUSHED) {
        nOverlayBuffersQueued = 0;
        if (mOverlay->queueBuffer((void *)mIndex) != 0) {
            LOGE("Queue buffer [%d] failed", mIndex);
        }
    }

    if (++mIndex == mOverlayAddresses.size()) {
        mIndex = 0;
    }

    overlay_buffer_t overlay_buffer;
    if (++nOverlayBuffersQueued >= NUM_OVERLAY_BUFFERS_REQUESTED) {
        status_t err = mOverlay->dequeueBuffer(&overlay_buffer);

        if (err == ALL_BUFFERS_FLUSHED) {
            nOverlayBuffersQueued = 0;
        } else if (!err) {
            nOverlayBuffersQueued--;
        } else {
            LOGE("Dequeue buffer failed");
        }
    }
}

#ifdef OVERLAY_SUPPORT_USERPTR_BUF
bool TIHardwareRenderer::setCallback(release_rendered_buffer_callback cb, void *c)
{
    release_frame_cb = cb;
    cookie = c;
    return true;
}
#endif

}  // namespace android

