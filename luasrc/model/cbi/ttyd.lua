-- Copyright 2017 Harry Gabriel (rootdesign@gmail.com)
-- This is free software, licensed under the Apache License, Version 2.0

local fs = require("nixio.fs")
local util = require("luci.util")
local ttydcfg = "/etc/config/ttyd"

if not nixio.fs.access(ttydcfg) then
	m = SimpleForm("error", nil, translate("Input file not found, please check your configuration."))
	m.reset = false
	m.submit = false
	return m
end

m = Map("ttyd", translate("Configuration"))
s = m:section(TypedSection, "server")
s.addremove = false
s.anonymous = true

-- once
once = s:option(Flag, "once", translate("Once"), translate("Accept only one client and exit on disconnection"))
once.rmempty = true

-- shell
shells = s:option(ListValue, "shell", translate("Shell"), translate("Select shell"))
for i in string.gmatch(nixio.fs.readfile("/etc/shells"), "%S+") do
   shells:value(i)
end
shells.rmempty = false

-- port, -p              Port to listen (default: 7681, use `0` for random port)
port = s:option(Value, "port", translate("Port"), translate("Port to listen (default: 7681, use `0` for random port)"))
port.default = 7681
port.datatype = "port"
port.rmempty = true
port.placeholder = 7681

-- interface, -i         Network interface to bind (eg: eth0), or UNIX domain socket path (eg: /var/run/ttyd.sock)
iface = s:option(Value, "interface", translate("Interface"), translate("Network interface to bind (eg: eth0), or UNIX domain socket path (eg: /var/run/ttyd.sock)"))
iface.template    = "cbi/network_netlist"
iface.nocreate    = true
iface.unspecified = true
iface.nobridges = true
iface.optional = true

-- signal, -s            Signal to send to the command when exit it (default: SIGHUP)
signals = s:option(ListValue, "signal", translate("Signal"), translate("Signal to send to the command when exit it (default: SIGHUP)"))

local outfile = os.tmpname()
local errfile = os.tmpname()
local rv = os.execute("ttyd --signal-list >%s 2>%s" %{ outfile, errfile })

for i in string.gmatch(nixio.fs.readfile(outfile), "[^\r\n]+") do
   signals:value(string.match(i, "%u+") , string.sub(i, 4))
end
signals.rmempty = true
signals.optional = true

-- ssl, -S               Enable SSL
ssl = s:option(Flag, "ssl", translate("SSL"), translate("Enable SSL"))
ssl.rmempty = true

-- ssl-cert, -C          SSL certificate file path
ssl_cert = s:option(FileUpload,	"ssl_cert", "/etc/ttyd/ttyd.crt", translate("SSL certificate file path")):depends("ssl",1)

-- ssl-key, -K           SSL key file path
ssl_key = s:option(FileUpload,	"ssl_key", "/etc/ttyd/ttyd.key", translate("SSL key file path")):depends("ssl",1)

-- ssl-ca, -A            SSL CA file path for client certificate verification
ssl_ca = s:option(FileUpload,	"ssl_ca", "/etc/ttyd/ttyd.ca", translate("SSL CA file path for client certificate verification")):depends("ssl",1)

 -- reconnect, -r         Time to reconnect for the client in seconds (default: 10)
reconnect = s:option(Value, "reconnect", translate("Reconnect"), translate("Time to reconnect for the client in seconds (default: 10)"))
reconnect.datatype = "integer"
reconnect.rmempty = true
reconnect.placeholder = 10
reconnect.optional = true

-- readonly, -R          Do not allow clients to write to the TTY
readonly = s:option(Flag, "readonly", translate("Readonly"), translate("Do not allow clients to write to the TTY"))
readonly.rmempty = true
readonly.optional = true

-- check-origin, -O      Do not allow websocket connection from different origin
check_origin = s:option(Flag, "check_origin", translate("check-origin"), translate("Do not allow websocket connection from different origin"))
check_origin.rmempty = true
check_origin.optional = true

-- max-clients, -m       Maximum clients to support (default: 0, no limit)
max_clients = s:option(Value, "max_clients", translate("Maximum clients"), translate("Maximum clients to support (default: 0, no limit)"))
max_clients.datatype = "integer"
max_clients.rmempty = true
max_clients.placeholder = 0
max_clients.optional = true

-- credential, -c        Credential for Basic Authentication (format: username:password)
credential = s:option(Flag, "credential", translate("Use Basic Authentication"), translate("Credential for Basic Authentication"))
credential.rmempty = true

credential_username = s:option(Value, "username", translate("Username"), translate("Username for Basic Authentication"))
credential_username:depends("credential",1)
credential_username.rmempty = true

credential_password = s:option(Value, "password", translate("Password"), translate("Password for Basic Authentication"))
credential_password:depends("credential",1)
credential_password.rmempty = true

-- debug, -d             Set log level (default: 7)
debug = s:option(Value, "debug", translate("Debug"), translate("Set log level (default: 7)"))
debug.datatype = "integer"
debug.rmempty = true
debug.placeholder = "7"
debug.optional = true

-- uid, -u               User id to run with
uid = s:option(Value, "uid", translate("User id"), translate("User id to run with"))
uid.rmempty = true
uid.optional = true

-- gid, -g               Group id to run with
gid = s:option(Value, "gid", translate("Group id"), translate("Group id to run with"))
gid.rmempty = true
gid.optional = true

-- client-option, -t     Send option to client (format: key=value), repeat to add more options
client_option = s:option(Value, "client_option", translate("Client options"), translate("Send option to client (format: key=value), repeat to add more options"))
client_option.rmempty = true
client_option.optional = true

-- index, -I             Custom index.html path
index = s:option(Value, "index", translate("Custom index.html"), translate("Custom index.html path"))
index.rmempty = true
index.optional = true

return m
