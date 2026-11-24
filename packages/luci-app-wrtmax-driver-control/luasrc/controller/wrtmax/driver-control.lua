module("luci.controller.wrtmax.driver-control", package.seeall)

function index()
    entry({"admin", "wrtmax", "driver-control"},
        call("action_driver-control"),
        _("Driver Control"),
        20).dependent = false
end

function action_driver-control()
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
            result = sys.exec("/usr/bin/wrtmax-driver " .. action ..
                (arg ~= "" and (" " .. util.shellquote(arg)) or "") .. " 2>&1")
        else result = "Invalid input." end
    else result = "Unsupported action." end
    luci.template.render("wrtmax/driver-control", {
        result=result, status=sys.exec("/usr/bin/wrtmax-driver status 2>&1")
    })
end
