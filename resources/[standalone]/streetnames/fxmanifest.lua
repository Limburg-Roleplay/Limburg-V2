shared_script '@FIVEGUARD/ai_module_fg-obfuscated.js'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'

fx_version 'cerulean'
game "gta5"
ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/mic_click_on.ogg",
	"ui/mic_click_off.ogg",
	'ui/fonts/*.ttf',
}
shared_scripts {
	"config.lua",
}
client_scripts {
	"client.lua",
}
-- server_scripts {
-- 	"server.lua",
-- }
provide "tokovoip_script"