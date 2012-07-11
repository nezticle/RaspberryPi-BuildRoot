#############################################################
#
# uClibc (the C library)
#
#############################################################

ifeq ($(BR2_TOOLCHAIN_BUILDROOT),y)

# specifying UCLIBC_CONFIG_FILE on the command-line overrides the .config
# setting.
ifndef UCLIBC_CONFIG_FILE
UCLIBC_CONFIG_FILE=$(call qstrip,$(BR2_UCLIBC_CONFIG))
endif

UCLIBC_VERSION:=$(call qstrip,$(BR2_UCLIBC_VERSION_STRING))

ifeq ($(BR2_UCLIBC_VERSION_SNAPSHOT),y)
UCLIBC_SITE:=http://www.uclibc.org/downloads/snapshots
UCLIBC_DIR:=$(TOOLCHAIN_DIR)/uClibc
else
UCLIBC_SITE:=http://www.uclibc.org/downloads
UCLIBC_DIR:=$(TOOLCHAIN_DIR)/uClibc-$(UCLIBC_VERSION)
endif

UCLIBC_PATCH_DIR:=toolchain/uClibc/
UCLIBC_SOURCE:=uClibc-$(UCLIBC_VERSION).tar.bz2

UCLIBC_CAT:=$(BZCAT)

UCLIBC_TARGET_ARCH:=$(shell $(SHELL) -c "echo $(ARCH) | sed \
		-e 's/-.*//' \
		-e 's/i.86/i386/' \
		-e 's/sparc.*/sparc/' \
		-e 's/arm.*/arm/g' \
		-e 's/m68k.*/m68k/' \
		-e 's/ppc/powerpc/g' \
		-e 's/v850.*/v850/g' \
		-e 's/sh[234].*/sh/' \
		-e 's/mips.*/mips/' \
		-e 's/mipsel.*/mips/' \
		-e 's/cris.*/cris/' \
		-e 's/xtensa.*/xtensa/' \
")
# just handle the ones that can be big or little
UCLIBC_TARGET_ENDIAN:=$(shell $(SHELL) -c "echo $(ARCH) | sed \
		-e 's/armeb/BIG/' \
		-e 's/arm/LITTLE/' \
		-e 's/mipsel/LITTLE/' \
		-e 's/mips/BIG/' \
		-e 's/sh.*eb/BIG/' \
		-e 's/sh.*/LITTLE/' \
		-e 's/sparc.*/BIG/' \
")

ifneq ($(UCLIBC_TARGET_ENDIAN),LITTLE)
ifneq ($(UCLIBC_TARGET_ENDIAN),BIG)
UCLIBC_TARGET_ENDIAN:=
endif
endif
ifeq ($(UCLIBC_TARGET_ENDIAN),LITTLE)
UCLIBC_NOT_TARGET_ENDIAN:=BIG
else
UCLIBC_NOT_TARGET_ENDIAN:=LITTLE
endif

UCLIBC_ARM_TYPE:=CONFIG_$(call qstrip,$(BR2_ARM_TYPE))
UCLIBC_SPARC_TYPE:=CONFIG_SPARC_$(call qstrip,$(BR2_SPARC_TYPE))

ifeq ($(GENERATE_LOCALE),)
# We need at least one locale
UCLIBC_LOCALES = en_US
else
# Strip out the encoding part of locale names, if any
UCLIBC_LOCALES = $(foreach locale,$(GENERATE_LOCALE),\
		   $(firstword $(subst .,$(space),$(locale))))
endif

$(DL_DIR)/$(UCLIBC_SOURCE):
	$(call DOWNLOAD,$(UCLIBC_SITE)/$(UCLIBC_SOURCE))

uclibc-unpacked: $(UCLIBC_DIR)/.unpacked
$(UCLIBC_DIR)/.unpacked: $(DL_DIR)/$(UCLIBC_SOURCE)
	mkdir -p $(TOOLCHAIN_DIR)
	rm -rf $(UCLIBC_DIR)
	$(UCLIBC_CAT) $(DL_DIR)/$(UCLIBC_SOURCE) | tar -C $(TOOLCHAIN_DIR) $(TAR_OPTIONS) -
	touch $@

