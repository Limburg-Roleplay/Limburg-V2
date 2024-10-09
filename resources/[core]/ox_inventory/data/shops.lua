return {
	General = {
		name = 'Supermarkt',
		blip = {
			id = 52, colour = 0, scale = 0.8
		}, inventory = {
			{ name = 'bread', price = 4 },
			{ name = 'pizza', price = 7 },
			{ name = 'burger', price = 11 },
			{ name = 'burger_chicken', price = 10 },
			{ name = 'chips', price = 4 },
			{ name = 'donut', price = 2 },
			{ name = 'fries', price = 9 },

			{ name = 'water', price = 6 },
			{ name = 'sinas', price = 8 },
			{ name = 'sprunk', price = 8 },
			{ name = 'cola', price = 8 },
			{ name = 'chocomel', price = 12 },
			{ name = 'energy', price = 3 },
			{ name = 'optimel', price = 5 },
			{ name = 'repairkit', price = 1500},
		}, locations = {
			vec3(26.45, -1347.72, 29.49),
			vec3(-3038.98, 586.72, 7.90),
			vec3(-3241.47, 1002.12, 12.830),
			vec3(1729.57, 6413.92, 35.037),
			vec3(1697.99, 4924.4, 42.06),
			vec3(1962.13, 3740.65, 32.34),
			vec3(546.90, 2671.61, 42.15),
			vec3(2679.46, 3281.00, 55.241),
			vec3(2558.00, 382.96, 108.62),
			vec3(374.55, 325.36, 103.56),
			vec3(1135.808, -982.281, 46.415),
			vec3(-1222.915, -906.983, 12.326),
			vec3(-1487.553, -379.107, 40.163),
			vec3(-2968.243, 390.910, 15.043),
			vec3(1166.024, 2708.930, 38.157),
			vec3(1392.562, 3604.684, 34.980),
			vec3(-1393.409, -606.624, 30.319),
			vec3(-48.75, -1757.93, 29.4210),
			vec3(-707.92, -914.57, 19.21),
			vec3(1163.19, -323.98, 69.20),
			vec3(-1820.72, 792.32, 138.11),
			vec3(161.8304, 6639.7686, 31.6989),
		}
	},

	Ammunation2 = {
		name = 'Telefoonwinkel',
		blip = {
			id = 424, colour = 0, scale = 0.8
		},
		inventory = {
			{ name = 'phone', price = 750},
			{ name = 'radio', price = 500},
		}, locations = {
			vec3(-657.0804, -857.6953, 24.5031)
		}
	},

	overvalshop = {
		name = 'Overval Winkel',
		blip = {
			id = 134, colour = 0, scale = 0.75
		},
		inventory = {
			{ name = 'hacking_device', price = 15000},
            { name = 'thermiet', price = 25000},
            { name = 'drill', price = 25000},
            { name = 'lockpick', price = 5000},
            { name = 'blowpipe', price = 25000},

		}, locations = {
			vec3(2747.3264, 3472.9827, 55.6703)
		}
	},

    politiekluis = {
        name = 'Politie | Uitrusting Kluis',
        inventory = {
			{ name = 'WEAPON_COMBATPISTOL', price = 500, metadata = { registered = true, serial = 'Politie' }, },
            { name = 'WEAPON_STUNGUN', price = 25, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'WEAPON_NIGHTSTICK', price = 25, metadata = { registered = true, serial = 'Politie' }, },
            { name = 'ammo-pistol-overheid', price = 5, metadata = { registered = false }, },
            { name = 'medkit', price = 250, metadata = { registered = false }, },
			{ name = 'handcuffs', price = 50, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'radio', price = 50, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'phone', price = 75, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'repairkit', price = 150, metadata = { registered = true, serial = 'Politie' }, },
        },
		groups = {
			police = 0
		},
    },

    dsikluis = {
        name = 'DSI | Wapen inkoop',
        inventory = {
            { name = 'WEAPON_PISTOL', price = 125, metadata = { registered = true, serial = 'Politie' }, },
            { name = 'WEAPON_GLOCK17', price = 125, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'WEAPON_SMG', price = 250, metadata = { registered = true, serial = 'Politie' }, },
            { name = 'WEAPON_MCXRATTLER', price = 350, metadata = { registered = true, serial = 'Politie' }, },
            { name = 'WEAPON_FM2_HK416', price = 350, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'WEAPON_FM1_HK416', price = 350, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'WEAPON_REMINGTON', price = 500, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'at_clip_extended_pistol', price = 50, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'at_clip_extended_smg', price = 50, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'at_scope_macro', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_clip_02', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_clip_05', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_clip_08', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_clip_10', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_stock_24', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_stock_09', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_stock_29', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_stock_20', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_sup_20', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_sup_23', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_sup_18', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_sup_04', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_grip_09', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_grip_03', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_flash_08', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_scope_38', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_scope_23', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_scope_18', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_scope_17', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_scope_15', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_scope_13', price = 50, metadata = { registered = true, serial = 'Politie' }, },
                        { name = 'at_fm_scope_01', price = 50, metadata = { registered = true, serial = 'Politie' }, },

			{ name = 'at_suppressor_light', price = 50, metadata = { registered = true, serial = 'Politie' }, },
            { name = 'ammo-pistol-overheid', price = 15, metadata = { registered = false }, },
            { name = 'ammo-smg-overheid', price = 30, metadata = { registered = false }, },
            { name = 'ammo-shotgun-overheid', price = 30, metadata = { registered = false }, },
            { name = 'ammo-rifle-overheid', price = 20, metadata = { registered = false }, },
			{ name = 'dsischild', price = 1000, metadata = { registered = true, serial = 'Politie' }, },
			{ name = 'repairkit', price = 1500, metadata = { registered = true, serial = 'Politie' }, },
        },
		groups = {
			police = 4,
		},
    },

    bsbkluis = {
        name = 'BSB | Wapen inkoop',
        inventory = {
            { name = 'WEAPON_GLOCK17', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_MP5', price = 250, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_MCXRATTLER', price = 350, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_FM2_HK416', price = 350, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_FM1_HK416', price = 350, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_REMINGTON', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'w_at_mp5_supp', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'w_at_mp5_scope', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'at_clip_extended_pistol', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'at_clip_extended_smg', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_clip_02', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_clip_05', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_clip_08', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_clip_10', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_stock_24', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_stock_09', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_stock_29', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_stock_20', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_sup_20', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_sup_23', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_sup_18', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_sup_04', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_grip_09', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_grip_03', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_flash_08', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_scope_38', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_scope_23', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_scope_18', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_scope_17', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_scope_15', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_scope_13', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
                        { name = 'at_fm_scope_01', price = 50, metadata = { registered = true, serial = 'Kmar' }, },

			{ name = 'at_suppressor_light', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'ammo-pistol-overheid', price = 15, metadata = { registered = false }, },
            { name = 'ammo-smg-overheid', price = 30, metadata = { registered = false }, },
            { name = 'ammo-shotgun-overheid', price = 30, metadata = { registered = false }, },
            { name = 'ammo-rifle-overheid', price = 20, metadata = { registered = false }, },
			{ name = 'dsischild', price = 1000, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'repairkit', price = 1500, metadata = { registered = true, serial = 'Kmar' }, },
        },
		groups = {
			kmar = 7,
		},
    },
 
    lv2kluis = {
        name = 'LV2 | Uitrusting Kluis',
        inventory = {
            { name = 'WEAPON_GLOCK17', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_STUNGUN', price = 25, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'WEAPON_NIGHTSTICK', price = 25, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_MP5', price = 250, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'w_at_mp5_supp', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'w_at_mp5_scope', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'ammo-pistol-overheid', price = 5, metadata = { registered = false }, },
            { name = 'ammo-smg-overheid', price = 30, metadata = { registered = false }, },
			{ name = 'handcuffs', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'medkit', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'radio', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'phone', price = 75, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'repairkit', price = 150, metadata = { registered = true, serial = 'Kmar' }, },
        },
		groups = {
			kmar = 4
		},
    },

    kmarkluis = {
        name = 'KMAR | Uitrusting Kluis',
        inventory = {
			{ name = 'WEAPON_GLOCK17', price = 500, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'WEAPON_STUNGUN', price = 25, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'WEAPON_NIGHTSTICK', price = 25, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'ammo-pistol-overheid', price = 5, metadata = { registered = false }, },
			{ name = 'handcuffs', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
            { name = 'medkit', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'radio', price = 50, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'phone', price = 75, metadata = { registered = true, serial = 'Kmar' }, },
			{ name = 'repairkit', price = 150, metadata = { registered = true, serial = 'Kmar' }, },
        },
		groups = {
			kmar = 0
		},
    },

    gangshop = {
        name = 'Gang Level 1: Inkoop Wapens',
        inventory = {

                                 -- PISTOLS --            
            { name = 'WEAPON_PISTOL50', price = 400000, metadata = { registered = true }, }, 
            { name = 'WEAPON_FM1_M9A3', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_SIG', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_GLOCK19X', price = 360000, metadata = { registered = true }, },
            { name = 'WEAPON_SNSPISTOL', price = 300000, metadata = { registered = true }, },

                                 -- MESSEN --                         
			{ name = 'WEAPON_SwitchBlade', price = 50000 },
			{ name = 'WEAPON_BAT', price = 35000 },
			{ name = 'WEAPON_KNIFE', price = 35000 },
			{ name = 'WEAPON_MACHETE', price = 30000 },
        }
	},

    gangshopammo = {
        name = 'Gang Level 1: Ammo Inkoop',
        inventory = {
                                 -- Ammo -- 
			{ name = 'ammo-pistol', price = 100, },

        }
	},

    extra = {
        name = 'Gang: Extra Inkoop',
        inventory = {
            { name = 'phone', price = 750, metadata = { registered = false }, },
            { name = 'radio', price = 500, metadata = { registered = false }, },
            { name = 'tiewraps', price = 1250, metadata = { registered = false }, },

        }
	},

    gangshopsuppressors = {
        name = 'Gang: Suppressor Inkoop',
        inventory = {

			{ name = 'at_suppressor_light', price = 25000, },
			{ name = 'at_fm_sup_10', price = 25000, },
			{ name = 'sigsupp', price = 25000, },
        }
	},

    gangshopscopes = {
        name = 'Gang: Scopes Inkoop',
        inventory = {

			{ name = 'at_fm_scope_30', price = 25000, },
			{ name = 'sigscope2', price = 25000, },

        }
	},

    gangshopmagazines = {
        name = 'Gang: Magazines Inkoop',
        inventory = {

			{ name = 'at_m9a3_clip_02', price = 25000, },
			{ name = 'at_clip_extended_pistol', price = 25000, },
			{ name = 'sigmag2', price = 25000, },

        }
	},

    gangshop2 = {
        name = 'Gang Level 2: Inkoop Wapens',
        inventory = {
                                 -- SMGS --    
            { name = 'WEAPON_MINISMG', price = 575000, metadata = { registered = true }, },

                                 -- PISTOLS --            
            { name = 'WEAPON_PISTOL50', price = 400000, metadata = { registered = true }, }, 
            { name = 'WEAPON_FM1_M9A3', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_SNSPISTOL', price = 300000, metadata = { registered = true }, },
            { name = 'WEAPON_GLOCK19X', price = 360000, metadata = { registered = true }, },
            { name = 'WEAPON_SIG', price = 350000, metadata = { registered = true }, },

                                 -- MESSEN --                         
			{ name = 'WEAPON_SwitchBlade', price = 50000 },
			{ name = 'WEAPON_BAT', price = 35000 },
			{ name = 'WEAPON_KNIFE', price = 35000 },
			{ name = 'WEAPON_MACHETE', price = 30000 },
        }
	},

    gangshopammo2 = {
        name = 'Gang Level 2: Ammo Inkoop',
        inventory = {
                                 -- Ammo -- 
			{ name = 'ammo-pistol', price = 100, },
            { name = 'ammo-smg', price = 150, },

        }
	},

    extra2 = {
        name = 'Gang Level 2: Extra Inkoop',
        inventory = {
            { name = 'phone', price = 750, metadata = { registered = false }, },
            { name = 'radio', price = 500, metadata = { registered = false }, },
            { name = 'tiewraps', price = 1250, metadata = { registered = false }, },

        }
	},

    gangshopsuppressors2 = {
        name = 'Gang: Suppressor Inkoop',
        inventory = {

			{ name = 'at_suppressor_light', price = 25000, },
			{ name = 'at_fm_sup_10', price = 25000, },
			{ name = 'sigsupp', price = 25000, },

        }
	},

    gangshopscopes2 = {
        name = 'Gang: Scopes Inkoop',
        inventory = {

			{ name = 'at_fm_scope_30', price = 25000, },
			{ name = 'sigscope2', price = 25000, },

        }
	},

    gangshopmagazines2 = {
        name = 'Gang: Magazines Inkoop',
        inventory = {

			{ name = 'at_m9a3_clip_02', price = 25000, },
			{ name = 'at_clip_extended_pistol', price = 25000, },
			{ name = 'sigmag2', price = 25000, },
			{ name = 'at_clip_extended_smg', price = 25000, },

        }
	},

    gangshop3 = {
        name = 'Gang Level 3: Inkoop Wapens',
        inventory = {

                                 -- SMGS --    
            { name = 'WEAPON_MINIUZI', price = 650000, metadata = { registered = true }, },
            { name = 'WEAPON_MINISMG', price = 575000, metadata = { registered = true }, },

            { name = 'WEAPON_SAWNOFFSHOTGUN', price = 425000, metadata = { registered = true }, },  

                                 -- PISTOLS --            
            { name = 'WEAPON_PISTOL50', price = 400000, metadata = { registered = true }, }, 
            { name = 'WEAPON_FM1_M9A3', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_SNSPISTOL', price = 300000, metadata = { registered = true }, },
            { name = 'WEAPON_SIG', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_GLOCK19X', price = 360000, metadata = { registered = true }, },


                                 -- MESSEN --                         
			{ name = 'WEAPON_SwitchBlade', price = 50000 },
			{ name = 'WEAPON_BAT', price = 35000 },
			{ name = 'WEAPON_KNIFE', price = 35000 },
			{ name = 'WEAPON_MACHETE', price = 30000 },
        }
	},

    gangshopammo3 = {
        name = 'Gang Level 3: Ammo Inkoop',
        inventory = {
                                 -- Ammo -- 
			{ name = 'ammo-pistol', price = 100, },
            { name = 'ammo-smg', price = 150, },
            { name = 'ammo-shotgun', price = 250, },

        }
	},

    extra3 = {
        name = 'Gang Level 3: Extra Inkoop',
        inventory = {
            { name = 'phone', price = 750, metadata = { registered = false }, },
            { name = 'radio', price = 500, metadata = { registered = false }, },
            { name = 'tiewraps', price = 1250, metadata = { registered = false }, },

        }
	},

    gangshopsuppressors3 = {
        name = 'Gang: Suppressor Inkoop',
        inventory = {

			{ name = 'at_suppressor_light', price = 25000, },
			{ name = 'at_fm_sup_10', price = 25000, },
			{ name = 'sigsupp', price = 25000, },
			{ name = 'at_uzi_supp2', price = 25000, },

        }
	},

    gangshopscopes3 = {
        name = 'Gang: Scopes Inkoop',
        inventory = {

			{ name = 'at_fm_scope_30', price = 25000, },
			{ name = 'sigscope2', price = 25000, },
			{ name = 'at_uzi_scope6', price = 25000, },

        }
	},

    gangshopgrips3 = {
        name = 'Gang: Grips Inkoop',
        inventory = {

			{ name = 'at_grip', price = 50000, },
			{ name = 'at_uzi_stock2', price = 50000, },

        }
	},


    gangshopmagazines3 = {
        name = 'Gang: Magazines Inkoop',
        inventory = {

			{ name = 'at_m9a3_clip_02', price = 25000, },
			{ name = 'at_clip_extended_pistol', price = 25000, },
			{ name = 'sigmag2', price = 25000, },
			{ name = 'at_clip_extended_smg', price = 25000, },
			{ name = 'at_uzi_clip4', price = 25000, },

        }
	},

    gangshop4 = {
        name = 'Gang Level 4: Inkoop Wapens',
        inventory = {
  
            { name = 'WEAPON_AKS74U', price = 975000, metadata = { registered = true }, },

                                 -- SMGS --  
            { name = 'WEAPON_HKUMP', price = 700000, metadata = { registered = true }, }, 
            { name = 'WEAPON_MINISMG', price = 575000, metadata = { registered = true }, },

            { name = 'WEAPON_SAWNOFFSHOTGUN', price = 425000, metadata = { registered = true }, },  

                                 -- PISTOLS --            
            { name = 'WEAPON_PISTOL50', price = 400000, metadata = { registered = true }, }, 
            { name = 'WEAPON_FM1_M9A3', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_SNSPISTOL', price = 300000, metadata = { registered = true }, },
            { name = 'WEAPON_SIG', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_GLOCK19X', price = 360000, metadata = { registered = true }, },


                                 -- MESSEN --                         
			{ name = 'WEAPON_SwitchBlade', price = 50000 },
			{ name = 'WEAPON_BAT', price = 35000 },
			{ name = 'WEAPON_KNIFE', price = 35000 },
			{ name = 'WEAPON_MACHETE', price = 30000 },
        }
	},

    gangshopammo4 = {
        name = 'Gang Level 4: Ammo Inkoop',
        inventory = {
                                 -- Ammo -- 
			{ name = 'ammo-pistol', price = 100, },
            { name = 'ammo-smg', price = 150, },
            { name = 'ammo-shotgun', price = 250, },
            { name = 'ammo-rifle', price = 450, },

        }
	},

    extra4 = {
        name = 'Gang Level 4: Extra Inkoop',
        inventory = {
            { name = 'phone', price = 750, metadata = { registered = false }, },
            { name = 'radio', price = 500, metadata = { registered = false }, },
            { name = 'tiewraps', price = 1250, metadata = { registered = false }, },

        }
	},

    gangshopsuppressors4 = {
        name = 'Gang: Suppressor Inkoop',
        inventory = {

			{ name = 'at_suppressor_light', price = 50000, },
			{ name = 'at_fm_sup_10', price = 50000, },
			{ name = 'markomods-shared-supp12', price = 50000, },
			{ name = 'ak74_muz_07', price = 50000, },
			{ name = 'at_uzi_supp2', price = 50000, },

        }
	},

    gangshopscopes4 = {
        name = 'Gang: Scopes Inkoop',
        inventory = {

			{ name = 'at_scope_macro', price = 50000, },
			{ name = 'at_fm_scope_30', price = 50000, },
			{ name = 'markomods-shared-scope1', price = 50000, },
			{ name = 'markomods-shared-scope8', price = 50000, },
			{ name = 'ak74_scope_02', price = 50000, },
			{ name = 'ak74_scope_04', price = 50000, },
			{ name = 'ak74_scope_05', price = 50000, },
			{ name = 'ak74_scope_07', price = 50000, },
			{ name = 'ak74_scope_08', price = 50000, },
			{ name = 'at_uzi_scope6', price = 50000, },

        }
	},

    gangshopmagazines4 = {
        name = 'Gang: Magazines Inkoop',
        inventory = {

			{ name = 'at_m9a3_clip_02', price = 25000, },
			{ name = 'at_clip_extended_pistol', price = 25000, },
			{ name = 'at_clip_extended_smg', price = 25000, },
			{ name = 'at_clip_extended_rifle', price = 50000, },
			{ name = 'at_clip_drum_rifle', price = 75000, },
			{ name = 'ak74_mag_09', price = 50000, },
			{ name = 'at_uzi_clip4', price = 50000, },

        }
	},

    gangshopoverig4 = {
        name = 'Gang: Overig Inkoop',
        inventory = {

			{ name = 'at_uzi_stock2', price = 50000, },

        }
	},

    gangshop5 = {
        name = 'Gang Level 5: Inkoop Wapens',
        inventory = {

            { name = 'WEAPON_AK74_1', price = 1200000, metadata = { registered = true }, },  
            { name = 'WEAPON_AKS74U', price = 975000, metadata = { registered = true }, },

                                 -- SMGS --  
            { name = 'WEAPON_HKUMP', price = 700000, metadata = { registered = true }, }, 
            { name = 'WEAPON_AGC', price = 750000, metadata = { registered = true }, }, 
            { name = 'WEAPON_MINISMG', price = 575000, metadata = { registered = true }, },

            { name = 'WEAPON_SAWNOFFSHOTGUN', price = 425000, metadata = { registered = true }, },  

                                 -- PISTOLS --            
            { name = 'WEAPON_PISTOL50', price = 400000, metadata = { registered = true }, }, 
            { name = 'WEAPON_FM1_M9A3', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_SNSPISTOL', price = 300000, metadata = { registered = true }, },
            { name = 'WEAPON_SIG', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_GLOCK19X', price = 360000, metadata = { registered = true }, },


                                 -- MESSEN --                         
			{ name = 'WEAPON_SwitchBlade', price = 50000 },
			{ name = 'WEAPON_BAT', price = 35000 },
			{ name = 'WEAPON_KNIFE', price = 35000 },
			{ name = 'WEAPON_MACHETE', price = 30000 },
        }
	},

    gangshopammo5 = {
        name = 'Gang Level 5: Ammo Inkoop',
        inventory = {
                                 -- Ammo -- 
			{ name = 'ammo-pistol', price = 220, },
            { name = 'ammo-smg', price = 280, },
            { name = 'ammo-shotgun', price = 290, },
            { name = 'ammo-rifle', price = 550, },

        }
	},

    extra5 = {
        name = 'Gang Level 5: Extra Inkoop',
        inventory = {
            { name = 'phone', price = 750, metadata = { registered = false }, },
            { name = 'radio', price = 500, metadata = { registered = false }, },
            { name = 'tiewraps', price = 1250, metadata = { registered = false }, },

        }
	},

    gangshopsuppressors5 = {
        name = 'Gang: Suppressor Inkoop',
        inventory = {

			{ name = 'at_suppressor_light', price = 50000, },
			{ name = 'at_suppressor_heavy', price = 50000, },
			{ name = 'at_fm_sup_10', price = 50000, },
			{ name = 'markomods-shared-supp12', price = 50000, },
			{ name = 'ak74_muz_07', price = 50000, },

        }
	},

    gangshopscopes5 = {
        name = 'Gang: Scopes Inkoop',
        inventory = {

			{ name = 'at_scope_macro', price = 50000, },
			{ name = 'at_fm_scope_30', price = 50000, },
			{ name = 'markomods-shared-scope1', price = 50000, },
			{ name = 'markomods-shared-scope8', price = 50000, },
			{ name = 'ak74_scope_02', price = 50000, },
			{ name = 'ak74_scope_04', price = 50000, },
			{ name = 'ak74_scope_05', price = 50000, },
			{ name = 'ak74_scope_07', price = 50000, },
			{ name = 'ak74_scope_08', price = 50000, },
			{ name = 'at_uzi_scope6', price = 50000, },
			{ name = 'at_uzi_supp2', price = 50000, },

        }
	},

    gangshopgrips5 = {
        name = 'Gang: Grips Inkoop',
        inventory = {

			{ name = 'at_grip', price = 50000, },

        }
	},

    gangshopmagazines5 = {
        name = 'Gang: Magazines Inkoop',
        inventory = {

			{ name = 'at_m9a3_clip_02', price = 50000, },
			{ name = 'at_clip_extended_pistol', price = 50000, },
			{ name = 'at_clip_extended_smg', price = 50000, },
			{ name = 'at_clip_extended_rifle', price = 50000, },
			{ name = 'at_clip_drum_rifle', price = 75000, },
			{ name = 'ak74_mag_09', price = 75000, },

        }
	},


    vipwapen = {
        name = 'VIP: Wapens',
        inventory = {

            { name = 'WEAPON_NVRIFLE', price = 1800000, metadata = { registered = true }, },
            { name = 'WEAPON_BENELLIM4', price = 1600000, metadata = { registered = true }, },  
            { name = 'WEAPON_AK74_1', price = 1600000, metadata = { registered = true }, },  
            { name = 'WEAPON_AKS74U', price = 1200000, metadata = { registered = true }, },


                                 -- SMGS --  
            { name = 'WEAPON_HKUMP', price = 750000, metadata = { registered = true }, },
            { name = 'WEAPON_AGC', price = 750000, metadata = { registered = true }, },
            { name = 'WEAPON_MINIUZI', price = 700000, metadata = { registered = true }, },
            { name = 'WEAPON_MINISMG', price = 675000, metadata = { registered = true }, },


            { name = 'WEAPON_SAWNOFFSHOTGUN', price = 400000, metadata = { registered = true }, },
  

                                 -- PISTOLS --            
            { name = 'WEAPON_PISTOL50', price = 400000, metadata = { registered = true }, }, 
            { name = 'WEAPON_FM1_M9A3', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_SIG', price = 350000, metadata = { registered = true }, },
            { name = 'WEAPON_SNSPISTOL', price = 300000, metadata = { registered = true }, },
            { name = 'WEAPON_GLOCK19X', price = 360000, metadata = { registered = true }, },

                                 -- MESSEN --                         
			{ name = 'WEAPON_SwitchBlade', price = 40000 },
			{ name = 'WEAPON_BAT', price = 25000 },
			{ name = 'WEAPON_KNIFE', price = 25000 },
			{ name = 'WEAPON_MACHETE', price = 20000 },
        }
	},

    vipammo = {
        name = 'VIP: Ammo',
        inventory = {
                                 -- Ammo -- 
			{ name = 'ammo-pistol', price = 100, },
            { name = 'ammo-smg', price = 150, },
            { name = 'ammo-shotgun', price = 250, },
            { name = 'ammo-rifle', price = 450, },

        }
	},

    vipattachments = {
        name = 'VIP: Attachments',
        inventory = {

			{ name = 'at_suppressor_light', price = 50000, },
			{ name = 'at_suppressor_heavy', price = 50000, },

			{ name = 'at_fm_scope_30', price = 50000, },
			{ name = 'at_fm_sup_10', price = 50000, },
			{ name = 'at_m9a3_clip_02', price = 50000, },

			{ name = 'sigscope2', price = 50000, },
			{ name = 'sigmag2', price = 50000, },
			{ name = 'sigsupp', price = 50000, },

			{ name = 'markomods-shared-supp12', price = 50000, },
			{ name = 'markomods-shared-scope1', price = 50000, },
			{ name = 'markomods-shared-scope8', price = 50000, },
			{ name = 'markomods-shared-supp12', price = 50000, },

			{ name = 'at_uzi_scope6', price = 50000, },
			{ name = 'at_uzi_stock2', price = 50000, },
			{ name = 'at_uzi_clip4', price = 50000, },
			{ name = 'at_uzi_supp2', price = 50000, },

			{ name = 'at_ak74u_clip_09', price = 50000, },
			{ name = 'at_ak74u_scope_13', price = 50000, },
			{ name = 'at_ak74u_flash_10', price = 50000, },
			{ name = 'at_ak74u_muzzle_09', price = 50000, },

			{ name = 'at_ump_sup_04', price = 50000, },
			{ name = 'at_ump_sight_03', price = 50000, },
			{ name = 'at_ump_sight_06', price = 50000, },
			{ name = 'at_ump_grip_01', price = 50000, },
			{ name = 'at_ump_flashlight_01', price = 50000, },
			{ name = 'at_ump_clip_02', price = 50000, },

            { name = 'w_at_nvrifle_afgrip', price = 50000, },
			{ name = 'w_ar_nvrifle_mag2', price = 50000, },
			{ name = 'w_at_nvrifle_scope_small', price = 50000, },
			{ name = 'w_at_nvrifle_supp', price = 50000, },
            { name = 'w_at_sg_benellim4_supp', price = 50000, },

			{ name = 'ak74_muz_07', price = 50000, },
			{ name = 'ak74_scope_02', price = 50000, },
			{ name = 'ak74_scope_04', price = 50000, },
			{ name = 'ak74_scope_05', price = 50000, },
			{ name = 'ak74_scope_07', price = 50000, },
			{ name = 'ak74_scope_08', price = 50000, },
			{ name = 'ak74_mag_09', price = 75000, },

			{ name = 'at_clip_extended_pistol', price = 50000, },
			{ name = 'at_clip_extended_smg', price = 50000, },

        }
	},


    recherchekluis = {
        name = 'Recherche | Uitrusting Kluis',
        inventory = {
            { name = 'WEAPON_GLOCK17', price = 3000 },
			{ name = 'at_glock_clip_extended', price = 250 },
			{ name = 'at_glock_flashlight', price = 250 },
			{ name = 'at_glock_suppressor', price = 250 },
			{ name = 'at_glock_scope_1', price = 250 },
			{ name = 'ammo-9', price = 10 },
			{ name = 'bewijszak', price = 0 },
        },
		groups = {
			police = 3,
			kmar = 4
		},
    }
}