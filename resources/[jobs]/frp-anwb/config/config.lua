Config = {}

Config.EnableESXService = false

Config.Setup = {
    ['ProgressBars'] = {
        ['ReceiveVehicle'] = 3500,
        ['RemoveVehicle'] = 3500,
        ['WashVehicle'] = 10000
    }
}


--------//////////Dit zijn de script namen die de anwbjob nodig heeft dus als je resource renamt dan moet je het ook hier veranderen\\\\\\\\\\--------
Config.Notify = 'frp-notifications'
Config.interaction = 'frp-interaction'
Config.Jobsmenu = 'frp-jobsmenu'
Config.Carkeys = 'frp-carkeys'
Config.Benzine = 'frp-benzine'
Config.Kleding = 'frp-clothingmenu'
Config.Progress = 'frp-progressbar'
--------//////////Dit zijn de script namen die de anwbjob nodig heeft dus als je resource renamt dan moet je het ook hier veranderen\\\\\\\\\\--------

Config.BlipSprite  = 446
Config.BlipDisplay = 4
Config.BlipScale   = 0.9
Config.BlipColour  = 47
Config.Blips = {
	{
		BlipLabel = 'Wegenwacht',
		Coords = vector3(-334.14, -139.14, 39.01)
	}
}

Config.Timers = { -- Seconde * 1000
      TrailerSelectTimer = 5000,
      VehicleSelectTimer = 5000,
}

Config.Peds = {
	-- {
	-- 	model = 's_m_m_gaffer_01',
	-- 	coords = vector3(815.7990, -886.1822, 25.2508),
	-- 	heading = 110.9,
	-- 	scenario = 'WORLD_HUMAN_CLIPBOARD_FACILITY',
	-- },
}


Config.Locations = {
	-- Weazel news
    {
        coords = vector3(-354.9576, -153.5169, 39.0137),
        drawText = 'Garage',
        functionDefine = OpenGarage,
        spawnPoints = {                   
            [1] = vector4(-368.64, -110.81, 38.68, 115.39),
        }
    },
    {
        coords = vector3(-363.88, -146.13, 38.25),
        drawText = 'Voertuig wegzetten',
        functionDefine = DeleteVehicle,
        deleteType = 'any',
    },
    { -- Beneden
        coords = vector3(-341.4538, -162.1770, 44.5875),
        drawText = 'Omkleden',
        functionDefine = CloakroomMenu,
    },
    {
        coords = vector3(-346.4986, -128.2746, 39.0115),
        drawText = 'In-/uitklokken',
        functionDefine = OnOffDuty,
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
}

Config.Actions = {
    repairVehicle = {
        actions = {
            animation = {
                enabled = true,
                scenario = 'PROP_HUMAN_BUM_BIN',
                duration = 15000,
            }
        }
    },
    washVehicle = {
        actions = {
            animation = {
                enabled = true,
                scenario = 'WORLD_HUMAN_MAID_CLEAN',
                duration = 10000,
            }
        }
    },
}

Config.Vehicles = {
    cars = {
        {
            category = 'Dienstvoertuigen',
            description = 'Reguliere dienstvoertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'Volkswagen Buzz',
                    spawnName = 'anwbbuzz'
                },
                {
                    name = 'Mercedes Vito',
                    spawnName = 'anwbvito'
                },
                {
                    name = 'Volkswagen T6.1',
                    spawnName = 'anwbt6'
                },
            }
        },
        {
            category = 'Offroad',
            description = 'Reguliere dienstvoertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'Volkswagen Amarok',
                    spawnName = 'amarokanwb'
                },
                {
                    name = 'Ford Raptor',
                    spawnName = 'anwboffroad'
                },
            }
        },
        {
            category = 'Speciaal',
            description = 'Speciale voertuigen',
            rank = 0,
            vehicles = {
                {
                    name = 'Mercedes Flatbed',
                    spawnName = 'flatbed'
                }
            }
        },
    }
}