uclibc-patched: $(UCLIBC_DIR)/.patched
$(UCLIBC_DIR)/.patched: $(UCLIBC_DIR)/.unpacked
ifneq ($(BR2_UCLIBC_VERSION_SNAPSHOT),y)
	support/scripts/apply-patches.sh $(UCLIBC_DIR) $(UCLIBC_PATCH_DIR) \
		uClibc-$(UCLIBC_VERSION)-\*.patch \
		uClibc-$(UCLIBC_VERSION)-\*.patch.$(ARCH)
else
	support/scripts/apply-patches.sh $(UCLIBC_DIR) $(UCLIBC_PATCH_DIR) \
		uClibc.\*.patch uClibc.\*.patch.$(ARCH)
endif
	touch $@


# Some targets may wish to provide their own UCLIBC_CONFIG_FILE...
$(UCLIBC_DIR)/.oldconfig: $(UCLIBC_DIR)/.patched $(UCLIBC_CONFIG_FILE)
	cp -f $(UCLIBC_CONFIG_FILE) $(UCLIBC_DIR)/.oldconfig
	$(SED) 's,^CROSS_COMPILER_PREFIX=.*,CROSS_COMPILER_PREFIX="$(TARGET_CROSS)",g' \
		-e 's,# TARGET_$(UCLIBC_TARGET_ARCH) is not set,TARGET_$(UCLIBC_TARGET_ARCH)=y,g' \
		-e 's,^TARGET_ARCH=".*",TARGET_ARCH=\"$(UCLIBC_TARGET_ARCH)\",g' \
		-e 's,^KERNEL_SOURCE=.*,KERNEL_SOURCE=\"$(LINUX_HEADERS_DIR)\",g' \
		-e 's,^KERNEL_HEADERS=.*,KERNEL_HEADERS=\"$(LINUX_HEADERS_DIR)/include\",g' \
		-e 's,^RUNTIME_PREFIX=.*,RUNTIME_PREFIX=\"/\",g' \
		-e 's,^DEVEL_PREFIX=.*,DEVEL_PREFIX=\"/usr/\",g' \
		-e 's,^SHARED_LIB_LOADER_PREFIX=.*,SHARED_LIB_LOADER_PREFIX=\"/lib\",g' \
		$(UCLIBC_DIR)/.oldconfig
ifeq ($(UCLIBC_TARGET_ARCH),arm)
	(/bin/echo "# CONFIG_GENERIC_ARM is not set"; \
	 /bin/echo "# CONFIG_ARM610 is not set"; \
	 /bin/echo "# CONFIG_ARM710 is not set"; \
	 /bin/echo "# CONFIG_ARM7TDMI is not set"; \
	 /bin/echo "# CONFIG_ARM720T is not set"; \
	 /bin/echo "# CONFIG_ARM920T is not set"; \
	 /bin/echo "# CONFIG_ARM922T is not set"; \
	 /bin/echo "# CONFIG_ARM926T is not set"; \
	 /bin/echo "# CONFIG_ARM10T is not set"; \
	 /bin/echo "# CONFIG_ARM1136JF_S is not set"; \
	 /bin/echo "# CONFIG_ARM1176JZ_S is not set"; \
	 /bin/echo "# CONFIG_ARM1176JZF_S is not set"; \
	 /bin/echo "# CONFIG_ARM_SA110 is not set"; \
	 /bin/echo "# CONFIG_ARM_SA1100 is not set"; \
	 /bin/echo "# CONFIG_ARM_XSCALE is not set"; \
	 /bin/echo "# CONFIG_ARM_IWMMXT is not set"; \
	) >> $(UCLIBC_DIR)/.oldconfig
	$(SED) 's/^\(CONFIG_[^_]*[_]*ARM[^=]*\)=.*/# \1 is not set/g' \
		 $(UCLIBC_DIR)/.oldconfig
	$(SED) 's/^.*$(UCLIBC_ARM_TYPE).*/$(UCLIBC_ARM_TYPE)=y/g' $(UCLIBC_DIR)/.oldconfig
	$(SED) '/CONFIG_ARM_.ABI/d' $(UCLIBC_DIR)/.oldconfig
