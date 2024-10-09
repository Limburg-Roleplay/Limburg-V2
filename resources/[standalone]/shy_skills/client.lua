ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end

    while not ESX.PlayerLoaded do
        Wait(0)
    end
end)


local skillValues = {
    strength = 0,
    stamina = 0,
    shooting = 0,
    driving = 0,
    flying = 0,
    drugs = 0
}

exports('getStrength', function() return skillValues.strength end)
exports('getStamina', function() return skillValues.stamina end)
exports('getShooting', function() return skillValues.shooting end)
exports('getDriving', function() return skillValues.driving end)
exports('getFlying', function() return skillValues.flying end)
exports('getDrugs', function() return skillValues.drugs end)

local function EnableGui(enable)
    SendNUIMessage({
        type = "enableui",
        enable = enable,
        stamina = skillValues.stamina,
        strength = skillValues.strength,
        driving = skillValues.driving,
        shooting = skillValues.shooting,
        flying = skillValues.flying,
        drugs = skillValues.drugs
    })
end

RegisterCommand('+showskills', function()
    EnableGui(true)
    SetBigmapActive(true, false)
end, false)

RegisterCommand('-showskills', function()
    EnableGui(false)
    SetBigmapActive(false, false)
end, false)

RegisterKeyMapping("+showskills", "Bekijk je skills", "keyboard", "Z")

local function showNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, true)
end

RegisterNetEvent('shySkills:sendPlayerSkills')
AddEventHandler('shySkills:sendPlayerSkills', function(data, skillImproved, improvement)
    if data.strength and data.stamina and data.shooting and data.driving and data.flying and data.drugs then
        skillValues = {
            strength = data.strength,
            stamina = data.stamina,
            shooting = data.shooting,
            driving = data.driving,
            flying = data.flying,
            drugs = data.drugs
        }

        -- Define round function if not already defined
        local function round(num, numDecimalPlaces)
            local mult = 10^(numDecimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end

        StatSetInt("MP0_STRENGTH", round(skillValues.strength, 2), true)
        StatSetInt("MP0_STAMINA", round(skillValues.stamina, 2), true)
        StatSetInt('MP0_LUNG_CAPACITY', round(skillValues.stamina, 2), true)
        StatSetInt('MP0_WHEELIE_ABILITY', round(skillValues.driving, 2), true)
        StatSetInt('MP0_DRIVING_ABILITY', round(skillValues.driving, 2), true)
        StatSetInt('MP0_FLYING_ABILITY', round(skillValues.flying, 2), true)

        if skillImproved then
            local message = "Je bent " .. improvement .. "% beter geworden in " .. skillImproved .. "."
            exports["frp-notifications"]:Notify("success", message, 5000)
        end

        -- Trigger the UI update
        SendNUIMessage({
            type = "updateSkills",
            skills = skillValues
        })
    else
        print("Error: Missing skill data.")
    end
end)

RegisterNetEvent('shyBaselogic:eVehicle')
AddEventHandler('shyBaselogic:eVehicle', function()
    local drivingTimer = 0
    local flyingTimer = 0
    local ped = PlayerPedId()
    while IsPedInAnyVehicle(ped, false) do
        local vehicle = GetVehiclePedIsUsing(ped)
        if vehicle ~= 0 and GetEntitySpeed(vehicle) > 1.0 then
            local class = GetVehicleClass(vehicle)
            if class ~= 15 and class ~= 16 then
                drivingTimer = drivingTimer + 1
                if drivingTimer >= 60 then
                    TriggerServerEvent('shySkills:addDriving', GetPlayerServerId(PlayerId()))
                    StatSetInt('MP0_WHEELIE_ABILITY', round(skillValues.driving), true)
                    StatSetInt('MP0_DRIVING_ABILITY', round(skillValues.driving), true)
                    drivingTimer = 0
                end
            else
                flyingTimer = flyingTimer + 1
                if flyingTimer >= 60 then
                    TriggerServerEvent('shySkills:addFlying', GetPlayerServerId(PlayerId()))
                    StatSetInt('MP0_FLYING_ABILITY', round(skillValues.flying), true)
                    flyingTimer = 0
                end
            end
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            local randomChance = math.random(1, 100)
            if randomChance == 1 then
                ESX.ShowNotification('success', 'Je bent Beter geworden in schieten!')
                TriggerServerEvent('shySkills:addShooting', GetPlayerServerId(PlayerId()))
            end
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)


RegisterNUICallback('requestPlayerSkills', function(data, cb)
    print("NUI callback received for player:", source) -- Log the NUI callback
    TriggerServerEvent('shySkills:requestPlayerSkillsSV')
    cb({ status = 'ok' })
end)

local gymData = {}
local canExercise, exercising, procent, motionProcent, doingMotion, motionTimesDone, cooldown = false, false, 0, 0, false, 0, 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

CreateThread(function()
    while not ESX.PlayerLoaded do Wait(0) end
    PlayerData = ESX.PlayerData
    gymData['stamina'] = PlayerData.stamina
    gymData['strength'] = PlayerData.strength
    StatSetInt('MP0_STAMINA', gymData['stamina'], true)
    StatSetInt('MP0_STRENGHT', gymData['strength'], true)

    for i=1, #Config.Blips do 
        Config.Blips[i]['blipId'] = AddBlipForCoord(Config.Blips[i]['coords'])
        SetBlipSprite(Config.Blips[i]['blipId'], Config.Blips[i]['sprite'])
        SetBlipDisplay(Config.Blips[i]['blipId'], 4)
        SetBlipScale(Config.Blips[i]['blipId'], Config.Blips[i]['scale'])
        SetBlipColour(Config.Blips[i]['blipId'], Config.Blips[i]['colour'])
        SetBlipAsShortRange(Config.Blips[i]['blipId'], true)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blips[i]['drawText'])
        EndTextCommandSetBlipName(Config.Blips[i]['blipId'])
    end

    for i=1, #Config.Locations do  
        exports.ox_target:addBoxZone({
            coords = Config.Locations[i]['coords'],
            size = Config.Locations[i]['size'],
            options = {
                {
                    name = Config.Locations[i]['drawText'] .. ':' .. i,
                    onSelect = function(data)
                        if exercising then return end
                        if not Config.Locations[i]['args']['type'] then 
                            TriggerEvent(Config.Locations[i]['event'])
                        else 
                            TriggerEvent(Config.Locations[i]['event'], Config.Locations[i]['args']['animType'], Config.Locations[i]['args']['type'], i)
                        end
                    end,
                    icon = Config.Locations[i]['icon'],
                    distance = Config.Locations[i]['distance'],
                    label = Config.Locations[i]['drawText'],
                }
            }
        })
    end
end)

