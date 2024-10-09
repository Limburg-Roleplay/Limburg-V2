shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'
client_script 'client.lua'
server_scripts {
    'config.lua',
    'server.lua'
}
shared_script '@es_extended/imports.lua'server_scripts { '@mysql-async/lib/MySQL.lua' }