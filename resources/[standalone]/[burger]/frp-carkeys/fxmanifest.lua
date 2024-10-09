shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

author "!Jamie"
description "Carkey script JTM-Development"
version "1.0.0"

client_scripts { "src/client/*.lua" }
server_scripts { "@oxmysql/lib/MySQL.lua", "src/server/*.lua" }
shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua", "shared/*.lua" }