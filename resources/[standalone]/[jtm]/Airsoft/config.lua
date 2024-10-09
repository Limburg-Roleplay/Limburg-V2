DebugMode = false

if IsDuplicityVersion() then
	 DebugMode = false
end

Translations = {
	language = 'nl',

	en = {
		Maintenance = "There is currently maintenance, you can not open a lobby!",
		AlreadyHaveLobby = "You already have a lobby!",
		NotAllowed = "This lobby can not be created!",
		InvalidStake = "Invalid value for stake!",
		NotEnoughMoney = "You do not have the money for the lobby's stake!",
		LobbyDeleted = "This lobby no longer exists!",
		KickedFromLobby = "You automatically left the airsoft lobby!",

		Title = "Airsoft",
		Lobbies = "Lobbies",
		CreateLobby = "Create Lobby",
		NoLoadout = "\nChoose atleast one loadout!",
		LobbyStartingIn = "Lobby starting in %s minutes",
		LobbyStarting = "The lobby is starting!",
		LobbyEnded = "The game has finished",
		LobbyEnded2 = "Winner: %s, kills: %s",
		LobbyEnded2Royale = "Winner: %s, most kills: %s",
		LobbyEnded2Teams = "Winning team: %s, kills: %s",
		ReturnToMap = "Return to the arena!",
		PlayedJoined = "%s joined the lobby",
		PlayerLeft = "%s left the lobby",
		AreYouSure = "Are you sure?",
		StakeWarning = "This lobby has a stake of $%s",
		Cancel = "Cancel",

		LobbyName = "Lobby name: %s",
		LobbyMode = "Gamemode: %s",
		LobbyMap = "Map: %s",
		LobbyTeam = "Team",
		LobbyStake = "Stake: %s", LobbyNoStake = "no stake",
		LobbyLoadouts = "Loadouts (%s selected)",
		LobbyTime = "Game time: %s minutes", 
		LobbyPlayers = "Players: %s",
		LobbyArmor = "Bodyarmor %s",
		LobbyBlips = "Player blips %s",
		LobbyStamina = "Onbeperkt stamina %s",
		LobbyJoin = "Join lobby",
		LobbyLeave = "Leave lobby",
		LobbyQuickstart = "Quickstart",
		LobbyPassword = "Password",
		LobbyEndingIn = "Lobby ending in %s minutes",

		NewLobbyTitle = "New lobby",
		NewLobbyName = "Lobby name: %s",
		NewLobbyPassword = "Lobby password: %s", NewLobbyPasswordSet = "set", NewLobbyPasswordNotSet = "not set",
		NewLobbyMap = "Lobby map: %s",
		NewLobbyStake = "Stake: %s",
		NewLobbyLoadouts = "Loadouts (%s selected)",
		NewLobbyArmor = "Bodyarmor %s",
		NewLobbyBlips = "Player blips %s",
		NewLobbyStamina = "Unlimited stamina %s",
		NewLobbyTimer = "Lobby time: %s minutes",
		NewLobbyCreate = "Create lobbby",

		SpaceToJump = "Use ~r~[Spacebar]~HC_0~ to jump!",
		LMBToParachute = "Use ~r~[Left Mouse]~HC_0~ to use your parachute!",

		GameEnded = "Game finished",
		TimeLeft = "Time left: %s minutes",
		Kills = "Kills: %s",
		Scoreboard = "#%s %s - kills: %s"
	},
	nl = {
		Maintenance = "Airsoft is momenteel in onderhoud, je kan geen lobby maken!",
		AlreadyHaveLobby = "Je hebt nog een lobby open staan!",
		NotAllowed = "Deze lobby kan niet aangemaakt worden!",
		InvalidStake = "Ongeldige inzet!",
		NotEnoughMoney = "Je hebt niet genoeg geld voor de inzet!",
		LobbyDeleted = "Deze lobby bestaat niet meer!",
		KickedFromLobby = "Je hebt automatisch de airsoft lobby verlaten!",

		Title = "Airsoft",
		Lobbies = "Lobbies",
		CreateLobby = "Maak lobby",
		NoLoadout = "\nKies tenminste een loadout!",
		LobbyStartingIn = "De lobby begint over %s minuten",
		LobbyStarting = "De lobby gaat beginnen!",
		LobbyEnded = "De ronde is afgelopen!",
		LobbyEnded2 = "Winnaar: %s, kills: %s",
		LobbyEnded2Royale = "Winnaar: %s, meeste kills: %s",
		LobbyEnded2Teams = "Winnende team: %s, kills: %s",
		ReturnToMap = "Ga terug naar de arena!",
		PlayedJoined = "%s heeft de lobby gejoined",
		PlayerLeft = "%s heeft de lobby verlaten",
		AreYouSure = "Weet je het zeker?",
		StakeWarning = "Deze lobby heeft een inzet van $%s",
		Cancel = "Annuleer",

		LobbyName = "Lobby naam: %s",
		LobbyMode = "Gamemode: %s",
		LobbyMap = "Map: %s",
		LobbyTeam = "Kies een team",
		LobbyStake = "Inzet: %s", LobbyNoStake = "geen inzet",
		LobbyLoadouts = "Loadouts (%s geselecteerd)",
		LobbyAttachments = "Attachmenst: %s",
		LobbyNight = "Nacht: %s",
		LobbyTime = "Game tijd: %s minuten", 
		LobbyPlayers = "Spelers: %s",
		LobbyArmor = "Bodyarmor: %s",
		LobbyBlips = "Speler blips: %s",
		LobbyStamina = "Onbeperkt stamina: %s",
		LobbyJoin = "Join lobby",
		LobbyLeave = "Verlaat lobby",
		LobbyQuickstart = "Start lobby",
		LobbyPassword = "Wachtwoord",
		LobbyEndingIn = "Lobby eindigt in %s minuten",

		NewLobbyTitle = "Nieuwe lobby",
		NewLobbyName = "Lobby naam: %s",
		NewLobbyPassword = "Lobby wachtwoord: %s", NewLobbyPasswordSet = "ingesteld", NewLobbyPasswordNotSet = "geen wachtwoord",
		NewLobbyMap = "Lobby map: %s",
		NewLobbyStake = "Inzet: %s",
		NewLobbyLoadouts = "Loadouts (%s geselecteerd)",
		NewLobbyAttachments = "Attachments %s",
		NewLobbyNight = "Nacht %s",
		NewLobbyArmor = "Bodyarmor %s",
		NewLobbyBlips = "Speler blips %s",
		NewLobbyStamina = "Onbeperkt stamina %s",
		NewLobbyTimer = "Lobby tijd: %s minuten",
		NewLobbyCreate = "Lobby aanmaken",

		SpaceToJump = "Druk op ~r~[Spacebar]~HC_0~ om te springen!",
		LMBToParachute = "Druk op ~r~[Left Mouse]~HC_0~ om je parachute te openen!",

		GameEnded = "Ronde afgelopen",
		TimeLeft = "Tijd over: %s minuten",
		Kills = "Kills: %s",
		Scoreboard = "#%s %s - kills: %s"
	}
}

