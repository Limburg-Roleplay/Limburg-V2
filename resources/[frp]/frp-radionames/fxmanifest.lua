shared_script '@FIVEGUARD/ai_module_fg-obfuscated.js'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@frp-manualapi/shared_fg-obfuscated.lua'
shared_script '@frp-manualapi/ai_module_fg-obfuscated.lua'
shared_script '@frp-manualapi/ai_module_fg-obfuscated.js'
fx_version 'cerulean'
game 'gta5'
name 'JLRP-RadioList'
author 'Mahan#8183'
description 'JolbakLifeRP Radio List : List of players in each radio for pma-voice'
shared_scripts {
	'Config.lua',
}
ui_page "ui/index.html"
files {
	"ui/index.html"
}
server_script {
	"Server/*.lua"
}
client_script {
	"Client/*.lua"
}
