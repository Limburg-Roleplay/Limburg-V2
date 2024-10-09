shared_script '@FIVEGUARD/ai_module_fg-obfuscated.lua'
shared_script '@FIVEGUARD/shared_fg-obfuscated.lua'
fx_version "adamant"
use_fxv2_oal "yes"
lua54 "yes"
game "gta5"
client_scripts {"config.lua", "client/*.lua"}
server_scripts {"config.lua", "@oxmysql/lib/MySQL.lua", "server/*.lua"}
shared_scripts {"@es_extended/imports.lua", "@ox_lib/init.lua"}
ui_page "html/index.html"
files {
    "html/*.html",
    "html/**/*.css",
    "html/**/*.js"
}
