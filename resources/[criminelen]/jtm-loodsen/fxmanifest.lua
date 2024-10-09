fx_version "cerulean"
game "gta5"

description "Loods Systeem"

client_scripts {
    "config.lua",
    "client/client.lua"
}

server_scripts {
    "config.lua",
    "@mysql-async/lib/MySQL.lua",
    "server/server.lua"
}

ui_page "html/index.html"

files {
    "html/index.html"
}
