#############################################################
#
# php
#
#############################################################

PHP_VERSION = 5.3.14
PHP_SOURCE = php-$(PHP_VERSION).tar.bz2
PHP_SITE = http://www.php.net/distributions
PHP_INSTALL_STAGING = YES
PHP_INSTALL_STAGING_OPT = INSTALL_ROOT=$(STAGING_DIR) install
PHP_INSTALL_TARGET_OPT = INSTALL_ROOT=$(TARGET_DIR) install
PHP_CONF_OPT =  --mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--disable-all \
		--without-pear \
		--with-config-file-path=/etc \
		--localstatedir=/var \
		--disable-rpath

PHP_CFLAGS = $(TARGET_CFLAGS)

# Workaround for non-IPv6 uClibc toolchain
ifeq ($(BR2_TOOLCHAIN_BUILDROOT)$(BR2_TOOLCHAIN_EXTERNAL_UCLIBC)$(BR2_TOOLCHAIN_CTNG_uClibc),y)
ifneq ($(BR2_INET_IPV6),y)
	PHP_CFLAGS += -DHAVE_DEPRECATED_DNS_FUNCS
endif
endif

PHP_CONF_OPT += $(if $(BR2_PACKAGE_PHP_CLI),,--disable-cli)
PHP_CONF_OPT += $(if $(BR2_PACKAGE_PHP_CGI),,--disable-cgi)

### Extensions
PHP_CONF_OPT += $(if $(BR2_PACKAGE_PHP_EXT_SOCKETS),--enable-sockets) \
		$(if $(BR2_PACKAGE_PHP_EXT_POSIX),--enable-posix) \
		$(if $(BR2_PACKAGE_PHP_EXT_SESSION),--enable-session) \
		$(if $(BR2_PACKAGE_PHP_EXT_HASH),--enable-hash) \
		$(if $(BR2_PACKAGE_PHP_EXT_DOM),--enable-dom) \
		$(if $(BR2_PACKAGE_PHP_EXT_SIMPLEXML),--enable-simplexml) \
		$(if $(BR2_PACKAGE_PHP_EXT_SOAP),--enable-soap) \
		$(if $(BR2_PACKAGE_PHP_EXT_XML),--enable-xml) \
		$(if $(BR2_PACKAGE_PHP_EXT_XMLREADER),--enable-xmlreader) \
		$(if $(BR2_PACKAGE_PHP_EXT_XMLWRITER),--enable-xmlwriter) \
		$(if $(BR2_PACKAGE_PHP_EXT_EXIF),--enable-exif) \
		$(if $(BR2_PACKAGE_PHP_EXT_FTP),--enable-ftp) \
		$(if $(BR2_PACKAGE_PHP_EXT_JSON),--enable-json) \
		$(if $(BR2_PACKAGE_PHP_EXT_TOKENIZER),--enable-tokenizer) \
		$(if $(BR2_PACKAGE_PHP_EXT_PCNTL),--enable-pcntl) \
		$(if $(BR2_PACKAGE_PHP_EXT_SHMOP),--enable-shmop) \
		$(if $(BR2_PACKAGE_PHP_EXT_SYSVMSG),--enable-sysvmsg) \
		$(if $(BR2_PACKAGE_PHP_EXT_SYSVSEM),--enable-sysvsem) \
		$(if $(BR2_PACKAGE_PHP_EXT_SYSVSHM),--enable-sysvshm) \
		$(if $(BR2_PACKAGE_PHP_EXT_ZIP),--enable-zip) \
		$(if $(BR2_PACKAGE_PHP_EXT_CTYPE),--enable-ctype) \
		$(if $(BR2_PACKAGE_PHP_EXT_FILTER),--enable-filter) \
		$(if $(BR2_PACKAGE_PHP_EXT_CALENDAR),--enable-calendar) \
		$(if $(BR2_PACKAGE_PHP_EXT_FILENIFO),--enable-fileinfo) \
		$(if $(BR2_PACKAGE_PHP_EXT_BCMATH),--enable-bcmath)

ifeq ($(BR2_PACKAGE_PHP_EXT_OPENSSL),y)
	PHP_CONF_OPT += --with-openssl=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_LIBXML2),y)
	PHP_CONF_OPT += --enable-libxml --with-libxml-dir=${STAGING_DIR}/usr
	PHP_DEPENDENCIES += libxml2
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_WDDX),y)
	PHP_CONF_OPT += --enable-wddx --with-libexpat-dir=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += expat
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_XMLRPC),y)
	PHP_CONF_OPT += --with-xmlrpc \
		$(if $(BR2_PACKAGE_LIBICONV),--with-iconv-dir=$(STAGING_DIR)/usr)
	PHP_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)
endif

ifneq ($(BR2_PACKAGE_PHP_EXT_ZLIB)$(BR2_PACKAGE_PHP_EXT_ZIP),)
	PHP_CONF_OPT += --with-zlib=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += zlib
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_GETTEXT),y)
	PHP_CONF_OPT += --with-gettext=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += $(if $(BR2_NEEDS_GETTEXT),gettext)
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_ICONV),y)
ifeq ($(BR2_PACKAGE_LIBICONV),y)
	PHP_CONF_OPT += --with-iconv=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += libiconv
