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
        f6menu = true
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
        f6menu = true
    },
     camorra = {
        [1] = {
            gangname = "camorra",
            mingrade = 8,
            ganglevel = 2,
            coordsbossmenu = vector3(-1482.4443, -47.4977, 57.7233),
			coordswapeninkoop = vector3(-1479.4298, -21.5512, 50.9785),
            Startcoordswitwas = vector4(-1465.8457, -23.7542, 54.6415, 37.2374)
        },
        f6menu = true
    },
     zone6 = {
        [1] = {
            gangname = "zone6",
            mingrade = 8,
            ganglevel = 4,
            coordsbossmenu = vector3(1395.1283, 1160.1110, 114.3335),
			coordswapeninkoop = vector3(1405.7371, 1137.8448, 109.7457),
            Startcoordswitwas = vector3(1395.1283, 1160.1110, 114.3335)
        },
        f6menu = true
    },
    ms13 = {
        [1] = {
            gangname = "ms13",
            mingrade = 5,
            ganglevel = 1,
            coordsbossmenu = vector3(-104.9405, 979.6995, 240.8824),
			coordswapeninkoop = vector3(-59.9729, 994.9761, 239.5153),
            Startcoordswitwas = vector3(-127.0996, 988.8734, 235.7466)
        },
        f6menu = true
    },
    saints = {
        [1] = {
            gangname = "saints",
            mingrade = 6,
            ganglevel = 2,
            coordsbossmenu = vector3(244.2896, -3152.3064, 3.3346),
			coordswapeninkoop = vector3(206.2487, -3176.2620, 5.8145),
            Startcoordswitwas = vector3(187.0090, -3175.6064, 5.7020)
        },
        f6menu = true
    },
    bratva = {
        [1] = {
            gangname = "bratva",
            mingrade = 6,
            ganglevel = 4,
            coordsbossmenu = vector3(-2674.6375, 1336.1976, 144.2575),
			coordswapeninkoop = vector3(-2674.2891, 1328.8027, 140.8813),
            Startcoordswitwas = vector3(-2638.1150, 1306.6460, 145.3623)
        },
        f6menu = true
    },
     pavlov = {
        [1] = {
            gangname = "pavlov",
            mingrade = 6,
            ganglevel = 4,
            coordsbossmenu = vector3(-1546.1127, 137.3435, 55.6532),
			coordswapeninkoop = vector3(-1517.9232, 125.9776, 48.6503),
            Startcoordswitwas = vector4(-1498.0010, 56.4377, 54.4208, 276.5659)
        },
        f6menu = true
    },
    lfc = {
        [1] = {
            gangname = "lfc",
            mingrade = 5,
            ganglevel = 4,
            coordsbossmenu = vector3(-1875.8385, 2060.9429, 145.5737),
			coordswapeninkoop = vector3(-1870.2726, 2061.8125, 135.4347),
            Startcoordswitwas = vector4(-1875.5914, 2039.4227, 140.1070, 239.3353)
        },
        f6menu = true
    },
    chipmunks = {
        [1] = {
            gangname = "chipmunks",
            mingrade = 5,
            ganglevel = 1,
            coordsbossmenu = vector3(-640.5219, 941.3781, 243.9728),
			coordswapeninkoop = vector3(-628.1700, 948.3683, 243.9465),
            Startcoordswitwas = vector4(-716.7307, 1019.0453, 240.2595, 340.5587)
        },
        f6menu = true
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
        f6menu = true
    },
    sinaloa = {
        [1] = {
            gangname = "sinaloa",
            mingrade = 5,
            ganglevel = 2,
            coordsbossmenu = vector3(-94.1752, 819.6499, 231.3329),
			coordswapeninkoop = vector3(-102.1677, 824.2632, 227.5961),
            Startcoordswitwas = vector4(-73.0090, 868.3975, 235.6435, 0.7833)
        },
        f6menu = true
    },
    sons = {
        [1] = {
            gangname = "sons",
            mingrade = 6,
            ganglevel = 1,
            coordsbossmenu = vector3(982.9077, -91.9958, 74.8522),
			coordswapeninkoop = vector3(987.7953, -137.5166, 73.0909),
            Startcoordswitwas = vector4(965.0928, -131.2782, 74.3512, 146.53631)
        },
        f6menu = true
    },
    tgg = {
        [1] = {
            gangname = "tgg",
            mingrade = 6,
            ganglevel = 5,
            coordsbossmenu = vector3(430.9922, 6.6181, 91.9336),
			coordswapeninkoop = vector3(412.3693, 4.2529, 84.9215),
            Startcoordswitwas = vector4(335.6770, 32.8280, 88.4918, 67.6122)
        },
        f6menu = true
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
        f6menu = true
    },
    redeye = {
        [1] = {
            gangname = "redeye",
            mingrade = 6,
            ganglevel = 4,
            coordsbossmenu = vector3(-2294.9683, 4352.5664, 37.0810),
			coordswapeninkoop = vector3(-2305.6501, 4329.0063, 29.0838),
            Startcoordswitwas = vector4(-2295.9612, 4284.2305, 35.2326, 144.5905)
        },
        f6menu = true
    },
    reznikov = {
        [1] = {
            gangname = "reznikov",
            mingrade = 6,
            ganglevel = 5,
            coordsbossmenu = vector3(-686.4366, -402.3235, 52.2134),
			coordswapeninkoop = vector3(-711.6934, -412.7919, 35.0784),
            Startcoordswitwas = vector4(-739.9949, -397.5858, 35.4785, 338.1885)
        },
        f6menu = true
    },
    vissenkom = {
        [1] = {
            gangname = "vissenkom",
            mingrade = 3,
            ganglevel = 4,
            coordsbossmenu = vector3(-1990.5211, -504.5139, 20.7328),
			coordswapeninkoop = vector3(-1982.9875, -502.9479, 12.1917),
        },
        f6menu = true
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
        f6menu = true
    },
    crips = {
        [1] = {
            gangname = "crips",
            mingrade = 5,
            ganglevel = 2,
            coordsbossmenu = vector3(-112.7250, -1781.3091, 28.5872),
			coordswapeninkoop = vector3(-91.9708, -1794.1924, 26.9096),
            Startcoordswitwas = vector4(-55.4005, -1835.9349, 26.5963, 315.8484)
        },
        f6menu = true
    },
    albanesemaffia = {
        [1] = {
            gangname = "albanesemaffia",
            mingrade = 7,
            ganglevel = 1,
            coordsbossmenu = vector3(-112.7250, -1781.3091, 28.5872),
			coordswapeninkoop = vector3(-91.9708, -1794.1924, 26.9096),
            Startcoordswitwas = vector4(-55.4005, -1835.9349, 26.5963, 315.8484)
        },
        f6menu = true
    },
    calohwagoh = {
        [1] = {
            gangname = "calohwagoh",
            mingrade = 5,
            ganglevel = 3,
            coordsbossmenu = vector3(518.2502, -2757.7852, 6.6410),
			coordswapeninkoop = vector3(565.9285, -2777.0337, 5.9843),
            Startcoordswitwas = vector4(598.8004, -2798.0969, 6.0565, 328.6283)
        },
        f6menu = true
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