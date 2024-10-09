local bones = {
    [11816] = true,
    [58271] = true,
    [63931] = true,
    [14201] = true,
    [2108] = true,
    [65245] = true,
    [57717] = true,
    [46078] = true,
    [51826] = true,
    [36864] = true,
    [52301] = true,
    [20781] = true,
    [35502] = true,
    [24806] = true,
    [16335] = true,
    [23639] = true,
    [6442] = true,
}

Citizen.CreateThread(function()
    while true do 
        local sleep = 150
        local ped = PlayerPedId()

        if HasEntityBeenDamagedByAnyPed(ped) then 
            disarmPed(ped)
        end
        ClearEntityLastDamageEntity(ped)

        Citizen.Wait(sleep)
    end
end)

bool = function(num)
    return num == 1 or num == true
end

getDisarmOffsetsForPed = function(ped)
    local v 

    if IsPedWalking(ped) then 
        v = { 0.6, 4.7, -0.1 }
    elseif IsPedSprinting(ped) then 
        v = { 0.6, 5.7, -0.1 }
    elseif IsPedRunning(ped) then 
        v = { 0.6, 4.7, -0.1 }
    else 
        v = { 0.4, 4.7, -0.1 } 
    end

    return v
end

disarmPed = function(ped)
    if IsEntityDead(ped) then return false end

    local boneCoords 
    local hit, bone = GetPedLastDamageBone(ped)

    hit = bool(hit)

    if hit then 
        if bones[bone] then
            boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, bone))
            SetPedToRagdoll(PlayerPedId(), math.random(4000, 8000), math.random(4000, 8000), 0, 0, 0, 0)
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            return true
        end
    end

    return false
end