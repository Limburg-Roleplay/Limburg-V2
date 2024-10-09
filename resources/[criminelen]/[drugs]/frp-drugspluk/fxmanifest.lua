shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version "adamant"
game "gta5"
lua54 "yes"
version "1.0.0"
description 'FRP-DRUGSPLUK JTM-DEVELOPMENT'

depedencies { "ox_lib", "ox_target", "ox_inventory" }
client_scripts { "src/client/*.lua" }
server_scripts { "shared.lua", "@oxmysql/lib/MySQL.lua", "src/server/*.lua" }
shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua" }
