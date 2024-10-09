shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
use_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'
client_scripts { 'client/*.lua', 'config.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
shared_script { '@es_extended/imports.lua', '@ox_lib/init.lua' }