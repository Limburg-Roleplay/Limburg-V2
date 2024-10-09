Config = {}

exports('returnConfig', function()
    return Config.BlacklistedItems
end)

Config.BlacklistedItems = {
--[[     ['WEAPON_GLOCK17'] = true,
    ['WEAPON_M1911'] = true,
    ['WEAPON_STUNGUN'] = true,
    ['WEAPON_DEAGLE'] = true,
    ['WEAPON_CJ'] = true,
    ['WEAPON_MP5'] = true,
    ['WEAPON_TEC9'] = true,
    ['WEAPON_AK47'] = true,
    ['WEAPON_SWITCHBLADE'] = true,
    ['WEAPON_BAYONET'] = true,
    ['WEAPON_NIGHTSTICK'] = true,
    ['weed'] = true,
    ['weed_packed'] = true,
    ['cocaleaf'] = true,
    ['cocainepoeder'] = true,
    ['cokeblok'] = true,
    ['methamfetamine'] = true,
    ['xtc'] = true,
    ['butyrolacton'] = true,
    ['ghb'] = true, ]]
}

Config.Prices = {
    ['ImpoundPrice'] = 6000,
    ['PolitieImpound'] = 10000
}

Config.BotenPrice = {
    {
        model = 'LONGFIN',
        price = 300000,
    },
    {
        model = 'SEASHARK',
        price = 15000,
    },
    {
        model = 'SPEEDER',
        price = 135000,
    },
    {
        model = 'DINGHY',
        price = 60000,
    },
    {
        model = 'SQUALO',
        price = 40000,
    }
}

Config.Blips = {
    ['car'] = {
        ['sprite'] = 524,
        ['text'] = "Garage | Voertuigen"
    },
    ['boat'] = {
        ['sprite'] = 755,
        ['text'] = "Garage | Boten"
    },
    ['helicopter'] = {
        ['sprite'] = 43,
        ['text'] = "Garage | Helikopter"
    },
    ['airplanes'] = {
        ['sprite'] = 307,
        ['text'] = "Garage | Vliegtuigen"
    },
    ['polimpound'] = {
        ['sprite'] = 60,
        ['text'] = "Politie Impound"
    },
    ['eilandcar'] = {
        ['sprite'] = 524,
        ['text'] = "Eiland Garage | Voertuigen"
    },
    ['polboatimpound'] = {
        ['sprite'] = 60,
        ['text'] = "Politie Impound"
    },
    ['trailer'] = {
        ['sprite'] = 479,
        ['text'] = "Garage | Trailers"
    },
}

Config.Text = {
    ['car'] = '[E] - Open garage',
    ['eilandcar'] = '[E] - Open garage',
    ['boat'] = '[E] - Open garage',
    ['helicopter'] = '[E] - Open hanger',
    ['airplanes'] = '[E] - Open hangar',
    ['polimpound'] = '[E] - Open politie impound',
    ['trailer'] = '[E] - Open trailer garage'
}