Framework = {
	ESX = exports['es_extended']:getSharedObject(),

	-- this function is called client-sided to revive the player
	Revive = function()
		TriggerEvent('wsk-ambulance:client:staffrevive:player')
		-- local coords = GetEntityCoords(PlayerPedId())
		-- NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), false, false)
	end,

	-- This function gets called server-sided to retrieve a players name
	-- You can either return steam/fivem name, or an RP name. Shown on the lobby scoreboard
	GetPlayerName = function(source)
		return Framework.ESX.GetPlayerFromId(source).getName()
	end,

	-- This function gets called server-sided to retrieve how much cash/bank money a player has
	-- This is used when joining a lobby that has a stake. 
	GetPlayerMoney = function(source)
		return Framework.ESX.GetPlayerFromId(source).getAccount(Config.StakeAccount).money
	end,

	-- This function gets called server-sided to remove money from a player
	-- This is used when joining a lobby that has a stake. 
	RemovePlayerMoney = function(source, amount)
		Framework.ESX.GetPlayerFromId(source).removeAccountMoney(Config.StakeAccount, amount)
	end,

	-- this function gets called server-sided to give prize money
	-- This is used when winning a lobby that has a stake. 
	AddPlayerMoney = function(source, amount)
		Framework.ESX.GetPlayerFromId(source).addAccountMoney(Config.StakeAccount, amount)
	end,

	-- This function gets called server-sided to fetch the payers inventory in a json format, and also clear it.
	GetAndClearPlayerInventory = function(source)
		exports.ox_inventory:ConfiscateInventory(source)
		return "."
	end,

	-- This function is used to restore the data returned by `GetAndClearPlayerInventory`
	RestorePlayerInventory = function(source, data)
		exports.ox_inventory:ReturnInventory(source)
	end
}

