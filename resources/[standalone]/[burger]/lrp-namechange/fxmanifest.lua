shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'
version '1.0.0'
lua54 'yes'

author '!Jamie Discord: jamie_0001'
description 'LRP-Namechange'

dependencies {
    'ox_lib',
	'es_extended',
}

client_scripts {
	'@ox_lib/init.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'client/client.lua',
}

server_scripts {
	'@ox_lib/init.lua',
	'@oxmysql/lib/MySQL.lua',
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'server/server.lua',
}

shared_scripts {
    'config.lua'
}
