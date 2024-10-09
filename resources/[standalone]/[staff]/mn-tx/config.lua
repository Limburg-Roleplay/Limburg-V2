MN = {


    webhook = 'https://discord.com/api/webhooks/1134220573313085551/NKB08ZJuqS5FtKP3rLRJdoNU8liem2f7DCeYHtnHK47KUMPOWEFjr9fmBinJ1fnv8FPs',

    markers = {
        [1] = {
            coords = vector3(234.3493, -753.6935, 34.6386),
            type = 'klok',
            -- draw = '', -- Dit word in de client gezet
            trigger = 'mn-tx:client:klokken'
        },
        [2] = {
            coords = vector3(230.9256, -752.5950, 34.6370),
            draw = '[E] Open voertuig menu', -- Dit word in de client gezet
            trigger = 'mn-tx:client:openVehicleMenu'
        }
    },

    vehicleSpawn = vector4(234.3701, -739.7294, 34.5776, 69.2459),



    staffGarage = {
        {
            label = 'Staff Scootmobiel',
            model = 'boa11'
        },
        {
            label = 'Staff Gemeente Busje',
            model = 'boa11'
        }
    },


--     clothing = {
--         male = {
--             ['tshirt_1'] = 67, ['tshirt_2'] = 0,
--             ['torso_1'] = 471, ['torso_2'] = 4,
--             ['decals_1'] = 0, ['decals_2'] = 0,
--             ['arms'] = 30,
--             ['pants_1'] = 4, ['pants_2'] = 0,
--             ['shoes_1'] = 55, ['shoes_2'] = 0,
--             ['bproof_1'] = 8, ['bproof_2'] = 0,
--             ['glasses_1'] = 0, ['glasses_2'] = 0,
--             ['bag_1'] = 0, ['bag_2'] = 0,
--             ['helmet_1'] = -1, ['helmet_2'] = 0,
--             ['chain_1'] = 0, ['chain_2'] = 0,
--             ['ears_1'] = 0, ['ears_2'] = 0
--         },
--         female = {
--             ['tshirt_1'] = 14, ['tshirt_2'] = 0,
--             ['torso_1'] = 258, ['torso_2'] = 2,
--             ['decals_1'] = 0, ['decals_2'] = 0,
--             ['arms'] = 31,
--             ['pants_1'] = 30, ['pants_2'] = 20,
--             ['shoes_1'] = 43, ['shoes_2'] = 0,
--             ['bproof_1'] = 8, ['bproof_2'] = 0,
--             ['helmet_1'] = -1, ['helmet_2'] = 0,
--             ['chain_1'] = 0, ['chain_2'] = 0,
--             ['ears_1'] = 0, ['ears_2'] = 0
--         }
--     }
-- }

        clothing = {
                ["staff"] = {
                    male = {
                        ["props"] = {
                            [1] = {
                                ["prop_id"] = 0,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                                },
                            [2] = {
                                ["prop_id"] = 1,
                                ["texture"] = 0,
                                ["drawable"] = -1,
                                },
                            [3] = {
                                ["prop_id"] = 2,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                                },
                            [4] = {
                                ["prop_id"] = 6,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                                },
                            [5] = {
                                ["prop_id"] = 7,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                                },
                            },
                        ["components"] = {
                            [1] = {
                                ["drawable"] = 0,
                                ["component_id"] = 0,
                                ["texture"] = 0,
                                },
                            [2] = {
                                ["drawable"] = 0,
                                ["component_id"] = 1,
                                ["texture"] = 0,
                                },
                            [3] = {
                                ["drawable"] = 1,
                                ["component_id"] = 2,
                                ["texture"] = 0,
                                },
                            [4] = {
                                ["drawable"] = 30,
                                ["component_id"] = 3,
                                ["texture"] = 0,
                                },
                            [5] = {
                                ["drawable"] = 4,
                                ["component_id"] = 4,
                                ["texture"] = 0,
                                },
                            [6] = {
                                ["drawable"] = 0,
                                ["component_id"] = 5,
                                ["texture"] = 0,
                                },
                            [7] = {
                                ["drawable"] = 55,
                                ["component_id"] = 6,
                                ["texture"] = 0,
                                },
                            [8] = {
                                ["drawable"] = 0,
                                ["component_id"] = 7,
                                ["texture"] = 0,
                                },
                            [9] = {
                                ["drawable"] = 67,
                                ["component_id"] = 8,
                                ["texture"] = 0,
                                },
                            [10] = {
                                ["drawable"] = 0,
                                ["component_id"] = 10,
                                ["texture"] = 0,
                                },
                            [11] = {
                                ["drawable"] = 471,
                                ["component_id"] = 11,
                                ["texture"] = 4,
                                },
                            [12] = {
                                ["drawable"] = 8,
                                ["component_id"] = 9,
                                ["texture"] = 0,
                                },
                            },
                        },
                    female = {
                        props = {
                            [1] = {
                                ["prop_id"] = 0,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                            },
                            [2] = {
                                ["prop_id"] = 1,
                                ["texture"] = 0,
                                ["drawable"] = 10,
                            },
                            [3] = {
                                ["prop_id"] = 2,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                            },
                            [4] = {
                                ["prop_id"] = 0,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                            },
                            [5] = {
                                ["prop_id"] = 0,
                                ["texture"] = -1,
                                ["drawable"] = -1,
                            },
                        },
                        components = {
                            [1] = {
                                ["texture"] = 0,
                                ["drawable"] = 0,
                                ["component_id"] = 0,
                            },
                            [2] = {
                                ["texture"] = 0,
                                ["drawable"] = 0,
                                ["component_id"] = 1,
                            },
                            [3] = {
                                ["texture"] = 0,
                                ["drawable"] = 0,
                                ["component_id"] = 2,
                            },
                            [4] = {
                                ["texture"] = 0,
                                ["drawable"] = 0,
                                ["component_id"] = 3,
                            },
                            [5] = {
                                ["texture"] = 0,
                                ["drawable"] = 157,
                                ["component_id"] = 4,
                            },
                            [6] = {
                                ["texture"] = 0,
                                ["drawable"] = 0,
                                ["component_id"] = 5,
                            },
                            [7] = {
                                ["texture"] = 0,
                                ["drawable"] = 113,
                                ["component_id"] = 6,
                            },
                            [8] = {
                                ["texture"] = 0,
                                ["drawable"] = 128,
                                ["component_id"] = 7,
                            },
                            [9] = {
                                ["texture"] = 0,
                                ["drawable"] = 15,
                                ["component_id"] = 8,
                            },
                            [10] = {
                                ["texture"] = 0,
                                ["drawable"] = 57,
                                ["component_id"] = 9,
                            },
                            [11] = {
                                ["texture"] = 0,
                                ["drawable"] = 0,
                                ["component_id"] = 10,
                            },
                            [12] = {
                                ["texture"] = 0,
                                ["drawable"] = 440,
                                ["component_id"] = 11,
                            }
                        }
                    }
                }
            }
        }