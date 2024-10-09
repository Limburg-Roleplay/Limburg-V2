shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'Lucian Fialho'
description 'Discord Webhook to log commands'
version '1.0.0'

server_scripts {
    'config.lua',
    'server/*.lua'
}

server_only 'yes'