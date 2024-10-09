shared_script '@FIVEGUARD/ai_module_fg-obfuscated.js'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@frp-manualapi/ai_module_fg-obfuscated.lua'
shared_script '@frp-manualapi/ai_module_fg-obfuscated.js'
 
 
 

fx_version 'cerulean'
game 'gta5'
author 'AwayFromKane (#0001)'
description 'Progressbar'
ui_page('html/index.html')
shared_scripts {
    'shared/sh_*.lua',
    '@es_extended/imports.lua'
}
client_scripts {
    'client/cl_*.lua',
}
files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/fonts/*.ttf',
	'html/fonts/*.woff',
}
exports {
    'Progress',
    'GetTaskBarStatus',
    'ProgressWithStartEvent',
    'ProgressWithTickEvent',
    'ProgressWithStartAndTick'
}