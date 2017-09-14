include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for ttyd
LUCI_DEPENDS:=+ttyd
LUCI_PKGARCH:=all

include ../../luci.mk
