shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
description "/bonus Script"
author "JTM-Development"
version "1.0.0"
client_scripts {
	'client/*.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}