Shared = {}

Shared.Locations = {
    {
        blip = true,
        coords = vec4(1127.1108, -785.4495, 57.5908, 269.3378)
    }
}

Shared.Showroom = {
    {
        model = `rmod2rs6`,
        coords = vec3(-47.5383, -1093.7439, 26.4223),
        heading = 192.7317
    },
    {
        model = `fk28`,
        coords = vec3(-43.4629, -1095.1185, 26.4223),
        heading = 189.992126
    },
    {
        model = `g65amg2`,
        coords = vec3(-39.6167, -1096.5637, 26.4223),
        heading = 189.88
    },
    {
        model = `ev222`,
        coords = vec3(-43.1986, -1102.8335, 26.4223),
        heading = 299.10
    },
    {
        model = `porschecayennehybrid`,
        coords = vec3(-48.4410, -1101.9758, 26.4223),
        heading = 299.102372
    }
}

Shared.SpawnPlaces = {
    {
        coords = vec3(1159.0391, -790.2590, 57.5762),
        heading = 357.4930
    }
}

Shared.TestritSpawns = {
    {
        coords = vec3(1212.09, -2957.74, 5.87),
        heading = 92.15
    }
}

Shared.Vehicles = {
    ['Luxury'] = {
        {
            model = '2019chiron',
            label = 'Bugatta C 2019',
            price = 3750000
        },
        {
            model = 'bcps',
            label = 'Bugatta D',
            price = 3500000
        },
        {
            model = 'bvit',
            label = 'Bugatta V',
            price = 3000000
        },
        {
            model = 'rocket900',
            label = 'Rocketeer 900',
            price = 1500000
        },
        {
            model = 'rmodg900',
            label = 'Rocketeer G900',
            price = 2000000
        },
        {
            model = 'oycrs6dtm',
            label = 'Obey R6 DTM',
            price = 1600000
        },
        {
            model = 'm3csf80',
            label = 'Ubermacht M3 F80',
            price = 850000
        },
        {
            model = 'c63ew206',
            label = 'Benefactor Brubas C63',
            price = 1200000
        },
        {
            model = 'centm4maxtonkit',
            label = 'Ubermacht M4 Maxton',
            price = 850000
        },
        {
            model = 'evo9r',
            label = 'Pegassi Evo 9R',
            price = 1150000
        }
    }
}

Shared.Fotobook = {
    CarSettings = {
        coords = vector3(-211.6762, -1324.0729, 30.4683),
        heading = 326.7165
    },
    Colors = {
        ['black'] = { index = 0 },
    },
    Cameras = {
        [1] = { coords = vector3(-211.2689, -1318.4303, 32.7023), aimAt = vector3(-211.5825, -1324.5447, 31.3203) },
    },
    Vehicles = {}
}

for merk, models in pairs(Shared.Vehicles) do
    for _, vehicle in ipairs(models) do
        table.insert(Shared.Fotobook.Vehicles, {
            model = vehicle.model,
            merk = merk
        })
    end
end