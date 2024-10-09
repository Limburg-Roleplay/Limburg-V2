shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.js'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
fx_version 'bodacious'
game 'common'

client_script 'dist/client.js'
server_script 'dist/server.js'

dependency 'yarn'
dependency 'webpack'

webpack_config 'client.config.js'
webpack_config 'server.config.js'
webpack_config 'ui.config.js'

files {
    'dist/ui.html'
}

ui_page 'dist/ui.html'