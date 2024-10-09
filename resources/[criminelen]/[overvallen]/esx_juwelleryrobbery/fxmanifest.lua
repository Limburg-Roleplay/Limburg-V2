shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"

name "esx_juwelrobbery"
description "test"
author "Tijnn27"
version "1.0.0"

client_scripts {
	"config.lua",
	"client/*.lua"
}

server_scripts {
	"config.lua",
	"server/*.lua"
}
