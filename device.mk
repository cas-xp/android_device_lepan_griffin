#
# Copyright (C) 2009 The Android Open Source Project
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
#

# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS += device/lepan/griffin/overlay

$(call inherit-product, frameworks/base/build/tablet-dalvik-heap.mk)

# Init files
PRODUCT_COPY_FILES += \
    device/lepan/griffin/init.griffin.rc:root/init.griffin.rc \
    device/lepan/griffin/init.griffin.usb.rc:root/init.griffin.usb.rc \
    device/lepan/griffin/ueventd.griffin.rc:root/ueventd.griffin.rc

# Wifi
PRODUCT_COPY_FILES += \
    device/lepan/griffin/prebuilt/wifi/tiwlan_drv.ko:/system/lib/modules/tiwlan_drv.ko \
    device/lepan/griffin/prebuilt/wifi/tiwlan.ini:/system/etc/wifi/tiwlan.ini \
    device/lepan/griffin/prebuilt/wifi/firmware.bin:/system/etc/wifi/firmware.bin

# key mapping and touchscreen files
PRODUCT_COPY_FILES += \
    device/lepan/griffin/cyttsp-i2c.idc:/system/usr/idc/cyttsp-i2c.idc \
    device/lepan/griffin/ft5x06-i2c.idc:/system/usr/idc/ft5x06-i2c.idc \
    device/lepan/griffin/prebuilt/usr/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

# Bluetooth
PRODUCT_COPY_FILES += \
    device/lepan/griffin/firmware/TIInit_7.2.31.bts:/system/etc/firmware/TIInit_7.2.31.bts

# Overlay (omapzoom)
PRODUCT_COPY_FILES += \
    device/lepan/griffin/prebuilt/GFX/system/lib/hw/overlay.omap3.so:/system/lib/hw/overlay.omap3.so 

# Place permission files
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

# Vold
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/etc/vold.griffin.fstab:system/etc/vold.fstab

# Media Profile
PRODUCT_COPY_FILES += \
   $(LOCAL_PATH)/etc/media_profiles.xml:system/etc/media_profiles.xml


# Art
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/poetry/poem.txt:root/sbin/poem.txt


ifeq ($(TARGET_PREBUILT_KERNEL),)
    LOCAL_KERNEL := device/lepan/griffin/prebuilt/boot/kernel
else
    LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

ifeq ($(TARGET_PREBUILT_BOOTLOADER),)
    LOCAL_BOOTLOADER := device/lepan/griffin/prebuilt/boot/MLO
else
    LOCAL_BOOTLOADER := $(TARGET_PREBUILT_BOOTLOADER)
endif

ifeq ($(TARGET_PREBUILT_2NDBOOTLOADER),)
    LOCAL_2NDBOOTLOADER := device/lepan/griffin/prebuilt/boot/u-boot.bin
else
    LOCAL_2NDBOOTLOADER := $(TARGET_PREBUILT_2NDBOOTLOADER)
endif

# Boot files
PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel \
    $(LOCAL_BOOTLOADER):bootloader \
    $(LOCAL_2NDBOOTLOADER):2ndbootloader

# ramdisk_tools.sh -- use on-demand for various ramdisk operations, such as
# repacking the ramdisk for use on an SD card or alternate emmc partitions
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/ramdisk_tools.sh:ramdisk_tools.sh

# postrecoveryboot for cwm
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh

# Product specfic packages
PRODUCT_PACKAGES += \
    hwprops \
    lights.griffin \
    sensors.griffin \
    uim-sysfs \
    libaudioutils \
    audio.a2dp.default \
    libaudiohw_legacy \
    audio.primary.omap3 \
    libaudiopolicy_legacy2 \
    audio.primary.griffin

PRODUCT_PACKAGES += \
    acoustics.default \
    alsa.default \
    alsa.omap3 \
    com.android.future.usb.accessory \
    dhcpcd.conf \
    dspexec \
    libCustomWifi \
    libLCML \
    libOMX.TI.AAC.encode \
    libOMX.TI.AMR.encode \
    libOMX.TI.JPEG.Encoder \
    libOMX.TI.Video.Decoder \
    libOMX.TI.Video.encoder \
    libOMX.TI.WBAMR.encode \
    libOMX_Core \
    libVendor_ti_omx \
    libbridge \
    libomap_mm_library_jni \
    librs_jni \
    libtiOsLib \
    make_ext4fs \
    wlan_cu \
    wlan_loader \
    wpa_supplicant.conf

PRODUCT_CHARACTERISTICS := tablet

# Screen size is "large", density is "mdpi"
PRODUCT_AAPT_CONFIG := large mdpi

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Set property overrides
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=tiwlan0 \
    alsa.mixer.playback.master=default \
    alsa.mixer.capture.master=Analog \
    dalvik.vm.heapsize=128m \
    ro.opengles.version=131072 \

$(call inherit-product-if-exists, vendor/lepan/griffin/device-vendor.mk)
$(call inherit-product-if-exists, vendor/lepan/griffin/device-vendor-blobs.mk)
