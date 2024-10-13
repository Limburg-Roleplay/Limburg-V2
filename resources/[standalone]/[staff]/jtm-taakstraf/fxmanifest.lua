shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'

fx_version 'cerulean'
game 'gta5' 
author 'JTM-Development'
version '1.0.0'
lua54 'yes'

shared_scripts { 
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js'
}