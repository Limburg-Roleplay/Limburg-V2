Config	=	{}

Config.CheckOwnership = true -- If true, Only owner of vehicle can store items in trunk.
Config.AllowPolice = true -- If true, police will be able to search players' trunks.

Config.Locale   = 'en'

 -- Limit, unit can be whatever you want. Originally grams (as average people can hold 25kg)
Config.Limit = 25000

-- Default weight for an item:
	-- weight == 0 : The item do not affect character inventory weight
	-- weight > 0 : The item cost place on inventory
	-- weight < 0 : The item add place on inventory. Smart people will love it.
Config.DefaultWeight = 10

Config.localWeight = {
	bread = 125,
	water = 330,
	WEAPON_SMG = 5000,
    weed = 10,
    weed_pooch = 280,
    coke = 10,
    coke_pooch = 280,
    opium = 10,
    opium_pooch = 280,
    stone = 10,
    washed_stone = 10,
    gold = 15,
    iron = 10,
    wood = 20,
    jewels = 30,
    fabric = 10,
    coke_brick = 250,
    xtc_brick = 250,
    meth_brick = 250,
    coke_bag = 25,
    meth_bag = 25,
    xtc_bag = 25,
    wool = 10,
    lsd_brick = 40,
    lsd_bag = 25,
    tenen_brick = 40,
    tenen_bag = 25,
}


Config.VehicleLimit = {
    [0] = 15000, --Compact
    [1] = 7500, --Sedan
    [2] = 15000, --SUV
    [3] = 7000, --Coupes
    [4] = 7000, --Muscle
    [5] = 10000, --Sports Classics
    [6] = 10000, --Sports
    [7] = 5000, --Super
    [8] = 1000, --Motorcycles
    [9] = 15000, --Off-road
    [10] = 15000, --Industrial
    [11] = 15000, --Utility
    [12] = 15000, --Vans
    [13] = 0, --Cycles
    [14] = 2000, --Boats
    [15] = 0, --Helicopters
    [16] = 0, --Planes
    [17] = 7000, --Service
    [18] = 7000, --Emergency
    [19] = 0, --Military
    [20] = 5000, --Commercial
    [21] = 0, --Trains
}
Config.VehiclePlate = {
	taxi        = "TAXI",
	cop         = "POLITIE",
	ambulance   = "AMBULANCE",
	mecano	    = "MONTEUR",
}