Config = {
	-- The webhook for any logs. Set this to 'nil' if you do not want any logging
	Webhook = 'https://discord.com/api/webhooks/1285311158093484063/_kYUr6Svhuv1u_TaIvwGxTz91SnRSwAtpkmnaaO0eioE5htBhhW8U-skJpJekFeDaK2M',

	-- All settings for the marker where you can create/join lobbies
	LobbyMarker = {
		-- The coordinates
		Coords = vec3(180.1811, -923.8987, 29.9),
		-- The marker type, see https://docs.fivem.net/docs/game-references/markers/
		Type = 23,
		-- Marker size
		Scale = {
			x = 10.0, y = 10.0, z = 0.1
		},
		-- The color, red green blue and alpha (transparency)
		Color = {
			r = 255, g = 0, b = 0, a = 150,
		},
		-- The rotation
		Rotation = {
			x = 0.0, y = 0.0, z = 0.0
		}
	},

	StakeAccount = 'bank', -- which account to use for stake's

	GameModes = {
		[1] = {
			Label = "Free for all",
			key = 'ffa', -- DO NOT CHANGE
			Ace = "group.admin", -- You need this ace to select this gamemode. Leave `nil` to let anyone start this lobby
			DisableSettings = { -- DO NOT CHANGE
				'team'
			}
		},
		[2] = {
			Label = "Gungame",
			key = 'gungame', -- DO NOT CHANGE
			Ace = "pac_permission_everything", -- You need this ace to select this gamemode. Leave `nil` to let anyone start this lobby
			DisableSettings = { -- DO NOT CHANGE
				'loadouts', 'team'
			},
			Weapons = { -- This is the order of weapons you go through to win gun game
				 [1] = 'weapon_navyrevolver',
				 [2] = 'weapon_assaultrifle_mk2',
				 [3] = 'weapon_compactrifle',
				 [4] = 'weapon_assaultsmg',
				 [5] = 'weapon_smg',
				 [6] = 'weapon_minismg',
				 [7] = 'weapon_microsmg',
				 [8] = 'weapon_machinepistol',
				 [9] = 'weapon_pumpshotgun',
				[10] = 'weapon_sawnoffshotgun',
				[11] = 'weapon_pistol_mk2',
				[12] = 'weapon_smg_mk2',
				[13] = 'weapon_snspistol_mk2',
				[14] = 'weapon_pistol',
				[15] = 'weapon_revolver',
				[16] = 'weapon_heavypistol',
				[17] = 'weapon_sig',
				[18] = 'weapon_benellim4',
				[19] = 'weapon_fm1_m9a3',
				[20] = 'weapon_ak74_1',
				[21] = 'weapon_mb47',
				[22] = 'weapon_switchblade',
			}
		},
		[3] = {
			Label = "One in the Chamber",
			key = 'chamber', -- DO NOT CHANGE
			Ace = "pac_permission_everything", -- You need this ace to select this gamemode. Leave `nil` to let anyone start this lobby
			DisableSettings = { -- DO NOT CHANGE
				'loadouts', 'team', 'attachments'
			},
			Weapon = 'weapon_gadgetpistol',
			Weapons = { -- I do not recommend changing this, one in the chamber requires a one-shot gun to function properly
				[1] = 'weapon_knife',
				[2] = 'weapon_gadgetpistol'
			}
		},
		[4] = {
			Label = "Team Deathmatch",
			key = 'tdm', -- DO NOT CHANGE
			Ace = "pac_permission_everything", -- You need this ace to select this gamemode. Leave `nil` to let anyone start this lobby
			DisableSettings = { 'stake' }, -- DO NOT CHANGE
		},
		[5] = {
			Label = "Battle Royale",
			key = 'battle', -- DO NOT CHANGE
			Ace = "pac_permission_everything", -- You need this ace to select this gamemode. Leave `nil` to let anyone start this lobby
			DisableSettings = { 'loadouts', 'team', 'map', 'timer', 'attachments' }, -- DO NOT CHANGE
	
			PickupModels = { -- key value pairs of weapon names and their 3d model
			-- Ammo
				['ammo-9'] = 'w_pi_pistol50_mag1',
				['ammo-45'] = 'w_sb_assaultsmg_mag1',
				['ammo-rifle2'] = 'w_ar_assaultrifle_mag1',
				['ammo-shotgun'] = 'w_sg_heavyshotgun_mag1',
			-- Melee
				['WEAPON_NAILBAT'] = 'w_me_nailbat',
				['WEAPON_APOSWORD'] = 'w_me_aposword',
				['WEAPON_WRENCHKNIFE'] = 'w_me_wrenchknife',
				['WEAPON_CHAINKNIFE'] = 'w_me_chainknife',
			-- Vuurwapens
				['WEAPON_COLT1911'] = 'hane_colt1911',
				['weapon_fm1_m9a3'] = 'fm1_m9a3',
				['WEAPON_DESERT_EAGLE'] = 'w_pi_desert_eagle',
				['WEAPON_PPK'] = 'w_pi_PPK',
				['WEAPON_38SNUBNOSE'] = '38snubnose',
				['WEAPON_38SNUBNOSE2'] = '38snubnose2',
				['WEAPON_38SNUBNOSE3'] = '38snubnose3',
				['WEAPON_38SPECIAL'] = '38special',
				['WEAPON_44MAGNUM'] = '44magnum',
				['WEAPON_BENELLIM4'] = 'w_sg_benellim4',
				['WEAPON_DOUBLEBARRELFM'] = 'doublebarrelfm',
				['WEAPON_HKUMP'] = 'ump',
				['WEAPON_MINIUZI'] = 'markomods-uzi',
				['WEAPON_AKS74U'] = 'w_ar_assaultrifle_smg',
				['WEAPON_AK74'] = 'W_AR_ASSAULTRIFLE',
			-- Heal / body armor
				['morfine'] = 'prop_ld_health_pack',
				['morfine'] = 'prop_ld_health_pack',
				['morfine'] = 'prop_ld_health_pack',
				['kevlar'] = 'Prop_Armour_Pickup',
				['kevlardsi'] = 'Prop_Armour_Pickup',
			},
			PickupTiers = {
				-- Here you can create and customize the different pickup-tiers
				[1] = { -- ammo
					'ammo-9', 'ammo-9', 'ammo-9', 'ammo-45', 'ammo-45', 'ammo-rifle2', 'ammo-rifle2', 'ammo-shotgun'
				},
				[2] = { -- healing and body armor
					'morfine', 'morfine', 'morfine', 'morfine', 'morfine', 'morfine', 'kevlar', 'kevlar', 'kevlar', 'kevlar', 'kevlardsi'
				},
				[3] = { -- melee
					'WEAPON_APOSWORD', 'WEAPON_NAILBAT', 'WEAPON_WRENCHKNIFE', 'WEAPON_CHAINKNIFE'
				},
				[4] = { -- pistols
					'WEAPON_COLT1911', 'weapon_fm1_m9a3', 'WEAPON_DESERT_EAGLE', 'WEAPON_PPK', 'WEAPON_38SNUBNOSE', 'WEAPON_38SNUBNOSE2', 'WEAPON_38SNUBNOSE3', 'WEAPON_38SPECIAL', 'WEAPON_44MAGNUM'
				},
				[5] = { -- SMGs
					'WEAPON_HKUMP', 'WEAPON_MINIUZI'
				},
				[6] = { -- shotguns
					'WEAPON_BENELLIM4', 'WEAPON_DOUBLEBARRELFM'
				},
				[7] = { -- Heavy weapons
					'WEAPON_AKS74U'
				}
			},
			Pickups = {
				[1] = { -- all the coordinates where a random 'tier 1' pickup can spawn
				-- Grote haven (tier 1)
				vector3(5000.6079, -5166.9341, 2.7644), vector3(4993.9453, -5157.6030, 2.6642), vector3(4988.1787, -5127.9966, 2.4371), vector3(5003.8408, -5125.2222, 2.8964), vector3(5016.4229, -5161.3076, 2.6105), vector3(5012.2710, -5203.0249, 2.5165), vector3(4999.1909, -5214.3096, 2.5036), vector3(4979.0840, -5209.1655, 2.5033), vector3(4935.0107, -5224.9668, 2.5525), vector3(4916.7271, -5228.3325, 2.5206), 
				vector3(4917.9751, -5240.6797, 2.5232), vector3(4925.9731, -5243.6479, 2.5238), vector3(4893.9600, -5210.0620, 2.6701), vector3(4913.9507, -5186.0586, 2.4455), vector3(4900.7739, -5179.9473, 2.4456), vector3(4880.5078, -5171.1562, 2.4449), vector3(4866.9980, -5159.7178, 2.4383), vector3(4836.3892, -5177.3979, 2.1863), vector3(4927.5669, -5272.9404, 5.6754), vector3(4952.9609, -5270.1851, 4.5093), 
				vector3(4965.2505, -5279.6836, 6.2134), vector3(4968.7764, -5302.5444, 6.2994), vector3(4951.7832, -5322.3281, 8.0843), vector3(4978.6021, -5179.5151, 2.4740), vector3(4971.7646, -5157.9395, 2.4933), vector3(4955.0200, -5140.5957, 2.4468), vector3(4974.0967, -5127.5430, 2.7927), vector3(4954.7217, -5110.2798, 3.2257), vector3(4936.1201, -5099.9092, 2.6303), vector3(4969.2856, -5086.6699, 3.1042), 
				vector3(5009.5566, -5113.9287, 2.5680), vector3(5040.8203, -5115.0640, 6.1643), vector3(5115.8525, -5139.6279, 2.1806), vector3(5117.7979, -5170.0215, 2.2792), vector3(5107.9478, -5192.2046, 1.9963), vector3(5132.4580, -5203.3862, 2.7463), vector3(5169.7407, -5184.7285, 2.0389), vector3(5187.0811, -5153.9141, 3.6043), vector3(5182.5400, -5146.9468, 3.5214), vector3(5178.0298, -5127.8833, 3.0402),
				vector3(5190.2354, -5135.0840, 3.3427), vector3(5155.5898, -5123.4551, 2.3004),  vector3(5147.3438, -5141.5737, 2.2453), vector3(5135.7100, -5128.8564, 2.1160), vector3(5131.4521, -5117.0200, 2.1118), vector3(5140.7422, -5101.3999, 2.1875), vector3(5122.1621, -5102.4790, 2.2060), vector3(5126.5166, -5083.2852, 2.2059), vector3(5211.6201, -5126.1636, 6.2103), vector3(5040.8823, -5117.3008, 18.1446), 
				-- Villa (tier 7)

				-- Kleine haven (tier 3)
				vector3(5172.8091, -4591.1592, 3.7435), vector3(5139.9536, -4609.5962, 2.4858), vector3(5128.4395, -4598.1489, 4.2909), vector3(5151.2979, -4663.3760, 1.4374), vector3(5133.2896, -4693.5596, 2.1349), vector3(5141.8311, -4706.7866, 2.1999), vector3(5144.2354, -4719.4561, 2.1423), vector3(5132.0830, -4732.5493, 1.8771), vector3(5119.3711, -4752.4727, 1.8145), vector3(5119.3711, -4752.4727, 1.8145), 
				vector3(5081.6030, -4667.6914, 3.4202), vector3(5156.0967, -4667.5474, 1.4310), vector3(5170.4229, -4660.6973, 2.5183), vector3(5183.5786, -4657.5972, 2.5328), vector3(5159.7881, -4638.0776, 2.6164), vector3(5078.1045, -4682.3115, 2.7111), vector3(5068.1460, -4646.6367, 2.4364), vector3(5083.0103, -4642.5645, 5.9149), vector3(5082.3979, -4652.1294, 2.1238), vector3(5094.6733, -4656.2207, 1.7768), 
				vector3(5128.2456, -4684.6943, 1.8608), vector3(5117.9087, -4683.2939, 2.4423), vector3(5152.4404, -4634.2095, 3.6904), vector3(5148.0249, -4633.9551, 4.2003), vector3(5138.5215, -4630.7964, 2.6326), 
				-- Wiet velden (tier 5)

				-- Airport (tier 6)

				-- Party tent (tier 2)

				-- Grens (tier 4)

				-- Random (tier 8)
				},
				[2] = { -- all the coordinates where a random 'tier 2' pickup can spawn
				-- Grote haven (tier 1)
				vector3(4897.4434, -5209.5229, 2.5120), vector3(4869.5356, -5169.5479, 2.4383), vector3(4847.6484, -5190.7759, 5.1617), vector3(4908.0342, -5220.4170, 2.5162), vector3(4948.3271, -5267.7954, 3.7006), vector3(4961.5674, -5291.2178, 6.2302), vector3(4933.8794, -5319.8535, 7.2221), vector3(4993.4775, -5188.3579, 2.4702), vector3(4992.6211, -5137.7793, 2.4522), vector3(5018.5146, -5135.0249, 3.0091), 
				vector3(5150.4531, -5254.2266, 9.2501), vector3(5139.6953, -5206.2861, 2.9584), vector3(5172.0015, -5139.4810, 2.7716), vector3(5149.7852, -5083.0767, 2.4575), vector3(5150.8335, -5050.7529, 10.0268), vector3(5012.6597, -5106.5913, 4.1063), vector3(4872.2383, -5164.7671, 2.4382), vector3(4915.1597, -5222.7144, 2.5194), vector3(4962.1836, -5231.9224, 3.4743), vector3(5026.1050, -5203.7368, 2.5724), 
				vector3(4897.7588, -5283.0996, 8.4523), vector3(4942.6323, -5333.1323, 8.1496), vector3(4863.4951, -5378.9453, 15.8298), vector3(4850.0571, -5296.0049, 11.8795), vector3(4889.6436, -5181.9946, 2.4343), vector3(4963.7603, -5121.2539, 2.8489), vector3(5110.8154, -5150.0840, 2.0204), vector3(4931.7783, -5243.6743, 2.5834), vector3(5054.8853, -5205.2764, 2.5015), vector3(4947.6514, -5170.6035, 2.5171), 
				-- Villa (tier 7)

				-- Kleine haven (tier 3)
				vector3(5094.6733, -4656.2207, 1.7768), vector3(5095.2041, -4654.7046, 1.7712), vector3(5109.0952, -4622.6582, 2.6036), vector3(5095.6328, -4607.7861, 3.2627), vector3(5075.3110, -4615.5298, 2.7251), vector3(5071.0220, -4635.8408, 2.3703), vector3(5090.5479, -4654.0767, 1.8631), vector3(5099.4126, -4681.8628, 8.7016), vector3(5104.6978, -4682.9883, 8.6965), vector3(5108.7886, -4683.3237, 8.7016), 
				vector3(5113.2993, -4677.4854, 5.5711), vector3(5119.3896, -4674.2715, 4.1923), vector3(5104.1758, -4679.2256, 3.2149), vector3(5071.6377, -4637.6626, 3.8786), vector3(5075.7090, -4640.7676, 3.8387),
				-- Wiet velden (tier 5)

				-- Airport (tier 6)

				-- Party tent (tier 2)

				-- Grens (tier 4)

				-- Random (tier 8)
				},
				[3] = { -- all the coordinates where a random 'tier 3' pickup can spawn
				-- Grote haven (tier 1)
				vector3(5149.6299, -5042.7041, 4.3918), vector3(5196.0034, -5114.3843, 4.4703), vector3(5193.2544, -5196.2661, 10.8086), vector3(5028.0806, -5192.8354, 2.6953), vector3(4968.1748, -5133.9507, 2.6347), vector3(4995.2485, -5090.1372, 5.3012), vector3(4961.8101, -5186.8237, 2.4677), vector3(4906.9131, -5217.9800, 2.5135), vector3(4850.6045, -5179.1665, 2.6532), vector3(4920.2939, -5272.8413, 5.6515), 
				vector3(4941.2764, -5336.3574, 8.4313), vector3(4933.1929, -5327.8823, 7.6320), vector3(4979.2153, -5210.8389, 2.5004), vector3(4992.0283, -5141.3530, 2.4567), vector3(5026.4697, -5143.1235, 2.4859), vector3(5005.9360, -5197.8408, 2.5138), vector3(4921.4829, -5226.2554, 2.4986), vector3(4921.2954, -5234.9160, 2.5226), vector3(4901.9536, -5224.8379, 2.5246), vector3(4958.3184, -5142.3687, 2.4258), 
				vector3(4979.7969, -5150.2476, 2.5310), vector3(4958.8521, -5270.3311, 4.7344), vector3(4860.3335, -5331.5059, 13.4409), vector3(4843.9146, -5220.5312, 11.5597), vector3(4989.5791, -5192.6973, 2.5316), vector3(4974.2583, -5204.1899, 2.5033), vector3(5042.0547, -5137.0430, 6.3761), vector3(4998.9150, -5075.3950, 3.6144), vector3(5122.6089, -5070.8765, 2.2135), vector3(4908.4478, -5335.7974, 10.0127), 
				vector3(4915.9932, -5383.8257, 13.2092), vector3(4964.0366, -5330.2461, 8.3494), vector3(4965.6035, -5067.4629, 2.0791), vector3(5143.8574, -5064.4346, 3.3384), vector3(4947.6768, -5274.7686, 4.4959), vector3(4953.8096, -5327.0303, 8.1198), vector3(5033.6641, -5200.0688, 2.7288), vector3(4998.1904, -5117.4775, 2.5366), vector3(4994.7588, -5154.7739, 2.6249), vector3(5127.4683, -5141.5630, 2.1897), 
				-- Villa (tier 7)

				-- Kleine haven (tier 3)
				vector3(5094.6733, -4656.2207, 1.7768), vector3(5099.6201, -4677.4067, 2.4172), vector3(5087.4263, -4674.0161, 2.5593), vector3(5081.6030, -4667.6914, 3.4202), vector3(5053.9688, -4634.4473, 2.6825), vector3(5029.8984, -4628.6489, 4.9042), vector3(5034.4995, -4633.8330, 7.8737), vector3(5035.5000, -4629.0493, 11.3176), vector3(5031.5117, -4627.5249, 13.4674), vector3(5030.0850, -4632.0879, 16.8910), 
				vector3(5034.7817, -4633.6333, 19.0848  ), vector3(5035.6284, -4629.3950, 21.6921), vector3(5033.1968, -4628.6274, 21.6846), vector3(5030.1841, -4631.1484, 21.6846), vector3(5032.4150, -4632.8125, 21.6846), vector3(5032.4878, -4630.5435, 21.6846), vector3(5053.9619, -4593.2266, 2.8798), vector3(5063.8096, -4596.8936, 2.8475), vector3(5069.3594, -4598.6641, 2.8646), vector3(5074.6519, -4600.4248, 2.8721), 
				-- Wiet velden (tier 5)

				-- Airport (tier 6)

				-- Party tent (tier 2)

				-- Grens (tier 4)

				-- Random (tier 8)
				},
				[4] = { -- all the coordinates where a random 'tier 4' pickup can spawn
				-- Grote haven (tier 1)
				vector3(5038.0312, -5164.9487, 2.7933), vector3(5008.8545, -5123.9087, 2.4807), vector3(4997.2144, -5131.9175, 2.5519), vector3(5020.9688, -5165.6421, 2.6889), vector3(4984.2271, -5197.0215, 2.5229), vector3(4960.8726, -5185.3647, 2.4739), vector3(4928.8154, -5249.8428, 3.1931), vector3(4886.2651, -5302.8032, 10.4094), vector3(4860.0200, -5351.8062, 14.3327), vector3(4844.5923, -5176.3281, 2.4268), 
				vector3(5022.8892, -5063.9238, 2.2109), vector3(5041.6353, -5116.8584, 22.9404), vector3(5116.7617, -5124.6240, 2.1458), vector3(5137.3501, -5098.0967, 2.1895), vector3(5175.0938, -5097.1128, 3.1605), vector3(5194.9087, -5134.9229, 3.3493), vector3(5188.6118, -5147.3276, 3.6208), vector3(5143.3066, -5241.8140, 21.4922), vector3(4905.0112, -5342.8916, 20.4293), vector3(4895.2051, -5348.1313, 10.2606), 
				vector3(4916.2661, -5274.2256, 5.7789), vector3(4931.9976, -5146.6230, 2.4539), vector3(4898.0073, -5168.7207, 2.4675), vector3(4939.6450, -5112.6548, 2.8092), vector3(5069.5771, -5105.1104, 2.2245), vector3(5212.6172, -5225.6772, 17.4111), vector3(5154.8022, -5279.6279, 9.2474), vector3(4900.9722, -5382.2993, 13.5717), vector3(4883.9336, -5115.1592, 2.4952), vector3(4948.1460, -5186.9453, 5.0295), 
				-- Villa (tier 7)

				-- Kleine haven (tier 3)
				vector3(5105.5103, -4581.6787, 29.7177), vector3(5109.6899, -4582.1460, 29.7178), vector3(5110.0854, -4583.7402, 23.2523), vector3(5109.6914, -4576.2349, 23.2524), vector3(5164.3081, -4677.7319, 2.3835), vector3(5177.4766, -4677.6826, 2.4342), vector3(5180.6855, -4668.8779, 7.2263), vector3(5178.7095, -4671.7065, 7.1432), vector3(5180.3823, -4670.0908, 7.2273), vector3(5166.5112, -4670.9521, 2.4837),
				vector3(5109.4551, -4577.7988, 30.5615), vector3(5141.9819, -4631.1699, 2.6238), vector3(5130.6924, -4628.0488, 2.6153), vector3(5105.9980, -4620.4165, 2.5483), vector3(5090.6475, -4616.4980, 2.4703),
				-- Wiet velden (tier 5)

				-- Airport (tier 6)

				-- Party tent (tier 2)

				-- Grens (tier 4)

				-- Random (tier 8)
				},
				[5] = { -- all the coordinates where a random 'tier 5' pickup can spawn
				-- Grote haven (tier 1)
				vector3(4862.7754, -5156.4712, 2.4311), vector3(4906.7588, -5171.2480, 2.4462), vector3(4939.0405, -5108.9849, 5.7568), vector3(4962.0620, -5108.0981, 2.9821), vector3(4933.8506, -5249.7651, 4.3107), vector3(4973.6270, -5272.8560, 5.7082), vector3(4964.8354, -5317.8564, 8.1424), vector3(4902.9321, -5339.0972, 35.5706), vector3(4851.0107, -5325.1147, 15.7389), vector3(4834.5386, -5178.3179, 5.5480), 
				-- Villa (tier 7)

				-- Kleine haven (tier 3)
				vector3(5168.4312, -4639.5454, 6.7032), vector3(5155.3389, -4671.9185, 5.7233), vector3(5153.3853, -4656.3242, 1.4387), vector3(5078.0215, -4633.6846, 2.2217), vector3(5069.7808, -4650.0054, 2.4382),
				-- Wiet velden (tier 5)

				-- Airport (tier 6)

				-- Party tent (tier 2)

				-- Grens (tier 4)

				-- Random (tier 8)
				},
				[6] = { -- all the coordinates where a random 'tier 6' pickup can spawn
				-- Grote haven (tier 1)
				vector3(4935.0532, -5104.3218, 5.7097), vector3(5044.0596, -5114.8784, 22.9405), vector3(5109.9917, -5187.6221, 3.2958), vector3(5135.6445, -5235.4678, 8.7578), vector3(5203.9038, -5119.6440, 6.1468), vector3(5201.6816, -5219.2666, 15.7459), vector3(5142.9844, -5246.4277, 26.2981), vector3(5003.9766, -5211.8804, 4.7574), vector3(4922.6665, -5236.3994, 3.6759), vector3(4982.5884, -5162.1367, 2.5225), 
				-- Villa (tier 7)

				-- Kleine haven (tier 3)
				vector3(5137.8950, -4614.3901, 7.7535), vector3(5061.2930, -4658.0581, 2.9407), vector3(5110.2222, -4575.0229, 14.5469), vector3(5102.5249, -4695.3882, 11.3537), vector3(5108.9570, -4685.5415, 8.7009),
				-- Wiet velden (tier 5)

				-- Airport (tier 6)

				-- Party tent (tier 2)

				-- Grens (tier 4)

				-- Random (tier 8)
				},
				[7] = { -- all the coordinates where a random 'tier 7' pickup can spawn
				-- Grote haven (tier 1)
				vector3(5043.0063, -5116.9692, 22.9489), vector3(5147.2065, -5055.7920, 20.3915), vector3(4902.9883, -5336.5449, 35.7425), vector3(4996.2827, -5207.2798, 12.9472), vector3(4968.0649, -5112.1206, 3.2096),
				-- Villa (tier 7)

				-- Kleine haven (tier 3)
				vector3(5129.8555, -4608.9956, 12.3940), vector3(5173.0493, -4589.5332, 6.8918), vector3(5101.9146, -4673.8857, 2.3098),
				-- Wiet velden (tier 5)

				-- Airport (tier 6)

				-- Party tent (tier 2)

				-- Grens (tier 4)

				-- Random (tier 8)
				}
			},
			PlanePaths = {
				-- I recommend not touching this, default settings work great as is
				-- Though if you want to, go to one start point, then note the coordinates and heading. 
				-- Fly in a straight line, without changing your heading even slightly, far beyond the actual end point, and mark those coordinates
				-- Then you can mark the maximum jump distance, minimum jump distance and delete distance.
				[1] = {
					start = vector3(5584.812, -6003.284, 850.0),
					target = vector3(3501.652, -2916.95, 500.0),
					heading = 34.015747070312,
					delete = 1300,
					minDropDistance = 3550,
					maxDropDistance = 1900
				},
				[2] = {
					start = vector3(4707.138, -3941.262, 850.0),
					target = vector3(5391.652, -7220.914, 500.0),
					heading = 192.75590515136,
					delete = 1250,
					minDropDistance = 3000,
					maxDropDistance = 1600
				}
			},
			Zones = {
				[1] = vector3(4888.8, -5106.0, 0.0)
			}
		}
	},

	Loadouts = {
		[1] = {
			Label = 'Melee',
			Weapons = {
				'weapon_dagger', 'weapon_bat', 'weapon_bottle', 'weapon_crowbar', 'weapon_flashlight', 'weapon_hammer', 'weapon_hatchet', 'weapon_knuckle', 'weapon_knife', 'weapon_machete', 'weapon_switchblade', 'weapon_nightstick', 'weapon_wrench', 'weapon_battleaxe', 'weapon_stone_hatchet'
			}
		},
		[2] = {
			Label = 'Pistols',
			Weapons = {
				'weapon_sig', 'weapon_glock17', 'weapon_glock19x', 'weapon_combatpistol', 'weapon_pistol50', 'weapon_snspistol', 'weapon_fm1_m9a3'
			}
		},
		[3] = {
			Label = 'Revolvers',
			Weapons = {
				'weapon_revolver', 'weapon_doubleaction'
			}
		},
		[4] = {
			Label = "SMGs",
			Weapons = {
				'weapon_hkump', 'weapon_agc', 'weapon_miniuzi', 'weapon_minismg', 'weapon_mp5'
			}
		},
		[5] = {
			Label = 'Rifles',
			Weapons = {
				'weapon_ak74_1', 'weapon_nvrifle', 'weapon_mcxrattler', 'weapon_fm2_hk416', 'weapon_mb47', 'weapon_aks74u', 'weapon_fm1_hk416'
			}
		},
		[6] = {
			Label = 'Shotguns',
			Weapons = {
				'weapon_benellim4', 'weapon_sawnoffshotgun', 'weapon_doublebarrelfm', 'weapon_remington'
			}
		},
		[7] = {
			Label = 'Snipers',
			Weapons = {
				'weapon_sniperrifle', 'weapon_marksmanrifle_mk2', 'weapon_heavysniper_mk2'
			}
		},
		[8] = {
			Label = 'Minigun',
			Weapons = {
				'weapon_minigun'
			},
		},
		[9] = {
			Label = 'All weapons',
			Weapons = {
            'weapon_sig', 'weapon_glock17', 'weapon_glock19x', 'weapon_combatpistol', 'weapon_pistol50', 'weapon_snspistol', 'weapon_fm1_m9a3', 'weapon_revolver', 'weapon_doubleaction', 'weapon_hkump', 'weapon_agc', 'weapon_miniuzi', 'weapon_minismg', 'weapon_mp5', 'weapon_ak74_1', 'weapon_nvrifle', 'weapon_mcxrattler', 'weapon_fm2_hk416', 'weapon_mb47', 'weapon_aks74u', 'weapon_fm1_hk416', 'weapon_benellim4', 'weapon_sawnoffshotgun', 'weapon_doublebarrelfm', 'weapon_remington'
			}
		},
     },

	 Attachments = {
		['weapon_assaultrifle_mk2'] = 'COMPONENT_AT_AR_SUPP_02',
		['weapon_pistol'] = 'COMPONENT_AT_PI_SUPP_02',
		['weapon_combatpistol'] = 'COMPONENT_AT_PI_SUPP',
		['weapon_pumpshotgun_mk2'] = 'COMPONENT_AT_SR_SUPP_03',
		['weapon_appistol'] = 'COMPONENT_AT_PI_SUPP',
		['weapon_pistol50'] = 'COMPONENT_AT_AR_SUPP_02',
		['weapon_heavypistol'] = 'COMPONENT_AT_PI_SUPP',
		['weapon_pistol_mk2'] = 'COMPONENT_AT_PI_SUPP_02',
		['weapon_vintagepistol'] = 'COMPONENT_AT_PI_SUPP',
		['weapon_microsmg'] = 'COMPONENT_AT_AR_SUPP_02',
		['weapon_smg'] = 'COMPONENT_AT_PI_SUPP',
		['weapon_snspistol_mk2'] = 'COMPONENT_AT_PI_SUPP_02',
		['weapon_assaultsmg'] = 'COMPONENT_AT_AR_SUPP_02',
		['weapon_machinepistol'] = 'COMPONENT_AT_PI_SUPP',
		['weapon_pumpshotgun'] = 'COMPONENT_AT_SR_SUPP',
		['weapon_assaultshotgun'] = 'COMPONENT_AT_AR_SUPP',
		['weapon_bullpupshotgun'] = 'COMPONENT_AT_AR_SUPP_02',
		['weapon_assaultrifle'] = 'COMPONENT_AT_AR_SUPP_02',
		['weapon_carbinerifle'] = 'COMPONENT_AT_AR_SUPP',
		['weapon_advancedrifle'] = 'COMPONENT_AT_SCOPE_SMALL',
		['weapon_specialcarbine'] = 'COMPONENT_AT_AR_SUPP_02',
		['weapon_bullpuprifle'] = 'COMPONENT_AT_AR_SUPP',
		['weapon_sniperrifle'] = 'COMPONENT_AT_AR_SUPP_02',
	},

	-- The color of the arena border
	PolyzoneColor = { 0, 205, 255 },

	-- Do not touch this
	Maps = nil
}