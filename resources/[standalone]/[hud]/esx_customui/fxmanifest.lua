shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'bodacious'

game 'gta5'

description 'FiveM Custom UI for ESX'

ui_page 'html/ui.html'

client_scripts {
	'@es_extended/locale.lua',
	'client.lua'
}

files {
	-- Main Files
	'html/ui.html',
	'html/style.css',
	'html/grid.css',
	'html/main.js',
	'html/jquery-ui.min.js',
	-- UI Images
	'html/img/*.png',
	-- Job Images
	'html/img/jobs/*.png',
}