#############################################################
#
# sdl_sound addon for SDL
#
#############################################################
SDL_SOUND_VERSION = 1.0.3
SDL_SOUND_SOURCE = SDL_sound-$(SDL_SOUND_VERSION).tar.gz
SDL_SOUND_SITE = http://icculus.org/SDL_sound/downloads/
SDL_SOUND_INSTALL_STAGING = YES
SDL_SOUND_DEPENDENCIES = sdl

ifneq ($(BR2_ENABLE_LOCALE),y)
SDL_SOUND_DEPENDENCIES += libiconv
endif

# optional dependencies
ifeq ($(BR2_PACKAGE_FLAC),y)
SDL_SOUND_DEPENDENCIES += flac # is only used if ogg is also enabled
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SDL_SOUND_DEPENDENCIES += libvorbis
endif

ifeq ($(BR2_PACKAGE_SPEEX),y)
SDL_SOUND_DEPENDENCIES += speex
endif

SDL_SOUND_CONF_OPT = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--with-sdl-exec-prefix=$(STAGING_DIR)/usr \
	--disable-sdltest \
	--enable-static

# enable mmx for newer x86's
ifeq ($(BR2_i386)$(BR2_x86_i386)$(BR2_x86_i486)$(BR2_x86_i586)$(BR2_x86_pentiumpro)$(BR2_x86_geode),y)
SDL_SOUND_CONF_OPT += --enable-mmx
else
SDL_SOUND_CONF_OPT += --disable-mmx
endif

define SDL_SOUND_REMOVE_PLAYSOUND
	rm $(addprefix $(TARGET_DIR)/usr/bin/,playsound playsound_simple)
endef

ifneq ($(BR2_PACKAGE_SDL_SOUND_PLAYSOUND),y)
SDL_SOUND_POST_INSTALL_TARGET_HOOKS += SDL_SOUND_REMOVE_PLAYSOUND
endif

# target shared libs doesn't get removed by make uninstall if the .la
# files are removed (E.G. if BR2_HAVE_DEVFILES isn't set)
define SDL_SOUND_UNINSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) uninstall -C $(@D)
	rm -f $(TARGET_DIR)/usr/lib/libSDL_sound*so*
endef

$(eval $(call AUTOTARGETS))
