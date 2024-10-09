shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'
lua54 'yes'
description 'ESX Identity'
version '1.2.0'
shared_script '@ox_lib/init.lua'
server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'locales/en.lua',
	'locales/cs.lua',
	'locales/de.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/cs.lua',
	'locales/de.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}
ui_page 'html/index.html'
files {
	'html/index.html',
	'html/script.js',
	'html/style.css'
}
dependency 'es_extended'
server_scripts { '@mysql-async/lib/MySQL.lua' }