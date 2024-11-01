fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

name "exios-nonwhitelistedjobs"
author "Exios Solutions | Exios Non Whitelisted Jobs"
version "1.0.0"
description "Custom made non-whitelistedjobs for ESX Legacy Servers made by Exios Solutions."

client_scripts { "shared/*.lua", "src/client/*.lua" }
server_scripts { "shared/*.lua", "@oxmysql/lib/MySQL.lua", "src/server/*.lua" }
shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua" }