shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

client_scripts {
    'client.lua'
}

loadscreen 'ui/index.html'

files {
    'ui/index.html',
    'ui/css/*.css',
    'ui/img/*.png',
    'ui/music/*.mp3',
    'ui/js/*.js',
}

lua54 'yes'
loadscreen_manual_shutdown 'yes'

author 'JTM-Development'