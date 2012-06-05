#
# Copyright (C) 2009 The Android Open Source Project
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
#

# include cicada's sensors library
common_ti_dirs := libsensors

include $(call all-named-subdir-makefiles, $(common_ti_dirs))

$(call inherit-product, build/target/product/full_base.mk)

# Place libcamera.so in obj folder for link and system/lib folder 
# 
# 
PRODUCT_COPY_FILES += \
    device/lepan/griffin/prebuilt/libcamera.so:obj/lib/libcamera.so \
    device/lepan/griffin/prebuilt/libcamera.so:/system/lib/libcamera.so

# Get a proper init file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.griffin.rc:root/init.rc \
    $(LOCAL_PATH)/ueventd.griffin.rc:root/ueventd.griffin.rc

# Place wifi files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/wifi/tiwlan_drv.ko:/system/lib/modules/tiwlan_drv.ko \
    $(LOCAL_PATH)/prebuilt/wifi/tiwlan.ini:/system/etc/wifi/tiwlan.ini \
    $(LOCAL_PATH)/prebuilt/wifi/nvs_map.bin:/system/etc/wifi/nvs_map.bin \
    $(LOCAL_PATH)/prebuilt/wifi/wifi_calibration.txt:/system/etc/wifi/wifi_calibration.txt \
    $(LOCAL_PATH)/prebuilt/wifi/firmware.bin:/system/etc/wifi/firmware.bin

# Place bluetooth firmware
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/firmware/TIInit_7.2.31.bts:/system/etc/firmware/TIInit_7.2.31.bts \
    $(LOCAL_PATH)/firmware/TIInit_7.6.15.bts:/system/etc/firmware/TIInit_7.6.15.bts \
    $(LOCAL_PATH)/firmware/fm_rx_init_1273.2.bts:/system/etc/firmware/fm_rx_init_1273.2.bts \
    $(LOCAL_PATH)/firmware/fm_tx_init_1273.2.bts:/system/etc/firmware/fm_tx_init_1273.2.bts \
    $(LOCAL_PATH)/firmware/fmc_init_1273.2.bts:/system/etc/firmware/fmc_init_1273.2.bts \
    $(LOCAL_PATH)/prebuilt/bluetooth/bt_drv.ko:/system/etc/bluetooth/drivers/bt_drv.ko \
    $(LOCAL_PATH)/prebuilt/bluetooth/st_drv.ko:/system/etc/bluetooth/drivers/st_drv.ko \
    $(LOCAL_PATH)/prebuilt/bluetooth/fm_drv.ko:/system/etc/bluetooth/drivers/fm_drv.ko 

# Place prebuilt from misc
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/asound.conf:/system/etc/asound.conf \
    $(LOCAL_PATH)/prebuilt/egl.cfg:/system/lib/egl/egl.cfg \
    $(LOCAL_PATH)/prebuilt/geomagneticd:/system/bin/geomagneticd \
    $(LOCAL_PATH)/prebuilt/orientationd:/system/bin/orientationd \
    $(LOCAL_PATH)/prebuilt/uim:/system/xbin/uim 

# Place prebuilt from gps library in libhardware_legacy.so ==> libhardware_legaci.so 
# To avoid name conflict
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/libhardware_legaci.so:/system/lib/libhardware_legaci.so 

#    $(LOCAL_PATH)/prebuilt/libstagefrighthw.so:/system/lib/libstagefrighthw.so \
#    $(LOCAL_PATH)/prebuilt/GFX/system/lib/hw/overlay.omap3.so:/system/lib/hw/overlay.omap3.so \

# Place charger image and execute binary
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/charger/images/charge_1.png:/system/usr/charger/images/charge_1.png \
    $(LOCAL_PATH)/prebuilt/charger/images/charge_2.png:/system/usr/charger/images/charge_2.png \
    $(LOCAL_PATH)/prebuilt/charger/images/charge_3.png:/system/usr/charger/images/charge_3.png \
    $(LOCAL_PATH)/prebuilt/charger/images/charge_4.png:/system/usr/charger/images/charge_4.png \
    $(LOCAL_PATH)/prebuilt/charger/images/charge_full.png:/system/usr/charger/images/charge_full.png \
    $(LOCAL_PATH)/prebuilt/charger/images/charge_prepare.png:/system/usr/charger/images/charge_prepare.png \
    $(LOCAL_PATH)/prebuilt/charger/charger_man:/system/bin/charger_man 


# Place permission files
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

