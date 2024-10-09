Shared = {}

Shared.Locations = {
    {
        blip = true,
        coords = vec4(-805.7817, -1368.5077, 5.1783, 352.5867),
    }
}


Shared.SpawnPlaces = {
    {
        coords = vec3(-715.8414, -1323.9836, -0.8598),
        heading = 229.5867
    }
}

Shared.TestritSpawns = {
    {
        coords = vec3(-715.8414, -1323.9836, -0.8598),
        heading = 229.5867
    }
}

Shared.Vehicles = {
   	['Boten'] = {
    	-- {label = 'Speedophile Seashark', model = 'seashark', price = 18000},
    	{label = 'Shitzu Tropic', model = 'tropic', price = 255000},
    	-- {label = 'Shitzu Jetmax', model = 'jetmax', price = 115000},
    	-- {label = 'Dinka Marquis', model = 'marquis', price = 225000},
    	{label = 'Longfin', model = 'longfin', price = 545000},
	}
}


Shared.Fotobook = {
    CarSettings = {
        coords = vector3(-814.3417, -1529.6284, -0.4748),
        heading = 15.5065
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
        [1] = { coords = vector3(-820.7071, -1528.9185, 2.4740), aimAt = vector3(-814.3417, -1529.6284, 1.1748) },
        -- Side-cam
        [2] = { coords = vector3(-813.0795, -1521.4847, 2.4749), aimAt = vector3(-814.3417, -1529.6284, 1.1748) },
        -- back-cam
        [3] = { coords = vector3(-806.1705, -1535.1605, 2.4749), aimAt = vector3(-814.3417, -1529.6284, 1.1748) },
        [4] = { coords = vector3(-815.2475, -1539.4012, 2.4748), aimAt = vector3(-814.3417, -1529.6284, 1.1748) },
        -- front-cam
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