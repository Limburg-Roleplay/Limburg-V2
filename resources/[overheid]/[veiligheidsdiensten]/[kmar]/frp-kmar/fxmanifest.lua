shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'FRP-Politie Gemaakt door JTM-DEVELOPMENT'
version '1.0'
client_scripts { 
    'client/*.lua',
    'config/*.lua'
}
server_scripts { 
    '@oxmysql/lib/MySQL.lua', 
    'server/*.lua',
    'config/*.lua'
}
shared_scripts { 
    '@es_extended/imports.lua', 
    '@ox_lib/init.lua' 
}