shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
fx_version 'adamant'

game 'gta5'

author 'okok' -- Discord: okok#3488
description 'okokTextUI'
version '1.0'

ui_page 'web/ui.html'

client_scripts {
	'client.lua',
}

files {
	'web/*.*'
}

export 'Open'
export 'Close'