shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'FRP Jobmenu'
version '1.0'
client_scripts { 'config.lua', 'client/*.lua' }
server_scripts { 'config.lua', '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua', 'locales/*.lua' }

escrow_ignore {
    'config.lua'
}