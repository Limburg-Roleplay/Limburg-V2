DRM = { ['Functions'] = {}, ['Data'] = {} }
local SharedMessageSent, activeEntity, isInteracting = false, nil, false

lib.locale()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
    ESX.PlayerData = PlayerData
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
    ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
    ESX.PlayerData.job = Job
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for k, v in pairs(DRM.Data) do for _, v in pairs(v) do ESX.Game.DeleteObject(v) end end
end)

CreateThread(function()
    ESX.TriggerServerCallback('exios-drugsfarm:server:cb:get:Shared', function(table)
        Shared = table
    end)

    while not Shared do Wait(0) end

    local function showInteractionPrompt(entity, objectType)
        if not isInteracting then
            activeEntity = entity
            local v = Shared.Settings[objectType]
            lib.showTextUI(v['Target Interaction']['Label'], {
                position = "right-center",
                icon = v['Target Interaction']['Icon']
            })
        end
    end

    local function hideInteractionPrompt()
        lib.hideTextUI()
    end

    CreateThread(function()
        while true do
            local sleep = 1000
            local ped = cache.ped
            local coords = GetEntityCoords(ped)

            for k, v in pairs(Shared.Settings) do
                local closestObject = GetClosestObjectOfType(coords.x, coords.y, coords.z, 3.3, v['ObjectHash'], false, false, false)
                if DoesEntityExist(closestObject) then
                    local objectCoords = GetEntityCoords(closestObject)
                    local distance = #(coords - objectCoords)
                    if distance <= 3.3 then
                        showInteractionPrompt(closestObject, k)
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('exios-drugsfarm:client:pickupObject', {entity = closestObject}, k)
                        end
                        sleep = 0
                    else
                        hideInteractionPrompt()
                    end
                end
            end

            Wait(sleep)
        end
    end)

    while true do 
        local sleep = 2000
        local ped = cache.ped
        local distance = nil

        for k, v in pairs(Shared.Settings) do 
            if not DRM.Data[k] then DRM.Data[k] = {} end
            distance = #(GetEntityCoords(ped) - v['Coordinates'])
                if distance < 50.0 then 
                    DRM.Functions.SpawnObjects(k, v['Coordinates'])
                elseif next(DRM.Data[k]) and distance > 50.0 then
                    for k, v in pairs(DRM.Data[k]) do
                        ESX.Game.DeleteObject(v)
                    end
                    DRM.Data[k] = {}
                end
            end

        Wait(sleep)
    end
end)

local playerEventTriggers = {}

RegisterNetEvent('exios-drugsfarm:client:pickupObject')
AddEventHandler('exios-drugsfarm:client:pickupObject', function(data, objectType)
    if isInteracting then
        print("Already interacting, ignoring event")
        return
    end

    local playerId = GetPlayerServerId(PlayerId())
    local currentTime = GetGameTimer()

    if not playerEventTriggers[playerId] then
        playerEventTriggers[playerId] = {count = 0, timestamp = currentTime}
    end

    if currentTime - playerEventTriggers[playerId].timestamp < 5000 then
        playerEventTriggers[playerId].count = playerEventTriggers[playerId].count + 1
    else
        playerEventTriggers[playerId].count = 1
        playerEventTriggers[playerId].timestamp = currentTime
    end

    if playerEventTriggers[playerId].count > 3 then
        print("Banning player", playerId, "for triggering event too many times")
        return
    end

    isInteracting = true
    TaskTurnPedToFaceEntity(cache.ped, data.entity, 1.0)

    Wait(1500)

    LocalPlayer.state.invBusy = true
    FreezeEntityPosition(cache.ped, true)

    if Shared.Settings[objectType] and Shared.Settings[objectType]['Pick-Up'] then
        if Shared.Settings[objectType]['Pick-Up']['Scenario'] then 
            TaskStartScenarioInPlace(cache.ped, Shared.Settings[objectType]['Pick-Up']['Scenario'], 0, false)
        elseif Shared.Settings[objectType]['Pick-Up']['Animation'] then 
            ESX.Streaming.RequestAnimDict(Shared.Settings[objectType]['Pick-Up']['Animation']['Dict'], function()
                TaskPlayAnim(cache.ped, Shared.Settings[objectType]['Pick-Up']['Animation']['Dict'], Shared.Settings[objectType]['Pick-Up']['Animation']['Clip'], 1.0, 1.0, 3000, 33, 1, false, false, false)
            end)
        end
    else
        print("Error: Shared.Settings[objectType]['Pick-Up'] is nil. objectType:", objectType)
        isInteracting = false
        LocalPlayer.state.invBusy = false
        return
    end

    Wait(3000)

    FreezeEntityPosition(cache.ped, false)
    ClearPedTasks(cache.ped)

    Wait(1500)
    ESX.Game.DeleteObject(activeEntity)

    TriggerServerEvent('exios-drugsfarm:server:pickupObject', data.entity, objectType)

    if DRM.Data[objectType] and type(DRM.Data[objectType]) == "table" then
        if #DRM.Data[objectType] > 0 then
            DRM.Data[objectType][#DRM.Data[objectType]] = nil
        else
            print("Error: DRM.Data[objectType] table is empty. objectType:", objectType)
        end
    else
        print("Error: DRM.Data[objectType] is nil or not a table. objectType:", objectType)
    end

    isInteracting = false
    LocalPlayer.state.invBusy = false
    lib.hideTextUI()
end)