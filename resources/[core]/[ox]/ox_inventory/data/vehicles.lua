return {
	-- 0	vehicle has no storage
	-- 1	vehicle has no trunk storage
	-- 2	vehicle has no glovebox storage
	-- 3	vehicle has trunk in the hood
	Storage = {
		['jester'] = 3,
		['adder'] = 3,
		['osiris'] = 1,
		['pfister811'] = 1,
		['penetrator'] = 1,
		['autarch'] = 1,
		['bullet'] = 1,
		['cheetah'] = 1,
		['cyclone'] = 1,
		['voltic'] = 1,
		['reaper'] = 3,
		['entityxf'] = 1,
		['t20'] = 1,
		['taipan'] = 1,
		['tezeract'] = 1,
		['torero'] = 3,
		['turismor'] = 1,
		['fmj'] = 1,
		['infernus'] = 1,
		['italigtb'] = 3,
		['italigtb2'] = 3,
		['nero2'] = 1,
		['vacca'] = 3,
		['vagner'] = 1,
		['visione'] = 1,
		['prototipo'] = 1,
		['zentorno'] = 1,
		['trophytruck'] = 0,
		['trophytruck2'] = 0,
	},

	-- slots, maxWeight; default weight is 8000 per slot
	glovebox = {
		[0] = {11, 10000},		-- Compact
		[1] = {11, 10000},		-- Sedan
		[2] = {11, 10000},		-- SUV
		[3] = {11, 10000},		-- Coupe
		[4] = {11, 10000},		-- Muscle
		[5] = {11, 10000},		-- Sports Classic
		[6] = {11, 10000},		-- Sports
		[7] = {11, 10000},		-- Super
		[8] = {5, 10000},		-- Motorcycle
		[9] = {11, 10000},		-- Offroad
		[10] = {11, 10000},		-- Industrial
		[11] = {11, 10000},		-- Utility
		[12] = {11, 10000},		-- Van
		[14] = {31, 200000},     -- Boat
		[15] = {31, 150000},	-- Helicopter
		[16] = {51, 10000},	    -- Plane
		[17] = {11, 10000},		-- Service
		[18] = {11, 10000},		-- Emergency
		[19] = {11, 10000},		-- Military
		[20] = {11, 10000},		-- Commercial (trucks)
		models = {
            [`frogger`] = {50, 15000},
            [`volatus`] = {50, 400000},
            [`swift`] = {50, 15000},
            [`luxor`] = {50, 1800000},
		}
	},

	trunk = {
		[0] = {50, 20000}, -- Compact
		[1] = {50, 20000}, -- Sedan
		[2] = {50, 20000},		-- SUV
		[3] = {50, 20000},		-- Coupe
		[4] = {50, 20000},		-- Muscle
		[5] = {50, 20000},		-- Sports Classic
		[6] = {50, 20000},		-- Sports
		[7] = {50, 20000},		-- Super
		[8] = {5, 20000},		-- Motorcycle
		[9] = {50, 20000},		-- Offroad
		[10] = {50, 20000},		-- Industrial
		[11] = {50, 20000},		-- Utility
		[12] = {50, 20000},		-- Van
		[14] = {50, 20000},	-- Boat
		[15] = {50, 20000},	-- Helicopter
		[16] = {50, 20000},	-- Plane
		[17] = {50, 20000},		-- Service
		[18] = {50, 50000},		-- Emergency
		[19] = {50, 20000},		-- Military
		[20] = {50, 20000},		-- Commercial (trucks)
		models = {
            [`ballerdef`] = {50, 80000},
			[`ballermansory`] = {50, 80000},
			[`gstjub1`] = {50, 70000},
			[`gstreb1`] = {50, 70000},
			[`gsttoros1`] = {50, 50000},
			[`torosvenatus`] = {50, 70000},
			[`argento`] = {50, 40000},
			[`caracaran`] = {50, 120000},
			[`ballerdef`] = {50, 150000},
			[`ballerdef`] = {50, 150000},
			[`ballerdef`] = {50, 150000},
			[`ballerdef`] = {50, 150000},
			[`ballerdef`] = {50, 150000},

		},
		
		boneIndex = {
			[`pounder`] = 'wheel_rr',
			[`pts21`] = 'bonnet',
			[`dinghy4`] = 'bodyshell',
			[`speeder`] = 'bodyshell',
            [`squalo`] = 'bodyshell',
			[`seashark`] = 'bodyshell',
			[`longfin`] = 'bodyshell',
            [`gstyosemite1`] = 'misc_c',
            [`logvolvo`] = 'chassis2',
            [`dbx`] = 'brakelight_m',
            [`600lt`] = 'bonnet',
            [`sportrs`] = 'bodyshell',
			[`titan17`] = 'bodyshell',
			[`m1000rr`] = 'bodyshell',
			[`kx450f`] = 'bodyshell',
			[`zx10`] = 'bodyshell',
			[`zx10r`] = 'bodyshell',
			[`exc530sm`] = 'bodyshell',
			[`excf250`] = 'bodyshell',
			[`ksd`] = 'bodyshell',
			[`africat`] = 'bodyshell',
			[`rangerover2`] = 'bodyshell',
			[`daemon3`] = 'bodyshell',
			[`daemon4`] = 'bodyshell',
			[`dragoon`] = 'bodyshell',
			[`foxharley1`] = 'bodyshell',
			[`motor1`] = 'bodyshell',
			[`motor3`] = 'bodyshell',
			[`motor5`] = 'bodyshell',
			[`oscurecer`] = 'bodyshell',
			[`sonsmotor`] = 'bodyshell',
			[`valkyria`] = 'bodyshell',
			[`20xmax`] = 'bodyshell',
			[`gilrunner`] = 'bodyshell',
			[`zip`] = 'bodyshell',
			[`rucr2`] = 'bodyshell',
			[`RS6TDB`] = 'bodyshell',
			[`seasparrow`] = 'bodyshell',
			[`maverick`] = 'bodyshell',
			[`frogger`] = 'bodyshell',
			[`supervolito`] = 'bodyshell',
			[`supervolito2`] = 'bodyshell',
			[`volatus`] = 'bodyshell',
			[`swift`] = 'bodyshell',
			[`stunt`] = 'bodyshell',
			[`dodo`] = 'bodyshell',
			[`cuban800`] = 'bodyshell',
			[`velum`] = 'bodyshell',
			[`vestra`] = 'bodyshell',
			[`luxor`] = 'bodyshell',
			[`rebelr`] = 'misc_h',
			[`flatbed`] = 'els',
			[`flatbed2`] = 'els',
			[`anwboffroad`] = 'bodyshell',
			[`trailers3`] = 'boot',
			[`trailers2`] = 'boot',
			[`trailers4`] = 'boot',
			[`packer`] = 'bodyshell',
			[`phantom`] = 'bodyshell',
			[`u5023`] = 'bodyshell',
			[`mbbs20`] = 'misc_v',
			[`mot2022`] = 'bodyshell',
		}
	}
}
