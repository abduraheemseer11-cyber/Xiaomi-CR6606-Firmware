module("luci.controller.wrtmax.wifi-analyzer", package.seeall)

function index()
    entry({"admin", "wrtmax", "wifi-analyzer"},
        call("action_wifi-analyzer"),
        _("Wi-Fi Analyzer"),
        20).dependent = false
end

function action_wifi-analyzer()
    local http = require "luci.http"
    local sys = require "luci.sys"
    local util = require "luci.util"
    local action = http.formvalue("action") or "status"
    local result = ""
    local allowed = {status=true,scan=true,set=true,start=true,stop=true,check=true,
        install=true,create=true,restore=true,diagnose=true,fix=true,run=true,
        apply=true,merge=true,vlan=true,configure=true,block=true,limit=true,
        enable=true,disable=true}
    if allowed[action] then
        local arg = http.formvalue("arg") or ""
        if arg:match("^[%w%._:/%-]*$") then
            result = sys.exec("/usr/bin/wrtmax-wifi-analyzer " .. action ..
                (arg ~= "" and (" " .. util.shellquote(arg)) or "") .. " 2>&1")
        else result = "Invalid input." end
    else result = "Unsupported action." end
    luci.template.render("wrtmax/wifi-analyzer", {
        result=result, status=sys.exec("/usr/bin/wrtmax-wifi-analyzer status 2>&1")
    })
end
