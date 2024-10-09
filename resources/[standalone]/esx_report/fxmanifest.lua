shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'
description 'esx_report'
version '1.0.0'
lua54 'yes'

client_script {
	'@esx_boilerplate/natives.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/nl.lua',
	'config.lua',
	'client.lua',
	
}

shared_scripts {'@ox_lib/init.lua'}

server_scripts {
	'@esx_boilerplate/natives_server.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/nl.lua',
	'config.lua',
	'server.lua',
	
}
server_scripts { '@mysql-async/lib/MySQL.lua' }