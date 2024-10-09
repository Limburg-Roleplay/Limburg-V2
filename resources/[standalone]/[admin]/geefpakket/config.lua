Config = {}
Config.packages = {

-- 2000 Leden Pack

    ["2000ledenpack"] = {
        title = "2000 Leden Pack",
        items = {
            ["WEAPON_BENELLIM4"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_BENELLIM4", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_NVRIFLE"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_NVRIFLE", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-shotgun"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-shotgun", amount = 50 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["w_at_sg_benellim4_supp"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "w_at_sg_benellim4_supp", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["w_at_nvrifle_afgrip"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "w_at_nvrifle_afgrip", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["w_ar_nvrifle_mag2"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "w_ar_nvrifle_mag2", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["w_at_nvrifle_scope_small"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "w_at_nvrifle_scope_small", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["w_at_nvrifle_supp"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "w_at_nvrifle_supp", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["cash"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "cash", amount = 500000 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "gemera", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

-- Summerpack 2024

    ["summerpack2024lfa"] = {
        title = "500 leden pakket",
        items = {
            ["WEAPON_BENELLIM4"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_BENELLIM4", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_MB47"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_MB47", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-shotgun"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-shotgun", amount = 50 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["cash"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "cash", amount = 500000 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "lfa", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

    ["summerpack2024g63"] = {
        title = "500 leden pakket",
        items = {
            ["WEAPON_BENELLIM4"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_BENELLIM4", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_MB47"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_MB47", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-shotgun"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-shotgun", amount = 50 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["cash"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "cash", amount = 500000 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "22g63", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

    ["summerpack2024m3"] = {
        title = "500 leden pakket",
        items = {
            ["WEAPON_BENELLIM4"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_BENELLIM4", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_MB47"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_MB47", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-shotgun"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-shotgun", amount = 50 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["cash"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "cash", amount = 500000 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "22m3", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

    ["4000ledenpack"] = {
        title = "4000 leden pakket",
        items = {
            ["WEAPON_DOUBLEBARRELFM"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_DOUBLEBARRELFM", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_PISTOL50"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_PISTOL50", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-shotgun"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-shotgun", amount = 50 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-pistol"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "m3csf80", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

    ["5000ledenpack"] = {
        title = "5000 Leden Pack",
        items = {
            ["WEAPON_MB47"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_MB47", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["money"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "money", amount = 1000000 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "gemera", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
            ["car2"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "lykan", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

    ["blockbundle"] = {
        title = "The Block Bundle",
        items = {
            ["WEAPON_NVRIFLE"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_NVRIFLE", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_GLOCK19X"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_GLOCK19X", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-pisol"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-pisol", amount = 100 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "money", amount = 500000 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "21durangowb", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
            ["car2"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "bagger", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords" },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

    ["summerpack2024mk7"] = {
        title = "500 leden pakket",
        items = {
            ["WEAPON_BENELLIM4"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_BENELLIM4", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_MB47"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_MB47", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-shotgun"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-shotgun", amount = 50 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["cash"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "cash", amount = 500000 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "rmodmk7", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords"              },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

-- Beginnerspack V1

    ["beginnerspackv1"] = {
        title = "Beginnerspack V1",
        items = {
            ["WEAPON_SIG"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_SIG", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-pistol"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-pistol", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["sigscope2"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "sigscope2", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["sigsupp"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "sigsupp", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "rmodmk7", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords"              },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

-- Beginnerspack Ultimate

    ["beginnerspackultimate"] = {
        title = "Beginnerspack Ultimate",
        items = {
            ["WEAPON_SIG"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_SIG", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_FM1_M9A3"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_FM1_M9A3", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-pistol"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-pistol", amount = 300 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["sigscope2"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "sigscope2", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["sigsupp"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "sigsupp", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "sti12", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords"              },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },

-- Mega Ultimate Pack

    ["megaultimatepack"] = {
        title = "Mega Ultimate Pack",
        items = {
            ["WEAPON_BENELLIM4"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_BENELLIM4", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_AKS74U"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_AKS74U", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_HKUMP"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_HKUMP", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["WEAPON_MINIUZI"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "WEAPON_MINIUZI", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-rifle"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-rifle", amount = 150 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-smg"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-smg", amount = 300 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["ammo-shotgun"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "ammo-shotgun", amount = 300 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ak74u_clip_09"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ak74u_clip_09", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ak74u_scope_13"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ak74u_scope_13", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ak74u_flash_10"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ak74u_flash_10", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ak74u_muzzle_09"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ak74u_muzzle_09", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ump_sup_04"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ump_sup_04", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ump_sight_03"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ump_sight_03", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ump_sight_06"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ump_sight_06", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ump_grip_01"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ump_grip_01", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ump_flashlight_01"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ump_flashlight_01", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_ump_clip_02"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_ump_clip_02", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_uzi_scope6"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_uzi_scope6", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_uzi_stock2"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_uzi_stock2", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_uzi_clip4"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_uzi_clip4", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["at_uzi_supp2"] = {
                type = 'item',
                event = 'td_refunds:insertRefund',
                params = { steam_id = ":playerSteam", item_name = "at_uzi_supp2", amount = 1 },
                paramOrder = { "steam_id", "item_name", "amount" },
                eventType = 'server' -- 'server' or 'client'
            },
            ["car1"] = {
                type = 'car',
                event = 'esx_giveownedcar:spawnVehicle',
                params = { source = ":playerSrc", car_model = "rmodrs6", playername = ":playerName", type = "console", vehicleType = "car", coords = ":playerCoords"              },
                paramOrder = { "car_model", "playername", "type", "vehicleType", "coords" },
                eventType = 'client' -- 'server' or 'client'
            },
        }
    },
}
