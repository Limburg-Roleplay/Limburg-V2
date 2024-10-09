shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5' 
client_scripts {
    'client.lua'
}

author 'JTM-Development'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'ui.html'

files {
    'ui.html',
    'ui.css',
    'ui.js',

}