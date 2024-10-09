shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
lua54 'yes'
game 'gta5'

client_scripts { 'client/*.lua' }
server_scripts { '@frp-boilerplate/server/ratelimit.lua', '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua' }