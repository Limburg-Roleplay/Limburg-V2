shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

version "1.0.0"
author 'JTM-Development'
description "FRP-Luchtvaartdealer JTM-Development"

client_scripts { "src/client/*.lua" }
server_scripts { "shared/*.lua", "@oxmysql/lib/MySQL.lua", "src/server/*.lua" }
shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua" }

ui_page "src/html/index.html"
files { "src/html/*.html", "src/html/*.js", "src/html/*.css", "src/html/**/*.png", "src/html/fonts/*.ttf" }

escrow_ignore {
    'shared/shared.lua'
}