shared_script '@fiveguard/ai_module_fg-obfuscated.lua'
shared_script '@fiveguard/shared_fg-obfuscated.lua'

fx_version 'adamant'
game 'gta5'

description 'esx_ktackle - enables tackling for cops'

version '1.0.0'

server_scripts {
	'config.lua',
	'@esx_boilerplate/utils/lazy_esx.lua',
	'server/main.lua',
}

client_scripts {
	'config.lua',
	'@esx_boilerplate/utils/lazy_esx.lua',
	'client/main.lua'
}server_scripts { '@mysql-async/lib/MySQL.lua' }server_scripts { '@mysql-async/lib/MySQL.lua' }