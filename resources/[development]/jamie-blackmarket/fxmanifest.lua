fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '!Jamie Discord:jamie_0001'
description 'Blackmarket script JTM-Development'

shared_script {
    'src/config/*.lua',
    '@ox_lib/init.lua'
}

client_script 'src/client/*.lua'
server_script 'src/server/*.lua'

ui_page 'src/html/index.html'

files {
    'src/html/*',
    'src/html/images/*'
}
