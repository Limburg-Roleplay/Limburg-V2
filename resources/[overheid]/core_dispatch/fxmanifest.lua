
fx_version 'cerulean'
game 'gta5'

author 'c8re'
description 'Advanced dispatching system'
version '1.4.0'

ui_page 'html/form.html'

files {
    'html/form.html',
	'html/css.css',
	'html/script.js',
	'html/jquery-3.4.1.min.js',
    'html/78879dfdec.js',
    'sounds/*.mp3'
}

client_scripts{
    'config.lua',
    'client/default_alert.lua',
    'client/main.lua',
}

server_scripts{
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/default_alert.lua',
    'server/main.lua',
}

lua54 'yes'


escrow_ignore {
  'client/main.lua',
  'client/default_alert.lua',
  'server/main.lua',
  'server/default_alert.lua',
  'config.lua'
}

dependency '/assetpacks'