shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version "cerulean"

game "gta5"
lua54 'yes'

description "Future: Logger"

version "1.0"

client_scripts {
    'client.lua',
    'weapons.lua'
}

server_script 'server.lua'
server_exports {
    'createLog',
}