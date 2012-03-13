#!/bin/sh

# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

DEVICE=griffin
MANUFACTURER=lepan

if [ $1 ]; then
    ZIPFILE=$1
else
    ZIPFILE=../../../${DEVICE}_update.zip
fi

if [ ! -f "$1" ]; then
    echo "Cannot find $ZIPFILE.  Try specifify the stock update.zip with $0 <zipfilename>"
    exit 1
fi
rm -rf ../../../vendor/$MANUFACTURER/$DEVICE
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/prebuilt

# DSP related libs and firmware
unzip -j -o $ZIPFILE system/lib/dsp/g729enc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/g722dec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/wbamrenc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/mp3dec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/baseimage.map -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/g726enc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/qosdyn_3430.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/nbamrdec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/postprocessor_dualout.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/wbamrdec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/conversions.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/ddspbase_tiomap3430.dof64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/monitor_tiomap3430.dof64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/yuvconvert.l64p -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/wmadec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/dctn_dyn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/jpegenc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/g722enc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/vpp_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/wmv9dec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/dfgm.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/g729dec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/g711enc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/h264venc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/jpegdec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/mp4vdec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/ipp_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/mpeg4aacenc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/nbamrenc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/star.l64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/dynbase_tiomap3430.dof64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/g726dec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/mpeg4aacdec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/eenf_ti.l64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/baseimage.dof -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/ringio.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/usn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/ilbcenc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/m4venc_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/chromasuppress.l64p -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/h264vdec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/ilbcdec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/dsp/g711dec_sn.dll64P -d ../../../vendor/lepan/griffin/proprietary
# DSP Codecs
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G722.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G729.encode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.AMR.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libLCML.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libbridge.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.MP3.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.JPEG.encoder.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.WBAMR.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G722.encode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.Video.Decoder.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.AAC.encode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.720P.Decoder.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libPERF.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.ILBC.encode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.AAC.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G726.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.VPP.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.JPEG.decoder.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.Video.encoder.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX_Core.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G711.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.WBAMR.encode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libomap_mm_library_jni.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G729.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.WMA.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.ILBC.decode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G726.encode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.G711.encode.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOMX.TI.AMR.encode.so -d ../../../vendor/lepan/griffin/proprietary

# SGX SDK
unzip -j -o $ZIPFILE system/lib/libIMGegl.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/bin/pvrsrvinit -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libsrv_um.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/hw/gralloc.omap3.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libusc.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libglslcompiler.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libpvrANDROID_WSEGL.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOpenVG.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libpvr2d.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libsrv_init.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/libOpenVGU.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/egl/libEGL_POWERVR_SGX530_125.so -d ../../../vendor/lepan/griffin/proprietary
unzip -j -o $ZIPFILE system/lib/egl/libGLESv2_POWERVR_SGX530_125.so -d ../../../vendor/lepan/griffin/proprietary

# audio legacy

unzip -j -o $ZIPFILE system/lib/libaudiopolicy.so -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/lib/libaudio.so -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/lib/libasound.so -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/lib/liba2dp.so -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/lib/hw/alsa.griffin.so -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/init/hda -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/init/00main -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/init/help -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/init/default -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/init/info -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/init/test -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/surround51.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/surround41.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/default.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/dmix.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/modem.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/side.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/front.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/iec958.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/surround50.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/surround40.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/surround71.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/dpl.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/dsnoop.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/rear.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/pcm/center_lfe.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/cards/aliases.conf -d ../../../vendor/lepan/griffin/prebuilt/
unzip -j -o $ZIPFILE system/usr/share/alsa/alsa.conf -d ../../../vendor/lepan/griffin/prebuilt/

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__MANUFACTURER__/$MANUFACTURER/g > ../../../vendor/$MANUFACTURER/$DEVICE/device-vendor-blobs.mk
# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/__MANUFACTURER__/__DEVICE__/extract-files.sh - DO NOT EDIT

