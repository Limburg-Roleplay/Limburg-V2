Config = {}

Config.Settings = {
    ['Prices'] = {
        ['JerryCan'] = 100,
        ['Refill'] = 30
    },
    ['FuelDecor'] = '_FUEL_LEVEL',
    ['PumpModels'] = { 
		[1] = -2007231801, 
		[2] = 1339433404, 
		[3] = 1694452750, 
		[4] = 1933174915, 
		[5] = -462817101, 
		[6] = -469694731, 
		[7] = -164877493,
		[8] = 486135101
	}
}

Config.LocationsObjects = {
	{['coords'] = vec4(-932.7791, -1477.4242, 1.5954, 108.5815)},
	{['coords'] = vec4(-335.8854, -139.6907, 60.4435, 119.6772)}
}

Config.Locations = {
    { ['Coords'] = vector3(49.4187, 2778.793, 58.043) },
	{ ['Coords'] = vector3(263.894, 2606.463, 44.983) },
	{ ['Coords'] = vector3(1039.958, 2671.134, 39.550) },
	{ ['Coords'] = vector3(1207.260, 2660.175, 37.899) },
	{ ['Coords'] = vector3(2539.685, 2594.192, 37.944) },
	{ ['Coords'] = vector3(2679.858, 3263.946, 55.240) },
	{ ['Coords'] = vector3(2005.055, 3773.887, 32.403) },
	{ ['Coords'] = vector3(1687.156, 4929.392, 42.078) },
	{ ['Coords'] = vector3(1701.314, 6416.028, 32.763) },
	{ ['Coords'] = vector3(179.857, 6602.839, 31.868) },
	{ ['Coords'] = vector3(-94.4619, 6419.594, 31.489) },
	{ ['Coords'] = vector3(-2554.996, 2334.40, 33.078) },
	{ ['Coords'] = vector3(-1800.375, 803.661, 138.651) },
	{ ['Coords'] = vector3(-1437.622, -276.747, 46.207) },
	{ ['Coords'] = vector3(-2096.243, -320.286, 13.168) },
	{ ['Coords'] = vector3(-724.619, -935.1631, 19.213) },
	{ ['Coords'] = vector3(-526.019, -1211.003, 18.184) },
	{ ['Coords'] = vector3(-70.2148, -1761.792, 29.534) },
	{ ['Coords'] = vector3(265.648, -1261.309, 29.292) },
	{ ['Coords'] = vector3(819.653, -1028.846, 26.403) },
	{ ['Coords'] = vector3(1208.951, -1402.567,35.224) },
	{ ['Coords'] = vector3(1181.381, -330.847, 69.316) },
	{ ['Coords'] = vector3(620.843, 269.100, 103.089) },
	{ ['Coords'] = vector3(2581.321, 362.039, 108.468) },
	{ ['Coords'] = vector3(176.631, -1562.025, 29.263) },
	{ ['Coords'] = vector3(176.631, -1562.025, 29.263) },
	{ ['Coords'] = vector3(-319.292, -1471.715, 30.549) },
	{ ['Coords'] = vector3(-1145.9111, -2864.4045, 13.9460) },
	{ ['Coords'] = vector3(-756.9984, -1374.3864, 1.1920) },
	{ ['Coords'] = vector3(1784.324, 3330.55, 41.253) }
}

Config.FuelDecor = "_FUEL_LEVEL"
Config.Blacklist = {
	[1] = 'bmx'
}

Config.Classes = {
	[0] = 0.6, -- Compacts
	[1] = 0.6, -- Sedans
	[2] = 0.6, -- SUVs
	[3] = 0.6, -- Coupes
	[4] = 0.6, -- Muscle
	[5] = 0.6, -- Sports Classics
	[6] = 0.6, -- Sports
	[7] = 0.6, -- Super
	[8] = 0.6, -- Motorcycles
	[9] = 0.6, -- Off-road
	[10] = 0.6, -- Industrial
	[11] = 0.6, -- Utility
	[12] = 0.6, -- Vans
	[13] = 0.6, -- Cycles
	[14] = 0.6, -- Boats
	[15] = 0.1, -- Helicopters
	[16] = 0.1, -- Planes
	[17] = 0.5, -- Service
	[18] = 0.6, -- Emergency
	[19] = 1.0, -- Military
	[20] = 0.5, -- Commercial
	[21] = 0.0, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
Config.FuelUsage = {
	[1.0] = 1.1,
	[0.9] = 0.9,
	[0.8] = 0.7,
	[0.7] = 0.6,
	[0.6] = 0.5,
	[0.5] = 0.5,
	[0.4] = 0.4,
	[0.3] = 0.3,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}