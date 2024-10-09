shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'TD_Refunds - By TijnnDev'

version '1.0.0'
shared_script '@es_extended/imports.lua'
client_script {
  'config.lua',
  'client.lua'

}

server_scripts {
  'server.lua',
  'config.lua'

}
server_scripts { '@mysql-async/lib/MySQL.lua' }