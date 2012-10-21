BOOTLOADER_VERSION = c58f722
BOOTLOADER_SITE = http://bsquask.com/downloads/firmware
BOOTLOADER_SOURCE = raspberrypi-firmware-$(BOOTLOADER_VERSION).tar.gz
BOOTLOADER_INSTALL_TARGET = YES

define BOOTLOADER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/boot
	cp $(@D)/boot/start.elf $(TARGET_DIR)/boot/start.elf
	cp $(@D)/boot/start_cd.elf $(TARGET_DIR)/boot/start_cd.elf
	cp $(@D)/boot/bootcode.bin $(TARGET_DIR)/boot/bootcode.bin
	cp $(@D)/boot/fixup.dat $(TARGET_DIR)/boot/fixup.dat
	cp $(@D)/boot/fixup_cd.dat $(TARGET_DIR)/boot/fixup_cd.dat
endef

$(eval $(generic-package))
