shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"

version '1.0.0'
description 'Future frp-nuiblocker '

shared_script {
    'config/config.general.lua',
    'config/config.shared.lua',
    'config/config.function.lua',
}

server_script {
    'server/main.lua',
}

client_scripts {
    "client/main.lua"
}

ui_page "client/html/index.html"

files {
    "client/html/index.html",
    "client/html/js/*.js",
}