shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

author 'JTM-Development'
description 'JTM-Development Wapenwinkel'
version 'v1.0'

-- Discord.gg/jtm

lua54 'yes'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/*.css',
	'html/*.js',
	'html/img/*.png',
	'html/img/weapons/*.png',
	'html/img/attachments/*.png',
	'html/img/bullets/*.png',
	'html/img/overig/*.png',
}

shared_scripts {
	'configs/*.lua',
}

client_script 'client/main.lua'

server_script 'server/main.lua'

escrow_ignore {
	'configs/*.lua',
	'html/index.html',
	'html/*.css',
	'html/*.js',
	'html/img/*.png',
	'html/img/weapons/*.png',
	'html/img/attachments/*.png',
	'html/img/bullets/*.png',
	'html/img/overig/*.png',
}