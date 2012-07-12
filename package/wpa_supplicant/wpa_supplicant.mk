#############################################################
#
# wpa_supplicant
#
#############################################################

WPA_SUPPLICANT_VERSION = 1.0
WPA_SUPPLICANT_SITE = http://hostap.epitest.fi/releases
WPA_SUPPLICANT_CONFIG = $(WPA_SUPPLICANT_DIR)/wpa_supplicant/.config
WPA_SUPPLICANT_SUBDIR = wpa_supplicant
WPA_SUPPLICANT_DBUS_SERVICE = fi.epitest.hostap.WPASupplicant
WPA_SUPPLICANT_CFLAGS = $(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/libnl3/
WPA_SUPPLICANT_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_LIBNL),y)
	WPA_SUPPLICANT_DEPENDENCIES += libnl
define WPA_SUPPLICANT_LIBNL_CONFIG
	echo 'CONFIG_LIBNL32=y' >>$(WPA_SUPPLICANT_CONFIG)
endef
else
define WPA_SUPPLICANT_LIBNL_CONFIG
	$(SED) 's/^\(CONFIG_DRIVER_NL80211.*\)/#\1/' $(WPA_SUPPLICANT_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_EAP),y)
define WPA_SUPPLICANT_EAP_CONFIG
	$(SED) 's/\(#\)\(CONFIG_EAP_AKA.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_FAST.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_GPSK.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_IKEV2.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_PAX.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_PSK.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_SAKE.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_SIM.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_TNC.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
endef
else
define WPA_SUPPLICANT_EAP_CONFIG
	$(SED) 's/^\(CONFIG_EAP.*\)/#\1/' $(WPA_SUPPLICANT_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_AP_SUPPORT),y)
define WPA_SUPPLICANT_AP_CONFIG
	echo 'CONFIG_AP=y' >>$(WPA_SUPPLICANT_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_WPS),y)
define WPA_SUPPLICANT_WPS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_WPS.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
endef
endif

define WPA_SUPPLICANT_LIBTOMMATH_CONFIG
	$(SED) 's/\(#\)\(CONFIG_INTERNAL_LIBTOMMATH.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
endef

# Try to use openssl or gnutls if it's already available
ifeq ($(BR2_PACKAGE_OPENSSL),y)
	WPA_SUPPLICANT_DEPENDENCIES += openssl
define WPA_SUPPLICANT_TLS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_TLS=openssl\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_PWD.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
endef
else
ifeq ($(BR2_PACKAGE_GNUTLS),y)
	WPA_SUPPLICANT_DEPENDENCIES += gnutls
define WPA_SUPPLICANT_TLS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_TLS=\).*/\2gnutls/' $(WPA_SUPPLICANT_CONFIG)
endef
else
define WPA_SUPPLICANT_TLS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_TLS=\).*/\2internal/' $(WPA_SUPPLICANT_CONFIG)
endef
endif
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
	WPA_SUPPLICANT_DEPENDENCIES += host-pkg-config dbus
	WPA_SUPPLICANT_MAKE_ENV = \
		PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)"	\
		PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig"
define WPA_SUPPLICANT_DBUS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_CTRL_IFACE_DBUS=\)/\2/' $(WPA_SUPPLICANT_CONFIG)
endef
endif

define WPA_SUPPLICANT_CONFIGURE_CMDS
	cp $(@D)/wpa_supplicant/defconfig $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_IEEE80211N.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_IEEE80211R.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_INTERWORKING.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_DELAYED_MIC.*\)/\2/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(CONFIG_DRIVER_ATMEL\)/#\1/' $(WPA_SUPPLICANT_CONFIG)
	$(SED) 's/\(CONFIG_SMARTCARD\)/#\1/' $(WPA_SUPPLICANT_CONFIG)
	$(WPA_SUPPLICANT_LIBTOMMATH_CONFIG)
	$(WPA_SUPPLICANT_TLS_CONFIG)
	$(WPA_SUPPLICANT_EAP_CONFIG)
	$(WPA_SUPPLICANT_WPS_CONFIG)
	$(WPA_SUPPLICANT_LIBNL_CONFIG)
	$(WPA_SUPPLICANT_DBUS_CONFIG)
	$(WPA_SUPPLICANT_AP_CONFIG)
endef

define WPA_SUPPLICANT_BUILD_CMDS
	$(TARGET_MAKE_ENV) CFLAGS="$(WPA_SUPPLICANT_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		$(MAKE) CC="$(TARGET_CC)" -C $(@D)/$(WPA_SUPPLICANT_SUBDIR)
endef

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_CLI),y)
define WPA_SUPPLICANT_INSTALL_CLI
	$(INSTALL) -m 0755 -D $(@D)/$(WPA_SUPPLICANT_SUBDIR)/wpa_cli \
		$(TARGET_DIR)/usr/sbin/wpa_cli
endef
endif

ifeq ($(BR2_PACKAGE_WPA_SUPPLICANT_PASSPHRASE),y)
define WPA_SUPPLICANT_INSTALL_PASSPHRASE
	$(INSTALL) -m 0755 -D $(@D)/$(WPA_SUPPLICANT_SUBDIR)/wpa_passphrase \
		$(TARGET_DIR)/usr/sbin/wpa_passphrase
endef
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
define WPA_SUPPLICANT_INSTALL_DBUS
	$(INSTALL) -D \
	  $(@D)/wpa_supplicant/dbus/dbus-wpa_supplicant.conf \
	  $(TARGET_DIR)/etc/dbus-1/system.d/wpa_supplicant.conf
	$(INSTALL) -D \
	  $(@D)/wpa_supplicant/dbus/$(WPA_SUPPLICANT_DBUS_SERVICE).service \
	  $(TARGET_DIR)/usr/share/dbus-1/system-services/$(WPA_SUPPLICANT_DBUS_SERVICE).service
endef
endif

define WPA_SUPPLICANT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(WPA_SUPPLICANT_SUBDIR)/wpa_supplicant \
		$(TARGET_DIR)/usr/sbin/wpa_supplicant
	$(INSTALL) -m 644 -D package/wpa_supplicant/wpa_supplicant.conf \
		$(TARGET_DIR)/etc/wpa_supplicant.conf
	$(WPA_SUPPLICANT_INSTALL_CLI)
	$(WPA_SUPPLICANT_INSTALL_PASSPHRASE)
	$(WPA_SUPPLICANT_INSTALL_DBUS)
endef

$(eval $(call GENTARGETS))
