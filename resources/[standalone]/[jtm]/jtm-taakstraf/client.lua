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
local checkpoint = nil
local checkpointRadius = 2.0 
local warningRadius = 40
local penaltyRadius = 50 
local warningActive = false
local taskCooldown = false 

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
        
      
        createCheckpoint(checkpoints[currentCheckpointIndex])
        
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

function createCheckpoint(coords)
    if checkpoint then
        DeleteCheckpoint(checkpoint)
    end
    checkpoint = CreateCheckpoint(18, coords.x, coords.y, coords.z - 1, 90, 0, 0, checkpointRadius, 255, 0, 0, 100, 0)

end

RegisterNUICallback('completeTask', function(data, cb)
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
           
            if checkpoint then
                DeleteCheckpoint(checkpoint)
                checkpoint = nil
            end
            
            SetNuiFocus(false, false)
            SendNUIMessage({
                type = "hide"
            })
            TriggerServerEvent('communityService:completeService')
        else
            
            createCheckpoint(checkpoints[currentCheckpointIndex])
        end

        
        Citizen.SetTimeout(1000, function() 
            taskCooldown = false 
        end)
    else
        print("Task on cooldown or no tasks left.")
    end
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if tasksLeft > 0 then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - checkpoints[currentCheckpointIndex])
            
            if distance < checkpointRadius then
                DisplayHelpText("Press ~INPUT_CONTEXT~ to complete a task.")
                
                if IsControlJustReleased(1, 51) then -- 51 is the control index for 'E'
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
                    SendNUIMessage({
                        type = "warning",
                        message = "Warning: You are leaving the designated area!"
                    })
                    warningActive = true
                end
            else
                -- Teleport back with penalty
                tasksLeft = tasksLeft + 5
                SendNUIMessage({
                    type = "penalty",
                    message = "You have left the designated area! +10 tasks added.",
                    tasksLeft = tasksLeft
                })
                SetEntityCoords(PlayerPedId(), checkpoints[currentCheckpointIndex].x, checkpoints[currentCheckpointIndex].y, checkpoints[currentCheckpointIndex].z)
                SetEntityHeading(PlayerPedId(), 52.6812)
                FreezeEntityPosition(playerPed, true)
                Citizen.Wait(3000) -- Freeze for 3 seconds per task
                FreezeEntityPosition(playerPed, false)
                SetNuiFocus(false, false)

               
                TriggerServerEvent('communityService:updateTasks', tasksLeft)
            end
        end
    end
end)

function freezePlayerForTask()
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    local freezeDuration = math.random(3000, 5000) -- Freeze for 3 to 5 seconds
    Citizen.Wait(freezeDuration)
    FreezeEntityPosition(playerPed, false)
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
    local animationDuration = math.random(3000, 5000) -- 3 to 5 seconds
    Citizen.Wait(animationDuration)
    ClearPedTasks(playerPed)
end

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

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
            
            if checkpoint then
                DeleteCheckpoint(checkpoint)
                checkpoint = nil
            end
            
            SetNuiFocus(false, false)
            SendNUIMessage({
                type = "hide"
            })
            TriggerServerEvent('communityService:completeService')
        else
            
            createCheckpoint(checkpoints[currentCheckpointIndex])
        end

       
        TriggerServerEvent('communityService:updateTasks', tasksLeft)

       
        Citizen.SetTimeout(1000, function() 
            taskCooldown = false 
        end)
    else
        print("Task on cooldown or no tasks left.")
    end
end)

RegisterNetEvent('jtm-taakstraf:afgerond')
AddEventHandler('jtm-taakstraf:afgerond', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "hide"
    })

     tasksLeft = 0

    TriggerServerEvent('communityService:updateTasks', tasksLeft)
    TriggerServerEvent('communityService:completeService')
end)
