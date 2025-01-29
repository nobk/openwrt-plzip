#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=plzip
PKG_VERSION:=1.12
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.savannah.gnu.org/releases/lzip/$(PKG_NAME)
PKG_HASH:=50d71aad6fa154ad8c824279e86eade4bcf3bb4932d757d8f281ac09cfadae30
PKG_MAINTAINER:=
PKG_LICENSE:=GPL-2.0-or-later

include $(INCLUDE_DIR)/uclibc++.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/plzip
	SECTION:=utils
	CATEGORY:=Utilities
	SUBMENU:=Compression
	TITLE:=A massively parallel \(multi-threaded\) implementation of lzip
	URL:=https://www.nongnu.org/lzip/plzip.html
	DEPENDS:= $(CXX_DEPENDS) +lzlib +libpthread
endef

define Package/plzip/description
 Plzip is a massively parallel (multi-threaded) implementation of lzip, fully compatible with lzip 1.4 or newer. Plzip uses the lzlib compression library.
 Lzip is a lossless data compressor with a user interface similar to the one of gzip or bzip2. Lzip can compress about as fast as gzip (lzip -0) or compress most files more than bzip2 (lzip -9). Decompression speed is intermediate between gzip and bzip2. Lzip is better than gzip and bzip2 from a data recovery perspective. Lzip has been designed, written, and tested with great care to replace gzip and bzip2 as the standard general-purpose compressed format for unix-like systems.
endef

HOST_BUILD_DEPENDS:=lzlib/host
HOST_CONFIGURE_ARGS += \
        CXXFLAGS+="-I$(STAGING_DIR_HOSTPKG)/include" \
	LDFLAGS="-L$(STAGING_DIR_HOSTPKG)/lib"

CONFIGURE_VARS += CXXFLAGS="$$$$CXXFLAGS -fno-rtti"

define Package/plzip/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin
	$(TOOLCHAIN_DIR)/bin/$(TARGET_CROSS)strip -s $(1)/usr/bin/$(PKG_NAME)
	$(LN) -s $(PKG_NAME) $(1)/usr/bin/lzip
endef

define Host/Install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/$(PKG_NAME) $(STAGING_DIR_HOST)/bin/
	$(STAGING_DIR_HOST)/bin/sstrip $(STAGING_DIR_HOST)/bin/$(PKG_NAME)
endef

$(eval $(call BuildPackage,plzip))
$(eval $(call HostBuild))
