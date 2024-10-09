Shared = {}

Shared.Locations = {
    {
        blip = true,
        coords = vec4(4524.2007, -4522.6313, 4.8476, 199.5700),
    }
}


Shared.SpawnPlaces = {
    {
        coords = vec3(4510.5605, -4522.6528, 4.1762),
        heading = 300.5867
    }
}

Shared.TestritSpawns = {
    {
        coords = vec3(4510.5605, -4522.6528, 4.176),
        heading = 300.5867
    }
}

Shared.Vehicles = {
   	['eilandcar'] = {
    	{label = 'Kamacho', model = 'kamacho', price = 255000},
    	-- {label = 'Rumpo', model = 'rumpo3', price = 345000},
    	{label = 'Yosemite', model = 'yosemite3', price = 245000},
    	{label = 'Vagrant', model = 'vagrant', price = 225000},
    	{label = 'Rumpo', model = 'rumpo3', price = 555000},
    	{label = 'Youga', model = 'youga3', price = 225000},
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