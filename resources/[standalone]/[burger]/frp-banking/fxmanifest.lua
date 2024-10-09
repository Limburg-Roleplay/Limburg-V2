shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'JTM-DEVELOPMENT'
description 'FRP-Banking gereworked voor Tilburg Roleplay'

ui_page 'html/ui.html'
files { 'html/ui.html' , 'html/pricedown.ttf' , 'html/logo.png' , 'html/styles.css' , 'html/scripts.js' , 'html/debounce.min.js'}
client_scripts { 'config.lua', 'client/*.lua' }
server_scripts { 'config.lua', '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
shared_script {'@es_extended/imports.lua'}