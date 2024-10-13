Shared = {}

Shared.Settings = {
    ['prices'] = {
        ['impound'] = 500,
        ['PolitieImpound'] = 3000
    }
}

Shared.Locations = {
    -- // [CAR GARAGES] \\ --
    {
        ['garageLabel'] = 'Gevangenis',
        ['garageType'] = 'car',
        ['interactCoords'] = vec3(1853.0582, 2581.9434, 45.6726),
        ['removeCoords'] = vec3(1862.3848, 2586.1985, 45.672),
        ['spawnCoords'] = {
            { ['coords'] = vec4(1854.9244, 2578.7993, 45.6726, 267.9419) },
            { ['coords'] = vec4(1854.9258, 2575.1565, 45.6726, 266.6691) }
        }
    },
    {
        ['garageLabel'] = 'Blokkenpark',
        ['garageType'] = 'car',
        ['interactCoords'] = vec3(58.07, -634.53, 31.90),
        ['removeCoords'] = vec3(55.02, -610.67, 31.63),
        ['spawnCoords'] = {
            { ['coords'] = vec4(13.17, -586.69, 31.63, 249.60) },
            { ['coords'] = vec4(16.83, -572.81, 31.63, 249.60) }
        }
    },
    {
       ['garageLabel'] = 'Rode Garage',
        ['garageType'] = 'car',
        ['interactCoords'] = vec3(-331.81, -781.57, 33.96),
        ['removeCoords'] = vec3(-342.06, -760.20, 33.97),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-340.62, -767.30, 33.97, 88.83) },
            { ['coords'] = vec4(-357.22, -756.82, 33.97, 266.95) },
            { ['coords'] = vec4(-331.96, -750.19, 33.97, 179.07) }
        }
    },
    {
        ['garageLabel'] = 'Borz Garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(104.6268, -209.9232, 54.6361),
         ['removeCoords'] = vec3(92.3278, -207.1748, 54.4913),
         ['spawnCoords'] = {
             { ['coords'] = vec4(90.9677, -197.4115, 54.4916, 163.6553) },
             { ['coords'] = vec4(87.7672, -196.4984, 54.4916, 155.7360) },
             { ['coords'] = vec4(84.5850, -195.4059, 54.4915, 164.4275) },
             { ['coords'] = vec4(78.4242, -198.5077, 54.4915, 252.0491) },
             { ['coords'] = vec4(77.2226, -201.7327, 54.4915, 251.7803) }
         }
     },
     {
        ['garageLabel'] = 'Unknown',
        ['garageType'] = 'car',
        ['invisible'] = true,
        ['interactCoords'] = vec3(1176.1075, -2083.9172, 23.2834),
        ['removeCoords'] = vec3(1170.2209, -2066.8440, 23.2834),
        ['spawnCoords'] = {
            { ['coords'] = vec4(1170.1703, -2066.7920, 23.2834, 180.3438) },
        }
    },
     {
        ['garageLabel'] = 'Mosley',
        ['garageType'] = 'car',
        ['invisible'] = true,
        ['interactCoords'] = vec3(-25.7457, -1673.5500, 29.4917),
        ['removeCoords'] = vec3(-50.5638, -1688.8602, 29.4725),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-58.5222, -1685.6301, 29.0235, 317.5090) },
        }
    },
     {
        ['garageLabel'] = 'Cardealer Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(953.0510, -944.2864, 42.953),
         ['removeCoords'] = vec3(937.3348, -943.1215, 59.1036),
         ['spawnCoords'] = {
             { ['coords'] = vec4(931.4637, -937.4565, 59.1036, 179.9230) },
             { ['coords'] = vec4(934.2829, -937.5306, 59.1036, 178.4149) },
             { ['coords'] = vec4(937.2690, -937.5376, 59.1036, 181.4837) },
             { ['coords'] = vec4(940.1817, -937.5771, 59.1035, 181.5390) },
             { ['coords'] = vec4(943.1806, -937.6428, 59.1035, 181.0621) },
             { ['coords'] = vec4(946.0536, -937.6277, 59.1035, 180.5563) },
             { ['coords'] = vec4(953.2061, -948.9708, 59.1036, 0.0113) },
             { ['coords'] = vec4(950.4180, -949.0241, 59.1036, 0.0780) },
             { ['coords'] = vec4(947.4030, -948.9481, 59.1036, 0.3898) },
             { ['coords'] = vec4(944.4561, -948.9543, 59.1036, 0.7494) },
             { ['coords'] = vec4(941.5035, -948.9540, 59.1036, 359.8069) },
             { ['coords'] = vec4(938.6209, -948.9492, 59.1036, 359.8601) },
             { ['coords'] = vec4(935.6789, -948.9371, 59.1036, 359.5872) },
             { ['coords'] = vec4(932.5288, -948.9526, 59.1035, 359.5751) }
         }
     },
    {
        ['garageLabel'] = 'Kernal Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(476.8465, -2734.5957, 3.0657),
         ['removeCoords'] = vec3(477.5585, -2741.1575, 3.0852),
         ['spawnCoords'] = {
             { ['coords'] = vec4(477.5585, -2741.1575, 3.0852, 239.4449) },
         }
     },
     {
        ['garageLabel'] = 'Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(946.6768, -966.2668, 59.1036),
         ['removeCoords'] = vec3(955.3259, -972.0680, 59.103),
         ['spawnCoords'] = {
             { ['coords'] = vec4(955.3684, -972.1143, 59.1036, 0.6812) },
             { ['coords'] = vec4(937.5810, -971.9972, 59.1035, 1.6209) }
         }
     },
     {
        ['garageLabel'] = 'Garage',
         ['garageType'] = 'helicopter',
         ['invisible'] = true,
         ['interactCoords'] = vec3(946.6768, -966.2668, 59.1036),
         ['removeCoords'] = vec3(955.3259, -972.0680, 59.103),
         ['spawnCoords'] = {
             { ['coords'] = vec4(955.3684, -972.1143, 59.1036, 0.6812) },
             { ['coords'] = vec4(937.5810, -971.9972, 59.1035, 1.6209) }
         }
     },
     {
        ['garageLabel'] = 'Garage',
         ['garageType'] = 'helicopter',
         ['invisible'] = true,
         ['interactCoords'] = vec3(997.2673, -2359.8843, 30.5096),
         ['removeCoords'] = vec3(1010.9764, -2347.5173, 30.5090),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1010.9764, -2347.5173, 30.5090, 172.7450) }
         }
     },
     {
        ['garageLabel'] = 'MS13 Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-1559.6526, 11.1229, 58.8618),
         ['removeCoords'] = vec3(-1555.4084, 22.0559, 58.6106),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1555.4084, 22.0559, 58.6106, 350.1735) }
         }
     },
     {
        ['garageLabel'] = 'Neta Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(914.9261, -1267.9543, 25.5701),
         ['removeCoords'] = vec3(912.6111, -1254.6692, 25.5649),
         ['spawnCoords'] = {
             { ['coords'] = vec4(916.0991, -1263.9902, 25.5624, 34.6098) }
         }
     },
     {
        ['garageLabel'] = '14K Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-3032.6826, 94.8906, 12.3463),
         ['removeCoords'] = vec3(-3016.0454, 88.5513, 11.6100),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-3023.3586, 93.3297, 11.6110, 317.1271) },
             { ['coords'] = vec4(-3025.9980, 95.6370, 11.6075, 314.7955) },
             { ['coords'] = vec4(98.5757, 247.4208, 108.2198, 249.8313) }
         }
     },
     {
        ['garageLabel'] = 'Santa Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(379.8557, -11.7261, 82.9886),
         ['removeCoords'] = vec3(366.3891, 3.6393, 82.9884),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-3034.2468, 102.5272, 11.6127, 318.8988) },
             { ['coords'] = vec4(-3036.7937, 105.0218, 11.5909, 317.3431) },
             { ['coords'] = vec4(-3039.3345, 107.5429, 11.5853, 318.3496) },
             { ['coords'] = vec4(-3042.2185, 109.8110, 11.5778, 320.4452) }
         }
     },

     {
        ['garageLabel'] = 'Moscow Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-1532.5121, 851.5568, 181.5752),
         ['removeCoords'] = vec3(-1527.3328, 857.8679, 181.6131),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1551.5278, 881.2422, 181.3227, 201.6602) },
             { ['coords'] = vec4(-1548.6487, 884.1337, 181.2967, 205.6731) },
             { ['coords'] = vec4(-1545.6626, 886.0170, 181.3377, 202.6444) },
             { ['coords'] = vec4(-1542.3240, 888.0558, 181.4946, 203.0900) }
         }
     },

     {
        ['garageLabel'] = 'Revoltes Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-1799.3226, 405.7864, 113.3249),
         ['removeCoords'] = vec3(-1794.2526, 397.6261, 112.7931),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1790.5482, 403.3844, 113.0080, 178.9580) },
             { ['coords'] = vec4(-1794.4492, 403.6991, 113.0499, 176.3741) }
         }
     },

     {
        ['garageLabel'] = 'Vera Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(524.6418, -2061.7173, 3.9801),
         ['removeCoords'] = vec3(523.5150, -2066.2273, 4.032),
         ['spawnCoords'] = {
             { ['coords'] = vec4(525.8107, -2066.1558, 4.0252, 86.8193) },
             { ['coords'] = vec4(513.6678, -2066.1218, 3.8953, 93.0602) }
         }
     },

     {
        ['garageLabel'] = 'Vera Garage',
         ['garageType'] = 'boat',
         ['invisible'] = true,
         ['interactCoords'] = vec3(575.4300, -2060.5095, 3.1037),
         ['removeCoords'] = vec3(575.5607, -2070.0627, 2.5033),
         ['spawnCoords'] = {
             { ['coords'] = vec4(575.5607, -2070.0627, 2.5033, 180.6071) }
         }
     },

     {
        ['garageLabel'] = 'Gaviao Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(931.5242, -1474.9510, 30.40),
         ['removeCoords'] = vec3(-1527.3328, 857.8679, 181.6131),
         ['spawnCoords'] = {
             { ['coords'] = vec4(939.6316, -1475.5299, 30.1024, 180.7834) }
         }
     },

     {
        ['garageLabel'] = 'Yardies Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-574.8972, -1595.9066, 26.9002),
         ['removeCoords'] = vec3(-589.6419, -1588.4408, 26.7504),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-615.7892, -1604.3909, 26.7501, 354.6822) },
             { ['coords'] = vec4(-619.4863, -1603.6979, 26.7501, 355.8476) }
         }
     },

     {
        ['garageLabel'] = 'Bratva Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-1894.1722, 2051.8679, 140.9655),
         ['removeCoords'] = vec3(-1890.9321, 2046.0461, 140.8622),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1895.8357, 2034.6953, 140.7414, 157.7520) },
             { ['coords'] = vec4(-1899.6600, 2036.1033, 140.7402, 159.5825) },
             { ['coords'] = vec4(-1905.9535, 2021.2435, 140.7882, 267.7734) },
             { ['coords'] = vec4(-1906.1066, 2017.2255, 140.9337, 268.1892) }
         }
     },

     {
        ['garageLabel'] = 'Casino Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(909.4626, 48.8818, 80.8968),
         ['removeCoords'] = vec3(919.8976, 52.8712, 80.8989),
         ['spawnCoords'] = {
             { ['coords'] = vec4(889.8009, -20.3156, 78.7640, 235.1030) },
             { ['coords'] = vec4(887.8489, -23.0618, 78.7640, 238.3825) },
             { ['coords'] = vec4(886.2346, -26.0103, 78.7640, 237.7881) },
             { ['coords'] = vec4(884.4554, -28.8354, 78.7640, 236.8230) },
             { ['coords'] = vec4(882.6796, -31.9163, 78.7640, 238.2160) }
         }
     },
     {
        ['garageLabel'] = 'Poliakov Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(1396.0134, 1042.5747, 114.334),
         ['removeCoords'] = vec3(1398.6609, 1057.5046, 114.3335),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1407.4756, 1051.5597, 114.3336, 266.7442) }
         }
     },
     {
        ['garageLabel'] = 'Furioza Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(1413.8628, -2042.3938, 51.9986),
         ['removeCoords'] = vec3(1398.6587, -2059.1995, 51.9986),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1404.2551, -2051.5400, 51.9986, 114.6111) }
         }
     },
    {
        ['garageLabel'] = 'Garage Helipads',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-697.1412, -1401.2969, 5.1503),
         ['removeCoords'] = vec3(-682.4861, -1424.5255, 4.0005),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-679.8843, -1403.7747, 5.0005, 84.5654) },
             { ['coords'] = vec4(-680.2276, -1408.0620, 5.0005, 86.0222) }
         }
     },
     {
        ['garageLabel'] = 'Garage Arena',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-73.4868, -2003.9069, 18.2753),
         ['removeCoords'] = vec3(-93.1272, -2002.8611, 18.0169),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-67.5391, -1989.0659, 18.0169, 170.6770) },
             { ['coords'] = vec4(-50.6734, -2001.0553, 18.0170, 108.4031) },
             { ['coords'] = vec4(-78.8055, -1988.3171, 18.0169, 169.5053) },
             { ['coords'] = vec4(-59.8018, -1991.1957, 18.0170, 157.7801) }
         }
     },
     {
        ['garageLabel'] = 'Garage CBR',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(220.4878, -1523.5524, 29.1455),
         ['removeCoords'] = vec3(240.1609, -1504.6832, 28.1443),
         ['spawnCoords'] = {
             { ['coords'] = vec4(227.9549, -1533.7129, 29.2046, 308.1695) },
             { ['coords'] = vec4(230.6098, -1536.5768, 29.2319, 306.2211) },
             { ['coords'] = vec4(232.3329, -1539.6852, 29.2605, 309.2152) },
             { ['coords'] = vec4(250.0939, -1523.1993, 29.1420, 6.25762) }
         }
     },
     {
        ['garageLabel'] = 'Garage Sud',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(430.0812, -1964.9443, 23.2970),
         ['removeCoords'] = vec3(436.9241, -1955.6876, 23.0639),
         ['spawnCoords'] = {
             { ['coords'] = vec4(458.1716, -1969.2650, 22.9964, 137.8843) },
             { ['coords'] = vec4(453.6513, -1965.5011, 22.9702, 179.4422) },
             { ['coords'] = vec4(449.3918, -1961.1864, 22.9694, 175.1212) }
         }
     },
     {
        ['garageLabel'] = 'Paleto Blvd',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(90.8364, 6362.9390, 31.2258),
         ['removeCoords'] = vec3(108.9913, 6378.1924, 31.2258),
         ['spawnCoords'] = {
             { ['coords'] = vec4(94.7166, 6373.7549, 30.6636, 11.2191) },
             { ['coords'] = vec4(102.0060, 6377.0420, 30.6633, 12.9015) },
             { ['coords'] = vec4(73.7392, 6363.5830, 30.6672, 15.4593) },
             { ['coords'] = vec4(80.6068, 6395.6636, 30.6632, 132.6940) },
             { ['coords'] = vec4(80.8776, 6366.6343, 30.6667, 11.7607) }
         }
     },
     {
        ['garageLabel'] = 'Route Sandy 68',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(1141.1857, 2664.0652, 38.1615),
         ['removeCoords'] = vec3(1127.3651, 2664.8413, 38.0166),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1131.6653, 2649.7539, 38.0842, 358.9446) },
             { ['coords'] = vec4(1124.2661, 2650.4041, 38.0844, 1.6293) },
             { ['coords'] = vec4(1116.5408, 2649.7156, 38.0827, 0.5930) },
             { ['coords'] = vec4(1101.7957, 2662.4497, 37.9557, 0.6370) }
         }
     },
     {
        ['garageLabel'] = 'Kortz Center',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-2310.5269, 282.7086, 169.4671),
         ['removeCoords'] = vec3(-2313.0125, 287.8197, 169.1186),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-2315.7524, 293.6253, 169.1187, 114.1774) },
             { ['coords'] = vec4(-2318.2935, 299.5242, 169.1189, 112.7015) }
         }
     },
     {
        ['garageLabel'] = 'Marina Dr',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(1530.6011, 3777.2798, 34.5115),
         ['removeCoords'] = vec3(1562.6752, 3795.6694, 34.1128),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1542.4930, 3780.7397, 34.0501, 209.7075) },
             { ['coords'] = vec4(1546.0811, 3782.5989, 34.0605, 204.5727) },
             { ['coords'] = vec4(1549.3225, 3784.9233, 34.0718, 206.3811) }
         }
     },
     {
        ['garageLabel'] = 'Route 68',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-2536.0984, 2318.5376, 33.2154),
         ['removeCoords'] = vec3(-2555.7563, 2348.0627, 33.0762),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-2529.2837, 2345.7705, 33.0599, 213.7988) },
             { ['coords'] = vec4(-2533.2109, 2345.7986, 33.0599, 211.1561) },
             { ['coords'] = vec4(-2537.1802, 2345.7568, 33.0599, 210.8287) }
         }
     },
     {
        ['garageLabel'] = 'Great Ocean Highway',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-3156.9346, 1094.5475, 20.8538),
         ['removeCoords'] = vec3(-3151.0686, 1059.7280, 20.6199),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-3139.0044, 1078.7317, 20.6208, 79.8846) },
             { ['coords'] = vec4(-3137.8547, 1087.0907, 20.6589, 78.4097) },
             { ['coords'] = vec4(-3136.8662, 1094.6887, 20.6165, 80.3788) },
             { ['coords'] = vec4(-3151.2478, 1096.0757, 20.7066, 284.7978) }
         }
     },
     {
        ['garageLabel'] = 'Route 15',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(2580.9712, 463.2871, 108.6070),
         ['removeCoords'] = vec3(2568.3923, 477.0139, 108.5283),
         ['spawnCoords'] = {
             { ['coords'] = vec4(2589.1008, 450.1848, 108.4556, 94.1662) },
             { ['coords'] = vec4(2588.8918, 443.7248, 108.4556, 90.0947) },
             { ['coords'] = vec4(2579.7109, 438.0333, 108.4556, 7.0904) }
         }
     },
     {
        ['garageLabel'] = 'Algonquin Blvd',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(1736.8716, 3711.2903, 34.1253),
         ['removeCoords'] = vec3(1725.5841, 3708.8738, 34.2333),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1735.5658, 3726.2454, 33.9627, 15.9098) },
             { ['coords'] = vec4(1741.1179, 3677.6257, 34.4175, 199.4085) },
             { ['coords'] = vec4(1718.7788, 3720.0833, 34.1288, 25.1135) }
         }
     },
     {
        ['garageLabel'] = 'Grapeseed Ave',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(1699.1262, 4801.0073, 41.8010),
         ['removeCoords'] = vec3(1690.8640, 4785.1465, 41.9215),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1690.9651, 4778.2773, 41.9215, 88.4266) },
             { ['coords'] = vec4(1691.1025, 4770.4561, 41.9215, 89.5071) },
             { ['coords'] = vec4(1690.8424, 4762.4180, 41.8069, 89.6326) }
         }
     },
     {
        ['garageLabel'] = 'Beach',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-1231.9310, -1431.2284, 4.3289),
         ['removeCoords'] = vec3(-1233.2729, -1406.9976, 4.2551),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1238.2029, -1419.0947, 4.3242, 311.4865) },
             { ['coords'] = vec4(-1245.5662, -1408.7543, 4.3136, 305.4868) }
         }
     },
     {
        ['garageLabel'] = 'Milton Rd',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-561.1852, 321.9857, 84.4037),
         ['removeCoords'] = vec3(-572.7488, 329.9819, 84.5571),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-576.4576, 323.8975, 84.6662, 355.9418) },
             { ['coords'] = vec4(-574.8796, 337.8940, 84.6474, 175.0497) },
             { ['coords'] = vec4(-583.8675, 316.0831, 84.7857, 354.9704) }
         }
     },
     {
        ['garageLabel'] = 'Mirror Park',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(1036.4336, -763.1708, 57.9930),
         ['removeCoords'] = vec3(1046.0140, -791.1768, 57.9897),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1027.5077, -785.4598, 57.8584, 310.3975) },
             { ['coords'] = vec4(1027.7150, -771.6804, 58.0376, 144.2998) }
         }
     },
     {
        ['garageLabel'] = 'PostNL Park',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(68.0629, 13.1636, 69.2144),
         ['removeCoords'] = vec3(77.1093, 18.8771, 69.1011),
         ['spawnCoords'] = {
             { ['coords'] = vec4(54.5320, 19.3814, 69.5065, 347.1367) },
             { ['coords'] = vec4(57.4180, 17.5948, 69.2801, 341.6527) }
         }
     },
     {
        ['garageLabel'] = 'Zwembad garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-1248.1323, -1236.7936, 6.7860),
         ['removeCoords'] = vec3(-1239.5209, -1226.2445, 6.9192),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1263.1652, -1236.4622, 5.0677, 287.3168) },
             { ['coords'] = vec4(-1261.9103, -1239.0612, 5.2656, 289.1635) },
             { ['coords'] = vec4(-1260.9009, -1241.5347, 5.4200, 291.6600) },
             { ['coords'] = vec4(-1260.1481, -1244.0928, 5.5865, 298.3954) },
             { ['coords'] = vec4(-1259.8373, -1243.9656, 5.6059, 283.4642) }
         }
     },
     {
        ['garageLabel'] = 'Vuilnis garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-341.6038, -1491.3575, 30.7553),
         ['removeCoords'] = vec3( -323.5232, -1494.7323, 30.6746),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-327.0130, -1495.3159, 30.6776, 358.2012) },
             { ['coords'] = vec4(-330.3080, -1495.2407, 30.6678, 356.9041) },
             { ['coords'] = vec4(-333.4438, -1495.6530, 30.6435, 3.2765) },
             { ['coords'] = vec4(-336.6394, -1495.8014, 30.6169, 355.0816) }
         }
     },
     {
        ['garageLabel'] = 'Luxury Car garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-781.5838, -201.1526, 37.2838),
         ['removeCoords'] = vec3( -776.2711, -192.9951, 37.2838),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-772.0566, -198.2632, 36.3250, 119.4163) },
             { ['coords'] = vec4(-787.5616, -198.8414, 36.9359, 300.5040) },
             { ['coords'] = vec4(-789.1656, -196.0189, 36.9346,300.0139) }
         }
     },
     {
        ['garageLabel'] = 'Lombank garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-1508.0442, -442.3745, 35.5919),
         ['removeCoords'] = vec3( -1531.4017, -443.6436, 35.4420),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1535.4164, -434.5893, 35.4421, 228.9833) },
             { ['coords'] = vec4(-1533.4657, -431.8948, 35.4421, 232.3147) },
             { ['coords'] = vec4(-1531.0605, -429.4283, 35.4421, 230.4352) },
             { ['coords'] = vec4(-1528.8411, -426.8246, 35.4421, 228.5631) },
             { ['coords'] = vec4(-1526.5038, -424.2713, 35.4422, 231.8513) }
         }
     },
     {
        ['garageLabel'] = 'Motel garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(327.9850, -221.7308, 54.0867),
         ['removeCoords'] = vec3( 327.9224, -204.5879, 54.0866),
         ['spawnCoords'] = {
             { ['coords'] = vec4(334.2190, -217.0066, 53.6660, 68.5174) },
             { ['coords'] = vec4(335.0861, -213.4929, 53.6639, 69.6586) },
             { ['coords'] = vec4(336.6698, -210.3779, 53.6647, 69.2071) },
             { ['coords'] = vec4(337.8473, -207.0726, 53.6643, 68.3810) },
             { ['coords'] = vec4(318.6003, -200.0061, 53.6637, 250.1350) }
         }
     },
     {
        ['garageLabel'] = 'Vliegveld garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-832.3580, -2351.0945, 14.5706),
         ['removeCoords'] = vec3( -835.7548, -2335.7542, 14.5706),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-830.1127, -2356.2954, 14.1487, 331.3243) },
             { ['coords'] = vec4(-827.1198, -2358.0193, 14.1483, 332.6719) },
             { ['coords'] = vec4(-823.9475, -2359.7139, 14.1474, 328.4125) },
             { ['coords'] = vec4(-820.8310, -2361.2871, 14.1475, 330.6277) },
             { ['coords'] = vec4(-817.8687, -2363.0830, 14.1478, 330.7028) }
         }
     },
     {
        ['garageLabel'] = 'Clinton Ave garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(638.2450, 206.5227, 97.6041),
         ['removeCoords'] = vec3(641.8108, 190.5006, 96.0812),
         ['spawnCoords'] = {
             { ['coords'] = vec4(628.2339, 196.1684, 97.2166, 250.5648) },
             { ['coords'] = vec4(627.3603, 192.1873, 97.1786, 248.6462) },
             { ['coords'] = vec4(625.4857, 188.8656, 97.2806, 247.1867) },
             { ['coords'] = vec4(624.0882, 184.6447, 97.3418, 250.0364) },
             { ['coords'] = vec4(643.5918, 180.0248, 95.7658, 249.4135) }
         }
     },
     {
        ['garageLabel'] = 'Eiland Kleine Garage',
         ['garageType'] = 'eilandcar',
         ['interactCoords'] = vec3(5053.1689, -4599.3999, 2.8763),
         ['removeCoords'] = vec3(5062.3540, -4607.9673, 2.4413),
         ['spawnCoords'] = {
             { ['coords'] = vec4(5049.6636, -4600.5410, 2.5737, 158.3316) },
             { ['coords'] = vec4(5072.7646, -4608.1431, 2.6356, 150.2974) },
             { ['coords'] = vec4(5053.8906, -4623.6221, 2.6843, 68.3863) }
         }
     },
     {
        ['garageLabel'] = 'Eiland Main Garage',
         ['garageType'] = 'eilandcar',
         ['interactCoords'] = vec3(4519.8931, -4514.4189, 4.5041),
         ['removeCoords'] = vec3(4529.0200, -4529.0000, 3.4381),
         ['spawnCoords'] = {
             { ['coords'] = vec4(4507.9756, -4533.5215, 3.7634, 316.6891) },
             { ['coords'] = vec4(4521.4688, -4528.8994, 4.0552, 61.8582) },
             { ['coords'] = vec4(4521.7046, -4506.1050, 4.1490, 37.2409) }
         }
     },
     {
        ['garageLabel'] = 'Eiland Grote Garage',
         ['garageType'] = 'eilandcar',
         ['interactCoords'] = vec3(4972.1084, -5156.2607, 2.4914),
         ['removeCoords'] = vec3(4971.4263, -5138.6572, 2.2701),
         ['spawnCoords'] = {
             { ['coords'] = vec4(4984.8384, -5148.1860, 2.1915, 184.6692) },
             { ['coords'] = vec4(5000.7104, -5143.2505, 2.4521, 114.3898) },
             { ['coords'] = vec4(5014.5859, -5177.0811, 2.4046, 207.6434) }
         }
     },
     {
        ['garageLabel'] = 'Politie HB',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-558.1567, -909.1863, 23.8533),
         ['removeCoords'] = vec3(-555.1567, -937.1433, 23.8533),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-535.1179, -902.9435, 23.8533, 58.4944) },
             { ['coords'] = vec4(-537.1248, -906.5798, 23.8533, 61.3147) },
             { ['coords'] = vec4(-539.6455, -910.1032, 23.8533, 55.4755) },
             { ['coords'] = vec4(-542.0071, -913.8250, 23.8533, 60.5155) }
         }
     },
     {
        ['garageLabel'] = 'PostNL',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-369.7153, 6123.6831, 31.4404),
         ['removeCoords'] = vec3(-371.8974, 6139.2905, 31.3831),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-362.2752, 6138.6787, 31.4451, 96.4226) },
             { ['coords'] = vec4(-354.4966, 6130.6196, 31.4404, 118.4370) },
             { ['coords'] = vec4(-346.4616, 6123.5396, 31.4453, 150.1705) },
             { ['coords'] = vec4(-341.7851, 6116.6826, 31.4427, 148.7957) }
        }
    },
    {
        ['garageLabel'] = 'Ambulance Garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(352.6288, -624.0368, 29.3452),
         ['removeCoords'] = vec3(337.5511, -623.4761, 29.2940),
         ['spawnCoords'] = {
             { ['coords'] = vec4(346.5424, -621.2844, 29.2940, 163.3825) },
             { ['coords'] = vec4(339.6899, -619.4249, 29.2940, 165.1709) },
             { ['coords'] = vec4(335.6399, -629.9370, 29.2940, 150.1705) },
             { ['coords'] = vec4(335.6399, -629.9370, 29.2940, 337.4996) }
        }
    },
    {
        ['garageLabel'] = 'Taxi Garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(32.4162, -104.5673, 56.0222),
         ['removeCoords'] = vec3(36.9854, -97.3515, 56.2835),
         ['spawnCoords'] = {
             { ['coords'] = vec4(12.2104, -98.7347, 57.5139, 341.3524) }
        }
    },
    {
        ['garageLabel'] = 'Duiker Garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(506.3899, -3146.4536, 6.0561),
         ['removeCoords'] = vec3(504.3745, -3128.6831, 6.0698),
         ['spawnCoords'] = {
             { ['coords'] = vec4(469.4875, -3148.3013, 6.0701, 269.5455) },
             { ['coords'] = vec4(469.0390, -3152.4231, 6.0701, 270.3582) },
             { ['coords'] = vec4(469.0072, -3144.4314, 6.0701, 269.7038) }
        }
    },
    {  
        ['garageLabel'] = 'Zwembad verschoner Garage',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-1300.5532, -1252.6831, 4.4755),
         ['removeCoords'] = vec3(-1309.7043, -1242.7468, 4.7330),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1302.8580, -1281.0729, 4.3500, 288.4268) },
             { ['coords'] = vec4(-1310.1522, -1284.4669, 4.5486, 268.4026) },
             { ['coords'] = vec4(-1297.1602, -1300.7582, 4.5702, 17.9113) }
            }
        },
        {
              ['garageLabel'] = 'ANWB',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-370.8562, -89.9142, 45.6648),
         ['removeCoords'] = vec3(-344.4347, -89.2712, 45.6653),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-354.2395, -98.7863, 44.8380, 340.1351) },
             { ['coords'] = vec4(-360.9881, -96.7003, 44.8381, 340.5626) },
             { ['coords'] = vec4(-367.6634, -94.4855, 44.8377, 339.9727) }
            }
        },
        {
        ['garageLabel'] = 'Garage Cardealer Zuid',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(152.8022, -3018.0073, 7.0409),
         ['removeCoords'] = vec3(146.8896, -2994.2466, 7.0314),
         ['spawnCoords'] = {
             { ['coords'] = vec4(144.1287, -3000.0640, 7.0311, 1.92) },
             { ['coords'] = vec4(130.2684, -3000.3618, 7.0309, 1.92) }
            }
        },
        {
        ['garageLabel'] = 'KMAR HB Paleto',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-455.5699, 6032.9351, 31.3404),
         ['removeCoords'] = vec3(-453.0100, 6050.1201, 31.1700),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-453.0100, 6050.1201, 31.1700, 219.8941) },
             { ['coords'] = vec4(-449.1205, 6052.7529, 31.1705, 212.6668) },
             { ['coords'] = vec4(-445.3981, 6055.4077, 31.1704, 150.1705) },
             { ['coords'] = vec4(-445.3981, 6055.4077, 31.1704, 208.6850) }
            }
        },
        {
        ['garageLabel'] = 'Garage Advocaat',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-561.2953, -133.1042, 38.0570),
         ['removeCoords'] = vec3(-578.2649, -170.5160, 37.8899),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-551.0371, -142.7929, 38.2320, 286.7363) },
             { ['coords'] = vec4(-570.2686, -145.2243, 37.7517, 199.4879) }
            }
        },
        {
        ['garageLabel'] = 'KMAR Sandy',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(1842.3446, 3692.5117, 33.9746),
         ['removeCoords'] = vec3(1816.5533, 3688.8569, 33.8052),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1844.7719, 3689.5317, 33.8040, 301.3336) },
             { ['coords'] = vec4(1861.0444, 3699.1206, 33.6688, 119.8947) },
             { ['coords'] = vec4(1865.1852, 3692.9309, 33.6685, 118.7302) },
             { ['coords'] = vec4(1848.7124, 3683.0083, 33.6687, 301.3930) }
            }
        },
        {
        ['garageLabel'] = 'Otto',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(842.7487, -820.0785, 26.3270),
         ['removeCoords'] = vec3(845.4851, -823.2722, 26.3307),
         ['spawnCoords'] = {
             { ['coords'] = vec4(842.1441, -811.2969, 25.7331, 271.1635) },
             { ['coords'] = vec4(842.3221, -817.4008, 25.5021, 271.2769) }
            }
        },
        {
        ['garageLabel'] = 'CarDealer',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-6.7001, -1090.0367, 27.0430),
         ['removeCoords'] = vec3(-24.7641, -1113.4852, 26.9247),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-16.7560, -1113.3298, 26.3623, 69.2750) },
             { ['coords'] = vec4(-15.7422, -1110.3562, 26.3618, 70.1665) },
             { ['coords'] = vec4(-14.3025, -1107.5068, 26.3619, 70.1665) },
             { ['coords'] = vec4(-13.3289, -1104.4320, 26.3621, 70.1665) }
            }
        },
        {
             ['garageLabel'] = 'ElectroJob',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(717.1000, -2023.1223, 29.2921),
         ['removeCoords'] = vec3(724.7758, -2012.5671, 28.7297),
         ['spawnCoords'] = {
             { ['coords'] = vec4(725.4532, -2032.0778, 28.7227, 354.5384) },
             { ['coords'] = vec4(731.8364, -2032.8834, 28.7148, 355.6791) }
            }
        },
        {
        ['garageLabel'] = 'Pitstop',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(797.5397, -1627.3674, 31.1654),
         ['removeCoords'] = vec3(791.6324, -1613.2771, 30.7857),
         ['spawnCoords'] = {
             { ['coords'] = vec4(807.2026, -1622.2362, 30.7921, 69.2838) },
             { ['coords'] = vec4(805.9952, -1626.0759, 30.6513, 68.7427) }
            }
        },
        {
        ['garageLabel'] = 'Vliegschool',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-1617.80, -3142.52, 13.99),
         ['removeCoords'] = vec3(-1621.96, -3137.33, 13.99),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1600.45, -3137.18, 13.59, 330.75) },
             { ['coords'] = vec4(-1609.05, -3153.82, 13.61, 330.90) }
            }
        },
        {
        ['garageLabel'] = 'Luchtvaartdealer',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(-963.0166, -2921.1653, 13.9451),
         ['removeCoords'] = vec3(-956.02, -2927.50, 13.59),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-962.40, -2930.12, 13.59, 148.88) },
             { ['coords'] = vec4(-955.6003, -2933.8752, 13.6076, 150.48) }
            }
        },
        {
        ['garageLabel'] = 'Sandy Airfield',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(1724.1113, 3301.7854, 41.2235),
         ['removeCoords'] = vec3(1728.7402, 3298.1636, 40.8750),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1724.49, 3314.49, 40.87, 193.86) },
             { ['coords'] = vec4(1731.40, 3317.57, 40.87, 195.07) }
            }
        },
        {
        ['garageLabel'] = 'Humain Labs',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(3574.20, 3673.28, 33.88),
         ['removeCoords'] = vec3(3563.78, 3672.31, 33.88),
         ['spawnCoords'] = {
             { ['coords'] = vec4(3576.73, 3664.48, 33.57, 169.53) },
             { ['coords'] = vec4(3563.55, 3666.87, 33.53, 170.47) }
            }
        },
        {
        ['garageLabel'] = 'IKEA',
         ['garageType'] = 'car',
         ['interactCoords'] = vec3(2752.0896, 3470.6455, 55.7213),
         ['removeCoords'] = vec3(2761.3997, 3467.2937, 55.3359),
         ['spawnCoords'] = {
             { ['coords'] = vec4(2768.2473, 3474.4290, 55.1605, 67.5417) },
             { ['coords'] = vec4(2778.4258, 3478.7451, 54.9671, 247.2913) }
         }
     },
     {
        ['garageLabel'] = 'Bombo Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-1595.03, -60.45, 56.48),
         ['removeCoords'] = vec3(-1590.00, -58.65, 56.48),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-1575.0210, -59.6619, 56.4917, 271.6014) },
             { ['coords'] = vec4(-1589.4972, -59.1266, 56.4825, 274.9498) }
         }
     },
     {
        ['garageLabel'] = 'LS Motors Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(-897.4823, -2029.8666, 9.4119),
         ['removeCoords'] = vec3(-887.3073, -2039.9363, 9.2991),
         ['spawnCoords'] = {
             { ['coords'] = vec4(-897.8662, -2035.0573, 9.2992, 222.8633) },
             { ['coords'] = vec4(-903.1247, -2039.7216, 9.2992, 225.9068) }
         }
     },
     {
        ['garageLabel'] = 'CCF Garage',
         ['garageType'] = 'car',
         ['invisible'] = true,
         ['interactCoords'] = vec3(1420.10, 1122.57, 114.76),
         ['removeCoords'] = vec3(1420.15, 1118.29, 114.76),
         ['spawnCoords'] = {
             { ['coords'] = vec4(1406.5146, 1118.3357, 114.8374, 89.7381) },
             { ['coords'] = vec4(1390.2451, 1116.7976, 114.8130, 79.0977) }
         }
     },
     {
        ['garageLabel'] = 'Plezierhaven',
        ['garageType'] = 'boat',
        ['interactCoords'] = vec3(-770.37, -1428.96, 1.60),
        ['removeCoords'] = vec3(-773.3516, -1425.2501, -0.4888),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-731.21, -1334.54, 0.47, 230.31) },
            { ['coords'] = vec4(-744.56, -1347.28, 0.88, 230.31) }
        }
    },
    {
        ['garageLabel'] = 'Los Santos Harbour',
        ['garageType'] = 'boat',
        ['interactCoords'] = vec3(23.8758, -2806.7195, 5.7018),
        ['removeCoords'] = vec3(-1.4716, -2793.0723, 0.0095),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-1.4716, -2793.0723, 0.0095, 168.3526) },
        }
    },
    {
        ['garageLabel'] = 'Gas Company Harbour',
        ['garageType'] = 'boat',
        ['interactCoords'] = vec3(594.2020, -2314.4727, 3.0433),
        ['removeCoords'] = vec3(597.9009, -2298.3750, 0.1855),
        ['spawnCoords'] = {
            { ['coords'] = vec4(596.8792, -2326.4873, 0.3043, 177.2169) },
            { ['coords'] = vec4(600.3348, -2277.1387, 0.2955, 351.1257) }
        }
    },
    {
        ['garageLabel'] = 'Pacific Harbour',
        ['garageType'] = 'boat',
        ['interactCoords'] = vec3(3864.2798, 4463.6636, 2.7239),
        ['removeCoords'] = vec3(3868.6870, 4449.3481, 0.4749),
        ['spawnCoords'] = {
            { ['coords'] = vec4(3868.6870, 4449.3481, 0.4749, 276.3055) },
        }
    },
    {
        ['garageLabel'] = 'Eiland Grote Haven',
        ['garageType'] = 'boat',
        ['interactCoords'] = vec3(4929.7539, -5174.3716, 2.4604),
        ['removeCoords'] = vec3(4918.6401, -5141.2666, 0.3830),
        ['spawnCoords'] = {
            { ['coords'] = vec4(4926.2881, -5183.4722, 0.3056, 65.2164) },
            { ['coords'] = vec4(4932.0942, -5164.8589, 0.3320, 67.8597) },
            { ['coords'] = vec4(4902.8027, -5170.1216, 0.3011, 336.4454) },
        }
    },
    {
        ['garageLabel'] = 'Eiland kleine haven',
        ['garageType'] = 'boat',
        ['interactCoords'] = vec3(5106.1494, -4626.5601, 2.6284),
        ['removeCoords'] = vec3(5143.1382, -4665.9907, 0.2467),
        ['spawnCoords'] = {
            { ['coords'] = vec4(5120.4795, -4639.0103, 0.3145, 165.4152) },
            { ['coords'] = vec4(5128.3604, -4642.1548, 0.3298, 165.6225) },
            { ['coords'] = vec4(5136.8848, -4642.4141, 0.3020, 163.5630) },
        }
    },
    -- // [HELICOPTER GARAGES] \\ --

    {
        ['garageLabel'] = 'Plezierhaven | Helikopter',
        ['garageType'] = 'helicopter',
        ['interactCoords'] = vec3 (-700.6156, -1447.4303, 5.0005),
        ['removeCoords'] = vec3(-745.3829, -1468.5951, 4.0005),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-724.7294, -1443.9557, 5.0005, 141.3345) },
            { ['coords'] = vec4(-745.3829, -1468.5951, 5.0005, 137.3258) }
        }
    },
    {
        ['garageLabel'] = 'Los Santos Airport',
        ['garageType'] = 'helicopter',
        ['interactCoords'] = vec3(-1106.77, -2873.36, 13.95),
        ['removeCoords'] = vec3(-1112.58, -2884.09, 13.60),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-1112.40, -2883.74, 13.95, 151.15) },
            { ['coords'] = vec4(-1145.94, -2864.38, 13.95, 151.15) }
        }
    },
    {
        ['garageLabel'] = 'Sandy Shores Heli Airport',
        ['garageType'] = 'helicopter',
        ['interactCoords'] = vec3 (1788.8068, 3244.4771, 42.4870),
        ['removeCoords'] = vec3(1770.2383, 3239.8308, 41.1234),
        ['spawnCoords'] = {
            { ['coords'] = vec4(1770.2383, 3239.8308, 41.1234, 102.4208) },
        }
    },
    {
        ['garageLabel'] = 'Grapeseed Airport | Helikopter',
        ['garageType'] = 'helicopter',
        ['interactCoords'] = vec3(2122.6482, 4784.7959, 40.9703),
        ['removeCoords'] = vec3(2133.7722, 4807.9595, 40.1293),
        ['spawnCoords'] = {
            { ['coords'] = vec4(2133.7722, 4807.9595, 40.1293, 114.2544) },
        }
    },
    {
        ['garageLabel'] = 'Legerbasis | Helikopter',
        ['garageType'] = 'helicopter',
        ['interactCoords'] = vec3(-1884.3494, 2816.9111, 32.8065),
        ['removeCoords'] = vec3(-1877.0583, 2805.3726, 33.0754),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-1877.0583, 2805.3726, 33.0754, 329.2879) },
        }
    },
    {
        ['garageLabel'] = 'Eiland | Helikopter',
        ['garageType'] = 'helicopter',
        ['interactCoords'] = vec3 (4468.5718, -4463.9312, 4.2483),
        ['removeCoords'] = vec3(4479.35, -4456.80, 4.21),
        ['spawnCoords'] = {
            { ['coords'] = vec4(4487.0977, -4455.3813, 4.1392, 201.6037) },
            { ['coords'] = vec4(-745.3829, -1468.5951, 5.0005, 137.3258) }
        }
    },

    -- // [AIRPLANES GARAGES] \\ --

    {
        ['garageLabel'] = 'Los Santos Airport',
        ['garageType'] = 'airplanes',
        ['interactCoords'] = vec3(-942.09, -2956.06, 13.95),
        ['removeCoords'] = vec3(-980.47, -2996.06, 12.95),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-980.47, -2996.06, 12.95, 60.11) }
        }
    },
    {
        ['garageLabel'] = 'Los Santos Airport',
        ['garageType'] = 'airplanes',
        ['interactCoords'] = vec3(-942.0859, -2956.0562, 13.9451),
        ['removeCoords'] = vec3(-980.4665, -2996.0598, 12.9451),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-980.4665, -2996.0598, 12.9451, 60.1101) }
        }
    },
    {
        ['garageLabel'] = 'Sandy Shores Plane Airport',
        ['garageType'] = 'airplanes',
        ['interactCoords'] = vec3(1742.0358, 3305.7532, 41.2235),
        ['removeCoords'] = vec3(1711.9373, 3252.7207, 40.0605),
        ['spawnCoords'] = {
            { ['coords'] = vec4(1711.9373, 3252.7207, 40.0605, 101.4580) }
        }
    },
    {
        ['garageLabel'] = 'Grapeseed Airport',
        ['garageType'] = 'airplanes',
        ['interactCoords'] = vec3(2139.8794, 4789.3037, 40.9703),
        ['removeCoords'] = vec3(2133.7722, 4807.9595, 41.1293),
        ['spawnCoords'] = {
            { ['coords'] = vec4(2133.7722, 4807.9595, 41.1293, 114.2544) }
        }
    },
    {
        ['garageLabel'] = 'Eiland',
        ['garageType'] = 'airplanes',
        ['interactCoords'] = vec3(4468.5718, -4463.9312, 4.2483),
        ['removeCoords'] = vec3(4433.38, -4516.78, 4.78),
        ['spawnCoords'] = {
            { ['coords'] = vec4(4433.38, -4516.78, 4.78, 109.16) }
        }
    },
    {
        ['garageLabel'] = 'Los Santos Airport',
        ['garageType'] = 'airplanes',
        ['interactCoords'] = vec3(-942.09, -2956.06, 13.95),
        ['removeCoords'] = vec3(-980.47, -2996.06, 12.95),
        ['spawnCoords'] = {
            { ['coords'] = vec4(-980.47, -2996.06, 12.95, 60.11) }
        }
    },
    {
        ['garageLabel'] = 'Politie Impound',
        ['garageType'] = 'polimpound',
        ['interactCoords'] = vec3(-191.8642, -1162.3573, 23.6714),
        ['removeCoords'] = vec3(-240.1242, -1173.4521, 23.0385),
        ['spawnCoords'] = {
            {
                ['coords'] = vec4(-198.1446, -1174.0306, 23.0440, 201.7933)
            },
            {
                ['coords'] = vec4(-194.8603, -1173.5574, 23.0440, 198.5625)
            },
            {
                ['coords'] = vec4(-191.1091, -1173.8092, 23.0440, 196.5264)
            },
        }
    },
}

Shared.Blips = {
    ['car'] = {
        ['sprite'] = 524,
        ['text'] = "Garage | Voertuigen"
    },
    ['eilandcar'] = {
        ['sprite'] = 524,
        ['text'] = "Garage | Eilandvoertuigen"
    },
    ['boat'] = {
        ['sprite'] = 755,
        ['text'] = "Garage | Boten"
    },
    ['helicopter'] = {
        ['sprite'] = 43,
        ['text'] = "Garage | Helikopters"
    },
    ['airplanes'] = {
        ['sprite'] = 307,
        ['text'] = "Garage | Vliegtuigen"
    },
    ['polimpound'] = {
        ['sprite'] = 60,
        ['text'] = "Politie Impound"
    },
}