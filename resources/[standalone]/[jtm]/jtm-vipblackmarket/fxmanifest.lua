shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'


shared_script {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}
client_script {
    'client.lua'
}