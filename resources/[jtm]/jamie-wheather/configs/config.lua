Config = {}
function L(cd) if Locales[Config.Language][cd] then return Locales[Config.Language][cd] else print('Locale is nil ('..cd..')') end end


--███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
--██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
--██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝


Config.Framework = 'esx'
Config.Language = 'NL'

Config.FrameworkTriggers = {
    main = 'esx:getSharedObject', 
    load = 'esx:playerLoaded',      
    job = 'esx:setJob',             
    resource_name = 'es_extended' 
}

Config.NotificationType = { --[ 'esx' / 'chat' / 'okok'
    server = 'okok',
    client = 'okok' 
}

Config.Command = {
    OpenUI = 'weer', -- command om het weermenu te openen

    Perms = { -- groups die de command kunnen gebruiken
        ['esx'] = {'owner', 'hogerop', 'admin'},
    }
}

Config.TimeCycleSpeed = 2 --(in seconds) Changing this value will effects the day/night time cycle, decreasing slows it down, incresing speeds it up. Right now its similar to the default gta5 time cycle.
Config.DynamicWeather_time = 10 --(in minutes) If dynamic weather is enabled, this value is how long until the weather changes.
Config.RainChance = 10 --The percent chance for it to rain out of 100.

Config.WeatherGroups = { 
    [1] = {'CLEAR', 'OVERCAST','EXTRASUNNY', 'CLOUDS'},--clear
    [2] = {'CLEARING', 'RAIN', 'NEUTRAL',},--rain
    [3] = {'SMOG', 'FOGGY'},--foggy
}