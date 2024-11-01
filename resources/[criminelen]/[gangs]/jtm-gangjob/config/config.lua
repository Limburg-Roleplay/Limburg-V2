Config = {}

Config.Webhooks = {
    PromoteWebhook = "https://discord.com/api/webhooks/1259270280824623226/PndN2wIrZoY3dj8W9NRzU2_DGfReRtvpPTwA1lRQhQ5VYCGCNj6A-eHWYS7ATnAbEVKC",
    DemoteWebhook = "https://discord.com/api/webhooks/1259270280824623226/PndN2wIrZoY3dj8W9NRzU2_DGfReRtvpPTwA1lRQhQ5VYCGCNj6A-eHWYS7ATnAbEVKC",
    OntslaanWebhook = "https://discord.com/api/webhooks/1259270280824623226/PndN2wIrZoY3dj8W9NRzU2_DGfReRtvpPTwA1lRQhQ5VYCGCNj6A-eHWYS7ATnAbEVKC",
    AaneemWebhook = "https://discord.com/api/webhooks/1259270280824623226/PndN2wIrZoY3dj8W9NRzU2_DGfReRtvpPTwA1lRQhQ5VYCGCNj6A-eHWYS7ATnAbEVKC"
}

Config.Locale = 'en' -- Taal locale [Alleen engels werkt voor nu!]

Config.Blip = true -- Blip op map

Config.Fouilleertimer = 3 -- Tijd staat in seconden! [Dit is hoelang de progressbar is!]

Config.Markerdistance = 15 -- Hoe dichtbij iemand in de range van de wapeninkoop moet zijn voordat je een console print krijgt. [in meters!]

Config.WitwasMissie = {
    title = 'Witwas Missie', -- Naam van de witwas
    description = 'Witwas missie starten', -- Bijnaam van de witwas
    minProcent = 85,  -- Minimum percentage
    maxProcent = 100,  -- Maximum percentage
    Aflevercoordswitwas = { -- Lijst van coördinaten
        vec3(787.4402, 1278.6433, 360.2965),
        vec3(-66.6006, 1897.9714, 196.1356), -- Voeg hier meer coördinaten toe
        vec3(181.9905, 3056.7617, 43.0167)
    }
}

Config.wapen_volgorde = { -- Wapen volgorde hoe het in de lijst komt te staan.
    "akm",
    "akmu",
    "xp45",
    "xagc",
    "minismg",
    "sawedoffshotgun",
    "pistol50",
    "pistolm9a3",
    "ladykiller",
    "ap320",
    "ap19",
    "switchblade",
    "knuppel",
    "mes",
    "machete"
}

Config.wapen_spawnnames = { -- Wapen spawnnames. Niet aanzitten A.U.B
    ["akm"] = "WEAPON_AK74_1",
    ["akmu"] = "WEAPON_AKS74U",
    ["xp45"] = "WEAPON_HKUMP",
    ["xagc"] = "WEAPON_AGC",
    ["minismg"] = "WEAPON_MINISMG",
    ["sawedoffshotgun"] = "WEAPON_SAWNOFFSHOTGUN",
    ["pistol50"] = "WEAPON_PISTOL50",
    ["pistolm9a3"] = "WEAPON_FM1_M9A3",
    ["ladykiller"] = "WEAPON_SNSPISTOL",
    ["ap320"] = "WEAPON_SIG",
    ["ap19"] = "WEAPON_GLOCK19X",
    ["switchblade"] = "WEAPON_SWITCHBLADE",
    ["knuppel"] = "WEAPON_BAT",
    ["mes"] = "WEAPON_KNIFE",
    ["machete"] = "WEAPON_MACHETE"
}

Config.wapen_labels = { -- Wapen Labels, zichtbaar in titels en descriptions
    ["akm"] = "AKM",
    ["akmu"] = "AKM-U",
    ["xp45"] = "XP-45",
    ["xagc"] = "",
    ["minismg"] = "",
    ["sawedoffshotgun"] = "",
    ["pistol50"] = "",
    ["pistolm9a3"] = "",
    ["ladykiller"] = "",
    ["ap320"] = "",
    ["ap19"] = "",
    ["switchblade"] = "",
    ["knuppel"] = "",
    ["mes"] = "Mes",
    ["machete"] = "Machete"
}

