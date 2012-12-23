BOOTLOADER_VERSION = 7beaaff
BOOTLOADER_SITE = http://bsquask.com/downloads/firmware
BOOTLOADER_SOURCE = raspberrypi-bootloader-$(BOOTLOADER_VERSION).tar.gz
BOOTLOADER_INSTALL_TARGET = YES

define BOOTLOADER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/boot
	cp $(@D)/start.elf $(TARGET_DIR)/boot/start.elf
	cp $(@D)/bootcode.bin $(TARGET_DIR)/boot/bootcode.bin
	cp $(@D)/fixup.dat $(TARGET_DIR)/boot/fixup.dat
	# Generate boot config files
	echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait" > $(TARGET_DIR)/boot/cmdline.txt
	echo "disable_overscan=1" > $(TARGET_DIR)/boot/config.txt
	echo "framebuffer_depth=24" >> $(TARGET_DIR)/boot/config.txt
	echo "arm_freq=800" >> $(TARGET_DIR)/boot/config.txt
	echo "gpu_mem="$(BR2_RASPBERRYPI_GPU_RAM_SIZE) >> $(TARGET_DIR)/boot/config.txt
endef

$(eval $(generic-package))
