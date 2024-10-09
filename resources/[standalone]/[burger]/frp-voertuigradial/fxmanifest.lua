shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
description 'JTM-DEVELOPMENT VOERTUIGRADIAL'
version '1.0.0'
ui_page 'html/index.html'
shared_scripts { 
	'@es_extended/imports.lua',
	'config.lua'
}
client_scripts {
    'client/main.lua',
}
-- server_scripts {
--     'server/main.lua',
--     'server/trunk.lua',
--     'server/brancard.lua'
-- }
files {
    'html/index.html',
    'html/css/main.css',
    'html/js/main.js',
    'html/js/RadialMenu.js',
}
