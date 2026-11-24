module("luci.controller.wrtmax.dashboard", package.seeall)

function index()
    entry({"admin", "wrtmax", "dashboard"},
        call("action_dashboard"),
        _("Dashboard"),
        20).dependent = false
end

function action_dashboard()
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
            result = sys.exec("/usr/bin/wrtmax-dashboard " .. action ..
                (arg ~= "" and (" " .. util.shellquote(arg)) or "") .. " 2>&1")
        else result = "Invalid input." end
    else result = "Unsupported action." end
    luci.template.render("wrtmax/dashboard", {
        result=result, status=sys.exec("/usr/bin/wrtmax-dashboard status 2>&1")
    })
end
