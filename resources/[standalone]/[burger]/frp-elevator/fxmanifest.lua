shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
description 'Future frp-elevator '
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'


shared_script '@ox_lib/init.lua'
client_script 'client.lua'


dependencies {'ox_lib'}

files {'config.lua'}