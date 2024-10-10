ESX = exports["es_extended"]:getSharedObject()

local tasksLeft = 0
local checkpoints = {
    vector3(1648.6382, 2589.7495, 45.5649),
    vector3(1636.3724, 2596.9302, 45.5649),
    vector3(1634.9235, 2616.3140, 45.5649),
    vector3(1649.7043, 2623.7151, 45.5649),
    vector3(1659.9852, 2614.6851, 45.5649),
    vector3(1651.4513, 2602.1853, 45.5649)
}
local currentCheckpointIndex = 1
local previousCheckpointIndex = nil
local checkpointRadius = 2.0 
local warningRadius = 40
local penaltyRadius = 50 
local warningActive = false
local taskCooldown = false 
local markerActive = false

-- ################################
-- THREADS
-- ################################
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if tasksLeft > 0 and markerActive then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - checkpoints[currentCheckpointIndex])

            ESX.DrawBasicMarker({
                x = checkpoints[currentCheckpointIndex].x,
                y = checkpoints[currentCheckpointIndex].y,
                z = checkpoints[currentCheckpointIndex].z,
                type = 1,
                color = {r = 255, g = 0, b = 0},
                scale = {x = 1.5, y = 1.5, z = 1.5},
                alpha = 100
            })

            if distance < checkpointRadius then
                DisplayHelpText("Press ~INPUT_CONTEXT~ to complete a task.")

                if IsControlJustReleased(1, 51) then
                    TriggerEvent('communityService:completeTask')
                end
            elseif distance < warningRadius then
                if warningActive then
                    SendNUIMessage({
                        type = "updateTasks",
                        tasksLeft = tasksLeft
                    })
                    warningActive = false
                end
            elseif distance < penaltyRadius then
                if not warningActive then
                    warningActive = true
                    exports['okokNotify']:Alert('Pas op!', 'Je loopt te ver weg van het takenpleintje, er komen zo 5 taken bij.', 15000, 'warning')
                end
            else
                tasksLeft = tasksLeft + 5
                exports['okokNotify']:Alert('Fout', 'Je bent te ver weg gelopen, er zijn nu 5 taken bij gekomen.', 5000, 'error')

                SetEntityCoords(PlayerPedId(), checkpoints[currentCheckpointIndex].x, checkpoints[currentCheckpointIndex].y, checkpoints[currentCheckpointIndex].z)
                SetEntityHeading(PlayerPedId(), 52.6812)
                freezePlayerForTask()
                SetNuiFocus(false, false)

                TriggerServerEvent('communityService:updateTasks', tasksLeft)
            end
        end
    end
end)

-- ################################
-- EVENTS
-- ################################
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerServerEvent('communityService:checkTasks')
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    TriggerServerEvent('communityService:checkTasks')
end)

RegisterNetEvent('communityService:assignTasks')
AddEventHandler('communityService:assignTasks', function(tasks, reason, staffMember)
    if tasks then
        tasksLeft = tasks
        
        repeat
            currentCheckpointIndex = math.random(1, #checkpoints)
        until currentCheckpointIndex ~= previousCheckpointIndex
        previousCheckpointIndex = currentCheckpointIndex

        SetEntityCoords(PlayerPedId(), checkpoints[currentCheckpointIndex].x, checkpoints[currentCheckpointIndex].y, checkpoints[currentCheckpointIndex].z)
        SetEntityHeading(PlayerPedId(), 52.6812)

        markerActive = true
        
        SendNUIMessage({
            type = "show",
            tasksLeft = tasksLeft,
            tasksGiven = tasks,
            reason = reason,
            staffMember = staffMember
        })
        SetNuiFocus(false, false)
    else
        print("Error: Invalid number of tasks received.")
    end
end)

RegisterNetEvent('communityService:completeTask')
AddEventHandler('communityService:completeTask', function()
    if tasksLeft > 0 and not taskCooldown then
        tasksLeft = tasksLeft - 1
        taskCooldown = true
        playTaskAnimation()
        freezePlayerForTask()

        SendNUIMessage({
            type = "updateTasks",
            tasksLeft = tasksLeft
        })

        repeat
            currentCheckpointIndex = math.random(1, #checkpoints)
        until currentCheckpointIndex ~= previousCheckpointIndex
        previousCheckpointIndex = currentCheckpointIndex

        if tasksLeft <= 0 then
            markerActive = false
            SetNuiFocus(false, false)
            SendNUIMessage({
                type = "hide"
            })
            TriggerServerEvent('communityService:completeService')
            exports['okokNotify']:Alert('Info', 'Je hebt je taken succesvol afgerond.', 5000, 'info')

        else
            createMarker(checkpoints[currentCheckpointIndex])
        end

        Citizen.SetTimeout(1000, function()
            taskCooldown = false
        end)
    else
        print("Task on cooldown or no tasks left.")
    end
end)

-- ################################
-- FUNCTIONS
-- ################################
function createMarker(coords)
    markerActive = true
end

function freezePlayerForTask()
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    local freezeDuration = math.random(3000, 5000)
    if lib.progressCircle({
        duration = freezeDuration,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true
    }) then FreezeEntityPosition(playerPed, false) end
end

function playTaskAnimation()
    local playerPed = PlayerPedId()
    local animationScenario = "WORLD_HUMAN_GARDENER_PLANT"
    local rand = math.random()
    if rand < 0.33 then
        animationScenario = "WORLD_HUMAN_JANITOR"
    elseif rand < 0.66 then
        animationScenario = "WORLD_HUMAN_BUM_WASH"
    end
    TaskStartScenarioInPlace(playerPed, animationScenario, 0, true)
    local animationDuration = math.random(3000, 5000)
    Citizen.Wait(animationDuration)
    ClearPedTasks(playerPed)
end

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end