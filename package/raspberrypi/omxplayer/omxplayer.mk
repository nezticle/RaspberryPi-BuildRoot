OMXPLAYER_VERSION = 71a72d0a4552040544f6c8d59b57d29e93e62ea7
OMXPLAYER_SITE = git://github.com/nezticle/omxplayer.git
OMXPLAYER_SITE_METHOD = git
OMXPLAYER_DEPENDENCIES = ffmpeg freetype boost pcre liberation

OMXPLAYER_CONFIG_ENV = \
LD="$(TARGET_LD)" \
CC="$(TARGET_CC)" \
CXX="$(TARGET_CXX)" \
OBJDUMP=$(HOST_DIR)usr/bin/$(TARGET_CROSS)objdump \
RANLIB=$(HOST_DIR)usr/bin/$(TARGET_CROSS)ranlib \
STRIP=$(HOST_DIR)usr/bin/$(TARGET_CROSS)strip \
AR=$(HOST_DIR)usr/bin/$(TARGET_CROSS)ar \
CXXCP="$(CXX) -E" \
PATH=$(HOST_DIR)usr/bin:$(PATH) \
CFLAGS="-pipe -mfloat-abi=hard -mcpu=arm1176jzf-s -fomit-frame-pointer -mabi=aapcs-linux -mtune=arm1176jzf-s -mfpu=vfp -Wno-psabi -mno-apcs-stack-check -O3 -mstructure-size-boundary=32 -mno-sched-prolog" \
LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib -L$(STAGING_DIR)/opt/vc/lib/" \
INCLUDES="-isystem$(STAGING_DIR)/usr/include -isystem$(STAGING_DIR)/opt/vc/include -isystem$(STAGING_DIR)/usr/include -isystem$(STAGING_DIR)/opt/vc/include/interface/vcos/pthreads -isystem$(STAGING_DIR)/opt/vc/include/interface/vmcs_host/linux -isystem$(STAGING_DIR)/usr/include/freetype2"

define OMXPLAYER_CONFIGURE_CMDS
	$(MAKE) clean -C $(@D)
endef

define OMXPLAYER_BUILD_CMDS
	$(OMXPLAYER_CONFIG_ENV) $(MAKE) -C $(@D)
endef

define OMXPLAYER_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/omxplayer.bin $(TARGET_DIR)/usr/bin/omxplayer.bin
	$(INSTALL) -m 755 $(@D)/omxplayer $(TARGET_DIR)/usr/bin/omxplayer
endef

define OMXPLAYER_UNINSTALL_TARGET_CMDS
	-rm $(TARGET_DIR)/usr/bin/omxplayer.bin
	-rm $(TARGET_DIR)/usr/bin/omxplayer
endef

$(eval $(generic-package))
