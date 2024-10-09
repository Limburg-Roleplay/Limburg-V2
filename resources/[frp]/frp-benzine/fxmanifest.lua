shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
description 'FRP-BENZINE JTM-DEVELOPMENT'
fx_version 'adamant'
lua54 'yes'
game 'gta5'
ui_page 'html/index.html'
client_scripts { 'config.lua', 'client/*.lua' }
server_scripts { 'config.lua', '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua' }
files { 'html/index.html', 'html/js/*.js', 'html/css/*.css' }