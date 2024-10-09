Shared = {}

Shared.Locations = {
    {
        blip = true,
        coords = vec4(-940.2803, -2963.6616, 19.8454, 269.8610)
    }
}

Shared.QuickSell = {
    coords = vec3(-23.8175, -1094.0479, 27.3052),
    sellPercentage = 0.15
}

Shared.Showroom = {
    {
        model = `rmodrs6`,
        coords = vec3(-37.0475, -1093.1947, 27.3023),
        heading = 156.7317
    },
    {
        model = `rmodrs6`,
        coords = vec3(-42.2574, -1101.4169, 27.3023),
        heading = 342.992126
    },
    {
        model = `rmode63s`,
        coords = vec3(-54.6786, -1096.9877, 27.3023),
        heading = 337.88
    },
    {
        model = `x5bmw`,
        coords = vec3(-49.7459, -1083.6982, 27.3023),
        heading = 203.10
    },
    {
        model = `rmodmk7`,
        coords = vec3(-47.6833, -1091.9606, 27.3023),
        heading = 211.102372
    }
}

Shared.HeliSpawnPlaces = {
    {
        coords = vec3(-1112.2654, -2883.8477, 13.9460),
        heading = 159.6484
    }
}

Shared.PlaneSpawnPlaces = {
    {
        coords = vec3(-980.2916, -2997.9619, 13.9451),
        heading = 59.9560
    }
}

Shared.TestritSpawns = {
    {
        coords = vec3(-1001.9518, -3336.3882, 13.9444),
        heading = 59.2820
    }
}

Shared.Vehicles = {
    ['vliegtuigen'] = {
        {
            model = 'vestra',
            label = 'Vestra',
            price = 3500000
         },
         {
            model = 'luxor',
            label = 'Luxor',
            price = 14500000
         },
    },
    ['helicopters'] = {
         {
            model = 'volatus',
            label = 'Volatus',
            price = 8500000
         },
         {
            model = 'swift',
            label = 'Swift',
            price = 7500000
         },
         {
            model = 'frogger',
            label = 'frogger',
            price = 5000000
         },
    }
}


Shared.Fotobook = {
    CarSettings = {
        coords = vector3(-1359.2811, -2806.4302, 13.9448),
        heading = 326.7165
    },
    Colors = {
        ['black'] = { index = 0 },
        ['white'] = { index = 111 },
        ['blue'] = { index = 64 },
        ['red'] = { index = 27 },
        ['green'] = { index = 55 },
        ['yellow'] = { index = 42 },
        ['pink'] = { index = 137 }
    },
    Cameras = {
        -- Maincam
        [1] = { coords = vector3(-211.2689, -1318.4303, 32.7023), aimAt = vector3(-211.5825, -1324.5447, 31.3203) },
        -- Side-cam
        [2] = { coords = vector3(-216.0495, -1321.5521, 32.0965), aimAt = vector3(-210.9144, -1325.0021, 31.2245) },
        -- back-cam
        [3] = { coords = vector3(-214.9406, -1329.0220, 32.1822), aimAt = vector3(-209.4646, -1320.7615, 31.3221) },
        -- front-cam
        [4] = { coords = vector3(-208.5354, -1319.2239, 32.7384), aimAt = vector3(-212.7731, -1325.7120, 30.9167) },
    },
    Vehicles = {}
}

-- Zet alle voertuigen vanuit Shared.Vehicles hierin
for merk, models in pairs(Shared.Vehicles) do
    for _, vehicle in ipairs(models) do
        table.insert(Shared.Fotobook.Vehicles, {
            model = vehicle.model,
            merk = merk
        })
    end
end