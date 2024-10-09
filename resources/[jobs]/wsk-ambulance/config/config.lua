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

local second = 1000
local minute = 60 * second

Config.BillCost = 2000
Config.AIHealTimer = 20 -- How long it will take to be healed after checking in, in seconds

Config.RespawnTimer = 3 * minute
Config.BleedoutTimer = 10 * minute
Config.Pleistertimer = 5
Config.KnockoutTimer 			  = 5 * minute
Config.knockOutWeapons 			  = {
	[`WEAPON_UNARMED`] = true,
	[`WEAPON_NIGHTSTICK`] = true
}

Config.RespawnPoint = vector4(351.9720, -588.6777, 28.7968, 248.5847)


--------//////////Dit zijn de script namen die de ambujob nodig heeft dus als je resource renamt dan moet je het ook hier veranderen\\\\\\\\\\--------
Config.Notify = 'frp-notifications'
Config.interaction = 'frp-interaction'
Config.Jobsmenu = 'frp-jobsmenu'
Config.Carkeys = 'frp-carkeys'
Config.Benzine = 'frp-benzine'
Config.Kleding = 'frp-clothingmenu'
Config.Progress = 'frp-progressbar'
--------//////////Dit zijn de script namen die de ambujob nodig heeft dus als je resource renamt dan moet je het ook hier veranderen\\\\\\\\\\--------


Config.BlipSprite  = 61
Config.BlipDisplay = 4
Config.BlipScale   = 0.9
Config.Blips = {
	{
		BlipLabel = 'Ziekenhuis',
		Coords = vector3(310.1051, -589.3291, 43.2840)
	},
    {
		BlipLabel = 'Paleto Ziekenhuis',
		Coords = vector3(-250.3376, 6319.4536, 32.4273)
	}
}

Config.Peds = {
	-- {
	-- 	model = 's_m_m_gaffer_01',
	-- 	coords = vector3(458.99, -1007.72, 28.26),
	-- 	heading = 110.9,
	-- 	scenario = 'WORLD_HUMAN_CLIPBOARD_FACILITY',
	-- },
}

Config.Gear = {
    {
        name = 'radio',
        count = 1,
    },
}

Config.CheckIn = {
    beds = {
        [1] = {coords = vector4(314.4869, -584.2539, 44.2039, 338.8562), taken = false, model = 1631638868},
        [2] = {coords = vector4(317.7459, -585.4700, 44.2039, 341.8416), taken = false, model = 1631638868},
        [3] = {coords = vector4(322.6343, -587.1966, 44.2039, 337.4828), taken = false, model = 2117668672},
        [4] = {coords = vector4(324.1082, -582.9505, 44.2039, 159.4762), taken = false, model = 2117668672},
        [5] = {coords = vector4(319.2556, -581.1628, 44.2039, 158.6586), taken = false, model = 2117668672},
        [6] = {coords = vector4(313.7766, -579.0840, 44.2039, 159.6420), taken = false, model = -1091386327},
        [7] = {coords = vector4(309.2277, -577.4340, 44.2039, 160.0815), taken = false, model = -1091386327},
        [8] = {coords = vector4(307.8128, -581.6453, 44.2039, 337.5186), taken = false, model = -1091386327},
        [9] = {coords = vector4(-255.9147, 6315.4971, 33.3421, 313.4537), taken = false, model = 2117668672},
        [10] = {coords = vector4(-252.3871, 6312.1260, 33.3422, 316.1042), taken = false, model = 2117668672},
        [11] = {coords = vector4(-246.9222, 6318.0229, 33.3421, 133.2083), taken = false, model = 2117668672},
        [12] = {coords = vector4(-252.2010, 6323.2178, 33.3421, 135.9671), taken = false, model = 2117668672},
    },

    Researchtable = {
        [1] = {coords = vector4(326.74, -571.12, 42.55, 160.00), taken = false, model = -1519439119},
        [2] = {coords = vector4(315.34, -566.44, 42.55, 160.00), taken = false, model = -1519439119},
        [3] = {coords = vector4(321.12, -568.44, 42.55, 160.00), taken = false, model = -1519439119},
        [4] = {coords = vector4(336.99, -575.23, 42.55, 160.00), taken = false, model = -289946279},
        [5] = {coords = vector4(348.66, -579.46, 42.55, 160.00), taken = false, model = -289946279},
    },

    checkIn = {
        [1] = {
            coords = vector3(307.67, -595.56, 42.28),
            length = 2.8,
            height = 1.4,
            heading = 340.0
        },
        [2] = {
            coords = vector3(312.18, -593.74, 42.28),
            length = 1.6,
            height = 3.0,
            heading = 340.0
        },
        [3] = {
            coords = vector3(-255.8932, 6332.1489, 31.7106),
            length = 1.6,
            height = 3.0,
            heading = 135.0049
        }
    },

    bedModels = {
        `v_med_bed1`
    },
    researchtable = {
        -1519439119,
        -289946279
    }
}

