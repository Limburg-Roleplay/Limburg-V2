shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
-- Resource Metadata
-- Resource Metadata
fx_version 'bodacious'
games { 'gta5' }

author 'tijnn27'
version '1.0.0'

client_script "client/client.lua"
server_scripts { '@mysql-async/lib/MySQL.lua', 'config.lua', 'server/*.lua' ,
	'@es_extended/locale.lua',}