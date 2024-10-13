fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

version "1.0.0"

client_scripts { "@tdy-boilerplate/src/client/model_loader.lua", "src/client/*.lua" }
server_scripts { "shared/*.lua", "@oxmysql/lib/MySQL.lua", "src/server/*.lua" }
shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua" }