/*
 * Copyright (C) 2008 The Android Open Source Project
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

//#define OVERLAY_DEBUG 1
#define LOG_TAG "Overlay"

#include <fcntl.h>
#include <errno.h>
#include <cutils/log.h>
#include <hardware/overlay.h>
#include <linux/videodev.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include "v4l2_utils.h"

#ifndef KERNEL_VERSION
#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
#endif
#define MAX_STR_LEN 35

#define LOG_FUNCTION_NAME    LOGV("%s: %s",  __FILE__, __FUNCTION__);

#ifndef LOGE
#define LOGE(fmt,args...) \
        do { printf(fmt, ##args); } \
        while (0)
#endif

#ifndef LOGI
#define LOGI(fmt,args...) \
        do { LOGE(fmt, ##args); } \
        while (0)
#endif
#define V4L2_CID_PRIV_OFFSET			0x00530000
#define V4L2_CID_PRIV_ROTATION		(V4L2_CID_PRIVATE_BASE \
						+ V4L2_CID_PRIV_OFFSET + 0)
#define V4L2_CID_PRIV_COLORKEY		(V4L2_CID_PRIVATE_BASE \
						+ V4L2_CID_PRIV_OFFSET + 1)
#define V4L2_CID_PRIV_COLORKEY_EN	(V4L2_CID_PRIVATE_BASE \
						+ V4L2_CID_PRIV_OFFSET + 2)



int v4l2_overlay_get(int name) {
    int result = -1;
    switch (name) {
        case OVERLAY_MINIFICATION_LIMIT:
            result = 4; // 0 = no limit
            break;
        case OVERLAY_MAGNIFICATION_LIMIT:
            result = 2; // 0 = no limit
            break;
        case OVERLAY_SCALING_FRAC_BITS:
            result = 0; // 0 = infinite
            break;
        case OVERLAY_ROTATION_STEP_DEG:
            result = 90; // 90 rotation steps (for instance)
            break;
        case OVERLAY_HORIZONTAL_ALIGNMENT:
            result = 1; // 1-pixel alignment
            break;
        case OVERLAY_VERTICAL_ALIGNMENT:
            result = 1; // 1-pixel alignment
            break;
        case OVERLAY_WIDTH_ALIGNMENT:
            result = 1; // 1-pixel alignment
            break;
        case OVERLAY_HEIGHT_ALIGNMENT:
            result = 1; // 1-pixel alignment
            break;
    }
    return result;
}

/* return kernel version code by parsing /proc/version,
   return <= 0 if error happens */
int get_kernel_version()
{
	char *verstring, *dummy;
	int fd;
	int major,minor,rev,ver=-1;
	if ((verstring = (char *) malloc(MAX_STR_LEN)) == NULL )
	{
		LOGE("Failed to allocate memory\n");
		return -1;
	}
	if ((dummy = (char *) malloc(MAX_STR_LEN)) == NULL )
	{
		LOGE("Failed to allocate memory\n");
		free (verstring);
		return -1;
	}

	if ((fd = open("/proc/version", O_RDONLY)) < 0)
	{
		LOGE("Failed to open file /proc/version\n");
		goto ret;
	}
	if (read(fd, verstring, MAX_STR_LEN) < 0)
	{
		LOGE("Failed to read kernel version string from /proc/version file\n");
		close(fd);
		goto ret;
	}
	close(fd);
	if (sscanf(verstring, "%s %s %d.%d.%d%s\n", dummy, dummy, &major, &minor, &rev, dummy) != 6)
	{
			LOGE("Failed to read kernel version numbers\n");
	        goto ret;
	}
	ver = KERNEL_VERSION(major, minor, rev);

ret:
	free(verstring);
	free(dummy);

	return ver;
}

int v4l2_overlay_open(int id)
{
    LOG_FUNCTION_NAME

	int ver = get_kernel_version();
	if(ver <= 0)
	{
		LOGE("Failed to parse kernel version\n");
		return -1;
	}

	if (id == V4L2_OVERLAY_PLANE_VIDEO1)
	{
		if(ver >= KERNEL_VERSION(2,6,37))
#if defined(CONFIG_OMAP3530)
			return open("/dev/video7", O_RDWR); //device node is changed in kernel 2.6.37 from video1 to video7 for beagleboard and am37x
#else
			return open("/dev/video1", O_RDWR);
#endif
		else
			return open("/dev/video1",O_RDWR);
	}
	else if (id == V4L2_OVERLAY_PLANE_VIDEO2)
	{
		return open("/dev/video2", O_RDWR);
	}
	return -EINVAL;
}

