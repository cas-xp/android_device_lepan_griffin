## Specify phone tech before including full_phone
# Inherit device configuration
$(call inherit-product, device/lepan/griffin/full_griffin.mk)

# Release name
PRODUCT_RELEASE_NAME := TC970

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_tablet_wifionly.mk)
#Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=griffin BUILD_ID=IML74K BUILD_DISPLAY_ID=IML74K BUILD_FINGERPRINT="google/lepan/griffin:4.0.3/IML74K/235179:user/release-keys" PRIVATE_BUILD_DESC="griffin-user 4.0.3 IML74K 35179 release-keys"

PRODUCT_NAME := cm_griffin
PRODUCT_DEVICE := griffin

