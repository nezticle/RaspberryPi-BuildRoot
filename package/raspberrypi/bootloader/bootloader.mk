BOOTLOADER_VERSION = 80d26df
BOOTLOADER_SITE = http://bsquask.com/downloads/firmware
BOOTLOADER_SOURCE = raspberrypi-bootloader-$(BOOTLOADER_VERSION).tar.gz
BOOTLOADER_INSTALL_TARGET = YES

define BOOTLOADER_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/boot
	cp $(@D)/start.elf $(TARGET_DIR)/boot/start.elf
	cp $(@D)/bootcode.bin $(TARGET_DIR)/boot/bootcode.bin
	cp $(@D)/fixup.dat $(TARGET_DIR)/boot/fixup.dat
	# Generate boot config files
	echo "dwc_otg.lpm_enable=0 console=ttyAMA0,115200 kgdboc=ttyAMA0,115200 console=tty2 root=/dev/mmcblk0p2 rootfstype=ext4 coherent_pool=6M smsc95xx.turbo_mode=N rootwait quiet" > $(TARGET_DIR)/boot/cmdline.txt
	echo "disable_overscan=1" > $(TARGET_DIR)/boot/config.txt
	echo "framebuffer_depth=24" >> $(TARGET_DIR)/boot/config.txt
	echo "arm_freq=1000" >> $(TARGET_DIR)/boot/config.txt
	echo "core_freq=500" >> $(TARGET_DIR)/boot/config.txt
	echo "sdram_freq=500" >> $(TARGET_DIR)/boot/config.txt
	echo "over_voltage=6" >> $(TARGET_DIR)/boot/config.txt
	echo "gpu_mem_256=112" >> $(TARGET_DIR)/boot/config.txt
	echo "gpu_mem_512=368" >> $(TARGET_DIR)/boot/config.txt
	echo "cma_lwm=16" >> $(TARGET_DIR)/boot/config.txt
	echo "cma_hwm=32" >> $(TARGET_DIR)/boot/config.txt
	echo "cma_offline_start=16" >> $(TARGET_DIR)/boot/config.txt
endef

$(eval $(generic-package))
