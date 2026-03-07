module("luci.controller.tg-notify", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/tg-notify") then
        return
    end
    entry({"admin", "services", "tg-notify"}, cbi("tg-notify"), _("New Device Notify"), 90).dependent = true
end
