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
Config.BlipSprite  = 141
Config.BlipDisplay = 4
Config.BlipScale   = 0.9
Config.BlipColour  = 0
Config.Blips = {
	{
		BlipLabel = 'Kmar Bureau',
		Coords = vector3(1855.4724, 3683.3022, 34.2677)
	},
    {
        BlipLabel = 'Kmar Bureau',
        Coords = vector3(-443.6259, 6007.4951, 40.5014)
    },
}

Config.Locations = {
    {
        coords = vector3(1850.0548, 3679.7312, 34.2680),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(1854.1929, 3675.1921, 33.7250, 207.0812),
            [2] = vector4(1850.8568, 3673.4558, 33.7519, 208.6271),
            [3] = vector4(1847.8295, 3671.7051, 33.7041, 212.1566)
        }
    },
    {
        coords = vector3(-462.6208, 6029.4497, 31.3404),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-468.9777, 6038.7051, 31.3404, 215.9077),
            [2] = vector4(-476.2583, 6032.2788, 31.3404, 212.5450),
            [3] = vector4(-484.0569, 6000.3379, 31.3116, 313.5390)
        }
    },
    {
        coords = vector3(-387.5143, -373.0611, 24.7567),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-381.6289, -365.5994, 24.7567, 79.1236),
            [2] = vector4(-381.0368, -361.2334, 24.7567, 80.4528),
            [3] = vector4(-380.4119, -357.0779, 24.7567, 75.5964)
        }
    },
    {
        coords = vector3(1841.0847, 3669.5417, 33.6799),
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'any',
    },
    {
        coords = vector3(-482.4638, 6024.4810, 31.3404),
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'any',
    },
    { -- Boven
        coords = vector3(1849.5659, 3695.5259, 34.2370),
        drawText = 'Omkleden',
        functionDefine = CloakroomMenu,
    },
    { -- Boven
        coords = vector3(-438.9825, 6011.3320, 36.9884),
        drawText = 'Omkleden',
        functionDefine = CloakroomMenu,
    },
    {
        coords = vector3(1853.0875, 3689.0911, 34.2586),
        drawText = 'In-/uitklokken',
        functionDefine = OnOffDuty,
    },
    {-- DSI
        coords = vector3(-87.5487, -814.8098, 36.1005),
        drawText = 'In-/uitklokken',
        functionDefine = OnOffDuty,
    },
    {-- DSI
        coords = vector3(1841.9551, 3691.2881, 34.2511),
        drawText = 'Wapens/munitie pakken',
        functionDefine = GetGear
    },
    {-- DSI
    coords = vector3(-402.8850, -376.9263, 25.0935),
    drawText = 'Wapens/munitie pakken',
    functionDefine = GetGear
},
    {-- DSI
    coords = vector3(-448.7558, 6013.3496, 36.9956),
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
        coords = vector3(1779.2601, 3641.0286, 34.4936),
        rank = 4,
        drawText = 'Garage',
        type = 'airport',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(1772.0979, 3654.4861, 34.4018, 300.3221)
            
        }
    },
    {
        coords = vector3(-464.1145, 5976.3696, 31.3038),
        rank = 4,
        drawText = 'Garage',
        type = 'airport',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-476.6231, 5987.3477, 31.3365, 317.3432)
            
        }
    },
    {
        coords = vector3(1774.1993, 3654.0610, 34.3759),
        rank =  4,
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'heli',
    },
    {
        coords = vector3(-476.6231, 5987.3477, 31.3365),
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
            category = 'Grenspolitie',
            description = 'Grenspolitie Voertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'KMar Everon',
                    spawnName = 'kmareveron'
                },
                {
                    name = 'KMar Unglu',
                    spawnName = 'unglukmar'
                },
                {
                    name = 'KMar Bober',
                    spawnName = 'boberkmar'
                },
            }
        },
        {
            category = 'VP',
            description = 'KMar VPs',
            rank = 2,
            vehicles = {
                {
                    name = 'KMar Argento',
                    spawnName = 'kmarargent2'
                },
                {
                    name = 'KMar Thrust',
                    spawnName = 'kmarthrust'
                },
            }
        },
        {
            category = 'HRB',
            description = 'KMar HRB',
            rank = 4,
            vehicles = {
                {
                    name = 'KMar Baller',
                    spawnName = 'upolballer'
                },
                {
                    name = 'KMar Dubstag',
                    spawnName = 'kmardubstag'
                },
                {
                    name = 'KMar Streite',
                    spawnName = 'upolstreite'
                },
            }
        },
        {
            category = ' Dienst Speciale Interventies',
            description = ' DSI voertuigen',
            rank = 8,
            vehicles = {
                {
                    name = 'DSI - Audi Q7 - NIET BESCHIKBAAR',
                    spawnName = 'DSIQ7'
                },
                {
                    name = 'DSI - Audi RS6 - NIET BESCHIKBAAR',
                    spawnName = 'DSIrmodrs6'
                },
                {
                    name = 'DSI - X5MC - NIET BESCHIKBAAR',
                    spawnName = 'DSIx5mc'
                },
                {
                    name = 'DSI - Ford Transit Bus - NIET BESCHIKBAAR',
                    spawnName = 'DSIGC_22transCIV'
                },
                {
                    name = 'DSI - SRT8 - NIET BESCHIKBAAR',
                    spawnName = 'DSIsrt8'
                },
                {
                    name = 'DSI - Brabus 800 - NIET BESCHIKBAAR',
                    spawnName = 'DSIrmode63s'
                },
                {
                    name = 'DSI - Africat - NIET BESCHIKBAAR',
                    spawnName = 'DSIafricat'
                },
                {
                    name = 'DSI - Porsche Panamera - NIET BESCHIKBAAR',
                    spawnName = 'DSIrmodpanamera2'
                },
                {
                    name = 'DSI - Golf 7 - NIET BESCHIKBAAR',
                    spawnName = 'DSIgolf7'
                },
            }
        }
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
                {
                    name = 'AW-139 Agusta - NIET BESCHIKBAAR',
                    spawnName = 'dsiheli1'
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