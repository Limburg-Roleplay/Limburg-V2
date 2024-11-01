Shared = {}

Shared.Borg = 1500

Shared.Locations = {
    [1] = {
        ['job'] = 'vuilnisman',
        ['color'] = {r = 71, g = 61, b = 26},
        ['Outfit'] = {
            ['Male'] = {
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
                    ["drawable"] = 73,
                    ["component_id"] = 2,
                    ["texture"] = 0,
                    },
                [4] = {
                    ["drawable"] = 0,
                    ["component_id"] = 5,
                    ["texture"] = 0,
                    },
                [5] = {
                    ["drawable"] = 0,
                    ["component_id"] = 7,
                    ["texture"] = 0,
                    },
                [6] = {
                    ["drawable"] = 0,
                    ["component_id"] = 9,
                    ["texture"] = 0,
                    },
                [7] = {
                    ["drawable"] = 0,
                    ["component_id"] = 10,
                    ["texture"] = 0,
                    },
                [8] = {
                    ["drawable"] = 99,
                    ["component_id"] = 3,
                    ["texture"] = 9,
                    },
                [9] = {
                    ["drawable"] = 36,
                    ["component_id"] = 4,
                    ["texture"] = 0,
                    },
                [10] = {
                    ["drawable"] = 27,
                    ["component_id"] = 6,
                    ["texture"] = 0,
                    },
                [11] = {
                    ["drawable"] = 56,
                    ["component_id"] = 11,
                    ["texture"] = 0,
                    },
                [12] = {
                    ["drawable"] = 59,
                    ["component_id"] = 8,
                    ["texture"] = 1,
                    },
                },
            ["props"] = {
                [1] = {
                    ["drawable"] = 0,
                    ["texture"] = 0,
                    ["prop_id"] = 1,
                    },
                [2] = {
                    ["drawable"] = -1,
                    ["texture"] = -1,
                    ["prop_id"] = 2,
                    },
                [3] = {
                    ["drawable"] = -1,
                    ["texture"] = -1,
                    ["prop_id"] = 6,
                    },
                [4] = {
                    ["drawable"] = -1,
                    ["texture"] = -1,
                    ["prop_id"] = 7,
                    },
                [5] = {
                    ["drawable"] = 58,
                    ["texture"] = 1,
                    ["prop_id"] = 0,
                    },
                }
            },
            ['Female'] = {
                ["props"] = {
                    [1] = {
                        ["prop_id"] = 0,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [2] = {
                        ["prop_id"] = 1,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [3] = {
                        ["prop_id"] = 2,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [4] = {
                        ["prop_id"] = 6,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [5] = {
                        ["prop_id"] = 7,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    },
                    ["components"] = {
                        [1] = {
                            ["drawable"] = 0,
                            ["texture"] = 0,
                            ["component_id"] = 0,
                            },
                        [2] = {
                            ["drawable"] = 0,
                            ["texture"] = 0,
                            ["component_id"] = 1,
                            },
                        [3] = {
                            ["drawable"] = 101,
                            ["texture"] = 0,
                            ["component_id"] = 2,
                            },
                        [4] = {
                            ["drawable"] = 12,
                            ["texture"] = 0,
                            ["component_id"] = 3,
                            },
                        [5] = {
                            ["drawable"] = 15,
                            ["texture"] = 0,
                            ["component_id"] = 4,
                            },
                        [6] = {
                            ["drawable"] = 112,
                            ["texture"] = 3,
                            ["component_id"] = 5,
                            },
                        [7] = {
                            ["drawable"] = 133,
                            ["texture"] = 1,
                            ["component_id"] = 6,
                            },
                        [8] = {
                            ["drawable"] = 0,
                            ["texture"] = 0,
                            ["component_id"] = 7,
                            },
                        [9] = {
                            ["drawable"] = 272,
                            ["texture"] = 1,
                            ["component_id"] = 8,
                            },
                        [10] = {
                            ["drawable"] = 0,
                            ["texture"] = 0,
                            ["component_id"] = 9,
                            },
                        [11] = {
                            ["drawable"] = 0,
                            ["texture"] = 0,
                            ["component_id"] = 10,
                            },
                        [12] = {
                            ["drawable"] = 517,
                            ["texture"] = 3,
                            ["component_id"] = 11,
                        },
                    },
            }
        },
        ['inklok'] = {['coords'] = vector3(-321.5921, -1545.8735, 31.0199)},
        ['verkoop'] = {['coords'] = vector3(-349.7739, -1569.7914, 25.2238)},
        ['salaryPerAction'] = function() return math.random(180, 410) end,
        ['vehicle'] = {
            ['spawnname'] = GetHashKey('trash2'),
            ['coords'] = {
                [1] = {
                    ['vector'] = vector3(-331.3730, -1522.3898, 27.5369),
                    ['heading'] = 269.0745
                },
                [2] = {
                    ['vector'] = vector3(-316.8691, -1538.2336, 27.6593),
                    ['heading'] = 352.9252
                },
            },
            ['removeLocation'] = vector3(-309.9414, -1524.8241, 27.5287)
        },
        ['blip'] = {
            ['sprite'] = 318,
            ['color'] = 2,
            ['text'] = 'Vuilnisman'
        },
        ['actions'] = {
            [1] = {['coords'] = vector3(118.1909, -1943.9821, 20.6627), ['ready'] = false, ['taked'] = false},
            [2] = {['coords'] = vector3(17.4844, -1847.3771, 24.1630), ['ready'] = false, ['taked'] = false},
            [3] = {['coords'] = vector3(251.3353, -1688.9529, 29.2467),  ['ready'] = false, ['taked'] = false},
            [4] = {['coords'] = vector3(481.9186, -1388.4916, 29.4229),  ['ready'] = false, ['taked'] = false},
            [5] = {['coords'] = vector3(379.5966, -1117.9514, 29.4064), ['ready'] = false, ['taked'] = false},
            [6] = {['coords'] = vector3(294.1375, -995.4436, 29.2725), ['ready'] = false, ['taked'] = false},
            [7] = {['coords'] = vector3(98.1657, -294.6700, 46.2300),  ['ready'] = false, ['taked'] = false},
            [8] = {['coords'] = vector3(80.3767, 66.4326, 73.9434), ['ready'] = false, ['taked'] = false},
            [9] = {['coords'] = vector3(12.3591, 542.7639, 175.9194), ['ready'] = false, ['taked'] = false},
            [10] = {['coords'] = vector3(-476.7043, 548.3423, 119.9695),  ['ready'] = false, ['taked'] = false},
            [11] = {['coords'] = vector3(476.0049, -600.0924, 28.4995), ['ready'] = false, ['taked'] = false},
            [12] = {['coords'] = vector3(815.231, -1625.342, 31.297),   ['ready'] = false, ['taked'] = false},
            [13] = {['coords'] = vector3(1196.9207, -626.4839, 62.999), ['ready'] = false, ['taked'] = false},
            [14] = {['coords'] = vector3(143.3217, 195.3914, 106.5881), ['ready'] = false, ['taked'] = false},
            [15] = {['coords'] = vector3(1119.6542, -345.1613, 67.138), ['ready'] = false, ['taked'] = false},
            [16] = {['coords'] = vector3(-1097.7334, -1363.486, 5.193), ['ready'] = false, ['taked'] = false},
            [17] = {['coords'] = vector3(-1332.4834, -1193.443, 4.890), ['ready'] = false, ['taked'] = false},
            [18] = {['coords'] = vector3(-800.2484, 841.2549, 204.325), ['ready'] = false, ['taked'] = false},
            [19] = {['coords'] = vector3(522.3570, -162.4832, 56.209),  ['ready'] = false, ['taked'] = false},
            [20] = {['coords'] = vector3(1148.7681, -1012.149, 44.649), ['ready'] = false, ['taked'] = false},
        }
    },
    [2] = {
        ['job'] = 'postnl',
        ['color'] = {r = 201, g = 101, b = 0},
        ['Outfit'] = {
            ['Male'] = {
                ["components"] = {
                    [1] = {
                        ["drawable"] = 0,
                        ["component_id"] = 0,
                        ["texture"] = 0,
                        },
                    [2] = {
                        ["drawable"] = 73,
                        ["component_id"] = 2,
                        ["texture"] = 0,
                        },
                    [3] = {
                        ["drawable"] = 0,
                        ["component_id"] = 3,
                        ["texture"] = 0,
                        },
                    [4] = {
                        ["drawable"] = 0,
                        ["component_id"] = 5,
                        ["texture"] = 0,
                        },
                    [5] = {
                        ["drawable"] = 15,
                        ["component_id"] = 8,
                        ["texture"] = 0,
                        },
                    [6] = {
                        ["drawable"] = 0,
                        ["component_id"] = 9,
                        ["texture"] = 0,
                        },
                    [7] = {
                        ["drawable"] = 0,
                        ["component_id"] = 10,
                        ["texture"] = 0,
                        },
                    [8] = {
                        ["drawable"] = 177,
                        ["component_id"] = 4,
                        ["texture"] = 4,
                        },
                    [9] = {
                        ["drawable"] = 120,
                        ["component_id"] = 6,
                        ["texture"] = 0,
                        },
                    [10] = {
                        ["drawable"] = 0,
                        ["component_id"] = 7,
                        ["texture"] = 0,
                        },
                    [11] = {
                        ["drawable"] = 97,
                        ["component_id"] = 11,
                        ["texture"] = 0,
                        },
                    [12] = {
                        ["drawable"] = 0,
                        ["component_id"] = 1,
                        ["texture"] = 0,
                        },
                    },
                ["props"] = {
                    [1] = {
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        ["prop_id"] = 2,
                        },
                    [2] = {
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        ["prop_id"] = 7,
                        },
                    [3] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["prop_id"] = 1,
                        },
                    [4] = {
                        ["drawable"] = -1,
                        ["texture"] = 0,
                        ["prop_id"] = 6,
                        },
                    [5] = {
                        ["drawable"] = 142,
                        ["texture"] = 6,
                        ["prop_id"] = 0,
                        },
                    },
                },
            ['Female'] = {                
                ["props"] = {
                    [1] = {
                        ["prop_id"] = 0,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                    },
                    [2] = {
                        ["prop_id"] = 1,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                    },
                    [3] = {
                        ["prop_id"] = 2,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                    },
                    [4] = {
                        ["prop_id"] = 6,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                    },
                    [5] = {
                        ["prop_id"] = 7,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                    },
                },
                ["components"] = {
                    [1] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 0,
                    },
                    [2] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 1,
                    },
                    [3] = {
                        ["drawable"] = 101,
                        ["texture"] = 0,
                        ["component_id"] = 2,
                    },
                    [4] = {
                        ["drawable"] = 12,
                        ["texture"] = 0,
                        ["component_id"] = 3,
                    },
                    [5] = {
                        ["drawable"] = 15,
                        ["texture"] = 0,
                        ["component_id"] = 4,
                    },
                    [6] = {
                        ["drawable"] = 112,
                        ["texture"] = 3,
                        ["component_id"] = 5,
                    },
                    [7] = {
                        ["drawable"] = 133,
                        ["texture"] = 1,
                        ["component_id"] = 6,
                    },
                    [8] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 7,
                    },
                    [9] = {
                        ["drawable"] = 272,
                        ["texture"] = 1,
                        ["component_id"] = 8,
                    },
                    [10] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 9,
                    },
                    [11] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 10,
                    },
                    [12] = {
                        ["drawable"] = 517,
                        ["texture"] = 3,
                        ["component_id"] = 11,
                    },
                },
            }
        },
        ['inklok'] = {['coords'] = vector3(-406.3554, 6148.9619, 31.6783)},
        ['verkoop'] = {['coords'] = vector3(-421.2197, 6136.2354, 31.8773)},
        ['salaryPerAction'] = function() return math.random(130, 475) end,
        ['vehicle'] = {
            ['spawnname'] = GetHashKey('speedo'),
            ['coords'] = {
                [1] = {
                    ['vector'] = vector3(-438.7065, 6141.7285, 31.4784),
                    ['heading'] = 220.7638
                },
                [2] = {
                    ['vector'] = vector3(-410.7275, 6175.6870, 31.4782),
                    ['heading'] = 221.6366,
                }
            },
            ['removeLocation'] = vector3(-394.2213, 6117.0630, 31.2931)
        },
        ['blip'] = {
            ['sprite'] = 479,
            ['color'] = 47,
            ['text'] = 'PostNL'
        },
        ['animations'] = {
            [1] = 'stealtv',
            [2] = 'box',
            [3] = 'cbbox3',
            [3] = 'cbbox',
        },
        ['actions'] = {
            [1] = {['coords'] = vector3(-3007.2625, 81.0969, 11.6081), ['ready'] = false},
            [2] = {['coords'] = vector3(-1041.2158, -241.5113, 37.8465), ['ready'] = false},
            [3] = {['coords'] = vector3(435.0409, -644.8981, 28.7344), ['ready'] = false},
            [4] = {['coords'] = vector3(357.2066, -593.3024, 28.7868), ['ready'] = false},
            [5] = {['coords'] = vector3(253.8627, -1012.4666, 29.2700), ['ready'] = false},
            [6] = {['coords'] = vector3(342.0884, -1398.5648, 32.5092), ['ready'] = false},
            [7] = {['coords'] = vector3(-700.5416, -1402.0829, 5.4953), ['ready'] = false},
            [8] = {['coords'] = vector3(-712.4929, -1298.8848, 5.1103), ['ready'] = false},
            [9] = {['coords'] = vector3(-17.3349, -296.6324, 45.7627), ['ready'] = false},
            [10] = {['coords'] = vector3(8.5251, -243.2840, 47.6606), ['ready'] = false},
            [11] = {['coords'] = vector3(-138.5547, -250.1559, 43.8275), ['ready'] = false},
            [12] = {['coords'] = vector3(-365.0898, -356.3451, 31.5568), ['ready'] = false},
            [13] = {['coords'] = vector3(-542.6707, -204.7762, 38.1106), ['ready'] = false},
            [14] = {['coords'] = vector3(-644.1564, -227.1295, 37.7450), ['ready'] = false},
            [15] = {['coords'] = vector3(-741.2999, -205.9108, 37.2732), ['ready'] = false},
            [16] = {['coords'] = vector3(-718.3859, -155.6936, 36.9919), ['ready'] = false},
            [17] = {['coords'] = vector3(-840.6456, -25.0699, 40.3933), ['ready'] = false},
            [18] = {['coords'] = vector3(-951.1541, 192.3855, 67.3934), ['ready'] = false},
            [19] = {['coords'] = vector3(-1040.2809, 222.1331, 64.3757), ['ready'] = false},
            [20] = {['coords'] = vector3(-2006.0491, 367.6762, 94.6345), ['ready'] = false},
            [21] = {['coords'] = vector3(-2014.4230, 499.6032, 107.1717), ['ready'] = false},
            [22] = {['coords'] = vector3(-1938.7827, 551.6927, 114.8284), ['ready'] = false},
            [23] = {['coords'] = vector3(-1995.1492, 590.8357, 117.9033), ['ready'] = false},
            [24] = {['coords'] = vector3(-1897.4410, 641.9639, 130.2091), ['ready'] = false},
            [25] = {['coords'] = vector3(-1206.5032, -1263.6110, 6.9643), ['ready'] = false},
            [26] = {['coords'] = vector3(-1221.1987, -1241.2233, 7.0269), ['ready'] = false},
            [27] = {['coords'] = vector3(-1225.4702, -1268.9996, 6.1288), ['ready'] = false},
            [28] = {['coords'] = vector3(-1269.1201, -1295.9066, 4.0039), ['ready'] = false},
            [29] = {['coords'] = vector3(-1209.6178, -1383.2382, 4.0536), ['ready'] = false},
            [30] = {['coords'] = vector3(-1268.9331, -1405.8737, 4.2683), ['ready'] = false},
            [31] = {['coords'] = vector3(-1301.8665, -1374.1038, 4.4994), ['ready'] = false},
            [32] = {['coords'] = vector3(-1324.7692, -1515.2603, 4.4367), ['ready'] = false},
            [33] = {['coords'] = vector3(-1183.5272, -1773.6815, 4.0465), ['ready'] = false},
            [34] = {['coords'] = vector3(512.2936, -1780.7330, 28.5030), ['ready'] = false},
            [35] = {['coords'] = vector3(471.7216, -1739.4410, 28.8769), ['ready'] = false},
            [36] = {['coords'] = vector3(519.0240, -1734.1718, 30.6915), ['ready'] = false},
            [37] = {['coords'] = vector3(1191.8934, -1654.1296, 42.4246), ['ready'] = false},
            [38] = {['coords'] = vector3(1231.6523, -1592.8923, 53.3679), ['ready'] = false},
            [39] = {['coords'] = vector3(2663.3376, 1641.3696, 24.8711), ['ready'] = false},
            [40] = {['coords'] = vector3(2556.4031, 2608.0945, 38.0870), ['ready'] = false},
            [41] = {['coords'] = vector3(2003.9709, 3790.5400, 32.1808), ['ready'] = false},
            [42] = {['coords'] = vector3(2506.4067, 4097.7188, 38.7049), ['ready'] = false},
            [43] = {['coords'] = vector3(2482.0598, 4099.8281, 38.1368), ['ready'] = false},
            [44] = {['coords'] = vector3(2454.9673, 4069.3650, 38.0647), ['ready'] = false},
            [45] = {['coords'] = vector3(2452.1611, 4968.5693, 46.5716), ['ready'] = false},
            [46] = {['coords'] = vector3(1656.4209, 4862.0508, 41.9908), ['ready'] = false},
            [47] = {['coords'] = vector3(1793.0579, 4593.4258, 37.6829), ['ready'] = false},
            [48] = {['coords'] = vector3(32.3063, 6595.9727, 32.4704), ['ready'] = false},
            [49] = {['coords'] = vector3(12.5350, 6577.5801, 32.7359), ['ready'] = false},
            [50] = {['coords'] = vector3(-14.6670, 6557.7651, 33.2404), ['ready'] = false},
            [51] = {['coords'] = vector3(-271.8162, 6400.0356, 31.3410), ['ready'] = false},
            [52] = {['coords'] = vector3(-246.2950, 6414.0039, 31.4590), ['ready'] = false},
            [53] = {['coords'] = vector3(-280.7571, 6351.1538, 32.6008), ['ready'] = false},
            [54] = {['coords'] = vector3(-359.2914, 6334.6670, 29.8472), ['ready'] = false},
            [55] = {['coords'] = vector3(-333.1005, 6302.7837, 33.0882), ['ready'] = false},
            [56] = {['coords'] = vector3(-249.6816, 6159.6084, 31.4824), ['ready'] = false},
            [57] = {['coords'] = vector3(-120.9591, 6326.4385, 35.5012), ['ready'] = false},
        }
    },
    [3] = {
        ['job'] = 'poolcleaner',
        ['color'] = {r = 3, g = 104, b = 140},
        ['Outfit'] = {
            ['Male'] = {["components"] = {
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
                    ["drawable"] = 73,
                    ["component_id"] = 2,
                    ["texture"] = 0,
                    },
                [4] = {
                    ["drawable"] = 135,
                    ["component_id"] = 3,
                    ["texture"] = 0,
                    },
                [5] = {
                    ["drawable"] = 144,
                    ["component_id"] = 4,
                    ["texture"] = 24,
                    },
                [6] = {
                    ["drawable"] = 149,
                    ["component_id"] = 6,
                    ["texture"] = 2,
                    },
                [7] = {
                    ["drawable"] = 0,
                    ["component_id"] = 7,
                    ["texture"] = 0,
                    },
                [8] = {
                    ["drawable"] = 15,
                    ["component_id"] = 8,
                    ["texture"] = 0,
                    },
                [9] = {
                    ["drawable"] = 0,
                    ["component_id"] = 9,
                    ["texture"] = 0,
                    },
                [10] = {
                    ["drawable"] = 0,
                    ["component_id"] = 10,
                    ["texture"] = 0,
                    },
                [11] = {
                    ["drawable"] = 405,
                    ["component_id"] = 11,
                    ["texture"] = 7,
                    },
                [12] = {
                    ["drawable"] = 128,
                    ["component_id"] = 5,
                    ["texture"] = 0,
                    },
                },
            ["props"] = {
                [1] = {
                    ["drawable"] = 216,
                    ["texture"] = 3,
                    ["prop_id"] = 0,
                    },
                [2] = {
                    ["drawable"] = 7,
                    ["texture"] = 6,
                    ["prop_id"] = 1,
                    },
                [3] = {
                    ["drawable"] = 41,
                    ["texture"] = 0,
                    ["prop_id"] = 2,
                    },
                [4] = {
                    ["drawable"] = -1,
                    ["texture"] = -1,
                    ["prop_id"] = 6,
                    },
                [5] = {
                    ["drawable"] = -1,
                    ["texture"] = -1,
                    ["prop_id"] = 7,
                    },
                },},
            ['Female'] = {
                ["props"] = {
                    [1] = {
                        ["prop_id"] = 0,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [2] = {
                        ["prop_id"] = 1,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [3] = {
                        ["prop_id"] = 2,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [4] = {
                        ["prop_id"] = 6,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [5] = {
                        ["prop_id"] = 7,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    },
                ["components"] = {
                    [1] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 0,
                        },
                    [2] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 1,
                        },
                    [3] = {
                        ["drawable"] = 101,
                        ["texture"] = 0,
                        ["component_id"] = 2,
                        },
                    [4] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 5,
                        },
                    [5] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 7,
                        },
                    [6] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 9,
                        },
                    [7] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 10,
                        },
                    [8] = {
                        ["drawable"] = 15,
                        ["texture"] = 0,
                        ["component_id"] = 4,
                        },
                    [9] = {
                        ["drawable"] = 113,
                        ["texture"] = 3,
                        ["component_id"] = 6,
                        },
                    [10] = {
                        ["drawable"] = 252,
                        ["texture"] = 9,
                        ["component_id"] = 8,
                        },
                    [11] = {
                        ["drawable"] = 506,
                        ["texture"] = 1,
                        ["component_id"] = 11,
                        },
                    [12] = {
                        ["drawable"] = 4,
                        ["texture"] = 0,
                        ["component_id"] = 3,
                    },
                },
            }
        },
        ['inklok'] = {['coords'] = vector3(-1321.05, -1264.02, 4.59)},
        ['verkoop'] = {['coords'] = vector3(-1309.4852, -1317.5184, 4.8738)},
        ['salaryPerAction'] = function() return math.random(175, 320) end,
        ['vehicle'] = {
            ['spawnname'] = GetHashKey('speedo'),
            ['coords'] = {
                [1] = {
                    ['vector'] = vector3(-1312.63, -1259.64, 4.56),
                    ['heading'] = 286.10
                },
                [2] = {
                    ['vector'] = vector3(-1311.4877, -1238.4830, 4.7487),
                    ['heading'] = 20.0248
                },
                [3] = {
                    ['vector'] = vector3(-1303.1797, -1252.1285, 4.3957),
                    ['heading'] = 198.3357
                },
            },
            ['removeLocation'] = vector3(-1318.55, -1253.89, 4.59)
        },
        ['blip'] = {
            ['sprite'] = 389,
            ['color'] = 5,
            ['text'] = 'Zwembadschoonmaker'
        },
        ['actions'] = {
            [1] = {['coords'] = vector3(-1113.09, 507.62, 82.20), ['ready'] = false, ['taked'] = false},
            [2] = {['coords'] = vector3(-1060.87, 580.02, 102.91), ['ready'] = false, ['taked'] = false},
            [3] = {['coords'] = vector3(-732.71, -996.24, 18.17), ['ready'] = false, ['taked'] = false},
            [4] = {['coords'] = vector3(-112.09, 7.74, 69.41), ['ready'] = false, ['taked'] = false},
            [5] = {['coords'] = vector3(-1489.86, -681.96, 28.31), ['ready'] = false, ['taked'] = false},
            [6] = {['coords'] = vector3(-1698.71, -466.15, 41.58), ['ready'] = false, ['taked'] = false},
            [7] = {['coords'] = vector3(-619.82, 449.16, 108.82), ['ready'] = false, ['taked'] = false},
            [8] = {['coords'] = vector3(-762.33, 493.03, 107.52), ['ready'] = false, ['taked'] = false},
            [9] = {['coords'] = vector3(-1657.48, -426.49, 41.62), ['ready'] = false, ['taked'] = false},
            [10] = {['coords'] = vector3(-991.67, -1509.86, 5.58), ['ready'] = false, ['taked'] = false},
            [11] = {['coords'] = vector3(-125.66, -1586.69, 34.22), ['ready'] = false, ['taked'] = false},
            [12] = {['coords'] = vector3(-851.95, 545.85, 95.16), ['ready'] = false, ['taked'] = false},
            [13] = {['coords'] = vector3(-725.67, 653.77, 155.54), ['ready'] = false, ['taked'] = false},
            [14] = {['coords'] = vector3(-1054.90, 702.36, 165.46), ['ready'] = false, ['taked'] = false},
            [15] = {['coords'] = vector3(188.06, -673.65, 42.40), ['ready'] = false, ['taked'] = false},
            [16] = {['coords'] = vector3(-1169.62, 606.35, 102.83), ['ready'] = false, ['taked'] = false},
            [17] = {['coords'] = vector3(-140.36, -871.20, 29.47), ['ready'] = false, ['taked'] = false},
            [18] = {['coords'] = vector3(-1296.24, 481.53, 97.65), ['ready'] = false, ['taked'] = false},
            [19] = {['coords'] = vector3(-555.49, -797.12, 30.69), ['ready'] = false, ['taked'] = false},
            [20] = {['coords'] = vector3(-75.50, -346.97, 42.14), ['ready'] = false, ['taked'] = false},
            [21] = {['coords'] = vector3(-1131.18, 714.69, 155.49), ['ready'] = false, ['taked'] = false},
            [22] = {['coords'] = vector3(340.73, -202.00, 54.25), ['ready'] = false, ['taked'] = false},
            [23] = {['coords'] = vector3(1419.90, 1155.11, 114.67), ['ready'] = false, ['taked'] = false},
            [24] = {['coords'] = vector3(-1102.78, 836.57, 168.43), ['ready'] = false, ['taked'] = false},
        }
    },
    [4] = {
        ['job'] = 'duiker',
        ['color'] = {r = 201, g = 101, b = 0},
        ['Outfit'] = {
            ['Male'] = {
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
                        ["drawable"] = 73,
                        ["component_id"] = 2,
                        ["texture"] = 0,
                        },
                    [4] = {
                        ["drawable"] = 0,
                        ["component_id"] = 5,
                        ["texture"] = 0,
                        },
                    [5] = {
                        ["drawable"] = 0,
                        ["component_id"] = 7,
                        ["texture"] = 0,
                        },
                    [6] = {
                        ["drawable"] = 0,
                        ["component_id"] = 9,
                        ["texture"] = 0,
                        },
                    [7] = {
                        ["drawable"] = 0,
                        ["component_id"] = 10,
                        ["texture"] = 0,
                        },
                    [8] = {
                        ["drawable"] = 94,
                        ["component_id"] = 4,
                        ["texture"] = 20,
                        },
                    [9] = {
                        ["drawable"] = 243,
                        ["component_id"] = 11,
                        ["texture"] = 20,
                        },
                    [10] = {
                        ["drawable"] = 15,
                        ["component_id"] = 8,
                        ["texture"] = 0,
                        },
                    [11] = {
                        ["drawable"] = 179,
                        ["component_id"] = 3,
                        ["texture"] = 0,
                        },
                    [12] = {
                        ["drawable"] = 67,
                        ["component_id"] = 6,
                        ["texture"] = 20,
                        },
                    },
                ["props"] = {
                    [1] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["prop_id"] = 1,
                        },
                    [2] = {
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        ["prop_id"] = 2,
                        },
                    [3] = {
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        ["prop_id"] = 6,
                        },
                    [4] = {
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        ["prop_id"] = 7,
                        },
                    [5] = {
                        ["drawable"] = -1,
                        ["texture"] = 0,
                        ["prop_id"] = 0,
                        },
                },
            },
            ['Female'] = {
                ["props"] = {
                    [1] = {
                        ["prop_id"] = 0,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [2] = {
                        ["prop_id"] = 1,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [3] = {
                        ["prop_id"] = 2,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [4] = {
                        ["prop_id"] = 6,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    [5] = {
                        ["prop_id"] = 7,
                        ["drawable"] = -1,
                        ["texture"] = -1,
                        },
                    },
                ["components"] = {
                    [1] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 0,
                        },
                    [2] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 1,
                        },
                    [3] = {
                        ["drawable"] = 101,
                        ["texture"] = 0,
                        ["component_id"] = 2,
                        },
                    [4] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 5,
                        },
                    [5] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 7,
                        },
                    [6] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 9,
                        },
                    [7] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 10,
                        },
                    [8] = {
                        ["drawable"] = 0,
                        ["texture"] = 0,
                        ["component_id"] = 3,
                        },
                    [9] = {
                        ["drawable"] = 97,
                        ["texture"] = 25,
                        ["component_id"] = 4,
                        },
                    [10] = {
                        ["drawable"] = 1,
                        ["texture"] = 0,
                        ["component_id"] = 8,
                        },
                    [11] = {
                        ["drawable"] = 251,
                        ["texture"] = 25,
                        ["component_id"] = 11,
                        },
                    [12] = {
                        ["drawable"] = 70,
                        ["texture"] = 25,
                        ["component_id"] = 6,
                        },
                    },
            }
        },
        ['inklok'] = {['coords'] = vector3(548.7469, -3132.6526, 6.0698)},
        ['verkoop'] = {['coords'] = vector3(554.3773, -3116.8164, 6.0693)},
        ['salaryPerAction'] = function() return math.random(200, 450) end,
        ['vehicle'] = {
            ['spawnname'] = GetHashKey('dinghy'),
            ['coords'] = {
                [1] = {
                    ['vector'] = vector3(571.2407, -3150.6763, -0.4330),
                    ['heading'] = 178.2767
                },
                [2] = {
                    ['vector'] = vector3(527.3154, -3154.0596, -0.4341),
                    ['heading'] =  183.4777
                },
            },
            ['removeLocation'] = vector3(579.4639, -3135.4888, 1.4471)
        },
        ['blip'] = {
            ['sprite'] = 729,
            ['color'] = 18,
            ['text'] = 'Duiker Job'
        },
        ['actions'] = {
            [1] = {['coords'] = vector3(-2848.3848, -491.6798, -29.1709), ['ready'] = false, ['taked'] = false},
            [2] = {['coords'] = vector3(-552.4983, -2459.6702, -13.44027), ['ready'] = false, ['taked'] = false},
            [3] = {['coords'] = vector3(3194.99, -377.61, -32.84), ['ready'] = false, ['taked'] = false},
            [4] = {['coords'] = vector3(265.9161, -2279.2793, -3.3913), ['ready'] = false, ['taked'] = false},
            [5] = {['coords'] = vector3(-2834.1914, -628.6026, -53.0343), ['ready'] = false, ['taked'] = false},
            [6] = {['coords'] = vector3(-2837.3477, -510.8742, -63.8260), ['ready'] = false, ['taked'] = false},
            [7] = {['coords'] = vector3(935.4266, -2733.3970, -12.2426), ['ready'] = false, ['taked'] = false},
            [8] = {['coords'] = vector3(-1016.6277, 6515.7026, -22.6101), ['ready'] = false, ['taked'] = false},
            [9] = {['coords'] = vector3(-985.7293, 6365.2900, -10.5108), ['ready'] = false, ['taked'] = false},
            [10] = {['coords'] = vector3(-927.9489, 6677.2222, -30.3124), ['ready'] = false, ['taked'] = false},
            [11] = {['coords'] = vector3(1782.2218, -2957.2930, -40.2165), ['ready'] = false, ['taked'] = false},
            [12] = {['coords'] = vector3(3402.9004, 6326.6094, -48.0618), ['ready'] = false, ['taked'] = false},
            [13] = {['coords'] = vector3(3897.0164, 3041.5957, -20.4893), ['ready'] = false, ['taked'] = false},
            [14] = {['coords'] = vector3(-3246.9358, 3691.4873, -21.3038), ['ready'] = false, ['taked'] = false},
            [15] = {['coords'] = vector3(-3291.0991, 3681.5999, -72.5527), ['ready'] = false, ['taked'] = false},
            [16] = {['coords'] = vector3(-3393.3862, 3718.3232, -83.5283), ['ready'] = false, ['taked'] = false},
            [17] = {['coords'] = vector3(757.5056, 7419.5850, -118.6483), ['ready'] = false, ['taked'] = false},
            [18] = {['coords'] = vector3(-3183.3196, 3021.3621, -33.9406), ['ready'] = false, ['taked'] = false},
            [19] = {['coords'] = vector3(-3166.0964, 3016.9521, -35.4015), ['ready'] = false, ['taked'] = false},
            [20] = {['coords'] = vector3(3220.4365, -409.8405, -38.1355), ['ready'] = false, ['taked'] = false},
            [21] = {['coords'] = vector3(3180.2874, -353.5628, -27.2223), ['ready'] = false, ['taked'] = false},
            [22] = {['coords'] = vector3(3140.1528, -252.9260, -22.3716), ['ready'] = false, ['taked'] = false},
            [23] = {['coords'] = vector3(4130.4287, 3522.2271, -23.2656), ['ready'] = false, ['taked'] = false},
            [24] = {['coords'] = vector3(4176.7905, 3518.4951, -42.3828), ['ready'] = false, ['taked'] = false},
            [25] = {['coords'] = vector3(4245.7070, 3593.8506, -45.1314), ['ready'] = false, ['taked'] = false},
            [26] = {['coords'] = vector3(2692.6743, -1418.8596, -16.4018), ['ready'] = false, ['taked'] = false},
            [27] = {['coords'] = vector3(-246.6227, -2873.3015, -18.8695), ['ready'] = false, ['taked'] = false},
            [28] = {['coords'] = vector3(-114.2279, -2871.3528, -4.5646), ['ready'] = false, ['taked'] = false},
            [29] = {['coords'] = vector3(319.6056, 3707.5505, 29.2811), ['ready'] = false, ['taked'] = false},
            [30] = {['coords'] = vector3(2678.6428, 6662.0977, -13.3155), ['ready'] = false, ['taked'] = false},
            [31] = {['coords'] = vector3(2637.1567, 6697.0889, -16.6607), ['ready'] = false, ['taked'] = false},
            [32] = {['coords'] = vector3(647.2057, 3776.7263, 24.5430), ['ready'] = false, ['taked'] = false},
            [33] = {['coords'] = vector3(-1750.3917, -1270.1003, -15.9318), ['ready'] = false, ['taked'] = false},
            [34] = {['coords'] = vector3(-416.8668, -2361.1482, -19.2214), ['ready'] = false, ['taked'] = false},
            [35] = {['coords'] = vector3(451.7260, -2209.4766, -0.8766), ['ready'] = false, ['taked'] = false},
            [36] = {['coords'] = vector3(577.1774, -2469.0806, -6.0376), ['ready'] = false, ['taked'] = false},
            [37] = {['coords'] = vector3(729.3953, -2576.0479, -3.7566), ['ready'] = false, ['taked'] = false},
            [38] = {['coords'] = vector3(1217.4480, -2887.7556, -9.0093), ['ready'] = false, ['taked'] = false},
            [39] = {['coords'] = vector3(1261.8799, -2882.7683, -16.2109), ['ready'] = false, ['taked'] = false},
            [40] = {['coords'] = vector3(1261.0109, -2982.0649, -13.3095), ['ready'] = false, ['taked'] = false},
        }
    },
    [5] = {
        ['job'] = 'technician',
        ['color'] = {r = 201, g = 101, b = 0},
        ['Outfit'] = {
            ['Male'] = {
                ["components"] = {
                    [1] = {
                        ["component_id"] = 0,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [2] = {
                        ["component_id"] = 1,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [3] = {
                        ["component_id"] = 2,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [4] = {
                        ["component_id"] = 5,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [5] = {
                        ["component_id"] = 7,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [6] = {
                        ["component_id"] = 9,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [7] = {
                        ["component_id"] = 10,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [8] = {
                        ["component_id"] = 3,
                        ["texture"] = 0,
                        ["drawable"] = 195,
                    },
                    [9] = {
                        ["component_id"] = 4,
                        ["texture"] = 3,
                        ["drawable"] = 38,
                    },
                    [10] = {
                        ["component_id"] = 6,
                        ["texture"] = 10,
                        ["drawable"] = 12,
                    },
                    [11] = {
                        ["component_id"] = 8,
                        ["texture"] = 0,
                        ["drawable"] = 215,
                    },
                    [12] = {
                        ["component_id"] = 11,
                        ["texture"] = 3,
                        ["drawable"] = 65,
                    },
                },
                ["props"] = {
                    [1] = {
                        ["prop_id"] = 1,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [2] = {
                        ["prop_id"] = 2,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [3] = {
                        ["prop_id"] = 6,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [4] = {
                        ["prop_id"] = 7,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [5] = {
                        ["prop_id"] = 0,
                        ["texture"] = 0,
                        ["drawable"] = 145,
                    },
                },
            },
            ['Female'] = {
                ["components"] = {
                    [1] = {
                        ["component_id"] = 0,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [2] = {
                        ["component_id"] = 1,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [3] = {
                        ["component_id"] = 2,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [4] = {
                        ["component_id"] = 5,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [5] = {
                        ["component_id"] = 7,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [6] = {
                        ["component_id"] = 9,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [7] = {
                        ["component_id"] = 10,
                        ["texture"] = 0,
                        ["drawable"] = 0,
                    },
                    [8] = {
                        ["component_id"] = 3,
                        ["texture"] = 0,
                        ["drawable"] = 240,
                    },
                    [9] = {
                        ["component_id"] = 4,
                        ["texture"] = 3,
                        ["drawable"] = 38,
                    },
                    [10] = {
                        ["component_id"] = 11,
                        ["texture"] = 3,
                        ["drawable"] = 59,
                    },
                    [11] = {
                        ["component_id"] = 8,
                        ["texture"] = 0,
                        ["drawable"] = 245,
                    },
                    [12] = {
                        ["component_id"] = 6,
                        ["texture"] = 0,
                        ["drawable"] = 52,
                    },
                },
                ["props"] = {
                    [1] = {
                        ["prop_id"] = 1,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [2] = {
                        ["prop_id"] = 2,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [3] = {
                        ["prop_id"] = 6,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [4] = {
                        ["prop_id"] = 7,
                        ["texture"] = -1,
                        ["drawable"] = -1,
                    },
                    [5] = {
                        ["prop_id"] = 0,
                        ["texture"] = 0,
                        ["drawable"] = 144,
                    },
                },
            }
        },
        ['inklok'] = {['coords'] = vector3(729.3506, -1974.0847, 29.2921)},
        ['verkoop'] = {['coords'] = vector3(722.4156, -2016.3250, 29.2920)},
        ['salaryPerAction'] = function() return math.random(200, 450) end,
        ['vehicle'] = {
            ['spawnname'] = GetHashKey('utillitruck2'),
            ['coords'] = {
                [1] = {['vector'] = vector3(739.73, -1907.33, 29.03), ['heading'] =  175.15},
                [2] = {['vector'] = vector3(734.09, -1906.89, 29.03), ['heading'] =  174.74},
                [3] = {['vector'] = vector3(736.23, -1915.97, 29.03), ['heading'] =  175.64},
                [4] = {['vector'] = vector3(738.34, -1924.04, 29.03), ['heading'] =  175.9},
                [5] = {['vector'] = vector3(732.88, -1923.67, 29.03), ['heading'] =  177.52},
            },
            ['removeLocation'] = vector(742.6639, -1956.5822, 29.0304)
        },
        ['blip'] = {
            ['sprite'] = 801,
            ['color'] = 18,
            ['text'] = 'Elektricien Job'
        },
        ['actions'] = {
            [1] = {['coords'] = vector3(552.5620, 122.5152, 98.0414), ['ready'] = false, ['taked'] = false},
            [2] = {['coords'] = vector3(383.7173, 241.0578, 103.0341), ['ready'] = false, ['taked'] = false},
            [3] = {['coords'] = vector3(196.7372, 314.8195, 105.4138), ['ready'] = false, ['taked'] = false},
            [4] = {['coords'] = vector3(2549.6436, 4663.5933, 34.0768), ['ready'] = false, ['taked'] = false},
            [5] = {['coords'] = vector3(141.5484, 170.4994, 104.9892), ['ready'] = false, ['taked'] = false},
            [6] = {['coords'] = vector3(-70.9151, 80.5677, 71.6010), ['ready'] = false, ['taked'] = false},
            [7] = {['coords'] = vector3(2251.1001, 5153.7510, 57.3477), ['ready'] = false, ['taked'] = false},
            [8] = {['coords'] = vector3(-1492.8666, -528.0201, 32.8068), ['ready'] = false, ['taked'] = false},
            [9] = {['coords'] = vector3(1699.3297, 4916.8486, 42.0781), ['ready'] = false, ['taked'] = false},
            [10] = {['coords'] = vector3(-1470.1917, -914.9515, 10.0236), ['ready'] = false, ['taked'] = false},
            [11] = {['coords'] = vector3(1694.3182, 4885.7183, 42.0351), ['ready'] = false, ['taked'] = false},
            [12] = {['coords'] = vector3(-1136.9762, -475.7379, 34.8853), ['ready'] = false, ['taked'] = false},
            [13] = {['coords'] = vector3(1706.1449, 4739.2163, 42.1331), ['ready'] = false, ['taked'] = false},
            [14] = {['coords'] = vector3(-780.7925, -203.5842, 37.2837), ['ready'] = false, ['taked'] = false},
            [15] = {['coords'] = vector3(-1810.1859, -1202.4962, 13.0175), ['ready'] = false, ['taked'] = false},
            [16] = {['coords'] = vector3(-1271.9482, -1370.0358, 4.3021), ['ready'] = false, ['taked'] = false},
            [17] = {['coords'] = vector3(-672.9318, -1182.9684, 10.6126), ['ready'] = false, ['taked'] = false},
            [18] = {['coords'] = vector3(2151.2219, 4775.3154, 41.1148), ['ready'] = false, ['taked'] = false},
            [19] = {['coords'] = vector3(169.4020, -1088.2928, 29.1921), ['ready'] = false, ['taked'] = false},
            [20] = {['coords'] = vector3(374.0897, -999.1454, 29.4510), ['ready'] = false, ['taked'] = false},
            [21] = {['coords'] = vector3(2463.8667, 4094.4153, 38.0647), ['ready'] = false, ['taked'] = false},
            [22] = {['coords'] = vector3(1205.1261, 2709.6167, 38.0054), ['ready'] = false, ['taked'] = false},
            [23] = {['coords'] = vector3(845.6896, -1065.0326, 27.9519), ['ready'] = false, ['taked'] = false},
            [24] = {['coords'] = vector3(972.4504, -1628.8970, 30.1107), ['ready'] = false, ['taked'] = false},
            [25] = {['coords'] = vector3(898.4894, -2537.1050, 28.2867), ['ready'] = false, ['taked'] = false},
            [26] = {['coords'] = vector3(123.8242, -2871.6375, 6.0000), ['ready'] = false, ['taked'] = false},
            [27] = {['coords'] = vector3(-124.4071, -2529.6492, 6.0957), ['ready'] = false, ['taked'] = false},
            [28] = {['coords'] = vector3(-1029.1184, -2343.6997, 14.0958), ['ready'] = false, ['taked'] = false},
            [29] = {['coords'] = vector3(-621.9629, -1213.5215, 13.6917), ['ready'] = false, ['taked'] = false},
            [30] = {['coords'] = vector3(-557.3299, -1763.4196, 21.8571), ['ready'] = false, ['taked'] = false},
            [31] = {['coords'] = vector3(1114.2836, -335.7139, 67.0967), ['ready'] = false, ['taked'] = false},
            [32] = {['coords'] = vector3(-544.3029, -1225.9213, 18.4517), ['ready'] = false, ['taked'] = false},
            [33] = {['coords'] = vector3(-148.4509, -2105.2134, 25.5775), ['ready'] = false, ['taked'] = false},
            [34] = {['coords'] = vector3(1193.4764, -1490.3999, 34.8431), ['ready'] = false, ['taked'] = false},
            [35] = {['coords'] = vector3(885.8356, -178.2773, 74.7002), ['ready'] = false, ['taked'] = false},
            [36] = {['coords'] = vector3(1092.5991, -794.4536, 58.2720), ['ready'] = false, ['taked'] = false},
            [37] = {['coords'] = vector3(-1179.8120, -1777.1005, 3.9085), ['ready'] = false, ['taked'] = false},
            [38] = {['coords'] = vector3(-1146.8252, -1563.6545, 4.4143), ['ready'] = false, ['taked'] = false},
            [39] = {['coords'] = vector3(-1119.5830, -1587.3324, 4.5757), ['ready'] = false, ['taked'] = false},
            [40] = {['coords'] = vector3(1155.8571, -376.6736, 67.4030), ['ready'] = false, ['taked'] = false},
            [41] = {['coords'] = vector3(-1123.1799, -1615.9266, 4.3984), ['ready'] = false, ['taked'] = false},
            [42] = {['coords'] = vector3(1229.2974, -469.8787, 66.5854), ['ready'] = false, ['taked'] = false},
            [43] = {['coords'] = vector3(54.8814, -1333.9846, 29.3078), ['ready'] = false, ['taked'] = false},
            [44] = {['coords'] = vector3(-356.7665, -641.4968, 31.8048), ['ready'] = false, ['taked'] = false},
            [45] = {['coords'] = vector3(1219.4437, -1270.8292, 35.3626), ['ready'] = false, ['taked'] = false},
            [46] = {['coords'] = vector3(-1078.1791, -1267.1416, 5.8201), ['ready'] = false, ['taked'] = false},
            [47] = {['coords'] = vector3(1219.6443, -1462.2604, 34.8436), ['ready'] = false, ['taked'] = false},
            [48] = {['coords'] = vector3(-1355.2579, -935.0860, 9.7058), ['ready'] = false, ['taked'] = false},
            [49] = {['coords'] = vector3(-1285.2877, -834.1904, 17.0992), ['ready'] = false, ['taked'] = false},
            [50] = {['coords'] = vector3(997.0758, -1504.7703, 31.4336), ['ready'] = false, ['taked'] = false},
        }
    }
}