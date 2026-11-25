local uci = require "luci.model.uci".cursor()
local sys = require "luci.sys"
local util = require "luci.util"
local db_path = uci:get("tg-notify", "main", "db_path") or ""

m = Map("tg-notify", translate("Telegram Notify"),
    translate("Send Telegram alerts when a new device connects to the network."))

s = m:section(NamedSection, "main", "bot", translate("Bot Settings"))

enabled = s:option(Flag, "enabled", translate("Enable"))
enabled.rmempty = false

token = s:option(Value, "token", translate("Bot Token"))
token.datatype = "string"

chat_id = s:option(Value, "chat_id", translate("Chat ID"))
chat_id.datatype = "string"

iface = s:option(ListValue, "interface", translate("Send via interface"),
    translate("Network interface for outgoing requests. Use to force traffic through VPN."))
iface:value("", translate("Default (system routing)"))
for _, dev in ipairs(sys.net.devices()) do
    iface:value(dev, dev)
end
iface.default = ""
iface.rmempty = true

start_timeout = s:option(Value, "start_timeout_sec", translate("Startup delay (seconds)"))
start_timeout.datatype = "uinteger"
start_timeout.default = 30
start_timeout.rmempty = false
start_timeout.description = translate("Delay processing after boot to avoid missing notifications due to network not ready")

main_label = s:option(Value, "main_label", translate("Main network label"))
guest_label = s:option(Value, "guest_label", translate("Guest network label"))

main_repeat = s:option(Value, "main_repeat_after_sec", translate("Repeat after (sec), Main"))
main_repeat.datatype = "uinteger"
main_repeat.default = "0"
main_repeat.description = translate("0 = notify only once per device in Main network.")

guest_repeat = s:option(Value, "guest_repeat_after_sec", translate("Repeat after (sec), Guest"))
guest_repeat.datatype = "uinteger"
guest_repeat.default = "0"
guest_repeat.description = translate("0 = notify only once per device in Guest network.")

template = s:option(TextValue, "template", translate("Message template for notification"))
template.rows = 8
template.wrap = "off"
template.rmempty = true
template.description = translate("Use variables: $NETNAME, $DATE, $HOST, $MAC, $IP.")

function template.cfgvalue(self, section)
    local val = self.map.uci:get("tg-notify", section, "template")
    if val then
        val = val:gsub("\\n", "\n")
    end
    return val
end

function template.write(self, section, value)
    if value then
        value = value:gsub("\r\n?", "\n")
        value = value:gsub("\n", "\\n")
    end
    self.map.uci:set("tg-notify", section, "template", value)
end


-- Test Notification
test_msg = s:option(Value, "_test_msg", translate("Test Message"))
test_msg.rmempty = false
test_msg.default = "Test message"
test_msg.template = "tg-notify/test_send"
function test_msg.write(self, section, value)
    return -- do not save to UCI
end

-- Hidden button to handle the submit action from the template
btn_test = s:option(Button, "_test_send", "")
btn_test.render = function() return "" end
function btn_test.write(self, section)
    local msg = self.map:formvalue("cbid.tg-notify.main._test_msg")
    if msg and #msg > 0 then
        sys.call(string.format("/usr/bin/tg-notify_send.sh %s >/dev/null 2>&1", util.shellquote(msg)))
    end
end

local import = s:option(Button, "_import", translate("Import current DHCP clients"),
    translate("Process active DHCPv4 leases from /tmp/dhcp.leases using the current notification settings."))
import.inputtitle = translate("Import clients")
import.inputstyle = "apply"
function import.write(self)
    if nixio.fs.access("/usr/bin/tg-notify_import.sh", "x") then
        sys.call("/usr/bin/tg-notify_import.sh </dev/null >/dev/null 2>&1 &")
        self.map.message = translate("Client import started. Refresh this page to see the updated database.")
    else
        self.map.message = translate("Client import requires an updated tg-notify package.")
    end
end

btn = s:option(Button, "_reset", translate("Forget all devices"))
btn.inputstyle = "reset"
function btn.write()
    nixio.fs.writefile(db_path, "")
end

db = s:option(TextValue, "_known_clients", translate("Known clients database"))
db.rows = 15
db.wrap = "off"
db.readonly = true

function db.cfgvalue(self, section)
    return nixio.fs.readfile(db_path) or ""
end

return m