ifeq ($(BR2_ARM_EABI),y)
	/bin/echo "# CONFIG_ARM_OABI is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "CONFIG_ARM_EABI=y" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_ARM_OABI),y)
	/bin/echo "CONFIG_ARM_OABI=y" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_ARM_EABI is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
endif
ifeq ($(UCLIBC_TARGET_ARCH),mips)
	$(SED) '/CONFIG_MIPS_[NO].._ABI/d' $(UCLIBC_DIR)/.oldconfig
	$(SED) '/CONFIG_MIPS_ISA_.*/d' $(UCLIBC_DIR)/.oldconfig
	(/bin/echo "# CONFIG_MIPS_O32_ABI is not set"; \
	 /bin/echo "# CONFIG_MIPS_N32_ABI is not set"; \
	 /bin/echo "# CONFIG_MIPS_N64_ABI is not set"; \
	 /bin/echo "# CONFIG_MIPS_ISA_1 is not set"; \
	 /bin/echo "# CONFIG_MIPS_ISA_2 is not set"; \
	 /bin/echo "# CONFIG_MIPS_ISA_3 is not set"; \
	 /bin/echo "# CONFIG_MIPS_ISA_4 is not set"; \
	 /bin/echo "# CONFIG_MIPS_ISA_MIPS32 is not set"; \
	 /bin/echo "# CONFIG_MIPS_ISA_MIPS32R2 is not set"; \
	 /bin/echo "# CONFIG_MIPS_ISA_MIPS64 is not set"; \
	) >> $(UCLIBC_DIR)/.oldconfig
ifeq ($(BR2_MIPS_OABI),y)
	$(SED) 's/.*\(CONFIG_MIPS_O32_ABI\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_MIPS_EABI),y)
	$(SED) 's/.*\(CONFIG_MIPS_N32_ABI\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_MIPS_ABI64),y)
	$(SED) 's/.*\(CONFIG_MIPS_N64_ABI\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_mips_1),y)
	$(SED) 's/.*\(CONFIG_MIPS_ISA_1\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_mips_2),y)
	$(SED) 's/.*\(CONFIG_MIPS_ISA_2\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_mips_3),y)
	$(SED) 's/.*\(CONFIG_MIPS_ISA_3\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_mips_4),y)
	$(SED) 's/.*\(CONFIG_MIPS_ISA_4\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_mips_32),y)
	$(SED) 's/.*\(CONFIG_MIPS_ISA_MIPS32\)[^R].*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_mips_32r2),y)
	$(SED) 's/.*\(CONFIG_MIPS_ISA_MIPS32R2\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_mips_64),y)
	$(SED) 's/.*\(CONFIG_MIPS_ISA_MIPS64\).*/\1=y/' $(UCLIBC_DIR)/.oldconfig
endif
endif
ifeq ($(UCLIBC_TARGET_ARCH),sh)
	/bin/echo "# CONFIG_SH2A is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_SH2 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_SH3 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_SH4 is not set" >> $(UCLIBC_DIR)/.oldconfig
ifeq ($(BR2_sh2a),y)
	$(SED) 's,# CONFIG_SH2A is not set,CONFIG_SH2A=y,g' $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_FDPIC_ELF is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_FLAT is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_FLAT_SEP_DATA is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_SHARED_FLAT is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_sh2),y)
	$(SED) 's,# CONFIG_SH2 is not set,CONFIG_SH2=y,g' $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_FDPIC_ELF is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_FLAT is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_FLAT_SEP_DATA is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# UCLIBC_FORMAT_SHARED_FLAT is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_sh3eb),y)
	$(SED) 's,# CONFIG_SH3 is not set,CONFIG_SH3=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_sh3),y)
	$(SED) 's,# CONFIG_SH3 is not set,CONFIG_SH3=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_sh4eb),y)
	$(SED) 's,# CONFIG_SH4 is not set,CONFIG_SH4=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_sh4),y)
	$(SED) 's,# CONFIG_SH4 is not set,CONFIG_SH4=y,g' $(UCLIBC_DIR)/.oldconfig
