ClientWeapons = {}

ClientWeapons.WeaponNames = {
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Unarmed',
	[tostring(GetHashKey('WEAPON_REMINGTON680'))] = 'Remington 680',
	[tostring(GetHashKey('WEAPON_AK47U'))] = 'AK 47U',
	[tostring(GetHashKey('WEAPON_WIREBAT'))] = 'Wire Bat',
	[tostring(GetHashKey('WEAPON_BAYONET'))] = 'Bayonet',
	[tostring(GetHashKey('WEAPON_FIREAXE'))] = 'Fire Axe',
	[tostring(GetHashKey('WEAPON_HK416'))] = 'HK 416',
	[tostring(GetHashKey('WEAPON_MAC11'))] = 'MAC-11',
	[tostring(GetHashKey('WEAPON_MEOS45'))] = 'MEOS-45',
	[tostring(GetHashKey('WEAPON_UMP45'))] = 'UMP-45',
	[tostring(GetHashKey('WEAPON_TRI-DAGGER'))] = 'Tri-Dagger',
	[tostring(GetHashKey('WEAPON_SPAS12'))] = 'Spas 12',
	[tostring(GetHashKey('WEAPON_SMITHWESSON'))] = 'Smith & Wesson',
	[tostring(GetHashKey('WEAPON_AK47'))] = 'AK 47',
	[tostring(GetHashKey('WEAPON_MP5'))] = 'MP5',
	[tostring(GetHashKey('WEAPON_M1911'))] = 'M1911',
	[tostring(GetHashKey('WEAPON_GLOCK17'))] = 'Glock 17',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switch Blade',

	[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
	[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
	[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
	[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
	[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
	[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
	[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
	[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
	[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
	[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
	[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
	[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
	[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
	[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
	[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
	[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
	[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
}


ClientFunc = {}

ClientFunc.IsMelee = function(Weapon)
	local Weapons = {'WEAPON_UNARMED', 'WEAPON_CROWBAR', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_NIGHTSTICK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsTorch = function(Weapon)
	local Weapons = {'WEAPON_MOLOTOV'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsKnife = function(Weapon)
	local Weapons = {'WEAPON_DAGGER', 'WEAPON_KNIFE', 'WEAPON_SWITCHBLADE', 'WEAPON_HATCHET', 'WEAPON_BOTTLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsPistol = function(Weapon)
	local Weapons = {'WEAPON_SNSPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_VINTAGEPISTOL', 'WEAPON_PISTOL', 'WEAPON_APPISTOL', 'WEAPON_COMBATPISTOL'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsSub = function(Weapon)
	local Weapons = {'WEAPON_MICROSMG', 'WEAPON_SMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsRifle = function(Weapon)
	local Weapons = {'WEAPON_CARBINERIFLE', 'WEAPON_MUSKET', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_ASSAULTRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_COMPACTRIFLE', 'WEAPON_BULLPUPRIFLE'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsLight = function(Weapon)
	local Weapons = {'WEAPON_MG', 'WEAPON_COMBATMG'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsShotgun = function(Weapon)
	local Weapons = {'WEAPON_BULLPUPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_PUMPSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsSniper = function(Weapon)
	local Weapons = {'WEAPON_MARKSMANRIFLE', 'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_ASSAULTSNIPER', 'WEAPON_REMOTESNIPER'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsHeavy = function(Weapon)
	local Weapons = {'WEAPON_GRENADELAUNCHER', 'WEAPON_RPG', 'WEAPON_FLAREGUN', 'WEAPON_HOMINGLAUNCHER', 'WEAPON_FIREWORK', 'VEHICLE_WEAPON_TANK'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsMinigun = function(Weapon)
	local Weapons = {'WEAPON_MINIGUN'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsBomb = function(Weapon)
	local Weapons = {'WEAPON_GRENADE', 'WEAPON_PROXMINE', 'WEAPON_EXPLOSION', 'WEAPON_STICKYBOMB', 'WEAPON_PIPEBOMB'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsVeh = function(Weapon)
	local Weapons = {'VEHICLE_WEAPON_ROTORS'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.IsVK = function(Weapon)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

ClientFunc.hashToWeapon = function(hash)
	return weapons[hash]
end

ClientFunc.has_value = function(tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end


CreateThread(function()
	local DeathReason, Killer, DeathCauseHash, Weapon
	while true do
		Wait(500)
		if IsEntityDead(PlayerPedId()) then
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			local killername = GetPlayerName(PedKiller)
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
			Weapon = ClientWeapons.WeaponNames[tostring(DeathCauseHash)]
			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end
			if (Killer == PlayerId()) then
				DeathReason = "Pleegde zelfmoord"
			elseif (Killer == nil) then
				DeathReason = "Is overleden"
			else
				if ClientFunc.IsMelee(DeathCauseHash) then
					DeathReason = "Is vermoord"
				elseif ClientFunc.IsTorch(DeathCauseHash) then
					DeathReason = "Is verbrand"
				elseif ClientFunc.IsKnife(DeathCauseHash) then
					DeathReason = "Is neergestoken"
				elseif ClientFunc.IsPistol(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsSub(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsRifle(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsLight(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsShotgun(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsSniper(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsHeavy(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsMinigun(DeathCauseHash) then
					DeathReason = "Is neergeschoten"
				elseif ClientFunc.IsBomb(DeathCauseHash) then
					DeathReason = "Is opgeblazen"
				elseif ClientFunc.IsVeh(DeathCauseHash) then
					DeathReason = "Is over reden"
				elseif ClientFunc.IsVK(DeathCauseHash) then
					DeathReason = "Is over reden"
				else
					DeathReason = "Is vermoord"
				end
			end

			if DeathReason == "Pleegde Zelfmoord" or DeathReason == "is overleden" then
				TriggerServerEvent('resources:playerDied', { type = 1, player_id = GetPlayerServerId(PlayerId()), death_reason = DeathReason, weapon = Weapon })
				TriggerServerEvent('frp-ambulance:death', GetPlayerServerId(PlayerId()), Weapon)
			else
				TriggerServerEvent('resources:playerDied', { type = 2, player_id = GetPlayerServerId(PlayerId()), player_2_id = GetPlayerServerId(Killer), death_reason = DeathReason, weapon = Weapon })
				TriggerServerEvent('frp-ambulance:death', GetPlayerServerId(PlayerId()), Weapon)
                    print(Weapon)
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
			Weapon = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Wait(1000)
		end
	end
end)

