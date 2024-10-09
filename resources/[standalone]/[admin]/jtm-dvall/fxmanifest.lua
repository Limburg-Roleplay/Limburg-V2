shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
--------------------------------------
------Created By Whit3Xlightning------
--https://github.com/Whit3XLightning--
--------------------------------------

fx_version 'bodacious'
game 'gta5'

server_script {
    'config.lua',
    'server/server.lua'
}
client_scripts {
    'config.lua',
    'client/client.lua',
    'client/entityiter.lua'
}

