# openwrt-tg-notify
Sends Telegram message when a new DHCP client appears; deduplicates by MAC and NETWORK NAME.

Указать источник для плагина: https://andreqgav.github.io/openwrt-tg-notify/{версия}/{архитектура}
пример: https://andreqgav.github.io/openwrt-tg-notify/21.02/aarch64_cortex-a53

Поддерживаются версии 21.02 и 24.10

Установить публичный ключ пакета, чтобы доверять источнику плагинов

```
wget -O /tmp/key-build.pub \
  https://andreqgav.github.io/openwrt-tg-notify/key-build.pub

KEY_ID=$(usign -F -p /tmp/key-build.pub)

mkdir -p /etc/opkg/keys
cp /tmp/key-build.pub "/etc/opkg/keys/$KEY_ID"
```

Установить плагины tg-notify и luci-app-tg-notify

Для настройки необходимо создать своего бота в телеграмм и указать его токен и идентификатор чат с вами в конфигурации:

1. Создайте бота в телеграмме через @BotFather

2. Начните диалог с ботом

3. Узнайте идентификатор чата (в личном сообщение chat id = ваш идентификатор)

	Можно узанть отправив запрос GET https://api.telegram.org/bot{{notify_bot_token}}/getUpdates и в нем будет chat.id с вами

4. Установить параметры token, chat_id в /etc/config/tg-notify или используйте плагин luci-app-tg-notify и через LuCI сделайте это (Services->Telegram Notify)

После установки или переустановки сохраните настройки бота и нажмите **Import clients** в **Services → Telegram Notify**. Плагин обработает действующие аренды DHCPv4 из `/tmp/dhcp.leases` и отправит уведомления по обычным правилам. Импорт выполняется в фоне. Обновите страницу, чтобы увидеть записи в базе.
