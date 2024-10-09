shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'

game 'gta5'
author 'Snipe'
description 'Thermite Game Like NoPixel'
version '1.0.0'
server_scripts {
  --'server/server.lua',
}

client_scripts {
  'client/main.lua',
}

ui_page {
  'html/index.html'
}

files {
  'html/index.html',
  'html/style.css',
  'html/app.js'
}