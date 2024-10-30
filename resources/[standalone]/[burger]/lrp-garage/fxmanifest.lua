shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'
lua54 'yes'
description 'Future garages | XeaksRemakes'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'config.lua',
	'client/*.lua'
}

escrow_ignore {
    'config.lua'
}
dependency '/assetpacks'