void dump_pixfmt(struct v4l2_pix_format *pix)
{
    char *fmt;

    switch (pix->pixelformat) {
        case V4L2_PIX_FMT_YUYV: fmt = "YUYV"; break;
        case V4L2_PIX_FMT_UYVY: fmt = "UYVY"; break;
        case V4L2_PIX_FMT_RGB565: fmt = "RGB565"; break;
        case V4L2_PIX_FMT_RGB565X: fmt = "RGB565X"; break;
        default: fmt = "unsupported"; break;
    }
    LOGI("output pixfmt: w %d, h %d, colorsapce %x, pixfmt %s",
            pix->width, pix->height, pix->colorspace, fmt);
}

void v4l2_overlay_dump_state(int fd)
{
    struct v4l2_format format;
    struct v4l2_crop crop;
    int ret;

    LOGI("dumping driver state:");
    format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    ret = ioctl(fd, VIDIOC_G_FMT, &format);
    if (ret < 0)
        return;
    dump_pixfmt(&format.fmt.pix);

    format.type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
    ret = ioctl(fd, VIDIOC_G_FMT, &format);
    if (ret < 0)
        return;
    LOGI("v4l2_overlay window: l %d, t %d, w %d, h %d",
         format.fmt.win.w.left, format.fmt.win.w.top,
         format.fmt.win.w.width, format.fmt.win.w.height);

    crop.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    ret = ioctl(fd, VIDIOC_G_CROP, &crop);
    if (ret < 0)
        return;
    LOGI("output crop: l %d, t %d, w %d, h %d",
         crop.c.left, crop.c.top, crop.c.width, crop.c.height);
}

static void error(int fd, const char *msg)
{
  LOGE("Error = %s from %s", strerror(errno), msg);
#ifdef OVERLAY_DEBUG
  v4l2_overlay_dump_state(fd);
#endif
}

static int v4l2_overlay_ioctl(int fd, int req, void *arg, const char* msg)
{
    int ret;
    ret = ioctl(fd, req, arg);
    if (ret < 0) {
        error(fd, msg);
        return -1;
    }
    return 0;
}

int configure_pixfmt(struct v4l2_pix_format *pix, int32_t fmt,
                     uint32_t w, uint32_t h)
{
    LOG_FUNCTION_NAME

    int fd;

    switch (fmt) {
        case OVERLAY_FORMAT_RGB_565:
            pix->pixelformat = V4L2_PIX_FMT_RGB565;
            break;
        case OVERLAY_FORMAT_YCbYCr_422_I:
            pix->pixelformat = V4L2_PIX_FMT_YUYV;
            break;
        case OVERLAY_FORMAT_CbYCrY_422_I:
            pix->pixelformat = V4L2_PIX_FMT_UYVY;
            break;
        default:
            return -1;
    }
    pix->width = w;
    pix->height = h;
    return 0;
}

static void configure_window(struct v4l2_window *win, int32_t w,
                             int32_t h, int32_t x, int32_t y)
{
    LOG_FUNCTION_NAME

    win->w.left = x;
    win->w.top = y;
    win->w.width = w;
    win->w.height = h;
}

void get_window(struct v4l2_format *format, int32_t *x,
                int32_t *y, int32_t *w, int32_t *h)
{
    LOG_FUNCTION_NAME

    *x = format->fmt.win.w.left;
    *y = format->fmt.win.w.top;
    *w = format->fmt.win.w.width;
    *h = format->fmt.win.w.height;
}

