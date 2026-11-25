# openwrt-tg-notify
Sends Telegram message when a new DHCP client appears; deduplicates by MAC and NETWORK NAME.

Указать источник для плагина: https://andreqgav.github.io/openwrt-tg-notify/

Поддерживаются версии 21.02 и 24.10

Установить плагины tg-notify и luci-app-tg-notify

Для настройки необходимо создать своего бота в телеграмм и указать его токен и идентификатор чат с вами в конфигурации:

1. Создайте бота в телеграмме через @BotFather

2. Начните диалог с ботом

3. Узнайте идентификатор чата (в личном сообщение chat id = ваш идентификатор)

	Можно узанть отправив запрос GET https://api.telegram.org/bot{{notify_bot_token}}/getUpdates и в нем будет chat.id с вами

4. Установить параметры token, chat_id в /etc/config/tg-notify или используйте плагин luci-app-tg-notify и через LuCI сделайте это (Services->Telegram Notify)
