shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/imports.lua',
    'server.lua'
}

shared_script '@ox_lib/init.lua'

ui_page 'web/index.html'

files {
    'web/*.*'
}

shared_script 'config.lua'