int v4l2_overlay_init(int fd, uint32_t w, uint32_t h, uint32_t fmt)
{
    LOG_FUNCTION_NAME

    struct v4l2_format format;
    int ret;

    /* configure the v4l2_overlay framebuffer */
    /*
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FBUF, &fbuf, "get fbuf");
    if (ret)
        return ret;
    if (fbuf.fmt.pixelformat != dst_format) {
        fbuf.fmt.pixelformat = dst_format;
        ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FBUF, &fbuf, "set fbuf");
        if (ret)
            return ret;
    }
    */

    format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FMT, &format, "get format");
    if (ret)
        return ret;
    LOGI("v4l2_overlay_init:: w=%d h=%d\n", format.fmt.pix.width, format.fmt.pix.height);

    format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    configure_pixfmt(&format.fmt.pix, fmt, w, h);
    LOGI("v4l2_overlay_init:: w=%d h=%d\n", format.fmt.pix.width, format.fmt.pix.height);
    ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FMT, &format, "set output format");

    format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FMT, &format, "get output format");
    LOGI("v4l2_overlay_init:: w=%d h=%d\n", format.fmt.pix.width, format.fmt.pix.height);
    return ret;
}

int v4l2_overlay_get_input_size_and_format(int fd, uint32_t *w, uint32_t *h, uint32_t *fmt)
{
    LOG_FUNCTION_NAME

    struct v4l2_format format;
    int ret;

    format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FMT, &format, "get format");
    *w = format.fmt.pix.width;
    *h = format.fmt.pix.height;
    //if (format.fmt.pix.pixelformat == V4L2_PIX_FMT_UYVY)
    if (format.fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
        *fmt = OVERLAY_FORMAT_CbYCrY_422_I;
    else return -EINVAL;
    return ret;
}

int v4l2_overlay_set_position(int fd, int32_t x, int32_t y, int32_t w, int32_t h)
{
    LOG_FUNCTION_NAME

    struct v4l2_format format;
    int ret;

     /* configure the src format pix */
    /* configure the dst v4l2_overlay window */
    format.type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FMT, &format,
                             "get v4l2_overlay format");
    if (ret)
       return ret;
    LOGI("v4l2_overlay_set_position:: original w=%d h=%d", format.fmt.win.w.width, format.fmt.win.w.height);
   
    configure_window(&format.fmt.win, w, h, x, y);

    format.type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FMT, &format,
                             "set v4l2_overlay format");
    LOGI("v4l2_overlay_set_position:: new w=%d h=%d", format.fmt.win.w.width, format.fmt.win.w.height);
    
    if (ret)
       return ret;
    v4l2_overlay_dump_state(fd);

    return 0;
}

int v4l2_overlay_get_position(int fd, int32_t *x, int32_t *y, int32_t *w, int32_t *h)
{
    struct v4l2_format format;
    int ret;

    format.type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FMT, &format, "get v4l2_overlay format");
    if (ret)
       return ret;
    get_window(&format, x, y, w, h);
    return 0;
}

int v4l2_overlay_set_crop(int fd, uint32_t x, uint32_t y, uint32_t w, uint32_t h)
{
    LOG_FUNCTION_NAME

    struct v4l2_crop crop;
    int ret;

    crop.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_CROP, &crop, "get crop");
    crop.c.left = x;
    crop.c.top = y;
    crop.c.width = w;
    crop.c.height = h;
    crop.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;

    return v4l2_overlay_ioctl(fd, VIDIOC_S_CROP, &crop, "set crop");
}

int v4l2_overlay_get_crop(int fd, uint32_t *x, uint32_t *y, uint32_t *w, uint32_t *h)
{
    LOG_FUNCTION_NAME

    struct v4l2_crop crop;
    int ret;

    crop.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_CROP, &crop, "get crop");
    *x = crop.c.left;
    *y = crop.c.top;
    *w = crop.c.width;
    *h = crop.c.height;
    return ret;
}

int v4l2_overlay_set_rotation(int fd, int degree, int step)
{
    LOG_FUNCTION_NAME

    int ret;
    struct v4l2_control ctrl;

    ctrl.id = V4L2_CID_ROTATE;
    ctrl.value = degree;
    ret = v4l2_overlay_ioctl(fd, VIDIOC_S_CTRL, &ctrl, "set rotation");

    return ret;
}

