ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),griffin)
include $(call first-makefiles-under,$(call my-dir))
endif
