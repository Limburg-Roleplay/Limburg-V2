Config = {}

Config.Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config.TackleDistance = 1.0

Config.ActionsOpenKey = 'F6'

Config.RequiredAmbulance = 2

Config.MecanoAmtDeletingVehicle = 3
Config.MinHealthToDeleteVehicle = 500
Config.BlipSprite  = 60
Config.BlipDisplay = 4
Config.BlipScale   = 0.9
Config.BlipColour  = 0
Config.Blips = {
	{
		BlipLabel = 'Politie Bureau',
		Coords = vector3(-389.9100, -350.5517, 70.9539)
	},
}

Config.Locations = {
    {
        coords = vector3(-387.2899, -373.4454, 24.7567),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-375.6584, -366.7184, 24.7567, 256.4708),
            [2] = vector4(-374.9686, -362.3497, 24.7567, 259.4238),
            [3] = vector4(-380.0863, -361.5701, 24.7567, 76.2503),
            [4] = vector4(-373.3387, -321.2898, 24.7559, 81.5934),
            [5] = vector4(-370.2289, -322.5952, 24.7559, 259.4644)
        }
    },
    {--- DSI HB Mazebank
        coords = vector3(-76.3337, -816.1165, 36.1340),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-67.2052, -811.0093, 36.1051, 125.5662),
            [2] = vector4(-63.8915, -821.1813, 35.6512, 96.6334),
            [3] = vector4(-73.8857, -823.0173, 35.4810, 270.4504)
        }
    },
        {
        coords = vector3(-335.4138, -374.5309, 20.2262),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-1061.9011, -853.3899, 4.8689, 215.0634)
        }
    },
    {
        coords = vector3(-373.0930, -373.7690, 24.7567),
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'any',
    },
    { -- Boven
        coords = vector3(-399.4167, -366.9086, 25.0989),
        drawText = 'Omkleden',
        functionDefine = CloakroomMenu,
    },
    { -- Beneden
        coords = vector3(-399.4167, -366.9086, 25.0989),
        drawText = 'Omkleden',
        functionDefine = CloakroomMenu,
    },
    {
        coords = vector3(-578.6591, -929.6273, 23.8586),
        drawText = 'In-/uitklokken',
        functionDefine = OnOffDuty,
    },
    {-- DSI
        coords = vector3(-87.5487, -814.8098, 36.1005),
        drawText = 'In-/uitklokken',
        functionDefine = OnOffDuty,
    },
    {
        coords = vector3(-402.9269, -377.0875, 25.0989),
        drawText = 'Wapens/munitie pakken',
        functionDefine = GetGear
    },
    {
        coords = vector3(403.93, -1633.41, 29.29),
        drawText = 'Impound',
        functionDefine = StoreCarInImpound,
    },
    {
        coords = vector3(1842.9701, 3703.4065, 33.9746),
        drawText = 'Impound',
        functionDefine = StoreCarInImpound,
    },
    {
        coords = vector3(-461.0262, 6044.3833, 31.3404),
        drawText = 'Impound',
        functionDefine = StoreCarInImpound,
    },
    {
        coords = vector3(2404.2998, 3106.0754, 48.2429),
        drawText = 'Impound',
        functionDefine = StoreCarInImpound,
    },
	{
        coords = vector3(-401.6153, -343.5191, 70.9539),
        rank = 4,
        drawText = 'Garage',
        type = 'airport',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-393.6525, -336.9238, 72.8155, 323.3911)
        }
    },
    {
        coords = vector3(-1096.8512, -832.8571, 37.7002),
        rank =  4,
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'heli',
    },
	{
        coords = vector3(-780.8802, -1505.7128, 1.5954),
        rank = 2,
        drawText = 'Garage',
        type = 'boten',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-789.1931, -1502.5710, 0.1144, 110.2755)
        }
    },
	{
        coords = vector3(-789.1931, -1502.5710, 0.1144),
        rank = 2,
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'boot',
    },
    {
        coords = vector3(-842.3481, -1371.9121, 0.2885),
        drawText = 'Impound',
        functionDefine = StoreCarInImpound,
    },
	{ --vliegdekschip
        coords = vector3(3099.1880, -4809.3193, 2.0370),
        rank = 2,
        drawText = 'Garage',
        type = 'boten',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(3091.8379, -4816.9976, 0.3009, 194.3612)
        }
    },
	{ --vliegdekschip
        coords = vector3(3091.8379, -4816.9976, 0.3009),
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'boot',
    },
	{ -- Legerbasis
        coords = vector3(-1886.6158, 2812.3506, 32.8065),
        rank = 3,
        drawText = 'Garage',
        type = 'airport',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-1859.9380, 2794.8145, 33.0796, 331.7114)
        }
    },
	{ -- Legerbasis
        coords = vector3(-1859.6576, 2795.3623, 32.8065),
        rank = 3,
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'heli',
    },
}

Config.Vehicles = {
    cars = {       
        {
            category = 'Noodhulp',
            description = 'Noodhulp voertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'Mercedes B-Klasse',
                    spawnName = 'pbklasse'
                },
                {
                    name = 'Politie X5',
                    spawnName = 'polrebla'
                },
                {
                    name = 'Volkswagen Amarok',
                    spawnName = 'poleveron'
                },
            }
        },
        {
            category = 'Verkeers Politie',
            description = ' VP voertuigen.',
            rank = 0,
            vehicles = {
                {
                    name = 'Audi A6',
                    spawnName = 'polargento1'
                },
                {
                    name = 'Audi A6 Slicktop',
                    spawnName = 'polargento2'
                },
                {
                    name = 'Thrust Motor',
                    spawnName = 'polthrust'
                },
                {
                    name = 'Unmarked Baller',
                    spawnName = 'upolballer'
                },
                {
                    name = 'Unmarked Streite',
                    spawnName = 'upolstreite'
                },
            }
        },
    },

    air = {
        {
            category = 'Helikopters',
            description = 'Handig voor achtervolgingen',
            rank = 4,
            vehicles = {
                {
                    name = 'EC-135 Zulu',
                    spawnName = 'polzulu'
                },
            }
        }
    },
    sea = {
        {
            category = 'Politie Boten',
            description = 'Controle ter water',
            rank = 0,
            vehicles = {
                {
                    name = 'Politie klein - NIET BESCHIKBAAR',
                    spawnName = 'pbootklein'
                },
                {
                    name = 'Politie Groot - NIET BESCHIKBAAR',
                    spawnName = 'pbootgroot'
                },
            }
        }
    }
}

-- Handcuff systeem

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