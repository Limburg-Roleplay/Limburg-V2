Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
		local playerPed = GetPlayerPed(-1)
        local animDict = "missminuteman_1ig_2"
        local animName = "handsup_enter"

        if IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
            DisableControlAction(0, 25, true) -- Disable aiming
           	DisableControlAction(0, 24, true) -- Disable attacking
			DisablePlayerFiring(playerPed, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuOpen then
            local playerPed = PlayerPedId()
            if IsPlayerFreeAiming(PlayerId()) then  -- If player is aiming
                local weaponHash = GetSelectedPedWeapon(playerPed)
                -- Check if player is holding a firearm (not melee weapon)
                if IsWeaponValid(weaponHash) and not IsMeleeWeapon(weaponHash) then
                    DisableControlAction(0, 140, true) -- Disable melee attack (R)
                    DisableControlAction(0, 141, true) -- Disable melee alternative
                    DisableControlAction(0, 142, true) -- Disable melee alternative
                end
            end
        end
    end
end)

-- Function to detect if the player is using a melee weapon
function IsMeleeWeapon(weaponHash)
    local meleeWeapons = {
        GetHashKey('WEAPON_KNIFE'),
        GetHashKey('WEAPON_BAT'),
        GetHashKey('WEAPON_CROWBAR'),
        GetHashKey('WEAPON_GOLFCLUB'),
        GetHashKey('WEAPON_HAMMER'),
        GetHashKey('WEAPON_BOTTLE'),
        GetHashKey('WEAPON_UNARMED'),
        GetHashKey('WEAPON_SWITCHBLADE'),
        GetHashKey('WEAPON_KNUCKLEDUSTER'),
        GetHashKey('WEAPON_NIGHTSTICK')
    }

    for _, hash in pairs(meleeWeapons) do
        if weaponHash == hash then
            return true
        end
    end

    return false
end