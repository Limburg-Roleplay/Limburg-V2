fx_version 'cerulean'

game 'gta5'

author 'okok#3488'
description 'okokBanking'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/img/*.*'
}

shared_scripts {
    'config.lua',
    'locales/*.lua',
	'@ox_lib/init.lua',
}

client_scripts {
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

lua54 'yes'

escrow_ignore {
	'locales/*.lua',
	'web/*.lua',
	'client.lua',
	'config.lua'
}