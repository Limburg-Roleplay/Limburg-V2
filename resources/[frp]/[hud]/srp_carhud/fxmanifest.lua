shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'bodacious'
game 'gta5'
lua54 'yes'

-- UI
ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/assets/seatbelt.png",
	"ui/assets/seatbelt.svg",
	"ui/assets/cruise.svg",
	"ui/assets/clignotant-droite.svg",
	"ui/assets/clignotant-gauche.svg",
	"ui/assets/feu-position.svg",
	"ui/assets/feu-route.svg",
	"ui/assets/fuel.svg",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js"
}

-- Client Scripts
client_scripts {
	"client.lua",
	"config.lua",
	'vehicles.lua'
}

shared_scripts {
	"@ox_lib/init.lua"
}