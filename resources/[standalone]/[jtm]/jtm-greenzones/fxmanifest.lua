shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Jamie'
description 'JTM-Development Greenzone/redzone script'
version '1.0.0'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    'config.lua',
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}