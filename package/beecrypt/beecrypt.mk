#############################################################
#
# beecrypt
#
#############################################################
BEECRYPT_VERSION = 4.2.1
BEECRYPT_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/beecrypt
BEECRYPT_AUTORECONF = YES
BEECRYPT_INSTALL_STAGING = YES

# beecrypt contains C++ code that g++ 4.7 doesn't really
# like. Upstream does not seem to be really active, so workaround this
# by passing -fpermissive.
BEECRYPT_CONF_ENV = \
	CXXFLAGS="$(TARGET_CXXFLAGS) -fpermissive"

BEECRYPT_CONF_OPT = \
		--without-java \
		--without-python

ifeq ($(BR2_PACKAGE_ICU),y)
# C++ support needs icu
BEECRYPT_DEPENDENCIES += icu
else
BEECRYPT_CONF_OPT += --without-cplusplus

# automake/libtool uses the C++ compiler to link libbeecrypt because of
# (the optional) cppglue.cxx. Force it to use the C compiler instead.
define BEECRYPT_LINK_WITH_CC
	$(SED) 's/--tag=CXX/--tag=CC/g' $(@D)/Makefile
endef

BEECRYPT_POST_CONFIGURE_HOOKS += BEECRYPT_LINK_WITH_CC
endif

$(eval $(call AUTOTARGETS))
