return {

    DrawMarker = false, -- if you dont want marker put here false
    EnableFadeOut = false, -- if you dont want screen fading disable this

    Elevators = {
        -- this is just example 

        [1] = {
            name = 'The Gentlemans Gang Lift', -- name that will be displayed in textUI
            coords = { -- in whitch order you put in table coords, same order will be in menu, example:
                vec3(380.2477, -15.0945, 82.9977),  -- Garage
                vec3(414.8425, -15.2492, 99.6456),  -- Hotelkamers
            },
            jobs = false -- if you dont want check for jobs then put false
        },

        [2] = {
            name = 'Soulz Lift', -- name that will be displayed in textUI
            coords = { -- in whitch order you put in table coords, same order will be in menu, example:
                vec3(-305.1036, -721.1508, 28.0286),  -- Garage
                vec3(-288.1228, -722.6609, 125.4733),  -- Hotelkamers
            },
            jobs = false -- if you dont want check for jobs then put false
        },

        [3] = {
            name = 'Politie HB Lift', -- name that will be displayed in textUI
            coords = { -- in whitch order you put in table coords, same order will be in menu, example:
                vec3(-1097.5825, -848.4939, 4.8841),  -- Garage
                vec3(-1097.6006, -848.5129, 10.2769),  -- Hotelkamers
                vec3(-1097.6254, -848.5343, 13.6871),  -- Garage
                vec3(-1097.5989, -848.5129, 19.0014),  -- Hotelkamers
                vec3(-1097.5184, -848.4694, 23.0348),  -- Garage
                vec3(-1097.4803, -848.5156, 26.8275),  -- Hotelkamers
                vec3(-1097.5695, -848.4545, 30.6289),  -- Garage
                vec3(-1097.4425, -848.5063, 34.3611),  -- Hotelkamers
                vec3(-1096.0911, -850.7619, 38.2432),  -- Hotelkamers
            },
            jobs = false -- if you dont want check for jobs then put false
        },

        [4] = {
            name = 'Paletto HB Lift', -- name that will be displayed in textUI
            coords = { -- in whitch order you put in table coords, same order will be in menu, example:
                vec3(-450.1032, 6010.5259, 27.5814),  -- Garage
                vec3(-450.0330, 6010.4883, 32.287),  -- Garage
                vec3(-449.2106, 6009.1084, 36.9955),  -- Hotelkamers
            },
            jobs = false -- if you dont want check for jobs then put false
        },

        --[[
            example
            [next number (3)] = {
                name = name,
                coords = {coords},
                jobs = false or table
            }
        ]]
    }
}