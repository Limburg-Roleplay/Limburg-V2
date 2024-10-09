return {

	-- ============= --
	-- === HEALS === --
	-- ============= --

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

    ['armour'] = {
		label = 'Kevlar Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500,
            export = 'mr_bulletproof.bulletproofvest',
		}
	},

	-- ============= --
	-- === MONEY === --
	-- ============= --

	['black_money'] = {
		label = 'Zwart geld',
		weight = 0,
	},

	['money'] = {
		label = 'Contant geld',
		weight = 0,
	},

	-- ============= --
	-- === FOOD === --
	-- ============= --

	['pizza'] = {
		label = 'Pizza',
		description = 'In ieder geval is dit geen Hawai.',
		weight = 300,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'sandwich',
			usetime = 2000,
		},
	},

	['fries'] = {
		label = 'Friet',
		description = 'Het is patat, geen friet..',
		weight = 150,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { bone = 18905, model = 'prop_food_bs_chips', pos = vec3(0.15, 0.005, 0.020), rot = vec3(290.0, 155.0, -10.0) },
			usetime = 2000,
		},
	},

	['burger'] = {
		label = 'Hamburger',
		description = 'Lekkere Hamburger.',
		weight = 175,
		client = {
			status = { hunger = 200000 },
			anim = 'eating2',
			prop = 'burger',
			usetime = 2000,
		},
	},

	['burger_chicken'] = {
		label = 'Kip Burger',
		description = 'Lekkere Kipburger.',
		weight = 175,
		client = {
			status = { hunger = 200000 },
			anim = 'eating2',
			prop = 'burger',
			usetime = 2000,
		},
	},

	['bread'] = {
		label = 'Brood',
		description = 'Iets lekkers om te eten.',
		weight = 70,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'sandwich',
			usetime = 2000,
		}
	},
    
   	['backpack'] = {
		label = 'Bewijszakje',
		weight = 220,
		stack = false,
		consume = 0,
		client = {
			export = 'wasabi_backpack.openBackpack'
		}
	},
    
	['chips'] = {
		label = 'Chips',
		description = 'Lekker knapperig.',
		weight = 175,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'sandwich',
			usetime = 2000,
		},
	},

	['donut'] = {
		label = 'Donut',
		description = 'Voor de Politie mensen..',
		weight = 55,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'donut',
			usetime = 2000,
		},
	},


	-- ============= --
	-- === DRINKS === --
	-- ============= --

	['cola'] = {
		label = 'Cola',
		description = 'Dit is geen cocaine!',
		weight = 330,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking',
			prop = 'cola',
			usetime = 2000,
		},
	},
	
	['sinas'] = {
		label = 'Sinas',
		description = 'Dit is echt Sintastisch.',
		weight = 330,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking',
			prop = 'cola',
			usetime = 2000,
		},
	},

	['sprunk'] = {
		label = 'Sprunk',
		description = 'Dit is geen sprite.',
		weight = 330,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking',
			prop = 'cola',
			usetime = 2000,
		},
	},

	['water'] = {
		label = 'Water',
		description = 'Wil je mij vergiftigen ofzo?',
		weight = 150,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking2',
			prop = 'water',
			usetime = 2000,
		},
	},
    
    ['beer'] = {
		label = 'Bier',
		description = 'Dronken?',
		weight = 150,
		client = {
			status = { drunk = 200000 },
			anim = 'drinking2',
			prop = 'water',
			usetime = 2000,
		},
	},

	['chocomel'] = {
		label = 'Chocomelk',
		description = 'Van de appie!',
		weight = 150,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking2',
			prop = 'water',
			usetime = 2000,
		},
	},

	['energy'] = {
		label = 'Energy',
		description = 'Voor de skere rakkers!',
		weight = 150,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking2',
			prop = 'water',
			usetime = 2000,
		},
	},

	['optimel'] = {
		label = 'Drinkyoghurt Framboos',
		description = 'Voor de knapen die melk niet lusten!',
		weight = 150,
		client = {
			status = { thirst = 200000 },
			anim = 'drinking2',
			prop = 'water',
			usetime = 2000,
		},
	},
	

	['dsischild'] = {
		label = 'DSI Schild',
		description = 'Een Schild alleen voor de Dienst Speciale Interventies..',
		weight = 950,
		allowArmed = true,
	},


	-- ============= --
	-- === GADGETS === --
	-- ============= --

	['handcuffs'] = {
		label = 'Handboeien',
		description = 'Lijkt wel iets waarmee je iemand vast kan binden..',
		weight = 980,
	},

	['tiewraps'] = {
		label = 'Tiewraps',
		description = 'Lijkt wel iets waarmee je iemand vast kan binden..',
		weight = 90,
	},
	['medkit'] = {
		label = 'Medkit',
		description = 'Hiermee kan je iemand omhoog helpen met de juiste trainingen..',
		weight = 90,
	},

	['lockpick'] = {
		label = 'Lockpick',
		description = 'Misschien kan je hiermee iets openen?',
		weight = 160,
	},

	["phone"] = {
		label = "Telefoon",
		weight = 150,
		consume = 0,
	},

	['radio'] = {
		label = 'Portofoon',
		description = 'Iets om mee te communiceren in bepaalde kanalen ofzo.',
		weight = 150,
	},

	['repairkit'] = {
		label = 'Reparatieset',
		description = 'Als je dit gebruikt, weet je dat je niet kan rijden..',
		weight = 912,
	},

	['wapenrepairkit'] = {
		label = 'Wapen Reparatieset',
		description = 'Als je dit gebruikt, weet je dat je niet kan schieten..',
		weight = 912,
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 2500,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['jerrycan'] = {
		label = 'Jerrycan',
		description = 'Om een extra zetje in je voertuig te geven',
		weight = 500,
		server = {
			export = 'frp-benzine.benzine',
		}
	},

	['weed'] = {
		label = 'Onverpakte Wiet',
		description = 'Iets met legaal en illegaal..',
		weight = 250
	},

	['coca_leaf'] = {
		label = 'Coca bladeren',
		description = 'Iets met legaal en illegaal..',
		weight = 250
	},

	['cocainepoeder'] = {
		label = 'Cocaine Zakje',
		description = 'Iets met legaal en illegaal..',
		weight = 1000
	},

	['cokeblok'] = {
		label = 'Cocaine Blok',
		description = 'Met dit opzak ben je net Tony Montana..',
		weight = 1000
	},

	['coke'] = {
		label = 'Cocaine Bladeren',
		description = 'Met dit opzak ben je net Tony Montana..',
		weight = 1000
	},

	['xtc'] = {
		label = 'XTC Zakje',
		description = 'Iets met legaal en illegaal..',
		weight = 100
	},

	['weed_packed'] = {
		label = 'Verpakte Wiet',
		description = 'Iets met legaal en illegaal..',
		weight = 100
	},


	-- ============= --
	-- === OVERVALLEN === --
	-- ============= --


	['jewels'] = {
		label = 'Juwelen',
		weight = 125,
	},

	['jachtkey'] = {
		label = 'Jacht Key',
		weight = 125,
	},

	['laptop'] = {
		label = 'Laptop',
		weight = 1500,
	},

	['drill'] = {
		label = 'Boor',
		weight = 1500,
	},

	['thermiet'] = {
		label = 'Thermiet',
		weight = 250,
	},


	["blowpipe"] = {
		label = "Blowtorch",
		weight = 2,
		stack = true,
		close = true,
	},

	["g4s"] = {
		label = "G4S Pas",
		weight = 2,
		stack = true,
		close = true,
	},
    
     ["hammerwirecutter"] = {
		label = "Hammer Wirecutter",
		weight = 2,
		stack = true,
		close = true,
	},
    
    ["accesscard"] = {
		label = "Toegangskaartje",
		weight = 2,
		stack = true,
		close = true,
	},
    
    ["goldbar"] = {
		label = "Goudstaaf",
		weight = 2,
		stack = true,
		close = true,
	},
    
    ["goldwatch"] = {
		label = "Goud Horloge",
		weight = 2,
		stack = true,
		close = true,
	},
    
    ["goldnecklace"] = {
		label = "Goude Ketting",
		weight = 2,
		stack = true,
		close = true,
	},
    
	["hacking_device"] = {
		label = "Hack Apparaat",
		weight = 2,
		stack = true,
		close = true,
	},

	["c4"] = {
		label = "C4",
		weight = 2,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 3,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

    ["lsd"] = {
		label = "LSD",
		weight = 430,
		stack = true,
		close = true,
	},
    
    ["meth"] = {
		label = "Meth",
		weight = 130,
		stack = true,
		close = true,
	},
    
    ["methzakje"] = {
		label = "Meth Zakje",
		weight = 340,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Medikit",
		weight = 2,
		stack = true,
		close = true,
	},

	["medbag"] = {
		label = "Medical Bag",
		weight = 1,
		stack = true,
		close = true,
	},

    ["ghb_ton"] = {
		label = "Ghb Ton",
		weight = 120,
		stack = true,
		close = true,
	},

    ["ghb"] = {
		label = "Ghb Poeder",
		weight = 200,
		stack = true,
		close = true,
	},

	["alive_chicken"] = {
		label = "Living chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["black_phone"] = {
		label = "Black Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["blue_phone"] = {
		label = "Blue Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["burncream"] = {
		label = "Burn Cream",
		weight = 1,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Body Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["classic_phone"] = {
		label = "Classic Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Cloth",
		weight = 1,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Copper",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Cut wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["defib"] = {
		label = "Defibrillator",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamonds_box"] = {
		label = "Diamonds box",
		weight = 1,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gas",
		weight = 1,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Fabric",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Fish",
		weight = 1,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Repair Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Repair Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["gas_mask"] = {
		label = "Gas mask",
		weight = 1,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 1,
		stack = true,
		close = true,
	},

	["gold_ingot"] = {
		label = "Gold ingot",
		weight = 1,
		stack = true,
		close = true,
	},

	["gold_phone"] = {
		label = "Gold Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["gps"] = {
		label = "GPS",
		weight = 1,
		stack = true,
		close = true,
	},

	["greenlight_phone"] = {
		label = "Green Light Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["green_phone"] = {
		label = "Green Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["hacking_computer"] = {
		label = "Hacking computer",
		weight = 1,
		stack = true,
		close = true,
	},

	["icepack"] = {
		label = "Ice Pack",
		weight = 1,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Iron",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Chicken fillet",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["painting"] = {
		label = "Painting",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["phone_hack"] = {
		label = "Phone Hack",
		weight = 10,
		stack = true,
		close = true,
	},

	["phone_module"] = {
		label = "Phone Module",
		weight = 10,
		stack = true,
		close = true,
	},

	["pink_phone"] = {
		label = "Pink Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["powerbank"] = {
		label = "Power Bank",
		weight = 10,
		stack = true,
		close = true,
	},

	["red_phone"] = {
		label = "Red Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["sedative"] = {
		label = "Sedative",
		weight = 1,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Slaughtered chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["suturekit"] = {
		label = "Suture Kit",
		weight = 1,
		stack = true,
		close = true,
	},

	["thermal_charge"] = {
		label = "Thermal charge",
		weight = 1,
		stack = true,
		close = true,
	},

	["tweezers"] = {
		label = "Tweezers",
		weight = 1,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Washed stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_black_phone"] = {
		label = "Wet Black Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wet_blue_phone"] = {
		label = "Wet Blue Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wet_classic_phone"] = {
		label = "Wet Classic Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wet_gold_phone"] = {
		label = "Wet Gold Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wet_greenlight_phone"] = {
		label = "Wet Green Light Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wet_green_phone"] = {
		label = "Wet Green Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wool",
		weight = 1,
		stack = true,
		close = true,
	},

	["wet_pink_phone"] = {
		label = "Wet Pink Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wet_red_phone"] = {
		label = "Wet Red Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wet_white_phone"] = {
		label = "Wet White Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["white_phone"] = {
		label = "White Phone",
		weight = 10,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["hackerDevice"] = {
		label = "Hacker Device",
		weight = 10,
		stack = true,
		close = true,
	},
    ['weed'] = {
		label = 'Onverpakte Wiet',
		description = 'Iets met legaal en illegaal..',
		weight = 250
	},

	['cocaleaf'] = {
		label = 'Coca bladeren',
		description = 'Iets met legaal en illegaal..',
		weight = 250
	},
    ['xtc'] = {
		label = 'XTC Zakje',
		description = 'Iets met legaal en illegaal..',
		weight = 1000
	},

	['weed_packed'] = {
		label = 'Verpakte Wiet',
		description = 'Iets met legaal en illegaal..',
		weight = 1000
	},
    ["weed_card"] = {
		label = "Wiet kaart",
		weight = 1,
		stack = true,
		close = true,
	},
    ["weed_access"] = {
		label = "Access card",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_blunt"] = {
		label = "Blunt",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_bud"] = {
		label = "Weed Bud",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_budclean"] = {
		label = "Weed Bud",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_joint"] = {
		label = "Joint",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_package"] = {
		label = "Weed Bag",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_papers"] = {
		label = "Weed papers",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_wrap"] = {
		label = "Blunt wraps",
		weight = 1,
		stack = true,
		close = true,
	},
    
}