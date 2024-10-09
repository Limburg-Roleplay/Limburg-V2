shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'

lua54 'yes'
game 'gta5'

author 'okok#3488'
description 'okokRequests'

ui_page 'web/ui.html'

shared_scripts { '@ox_lib/init.lua' }

files {
	'web/*.*'
}

client_scripts {
	'client.lua',
}

server_scripts {
	'server.lua'
}

export 'requestMenu'

escrow_ignore {
	'server.lua',
	'client.lua'
}
dependency '/assetpacks'