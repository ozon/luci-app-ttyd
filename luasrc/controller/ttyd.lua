-- Copyright 2017 Harry Gabriel (rootdesign@gmail.com)
-- This is free software, licensed under the Apache License, Version 2.0

module("luci.controller.ttyd", package.seeall)

local fs = require("nixio.fs")
local util = require("luci.util")
local templ = require("luci.template")
local i18n = require("luci.i18n")

function index()
    if not nixio.fs.access("/etc/config/ttyd") then
        nixio.fs.writefile("/etc/config/ttyd", "")
    end

    entry({"admin", "system", "ttyd"}, firstchild(), _("Terminal"), 10).dependent = false
    --entry({"admin", "system", "ttyd", "overview"}, template("ttyd/overview"), _("Overview"), 10).leaf = true
    entry({"admin", "system", "ttyd", "overview"}, call("overview"), _("Overview"), 10).leaf = true
    --entry({"admin", "system", "ttyd", "logfile"}, call("overview"), _("View Logfile"), 20).leaf = true
    entry({"admin", "system", "ttyd", "config"}, cbi("ttyd"), _("Configure"), 20)
	entry({"admin", "system", "ttyd", "start"}, call("action_run"))

end


function overview()
	local is_running = luci.sys.exec("/etc/init.d/ttyd status")

    templ.render("ttyd/overview", {title = i18n.translate("Terminal"), is_running = tonumber(is_running)})

end

function action_run()
    local http = require "luci.http"
    local rv = luci.sys.exec("/etc/init.d/ttyd start")
    http.redirect(luci.dispatcher.build_url('admin/system/ttyd'))
end
