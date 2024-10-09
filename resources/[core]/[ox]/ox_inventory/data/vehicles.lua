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
            [`vetir`] = {50, 150000},
            [`blazer`] = {50, 10000},
            [`bodhi2`] = {50, 100000},
            [`manchez2`] = {50, 10000},
            [`rancherxl`] = {50, 100000},
            [`seminole2`] = {50, 80000},
            [`gstyosemite1`] = {50, 40000},
            -- Renault
            [`cliors`] = {50, 35000},
            [`sportrs`] = {50, 25000},
            [`megrs18`] = {50, 40000},
            -- Nissan
            [`r35`] = {50, 25000},
            [`nisgtir`] = {50, 35000},
            [`silvia3`] = {50, 30000},
            [`skyline`] = {50, 35000},
            [`180sxrb`] = {50, 30000},
            [`gtr50`] = {50, 25000},
            [`titan17`] = {50, 120000},
            -- BMW
            [`rmodm5cs`] = {50, 45000},
            [`bmwm5touring`] = {50, 55000},
            [`rmodm4gts`] = {50, 45000},
            [`rmodm5e34`] = {50, 45000},
            [`rmodm3touring`] = {50, 55000},
            [`bmwg07`] = {50, 80000},
            [`m2f22`] = {50, 25000},
            [`m1000rr`] = {50, 5000},
            [`e46`] = {50, 25000},
            [`bmwm4`] = {50, 35000},
            [`ix21`] = {50, 65000},
            [`rmodm8c`] = {50, 40000},
            [`x5bmw`] = {50, 65000},
            [`m4cs18`] = {50, 45000},
            [`z4acs`] = {50, 25000},
            [`22m135imperf`] = {50, 40000},
            [`bmwm5e60`] = {50, 45000},
            [`mobm23`] = {50, 90000},
            [`x6mpd`] = {50, 75000},
            -- Volkswagen
            [`beetle74`] = {50, 35000},
            [`golf75r`] = {50, 35000},
            [`rmodmk7`] = {50, 350000},
            --Dodge
            [`16charger`] = {50, 45000},
            [`rmodcharger69`] = {50, 30000},
            [`texviper`] = {50, 25000},
            [`16challenger`] = {50, 30000},
            [`chr20`] = {50, 45000},
            [`ram2500lifted`] = {50, 145000},
            [`x3ramtrx21`] = {50, 155000},
			-- Ford
			[`f15078`] = {50, 70000},
			[`mgt`] = {50, 35000},
			[`raptor2017`] = {50, 150000},
			[`wildtrak`] = {50, 70000},
			[`rmodescort`] = {50, 25000},
			[`velociraptor`] = {50, 190000},
			[`21bro`] = {50, 65000},
			-- McLaren
			[`600lt`] = {50, 25000},
			-- Chevrolet
			[`rmodz06`] = {50, 25000},
			[`c8z0723`] = {50, 25000},
			-- Helikopters
			[`supervolito`] = {50, 25000},
			[`havok`] = {50, 25000},
			-- Mini Cooper
			[`mcjcw20`] = {50, 35000},
			[`cooperworks`] = {50, 35000},
			-- Audi
			[`2015a3`] = {50, 35000},
			[`a6`] = {50, 45000},
			[`r8spyder20`] = {50, 25000},
			[`rs52021`] = {50, 30000},
			[`rmodaudirs7`] = {50, 50000},
			[`q7`] = {50, 80000},
			[`15q7`] = {50, 80000},
			[`rmodrs6`] = {50, 55000},
			-- Cadillac
			[`ct5vbw22`] = {50, 45000},
			[`rmodctsv`] = {50, 45000},
			-- Porsche
			[`cayenneturbo`] = {50, 70000},
			[`panamera17turbo`] = {50, 55000},
			[`pgt322`] = {50, 25000},
			[`pts21`] = {50, 30000},
			[`22caygt`] = {50, 65000},
			[`ikx3cross22`] = {50, 55000},
			[`techart17`] = {50, 55000},
			[`rmodpanamera2`] = {50, 55000},
			[`718gt4rs`] = {50, 25000},
			[`rucr2`] = {50, 25000},
			-- Mercedes
			[`dubsta3`] = {50, 180000},
			[`e632014`] = {50, 45000},
			[`g65amg`] = {50, 75000},
			[`gle53`] = {50, 55000},
			[`rmodc63amg`] = {50, 40000},
			[`rmode63s`] = {50, 45000},
			[`rmodgt63`] = {50, 45000},
			[`s63amg`] = {50, 40000},
			[`w463a1`] = {50, 65000},
            [`ikx3dbx707`] = {50, 65000},
            [`rover22`] = {50, 55000},
            [`18velar`] = {50, 55000},
            [`rmodrover`] = {50, 55000},
            [`rangerover2`] = {50, 55000},
            [`formentertdb`] = {50, 75000},
            [`Boxtruck`] = {50, 200000},
            [`srt8h`] = {50, 65000},
            [`freeboghoulhawk`] = {50, 65000},
            [`jp12`] = {50, 65000},
            [`f15078`] = {50, 65000},
            [`raptor2017`] = {50, 65000},
            [`ikx3r1t22`] = {50, 95000},
            [`21durangowb`] = {50, 75000},
            [`rrtrx`] = {50, 100000},
            [`ikx3charger9`] = {50, 45000},
            [`ikx3ev22`] = {50, 85000},
            [`24humevof`] = {50, 65000},
            [`caph1`] = {50, 85000},
            [`x5xdriver`] = {50, 65000},
            [`cayennehybridcoupe`] = {50, 65000},
			[`a45amg`] = {50, 30000},
			[`c63wagon`] = {50, 55000},
			[`g632019`] = {50, 65000},
			[`gls63`] = {50, 45000},
			[`xclass`] = {50, 85000},
			[`amggts`] = {50, 25000},
			[`e63s`] = {50, 45000},
			-- RollsRoyce
			[`dawnonyx`] = {50, 35000},
			[`wald19`] = {50, 35000},
			-- Bentley
			[`rmodbentleygt`] = {50, 35000},
			[`contss18`] = {50, 35000},
			[`rmodbacalar`] = {50, 35000},
			-- Jeep
			[`gladiator`] = {50, 125000},
			[`jp12`] = {50, 80000},
			[`rmodjeep`] = {50, 80000},
			[`srt8`] = {50, 100000},
			-- Ferrari
			[`roma20`] = {50, 25000},
			[`gcmferraripurosangue`] = {50, 60000},
			-- Kawasaki
			[`kx450f`] = {50, 5000},
			[`zx10`] = {50, 5000},
			[`zx10r`] = {50, 5000},
			-- KTM
			[`exc530sm`] = {50, 5000},
			[`excf250`] = {50, 5000},
			[`ksd`] = {50, 5000},
			-- Maibatsu
			[`mule3`] = {50, 350000},
			-- GTA
			[`kamacho`] = {50, 125000},
			[`rebelr`] = {50, 80000},
			[`r500`] = {50, 15000},
			[`xpeng`] = {50, 30000},
			-- Volvo
			[`xc9014`] = {50, 90000},
			-- Honda
			[`civic96`] = {50, 35000},
			[`ikx3vtec94`] = {50, 30000},
			[`africat`] = {50, 5000},
			[`fk8`] = {50, 40000},
			-- Mitsubishi
			[`cp9a`] = {50, 35000},
			[`bmeclipse95`] = {50, 25000},
			-- Toyota
			[`a80`] = {50, 30000},
			[`toy86`] = {50, 25000},
			[`cam8tun`] = {50, 40000},
			[`ae86`] = {50, 30000},
			[`landc`] = {50, 65000},
			[`mot2022`] = {50, 100000},
			[`4runn`] = {50, 75000},
			[`lcruise`] = {50, 75000},
			[`rmodsuprapandem`] = {50, 25000},
			-- RangeRover
			[`rangerover2`] = {50, 70000},
			[`rmodrover`] = {50, 70000},
			[`rrst`] = {50, 70000},
			[`rsvr16`] = {50, 70000},
			[`mansrr`] = {50, 70000},
			-- Lexus
			[`rmodlfa`] = {50, 25000},
			[`lx470`] = {50, 70000},
			-- AlfaRomeo
			[`gtam21`] = {50, 45000},
			[`4c`] = {50, 20000},
			[`stelvio`] = {50, 65000},
			[`gxgiulia`] = {50, 45000},
			[`giuliasbgta`] = {50, 55000},
			-- AstonMartin
			[`vantage`] = {50, 25000},
			[`dbx`] = {50, 60000},
			-- Lamborghini
			[`hura`] = {50, 25000},
			[`hurevohard`] = {50, 25000},
			[`urus`] = {50, 70000},
			-- Jaguar
			[`fpacehm`] = {50, 65000},
			-- Motoren
			[`daemon3`] = {50, 5000},
			[`daemon4`] = {50, 5000},
			[`dragoon`] = {50, 5000},
			[`foxharley1`] = {50, 5000},
			[`motor1`] = {50, 5000},
			[`motor3`] = {50, 5000},
			[`motor5`] = {50, 5000},
			[`oscurecer`] = {50, 5000},
			[`sonsmotor`] = {50, 5000},
            [`boxtruck`] = {50, 35000},
            [`urusperf`] = {50, 65000},
			[`valkyria`] = {50, 5000},
			-- Scooters
			[`20xmax`] = {50, 5000},
			[`gilrunner`] = {50, 5000},
			[`zip`] = {50, 5000},
			-- Tesla
			[`teslax`] = {50, 70000},
			-- Boten
			[`dinghy4`] = {44, 55000},
			[`squalo`] = {44, 40000},
			[`speeder`] = {44, 100000},
			[`seashark`] = {44, 10000},
			[`longfin`] = {50, 220000},
            -- Politie
            [`pvoacrafter`] = {50, 150000},
            [`logvolvo`] = {50, 500000},
			[`flatbed2`] = {50, 80000},
			--ANWB
			[`flatbed`] = {50, 80000},
			[`anwboffroad`] = {50, 60000},
            -- Eiland
            [`gstyosemite1`] = {50, 60000},
            -- GTAV (ingespawned)
            [`stockade`] = {50, 500000},
            [`rumpo3`] = {50, 120000},
            [`terbyte`] = {50, 500000},
			[`q60pbs`] = {50, 30000},
			[`rs322sedancarbont`] = {50, 40000},
			[`RS6TDB`] = {50, 50000},
			[`e30s`] = {50, 25000},
			[`escaladesport`] = {50, 75000},
			[`dc5`] = {50, 25000},
			[`lhuracant`] = {50, 15000},
			[`is300`] = {50, 25000},
			[`mazfd`] = {50, 25000},
			[`na6`] = {50, 25000},
			[`s63amg18`] = {50, 25000},
			[`ikx3gtr20`] = {50, 25000},
			[`nis15`] = {50, 25000},
			[`nis180`] = {50, 25000},
			[`930t`] = {50, 25000},
			[`subwrxtdb`] = {50, 25000},
			[`a70`] = {50, 25000},
			[`jzx100`] = {50, 25000},
			[`remus8r`] = {50, 30000},
			[`rcwagon`] = {50, 25000},
			[`86montelow`] = {50, 25000},
			[`GODz10VICLOW`] = {50, 25000},
			[`hycgt500`] = {50, 25000},
			[`amrevu23mg`] = {50, 15000},
			[`amghr`] = {50, 25000},
			[`evo10`] = {50, 25000},
			[`GODzR36CONCEPT`] = {50, 25000},
			[`r33ptnc`] = {50, 25000},
			[`rrsupramk3`] = {50, 25000},
			[`golf91wideprzemo`] = {50, 25000},
			[`seasparrow`] = {50, 80000},
			[`maverick`] = {50, 250000},
			[`frogger`] = {50, 250000},
			[`supervolito`] = {50, 450000},
			[`supervolito2`] = {50, 500000},
			[`volatus`] = {50, 15000},
			[`swift`] = {50, 350000},
			[`stunt`] = {50, 25000},
			[`dodo`] = {50, 200000},
			[`cuban800`] = {50, 250000},
			[`velum`] = {50, 350000},
			[`vestra`] = {50, 380000},
			[`luxor`] = {50, 10000},
			[`rs422`] = {50, 65000},
			[`m3f80`] = {50, 50000},
			[`x5mc`] = {50, 65000},
			[`z3m`] = {50, 35000},
			[`hellephantdurango`] = {50, 85000},
			[`GC_22transMoney`] = {50, 180000},
			[`GC_22transCIV`] = {50, 180000},
			[`ugcdrugtruck`] = {50, 380000},
			[`sprinter211`] = {11, 200000},
			[`u5023`] = {50, 320000},
			[`packer`] = {50, 100000},
			[`phantom`] = {50, 100000},
			[`exor`] = {50, 20000},
			-- Trailers
			[`trailers3`] = {50, 800000},
			[`812nlargo`] = {50, 25000},
			[`720nlargo`] = {50, 25000},
			[`mbbs20`] = {50, 25000},
			[`rmodrs6r`] = {50, 55000},
			[`f288gto`] = {50, 25000},
			[`glemansory`] = {50, 50000},
			[`urus1016`] = {50, 50000},
			[`cullinan`] = {50, 50000},
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
