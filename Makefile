include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ttyd
PKG_VERSION:=0.0.1
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Harry Gabriel <rootdesign@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-ttyd
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=ttyd LuCI interface
	PKGARCH:=all
	DEPENDS:=+ttyd
endef

define Package/luci-app-ttyd/description
	LuCI Support for ttyd.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-ttyd/postrm
#!/bin/sh
rm -f /tmp/luci-indexcache
exit 0
endef


define Package/luci-app-ttyd/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/controller/ttyd.lua $(1)/usr/lib/lua/luci/controller/ttyd.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luasrc/model/cbi/ttyd.lua $(1)/usr/lib/lua/luci/model/cbi/ttyd.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/ttyd
	$(INSTALL_DATA) ./luasrc/view/ttyd/overview.htm $(1)/usr/lib/lua/luci/view/ttyd/overview.htm

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./root/etc/config/ttyd $(1)/etc/config/ttyd

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/ttyd $(1)/etc/init.d/ttyd
endef

$(eval $(call BuildPackage,luci-app-ttyd))