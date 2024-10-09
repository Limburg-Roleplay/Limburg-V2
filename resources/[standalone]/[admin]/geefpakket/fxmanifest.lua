shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'

lua54 'yes'
game 'gta5'

description 'JTM-Development Resources'

version '1.2.0'
server_scripts {
    '@es_extended/imports.lua',
	'@oxmysql/lib/MySQL.lua',
    'config.lua',
	'server.lua'
}