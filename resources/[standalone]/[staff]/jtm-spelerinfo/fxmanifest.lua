shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 "yes"
author "Jamie Discord:Jamie_0001"
description "Informatie over spelers"
version "1.0.0"
shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    '@ox_lib/init.lua'
}
client_scripts {
    "client/client.lua"
}
server_scripts {
    "server/server.lua",
    '@oxmysql/lib/MySQL.lua'
}