int v4l2_overlay_set_colorkey(int fd, int enable, int colorkey)
{
    LOG_FUNCTION_NAME

    int ret;
    struct v4l2_framebuffer fbuf;
    struct v4l2_format fmt;

    memset(&fbuf, 0, sizeof(fbuf));
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FBUF, &fbuf, "get transparency enables");

    if (ret)
        return ret;

    if (enable)
        fbuf.flags |= V4L2_FBUF_FLAG_CHROMAKEY;
    else
        fbuf.flags &= ~V4L2_FBUF_FLAG_CHROMAKEY;

    ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FBUF, &fbuf, "enable colorkey");

    if (ret)
        return ret;

    if (enable)

    {
        memset(&fmt, 0, sizeof(fmt));
        fmt.type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
        ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FMT, &fmt, "get colorkey");

        if (ret)
            return ret;

        fmt.fmt.win.chromakey = colorkey & 0xFFFFFF;

        ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FMT, &fmt, "set colorkey");
    }

    return ret;
}

int v4l2_overlay_set_global_alpha(int fd, int enable, int alpha)
{
    LOG_FUNCTION_NAME

    int ret;
    struct v4l2_framebuffer fbuf;
    struct v4l2_format fmt;

    memset(&fbuf, 0, sizeof(fbuf));
    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FBUF, &fbuf, "get transparency enables");

    if (ret)
        return ret;

    if (enable)
        fbuf.flags |= V4L2_FBUF_FLAG_GLOBAL_ALPHA;
    else
        fbuf.flags &= ~V4L2_FBUF_FLAG_GLOBAL_ALPHA;

    ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FBUF, &fbuf, "enable global alpha");

    if (ret)
        return ret;

    if (enable)
    {
        memset(&fmt, 0, sizeof(fmt));
        fmt.type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
        ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FMT, &fmt, "get global alpha");

        if (ret)
            return ret;

        fmt.fmt.win.global_alpha = alpha & 0xFF;

        ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FMT, &fmt, "set global alpha");
    }

    return ret;
}

int v4l2_overlay_set_local_alpha(int fd, int enable)
{
    int ret;
    struct v4l2_framebuffer fbuf;

    ret = v4l2_overlay_ioctl(fd, VIDIOC_G_FBUF, &fbuf,
                             "get transparency enables");

    if (ret)
        return ret;

    if (enable)
        fbuf.flags |= V4L2_FBUF_FLAG_LOCAL_ALPHA;
    else
        fbuf.flags &= ~V4L2_FBUF_FLAG_LOCAL_ALPHA;

    ret = v4l2_overlay_ioctl(fd, VIDIOC_S_FBUF, &fbuf, "enable local alpha");

    return ret;
}

#ifdef OVERLAY_SUPPORT_USERPTR_BUF
int v4l2_overlay_req_buf(int fd, uint32_t *num_bufs, int cacheable_buffers, int memtype)
#else
int v4l2_overlay_req_buf(int fd, uint32_t *num_bufs, int cacheable_buffers)
#endif
{
    LOG_FUNCTION_NAME

    struct v4l2_requestbuffers reqbuf;
    int ret, i;
    reqbuf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
#ifdef OVERLAY_SUPPORT_USERPTR_BUF
    reqbuf.memory = (memtype == EMEMORY_USERPTR) ? V4L2_MEMORY_USERPTR : V4L2_MEMORY_MMAP;
#else
    reqbuf.memory = V4L2_MEMORY_MMAP;
#endif
    reqbuf.count = *num_bufs;
    //reqbuf.reserved[0] = cacheable_buffers;
    ret = ioctl(fd, VIDIOC_REQBUFS, &reqbuf);
    if (ret < 0) {
        error(fd, "reqbuf ioctl");
        return ret;
    }
    LOGI("%d buffers allocated %d requested\n", reqbuf.count, *num_bufs);
    if (reqbuf.count > *num_bufs) {
        error(fd, "Not enough buffer allcated");
        return -ENOMEM;
    }
    *num_bufs = reqbuf.count;
    LOGI("buffer cookie is %d\n", reqbuf.type);
    return 0;
}

static int is_mmaped(struct v4l2_buffer *buf)
{
    return buf->flags == V4L2_BUF_FLAG_MAPPED;
}