local poly = lib.zones.poly({
    points = {
        vec3(293.0, -269.0, 54.0),
        vec3(281.0, -264.0, 54.0),
        vec3(260.04998779297, -255.94999694824, 54.0),
        vec3(237.0, -248.0, 54.0),
        vec3(225.0, -280.0, 54.0),
        vec3(218.5, -289.0, 54.0),
        vec3(279.0, -310.0, 54.0),
    },
    thickness = 40.85,
    debug = false,
    inside = inside,
    onEnter = function()
        TriggerServerEvent('frp-gym:srv:gym', true)
    end,
    onExit = function()
        TriggerServerEvent('frp-gym:srv:gym', false)
    end,
})


RegisterNetEvent('frp-gym:cl:data')
AddEventHandler('frp-gym:cl:data', function(indexId, bool)
    Config.Locations[indexId]['isBusy'] = bool
end)

RegisterNetEvent('frp-gym:client:train')
AddEventHandler('frp-gym:client:train', function(animType, gymType, indexId)
    -- Assuming cooldown and procent are defined somewhere globally
    if cooldown > 5 then 
        exports['frp-notifications']:notify('error', 'Je hebt een cooldown, wacht nog ' .. cooldown .. ' seconden.') 
        return 
    end

    if Config.Locations[indexId]['isBusy'] then 
        exports['frp-notifications']:notify('error', 'Er is al iemand bezig hier, probeer het later opnieuw!') 
        return 
    end

    TriggerServerEvent('frp-gym:srv:data', indexId, true)

    if animType ~= 'weights' then
        loadAnimDict(Config.Animations[animType]['idleDict'])
        loadAnimDict(Config.Animations[animType]['enterDict'])
        loadAnimDict(Config.Animations[animType]['exitDict'])
        loadAnimDict(Config.Animations[animType]['actionDict'])
        if Config.Animations[animType]['freeze'] then 
            FreezeEntityPosition(PlayerPedId(), true)
        end
    end

    if Config.Locations[indexId]['activityCoords'] then 
        SetEntityCoords(PlayerPedId(), Config.Locations[indexId]['activityCoords']['x'], Config.Locations[indexId]['activityCoords']['y'], Config.Locations[indexId]['activityCoords']['z'] - 1.0)
        SetEntityHeading(PlayerPedId(), Config.Locations[indexId]['activityCoords']['w'])
    end

    if Config.Animations[animType]['freeze'] then 
        FreezeEntityPosition(PlayerPedId(), true)
    end

    if animType ~= 'weights' then
        doEnterAnim(Config.Animations[animType])
    else
        ExecuteCommand('e weights')
    end

    canExercise = true
    exercising = true

    CreateThread(function()
        SendNUIMessage({
            type = 'openPlaceholder',
            text = 'Percentage: <b>' .. procent .. '%</b><br><b>[SPATIE]</b> Trainen<br><b>[DELETE]</b> Stoppen'
        })
        while exercising do
            SendNUIMessage({
                type = 'updatePlaceholder',
                text = 'Percentage: <b>' .. procent .. '%</b><br><b>[SPATIE]</b> Trainen<br><b>[DELETE]</b> Stoppen'
            })
            Wait(1000)
        end
    end)

    CreateThread(function()
        while canExercise do
            local Animation = Config.Animations[animType]
            if procent <= 99 then
                if animType ~= 'weights' then
                    restartAnimIfNeeded(Animation)
                end
                if IsControlJustPressed(0, 22) then
                    canExercise = false
                    doActionAnim(Animation)
                    addProcent(Animation['actionProcent'], Animation['actionProcentTimes'], Animation['actionTime'] - 70)
                    canExercise = true
                end
                if IsControlJustPressed(0, 178) then
                    exitTraining(Animation)
                    ExecuteCommand('e c')
                    SendNUIMessage({
                        type = 'closePlaceholder'
                    })
                    TriggerServerEvent('frp-gym:srv:data', indexId, false)
                    exercising = false
                end
            else
                Wait(1000)
                exitTraining(Animation)
                ExecuteCommand('e c')
                SendNUIMessage({
                    type = 'closePlaceholder'
                })
                if gymType == 'stamina' then
                    ESX.ShowNotification('success', 'Je uithoudingsvermogen is verbeterd!')
                    TriggerServerEvent('shySkills:addStamina', GetPlayerServerId(PlayerId()))
                elseif gymType == 'strength' then
                    ESX.ShowNotification('success', 'Je bent sterker geworden!')
                    TriggerServerEvent('shySkills:addStrength', GetPlayerServerId(PlayerId()))
                end
                exercising = false
            end
            Wait(0)
        end
    end)
end)



RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
end)

addProcent = function(amount, amountTimes, time)
    for i=1, amountTimes do
        Citizen.Wait(time/amountTimes)
        procent = procent + amount
        if procent > 100 then
            procent = 100
        end
    end
end

doActionAnim = function(anim)
    if anim.actionDict and anim.actionAnim then
        TaskPlayAnim(PlayerPedId(), anim.actionDict, anim.actionAnim, 8.0, -8.0, anim.actionTime, 0, 0.0, 0, 0, 0)
    end
    if anim.dpActionAnim then
        dpEmotes.StartEmote(anim.dpActionAnim)
    end
end

doEnterAnim = function(anim)
    if anim.dpEnterAnim then
        dpEmotes.StartEmote(anim.dpEnterAnim)
    end
    if anim.enterDict and anim.enterAnim then
        TaskPlayAnim(PlayerPedId(), anim.enterDict, anim.enterAnim, 8.0, -8.0, anim.enterTime, 0, 0.0, 0, 0, 0)
    end
    if anim.enterTime then
        Citizen.Wait(anim.enterTime)
    end
end

exitTraining = function(anim)
    canExercise = false
    exercising = false
    procent = 0
    currentAnim = nil
    FreezeEntityPosition(PlayerPedId(), false)

    if anim.exitDict and anim.exitAnim then
        TaskPlayAnim(PlayerPedId(), anim.exitDict, anim.exitAnim, 8.0, -8.0, anim.exitTime, 0, 0.0, 0, 0, 0)
    end
    if currentAnim then
        dpEmotes.CancelEmote()
    end
    if anim.dpExitAnim then
        dpEmotes.StartEmote(anim.dpExitAnim)
    end
    if anim.exitTime then
        Citizen.Wait(anim.exitTime)
    end
end

restartAnimIfNeeded = function(anim)
    if anim.idleAnim and anim.idleDict then
        if not IsEntityPlayingAnim(PlayerPedId(), anim.idleDict, anim.idleAnim, 3) then
            TaskPlayAnim(PlayerPedId(), anim.idleDict, anim.idleAnim, 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
        end
    end
    if anim.dpIdleAnim then
        dpEmotes.StartEmote(anim.dpIdleAnim)
    end
end

loadAnimDict = function(dict)
    if not dict then return end
    if not DoesAnimDictExist(dict) then
        error(("Anim dict %s doesn't exist!"):format(dict))
    end
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Citizen.Wait(50) end
end

drawText2D = function(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

round = function(num, numDecimalPlaces) 
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

Citizen.CreateThread(function()
    while not ESX.PlayerLoaded do Wait(0) end
    while true do
        Citizen.Wait(10 * 60000) -- 10 min
        if not gymData['strength'] then return end

        if gymData["strength"] >= 1 then
            gymData["strength"] = gymData["strength"] - 1
            StatSetInt('MP0_STRENGHT', gymData['strength'], true)
            TriggerServerEvent('frp-gym:srv:add:strength', gymData["strength"])
        end

        if gymData["stamina"] >= 1 then
            gymData["stamina"] = gymData["stamina"] - 1
            StatSetInt('MP0_STAMINA', gymData['stamina'], true)
            TriggerServerEvent('frp-gym:srv:add:stamina', gymData["stamina"])
        end
    end
end) -- Closing parenthesis added here
