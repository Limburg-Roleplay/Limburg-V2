shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
description 'Future frp-carwash '
fx_version 'adamant'
game 'gta5'
lua54 'yes'
client_scripts { 'config.lua', 'client/*.lua' }
server_scripts { 'config.lua', '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua' }