Config.wapen_prijzen = { -- Wapen prijzen
    ["akm"] = 10000,
    ["akmu"] = 10000,
    ["xp45"] = 10000,
    ["xagc"] = 10000,
    ["minismg"] = 10000,
    ["sawedoffshotgun"] = 10000,
    ["pistol50"] = 10000,
    ["pistolm9a3"] = 10000,
    ["ladykiller"] = 10000,
    ["ap320"] = 10000,
    ["ap19"] = 10000,
    ["switchblade"] = 10000,
    ["knuppel"] = 10000,
    ["mes"] = 10000,
    ["machete"] = 10000
}

Config.wapen_icons = { -- Icons die in images/.. staan
    ["akm"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["akmu"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["xp45"] = 'nui://jtm-gangjob/images/automatischwapen.png',
    ["xagc"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["minismg"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["sawedoffshotgun"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["pistol50"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["pistolm9a3"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["ladykiller"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["ap320"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["ap19"] = 'nui://jtm-gangjob/images/handwapen.png',
    ["switchblade"] = 'nui://jtm-gangjob/images/mes.png',
    ["knuppel"] = 'nui://jtm-gangjob/images/mes.png',
    ["mes"] = 'nui://jtm-gangjob/images/mes.png',
    ["machete"] = 'nui://jtm-gangjob/images/mes.png'
}

Config.Wapeninkoopgangs = {
    jansen = {
        [1] = {
            gangname = "jansen",
            mingrade = 2,
            ganglevel = 5,
            coordsbossmenu = vector3(473.3943, -1310.1309, 29.2269),
            coordswapeninkoop = vector3(479.3991, -1325.6292, 29.2075),
            Startcoordswitwas = vector3(510.3524, -1314.4404, 29.3410)
        },
        f6menu = true,
        wapeninkoop = { -- MAXIMAAL aantal wapens
            ["akm"] = 2,
            ["akmu"] = 4,
            ["xp45"] = 2,
            ["xagc"] = 2,
            ["minismg"] = 2,
            ["sawedoffshotgun"] = 2,
            ["pistol50"] = 2,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 2,
            ["ap320"] = 1,
            ["ap19"] = 2,
            ["switchblade"] = 2,
            ["knuppel"] = 2,
            ["mes"] = 2,
            ["machete"] = 2,
        }
    },
     cjng = {
        [1] = {
            gangname = "cjng",
            mingrade = 7,
            ganglevel = 5,
            coordsbossmenu = vector3(360.8562, -2040.7520, 25.5946),
			coordswapeninkoop = vector3(331.9081, -2013.5154, 22.3949),
            Startcoordswitwas = vector4(355.8191, -1965.7003, 24.4911, 57.5622)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    hsq = {
        [1] = {
            gangname = "hsq",
            mingrade = 6,
            ganglevel = 1,
            coordsbossmenu = vector3(133.0420, 1218.2458, 217.6068),
			coordswapeninkoop = vector3(115.3486, 1241.1381, 214.1099),
            Startcoordswitwas = vector4(133.0420, 1218.2458, 217.6068, 105.3736)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    sinaloa = {
        [1] = {
            gangname = "sinaloa",
            mingrade = 5,
            ganglevel = 2,
            coordsbossmenu = vector3(1395.4060, 1160.0037, 114.3335),
			coordswapeninkoop = vector3(1400.3490, 1141.4763, 114.3336),
            Startcoordswitwas = vector4(1354.9794, 1189.1823, 112.1166, 88.9723)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    ccf = {
        [1] = {
            gangname = "ccf",
            mingrade = 8,
            ganglevel = 1,
            coordsbossmenu = vector3(-1101.6047, -1615.5483, 8.5928),
			coordswapeninkoop = vector3(-1070.9995, -1647.0813, 4.4633),
            Startcoordswitwas = vector3(-1136.8572, -1578.7875, 4.4293)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    laoscura = {
        [1] = {
            gangname = "laoscura",
            mingrade = 7,
            ganglevel = 1,
            coordsbossmenu = vector3(-1101.6047, -1615.5483, 8.5928),
			coordswapeninkoop = vector3(-1070.9995, -1647.0813, 4.4633),
            Startcoordswitwas = vector3(-1136.8572, -1578.7875, 4.4293)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
     vatoslocos = {
        [1] = {
            gangname = "vatoslocos",
            mingrade = 6,
            ganglevel = 4,
            coordsbossmenu = vector3(-1592.2097, -21.6209, 57.5767),
			coordswapeninkoop = vector3(-1582.2375, -31.4063, 52.6013),
            Startcoordswitwas = vector4(-1525.6399, -27.2629, 57.2930, 303.5891)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    carteldellago = {
        [1] = {
            gangname = "carteldellago",
            mingrade = 7,
            ganglevel = 1,
            coordsbossmenu = vector3(-1529.0190, 150.5548, 60.7980),
			coordswapeninkoop = vector3(-1545.5714, 84.8462, 53.8744),
            Startcoordswitwas = vector4(-1612.0688, 120.4822, 61.0354)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    albanesemaffia = {
        [1] = {
            gangname = "albanesemaffia",
            mingrade = 6,
            ganglevel = 4,
            coordsbossmenu = vector3(-686.4366, -402.3235, 52.2134),
			coordswapeninkoop = vector3(-711.6934, -412.7919, 35.0784),
            Startcoordswitwas = vector4(-739.9949, -397.5858, 35.4785, 338.1885)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    niquenta = {
        [1] = {
            gangname = "niquenta",
            mingrade = 6,
            ganglevel = 1,
            coordsbossmenu = vector3(-686.4366, -402.3235, 52.2134),
			coordswapeninkoop = vector3(-711.6934, -412.7919, 35.0784),
            Startcoordswitwas = vector4(-739.9949, -397.5858, 35.4785, 338.1885)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 0,
            ["knuppel"] = 0,
            ["mes"] = 0,
            ["machete"] = 0,
        }
    },
    saints = {
        [1] = {
            gangname = "saints",
            mingrade = 7,
            ganglevel = 1,
            coordsbossmenu = vector3(-1876.2509, 2060.9377, 145.5736),
			coordswapeninkoop = vector3(-1870.3710, 2061.4619, 135.4347),
            Startcoordswitwas = vector4(-1911.5717, 2048.7026, 140.7368)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 5,
            ["akmu"] = 5,
            ["xp45"] = 5,
            ["xagc"] = 5,
            ["minismg"] = 5,
            ["sawedoffshotgun"] = 5,
            ["pistol50"] = 5,
            ["pistolm9a3"] = 5,
            ["ladykiller"] = 5,
            ["ap320"] = 5,
            ["ap19"] = 5,
            ["switchblade"] = 5,
            ["knuppel"] = 5,
            ["mes"] = 5,
            ["machete"] = 5,
        }
    },
    angelsofdeath = {
        [1] = {
            gangname = "angelsofdeath",
            mingrade = 7,
            ganglevel = 4,
            coordsbossmenu = vector3(-263.7994, -728.3154, 125.4733),
			coordswapeninkoop = vector3(-316.1113, -746.9086, 28.0286),
            Startcoordswitwas = vector4(-303.5113, -703.2805, 30.1414, 337.8767)
        },
        f6menu = true,
        wapeninkoop = {
            
            ["akm"] = 0,
            ["akmu"] = 0,
            ["xp45"] = 0,
            ["xagc"] = 0,
            ["minismg"] = 0,
            ["sawedoffshotgun"] = 0,
            ["pistol50"] = 0,
            ["pistolm9a3"] = 0,
            ["ladykiller"] = 0,
            ["ap320"] = 0,
            ["ap19"] = 0,
            ["switchblade"] = 5,
            ["knuppel"] = 5,
            ["mes"] = 5,
            ["machete"] = 5,
        }
    },
}

-- Tiewrap systeem

Config.Pushing = {
    pushingAnimDict = 'switch@trevor@escorted_out',
    pushingAnim = '001215_02_trvs_12_escorted_out_idle_guard2'
}

Config.Walking = {
    ['walkingAnimDict'] = 'anim@move_m@grooving@',
    ['walkingAnim'] = 'walk'
}

Config.GetClosestPlayer = function()
   return ESX.OneSync.GetClosestPlayer()
end