endif
endif
ifeq ($(UCLIBC_TARGET_ARCH),sparc)
	$(SED) 's/^\(CONFIG_[^_]*[_]*SPARC[^=]*\)=.*/# \1 is not set/g' \
		 $(UCLIBC_DIR)/.oldconfig
	for i in V7 V8 V9 V9B; do echo "# CONFIG_SPARC_$$i is not set"; done \
		>> $(UCLIBC_DIR)/.oldconfig
	$(SED) 's/^.*$(UCLIBC_SPARC_TYPE)[^B].*/$(UCLIBC_SPARC_TYPE)=y/g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(UCLIBC_TARGET_ARCH),powerpc)
ifeq ($(BR2_powerpc_8540)$(BR2_powerpc_8548)$(BR2_powerpc_e500mc),y)
	/bin/echo "# CONFIG_CLASSIC is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "CONFIG_E500=y" >> $(UCLIBC_DIR)/.oldconfig
else
	/bin/echo "CONFIG_CLASSIC=y" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_E500 is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
endif
ifeq ($(UCLIBC_TARGET_ARCH),avr32)
	/bin/echo "LINKRELAX=y" >> $(UCLIBC_DIR)/.oldconfig
endif
ifneq ($(UCLIBC_TARGET_ENDIAN),)
	# The above doesn't work for me, so redo
	$(SED) 's/.*\(ARCH_$(UCLIBC_NOT_TARGET_ENDIAN)_ENDIAN\).*/# \1 is not set/g' \
		-e 's/.*\(ARCH_WANTS_$(UCLIBC_NOT_TARGET_ENDIAN)_ENDIAN\).*/# \1 is not set/g' \
		-e 's/.*\(ARCH_$(UCLIBC_TARGET_ENDIAN)_ENDIAN\).*/\1=y/g' \
		-e 's/.*\(ARCH_WANTS_$(UCLIBC_TARGET_ENDIAN)_ENDIAN\).*/\1=y/g' \
		$(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_LARGEFILE),y)
	$(SED) 's,.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=y,g' $(UCLIBC_DIR)/.oldconfig
else
	$(SED) 's,.*UCLIBC_HAS_LFS.*,UCLIBC_HAS_LFS=n,g' $(UCLIBC_DIR)/.oldconfig
	$(SED) '/.*UCLIBC_HAS_FOPEN_LARGEFILE_MODE.*/d' $(UCLIBC_DIR)/.oldconfig
	echo "# UCLIBC_HAS_FOPEN_LARGEFILE_MODE is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_INET_IPV6),y)
	$(SED) 's,^.*UCLIBC_HAS_IPV6.*,UCLIBC_HAS_IPV6=y,g' $(UCLIBC_DIR)/.oldconfig
else
	$(SED) 's,^.*UCLIBC_HAS_IPV6.*,UCLIBC_HAS_IPV6=n,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_INET_RPC),y)
	$(SED) 's,^.*UCLIBC_HAS_RPC.*,UCLIBC_HAS_RPC=y,g' \
		-e 's,^.*UCLIBC_HAS_FULL_RPC.*,UCLIBC_HAS_FULL_RPC=y,g' \
		-e 's,^.*UCLIBC_HAS_REENTRANT_RPC.*,UCLIBC_HAS_REENTRANT_RPC=y,g' \
		$(UCLIBC_DIR)/.oldconfig
else
	$(SED) 's,^.*UCLIBC_HAS_RPC.*,UCLIBC_HAS_RPC=n,g' \
		-e 's,^.*UCLIBC_HAS_FULL_RPC.*,UCLIBC_HAS_FULL_RPC=n,g' \
		-e 's,^.*UCLIBC_HAS_REENTRANT_RPC.*,UCLIBC_HAS_REENTRANT_RPC=n,g' \
		$(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_SOFT_FLOAT),y)
	$(SED) 's,.*UCLIBC_HAS_FPU.*,UCLIBC_HAS_FPU=n,g' \
		-e 's,^[^_]*HAS_FPU.*,HAS_FPU=n,g' \
		-e 's,.*UCLIBC_HAS_FLOATS.*,UCLIBC_HAS_FLOATS=y,g' \
		-e 's,.*DO_C99_MATH.*,DO_C99_MATH=y,g' \
		$(UCLIBC_DIR)/.oldconfig
	#$(SED) 's,.*UCLIBC_HAS_FPU.*,UCLIBC_HAS_FPU=n\nHAS_FPU=n\nUCLIBC_HAS_FLOATS=y\nUCLIBC_HAS_SOFT_FLOAT=y,g' $(UCLIBC_DIR)/.oldconfig
