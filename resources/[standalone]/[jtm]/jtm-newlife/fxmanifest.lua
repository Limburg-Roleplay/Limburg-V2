shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
lua54 'yes'
game 'gta5'
author 'JTM Development'
description 'Newlife Script'
version '1.2.0'
shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua'}
ui_page "html/index.html"
files { "html/*.html", "html/*.js", "html/*.css", "html/fonts/*.ttf" }
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'sv_scripts/*.lua',
}
client_scripts {
	'@es_extended/locale.lua',
	'cl_scripts/*.lua',
}