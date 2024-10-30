shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'adamant'

game 'gta5'
author 'Jamie Discord jamie_0001'
description 'Airdrop script'
lua54 'yes'

ui_page "html/ui.html"

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',

}

client_scripts {
	"client/main.lua",
	"config.lua"
}

server_scripts {
    "server/*.lua",
    "config.lua"
}

dependency{
	'ox_inventory'
}