else
	PHP_CONF_OPT += --with-iconv
endif
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_INTL),y)
	PHP_CONF_OPT += --enable-intl --with-icu-dir=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += icu
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_GMP),y)
	PHP_CONF_OPT += --with-gmp=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += gmp
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_READLINE),y)
	PHP_CONF_OPT += --with-readline=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += readline
endif

### Legacy sqlite2 support
ifeq ($(BR2_PACKAGE_PHP_EXT_SQLITE),y)
	PHP_CONF_OPT += --with-sqlite
ifneq ($(BR2_LARGEFILE),y)
	PHP_CFLAGS += -DSQLITE_DISABLE_LFS
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_SQLITE_UTF8),y)
	PHP_CONF_OPT += --enable-sqlite-utf8
endif
endif

### Native MySQL extensions
ifeq ($(BR2_PACKAGE_PHP_EXT_MYSQL),y)
	PHP_CONF_OPT += --with-mysql=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += mysql_client
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_MYSQLI),y)
	PHP_CONF_OPT += --with-mysqli=$(STAGING_DIR)/usr/bin/mysql_config
	PHP_DEPENDENCIES += mysql_client
endif

### PDO
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO),y)
	PHP_CONF_OPT += --enable-pdo
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_SQLITE),y)
	PHP_CONF_OPT += --with-pdo-sqlite=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += sqlite
	PHP_CFLAGS += -DSQLITE_OMIT_LOAD_EXTENSION
ifneq ($(BR2_LARGEFILE),y)
	PHP_CFLAGS += -DSQLITE_DISABLE_LFS
endif
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_PDO_MYSQL),y)
	PHP_CONF_OPT += --with-pdo-mysql=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += mysql_client
endif
endif

### Use external PCRE if it's available
ifeq ($(BR2_PACKAGE_PCRE),y)
	PHP_CONF_OPT += --with-pcre-regex=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += pcre
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_CURL),y)
	PHP_CONF_OPT += --with-curl=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += libcurl
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_XSL),y)
	PHP_CONF_OPT += --with-xsl=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += libxslt
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_BZIP2),y)
	PHP_CONF_OPT += --with-bz2=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += bzip2
endif

### DBA
ifeq ($(BR2_PACKAGE_PHP_EXT_DBA),y)
	PHP_CONF_OPT += --enable-dba
ifneq ($(BR2_PACKAGE_PHP_EXT_DBA_CDB),y)
	PHP_CONF_OPT += --without-cdb
endif
ifneq ($(BR2_PACKAGE_PHP_EXT_DBA_FLAT),y)
	PHP_CONF_OPT += --without-flatfile
endif
ifneq ($(BR2_PACKAGE_PHP_EXT_DBA_INI),y)
	PHP_CONF_OPT += --without-inifile
endif
ifeq ($(BR2_PACKAGE_PHP_EXT_DBA_DB4),y)
	PHP_CONF_OPT += --with-db4=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += berkeleydb
endif
endif

ifeq ($(BR2_PACKAGE_PHP_EXT_SNMP),y)
	PHP_CONF_OPT += --with-snmp=$(STAGING_DIR)/usr
	PHP_DEPENDENCIES += netsnmp
endif

# Fixup prefix= and exec_prefix= in php-config
define PHP_FIXUP_PHP_CONFIG
	$(SED) 's%^prefix="/usr"%prefix="$(STAGING_DIR)/usr"%' \
		-e 's%^exec_prefix="/usr"%exec_prefix="$(STAGING_DIR)/usr"%' \
		$(STAGING_DIR)/usr/bin/php-config
endef

PHP_POST_INSTALL_STAGING_HOOKS += PHP_FIXUP_PHP_CONFIG

define PHP_INSTALL_FIXUP
	rm -rf $(TARGET_DIR)/usr/lib/php
	rm -f $(TARGET_DIR)/usr/bin/phpize
	rm -f $(TARGET_DIR)/usr/bin/php-config
	if [ ! -f $(TARGET_DIR)/etc/php.ini ]; then \
		$(INSTALL) -m 0755  $(PHP_DIR)/php.ini-production \
			$(TARGET_DIR)/etc/php.ini; \
	fi
endef

PHP_POST_INSTALL_TARGET_HOOKS += PHP_INSTALL_FIXUP

define PHP_UNINSTALL_STAGING_CMDS
	rm -rf $(STAGING_DIR)/usr/include/php
	rm -rf $(STAGING_DIR)/usr/lib/php
	rm -f $(STAGING_DIR)/usr/bin/php*
	rm -f $(STAGING_DIR)/usr/share/man/man1/php*.1
endef

define PHP_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/etc/php.ini
	rm -f $(TARGET_DIR)/usr/bin/php*
endef

PHP_CONF_ENV += CFLAGS="$(PHP_CFLAGS)"

$(eval $(call AUTOTARGETS))
