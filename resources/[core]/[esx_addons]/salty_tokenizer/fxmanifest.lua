shared_script '@FIVEGUARD/ai_module_fg-obfuscated.js'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

description 'Add security tokens to server events.'

dependency "yarn"

client_scripts {
	'config.lua',
	'client.lua'
}

server_scripts {
	'uuid.js',
	'config.lua',
	'server.lua'
}

exports {
	'setupClientResource'
}

server_exports {
	'generateToken',
	'setupServerResource',
	'secureServerEvent',
	'getResourceToken'
}

file 'init.lua'
