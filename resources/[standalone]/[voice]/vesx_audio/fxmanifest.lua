shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'
game 'gta5'

shared_scripts { '@es_extended/imports.lua' }
client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua'}

ui_page('html/index.html')

files {
 'html/index.html',
 'html/sounds/*.ogg',
}