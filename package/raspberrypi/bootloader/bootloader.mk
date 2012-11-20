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
	# Generate boot config files
	echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait" > $(TARGET_DIR)/boot/cmdline.txt
	echo "disable_overscan=1" > $(TARGET_DIR)/boot/config.txt
	echo "arm_freq=1000" >> $(TARGET_DIR)/boot/config.txt
	echo "core_freq=500" >> $(TARGET_DIR)/boot/config.txt
	echo "sdram_freq=500" >> $(TARGET_DIR)/boot/config.txt
	echo "over_voltage=6" >> $(TARGET_DIR)/boot/config.txt
	echo "gpu_mem="$(BR2_RASPBERRYPI_GPU_RAM_SIZE) >> $(TARGET_DIR)/boot/config.txt
endef

$(eval $(generic-package))
