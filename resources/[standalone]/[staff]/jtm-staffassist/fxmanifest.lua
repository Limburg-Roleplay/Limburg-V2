shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
games { 'gta5' }
author 'JTM-Development'
description "FRP-Staffassist JTM-Development"
use_fxv2_oal 'yes'
lua54 'yes'
client_scripts { 'client/*.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', '@ox_inventory/data/weapons.lua', 'config.lua', 'server/*.lua' }
shared_script { '@es_extended/imports.lua', '@ox_lib/init.lua' }