else
	$(SED) '/UCLIBC_HAS_FLOATS/d' \
		-e 's,.*UCLIBC_HAS_FPU.*,UCLIBC_HAS_FPU=y\nHAS_FPU=y\nUCLIBC_HAS_FLOATS=y\n,g' \
		$(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_USE_SSP),y)
	$(SED) 's,^.*UCLIBC_HAS_SSP[^_].*,UCLIBC_HAS_SSP=y,g' $(UCLIBC_DIR)/.oldconfig
else
	$(SED) 's,^.*UCLIBC_HAS_SSP[^_].*,UCLIBC_HAS_SSP=n,g' $(UCLIBC_DIR)/.oldconfig
endif
	$(SED) '/UCLIBC_HAS_THREADS/d' $(UCLIBC_DIR)/.oldconfig
	$(SED) '/LINUXTHREADS/d' $(UCLIBC_DIR)/.oldconfig
	$(SED) '/LINUXTHREADS_OLD/d' $(UCLIBC_DIR)/.oldconfig
	$(SED) '/PTHREADS_DEBUG_SUPPORT/d' $(UCLIBC_DIR)/.oldconfig
	$(SED) '/UCLIBC_HAS_THREADS_NATIVE/d' $(UCLIBC_DIR)/.oldconfig
ifeq ($(BR2_PTHREADS_NONE),y)
	echo "# UCLIBC_HAS_THREADS is not set" >> $(UCLIBC_DIR)/.oldconfig
else
	echo "UCLIBC_HAS_THREADS=y" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_PTHREADS),y)
	echo "LINUXTHREADS=y" >> $(UCLIBC_DIR)/.oldconfig
	echo "LINUXTHREADS_NEW=y" >> $(UCLIBC_DIR)/.oldconfig
else
	echo "# LINUXTHREADS is not set" >> $(UCLIBC_DIR)/.oldconfig
	echo "# LINUXTHREADS_NEW is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_PTHREADS_OLD),y)
	echo "LINUXTHREADS_OLD=y" >> $(UCLIBC_DIR)/.oldconfig
else
	echo "# LINUXTHREADS_OLD is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_PTHREADS_NATIVE),y)
	echo "UCLIBC_HAS_THREADS_NATIVE=y" >> $(UCLIBC_DIR)/.oldconfig
else
	echo "# UCLIBC_HAS_THREADS_NATIVE is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_PTHREAD_DEBUG),y)
	echo "PTHREADS_DEBUG_SUPPORT=y" >> $(UCLIBC_DIR)/.oldconfig
else
	echo "# PTHREADS_DEBUG_SUPPORT is not set" >> $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_ENABLE_LOCALE),y)
	$(SED) 's,^.*UCLIBC_HAS_LOCALE.*,UCLIBC_HAS_LOCALE=y\n# UCLIBC_BUILD_ALL_LOCALE is not set\nUCLIBC_BUILD_MINIMAL_LOCALE=y\nUCLIBC_BUILD_MINIMAL_LOCALES="$(UCLIBC_LOCALES)"\nUCLIBC_PREGENERATED_LOCALE_DATA=n\nUCLIBC_DOWNLOAD_PREGENERATED_LOCALE_DATA=n\nUCLIBC_HAS_XLOCALE=y\nUCLIBC_HAS_GLIBC_DIGIT_GROUPING=n\n,g' $(UCLIBC_DIR)/.oldconfig
