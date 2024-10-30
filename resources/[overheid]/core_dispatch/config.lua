Config = {

	NewESX = true, -- True if you have es_extended version > 1.8, false instead.
	OpenMenuKey = '-', -- Key to open the dispatch menu (Leave blank if you dont need a key)

	EnableUnitArrivalNotice = true, -- Give player notice that the unit is arriving to them! (Triggered when any unit accepts the call)

	callCommandSprite = 280, -- Blip sprite when player calls using command
	callCommandColor = 57, -- Blip color when player calls using command

	EnableMapBlipsForUnits = false, -- Shows units in their vehicles on the map
	AddCallBlips = true, -- Adds blips for calls that disappear over time
	CallBlipDisappearInterval = 500, -- The higher value longer they will stay on the map (in ms)

	DefaultAlertDelayBeforeTriggering = 1, -- number in sec that will take before the alert is generate (in second)

	-------------------------
	-- Shooting Alert Part --
	-------------------------

	EnableShootingAlerts = true, -- Alerts when player shoot in shooting zones or nearby npcs

	NPCShootingReport = false, -- Alerts when shot nearby npcs
	NPCReportRadius = 50.0, -- How close to npcs player need to be to get an alert
	NPCReportTime = 10, -- How long does it take ped to call an alert (if you kill him he wont call) (in second)

	EnableShootingAlertOnAllTheMap = true, -- if false, only in the zone below alert will be trigger (in addition of npc alert), if true, the whole map will trigger alert (and NPC option is useless)
	ShootingZones = { -- Zones where citizens shooting gives police an alert
		{coords = vector3(-20.18,6629.50,30.81), radius = 200.0},
	}, 

	SilencerDontTriggerAlert = true, -- if true, silencer weapon won"t trigger alert, if false they will

	JobWhitelisted = { -- list of job who won't trigger any shooting alert 
		 ['police'] = true,
		 ['dsi'] = true,
		 ['kmar'] = true,
		 ['bsb'] = true,
		 ['hrb'] = true,
	},

	WeaponWhitelisted = { -- list of weapon who won't trigger any shoot alert
		-- Melee
		[GetHashKey('WEAPON_UNARMED')] = true,
		[GetHashKey('WEAPON_FLASHLIGHT')] = true,
		[GetHashKey('WEAPON_DAGGER')] = true,
		[GetHashKey('WEAPON_BAT')] = true,
		[GetHashKey('WEAPON_BOTTLE')] = true,
		[GetHashKey('WEAPON_CROWBAR')] = true,
		[GetHashKey('WEAPON_GOLFCLUB')] = true,
		[GetHashKey('WEAPON_HAMMER')] = true,
		[GetHashKey('WEAPON_HATCHET')] = true,
		[GetHashKey('WEAPON_KNUCKLE')] = true,
		[GetHashKey('WEAPON_KNIFE')] = true,
		[GetHashKey('WEAPON_MACHETE')] = true,
		[GetHashKey('WEAPON_SWITCHBLADE')] = true,
		[GetHashKey('WEAPON_NIGHTSTICK')] = true,
		[GetHashKey('WEAPON_WRENCH')] = true,
		[GetHashKey('WEAPON_BATTLEAXE')] = true,
		[GetHashKey('WEAPON_POOLCUE')] = true,
		[GetHashKey('WEAPON_STONE_HATCHET')] = true,
		[GetHashKey('WEAPON_CANDYCANE')] = true,

		-- Miscellaneous
		[GetHashKey('WEAPON_SNOWBALL')] = true,
		[GetHashKey('WEAPON_BALL')] = true,
		[GetHashKey('WEAPON_ACIDPACKAGE')] = true,
		[GetHashKey('WEAPON_FLARE')] = true,
		[GetHashKey('WEAPON_PETROLCAN')] = true,
		[GetHashKey('WEAPON_FIREEXTINGUISHER')] = true,
		[GetHashKey('WEAPON_HAZARDCAN')] = true,
		[GetHashKey('WEAPON_FERTILIZERCAN')] = true,
	},

	ShotFireIsPriority = true, -- If true, shot fire will be a priority call type

	-----------------------------
	-- End Shooting Alert Part --
	-----------------------------

	EnableCarJackingAlert = false, -- When a player get a car from someone on the road
	ChanceToGetCarjackingAlert = 0.5, -- number between 0 and 1, 0% to 100% chance to get the alert

	NPCCarjackingReport = false, -- Alerts when carjack nearby npcs, if false, always trigger an alert when carjacking depending of the chance parameters
	NPCCarjackingReportRadius = 50.0, -- How close to npcs player need to be to get an alert
	NPCCarjackingReportTime = 10, -- How long does it take ped to call an alert (if you kill him he wont call) (in second)

	EnableCarTheftAlert = false, -- When a player get a car from a parking lot with alarm
	ChanceToGetCarTheftAlert = 0.8, -- number between 0 and 1, 0% to 100% chance to get the alert

	NPCCarTheftReport = false, -- Alerts when carjack nearby npcs, if false, always trigger an alert when CarTheft
	NPCCarTheftReportRadius = 50.0, -- How close to npcs player need to be to get an alert
	NPCCarTheftReportTime = 10, -- How long does it take ped to call an alert (if you kill him he wont call) (in second)

	-- You can have 3 jobs that can interact with the dispatch and 
	-- canRequestLocalBackup - This is for requesting backup/help from same job as yours
	-- canRequestOtherJobBackup - This is for requesting backup/help from other jobs too
	-- forwardCall - This will allow you to forward your jobs call to other jobs
	-- callCommand - Command to make a call in dispatch (You can also use triggers and make phone funcionallity or smth)
	-- color - This is the color of units! this is a css class if you dont know what are you doing dont change
	-- label - Label of the job
	-- /!\ Don't remove one of the three properties (JobOne, JobTwo, JobThree), set a job name you don't use if you want to not have three job
	JobOne = {job = 'police', canRequestLocalBackup = true, canRequestOtherJobBackup = true, forwardCall = true, canRemoveCall = true, callCommand = "112-politie", color = "blueunit", label = "Police", blipColor = 26 },
	JobTwo = {job = 'ambulance', canRequestLocalBackup = true, canRequestOtherJobBackup = true, forwardCall = true, canRemoveCall = true, callCommand = "112-ambulance", color = "redunit", label = "EMS",  blipColor = 1 },
	JobThree = {job = 'mechanic', canRequestLocalBackup = true, canRequestOtherJobBackup = true, forwardCall = true, canRemoveCall = true, callCommand = "112-anwb", color = "grayunit", label = "Mech",  blipColor = 39 },

	SameDepartementJobs = { -- Jobs that can be linked to main job in dispatch
		['politie'] = 'police',
		['dsi'] = 'police',
	},

	Text = {
		['call_removed'] = 'Call was removed',
		['backup_requested'] = 'Backup requested',
		['call_forwarded'] = 'Call forwarded',
		['someone_is_reacting'] = 'Unit is arriving to your location!',
		['offduty'] = 'Offduty is not set up, check config file',
		['alerts_turned_off'] = 'Alerts turned off!',
		['alerts_turned_on'] = 'Alerts turned on!',
		['phone_number_copied'] = 'Phone number copied',
		['unit_blips_turned_on'] = 'Units are now shown',
		['unit_blips_turned_off'] = 'Units are now hidden',
		['call_blips_turned_on'] = 'Call blips shown',
		['call_blips_turned_off'] = 'Call blips hidden',
		['callsign_changed'] = 'Call sign changed',
		['no_permission'] = 'You dont have permissions!',
		['callsign_char_long'] = 'Too many characters! 3 Max',
		['accepted'] = 'Accepted',
		['active_units_error'] = 'Cannot remove call with active units',
		['cant_accept_call'] = 'Cant accept call because it was removed'
	},

	Sprite = { -- Vehicle blip sprite by class
		[0] = 225,
		[1] = 225,
		[2] = 225,
		[3] = 225,
		[4] = 225,
		[5] = 225,
		[6] = 225,
		[7] = 225,
		[8] = 226,
		[9] = 225,
		[10] = 67,
		[11] = 67,
		[12] = 67,
		[13] = 226,
		[14] = 410,
		[15] = 422,
		[16] = 423,
		[17] = 225,
		[18] = 225,
		[19] = 225,
		[20] = 67,
		[22] = 1
	},

	Icons = { -- Vehicle icon by class
		[0] = 'fa-car',
		[1] = 'fa-car',
		[2] = 'fa-car',
		[3] = 'fa-car',
		[4] = 'fa-car',
		[5] = 'fa-car',
		[6] = 'fa-car',
		[7] = 'fa-car',
		[8] = 'fa-motorcycle',
		[9] = 'fa-car',
		[10] = 'fa-truck',
		[11] = 'fa-truck',
		[12] = 'fa-truck',
		[13] = 'fa-bicycle',
		[14] = 'fa-ship',
		[15] = 'fa-helicopter',
		[16] = 'fa-plane',
		[17] = 'fa-car',
		[18] = 'fa-car',
		[19] = 'fa-car',
		[20] = 'fa-truck',
		[22] = 'fa-running'
	},

	VehicleColors = {
		['0'] = "Metallic Black",
		['1'] = "Metallic Graphite Black",
		['2'] = "Metallic Black Steel",
		['3'] = "Metallic Dark Silver",
		['4'] = "Metallic Silver",
		['5'] = "Metallic Blue Silver",
		['6'] = "Metallic Steel Gray",
		['7'] = "Metallic Shadow Silver",
		['8'] = "Metallic Stone Silver",
		['9'] = "Metallic Midnight Silver",
		['10'] = "Metallic Gun Metal",
		['11'] = "Metallic Anthracite Grey",
		['12'] = "Matte Black",
		['13'] = "Matte Gray",
		['14'] = "Matte Light Grey",
		['15'] = "Util Black",
		['16'] = "Util Black Poly",
		['17'] = "Util Dark silver",
		['18'] = "Util Silver",
		['19'] = "Util Gun Metal",
		['20'] = "Util Shadow Silver",
		['21'] = "Worn Black",
		['22'] = "Worn Graphite",
		['23'] = "Worn Silver Grey",
		['24'] = "Worn Silver",
		['25'] = "Worn Blue Silver",
		['26'] = "Worn Shadow Silver",
		['27'] = "Metallic Red",
		['28'] = "Metallic Torino Red",
		['29'] = "Metallic Formula Red",
		['30'] = "Metallic Blaze Red",
		['31'] = "Metallic Graceful Red",
		['32'] = "Metallic Garnet Red",
		['33'] = "Metallic Desert Red",
		['34'] = "Metallic Cabernet Red",
		['35'] = "Metallic Candy Red",
		['36'] = "Metallic Sunrise Orange",
		['37'] = "Metallic Classic Gold",
		['38'] = "Metallic Orange",
		['39'] = "Matte Red",
		['40'] = "Matte Dark Red",
		['41'] = "Matte Orange",
		['42'] = "Matte Yellow",
		['43'] = "Util Red",
		['44'] = "Util Bright Red",
		['45'] = "Util Garnet Red",
		['46'] = "Worn Red",
		['47'] = "Worn Golden Red",
		['48'] = "Worn Dark Red",
		['49'] = "Metallic Dark Green",
		['50'] = "Metallic Racing Green",
		['51'] = "Metallic Sea Green",
		['52'] = "Metallic Olive Green",
		['53'] = "Metallic Green",
		['54'] = "Metallic Gasoline Blue Green",
		['55'] = "Matte Lime Green",
		['56'] = "Util Dark Green",
		['57'] = "Util Green",
		['58'] = "Worn Dark Green",
		['59'] = "Worn Green",
		['60'] = "Worn Sea Wash",
		['61'] = "Metallic Midnight Blue",
		['62'] = "Metallic Dark Blue",
		['63'] = "Metallic Saxony Blue",
		['64'] = "Metallic Blue",
		['65'] = "Metallic Mariner Blue",
		['66'] = "Metallic Harbor Blue",
		['67'] = "Metallic Diamond Blue",
		['68'] = "Metallic Surf Blue",
		['69'] = "Metallic Nautical Blue",
		['70'] = "Metallic Bright Blue",
		['71'] = "Metallic Purple Blue",
		['72'] = "Metallic Spinnaker Blue",
		['73'] = "Metallic Ultra Blue",
		['74'] = "Metallic Bright Blue",
		['75'] = "Util Dark Blue",
		['76'] = "Util Midnight Blue",
		['77'] = "Util Blue",
		['78'] = "Util Sea Foam Blue",
		['79'] = "Uil Lightning blue",
		['80'] = "Util Maui Blue Poly",
		['81'] = "Util Bright Blue",
		['82'] = "Matte Dark Blue",
		['83'] = "Matte Blue",
		['84'] = "Matte Midnight Blue",
		['85'] = "Worn Dark blue",
		['86'] = "Worn Blue",
		['87'] = "Worn Light blue",
		['88'] = "Metallic Taxi Yellow",
		['89'] = "Metallic Race Yellow",
		['90'] = "Metallic Bronze",
		['91'] = "Metallic Yellow Bird",
		['92'] = "Metallic Lime",
		['93'] = "Metallic Champagne",
		['94'] = "Metallic Pueblo Beige",
		['95'] = "Metallic Dark Ivory",
		['96'] = "Metallic Choco Brown",
		['97'] = "Metallic Golden Brown",
		['98'] = "Metallic Light Brown",
		['99'] = "Metallic Straw Beige",
		['100'] = "Metallic Moss Brown",
		['101'] = "Metallic Biston Brown",
		['102'] = "Metallic Beechwood",
		['103'] = "Metallic Dark Beechwood",
		['104'] = "Metallic Choco Orange",
		['105'] = "Metallic Beach Sand",
		['106'] = "Metallic Sun Bleeched Sand",
		['107'] = "Metallic Cream",
		['108'] = "Util Brown",
		['109'] = "Util Medium Brown",
		['110'] = "Util Light Brown",
		['111'] = "Metallic White",
		['112'] = "Metallic Frost White",
		['113'] = "Worn Honey Beige",
		['114'] = "Worn Brown",
		['115'] = "Worn Dark Brown",
		['116'] = "Worn straw beige",
		['117'] = "Brushed Steel",
		['118'] = "Brushed Black Steel",
		['119'] = "Brushed Aluminium",
		['120'] = "Chrome",
		['121'] = "Worn Off White",
		['122'] = "Util Off White",
		['123'] = "Worn Orange",
		['124'] = "Worn Light Orange",
		['125'] = "Metallic Securicor Green",
		['126'] = "Worn Taxi Yellow",
		['127'] = "Police Car Blue",
		['128'] = "Matte Green",
		['129'] = "Matte Brown",
		['130'] = "Worn Orange",
		['131'] = "Matte White",
		['132'] = "Worn White",
		['133'] = "Worn Olive Army Green",
		['134'] = "Pure White",
		['135'] = "Hot Pink",
		['136'] = "Salmon pink",
		['137'] = "Metallic Vermillion Pink",
		['138'] = "Orange",
		['139'] = "Green",
		['140'] = "Blue",
		['141'] = "Mettalic Black Blue",
		['142'] = "Metallic Black Purple",
		['143'] = "Metallic Black Red",
		['144'] = "hunter green",
		['145'] = "Metallic Purple",
		['146'] = "Metallic Dark Blue",
		['147'] = "Black",
		['148'] = "Matte Purple",
		['149'] = "Matte Dark Purple",
		['150'] = "Metallic Lava Red",
		['151'] = "Matte Forest Green",
		['152'] = "Matte Olive Drab",
		['153'] = "Matte Desert Brown",
		['154'] = "Matte Desert Tan",
		['155'] = "Matte Foilage Green",
		['156'] = "Default Alloy Color",
		['157'] = "Epsilon Blue",
		['158'] = "Pure Gold",
		['159'] = "Brushed Gold",
		['160'] = "MP100"
	}
}

--- Function called when you press power off button
function ToggleDuty() 
	SendTextMessage(Config.Text['offduty'])
end

-- Only change if you know what are you doing
function SendTextMessage(msg)
	
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)

	-- EXAMPLE USED IN VIDEO
	-- Required mythic_notify
	-- exports['mythic_notify']:SendAlert('inform', msg)
end