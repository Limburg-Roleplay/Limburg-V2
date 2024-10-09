shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'

lua54 'yes'
game 'gta5'

author 'JTM Development'
description 'Twitter Script'

version '1.2.0'
shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua'}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'client/*.lua',
}