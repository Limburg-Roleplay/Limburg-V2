shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'

fx_version 'adamant'
game 'gta5'
description 'ESX RP Chat'
version '1.0.0'
client_scripts {
	'@esx_boilerplate/natives.lua',
	'@es_extended/locale.lua',
	'@esx_boilerplate/utils/lazy_esx.lua',
	'client/main.lua'
}
server_scripts {
	'@esx_boilerplate/natives_server.lua',
	'@anticheat/event_s.lua',
	'@esx_boilerplate/utils/lazy_esx.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}