else
	$(SED) 's,^.*UCLIBC_HAS_LOCALE.*,UCLIBC_HAS_LOCALE=n,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_USE_WCHAR),y)
	$(SED) 's,^.*UCLIBC_HAS_WCHAR.*,UCLIBC_HAS_WCHAR=y,g' $(UCLIBC_DIR)/.oldconfig
else
	$(SED) 's,^.*UCLIBC_HAS_WCHAR.*,UCLIBC_HAS_WCHAR=n,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ("$(KERNEL_ARCH)","i386")
	/bin/echo "# CONFIG_GENERIC_386 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_386 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_486 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_586 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_586MMX is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_686 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_PENTIUMII is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_PENTIUMIII is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_PENTIUM4 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_K6 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_K7 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_ELAN is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_CRUSOE is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_WINCHIPC6 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_WINCHIP2 is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_CYRIXIII is not set" >> $(UCLIBC_DIR)/.oldconfig
	/bin/echo "# CONFIG_NEHEMIAH is not set" >> $(UCLIBC_DIR)/.oldconfig
ifeq ($(BR2_x86_i386),y)
	$(SED) 's,# CONFIG_386 is not set,CONFIG_386=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_i486),y)
	$(SED) 's,# CONFIG_486 is not set,CONFIG_486=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_i586),y)
	$(SED) 's,# CONFIG_586 is not set,CONFIG_586=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_pentium_mmx),y)
	$(SED) 's,# CONFIG_586MMX is not set,CONFIG_586MMX=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_i686),y)
	$(SED) 's,# CONFIG_686 is not set,CONFIG_686=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_pentiumpro),y)
	$(SED) 's,# CONFIG_686 is not set,CONFIG_686=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_pentium2),y)
	$(SED) 's,# CONFIG_PENTIUMII is not set,CONFIG_PENTIUMII=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_pentium3),y)
	$(SED) 's,# CONFIG_PENTIUMIII is not set,CONFIG_PENTIUMIII=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_pentium4),y)
	$(SED) 's,# CONFIG_PENTIUM4 is not set,CONFIG_PENTIUM4=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_pentium_m),y)
	$(SED) 's,# CONFIG_PENTIUM4 is not set,CONFIG_PENTIUM4=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_nocona),y)
	$(SED) 's,# CONFIG_PENTIUM4 is not set,CONFIG_PENTIUM4=y,g' $(UCLIBC_DIR)/.oldconfig
endif
ifeq ($(BR2_x86_core2),y)
	$(SED) 's,# CONFIG_PENTIUM4 is not set,CONFIG_PENTIUM4=y,g' $(UCLIBC_DIR)/.oldconfig
endif
endif

$(UCLIBC_DIR)/.config: $(UCLIBC_DIR)/.oldconfig
	cp -f $(UCLIBC_DIR)/.oldconfig $(UCLIBC_DIR)/.config
	mkdir -p $(TOOLCHAIN_DIR)/uClibc_dev/usr/include
	mkdir -p $(TOOLCHAIN_DIR)/uClibc_dev/usr/lib
	mkdir -p $(TOOLCHAIN_DIR)/uClibc_dev/lib
	$(MAKE1) -C $(UCLIBC_DIR) \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(TOOLCHAIN_DIR)/uClibc_dev/ \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(TOOLCHAIN_DIR)/uClibc_dev/ \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		UCLIB_EXTRA_CFLAGS="$(TARGET_ABI)" \
		HOSTCC="$(HOSTCC)" \
		oldconfig
	touch $@

ifeq ($(BR2_CCACHE),y)
# we'll need ccache for the host built before make oldconfig
# if configured, otherwise uclibc-menuconfig will fail.
# Use order-only dependency as host-ccache is a virtual target
$(UCLIBC_DIR)/.config: | host-ccache
endif

