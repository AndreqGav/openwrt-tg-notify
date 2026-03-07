include $(TOPDIR)/rules.mk

PKG_NAME:=tg-notify
PKG_VERSION:=1.0.5
PKG_RELEASE:=1
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/tg-notify
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Telegram notification on new DHCP client
  DEPENDS:=+curl +libuci +libubox +flock
  VERSION:=$(PKG_VERSION)-r$(PKG_RELEASE)
endef

define Package/tg-notify/description
Sends Telegram message when a new DHCP client appears; deduplicates by MAC and NETWORK NAME.
endef

define Build/Compile
endef

define Package/tg-notify/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/tg-notify $(1)/etc/config/tg-notify

	$(INSTALL_DIR) $(1)/etc/hotplug.d/dhcp
	$(INSTALL_BIN) ./files/etc/hotplug.d/dhcp/90-tg-notify $(1)/etc/hotplug.d/dhcp/90-tg-notify

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/tg-notify_send.sh $(1)/usr/bin/tg-notify_send.sh

	$(INSTALL_DIR) $(1)/etc/tg-notify
	touch $(1)/etc/tg-notify/known_clients.db
endef

define Package/tg-notify/conffiles
/etc/tg-notify/known_clients.db
endef

$(eval $(call BuildPackage,tg-notify))
