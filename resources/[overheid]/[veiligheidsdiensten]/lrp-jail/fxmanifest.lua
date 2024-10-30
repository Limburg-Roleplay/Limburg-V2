fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "Limburg Roleplay - Sinan Abi"
description "Limburg Roleplay Jail Script - Sinan Abi"

server_script 'server/server.lua'

client_scripts {
	'client/utils.lua',
	'client/client.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js'
}

exports {
	'OpenJailMenu'
}