shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'

game 'gta5'

author 'JTM-Development'
description 'JTM-Development | Drugsverwerk'

version '1.6.0'

lua54 'yes'

shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua' }

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/blip.lua',
	'client/ghb.lua',
	'client/meth.lua'
}

dependencies {
	'es_extended'
}