Config.Locations = {
    {
        ['label'] = 'Blokkenpark Garage',
        ['type'] = 'car',
        ['coords'] = vec3(58.1761, -634.2943, 31.9018),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(55.0152, -610.6664, 31.6286)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(13.1676, -586.6937, 31.6287),
                ['heading'] = 249.6001
            },
            {
                ['coords'] = vec3(16.8312, -572.8093, 31.6287),
                ['heading'] = 249.6001
            },
            {
                ['coords'] = vec3(35.6464, -581.3563, 31.6287),
                ['heading'] = 341.0143
            },
            {
                ['coords'] = vec3(30.8846, -593.6182, 31.6287),
                ['heading'] = 158.0312
            },
            {
                ['coords'] = vec3(67.9708, -600.1711, 31.6287),
                ['heading'] = 68.7147
            },
            {
                ['coords'] = vec3(68.0835, -577.9135, 31.6287),
                ['heading'] = 160.7228
            },
        }
    },

    {
        ['label'] = 'Garage Rodegarage',
        ['type'] = 'car',
        ['coords'] = vec3(-331.8131, -781.5704, 33.9645),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-342.0615, -760.1964, 33.9694)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-356.8978, -764.4210, 33.9683),
                ['heading'] = 272.3993
            },
            {
                ['coords'] = vec3(-356.6888, -756.7921, 33.9685),
                ['heading'] = 266.4279
            },
            {
                ['coords'] = vec3(-341.6763, -756.9667, 33.9693),
                ['heading'] = 268.5543
            },
            {
                ['coords'] = vec3(-320.5179, -753.1692, 33.9685),
                ['heading'] = 334.5393
            },
            {
                ['coords'] = vec3(-299.8680, -743.9873, 33.9646),
                ['heading'] = 163.9114
            },
        }
    },

    {
        ['label'] = 'Garage Helipads',
        ['type'] = 'car',
        ['coords'] = vec3(-697.1412, -1401.2969, 5.1503),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-682.4861, -1424.5255, 4.0005)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-680.0775, -1399.4275, 5.0005),
                ['heading'] = 83.2662
            },
            {
                ['coords'] = vec3(-679.8843, -1403.7747, 5.0005),
                ['heading'] = 84.5654
            },
            {
                ['coords'] = vec3(-680.2276, -1408.0620, 5.0005),
                ['heading'] = 86.0222
            },
            {
                ['coords'] = vec3(-680.0949, -1412.1512, 5.0005),
                ['heading'] = 80.4494
            },
            {
                ['coords'] = vec3(-680.6595, -1416.2131, 5.0005),
                ['heading'] = 90.1080
            },
        }
    },

    {
        ['label'] = 'Garage Arena',
        ['type'] = 'car',
        ['coords'] = vec3(-73.4868, -2003.9069, 18.2753),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-93.1272, -2002.8611, 18.0169)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-67.5391, -1989.0659, 18.0169),
                ['heading'] = 170.6770
            },
            {
                ['coords'] = vec3(-78.8055, -1988.3171, 18.0169),
                ['heading'] = 169.5053
            },
            {
                ['coords'] = vec3(-59.8018, -1991.1957, 18.0170),
                ['heading'] = 157.7801
            },
            {
                ['coords'] = vec3(-50.6734, -2001.0553, 18.0170),
                ['heading'] = 108.4031
            },
            {
                ['coords'] = vec3(-46.8683, -2011.2374, 18.0170),
                ['heading'] = 105.4993
            },
        }
    },

    {
        ['label'] = 'Garage CBR',
        ['type'] = 'car',
        ['coords'] = vec3(220.4878, -1523.5524, 29.1455),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(240.1609, -1504.6832, 28.1443)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(227.9549, -1533.7129, 29.2046),
                ['heading'] = 308.1695
            },
            {
                ['coords'] = vec3(230.6098, -1536.5768, 29.2319),
                ['heading'] = 306.2211
            },
            {
                ['coords'] = vec3(232.3329, -1539.6852, 29.2605),
                ['heading'] = 309.2152
            },
            {
                ['coords'] = vec3(250.0939, -1523.1993, 29.1420),
                ['heading'] = 26.5762
            },
            {
                ['coords'] = vec3(264.0678, -1512.3627, 29.1416),
                ['heading'] = 82.2817
            },
        }
    },

    {
        ['label'] = 'Garage Sud',
        ['type'] = 'car',
        ['coords'] = vec3(430.0812, -1964.9443, 23.2970),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(436.9241, -1955.6876, 22.0639)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(458.1716, -1969.2650, 22.9964),
                ['heading'] = 137.8843
            },
            {
                ['coords'] = vec3(453.6513, -1965.5011, 22.9702),
                ['heading'] = 179.4422
            },
            {
                ['coords'] = vec3(449.3918, -1961.1864, 22.9694),
                ['heading'] = 175.1212
            },
        }
    },

    {
        ['label'] = 'Garage Politie',
        ['type'] = 'car',
        ['coords'] = vec3(-364.2563, -363.3020, 24.7567),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-368.8451, -353.4590, 24.7567)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-373.4881, -358.3268, 24.7567),
                ['heading'] = 257.8843
            },
            {
                ['coords'] = vec3(-373.7756, -362.7711, 24.7567),
                ['heading'] = 259.4422
            },
            {
                ['coords'] = vec3(-374.4530, -367.1744, 24.7567),
                ['heading'] = 259.1212
            },
        }
    },

    {
        ['label'] = 'Paleto Blvd',
        ['type'] = 'car',
        ['coords'] = vec3(90.8364, 6362.9390, 31.2258),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(108.9913, 6378.1924, 31.2258),
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(94.7166, 6373.7549, 30.6636),
                ['heading'] = 11.2191
            },
            {
                ['coords'] = vec3(102.0060, 6377.0420, 30.6633),
                ['heading'] = 12.9015
            },
            {
                ['coords'] = vec3(80.8776, 6366.6343, 30.6667),
                ['heading'] = 11.7607
            },
            {
                ['coords'] = vec3(73.7392, 6363.5830, 30.6672),
                ['heading'] = 15.4593
            },
            {
                ['coords'] = vec3(80.6068, 6395.6636, 30.6632),
                ['heading'] = 132.6940
            },
        }
    },

    {
        ['label'] = 'Route Sandy 68',
        ['type'] = 'car',
        ['coords'] = vec3(1141.1857, 2664.0652, 38.1615),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1127.3651, 2664.8413, 38.0166)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1131.6653, 2649.7539, 38.0842),
                ['heading'] = 358.9446
            },
            {
                ['coords'] = vec3(1124.2661, 2650.4041, 38.0844),
                ['heading'] =  1.6293
            },
            {
                ['coords'] = vec3(1116.5408, 2649.7156, 38.0827),
                ['heading'] = 0.5930
            },
            {
                ['coords'] = vec3(1101.7957, 2662.4497, 37.9557),
                ['heading'] = 0.6370
            },
        }
    },

    {
        ['label'] = 'Kortz Center',
        ['type'] = 'car',
        ['coords'] = vec3(-2310.5269, 282.7086, 169.4671),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-2313.0125, 287.8197, 169.1186)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-2313.0125, 287.8197, 169.1186),
                ['heading'] = 114.2064
            },
            {
                ['coords'] = vec3(-2315.7524, 293.6253, 169.1187),
                ['heading'] = 114.1774
            },
            {
                ['coords'] = vec3(-2318.2935, 299.5242, 169.1189),
                ['heading'] =  112.7015
            },
        }
    },

    {
        ['label'] = 'Mosleys Garage',
        ['type'] = 'car',
        ['coords'] = vec3(-38.4190, -1677.5458, 29.4918),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-29.4027, -1674.4288, 29.4930)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-42.5173, -1689.0392, 29.3770),
                ['heading'] = 43.2064
            },
            {
                ['coords'] = vec3(-46.4322, -1690.2373, 29.4047),
                ['heading'] = 43.1774
            },
            {
                ['coords'] = vec3(-50.3260, -1692.2043, 29.4832),
                ['heading'] =  43.7015
            },
        }
    },
    
    {
        ['label'] = 'Marina Dr',
        ['type'] = 'car',
        ['coords'] = vec3(1530.6011, 3777.2798, 34.5115),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1562.6752, 3795.6694, 34.1128)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1542.4930, 3780.7397, 34.0501),
                ['heading'] = 209.7075
            },
            {
                ['coords'] = vec3(1546.0811, 3782.5989, 34.0605),
                ['heading'] = 204.5727
            },
            {
                ['coords'] = vec3(1549.3225, 3784.9233, 34.0718),
                ['heading'] = 206.3811
            },
        }
    },

    {
        ['label'] = 'Route 68',
        ['type'] = 'car',
        ['coords'] = vec3(-2536.0984, 2318.5376, 33.2154),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-2555.7563, 2348.0627, 33.0762)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-2529.2837, 2345.7705, 33.0599),
                ['heading'] = 213.7988
            },
            {
                ['coords'] = vec3(-2533.2109, 2345.7986, 33.0599),
                ['heading'] = 211.1561
            },
            {
                ['coords'] = vec3(-2537.1802, 2345.7568, 33.0599),
                ['heading'] = 210.8287
            },
        }
    },

    {
        ['label'] = 'Great Ocean Highway',
        ['type'] = 'car',
        ['coords'] = vec3(-3156.9346, 1094.5475, 20.8538),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-3151.0686, 1059.7280, 20.6199)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-3139.0044, 1078.7317, 20.6208),
                ['heading'] = 79.8846
            },
            {
                ['coords'] = vec3(-3137.8547, 1087.0907, 20.6589),
                ['heading'] = 78.4097
            },
            {
                ['coords'] = vec3(-3136.8662, 1094.6887, 20.6165),
                ['heading'] = 80.3788
            },
            {
                ['coords'] = vec3(-3151.2478, 1096.0757, 20.7066),
                ['heading'] = 284.7978
            },
        }
    },

    {
        ['label'] = 'Route 15',
        ['type'] = 'car',
        ['coords'] = vec3(2580.9712, 463.2871, 108.6070),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(2568.3923, 477.0139, 108.5283)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(2589.1008, 450.1848, 108.4556),
                ['heading'] = 94.1662
            },
            {
                ['coords'] = vec3(2588.8918, 443.7248, 108.4556),
                ['heading'] = 90.0947
            },
            {
                ['coords'] = vec3(2579.7109, 438.0333, 108.4556),
                ['heading'] = 7.0904
            },
        }
    },

    {
        ['label'] = 'Algonquin Blvd',
        ['type'] = 'car',
        ['coords'] = vec3(1736.8716, 3711.2903, 34.1253),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1725.5841, 3708.8738, 34.2333)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1735.5658, 3726.2454, 33.9627),
                ['heading'] = 15.9098
            },
            {
                ['coords'] = vec3(1741.1179, 3677.6257, 34.4175),
                ['heading'] = 199.4085
            },
            {
                ['coords'] = vec3(1718.7788, 3720.0833, 34.1288),
                ['heading'] = 25.1135
            },
        }
    },

    {
        ['label'] = 'Grapeseed Ave',
        ['type'] = 'car',
        ['coords'] = vec3(1699.1262, 4801.0073, 41.8010),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1690.8640, 4785.1465, 41.9215)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1690.9651, 4778.2773, 41.9215),
                ['heading'] = 88.4266
            },
            {
                ['coords'] = vec3(1691.1025, 4770.4561, 41.9215),
                ['heading'] = 89.5071
            },
            {
                ['coords'] = vec3(1690.8424, 4762.4180, 41.8069),
                ['heading'] = 89.6326
            },
        }
    },

    {
        ['label'] = 'Beach',
        ['type'] = 'car',
        ['coords'] = vec3(-1231.9310, -1431.2284, 4.3289),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1233.2729, -1406.9976, 4.2551)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1238.2029, -1419.0947, 4.3242),
                ['heading'] = 311.4865
            },
            {
                ['coords'] = vec3(-1245.5662, -1408.7543, 4.3136),
                ['heading'] = 305.4868
            },
        }
    },

    {
        ['label'] = 'Milton Rd',
        ['type'] = 'car',
        ['coords'] = vec3(-561.1852, 321.9857, 84.4037),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-572.7488, 329.9819, 84.5571)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-576.4576, 323.8975, 84.6662),
                ['heading'] = 355.9418
            },
            {
                ['coords'] = vec3(-574.8796, 337.8940, 84.6474),
                ['heading'] = 175.0497
            },
            {
                ['coords'] = vec3(-583.8675, 316.0831, 84.7857),
                ['heading'] = 354.9704
            },
        }
    },

    {
        ['label'] = 'Mirror Park',
        ['type'] = 'car',
        ['coords'] = vec3(1036.4336, -763.1708, 57.9930),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1046.0140, -791.1768, 57.9897)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1027.5077, -785.4598, 57.8584),
                ['heading'] = 310.3975
            },
            {
                ['coords'] = vec3(1027.7150, -771.6804, 58.0376),
                ['heading'] = 144.2998
            },
        }
    },

    {
        ['label'] = 'PostNL Park',
        ['type'] = 'car',
        ['coords'] = vec3(68.0629, 13.1636, 69.2144),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(77.1093, 18.8771, 69.1011)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(54.5320, 19.3814, 69.5065),
                ['heading'] = 347.1367
            },
            {
                ['coords'] = vec3(57.4180, 17.5948, 69.2801),
                ['heading'] = 341.6527
            },
            {
                ['coords'] = vec3(60.6710, 17.4784, 69.1883),
                ['heading'] = 343.2109
            },
            {
                ['coords'] = vec3(63.8314, 16.0707, 69.1141),
                ['heading'] = 334.7722
            },
        }
    },

    {
        ['label'] = 'Zwembad garage',
        ['type'] = 'car',
        ['coords'] = vec3(-1248.1323, -1236.7936, 6.7860),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1239.5209, -1226.2445, 6.9192)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1264.2273, -1233.7488, 4.8737),
                ['heading'] = 291.5783
            },
            {
                ['coords'] = vec3(-1263.1652, -1236.4622, 5.0677),
                ['heading'] = 287.3168
            },
            {
                ['coords'] = vec3(-1261.9103, -1239.0612, 5.2656),
                ['heading'] = 289.1635
            },
            {
                ['coords'] = vec3(-1260.9009, -1241.5347, 5.4200),
                ['heading'] = 291.6600
            },
            {
                ['coords'] = vec3(-1260.1481, -1244.0928, 5.5865),
                ['heading'] = 298.3954
            },
            {
                ['coords'] = vec3(-1259.8373, -1243.9656, 5.6059),
                ['heading'] = 283.4642
            },
        }
    },

    {
        ['label'] = 'Vuilnis garage',
        ['type'] = 'car',
        ['coords'] = vec3(-341.6038, -1491.3575, 30.7553),
        ['deletePoints'] = {
            {
                ['coords'] = vec3( -323.5232, -1494.7323, 30.6746)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-327.0130, -1495.3159, 30.6776),
                ['heading'] = 358.2012
            },
            {
                ['coords'] = vec3(-330.3080, -1495.2407, 30.6678),
                ['heading'] = 356.9041
            },
            {
                ['coords'] = vec3(-333.4438, -1495.6530, 30.6435),
                ['heading'] = 3.2765
            },
            {
                ['coords'] = vec3(-336.6394, -1495.8014, 30.6169),
                ['heading'] = 355.0816
            },
        }
    },

    {
        ['label'] = 'Luxury Car garage',
        ['type'] = 'car',
        ['coords'] = vec3(-781.5838, -201.1526, 37.2838),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-776.2711, -192.9951, 37.2838)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-772.0566, -198.2632, 36.3250),
                ['heading'] = 119.4163
            },
            {
                ['coords'] = vec3(-787.5616, -198.8414, 36.9359),
                ['heading'] = 300.5040
            },
            {
                ['coords'] = vec3(-789.1656, -196.0189, 36.9346),
                ['heading'] = 300.0139
            },
        }
    },

    {
        ['label'] = 'Lombank garage',
        ['type'] = 'car',
        ['coords'] = vec3(-1508.0442, -442.3745, 35.5919),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1531.4017, -443.6436, 35.4420)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1509.4901, -435.0189, 35.0981),
                ['heading'] = 83.1156
            },
            {
                ['coords'] = vec3(-1509.9824, -431.7534, 35.0954),
                ['heading'] = 85.2703
            },
            {
                ['coords'] = vec3(-1519.8073, -416.1682, 35.0940),
                ['heading'] = 230.7712
            },
            {
                ['coords'] = vec3(-1522.0908, -418.9923, 35.0933),
                ['heading'] = 232.0152
            },
            {
                ['coords'] = vec3(-1524.0896, -421.8347, 35.0945),
                ['heading'] = 230.6378
            },
            {
                ['coords'] = vec3(-1526.5359, -424.1509, 35.0937),
                ['heading'] = 230.1143
            },
            {
                ['coords'] = vec3(-1528.7554, -426.7424, 35.0939),
                ['heading'] = 229.2358
            },
            {
                ['coords'] = vec3(-1531.1074, -429.5530, 35.0939),
                ['heading'] = 228.2564
            },
            {
                ['coords'] = vec3(-1533.2338, -431.9867, 35.0943),
                ['heading'] = 230.0434
            },
            {
                ['coords'] = vec3(-1535.5596, -434.4558, 35.0937),
                ['heading'] = 229.3171
            },
            {
                ['coords'] = vec3(-1508.6036, -428.1469, 35.0939),
                ['heading'] = 85.8688
            },
        }
    },

    {
        ['label'] = 'Motel garage',
        ['type'] = 'car',
        ['coords'] = vec3(327.9850, -221.7308, 54.0867),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(327.9224, -204.5879, 54.0866)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(334.2190, -217.0066, 53.6660),
                ['heading'] = 68.5174
            },
            {
                ['coords'] = vec3(335.0861, -213.4929, 53.6639),
                ['heading'] = 69.6586
            },
            {
                ['coords'] = vec3(336.6698, -210.3779, 53.6647),
                ['heading'] = 69.2071
            },
            {
                ['coords'] = vec3(337.8473, -207.0726, 53.6643),
                ['heading'] = 68.3810
            },
            {
                ['coords'] = vec3(318.6003, -200.0061, 53.6637),
                ['heading'] = 250.1350
            },
            {
                ['coords'] = vec3(317.1392, -203.0780, 53.6633),
                ['heading'] = 249.2970
            },
            {
                ['coords'] = vec3(315.8985, -206.3911, 53.6644),
                ['heading'] = 249.2553
            },
            {
                ['coords'] = vec3(314.7865, -209.5608, 53.6639),
                ['heading'] = 250.1614
            },
        }
    },

    {
        ['label'] = 'Vliegveld garage',
        ['type'] = 'car',
        ['coords'] = vec3(-832.3580, -2351.0945, 14.5706),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-835.7548, -2335.7542, 14.5706)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-830.1127, -2356.2954, 14.1487),
                ['heading'] = 331.3243
            },
            {
                ['coords'] = vec3(-827.1198, -2358.0193, 14.1483),
                ['heading'] = 332.6719
            },
            {
                ['coords'] = vec3(-823.9475, -2359.7139, 14.1474),
                ['heading'] = 328.4125
            },
            {
                ['coords'] = vec3(-820.8310, -2361.2871, 14.1475),
                ['heading'] = 330.6277
            },
            {
                ['coords'] = vec3(-817.8687, -2363.0830, 14.1478),
                ['heading'] = 330.7028
            },
            {
                ['coords'] = vec3(-815.0781, -2364.7288, 14.1483),
                ['heading'] = 329.2166
            },
            {
                ['coords'] = vec3(-812.0212, -2366.4678, 14.1485),
                ['heading'] = 331.3800
            },
            {
                ['coords'] = vec3(-808.8999, -2368.3267, 14.1483),
                ['heading'] = 329.9311
            },
        }
    },

    {
        ['label'] = 'Grote Bank garage',
        ['type'] = 'car',
        ['coords'] = vec3(362.3379, 298.5456, 103.8838),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(358.7032, 286.4501, 103.4916)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(371.0319, 284.5153, 103.2563),
                ['heading'] = 341.6241
            },
            {
                ['coords'] = vec3(378.8649, 293.4342, 103.1959),
                ['heading'] = 160.6969
            },
        }
    },


    {
        ['label'] = 'Politie HB garage',
        ['type'] = 'car',
        ['coords'] = vec3(-1159.0310, -739.9919, 19.8899),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1147.8319, -737.9587, 20.1231)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1144.4087, -745.2997, 19.6968),
                ['heading'] = 103.0319
            },
            {
                ['coords'] = vec3(-1139.9470, -751.1044, 19.4029),
                ['heading'] = 107.4196
            },
        }
    },

    {
        ['label'] = 'Eiland Kleine Garage',
        ['type'] = 'eilandcar',
        ['coords'] = vec3(5053.1689, -4599.3999, 2.8763),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(5062.3540, -4607.9673, 2.4413)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(5049.6636, -4600.5410, 2.5737),
                ['heading'] = 158.3316
            },
            {
                ['coords'] = vec3(5072.7646, -4608.1431, 2.6356),
                ['heading'] = 150.2974
            },
            {
                ['coords'] = vec3(5053.8906, -4623.6221, 2.6843),
                ['heading'] = 68.3863
            },
        }
    },

    {
        ['label'] = 'Eiland Main Garage',
        ['type'] = 'eilandcar',
        ['coords'] = vec3(4519.8931, -4514.4189, 4.5041),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(4529.0200, -4529.0000, 3.4381)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(4507.9756, -4533.5215, 3.7634),
                ['heading'] = 316.6891
            },
            {
                ['coords'] = vec3(4521.4688, -4528.8994, 4.0552),
                ['heading'] = 61.8582
            },
            {
                ['coords'] = vec3(4521.7046, -4506.1050, 4.1490),
                ['heading'] = 37.2409
            },
        }
    },

    {
        ['label'] = 'Eiland Grote Garage',
        ['type'] = 'eilandcar',
        ['coords'] = vec3(4972.1084, -5156.2607, 2.4914),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(4971.4263, -5138.6572, 2.2701)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(4984.8384, -5148.1860, 2.1915),
                ['heading'] = 184.6692
            },
            {
                ['coords'] = vec3(5000.7104, -5143.2505, 2.4521),
                ['heading'] = 114.3898
            },
            {
                ['coords'] = vec3(5014.5859, -5177.0811, 2.4046),
                ['heading'] = 207.6434
            },
        }
    },

    {
        ['label'] = 'Plezierhaven | Helikopter',
        ['type'] = 'helicopter',
        ['coords'] = vec3(-700.6156, -1447.4303, 5.0005),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-745.3829, -1468.5951, 4.0005)
            },
            {
                ['coords'] = vec3(-724.7294, -1443.9557, 4.0005)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-724.7294, -1443.9557, 5.0005),
                ['heading'] = 141.3345
            },
            {
                ['coords'] = vec3(-745.3829, -1468.5951, 5.0005),
                ['heading'] = 137.3258
            },
        }
    },

    {
        ['label'] = 'Los Santos Heli Airport',
        ['type'] = 'helicopter',
        ['coords'] = vec3(-1106.7651, -2873.3643, 13.9462),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1112.5829, -2884.0862, 13.5979)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1090.8105, -2894.8748, 13.9469),
                ['heading'] = 233.1453
            },
            {
                ['coords'] = vec3(-1145.9426, -2864.3823, 13.9460),
                ['heading'] = 151.1453
            },
            {
                ['coords'] = vec3(-1178.2952, -2845.6841, 13.9458),
                ['heading'] = 151.1453
            },
        }
    },

    {
        ['label'] = 'Los Santos Plane Airport',
        ['type'] = 'airplanes',
        ['coords'] = vec3(-942.0859, -2956.0562, 13.9451),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-980.4665, -2996.0598, 12.9451)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-980.4665, -2996.0598, 12.9451),
                ['heading'] = 60.1101
            },
        }
    },

    {
        ['label'] = 'Sandy Shores Plane Airport',
        ['type'] = 'airplanes',
        ['coords'] = vec3(1742.0358, 3305.7532, 41.2235),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1711.9373, 3252.7207, 40.0605)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1711.9373, 3252.7207, 40.0605),
                ['heading'] = 101.4580
            },
        }
    },

    {
        ['label'] = 'Sandy Shores Heli Airport',
        ['type'] = 'helicopter',
        ['coords'] = vec3(1788.8068, 3244.4771, 42.4870),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1770.2383, 3239.8308, 41.1234)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1770.2383, 3239.8308, 41.1234),
                ['heading'] = 102.4208
            },
        }
    },

    {
        ['label'] = 'Grapeseed Airport | Helikopter',
        ['type'] = 'helicopter',
        ['coords'] = vec3(2122.6482, 4784.7959, 40.9703),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(2133.7722, 4807.9595, 40.1293)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(2133.7722, 4807.9595, 40.1293),
                ['heading'] = 114.2544
            },
        }
    },

    {
        ['label'] = 'Grapeseed Airport | Airplanes',
        ['type'] = 'airplanes',
        ['coords'] = vec3(2139.8794, 4789.3037, 40.9703),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(2133.7722, 4807.9595, 41.1293)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(2133.7722, 4807.9595, 41.1293),
                ['heading'] = 114.2544
            },
        }
    },

    {
        ['label'] = 'Plezierhaven | Boten',
        ['type'] = 'boat',
        ['coords'] = vec3(-770.3726, -1428.9608, 1.5954),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-761.6169, -1370.4229, 0.5151),
                ['coords'] = vec3(-738.5659, -1384.6967, 0.2723),
                ['coords'] = vec3(-776.2482, -1428.6973, 0.3073),
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-731.2079, -1334.5350, 0.4746),
                ['heading'] = 230.3115
            },
            {
                ['coords'] = vec3(-731.2079, -1334.5350, 0.4746),
                ['heading'] = 230.3115
            },
            {
                ['coords'] = vec3(-744.5635, -1347.2848, 0.8791),
                ['heading'] = 230.3115
            },
        }
    },

    {
        ['label'] = 'Los Santos Harbour',
        ['type'] = 'boat',
        ['coords'] = vec3(23.8758, -2806.7195, 5.7018),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1.4716, -2793.0723, 0.0095)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1.4716, -2793.0723, 0.0095),
                ['heading'] = 168.3526
            },
        }
    },

    {
        ['label'] = 'Gas Company Harbour',
        ['type'] = 'boat',
        ['invisible'] = true,
        ['coords'] = vec3(594.2020, -2314.4727, 3.0433),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(597.9009, -2298.3750, 0.1855)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(596.8792, -2326.4873, 0.3043),
                ['heading'] = 177.2169
            },
            {
                ['coords'] = vec3(600.3348, -2277.1387, 0.2955),
                ['heading'] = 351.1257
            },
        }
    },

    {
        ['label'] = 'Pacific Harbour',
        ['type'] = 'boat',
        ['coords'] = vec3(3864.2798, 4463.6636, 2.7239),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(3868.6870, 4449.3481, 0.4749)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(3868.6870, 4449.3481, 0.4749),
                ['heading'] = 276.3055
            },
        }
    },


    {
        ['label'] = 'Eiland Grote Haven',
        ['type'] = 'boat',
        ['coords'] = vec3(4929.7539, -5174.3716, 2.4604),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(4918.6401, -5141.2666, 0.3830)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(4926.2881, -5183.4722, 0.3056),
                ['heading'] = 65.2164
            },
            {
                ['coords'] = vec3(4932.0942, -5164.8589, 0.3320),
                ['heading'] = 67.8597
            },
            {
                ['coords'] = vec3(4902.8027, -5170.1216, 0.3011),
                ['heading'] = 336.4454
            },
        }
    },
    {
        ['label'] = 'Eiland Kleine Haven',
        ['type'] = 'boat',
        ['coords'] = vec3(5106.1494, -4626.5601, 2.6284),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(5143.1382, -4665.9907, 0.2467)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(5120.4795, -4639.0103, 0.3145),
                ['heading'] = 165.4152
            },
            {
                ['coords'] = vec3(5128.3604, -4642.1548, 0.3298),
                ['heading'] = 165.6225
            },
            {
                ['coords'] = vec3(5136.8848, -4642.4141, 0.3020),
                ['heading'] = 163.5630
            },
        }
    },
    {
        ['label'] = 'Stad',
        ['type'] = 'polimpound',
        ['coords'] = vec3(372.1382, -1611.8108, 29.2919),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(378.9806, -1614.6340, 29.2863)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(391.86, -1611.38, 28.94),
                ['heading'] = 227.94
            },
            {
                ['coords'] = vec3(394.4488, -1625.47, 28.94),
                ['heading'] = 49.39
            },
            {
                ['coords'] = vec3(400.20, -1618.17, 28.94),
                ['heading'] = 50.51
            },
        }
    },
    {
        ['label'] = 'Politie HB',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-558.1567, -909.1863, 23.8533),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-555.1567, -937.1433, 23.8533)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-535.1179, -902.9435, 23.8533),
                ['heading'] = 58.4944,
            },
            {
                ['coords'] = vec3(-537.1248, -906.5798, 23.8533),
                ['heading'] = 61.3147,
            },
            {
                ['coords'] = vec3(-539.6455, -910.1032, 23.8533),
                ['heading'] = 55.4755,
            },
            {
                ['coords'] = vec3(-542.0071, -913.8250, 23.8533),
                ['heading'] = 60.5155,
            },
        }
    },

    {
        ['label'] = 'PostNL',
        ['type'] = 'car',
        ['coords'] = vec3(-369.7153, 6123.6831, 31.4404),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-371.8974, 6139.2905, 31.3831)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-362.2752, 6138.6787, 31.4451),
                ['heading'] = 96.4226,
            },
            {
                ['coords'] = vec3(-354.4966, 6130.6196, 31.4404),
                ['heading'] = 118.4370,
            },
            {
                ['coords'] = vec3(-346.4616, 6123.5396, 31.4453),
                ['heading'] = 150.1705,
            },
            {
                ['coords'] = vec3(-341.7851, 6116.6826, 31.4427),
                ['heading'] = 148.7957,
            },
        }
    },

    {
        ['label'] = 'Ambulance Garage',
        ['type'] = 'car',
        ['coords'] = vec3(352.6288, -624.0368, 29.3452),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(337.5511, -623.4761, 29.2940)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(346.5424, -621.2844, 29.2940),
                ['heading'] = 163.3825,
            },
            {
                ['coords'] = vec3(339.6899, -619.4249, 29.2940),
                ['heading'] = 165.1709,
            },
            {
                ['coords'] = vec3(335.6399, -629.9370, 29.2940),
                ['heading'] = 337.4996,
            },
        }
    },

    {
        ['label'] = 'Taxi Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(32.4162, -104.5673, 56.0222),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(36.9854, -97.3515, 56.2835)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(12.2104, -98.7347, 57.5139),
                ['heading'] = 341.3524,
            },
        }
    },

    {
        ['label'] = 'Duiker Garage',
        ['type'] = 'car',
        ['coords'] = vec3(506.3899, -3146.4536, 6.0561),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(504.3745, -3128.6831, 6.0698)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(479.3708, -3151.1975, 6.0701),
                ['heading'] = 91.6666,
            },
            {
                ['coords'] = vec3(478.2011, -3145.3889, 6.0701),
                ['heading'] = 83.3534,
            },
            {
                ['coords'] = vec3(479.7554, -3137.5286, 6.0701),
                ['heading'] = 96.5568,
            },
        }
    },

    {
        ['label'] = 'Zwembad verschoner Garage',
        ['type'] = 'car',
        ['coords'] = vec3(-1300.5532, -1252.6831, 4.4755),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1309.7043, -1242.7468, 4.7330)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1302.8580, -1281.0729, 4.3500),
                ['heading'] = 288.4268,
            },
            {
                ['coords'] = vec3(-1310.1522, -1284.4669, 4.5486),
                ['heading'] = 268.4026,
            },
            {
                ['coords'] = vec3(-1297.1602, -1300.7582, 4.5702),
                ['heading'] = 17.9113,
            },
        }
    },

    {
        ['label'] = 'ANWB',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-370.8562, -89.9142, 45.6648),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-344.4347, -89.2712, 45.6653)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-354.2395, -98.7863, 44.8380),
                ['heading'] = 340.1351,
            },
            {
                ['coords'] = vec3(-360.9881, -96.7003, 44.8381),
                ['heading'] = 340.5626,
            },
            {
                ['coords'] = vec3(-367.6634, -94.4855, 44.8377),
                ['heading'] = 339.9727,
            },
        }
    },
    
    {
        ['label'] = 'Garage Cardealer Zuid',
        ['type'] = 'car',
        ['coords'] = vec3(19.8936, -2748.3320, 6.0043),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(10.7445, -2755.9824, 6.0043)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(10.8837, -2754.3394, 6.0043),
                ['heading'] = 358.0
            },
            {
                ['coords'] = vec3(15.0465, -2754.5078, 6.0043),
                ['heading'] = 358.0
            },
        }
    },
    {
        ['label'] = 'Haven',
        ['type'] = 'polboatimpound',
        ['coords'] = vec3(-846.0723, -1367.6445, 1.6052),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-840.8543, -1370.9449, 0.3230)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-845.9951, -1361.9850, 0.2842),
                ['heading'] = 111.6
            },
            {
                ['coords'] = vec3(-850.6658, -1344.6687, 0.3010),
                ['heading'] = 109.8570
            }
        }
    },
    {
        ['label'] = 'KMAR HB Paleto',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-455.5699, 6032.9351, 31.3404),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-453.0100, 6050.1201, 31.1700)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-453.0100, 6050.1201, 31.1700),
                ['heading'] = 219.8941,
            },
            {
                ['coords'] = vec3(-449.1205, 6052.7529, 31.1705),
                ['heading'] = 212.6668,
            },
            {
                ['coords'] = vec3(-445.3981, 6055.4077, 31.1704),
                ['heading'] = 208.6850,
            },
        }
    },
    {
        ['label'] = 'Garage Advocaat',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-561.2953, -133.1042, 38.0570),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-578.2649, -170.5160, 37.8899)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-551.0371, -142.7929, 38.2320),
                ['heading'] = 286.7363,
            },
            {
                ['coords'] = vec3(-570.2686, -145.2243, 37.7517),
                ['heading'] = 199.4879,
            },
        }
    },
    {
        ['label'] = 'KMAR Sandy',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(1842.3446, 3692.5117, 33.9746),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1816.5533, 3688.8569, 33.8052)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1844.7719, 3689.5317, 33.8040),
                ['heading'] = 301.3336,
            },
            {
                ['coords'] = vec3(1861.0444, 3699.1206, 33.6688),
                ['heading'] = 119.8947,
            },
            {
                ['coords'] = vec3(1865.1852, 3692.9309, 33.6685),
                ['heading'] = 118.7302,
            },
            {
                ['coords'] = vec3(1848.7124, 3683.0083, 33.6687),
                ['heading'] = 301.3930,
            },
        }
    },
    {
        ['label'] = 'Sandy | Boten',
        ['type'] = 'boat',
        ['coords'] = vec3(1301.4122, 4217.7383, 33.9087),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1288.8937, 4232.3682, 30.8250),
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1314.6417, 4236.3311, 30.7349),
                ['heading'] = 257.3927
            },
            {
                ['coords'] = vec3(1316.6449, 4248.3696, 30.2905),
                ['heading'] = 257.8313
            },
            {
                ['coords'] = vec3(1320.4679, 4263.0708, 30.1004),
                ['heading'] = 257.3854
            },
        }
    },
    {
        ['label'] = 'Pitstop',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(944.0802, -1569.8015, 30.7379),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(939.8960, -1568.2439, 30.3902)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(907.5009, -1579.3577, 30.3411),
                ['heading'] = 359.5692,
            },
            {
                ['coords'] = vec3(900.9628, -1579.6744, 30.3568),
                ['heading'] = 359.6024,
            },
            {
                ['coords'] = vec3(894.3409, -1579.3481, 30.3985),
                ['heading'] = 0.1949,
            },
        }
    },
    {
        ['label'] = 'Otto',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(842.7487, -820.0785, 26.3270),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(845.4851, -823.2722, 26.3307)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(842.1441, -811.2969, 25.7331),
                ['heading'] = 271.1635,
            },
            {
                ['coords'] = vec3(842.3221, -817.4008, 25.5021),
                ['heading'] = 271.2769,
            },
        }
    },
    {
        ['label'] = 'CarDealer',
        ['type'] = 'car',
        ['coords'] = vec3(-11.6101, -1080.8131, 27.0472),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-24.7641, -1113.4852, 26.9247)
            },
            {
                ['coords'] = vec3(-60.7510, -1117.8883, 26.6703)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-16.7560, -1113.3298, 26.3623),
                ['heading'] = 69.2750,
            },
            {
                ['coords'] = vec3(-15.7422, -1110.3562, 26.3618),
                ['heading'] = 70.1665,
            },
            {
                ['coords'] = vec3(-14.3025, -1107.5068, 26.3619),
                ['heading'] = 70.1665,
            },
            {
                ['coords'] = vec3(-13.3289, -1104.4320, 26.3621),
                ['heading'] = 70.1665,
            },
            {
                ['coords'] = vec3(-12.3087, -1101.5594, 26.3619),
                ['heading'] = 70.1665,
            },
        }
    },
    {
        ['label'] = 'ElectroJob',
        ['type'] = 'car',
        ['coords'] = vec3(717.1000, -2023.1223, 29.2921),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(724.7758, -2012.5671, 28.7297)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(725.4532, -2032.0778, 28.7227),
                ['heading'] = 354.5384,
            },
            {
                ['coords'] = vec3(731.8364, -2032.8834, 28.7148),
                ['heading'] = 355.6791,
            },
        }
    },
    {
        ['label'] = 'PitStopOverkant',
        ['type'] = 'car',
        ['coords'] = vec3(797.5397, -1627.3674, 31.1654),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(791.6324, -1613.2771, 30.7857)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(807.2026, -1622.2362, 30.7921),
                ['heading'] = 69.2838,
            },
            {
                ['coords'] = vec3(805.9952, -1626.0759, 30.6513),
                ['heading'] = 68.7427,
            },
        }
    },
    {
        ['label'] = 'Vliegschool',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1617.80, -3142.52, 13.99),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1621.96, -3137.33, 13.99)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1600.45, -3137.18, 13.59),
                ['heading'] = 330.75,
            },
            {
                ['coords'] = vec3(-1609.05, -3153.82, 13.61),
                ['heading'] = 330.90,
            },
        }
    },
    {
        ['label'] = 'Luchtvaartdealer',
        ['type'] = 'car',
        ['coords'] = vec3(-963.0166, -2921.1653, 13.9451),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-956.02, -2927.50, 13.59)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-962.40, -2930.12, 13.59),
                ['heading'] = 148.88,
            },
            {
                ['coords'] = vec3(-955.6003, -2933.8752, 13.6076),
                ['heading'] = 150.48,
            },
        }
    },
    {
        ['label'] = 'Eiland',
        ['type'] = 'airplanes',
        ['coords'] = vec3(4429.6626, -4480.1123, 4.3283),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(4433.38, -4516.78, 4.78)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(4433.38, -4516.78, 4.78),
                ['heading'] = 109.16
            },
        }
    },
    {
        ['label'] = 'Eiland | Helikopter',
        ['type'] = 'helicopter',
        ['coords'] = vec3(4468.5718, -4463.9312, 4.2483),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(4479.35, -4456.80, 4.21)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(4487.0977, -4455.3813, 4.1392),
                ['heading'] = 201.6037
            },
        }
    },
    {
        ['label'] = 'Sandy Airfield',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(1724.1113, 3301.7854, 41.2235),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1728.7402, 3298.1636, 40.8750)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1724.49, 3314.49, 40.87),
                ['heading'] = 193.86,
            },
            {
                ['coords'] = vec3(1731.40, 3317.57, 40.87),
                ['heading'] = 195.07,
            },
        }
    },
    {
        ['label'] = 'Legerbasis | Helikopter',
        ['type'] = 'helicopter',
        ['invisible'] = true,
        ['coords'] = vec3(-1884.3494, 2816.9111, 32.8065),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1877.0583, 2805.3726, 33.0754)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1877.5939, 2804.4021, 33.0758),
                ['heading'] = 329.2879
            },
        }
    },
    {
        ['label'] = 'Trailer Paleto',
        ['type'] = 'trailer',
        ['invisible'] = false,
        ['coords'] = vec3(182.3397, 6394.0669, 31.3809),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(201.7106, 6395.6777, 31.3826)
            },
            {
                ['coords'] = vec3(153.9630, 6432.6738, 30.9499),
            },
            {
                ['coords'] = vec3(147.6581, 6427.6440, 30.9525),
            },
            {
                ['coords'] = vec3(147.0424, 6420.8315, 30.9243),
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(153.9630, 6432.6738, 30.9499),
                ['heading'] = 73.9948
            },
            {
                ['coords'] = vec3(147.6581, 6427.6440, 30.9525),
                ['heading'] = 72.6420
            },
            {
                ['coords'] = vec3(147.0424, 6420.8315, 30.9243),
                ['heading'] = 73.5845
            },
        }
    },
    {
        ['label'] = 'Trailer Stad',
        ['type'] = 'trailer',
        ['invisible'] = false,
        ['coords'] = vec3(434.3638, -645.9673, 28.7318),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(423.4788, -642.4829, 28.15)
            },
            {
                ['coords'] = vec3(429.3006, -602.4338, 28.1514),
                ['heading'] = 84.2906
            },
            {
                ['coords'] = vec3(428.6077, -610.5132, 28.1516),
                ['heading'] = 85.2354
            },
            {
                ['coords'] = vec3(427.2157, -618.3696, 28.1517),
                ['heading'] = 85.1835
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(429.3006, -602.4338, 28.1514),
                ['heading'] = 84.2906
            },
            {
                ['coords'] = vec3(428.6077, -610.5132, 28.1516),
                ['heading'] = 85.2354
            },
            {
                ['coords'] = vec3(427.2157, -618.3696, 28.1517),
                ['heading'] = 85.1835
            },
        }
    },
    {
        ['label'] = 'Trailer Sandy',
        ['type'] = 'trailer',
        ['invisible'] = false,
        ['coords'] = vec3(183.3613, 2776.3132, 45.6553),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(209.0552, 2751.0867, 43.4263)
            },
            {
                ['coords'] = vec3(178.4584, 2754.0710, 43.0778),
                ['heading'] = 190.1022
            },
            {
                ['coords'] = vec3(168.0048, 2752.8535, 43.0427),
                ['heading'] = 186.9422
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(178.4584, 2754.0710, 43.0778),
                ['heading'] = 190.1022
            },
            {
                ['coords'] = vec3(168.0048, 2752.8535, 43.0427),
                ['heading'] = 186.9422
            },
        }
    },
    {
        ['label'] = 'Humain Labs',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(3574.20, 3673.28, 33.88),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(3563.78, 3672.31, 33.88)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(3576.73, 3664.48, 33.57),
                ['heading'] = 169.53
            },
            {
                ['coords'] = vec3(3563.55, 3666.87, 33.53),
                ['heading'] = 170.47
            },
        }
    },
    {
        ['label'] = 'IKEA',
        ['type'] = 'car',
        ['invisible'] = false,
        ['coords'] = vec3(2748.7737, 3458.1953, 55.9048),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(2761.3997, 3467.2937, 55.3359)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(2768.2473, 3474.4290, 55.1605),
                ['heading'] = 67.5417
            },
            {
                ['coords'] = vec3(2778.4258, 3478.7451, 54.9671),
                ['heading'] = 247.2913
            },
            {
                ['coords'] = vec3(2768.7708, 3456.2026, 55.3406),
                ['heading'] = 247.0595
            },
        }
    },
    {
        ['label'] = 'Gevangenis Garage',
        ['type'] = 'car',
        ['invisible'] = false,
        ['coords'] = vec3(1855.4531, 2592.4482, 45.6720),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1855.8066, 2600.9651, 45.6720)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1855.1425, 2574.8772, 45.6720),
                ['heading'] = 272.3704
            },
            {
                ['coords'] = vec3(1855.0002, 2567.6812, 45.6720),
                ['heading'] = 273.5885
            },
        }
    },
    {
        ['label'] = 'Galileo Garage',
        ['type'] = 'car',
        ['invisible'] = false,
        ['coords'] = vec3(-72.4559, 907.9539, 235.6207),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-66.2896, 892.0181, 235.5588)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-69.0314, 897.6651, 235.5637),
                ['heading'] = 116.7037
            },
            {
                ['coords'] = vec3(-71.1497, 903.2485, 235.6129),
                ['heading'] = 111.4681
            },
        }
    },
    {
        ['label'] = 'Sandy',
        ['type'] = 'polimpound',
        ['coords'] = vec3(2403.9912, 3127.6770, 48.1532),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(2399.8677, 3148.0359, 48.2506)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(2398.1099, 3118.0654, 47.8355),
                ['heading'] =  72.1335
            },
            {
                ['coords'] = vec3(2389.8708, 3093.9695, 47.8050),
                ['heading'] = 349.7545
            },
            {
                ['coords'] = vec3(2422.3521, 3110.6624, 47.8058),
                ['heading'] = 115.8871
            },
        }
    },
    {
        ['label'] = 'Paleto',
        ['type'] = 'polimpound',
        ['coords'] = vec3(-195.9438, 6265.2788, 31.4893),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-190.0064, 6248.0000, 31.4895)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-201.6616, 6263.2534, 31.1408),
                ['heading'] =  41.3020
            },
            {
                ['coords'] = vec3(-194.6226, 6268.5020, 31.1414),
                ['heading'] = 43.0444
            },
            {
                ['coords'] = vec3(-179.1056, 6287.2695, 31.1265),
                ['heading'] = 52.2380
            },
        }
    },
    {
        ['label'] = 'DSIUitvalbasis',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-90.3636, -816.5272, 35.9965),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-96.7153, -805.6660, 36.4602)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-96.9723, -805.2516, 36.1300),
                ['heading'] = 214.6187
            },
            {
                ['coords'] = vec3(-104.0563, -813.8846, 35.6629),
                ['heading'] = 245.4161
            },
            {
                ['coords'] = vec3(-105.8382, -824.8044, 35.1317),
                ['heading'] = 269.9514
            },
        }
    },
    {
        ['label'] = 'Legerbasis',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1869.4769, 2955.8057, 32.8102),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1863.6864, 2956.9109, 32.4623)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1863.6864, 2956.9109, 32.4623),
                ['heading'] = 330.8492
            },
            {
                ['coords'] = vec3(-1833.5134, 2935.7305, 32.4625),
                ['heading'] = 332.1608
            },
            {
                ['coords'] = vec3(-1845.0547, 2942.8772, 32.4627),
                ['heading'] = 331.4192
            },
        }
    },
    {
        ['label'] = 'Hanenkam Cartel Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-118.5665, 1011.7839, 235.7867),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-130.4770, 1005.0259, 235.3841)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-130.4770, 1005.0259, 235.3841),
                ['heading'] = 200.5287
            },
            {
                ['coords'] = vec3(-123.5327, 1007.4399, 235.3840),
                ['heading'] = 202.2851
            },
        }
    },
    {
        ['label'] = 'La fueta | Helikopter',
        ['type'] = 'helicopter',
        ['invisible'] = true,
        ['coords'] = vec3(1460.1089, 1111.7427, 116.0711),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1460.1089, 1111.7427, 116.071)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1460.1089, 1111.7427, 116.0711),
                ['heading'] = 89.6642
            },
        }
    },
    {
        ['label'] = 'Yakuza Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-191.2297, 301.6787, 96.9455),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-197.9235, 314.7256, 96.9456)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-198.7192, 301.1561, 96.9456),
                ['heading'] = 0.5949
            },
            {
                ['coords'] = vec3(-205.5471, 300.9958, 96.9456),
                ['heading'] =  3.5692
            },
        }
    },
    {
        ['label'] = 'Jalisco Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(1415.5618, 1124.3995, 114.8379),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(1407.8547, 1117.7140, 114.8376)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(1408.2040, 1116.5977, 114.837),
                ['heading'] = 80.4474
            },
            {
                ['coords'] = vec3(1407.5916, 1120.0995, 114.8376),
                ['heading'] =  87.8981
            },
        }
    },
    {
        ['label'] = 'Karmellos Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1525.6361, 887.4729, 181.7738),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1531.2096, 890.3080, 181.8864)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1542.7039, 888.8044, 181.4918),
                ['heading'] = 204.3947
            },
            {
                ['coords'] = vec3(-1534.8754, 889.8474, 181.8048),
                ['heading'] = 205.2640
            },
        }
    },
    {
        ['label'] = 'Reznikov Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(383.4137, -7.6825, 82.9806),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(369.7229, -15.0990, 82.9915)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(375.8096, 1.8604, 82.9805),
                ['heading'] = 126.2027
            },
            {
                ['coords'] = vec3(378.3657, -1.2357, 82.9804),
                ['heading'] = 123.4623
            },
        }
    },

    {
        ['label'] = 'Redeye Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-2294.6060, 4334.8169, 29.0811),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-2306.9453, 4339.3682, 29.0811)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-2302.6699, 4340.7935, 29.0811),
                ['heading'] = 228.2027
            },
            {
                ['coords'] = vec3(-2305.8528, 4337.7793, 29.0811),
                ['heading'] = 228.4623
            },
        }
    },

    {
        ['label'] = 'Pavlov Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1534.1792, 80.6303, 56.7742),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1525.6760, 82.5753, 56.5577)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1525.4410, 97.0024, 56.6646),
                ['heading'] = 190.2027
            },
            {
                ['coords'] = vec3(-1523.5741, 93.8315, 56.5790),
                ['heading'] = 190.4623
            },
        }
    },

    {
        ['label'] = 'Bratva Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-2671.8730, 1312.4492, 147.4450),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-2667.0459, 1309.8558, 147.1184)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-2667.2029, 1305.0004, 147.1184),
                ['heading'] = 268.2027
            },
        }
    },

    {
        ['label'] = 'Camorra Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1467.1632, -30.8170, 54.6807),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1462.7542, -40.8804, 54.6531)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1458.3756, -24.2315, 54.6427),
                ['heading'] = 140.2027
            },
            {
                ['coords'] = vec3(-1461.7903, -20.7277, 54.5849),
                ['heading'] = 140.4623
            },
        }
    },

    {
        ['label'] = 'Reznikov Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-721.6256, -415.9095, 34.9838),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-734.6927, -405.2618, 35.3699)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-727.5912, -412.1331, 35.0803),
                ['heading'] = 82.2027
            },
            {
                ['coords'] = vec3(-727.2920, -408.4114, 35.0611),
                ['heading'] = 82.4623
            },
        }
    },

    {
        ['label'] = 'Parkstad Bende Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-89.9218, 356.8989, 112.4351),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-88.9435, 353.0534, 112.4357)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-89.1763, 349.1582, 112.4362),
                ['heading'] = 245.0189
            },
            {
                ['coords'] = vec3(-90.7121, 345.5268, 112.4363),
                ['heading'] = 247.1940
            },
        }
    },

    {
        ['label'] = 'Sons Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(978.6768, -110.0713, 74.3531),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(970.3077, -113.7111, 74.3532)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(978.5300, -127.4105, 74.0350),
                ['heading'] = 59.0189
            },
            {
                ['coords'] = vec3(975.7684, -131.9525, 74.0272),
                ['heading'] = 59.1940
            },
        }
    },

    {
        ['label'] = 'LFC Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1924.2531, 2051.2964, 140.8313),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1918.7979, 2057.2402, 140.7350)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1918.4133, 2052.3208, 140.7354),
                ['heading'] = 261.0189
            },
            {
                ['coords'] = vec3(-1919.3257, 2048.3044, 140.7354),
                ['heading'] = 261.1940
            },
        }
    },

    {
        ['label'] = 'DTMC Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1172.0295, -1155.8118, 5.6522),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1165.7125, -1155.0596, 5.6503)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1163.8348, -1157.3688, 5.6448),
                ['heading'] = 21.0647
            },
            {
                ['coords'] = vec3(-1166.8136, -1157.9268, 5.6453),
                ['heading'] = 15.0395
            },
        }
    },
    {
        ['label'] = 'Tijuana Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-3188.6077, 822.2156, 8.9309),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-3197.2883, 810.5995, 8.9309)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-3199.0208, 817.7173, 8.9309),
                ['heading'] = 207.8878
            },
            {
                ['coords'] = vec3(-3203.3010, 814.2302, 8.9309),
                ['heading'] = 211.9717
            },
        }
    },
    {
        ['label'] = 'CJNG Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(134.6051, 1216.6461, 214.110),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(128.4662, 1226.4222, 214.1098)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(125.6212, 1228.8867, 214.1100),
                ['heading'] = 9.9364
            },
            {
                ['coords'] = vec3(129.3486, 1229.8364, 214.1099),
                ['heading'] = 14.4477
            },
        }
    },
    {
        ['label'] = 'Surenos Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(304.3188, -2745.6135, 6.1824),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(306.1390, -2758.6704, 5.9882)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(305.3684, -2762.7539, 5.9795),
                ['heading'] = 91.3498
            },
            {
                ['coords'] = vec3(305.1421, -2753.9968, 5.9779),
                ['heading'] = 87.2983
            },
        }
    },
    {
        ['label'] = 'Ñeta Association Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-97.4049, 828.2664, 235.7288),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-107.7497, 833.4982, 235.7201)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-110.7778, 832.4390, 235.7181),
                ['heading'] = 335.3880
            },
            {
                ['coords'] = vec3(-105.5024, 832.3835, 235.7153),
                ['heading'] = 6.4843
            },
        }
    },
    {
        ['label'] = 'Crips Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-66.4889, -1817.5515, 26.9419),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-66.9160, -1828.6088, 26.9427)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-71.5077, -1831.1675, 26.9419),
                ['heading'] = 233.0884
            },
            {
                ['coords'] = vec3(-66.4382, -1824.8186, 26.9435),
                ['heading'] = 233.8783
            },
        }
    },
    {
        ['label'] = 'Les Revoltes Garage',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-1796.0277, 454.5050, 128.3081),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-1794.3116, 458.8114, 128.3081)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-1791.5038, 456.1814, 128.3081),
                ['heading'] = 88.9608
            },
            {
                ['coords'] = vec3(-1791.8319, 459.9008, 128.3081),
                ['heading'] = 92.1746
            },
        }
    },
    {
        ['label'] = 'gang_menendez',
        ['type'] = 'car',
        ['invisible'] = true,
        ['coords'] = vec3(-2600.9514, 1931.6362, 167.3054),
        ['deletePoints'] = {
            {
                ['coords'] = vec3(-2597.6238, 1930.0747, 166.9584)
            },
        },
        ['spawnPoints'] = {
            {
                ['coords'] = vec3(-2597.6238, 1930.0747, 166.9584),
                ['heading'] = 276.2501
            },
        }
    },
}