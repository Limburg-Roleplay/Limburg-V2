local PlayerData = {}

local loop = false
local eventLoop = false
local cop = false
local master = true
local FP = false
local inair = false
local inveh = false
local point = false

local function initPoint(data)
    CreateThread(function()
        while point do
            if data.hash ~= `WEAPON_SNIPERRIFLE` and data.hash ~= `WEAPON_HEAVYSNIPER` and data.hash ~= `WEAPON_HEAVYSNIPER_MK2` then
                HideHudComponentThisFrame(14)
            end
            Wait(1)
        end
    end)
end

AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    if weapon ~= nil then
        initPoint(weapon)
        point = true
        if master then
            if not loop then
                loop = true
                TriggerEvent('shyWeaponlogic:initLoop', weapon)
                if not eventLoop and Config.Recoil[weapon.hash] then
                    eventLoop = true
                    TriggerEvent('shyWeaponlogic:weaponEvents', weapon)
                end
            end
        else 
            loop = false
            if not eventLoop and Config.Recoil[weapon.hash] then
                eventLoop = true
                TriggerEvent('shyWeaponlogic:weaponEvents', weapon)
            end
        end
    else 
        loop = false
        eventLoop = false
        point = false
    end
end)

RegisterNetEvent('shyWeaponlogic:toggle')
AddEventHandler('shyWeaponlogic:toggle', function(bool)
    if bool then 
        master = true
    else
        master = false
    end
end)

RegisterNetEvent('shyWeaponlogic:weaponEvents')
AddEventHandler('shyWeaponlogic:weaponEvents', function(data)
    local shooting = exports['shy_skills']:getShooting()
    local shootFactor = 1 - (shooting/400)
    while eventLoop do
        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            if GetFollowPedCamViewMode() ~= 4 then
                SetFollowPedCamViewMode(4)
            end
            if Config.Recoil[data.hash] then
                ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', Config.Recoil[data.hash].shake * shootFactor)
                local xPitched = 0
                repeat
                    Citizen.Wait(0)
                    local pitch = GetGameplayCamRelativePitch()
                    SetGameplayCamRelativePitch(pitch + 0.1, 1.0)
                    xPitched = xPitched + 0.1
                until xPitched >= Config.Recoil[data.hash].factor * shootFactor
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    local sleep = 5
    local DB = false
    local show = false
    while true do
        local ped = PlayerPedId()
        local id = PlayerId()

        SetPlayerTargetingMode(3)
        DisableControlAction(1, 104)
        DisableControlAction(1, 140)

        if not IsPedInAnyVehicle(ped) then
            sleep = 4
            local viewmode = GetFollowPedCamViewMode()

            if GetProfileSetting(758) == 1 then
                DisablePlayerFiring(id, true)
                DisableControlAction(1, 24)
                DisableControlAction(1, 25)
                if not show then
                    lib.showTextUI("Zet Toggle Aim uit om je controls te unlocken.")
                    show = true
                end
            else
                DisablePlayerFiring(id, false)
                if show then
                    lib.hideTextUI()
                    show = false
                end
            end

            if not FP and IsControlPressed(1, 25) and viewmode ~= 4 then
                SetFollowPedCamViewMode(4)
                FP = true
            end

		    if IsControlJustPressed(1, 25) and viewmode ~= 4 then
		    	SetFollowPedCamViewMode(4)
                FP = true
		    elseif IsControlJustReleased(1, 25) then
		    	SetFollowPedCamViewMode(0)
                FP = false
		    end
            
            if IsControlPressed(1, 25) then
		    	DisableControlAction(1, 0)
                EnableControlAction(1, 24, true)
            else
                DisableControlAction(1, 24)
            end

            if IsPedArmed(ped, 4) then
                DisableControlAction(1, 141)
                DisableControlAction(1, 142)
            end
            
            if inair and not cop then
                inair = false
                TriggerServerEvent('shyWeaponlogic:leftAirspace', cops)
            end

            if inveh then
                inveh = false
                TriggerServerEvent('shyWeaponlogic:leftVehicle')
            end
        else
            local veh = GetVehiclePedIsIn(ped, false)
            local class = GetVehicleClass(veh)
            if not inveh then
                inveh = true
                TriggerServerEvent('shyWeaponlogic:enteredVehicle')
            end
            if class < 15 or class > 16 then
                sleep = 100
                if GetPedInVehicleSeat(veh, -1) == ped or GetEntitySpeed(veh) > 40 then
                    DB = false
                elseif heading() and GetFollowVehicleCamViewMode() == 4 then
                    DB = true
                else
                    DB = false
                end
                if inair and not cop then
                    inair = false
                    TriggerServerEvent('shyWeaponlogic:leftAirspace')
                end
            elseif not inair and not cop then
                sleep = 4
                DB = true
                inair = true
                TriggerServerEvent('shyWeaponlogic:joinedAirspace')
            end
            SetPlayerCanDoDriveBy(id, DB)
            SetPedConfigFlag(ped, 184, true)
        end
        Citizen.Wait(sleep)
    end
end)

AddEventHandler("onResourceStop", function(name) 
    if name ~= GetCurrentResourceName() then return end
    PlayerData = {}
    loop = false
    eventLoop = false
    cop = false
    master = true
end)

exports("inFP", function()
    return FP
end)