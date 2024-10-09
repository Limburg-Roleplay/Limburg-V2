shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'

lua54 'yes'
game 'gta5'

description 'JTM-Development Resources'

version '1.2.0'
shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua', 'shared/*.lua' }
server_scripts {
    '@es_extended/imports.lua',
	'@oxmysql/lib/MySQL.lua',
    'config.lua',
	'sv_scripts/*.lua',
}

client_scripts {
    '@es_extended/imports.lua',
	'@es_extended/locale.lua',
    'config.lua',
	'cl_scripts/*.lua',
}