Config.Teleports = {
    menus = {
        [1] = { -- Begane grond
            coords = vector3(342.20, -585.46, 28.79)
        },
        [2] = {
            coords = vector3(332.41, -595.69, 43.28)
        },
        [3] = { -- Helipad
            coords = vector3(338.73, -583.84, 74.16)
        }
    },
    
    options = {
        [1] = {
            label = 'Begane Grond', 
            desc = 'Hier pakken wij de voertuigen van de Ambulance',
            coords = vector4(342.20, -585.46, 28.79, 241.07)
        },

        [2] = {
            label = '1e Verdieping', 
            desc = 'De algemene behandel plaats van de Ambulance',
            coords = vector4(332.41, -595.69, 43.28, 72.04)
        },

        [3] = {
            label = 'Heliplatform', 
            desc = 'Een plaats om de lifeliner te pakken',
            coords = vector4(338.73, -583.84, 74.16, 250.29)
        }
    }
}

Config.Locations = {
	-- Weazel news
    {
        coords = vector3(319.9913, -584.9776, 28.7968),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(316.2316, -577.8825, 29.1286, 250.9682),
            [2] = vector4(317.9458, -573.6398, 29.1287, 249.5804),
            [3] = vector4(319.3202, -569.5412, 29.1285, 249.8482),
            [4] = vector4(320.6986, -565.3728, 29.1288, 248.0522)
        }
    },
    {
        coords = vector3(331.5616, -579.9094, 28.7969),
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'any',
    },
    { -- Beneden
        coords = vector3(300.7103, -597.4767, 43.2841),
        drawText = 'Omkleden',
        functionDefine = CloakroomMenu,
    },
    {
        coords = vector3(304.3295, -600.3444, 43.2841),
        drawText = 'In-/uitklokken',
        functionDefine = OnOffDuty,
    },
    {
        coords = vector3(303.6837, -569.9716, 43.2841),
        drawText = 'Werkspullen pakken',
        functionDefine = GetGear
    },
    {
        coords = vector3(339.1799, -589.6369, 43.2821),
        rank = 7,
        drawText = 'Baas acties',
        functionDefine = OpenManagement,
    },
	-- {
    --     drawText = 'Management openen',
    --     drawIcon = 'fas fa-database',
    --     target = true,
    --     coords = vector3(457.09, -993.33, 30.72),
    --     length = 0.4,
    --     width = 0.4,
    --     height = 0.4,
    --     heading = 0,
    --     functionDefine = ManagementMenu,
	-- 	rank = 6
    -- },

	-- -- Helipad
	{
        coords = vector3(339.4818, -587.1909, 74.1617),
        rank = 4,
        drawText = 'Garage',
        type = 'airport',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(350.9586, -588.0869, 74.1617, 273.1078)
        }
    },
	{
        coords = vector3(351.4418, -587.9977, 74.1617),
        rank = 4,
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'heli',
    },
}

Config.WhitelistedBrancard = {
    [1] = GetHashKey('ablokkendoos'),
    [2] = GetHashKey('asprinter'),
    [3] = GetHashKey('aoffroad'),
    [4] = GetHashKey('amicu'),
    [5] = GetHashKey('ambucrafter'),
    [6] = GetHashKey('ambuman'),
    [7] = GetHashKey('ambu14'),
    ['coords'] = {
        [GetHashKey('ablokkendoos')] = vec3(-0.5, -1.0, -0.5),
        [GetHashKey('asprinter')] = vec3(0, -1.0, -0.5),
        [GetHashKey('aoffroad')] = vec3(-0.5, -1.0, -0.5),
        [GetHashKey('amicu')] = vec3(-0.5, -1.0, -0.5),
        [GetHashKey('ambucrafter')] = vec3(-0.5, -1.0, -0.5),
        [GetHashKey('amiambumancu')] = vec3(-0.5, -1.0, -0.5),
        [GetHashKey('ambu14')] = vec3(-0.5, -1.0, -0.5),
    }
}

Config.Vehicles = {
    cars = {
        {
            category = 'Dienstvoertuigen',
            description = 'Reguliere dienstvoertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'Mercedes-Benz Sprinter 2019',
                    spawnName = 'asprinter'
                },
                {
                    name = 'Mercedes-Benz Sprinter 2019 Blokkendoos',
                    spawnName = 'ablokkendoos'
                },
                {
                    name = 'Volkswagen OFFROAD',
                    spawnName = 'aoffroad'
                },
                {
                    name = 'Mercedes Vito',
                    spawnName = 'ambuvito'
                },
            }
        },
        {
            category = 'Rapid',
            description = 'Rapid Responder voertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'Volvo XC40 (RR)',
                    spawnName = 'axc40'
                }
            }
        },
        {
            category = 'Speciaal',
            description = 'Speciale voertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'Volvo Micu',
                    spawnName = 'amicu'
                },
            }
        },
    },
    air = {
        {
            category = 'Trauma Helikopter',
            description = 'Handig voor snelle acties',
            rank = 0,
            vehicles = {
                {
                    name = 'EC-135 (NIET WERKEND)',
                    spawnName = 'ambu1'
                }
            }
        }
    }
}

Config.Declared = 'Persoon dood verklaard!' -- This Msg appeared when the player died using /med [id] to display blood = 0 - 5% and Hurt area is Head

Config.Timer = 8   -- Timer to Remove Med Display after using MedSystem