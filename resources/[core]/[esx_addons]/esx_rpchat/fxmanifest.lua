shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'

fx_version 'adamant'
game 'gta5'
description 'ESX RP Chat'
version '1.0.0'
client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua'
}
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}