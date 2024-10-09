fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'bishway#0'
description 'Blackmarket Script for Westkust Roleplay made by bishway#0'

shared_script {
    'src/config/*.lua',
    '@ox_lib/init.lua'
}

client_script 'src/client/*.lua'
-- server_script 'src/server/*.lua'

ui_page 'src/html/index.html'

files {
    'src/html/*',
    'src/html/images/*'
}
