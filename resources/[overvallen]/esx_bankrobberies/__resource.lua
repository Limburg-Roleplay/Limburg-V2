shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
shared_script '@es_extended/imports.lua'
server_scripts {
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'config.lua',
 	'client/main.lua',
 	'client/doors.lua'
}