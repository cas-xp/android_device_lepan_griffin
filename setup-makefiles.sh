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

VENDOR=lepan
DEVICE=griffin

mkdir -p ../../../vendor/$VENDOR/$DEVICE

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/$VENDOR/$DEVICE/$DEVICE-vendor.mk
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

# This file is generated by device/__VENDOR__/__DEVICE__/setup-makefiles.sh

# Live wallpaper packages
PRODUCT_PACKAGES := \\
    LiveWallpapers \\
    LiveWallpapersPicker \\
    MagicSmokeWallpapers \\
    VisualizationWallpapers \\
    librs_jni

# Publish that we support the live wallpaper feature.
PRODUCT_COPY_FILES := \\
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml

\$(call inherit-product, vendor/__VENDOR__/__DEVICE__/__DEVICE__-vendor-blobs.mk)
EOF

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/$VENDOR/$DEVICE/$DEVICE-vendor-blobs.mk
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

# This file is generated by device/__VENDOR__/__DEVICE__/setup-makefiles.sh

# HAL
PRODUCT_COPY_FILES += \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/hw/gralloc.omap3.so:/system/lib/hw/gralloc.omap3.so 

# PVRSGX
PRODUCT_COPY_FILES += \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/egl/libEGL_POWERVR_SGX530_125.so:system/lib/egl/libEGL_POWERVR_SGX530_125.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so:system/lib/egl/libGLESv1_CM_POWERVR_SGX530_125.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/egl/libGLESv2_POWERVR_SGX530_125.so:system/lib/egl/libGLESv2_POWERVR_SGX530_125.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libsrv_um.so:system/lib/libsrv_um.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libsrv_init.so:system/lib/libsrv_init.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libpvr2d.so:system/lib/libpvr2d.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libpvrANDROID_WSEGL.so:system/lib/libpvrANDROID_WSEGL.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libIMGegl.so:system/lib/libIMGegl.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libglslcompiler.so:system/lib/libglslcompiler.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libusc.so:system/lib/libusc.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOpenVG.so:system/lib/libOpenVG.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOpenVGU.so:system/lib/libOpenVGU.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/bin/pvrsrvinit:system/bin/pvrsrvinit


## DSP
PRODUCT_COPY_FILES += \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/720p_h264vdec_sn.dll64P:system/lib/dsp/720p_h264vdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/720p_h264venc_sn.dll64P:system/lib/dsp/720p_h264venc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/720p_mp4vdec_sn.dll64P:system/lib/dsp/720p_mp4vdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/720p_mp4venc_sn.dll64P:system/lib/dsp/720p_mp4venc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/baseimage.dof:system/lib/dsp/baseimage.dof \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/baseimage.map:system/lib/dsp/baseimage.map \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/chromasuppress.l64p:system/lib/dsp/chromasuppress.l64p \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/conversions.dll64P:system/lib/dsp/conversions.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/dctn_dyn.dll64P:system/lib/dsp/dctn_dyn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/ddspbase_tiomap3430.dof64P:system/lib/dsp/ddspbase_tiomap3430.dof64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/dfgm.dll64P:system/lib/dsp/dfgm.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/dynbase_tiomap3430.dof64P:system/lib/dsp/dynbase_tiomap3430.dof64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/eenf_ti.l64P:system/lib/dsp/eenf_ti.l64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g711dec_sn.dll64P:system/lib/dsp/g711dec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g711enc_sn.dll64P:system/lib/dsp/g711enc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g722dec_sn.dll64P:system/lib/dsp/g722dec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g722enc_sn.dll64P:system/lib/dsp/g722enc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g726dec_sn.dll64P:system/lib/dsp/g726dec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g726enc_sn.dll64P:system/lib/dsp/g726enc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g729dec_sn.dll64P:system/lib/dsp/g729dec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/g729enc_sn.dll64P:system/lib/dsp/g729enc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/h264vdec_sn.dll64P:system/lib/dsp/h264vdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/h264venc_sn.dll64P:system/lib/dsp/h264venc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/ilbcdec_sn.dll64P:system/lib/dsp/ilbcdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/ilbcenc_sn.dll64P:system/lib/dsp/ilbcenc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/ipp_sn.dll64P:system/lib/dsp/ipp_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/jpegdec_sn.dll64P:system/lib/dsp/jpegdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/jpegenc_sn.dll64P:system/lib/dsp/jpegenc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/m4venc_sn.dll64P:system/lib/dsp/m4venc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/monitor_tiomap3430.dof64P:system/lib/dsp/monitor_tiomap3430.dof64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/mp3dec_sn.dll64P:system/lib/dsp/mp3dec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/mp4vdec_sn.dll64P:system/lib/dsp/mp4vdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/mpeg4aacdec_sn.dll64P:system/lib/dsp/mpeg4aacdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/mpeg4aacenc_sn.dll64P:system/lib/dsp/mpeg4aacenc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/nbamrdec_sn.dll64P:system/lib/dsp/nbamrdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/nbamrenc_sn.dll64P:system/lib/dsp/nbamrenc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/postprocessor_dualout.dll64P:system/lib/dsp/postprocessor_dualout.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/qosdyn_3430.dll64P:system/lib/dsp/qosdyn_3430.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/ringio.dll64P:system/lib/dsp/ringio.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/star.l64P:system/lib/dsp/star.l64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/usn.dll64P:system/lib/dsp/usn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/vpp_sn.dll64P:system/lib/dsp/vpp_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/wbamrdec_sn.dll64P:system/lib/dsp/wbamrdec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/wbamrenc_sn.dll64P:system/lib/dsp/wbamrenc_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/wmadec_sn.dll64P:system/lib/dsp/wmadec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/wmv9dec_sn.dll64P:system/lib/dsp/wmv9dec_sn.dll64P \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/dsp/yuvconvert.l64p:system/lib/dsp/yuvconvert.l64p \\
    vendor/__VENDOR__/__DEVICE__/proprietary/bin/cexec.out:system/bin/cexec.out 


## OMX 720p libraries
PRODUCT_COPY_FILES += \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOMX.TI.mp4.splt.Encoder.so:system/lib/libOMX.TI.mp4.splt.Encoder.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOMX.TI.720P.Encoder.so:system/lib/libOMX.TI.720P.Encoder.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOMX.TI.720P.Decoder.so:system/lib/libOMX.TI.720P.Decoder.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOMX.ITTIAM.AAC.encode.so:system/lib/libOMX.ITTIAM.AAC.encode.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOMX.ITTIAM.AAC.decode.so:system/lib/libOMX.ITTIAM.AAC.decode.so \\
    vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOMX.TI.h264.splt.Encoder.so:system/lib/libOMX.TI.h264.splt.Encoder.so

EOF

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/$VENDOR/$DEVICE/BoardConfigVendor.mk
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

# This file is generated by device/__VENDOR__/__DEVICE__/setup-makefiles.sh

EOF

