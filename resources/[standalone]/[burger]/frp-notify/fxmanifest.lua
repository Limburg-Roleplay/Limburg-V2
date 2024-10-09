shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5' 
description 'Future frp-notify '
version '1.2'


client_scripts {
	'client.lua'
}

server_scripts {
	'server.lua'
}

ui_page "ui/ui.html"

files {
	"ui/css/*.css",
	"ui/js/*.js",
	"ui/sounds/*.ogg",
	"ui/ui.html"
}   

exports {
	'Alert'
}

server_exports {
	'Alert'
}