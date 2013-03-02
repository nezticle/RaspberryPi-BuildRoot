################################################################################
#
# json-c
#
################################################################################

JSON_C_VERSION = 0.10
JSON_C_SITE = http://github.com/downloads/json-c/json-c
JSON_C_INSTALL_STAGING = YES
JSON_C_POST_INSTALL_STAGING_HOOKS += POST_INSTALL_STAGING_FIX

define POST_INSTALL_STAGING_FIX
	#doesn't get installed by json-c for some reason
	cp $(@D)/json_object_iterator.h $(STAGING_DIR)/usr/include/json/
endef

$(eval $(autotools-package))
