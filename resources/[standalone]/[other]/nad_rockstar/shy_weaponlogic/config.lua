Config = {}

Config.Recoil = {
-- [PISTOLS]
	-- POL/DSI/KMAR
	[`WEAPON_COMBATPISTOL`] = {
		factor = 0.45,
		shake = 0.01,
	},

	-- CRIMINALS
	[`WEAPON_SNSPISTOL`] = {
		factor = 0.75,
		shake = 0.02,
	},
	[`WEAPON_FM1_M9A3`] = {
		factor = 0.65,
		shake = 0.01,
	},
	[`WEAPON_PISTOL50`] = {
		factor = 1.25,
		shake = 0.01,
	},
	[`WEAPON_SIG`] = {
		factor = 0.30,
		shake = 0.01,
	},

-- [SMG'S]
	-- KMAR/BOT
	[`WEAPON_SMG`] = {
		factor = 0.50,
		shake = 0.01,
	},

	-- CRIMINALS
	[`WEAPON_HKUMP`] = {
		factor = 0.20,
		shake = 0.01,
	},
	[`WEAPON_MINIUZI`] = {
		factor = 5.00,
		shake = 0.025,
	},
	[`WEAPON_MINISMG`] = {
		factor = 0.31,
		shake = 0.015,
	},


-- [SHOTGUNS]
	-- DSI
	[`WEAPON_PUMPSHOTGUN_MK2`] = {
		factor = 0.80,
		shake = 0.08,
	},

	-- CRIMINALS
	[`WEAPON_SAWNOFFSHOTGUN`] = {
		factor = 0.80,
		shake = 0.04,
	},
	[`WEAPON_DOUBLEBARRELFM`] = {
		factor = 1.0,
		shake = 0.08,
	},
	[`WEAPON_BENELLIM4`] = {
		factor = 0.60,
		shake = 0.05,
	},

-- [RIFLES]
	-- DSI
	[`WEAPON_FM1_HK416`] = {
		factor = 0.10,
		shake = 0.02,
	},
	[`WEAPON_FM2_HK416`] = {
		factor = 0.20,
		shake = 0.01,
	},
	[`WEAPON_MCXSPEAR`] = {
		factor = 2.00,
		shake = 0.05,
	},
	[`WEAPON_MCXRATTLER`] = {
		factor = 0.25,
		shake = 0.03,
	},

	-- CRIMINALS
	[`WEAPON_AK74_1`] = {
		factor = 0.15,
		shake = 0.04,
	},
	[`WEAPON_NVRIFLE`] = {
		factor = 0.00,
		shake = 0.01,
	},
	[`WEAPON_AKS74U`] = {
		factor = 0.05,
		shake = 0.04,
	}
}
	
Config.DamageModifiers = {
	[`WEAPON_UNARMED`] = 0.4,
	
	-- Politie
	[`WEAPON_FLASHLIGHT`] = 0.0,
	[`WEAPON_NIGHTSTICK`] = 0.05,
	[`WEAPON_PISTOL`] = 1.0,
	[`WEAPON_GLOCK`] = 1.5,
	[`WEAPON_GLOCKKMAR`] = 1.2,

	-- Melee
	[`WEAPON_DAGGER`] = 0.75,
	[`WEAPON_BAT`] = 0.65,
	[`WEAPON_BOTTLE`] = 0.75,
	[`WEAPON_CROWBAR`] = 0.65,
	[`WEAPON_GOLFCLUB`] = 0.65,
	[`WEAPON_HAMMER`] = 0.65,
	[`WEAPON_HATCHET`] = 0.75,
	[`WEAPON_KNIFE`] = 0.75,
	[`WEAPON_MACHETE`] = 0.90,
	[`WEAPON_SWITCHBLADE`] = 0.75,
	[`WEAPON_BATTLEAXE`] = 0.75,
	[`WEAPON_POOLCUE`] = 0.65,
	[`WEAPON_STONE_HATCHET`] = 0.5,
	[`WEAPON_NAILBAT`] = 0.60,
	[`WEAPON_WRENCHKNIFE`] = 0.60,
	[`WEAPON_SIGNAXE`] = 0.75,
	[`WEAPON_CANMACE`] = 0.75,
	[`WEAPON_APOSWORD`] = 0.90,
	[`WEAPON_APOMACE`] = 0.90,
	[`WEAPON_CHAINKNIFE`] = 0.75,
	[`WEAPON_HANDMADEAXE`] = 0.75,
	[`WEAPON_TUBEAXE`] = 0.80,
	[`WEAPON_TUBEPICKAXE`] = 0.75,
	[`WEAPON_APOKATANA`] = 1.1,
	[`WEAPON_BATTLEAXE`] = 0.80,
	[`WEAPON_BATSPIKE`] = 0.60 ,
	[`WEAPON_KARAMBIT`] = 0.75,
	[`WEAPON_BATMETAL`] = 0.75,
	[`WEAPON_AXE`] = 0.60,
	[`WEAPON_BAYONET`] = 0.75,
	[`WEAPON_BOTTLEIRNBRU`] = 0.60,			
	[`WEAPON_BUTTERFLYKNIFE`] = 0.75,
	[`WEAPON_CRUTCH`] = 0.60,
	[`WEAPON_FIREAXE`] = 0.60,
	[`WEAPON_GUITAR`] = 0.60,
	[`WEAPON_TUBE`] = 0.15,
	[`WEAPON_WRENCH`] = 0.15,
	[`WEAPON_SCREWDRIVER`] = 0.15,
	[`WEAPON_SHOVEL`] = 0.35,

	-- Guns
	[`WEAPON_FM1_M9A3`] = 1.5,
	[`WEAPON_MICROSMG`] = 1.5,
	[`WEAPON_ASSAULTRIFLE_MK2`] = 1.3,
	[`WEAPON_MINIUZI`] = 0.7,
	[`WEAPON_38SNUBNOSE`] = 1.0,
	[`WEAPON_38SNUBNOSE2`] = 1.0,
	[`WEAPON_38SNUBNOSE3`] = 1.0,
	[`WEAPON_38SPECIAL`] = 1.0,
	[`WEAPON_44MAGNUM`] = 1.0,
	[`WEAPON_SIG`] = 1.5,
	[`WEAPON_FM1_HK416`] = 1.3,
	[`WEAPON_SAWNOFFSHOTGUN`] = 1.5,

	-- Throwables
	[`WEAPON_SHURIKEN`] = 50.0,

	-- AntiVDM
	[-1553120962] = 0.0
}