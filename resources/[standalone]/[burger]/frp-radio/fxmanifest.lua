shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
description 'FRP-Radio'
version '1.0.0'
shared_script 'config.lua'
client_scripts {
  'client.lua'
}
shared_script '@es_extended/imports.lua'
server_script 'server.lua'
ui_page('html/ui.html')
files {'html/ui.html', 'html/js/script.js', 'html/css/style.css', 'html/img/radio.png'}
lua54 'yes'

escrow_ignore {
  'config.lua',
  'locales/**'
}