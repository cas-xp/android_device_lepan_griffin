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

MANUFACTURER=lepan
DEVICE=griffin

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
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/bin
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/etc/firmware
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/etc/wifi
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/etc/wifi/softap
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/etc/cert
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/egl
mkdir -p ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/hw

# DSP Firmware
unzip -j -o $ZIPFILE system/lib/dsp/720p_h264vdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/720p_h264venc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/720p_mp4vdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/720p_mp4venc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/baseimage.dof -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/baseimage.map -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/chromasuppress.l64p -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/conversions.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/dctn_dyn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/ddspbase_tiomap3430.dof64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/dfgm.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/dynbase_tiomap3430.dof64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/eenf_ti.l64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g711dec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g711enc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g722dec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g722enc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g726dec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g726enc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g729dec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/g729enc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/h264vdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/h264venc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/ilbcdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/ilbcenc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/ipp_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/jpegdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/jpegenc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/m4venc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/monitor_tiomap3430.dof64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/mp3dec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/mp4vdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/mpeg4aacdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/mpeg4aacenc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/nbamrdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/nbamrenc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/postprocessor_dualout.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/qosdyn_3430.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/ringio.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/star.l64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/usn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/vpp_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/wbamrdec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/wbamrenc_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/wmadec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/wmv9dec_sn.dll64P -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
unzip -j -o $ZIPFILE system/lib/dsp/yuvconvert.l64p -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/dsp/
# HAL
unzip -j -o $ZIPFILE system/lib/hw/gralloc.omap3.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/hw

## PVRSGX
unzip -j -o $ZIPFILE system/lib/egl/libEGL_POWERVR_SGX530_125.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/egl
unzip -j -o $ZIPFILE system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/egl
unzip -j -o $ZIPFILE system/lib/egl/libGLESv2_POWERVR_SGX530_125.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/egl
unzip -j -o $ZIPFILE system/lib/libsrv_um.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libsrv_init.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libpvr2d.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libpvrANDROID_WSEGL.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libIMGegl.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libglslcompiler.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libusc.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/bin/pvrsrvinit -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/bin/
unzip -j -o $ZIPFILE system/lib/libOpenVG.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib
unzip -j -o $ZIPFILE system/lib/libOpenVGU.so -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib




## OMX 720p libraries
unzip -j -o $ZIPFILE system/lib/libOMX.TI.mp4.splt.Encoder.so  -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libOMX.TI.720P.Encoder.so  -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libOMX.TI.720P.Decoder.so  -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libOMX.ITTIAM.AAC.encode.so  -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libOMX.ITTIAM.AAC.decode.so  -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/
unzip -j -o $ZIPFILE system/lib/libOMX.TI.h264.splt.Encoder.so  -d ../../../vendor/$MANUFACTURER/$DEVICE/proprietary/lib/

echo "NOTE: Unless all transfers failed, errors above should be safe to ignore. Proceed with your build"
exit
