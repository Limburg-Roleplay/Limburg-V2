shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script "@fivemsecure/init.lua"
fx_version 'adamant'

game 'gta5'

author 'okok' -- Discord: okok#3488
description 'okokNotify'
version '1.0'

ui_page 'html/ui.html'

client_scripts {
	'client.lua',
}

files {
	'html/*.*'
}

export 'Alert'