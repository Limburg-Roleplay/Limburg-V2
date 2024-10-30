--[[
BY RX Scripts © rxscripts.xyz
--]]

fx_version 'cerulean'
games { 'gta5' }

author 'Rejox'
description 'Housing System | rxscripts.xyz'
version '1.7.1'

shared_script {
    '@ox_lib/init.lua',
    'config.lua',
    'shells.lua',
    'init.lua',
    'locales/*.lua',
}

client_scripts {
    'client/utils.lua',
    'client/functions.lua',
    'client/offsettool.lua',
    'client/opensource.lua',
    'client/main.lua',
    'client/creating.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/property.lua',
    'server/functions.lua',
    'server/opensource.lua',
    'server/main.lua',
    'server/commands.lua',
}

ui_page 'web/build/index.html'

files {
  'web/build/index.html',
  'web/build/**/*',
}

escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'shells.lua',
    'client/opensource.lua',
    'server/opensource.lua',
}

lua54 'yes'

dependency '/assetpacks'