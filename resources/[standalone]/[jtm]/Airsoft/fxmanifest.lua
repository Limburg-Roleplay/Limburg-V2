fx_version 'cerulean'

game 'gta5'
lua54 'yes'
author 'VanishedMC#6507'
description 'An advanced airsoft script with multiple gamemodes'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
	'config.lua',
	'shared/shared.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
    '@PolyZone/client.lua',
}