$(call inherit-product-if-exists, vendor/lepan/griffin/griffin-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_PACKAGES += \
    librs_jni \
    libskiahw \
    alsa.griffin \
    overlay.griffin \
    gps.griffin \
    libbridge \
    libOMX_Core \
    libLCML \
    libOMX.TI.Video.Decoder \
    libOMX.TI.Video.encoder \
    libOMX.TI.WBAMR.decode \
    libOMX.TI.AAC.encode \
    libOMX.TI.G722.decode \
    libOMX.TI.MP3.decode \
    libOMX.TI.WMA.decode \
    libOMX.TI.Video.encoder \
    libOMX.TI.WBAMR.encode \
    libOMX.TI.G729.encode \
    libOMX.TI.AAC.decode \
    libOMX.TI.VPP \
    libOMX.TI.G711.encode \
    libOMX.TI.JPEG.encoder \
    libOMX.TI.G711.decode \
    libOMX.TI.ILBC.decode \
    libOMX.TI.ILBC.encode \
    libOMX.TI.AMR.encode \
    libOMX.TI.G722.encode \
    libOMX.TI.JPEG.decoder \
    libOMX.TI.G726.encode \
    libOMX.TI.G729.decode \
    libOMX.TI.Video.Decoder \
    libOMX.TI.AMR.decode \
    libOMX.TI.G726.decode \
    wlan_cu \
    libtiOsLib \
    wlan_loader \
    libCustomWifi \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libVendor_ti_omx \
    sensors.griffin \
    lights.griffin \
    alsa.default \
    alsa.omap3 \
    overlay.omap3 \
    acoustics.default \
    libomap_mm_library_jni 
#    hwprops #no need for lepan because the serial no is exposed by uboot

# OpenMAX IL configuration
TI_OMX_POLICY_MANAGER := hardware/ti/omx/system/src/openmax_il/omx_policy_manager

PRODUCT_PACKAGES += \
    libreference-ril

# Use medium-density artwork where available
PRODUCT_LOCALES += mdpi

# Vold
PRODUCT_COPY_FILES += \
    $(TI_OMX_POLICY_MANAGER)/src/policytable.tbl:system/etc/policytable.tbl \
    $(LOCAL_PATH)/etc/vold.griffin.fstab:system/etc/vold.fstab

# Media Profile // disable temporiablly so far
PRODUCT_COPY_FILES += \
   $(LOCAL_PATH)/etc/media_profiles.xml:system/etc/media_profiles.xml

# SD ramdisk packer script - by request - execute manually as-needed

#PRODUCT_COPY_FILES += \
#        $(LOCAL_PATH)/sd_ramdisk_packer.sh:sd_ramdisk_packer.sh

ifeq ($(TARGET_PREBUILT_KERNEL),)
    LOCAL_KERNEL := $(LOCAL_PATH)/prebuilt/boot/kernel32
else
    LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

ifeq ($(TARGET_PREBUILT_BOOTLOADER),)
    LOCAL_BOOTLOADER := $(LOCAL_PATH)/prebuilt/boot/MLO
else
    LOCAL_BOOTLOADER := $(TARGET_PREBUILT_BOOTLOADER)
endif

ifeq ($(TARGET_PREBUILT_2NDBOOTLOADER),)
    LOCAL_2NDBOOTLOADER := $(LOCAL_PATH)/prebuilt/boot/u-boot.bin
else
    LOCAL_2NDBOOTLOADER := $(TARGET_PREBUILT_2NDBOOTLOADER)
endif


# Boot files //No need for griffin
PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel \
    $(LOCAL_BOOTLOADER):bootloader \
    $(LOCAL_2NDBOOTLOADER):2ndbootloader

# Set property overrides
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt-flags=m=y \
    ro.com.google.locationfeatures=1 \
    ro.com.google.networklocation=1 \
    ro.allow.mock.location=1 \
    qemu.sf.lcd_density=160 \
    ro.setupwizard.enable_bypass=1 \
    ro.sf.hwrotation=180 \
    ro.setupwizard.enable_bypass=1 \
    keyguard.no_require_sim=1 \
    wifi.interface=tiwlan0 \
    alsa.mixer.playback.master=default \
    alsa.mixer.capture.master=Analog \
    dalvik.vm.heapsize=32m \
    ro.opengles.version=131072

FRAMEWORKS_BASE_SUBDIRS += \
            $(addsuffix /java, \
	    omapmmlib \
	 )

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_griffin
PRODUCT_DEVICE := griffin
