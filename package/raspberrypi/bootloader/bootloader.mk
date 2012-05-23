BOOTLOADER_VERSION = master
BOOTLOADER_SITE = git://github.com/raspberrypi/firmware.git
BOOTLOADER_SITE_METHOD = git
BOOTLOADER_INSTALL_TARGET = YES

define BOOTLOADER_INSTALL_TARGET_CMDS
	echo "Pull bootloaders from git"
	mkdir -p $(TARGET_DIR)/boot
	cp $(@D)/boot/arm128_start.elf $(TARGET_DIR)/boot/start.elf
	cp $(@D)/boot/bootcode.bin $(TARGET_DIR)/boot/bootcode.bin
	cp $(@D)/boot/loader.bin $(TARGET_DIR)/boot/loader.bin
endef

$(eval $(call GENTARGETS))
