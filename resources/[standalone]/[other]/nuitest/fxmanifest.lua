fx_version 'cerulean'
game 'gta5'

author 'Matthijs'
description 'Simple NUI Example for FiveM'
version '1.0.0'

client_script 'client.lua'

-- NUI-bestanden
ui_page 'ui/index.html' -- Het hoofdpunt van de UI

files {
    'ui/index.html',         -- Hoofd HTML bestand
    'ui/style.css',          -- CSS bestand voor styling
    'assets/*'            -- Eventuele assets zoals afbeeldingen, iconen, etc.
}

dependency 'es_extended'  -- Zorg ervoor dat ESX wordt geladen
