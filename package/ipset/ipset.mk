#############################################################
#
# ipset
#
#############################################################

IPSET_VERSION = 6.12.1
IPSET_SOURCE = ipset-$(IPSET_VERSION).tar.bz2
IPSET_SITE = http://ipset.netfilter.org
IPSET_DEPENDENCIES = libmnl host-pkg-config
IPSET_CONF_OPT = --with-kmod=no

$(eval $(call AUTOTARGETS))
