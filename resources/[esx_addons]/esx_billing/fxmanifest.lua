shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'

description 'ESX Billing'

version '1.1.0'

client_scripts {
	'@esx_boilerplate/natives.lua',
	'@esx_boilerplate/utils/logger.lua',
	'@esx_boilerplate/utils/lazy_esx.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

dependency 'es_extended'