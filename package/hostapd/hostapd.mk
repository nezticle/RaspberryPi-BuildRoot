##############################################################
#
# hostapd
#
#############################################################

HOSTAPD_VERSION = 1.0
HOSTAPD_SITE = http://hostap.epitest.fi/releases
HOSTAPD_SUBDIR = hostapd
HOSTAPD_CONFIG = $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/.config
HOSTAPD_DEPENDENCIES = libnl
HOSTAPD_CFLAGS = $(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/libnl3/
HOSTAPD_LDFLAGS = $(TARGET_LDFLAGS)

# libnl needs -lm (for rint) if linking statically
ifeq ($(BR2_PREFER_STATIC_LIB),y)
HOSTAPD_LDFLAGS += -lm
endif

define HOSTAPD_LIBNL_CONFIG
	echo 'CONFIG_LIBNL32=y' >>$(HOSTAPD_CONFIG)
endef

define HOSTAPD_LIBTOMMATH_CONFIG
	$(SED) 's/\(#\)\(CONFIG_INTERNAL_LIBTOMMATH.*\)/\2/' $(HOSTAPD_CONFIG)
endef

# Try to use openssl or gnutls if it's already available
ifeq ($(BR2_PACKAGE_OPENSSL),y)
	HOSTAPD_DEPENDENCIES += openssl
define HOSTAPD_TLS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_TLS=openssl\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_PWD.*\)/\2/' $(HOSTAPD_CONFIG)
endef
else
ifeq ($(BR2_PACKAGE_GNUTLS),y)
	HOSTAPD_DEPENDENCIES += gnutls
define HOSTAPD_TLS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_TLS=\).*/\2gnutls/' $(HOSTAPD_CONFIG)
endef
else
define HOSTAPD_TLS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_TLS=\).*/\2internal/' $(HOSTAPD_CONFIG)
endef
endif
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_EAP),y)
define HOSTAPD_EAP_CONFIG
	$(SED) 's/\(#\)\(CONFIG_EAP_AKA.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_FAST.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_GPSK.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_IKEV2.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_PAX.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_PSK.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_SAKE.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_SIM.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_EAP_TNC.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_RADIUS_SERVER.*\)/\2/' $(HOSTAPD_CONFIG)
endef
ifneq ($(BR2_INET_IPV6),y)
define HOSTAPD_RADIUS_IPV6_CONFIG
	$(SED) 's/\(CONFIG_IPV6.*\)/#\1/' $(HOSTAPD_CONFIG)
endef
endif
else
define HOSTAPD_EAP_CONFIG
	$(SED) 's/^\(CONFIG_EAP.*\)/#\1/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_NO_ACCOUNTING.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_NO_RADIUS.*\)/\2/' $(HOSTAPD_CONFIG)
endef
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_WPS),y)
define HOSTAPD_WPS_CONFIG
	$(SED) 's/\(#\)\(CONFIG_WPS.*\)/\2/' $(HOSTAPD_CONFIG)
endef
endif

define HOSTAPD_CONFIGURE_CMDS
	cp $(@D)/hostapd/defconfig $(HOSTAPD_CONFIG)
# Misc
	$(SED) 's/\(#\)\(CONFIG_IEEE80211N.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_IEEE80211R.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_INTERWORKING.*\)/\2/' $(HOSTAPD_CONFIG)
	$(SED) 's/\(#\)\(CONFIG_FULL_DYNAMIC_VLAN.*\)/\2/' $(HOSTAPD_CONFIG)
	$(HOSTAPD_LIBTOMMATH_CONFIG)
	$(HOSTAPD_TLS_CONFIG)
	$(HOSTAPD_RADIUS_IPV6_CONFIG)
	$(HOSTAPD_EAP_CONFIG)
	$(HOSTAPD_WPS_CONFIG)
	$(HOSTAPD_LIBNL_CONFIG)
endef

define HOSTAPD_BUILD_CMDS
	$(TARGET_MAKE_ENV) CFLAGS="$(HOSTAPD_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		$(MAKE) CC="$(TARGET_CC)" -C $(@D)/$(HOSTAPD_SUBDIR)
endef

define HOSTAPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd \
		$(TARGET_DIR)/usr/sbin/hostapd
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd_cli \
		$(TARGET_DIR)/usr/bin/hostapd_cli
endef

$(eval $(call GENTARGETS))