PRODUCT_COPY_FILES += \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G722.decode.so:/system/lib/libOMX.TI.G722.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G729.encode.so:/system/lib/libOMX.TI.G729.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.AMR.decode.so:/system/lib/libOMX.TI.AMR.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libLCML.so:/system/lib/libLCML.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libbridge.so:/system/lib/libbridge.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.MP3.decode.so:/system/lib/libOMX.TI.MP3.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.JPEG.encoder.so:/system/lib/libOMX.TI.JPEG.encoder.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.WBAMR.decode.so:/system/lib/libOMX.TI.WBAMR.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G722.encode.so:/system/lib/libOMX.TI.G722.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.Video.Decoder.so:/system/lib/libOMX.TI.Video.Decoder.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.AAC.encode.so:/system/lib/libOMX.TI.AAC.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.720P.Decoder.so:/system/lib/libOMX.TI.720P.Decoder.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libPERF.so:/system/lib/libPERF.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.ILBC.encode.so:/system/lib/libOMX.TI.ILBC.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.AAC.decode.so:/system/lib/libOMX.TI.AAC.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G726.decode.so:/system/lib/libOMX.TI.G726.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.VPP.so:/system/lib/libOMX.TI.VPP.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.JPEG.decoder.so:/system/lib/libOMX.TI.JPEG.decoder.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.Video.encoder.so:/system/lib/libOMX.TI.Video.encoder.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX_Core.so:/system/lib/libOMX_Core.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G711.decode.so:/system/lib/libOMX.TI.G711.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.WBAMR.encode.so:/system/lib/libOMX.TI.WBAMR.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libomap_mm_library_jni.so:/system/lib/libomap_mm_library_jni.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G729.decode.so:/system/lib/libOMX.TI.G729.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.WMA.decode.so:/system/lib/libOMX.TI.WMA.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.ILBC.decode.so:/system/lib/libOMX.TI.ILBC.decode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G726.encode.so:/system/lib/libOMX.TI.G726.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.G711.encode.so:/system/lib/libOMX.TI.G711.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOMX.TI.AMR.encode.so:/system/lib/libOMX.TI.AMR.encode.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libIMGegl.so:/system/lib/libIMGegl.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g729enc_sn.dll64P:/system/lib/dsp/g729enc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g722dec_sn.dll64P:/system/lib/dsp/g722dec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/wbamrenc_sn.dll64P:/system/lib/dsp/wbamrenc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/mp3dec_sn.dll64P:/system/lib/dsp/mp3dec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/baseimage.map:/system/lib/dsp/baseimage.map \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g726enc_sn.dll64P:/system/lib/dsp/g726enc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/qosdyn_3430.dll64P:/system/lib/dsp/qosdyn_3430.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/nbamrdec_sn.dll64P:/system/lib/dsp/nbamrdec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/postprocessor_dualout.dll64P:/system/lib/dsp/postprocessor_dualout.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/wbamrdec_sn.dll64P:/system/lib/dsp/wbamrdec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/conversions.dll64P:/system/lib/dsp/conversions.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/ddspbase_tiomap3430.dof64P:/system/lib/dsp/ddspbase_tiomap3430.dof64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/monitor_tiomap3430.dof64P:/system/lib/dsp/monitor_tiomap3430.dof64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/yuvconvert.l64p:/system/lib/dsp/yuvconvert.l64p \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/wmadec_sn.dll64P:/system/lib/dsp/wmadec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/dctn_dyn.dll64P:/system/lib/dsp/dctn_dyn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/jpegenc_sn.dll64P:/system/lib/dsp/jpegenc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g722enc_sn.dll64P:/system/lib/dsp/g722enc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/vpp_sn.dll64P:/system/lib/dsp/vpp_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/wmv9dec_sn.dll64P:/system/lib/dsp/wmv9dec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/dfgm.dll64P:/system/lib/dsp/dfgm.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g729dec_sn.dll64P:/system/lib/dsp/g729dec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g711enc_sn.dll64P:/system/lib/dsp/g711enc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/h264venc_sn.dll64P:/system/lib/dsp/h264venc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/jpegdec_sn.dll64P:/system/lib/dsp/jpegdec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/mp4vdec_sn.dll64P:/system/lib/dsp/mp4vdec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/ipp_sn.dll64P:/system/lib/dsp/ipp_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/mpeg4aacenc_sn.dll64P:/system/lib/dsp/mpeg4aacenc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/nbamrenc_sn.dll64P:/system/lib/dsp/nbamrenc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/star.l64P:/system/lib/dsp/star.l64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/dynbase_tiomap3430.dof64P:/system/lib/dsp/dynbase_tiomap3430.dof64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g726dec_sn.dll64P:/system/lib/dsp/g726dec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/mpeg4aacdec_sn.dll64P:/system/lib/dsp/mpeg4aacdec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/eenf_ti.l64P:/system/lib/dsp/eenf_ti.l64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/baseimage.dof:/system/lib/dsp/baseimage.dof \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/ringio.dll64P:/system/lib/dsp/ringio.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/usn.dll64P:/system/lib/dsp/usn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/ilbcenc_sn.dll64P:/system/lib/dsp/ilbcenc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/m4venc_sn.dll64P:/system/lib/dsp/m4venc_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/chromasuppress.l64p:/system/lib/dsp/chromasuppress.l64p \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/h264vdec_sn.dll64P:/system/lib/dsp/h264vdec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/ilbcdec_sn.dll64P:/system/lib/dsp/ilbcdec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/g711dec_sn.dll64P:/system/lib/dsp/g711dec_sn.dll64P \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/pvrsrvinit:/system/bin/pvrsrvinit \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOpenVGU.so:/system/lib/libOpenVGU.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libEGL_POWERVR_SGX530_125.so:/system/lib/egl/libEGL_POWERVR_SGX530_125.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libGLESv2_POWERVR_SGX530_125.so:/system/lib/egl/libGLESv2_POWERVR_SGX530_125.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libGLESv1_CM_POWERVR_SGX530_125.so:/system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libsrv_um.so:/system/lib/libsrv_um.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libIMGegl.so:/system/lib/libIMGegl.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/gralloc.omap3.so:/system/lib/hw/gralloc.omap3.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libusc.so:/system/lib/libusc.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libglslcompiler.so:/system/lib/libglslcompiler.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libpvrANDROID_WSEGL.so:/system/lib/libpvrANDROID_WSEGL.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libOpenVG.so:/system/lib/libOpenVG.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libpvr2d.so:/system/lib/libpvr2d.so \\
    vendor/__MANUFACTURER__/__DEVICE__/proprietary/libsrv_init.so:/system/lib/libsrv_init.so \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/libaudio.so:/system/lib/libaudio.so \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/libaudiopolicy.so:/system/lib/libaudiopolicy.so \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/alsa.griffin.so:/system/lib/hw/alsa.griffin.so \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/libaudio.so:/system/lib/libaudio.so \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/liba2dp.so:/system/lib/liba2dp.so \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/libasound.so:/system/lib/libasound.so \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/hda:/system/usr/share/alsa/init/hda \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/00main:/system/usr/share/alsa/init/00main \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/help:/system/usr/share/alsa/init/help \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/default:/system/usr/share/alsa/init/default \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/info:/system/usr/share/alsa/init/info \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/test:/system/usr/share/alsa/init/test \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/surround51.conf:/system/usr/share/alsa/pcm/surround51.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/surround41.conf:/system/usr/share/alsa/pcm/surround41.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/default.conf:/system/usr/share/alsa/pcm/default.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/dmix.conf:/system/usr/share/alsa/pcm/dmix.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/modem.conf:/system/usr/share/alsa/pcm/modem.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/side.conf:/system/usr/share/alsa/pcm/side.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/front.conf:/system/usr/share/alsa/pcm/front.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/iec958.conf:/system/usr/share/alsa/pcm/iec958.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/surround50.conf:/system/usr/share/alsa/pcm/surround50.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/surround40.conf:/system/usr/share/alsa/pcm/surround40.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/surround71.conf:/system/usr/share/alsa/pcm/surround71.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/dpl.conf:/system/usr/share/alsa/pcm/dpl.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/dsnoop.conf:/system/usr/share/alsa/pcm/dsnoop.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/rear.conf:/system/usr/share/alsa/pcm/rear.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/center_lfe.conf:/system/usr/share/alsa/pcm/center_lfe.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/aliases.conf:/system/usr/share/alsa/cards/aliases.conf \\
    vendor/__MANUFACTURER__/__DEVICE__/prebuilt/alsa.conf:/system/usr/share/alsa/alsa.conf \\

EOF


./setup-makefiles.sh

