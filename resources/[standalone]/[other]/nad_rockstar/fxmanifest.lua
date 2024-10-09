shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
name 'nad_rockstar'
description 'Rockstar Editor script, made by Nad#1223.'
author 'Nad#1223'
game 'gta5'

client_scripts {
    '@menuv/menuv.lua',
    'config.lua',
    'cl_rockstar.lua'
}

server_scripts {
    'config.lua',
    'sv_rockstar.lua'
}

dependencies {
    'menuv'
}