int v4l2_overlay_query_buffer(int fd, int index, struct v4l2_buffer *buf)
{
    LOG_FUNCTION_NAME

    memset(buf, 0, sizeof(struct v4l2_buffer));

    buf->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    buf->memory = V4L2_MEMORY_MMAP;
    buf->index = index;
    LOGI("query buffer, mem=%u type=%u index=%u\n", buf->memory, buf->type,
         buf->index);
    return v4l2_overlay_ioctl(fd, VIDIOC_QUERYBUF, buf, "querybuf ioctl");
}

int v4l2_overlay_map_buf(int fd, int index, void **start, size_t *len)
{
    LOG_FUNCTION_NAME

    struct v4l2_buffer buf;
    int ret;

    ret = v4l2_overlay_query_buffer(fd, index, &buf);
    if (ret)
        return ret;

    if (is_mmaped(&buf)) {
        LOGE("Trying to mmap buffers that are already mapped!\n");
        return -EINVAL;
    }

    *len = buf.length;
    *start = mmap(NULL, buf.length, PROT_READ | PROT_WRITE, MAP_SHARED,
                  fd, buf.m.offset);
    if (*start == MAP_FAILED) {
        LOGE("map failed, length=%u offset=%u\n", buf.length, buf.m.offset);
        return -EINVAL;
    }
    return 0;
}

int v4l2_overlay_unmap_buf(void *start, size_t len)
{
    LOG_FUNCTION_NAME

  return munmap(start, len);
}


int v4l2_overlay_get_caps(int fd, struct v4l2_capability *caps)
{
    return v4l2_overlay_ioctl(fd, VIDIOC_QUERYCAP, caps, "query cap");
}

int v4l2_overlay_stream_on(int fd)
{
    LOG_FUNCTION_NAME

    uint32_t type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    return v4l2_overlay_ioctl(fd, VIDIOC_STREAMON, &type, "stream on");
}

int v4l2_overlay_stream_off(int fd)
{
    LOG_FUNCTION_NAME

    uint32_t type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    return v4l2_overlay_ioctl(fd, VIDIOC_STREAMOFF, &type, "stream off");
}

#ifdef OVERLAY_SUPPORT_USERPTR_BUF
int v4l2_overlay_q_buf_uptr(int fd, void *ptr, size_t len)
{
    /* FIXME index - not idea to track qbuf index */
    static int index = 0;
    struct v4l2_buffer buf;
    int ret;

    buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    buf.m.userptr = (unsigned long)ptr;
    buf.index = index++;
    buf.length = len;
    buf.memory = V4L2_MEMORY_USERPTR;
    buf.field = V4L2_FIELD_NONE;
    buf.timestamp.tv_sec = 0;
    buf.timestamp.tv_usec = 0;
    buf.flags = 0;
    index %= NUM_OVERLAY_BUFFERS_REQUESTED;

    return v4l2_overlay_ioctl(fd, VIDIOC_QBUF, &buf, "qbuf");
}
#endif

int v4l2_overlay_q_buf(int fd, int index)
{
    struct v4l2_buffer buf;
    int ret;

    buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
    buf.index = index;
    buf.memory = V4L2_MEMORY_MMAP;
    buf.field = V4L2_FIELD_NONE;
    buf.timestamp.tv_sec = 0;
    buf.timestamp.tv_usec = 0;
    buf.flags = 0;

    return v4l2_overlay_ioctl(fd, VIDIOC_QBUF, &buf, "qbuf");
}

#ifdef OVERLAY_SUPPORT_USERPTR_BUF
int v4l2_overlay_dq_buf(int fd, int *index, int memtype)
#else
int v4l2_overlay_dq_buf(int fd, int *index)
#endif
{
    struct v4l2_buffer buf;
    int ret;

    buf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
#ifdef OVERLAY_SUPPORT_USERPTR_BUF
    buf.memory = (memtype == EMEMORY_USERPTR) ?
                 V4L2_MEMORY_USERPTR : V4L2_MEMORY_MMAP;
#else
    buf.memory = V4L2_MEMORY_MMAP;
#endif

    ret = v4l2_overlay_ioctl(fd, VIDIOC_DQBUF, &buf, "dqbuf");
    if (ret)
        return errno;
#ifdef OVERLAY_SUPPORT_USERPTR_BUF
    *index = (memtype == EMEMORY_USERPTR) ? (int)buf.m.userptr : buf.index;
#else
    *index = buf.index;
#endif
    return 0;
}
