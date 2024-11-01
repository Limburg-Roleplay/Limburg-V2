Config = {}

--- Options ---
Config.MoneyPerDelivery = 2500 -- Money per Delivery
Config.DeliveryFinalMoney = 1000 -- Final Money
Config.ActivateDamage = true -- if true will depend on the life of the truck and will be deaccountanted from the Final Money.
Config.DeleteTruckWhenFinish = false -- Will truck be deleted when finish the job?

Config.AddDeliveryTruck = true -- Will the player have to delivery the truck when finish the job?
Config.DeliveryTruckNotification = 'Breng de truck terug naar de marker!'
Config.CoordDeliveryTruck = vector3(-65.64, -2500.52, 6.00)
Config.MarkerDeliveryTruck = '[ ~g~E ~w~] Lever truck in'
Config.VehicleDelivered = 'Je hebt je route afgerond, goed bezig!'

Config.SpawnPointTrucker = { x = -102.83, y = -2529.71, z = 6.0 } -- Where Trucker will Spawn?
Config.TeleportPlayerToTruck = true -- Teleport Player to truck when spawn?
----

--- Messages ---
Config.ReceiveMoney = 'Je hebt ' .. Config.MoneyPerDelivery .. '€ ontvangen voor de levering.'
Config.ReceiveFinalMoney = 'Je hebt ' .. Config.DeliveryFinalMoney .. '€ verdiend voor de laatste levering.'
Config.ALittleBroken = 'Het lijkt erop dat de vrachtwagen een beetje beschadigd is, je zult minder verdienen.'
Config.Broken = 'De vrachtwagen lijkt nauwelijks nog te werken! Je zult hiervoor moeten betalen.'
Config.NeedDeliveryFirst = '~r~Je moet eerst de andere locatie leveren.'
---

--- Progress Bar ---
Config.Duration = 7500 -- In MS
Config.Label = 'Afleveren'
Config.DisableMouse = false
----

Config.Menus = {
    ['start'] = {
        name = 'Trucker',
        label = 'Start een route'
    },
    ['trucks'] = {
        name = 'Kies een truck',
        options = {"phantom","phantom3","packer","hauler"}
    },
    ['trailers'] = {
        name = 'Kies een route',
        options = {
            ['trailers2'] = { -- Name of trailer model, can add/remove more trailers.
                name = 'Trailers2 (kort)',
                route = 'route1' -- can change to route1/2/3/4.
            },
            ['trailers4'] = {
                name = 'trailer4 (kort)',
                route = 'route1' 
            },
            ['trailers3'] = {
                name = 'Trailer 3 (gemiddeld)',
                route = 'route2' 
            },
            ['tanker2'] = {
                name = 'Tanker 2 (lang)',
                route = 'route3' 
            }
        }
    },
    ['confirm'] = {
        name = 'Start de route?',
        yes = {label = 'Yes'},
        no = {label = 'No'}
    }
}

Config.Markers = {
    ['start_job'] = {
        name = 'Start',
        cancel = 'Cancel',
        event = 'ry_truckerjob:start_job',
        coord = vector3(-59.63,-2523.16,6.15),
        marker = {
            type = 2, -- can found in https://docs.fivem.net/docs/game-references/markers/
            size  = {x = 0.5, y = 0.5, z = 0.5},
            color = {r = 204, g = 204, b = 0}
        },
        blip = {
            Name = 'Trucker Job',
            Sprite = 67,
            Scale = 0.8,
            Colour = 5
        }
    },
}

Config.Routes = {
    -- Route1
    ['route1'] = {
        ['locations'] = {
            [1] = {
                active = false, -- don't change
                delivered = false, -- don't change
                event = 'ry_truckerjob:delivery', 
                coord = vector3(824.7958, -2476.1877, 23.6801),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [2] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:delivery', 
                coord = vector3(1092.4661, -2328.0022, 30.1700),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            }, 
            [3] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:delivery', 
                coord = vector3(-1022.1234, -2369.8826, 13.9443),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [4] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-760.5409, -2588.6130, 13.8652),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [5] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:delivery', 
                coord = vector3(87.0550, -2559.9954, 6.0000),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            }
        }
    },
    ['route2'] = {
        ['locations'] = {
            [1] = {
                active = false, -- don't change
                delivered = false, -- don't change
                event = 'ry_truckerjob:delivery', 
                coord = vector3(511.0227, -2295.3008, 5.9173),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [2] = {
                active = false, -- don't change
                delivered = false, -- don't change
                event = 'ry_truckerjob:delivery', 
                coord = vector3(887.0851, -1595.5771, 30.1856),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [3] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:delivery', 
                coord = vector3(1053.1710, 221.1753, 80.8558),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [4] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(1529.1807, 834.7703, 77.4519),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [5] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(1208.9452, 2716.7874, 38.0041),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [6] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(562.5426, 2733.1533, 42.0592),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [7] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(161.4566, 2761.5059, 43.2922),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [8] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-1159.6628, 2669.0508, 18.0937),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [9] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-3122.1338, 1130.5939, 20.4063),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [10] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-3019.3994, 349.3483, 14.6097),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [11] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-2182.0757, -390.1380, 13.3254),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [12] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-1731.5979, -738.5318, 10.3677),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [13] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(733.4273, -2317.0869, 26.5996),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            }
        }
    },
    ['route3'] = {
        ['locations'] = {
            [1] = {
                active = false, -- don't change
                delivered = false, -- don't change
                event = 'ry_truckerjob:delivery', 
                coord = vector3(124.2818, -2542.5642, 5.9957),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [2] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:delivery', 
                coord = vector3(801.5810, -2020.7671, 29.2722),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            }, 
            [3] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:delivery', 
                coord = vector3(878.4031, -1078.8988, 29.5156),
                marker = {
                    type = 21,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [4] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(858.5779, 80.9609, 68.5446),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [5] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(1544.0144, 861.9641, 77.4445),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [6] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(2679.4026, 3458.7930, 55.7369),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [7] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(2893.7385, 4380.9897, 50.3545),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [8] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(2540.0266, 4661.3926, 34.0750),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [9] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(1632.0620, 6420.7842, 27.7734),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [10] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(19.8825, 6285.4434, 31.2304),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [11] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-1531.0969, 4993.0156, 62.3129),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [12] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-2365.6619, 4068.4541, 31.5432),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [13] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-3095.2021, 1352.1301, 20.1997),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [14] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-1579.0726, -653.3010, 29.5262),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [15] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-578.4907, -902.9357, 25.6813),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [16] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(-6.3457, -1023.7719, 28.9990),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [17] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(411.7603, -1612.5084, 29.2866),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            },
            [18] = {
                active = false,
                delivered = false,
                event = 'ry_truckerjob:last_delivery', 
                coord = vector3(233.5771, -2537.5479, 5.8609),
                marker = {
                    type = 2,
                    text = "[ ~g~E ~w~] ~w~To Delivery",
                    text_delivered = "~y~Afgeleverd, ga naar het nieuwe punt!",
                    size  = {x = 0.5, y = 0.5, z = 0.5},
                    color = {r = 204, g = 204, b = 0}
                },
            }
        }
    },

    -- Don't add more
}