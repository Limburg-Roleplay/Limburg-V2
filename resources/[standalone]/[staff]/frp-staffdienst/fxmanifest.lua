shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 "yes"

server_scripts{
    "config.lua",
    "server.lua"
}

client_scripts {
    "config.lua",
    "client.lua"
}

escrow_ignore {
    "config.lua"
}