$(UCLIBC_DIR)/.configured: $(LINUX_HEADERS_DIR)/.configured $(UCLIBC_DIR)/.config
	$(MAKE1) -C $(UCLIBC_DIR) \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(TOOLCHAIN_DIR)/uClibc_dev/ \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(TOOLCHAIN_DIR)/uClibc_dev/ \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		UCLIB_EXTRA_CFLAGS="$(TARGET_ABI)" \
		HOSTCC="$(HOSTCC)" headers \
		lib/crt1.o lib/crti.o lib/crtn.o \
		install_headers
	# Install the kernel headers to the first stage gcc include dir
	# if necessary
	if [ ! -f $(TOOLCHAIN_DIR)/uClibc_dev/usr/include/linux/version.h ]; then \
		cp -pLR $(LINUX_HEADERS_DIR)/include/* \
			$(TOOLCHAIN_DIR)/uClibc_dev/usr/include/; \
	fi
	$(TARGET_CROSS)gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $(TOOLCHAIN_DIR)/uClibc_dev/usr/lib/libc.so
	$(TARGET_CROSS)gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $(TOOLCHAIN_DIR)/uClibc_dev/usr/lib/libm.so
	cp -pLR $(UCLIBC_DIR)/lib/crt[1in].o $(TOOLCHAIN_DIR)/uClibc_dev/usr/lib/
	touch $@

$(UCLIBC_DIR)/lib/libc.a: $(UCLIBC_DIR)/.configured $(gcc_intermediate) $(LIBFLOAT_TARGET)
	$(MAKE1) -C $(UCLIBC_DIR) \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX= \
		DEVEL_PREFIX=/ \
		RUNTIME_PREFIX=/ \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		UCLIB_EXTRA_CFLAGS="$(TARGET_ABI)" \
		HOSTCC="$(HOSTCC)" \
		all
	touch -c $@

uclibc-menuconfig: dirs $(UCLIBC_DIR)/.config
	$(MAKE1) -C $(UCLIBC_DIR) \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(TOOLCHAIN_DIR)/uClibc_dev/ \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=$(TOOLCHAIN_DIR)/uClibc_dev/ \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		UCLIB_EXTRA_CFLAGS="$(TARGET_ABI)" \
		HOSTCC="$(HOSTCC)" \
		menuconfig && \
	touch -c $(UCLIBC_DIR)/.config


$(STAGING_DIR)/usr/lib/libc.a: $(UCLIBC_DIR)/lib/libc.a
	$(MAKE1) -C $(UCLIBC_DIR) \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(STAGING_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		UCLIB_EXTRA_CFLAGS="$(TARGET_ABI)" \
		install_runtime install_dev
	# Install the kernel headers to the staging dir if necessary
	if [ ! -f $(STAGING_DIR)/usr/include/linux/version.h ]; then \
		cp -pLR $(LINUX_HEADERS_DIR)/include/* \
			$(STAGING_DIR)/usr/include/; \
	fi
	# Build the host utils. Need to add an install target...
	$(MAKE1) -C $(UCLIBC_DIR)/utils \
		PREFIX=$(HOST_DIR) \
		HOSTCC="$(HOSTCC)" \
		hostutils
	if [ -f $(UCLIBC_DIR)/utils/ldd.host ]; then \
		install -D $(UCLIBC_DIR)/utils/ldd.host $(HOST_DIR)/usr/bin/ldd; \
		ln -sf ldd $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-ldd; \
	fi
	if [ -f $(UCLIBC_DIR)/utils/ldconfig.host ]; then \
		install -D $(UCLIBC_DIR)/utils/ldconfig.host $(HOST_DIR)/usr/bin/ldconfig; \
		ln -sf ldconfig $(HOST_DIR)/usr/bin/$(GNU_TARGET_NAME)-ldconfig; \
	fi
	touch -c $@

ifneq ($(TARGET_DIR),)
$(TARGET_DIR)/lib/libc.so.0: $(STAGING_DIR)/usr/lib/libc.a
	$(MAKE1) -C $(UCLIBC_DIR) \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		UCLIB_EXTRA_CFLAGS="$(TARGET_ABI)" \
		install_runtime
	touch -c $@

$(TARGET_DIR)/usr/bin/ldd: $(cross_compiler)
	$(MAKE1) -C $(UCLIBC_DIR) CC=$(TARGET_CROSS)gcc \
		CPP=$(TARGET_CROSS)cpp LD=$(TARGET_CROSS)ld \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(TARGET_DIR) utils install_utils
	touch -c $@

ifneq ($(BR2_PREFER_STATIC_LIB),y)
UCLIBC_TARGETS=$(TARGET_DIR)/lib/libc.so.0
endif

ifeq ($(BR2_UCLIBC_INSTALL_TEST_SUITE),y)
UCLIBC_TARGETS+=uclibc-test
endif
endif

uclibc: $(gcc_intermediate) $(STAGING_DIR)/usr/lib/libc.a $(UCLIBC_TARGETS)

uclibc-source: $(DL_DIR)/$(UCLIBC_SOURCE)

uclibc-unpacked: $(UCLIBC_DIR)/.unpacked

uclibc-config: $(UCLIBC_DIR)/.config

uclibc-oldconfig: $(UCLIBC_DIR)/.oldconfig

uclibc-update-config: uclibc-config
	cp -f $(UCLIBC_DIR)/.config $(UCLIBC_CONFIG_FILE)

uclibc-configured: gcc_initial kernel-headers $(UCLIBC_DIR)/.configured

uclibc-configured-source: uclibc-source

uclibc-clean: uclibc-test-clean
	-$(MAKE1) -C $(UCLIBC_DIR) ARCH="$(UCLIBC_TARGET_ARCH)" clean
	rm -f $(UCLIBC_DIR)/.config

uclibc-dirclean: uclibc-test-dirclean
	rm -rf $(UCLIBC_DIR)

uclibc-target-utils: $(TARGET_DIR)/usr/bin/ldd

uclibc-target-utils-source: $(DL_DIR)/$(UCLIBC_SOURCE)

$(UCLIBC_DIR)/test/unistd/errno:
	$(MAKE) -C $(UCLIBC_DIR)/test \
	ARCH_CFLAGS=-I$(STAGING_DIR)/usr/include \
	UCLIBC_ONLY=1 TEST_INSTALLED_UCLIBC=1 compile

$(TARGET_DIR)/root/uClibc/test/unistd/errno: $(UCLIBC_DIR)/test/unistd/errno
	mkdir -p $(TARGET_DIR)/root/uClibc
	cp -rdpf $(UCLIBC_DIR)/test $(TARGET_DIR)/root/uClibc
	$(INSTALL) $(UCLIBC_DIR)/Rules.mak $(TARGET_DIR)/root/uClibc
	$(INSTALL) $(UCLIBC_DIR)/.config $(TARGET_DIR)/root/uClibc

uclibc-test: $(STAGING_DIR)/usr/lib/libc.a $(TARGET_DIR)/root/uClibc/test/unistd/errno

uclibc-test-source: uclibc-source

uclibc-test-clean:
	-$(MAKE) -C $(UCLIBC_DIR)/test clean
	rm -rf $(TARGET_DIR)/root/uClibc

uclibc-test-dirclean:
	rm -rf $(TARGET_DIR)/root/uClibc

#############################################################
#
# uClibc for the target just needs its header files
# and whatnot installed.
#
#############################################################

$(TARGET_DIR)/usr/lib/libc.a: $(STAGING_DIR)/usr/lib/libc.a
	$(MAKE1) -C $(UCLIBC_DIR) \
		ARCH="$(UCLIBC_TARGET_ARCH)" \
		PREFIX=$(TARGET_DIR) \
		DEVEL_PREFIX=/usr/ \
		RUNTIME_PREFIX=/ \
		install_dev
	# Install the kernel headers to the target dir if necessary
	if [ ! -f $(TARGET_DIR)/usr/include/linux/version.h ]; then \
		cp -pLR $(LINUX_HEADERS_DIR)/include/* \
			$(TARGET_DIR)/usr/include/; \
	fi
	touch -c $@

uclibc_target: cross_compiler uclibc $(TARGET_DIR)/usr/lib/libc.a $(TARGET_DIR)/usr/bin/ldd

uclibc_target-clean: uclibc-test-clean
	rm -rf $(TARGET_DIR)/usr/include \
		$(TARGET_DIR)/usr/lib/libc.a $(TARGET_DIR)/usr/bin/ldd

uclibc_target-dirclean: uclibc-test-dirclean
	rm -rf $(TARGET_DIR)/usr/include

endif
