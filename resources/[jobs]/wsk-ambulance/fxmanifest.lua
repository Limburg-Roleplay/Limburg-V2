shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'wsk-ambulance job'
author 'pindakees'
version '1.0.8'
shared_script { '@es_extended/imports.lua', '@ox_lib/init.lua' }
client_scripts { 'client/*.lua', 'config/*.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua', 'config/*.lua' }

ui_page 'html/index.html'
files {
  'html/index.html',
  'html/js/*.js',
  'html/css/*.css'
}

escrow_ignore = {
  'config/config.lua',
  'config/outfits.lua',
  'config/fines.lua'
}