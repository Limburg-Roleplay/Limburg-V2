shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
lua54 'yes'
games { 'gta5' }

client_scripts {
    'config.lua',
    'client_print.lua',
    'client_base.lua',
    'bones.lua',
    'weapons.lua'
}

server_scripts {
    'config.lua',
    'server.lua'
}

escrow_ignore {
	'config.lua',
    'bones.lua',
    'weapons.lua'
}

shared_scripts {
    "@es_extended/imports.lua",
    "@srp-boilerplate/import.lua"
}