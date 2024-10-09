local Action = {
    name = "",
    duration = 0,
    label = "",
    useWhileDead = false,
    canCancel = true,
	disarm = true,
    controlDisables = { disableMovement = false, disableCarMovement = false, disableMouse = false, disableCombat = false, },
    animation = { animDict = nil, anim = nil, flags = 0, task = nil, },
    prop = { model = nil, bone = nil, coords = { x = 0.0, y = 0.0, z = 0.0 }, rotation = { x = 0.0, y = 0.0, z = 0.0 }, },
    propTwo = { model = nil, bone = nil, coords = { x = 0.0, y = 0.0, z = 0.0 }, rotation = { x = 0.0, y = 0.0, z = 0.0 }, },
}

local isDoingAction, disableMouse, wasCancelled = false, false, false
local isAnim, isProp, isPropTwo = false, false, false
local prop_net, propTwo_net = nil, nil

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('progressbar/client/toggle-busy', function(Bool)
    isDoingAction = Bool
end)

RegisterNetEvent("progressbar/client/progress", function(Action, Finish)
	Process(Action, nil, nil, Finish)
end)

RegisterNetEvent("progressbar/client/ProgressWithStartEvent", function(Action, Start, Finish)
	Process(Action, Start, nil, Finish)
end)

RegisterNetEvent("progressbar/client/ProgressWithTickEvent", function(Action, Tick, Finish)
	Process(Action, nil, Tick, Finish)
end)

RegisterNetEvent("progressbar/client/ProgressWithStartAndTick", function(Action, Start, Tick, Finish)
	Process(Action, Start, Tick, Finish)
end)

RegisterNetEvent("progressbar/client/cancel", function()
	Cancel()
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('FinishAction', function(data, cb)
	Finish()
end)

exports('isBusy', function()
    return isDoingAction
end)

-- [ Functions ] --

function Process(action, start, tick, finish)
	ActionStart()
    Action = action
    if not IsEntityDead(PlayerPedId()) or Action.useWhileDead then
        if not isDoingAction then
            isDoingAction = true
            wasCancelled = false
            isAnim = false
            isProp = false
            SendNUIMessage({
                action = "start",
                duration = Action.duration,
                label = Action.label
            })
            Citizen.CreateThread(function ()
                if start ~= nil then
                    start()
                end
                while isDoingAction do
                    Citizen.Wait(1)
                    local ped = PlayerPedId()
                    if tick ~= nil then
                        tick()
                    end
                    if IsControlJustPressed(0, Config.Settings['CancelKey']) and Action.canCancel then
                        TriggerEvent("progressbar/client/cancel")
                    end
                    if IsEntityDead(ped) and not Action.useWhileDead then
                        TriggerEvent("progressbar/client/cancel")
                    end
                    if isAnim then
                        if action.animation then
                            if not IsEntityPlayingAnim(ped, action.animation.animDict, action.animation.anim, 3) then
                                ClearPedTasks(ped)
                                RequestAnimationDict(action.animation.animDict)
                                TaskPlayAnim(ped, action.animation.animDict, action.animation.anim, 3.0, 3.0, -1, action.animation.flags, 0, 0, 0, 0 )   
                            end
                        end
                    end
                end
                if finish ~= nil then
                    finish(wasCancelled)
                end
            end)
        else
            ESX.ShowNotification('error', 'Je bent al met iets bezig!', 3500)
        end
    else
        ESX.ShowNotification('error', 'Kan actie niet uitvoeren!', 3500)
    end
end


function RequestModelHash(Model)
    RequestModel(Model)
    while not HasModelLoaded(Model) do
        Wait(1)
    end
end

function RequestAnimationDict(AnimDict)
    RequestAnimDict(AnimDict)
    while not HasAnimDictLoaded(AnimDict) do
        Citizen.Wait(1)
    end
end

function ActionStart()
    runProgThread = true
    Citizen.CreateThread(function()
        while runProgThread do
            if isDoingAction then
                if not isAnim then
                    if Action.animation ~= nil then
                        if Action.animation.task ~= nil then
                            TaskStartScenarioInPlace(PlayerPedId(), Action.animation.task, 0, true)
                        elseif Action.animation.animDict ~= nil and Action.animation.anim ~= nil then
                            if Action.animation.flags == nil then
                                Action.animation.flags = 1
                            end

                            local player = PlayerPedId()
                            if (DoesEntityExist(player) and not IsEntityDead(player)) then
                                RequestAnimationDict(Action.animation.animDict)
                                TaskPlayAnim(player, Action.animation.animDict, Action.animation.anim, 3.0, 3.0, -1, Action.animation.flags, 0, 0, 0, 0 )     
                            end
                        end
                    end
                    isAnim = true
                end
                if not isProp and Action.prop ~= nil and Action.prop.model ~= nil then
                    RequestModel(Action.prop.model)
                    RequestModelHash(GetHashKey(Action.prop.model))
                    local pCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
                    local modelSpawn = CreateObject(GetHashKey(Action.prop.model), pCoords.x, pCoords.y, pCoords.z, true, true, true)
                    SetNetworkIdExistsOnAllMachines(netid, true)
                    NetworkSetNetworkIdDynamic(netid, true)
                    SetNetworkIdCanMigrate(netid, false)
                    if Action.prop.bone == nil then
                        Action.prop.bone = 60309
                    end
                    if Action.prop.coords == nil then
                        Action.prop.coords = { x = 0.0, y = 0.0, z = 0.0 }
                    end

                    if Action.prop.rotation == nil then
                        Action.prop.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                    end
                    AttachEntityToEntity(modelSpawn, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), Action.prop.bone), Action.prop.coords.x, Action.prop.coords.y, Action.prop.coords.z, Action.prop.rotation.x, Action.prop.rotation.y, Action.prop.rotation.z, 1, 1, 0, 1, 0, 1)
                    prop_net = modelSpawn
                    isProp = true
                
                    if not isPropTwo and Action.propTwo ~= nil and Action.propTwo.model ~= nil then
                        RequestModel(Action.propTwo.model)

                        while not HasModelLoaded(GetHashKey(Action.propTwo.model)) do
                            Citizen.Wait(0)
                        end

                        local pCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
                        local modelSpawn = CreateObject(GetHashKey(Action.propTwo.model), pCoords.x, pCoords.y, pCoords.z, true, true, true)

                        SetNetworkIdExistsOnAllMachines(netid, true)
                        NetworkSetNetworkIdDynamic(netid, true)
                        SetNetworkIdCanMigrate(netid, false)
                        if Action.propTwo.bone == nil then
                            Action.propTwo.bone = 60309
                        end

                        if Action.propTwo.coords == nil then
                            Action.propTwo.coords = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        if Action.propTwo.rotation == nil then
                            Action.propTwo.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        AttachEntityToEntity(modelSpawn, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), Action.propTwo.bone), Action.propTwo.coords.x, Action.propTwo.coords.y, Action.propTwo.coords.z, Action.propTwo.rotation.x, Action.propTwo.rotation.y, Action.propTwo.rotation.z, 1, 1, 0, 1, 0, 1)
                        propTwo_net = modelSpawn

                        isPropTwo = true
                    end
                end
                DisableActions()
            end
            Citizen.Wait(0)
        end
    end)
