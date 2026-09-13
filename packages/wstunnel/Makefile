include $(TOPDIR)/rules.mk

PKG_NAME:=wstunnel
PKG_VERSION:=10.7.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/erebe/wstunnel/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=016cc051c48159cbd7a2b172024ae70ca7e3db298022828fdcc6b7324aa62d85

PKG_MAINTAINER:=Jimmy Qin <sunnyqeen@gmail.com>
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=rust/host

include $(INCLUDE_DIR)/package.mk
include ../../lang/rust/rust-package.mk

define Package/wstunnel
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Tunnel traffic over Websocket or HTTP2
  URL:=https://github.com/erebe/wstunnel
  DEPENDS:=$(RUST_ARCH_DEPENDS)
endef

define Package/wstunnel/description
  Wstunnel uses the websocket protocol which is compatible with HTTP in order
  to bypass firewalls and proxies, allowing you to tunnel any TCP/UDP traffic.
endef

MAKE_PATH:=wstunnel-cli

CARGO_PKG_CONFIG_VARS+=BINDGEN_EXTRA_CLANG_ARGS="\
		--target=$(REAL_GNU_TARGET_NAME) \
		--sysroot=$(STAGING_DIR)/target-$(REAL_GNU_TARGET_NAME) \
		-I$(TOOLCHAIN_DIR)/include"

define Package/wstunnel/conffiles
/etc/config/wstunnel
endef

define Package/wstunnel/install
	# Install the binary
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/wstunnel $(1)/usr/bin/wstunnel

	# Install the service Init script
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/wstunnel.init $(1)/etc/init.d/wstunnel

	# Install the default UCI configuration template
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/wstunnel.conf $(1)/etc/config/wstunnel
endef

#$(eval $(call RustBinPackage,wstunnel))
$(eval $(call BuildPackage,wstunnel))
