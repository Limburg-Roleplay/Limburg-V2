shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
author 'JTM-Development'
description 'JTM-Development Gangjob'
version '1.0'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
	"@es_extended/imports.lua",
	"config/config.lua",
	'@es_extended/locale.lua',
	'locales/*.lua', 
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'config/config.server.lua',
    'server/*.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/*.js',
    'html/css/*.css'
}

shared_script '@ox_lib/init.lua'

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

escrow_ignore {
	'configs/*.lua',
	'locales/*.lua',
	'html/index.html',
	'html/*.css',
	'html/*.js',
}