end

function Progress(action, finish)
	Process(action, nil, nil, finish)
end

function ProgressWithStartEvent(action, start, finish)
	Process(action, start, nil, finish)
end

function ProgressWithTickEvent(action, tick, finish)
	Process(action, nil, tick, finish)
end

function ProgressWithStartAndTick(action, start, tick, finish)
	Process(action, start, tick, finish)
end

function Cancel()
    isDoingAction = false
    wasCancelled = true
    ActionCleanup()
    SendNUIMessage({
        action = "cancel"
    })
end

function Finish()
    isDoingAction = false
    ActionCleanup()
end

function ActionCleanup()
    if Action.animation ~= nil then
        if Action.animation.task ~= nil or (Action.animation.animDict ~= nil and Action.animation.anim ~= nil) then
            ClearPedSecondaryTask(PlayerPedId())
            StopAnimTask(PlayerPedId(), Action.animDict, Action.anim, 1.0)
        else
            ClearPedTasks(PlayerPedId())
        end
    end
    EnableControlAction(0, 24, true)
    EnableControlAction(0, 25, true)
    DisablePlayerFiring(PlayerId(), false) 
    NetworkRequestControlOfEntity(prop_net)
    SetEntityAsMissionEntity(prop_net, true, true)
    DetachEntity(prop_net, 1, 1)
    DeleteEntity(prop_net)
    DeleteObject(prop_net)
    NetworkRequestControlOfEntity(propTwo_net)
    SetEntityAsMissionEntity(propTwo_net, true, true)
    DetachEntity(propTwo_net, 1, 1)
    DeleteEntity(propTwo_net)
    DeleteObject(propTwo_net)
    prop_net = nil
    propTwo_net = nil
    runProgThread = false
end

function DisableActions()
    if Action.controlDisables.disableMouse then
        DisableMouseControls()
    end

    if Action.controlDisables.disableMovement then
        DisableMovementControls()
    end

    if Action.controlDisables.disableCarMovement then
        DisableCarMovementControls()
    end

    if Action.controlDisables.disableCombat then
        DisableCombatControls()
    end
end

function DisableMouseControls()
    DisableControlAction(0, 1, true) -- LookLeftRight
    DisableControlAction(0, 2, true) -- LookUpDown
    DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
end

function DisableMovementControls()
    DisableControlAction(0, 30, true) -- disable left/right
    DisableControlAction(0, 36, true) -- Left CTRL
    DisableControlAction(0, 31, true) -- disable forward/back
    DisableControlAction(0, 36, true) -- INPUT_DUCK
    DisableControlAction(0, 21, true) -- disable sprint
    DisableControlAction(0, 75, true)  -- Disable exit vehicle
    DisableControlAction(27, 75, true) -- Disable exit vehicle 
end

function DisableCarMovementControls()
    DisableControlAction(0, 63, true) -- veh turn left
    DisableControlAction(0, 64, true) -- veh turn right
    DisableControlAction(0, 71, true) -- veh forward
    DisableControlAction(0, 72, true) -- veh backwards
    DisableControlAction(0, 75, true) -- disable exit vehicle
end

function DisableCombatControls()
    DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
    DisableControlAction(0, 24, true) -- disable attack
    DisableControlAction(0, 25, true) -- disable aim
    DisableControlAction(1, 37, true) -- disable weapon select
    DisableControlAction(0, 47, true) -- disable weapon
    DisableControlAction(0, 58, true) -- disable weapon
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee
    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
end

function GetTaskBarStatus()
    return isDoingAction
end
