Config = {}

Config.Locale = 'en'

-- Set the time (in minutes) during the player is outlaw
Config.Timer = 1

-- Set if show alert when player use gun
Config.GunshotAlert = true

-- Set if show when player do carjacking
Config.CarJackingAlert = false

-- Set if show when player fight in melee
Config.MeleeAlert = false

-- In seconds
Config.BlipGunTime = 45

-- Blip radius, in float value!
Config.BlipGunRadius = 100.0

-- In seconds
Config.BlipMeleeTime = 2

-- Blip radius, in float value!
Config.BlipMeleeRadius = 180.0

-- In seconds
Config.BlipJackingTime = 15

-- Blip radius, in float value!
Config.BlipJackingRadius = 180.0

-- Show notification when cops steal too?
Config.ShowCopsMisbehave = false

Config.UnconsciousAlert = true

-- Jobs in this table are considered as cops
Config.WhitelistedCops = {
	'kmar',
	'police',
	'staff'
}