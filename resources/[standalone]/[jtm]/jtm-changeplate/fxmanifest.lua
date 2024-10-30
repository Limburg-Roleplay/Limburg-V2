shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'

author 'JTM-Development'
description 'Change Plate script'
version 'v1.1.1'

server_script {
    'server/*.lua',
}
client_scripts {
    'client/*.lua',
}

server_scripts { '@mysql-async/lib/MySQL.lua' }