shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version 'cerulean'
games {'gta5'}
author 'mn#0810'
description 'mn-tx'
version '1.0.0'
shared_script '@es_extended/imports.lua'
client_scripts {
  "client/*",
  "config.lua"
}
server_scripts {
  "server/*",
  "config.lua"
}
dependencies {
	'es_extended'
}
