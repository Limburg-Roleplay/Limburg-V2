shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
-- fxmanifest.lua

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Matthijs'
description 'Script voor staffnames weergave boven spelers'
version '1.0.0'

-- Client-side scripts
client_scripts {
    'client.lua'
}

-- Server-side scripts
server_scripts {
    'server.lua'
}

shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua" }
