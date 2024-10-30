ESX = nil
local currentPlate = ""
local currentType = 0

local job = ""
local callsign = nil
local isLoggedIn = false

local unitCooldown = false
local alertsToggled = true
local unitBlipsToggled = true
local callBlipsToggled = true

local callBlips = {}
local jobInfo = {}
local blips = {}

Citizen.CreateThread(function()
    while ESX == nil do
        if not Config.NewESX then
            TriggerEvent("esx:getSharedObject", function(obj)
                ESX = obj
            end)
        else
            ESX = exports["es_extended"]:getSharedObject()
        end
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    job = ESX.GetPlayerData().job.name
    isLoggedIn = true

    for k, v in pairs(Config.SameDepartementJobs) do
        if k == job then
            job = v
        end
    end

    if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job then

        updateJobInfo()

        ESX.TriggerServerCallback("core_dispatch:getPersonalInfo", function(firstname, lastname)
            SendNUIMessage({
                type = "Init",
                firstname = firstname,
                lastname = lastname,
                jobInfo = jobInfo
            })
        end)
    else
        for _, z in pairs(blips) do
            RemoveBlip(z)
        end

        blips = {}
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(JobInfo)
    job = JobInfo.name

    for k, v in pairs(Config.SameDepartementJobs) do
        if k == job then
            job = v
        end
    end

    if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job then

        updateJobInfo()

        ESX.TriggerServerCallback("core_dispatch:getPersonalInfo", function(firstname, lastname)
            SendNUIMessage({
                type = "Init",
                firstname = firstname,
                lastname = lastname,
                jobInfo = jobInfo
            })
        end)
    else
        for _, z in pairs(blips) do
            RemoveBlip(z)
        end

        blips = {}
    end
end)

--------------------
-- Shooting Alert --
--------------------
local function loadPhoneAnimDict()
    if not HasAnimDictLoaded('cellphone@') then
        RequestAnimDict('cellphone@')
        while not HasAnimDictLoaded('cellphone@') do
            Citizen.Wait(5)
        end
    end
end

local searchedNPCS = false
local foundNpcs = false

Citizen.CreateThread(function()
    while Config.EnableShootingAlerts do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        local gender = IsPedMale(ped) and 'male' or 'female'
        local playerPos = GetEntityCoords(ped)
        local within = false
        local npc = nil

        if Config.WeaponWhitelisted[GetSelectedPedWeapon(ped)] or Config.JobWhitelisted[job] or
            (Config.SilencerDontTriggerAlert and IsPedCurrentWeaponSilenced(ped)) then
            goto continue
        end

        if Config.EnableShootingAlertOnAllTheMap then
            within = true
        else
            for _, v in ipairs(Config.ShootingZones) do
                local distance = #(playerPos - v.coords)
                if distance < v.radius then
                    within = true
                    break
                end
            end
        end

        if not within and Config.NPCShootingReport then
            npc = AreNPCsNearby(playerPos, Config.NPCReportRadius)
        end

        if IsPedShooting(ped) and (within or npc) then

            if npc and not Config.EnableShootingAlertOnAllTheMap then
                loadPhoneAnimDict()

                TaskPlayAnim(npc, 'cellphone@', 'cellphone_call_listen_base', 8.0, -8, -1, 49, 0, false, false, false)
                local blip = AddBlipForEntity(npc)

                CreateThread(function()
                    Citizen.Wait(Config.NPCReportTime * 1000)
                    RemoveBlip(blip)
                    if not IsPedDeadOrDying(npc, true) then
                        local npcCoords = GetEntityCoords(npc)
                        local gender = "unknown"

                        if (IsPedMale(npc)) then
                            gender = "male"
                        else
                            gender = "female"
                        end
                        exports['core_dispatch']:sendShootingAlert()
                    end
                end)
            else
                TriggerServerEvent("core_dispatch:addCall", "10-71", "Shots in area", {{
                    icon = "fa-venus-mars",
                    info = gender
                }}, {playerPos[1], playerPos[2], playerPos[3]}, Config.JobOne.job, 5000, 156, 1)
            end

            Citizen.Wait(20000)
        end

        ::continue::
    end
end)

-----------------------
-- Car jacking alert --
-----------------------
local carJackingTriggerred = false
if Config.EnableCarJackingAlert then
    AddEventHandler('CEventPedJackingMyVehicle', function(_, ped)
        if ped ~= PlayerPedId() or carJackingTriggerred then
            return
        end
        Wait(math.random(50,100))
        if not carJackingTriggerred then
            carJackingTriggerred = true

            local vehicleTrying = GetVehiclePedIsUsing(ped)

            if Config.NPCCarjackingReport  then
                local coords = GetEntityCoords(PlayerPedId())
                local npc = AreNPCsNearby(coords, Config.NPCCarjackingReportRadius)
                if npc then
                    loadPhoneAnimDict()

                    TaskPlayAnim(npc, 'cellphone@', 'cellphone_call_listen_base', 8.0, -8, -1, 49, 0, false, false, false)
                    local blip = AddBlipForEntity(npc)

                    CreateThread(function()
                        carJackingTriggerred = true
                        Citizen.Wait(Config.NPCCarjackingReportTime * 1000)
                        RemoveBlip(blip)
                        if not IsPedDeadOrDying(npc, true) then
                            local vehicleIn = GetVehiclePedIsUsing(ped)
                            if vehicleIn and vehicleIn > 0 then
                                exports['core_dispatch']:sendCarjackAlert(vehicleIn)
                            else
                                exports['core_dispatch']:sendCarjackAlert(vehicleTrying)
                            end
                            carJackingTriggerred = false
                        else
                            carJackingTriggerred = false
                        end
                    end)
                end
            else
                local random = math.random()
                if random <= Config.ChanceToGetCarjackingAlert then
                    CreateThread(function()
                        carJackingTriggerred = true
                        Citizen.Wait(Config.DefaultAlertDelayBeforeTriggering * 1000)
                        local vehicle = GetVehiclePedIsUsing(ped)
                        if vehicleIn then
                            exports['core_dispatch']:sendCarjackAlert(vehicleIn)
                        else
                            exports['core_dispatch']:sendCarjackAlert(vehicleTrying)
                        end
                        carJackingTriggerred = false
                    end)
                end
            end
        end
    end)
end

---------------------
-- Car Theft alert --
---------------------
local carTheftTriggerred = false
if Config.EnableCarTheftAlert then
    AddEventHandler('CEventShockingCarAlarm', function(_, ped) -- can be replace by CEventShockingSeenCarStolen if your server have ped and will be trigger when they see someone stole a car
        if ped ~= PlayerPedId() or carTheftTriggerred then
            return
        end
        Wait(math.random(50,100))
        if not carTheftTriggerred then
            carTheftTriggerred = true
            local vehicleTrying = GetVehiclePedIsUsing(ped)

            if Config.NPCCarTheftReport then
                local coords = GetEntityCoords(PlayerPedId())
                local npc = AreNPCsNearby(coords, Config.NPCCarTheftReportRadius)
                if npc then
                    loadPhoneAnimDict()

                    TaskPlayAnim(npc, 'cellphone@', 'cellphone_call_listen_base', 8.0, -8, -1, 49, 0, false, false, false)
                    local blip = AddBlipForEntity(npc)

                    CreateThread(function()
                        carTheftTriggerred = true
                        Wait(Config.NPCCarTheftReportTime * 1000)
                        RemoveBlip(blip)
                        if not IsPedDeadOrDying(npc, true) then
                            local vehicleIn = GetVehiclePedIsUsing(ped)
                            if vehicleIn and vehicleIn > 0 then
                                exports['core_dispatch']:sendCarTheftAlert(vehicleIn)
                            else
                                exports['core_dispatch']:sendCarTheftAlert(vehicleTrying)
                            end
                            carTheftTriggerred = false
                        else
                            carTheftTriggerred = false
                        end
                    end)
                end
            else
                local random = math.random()
                if random <= Config.ChanceToGetCarTheftAlert then
                    CreateThread(function()
                        carTheftTriggerred = true
                        Wait(Config.DefaultAlertDelayBeforeTriggering * 1000)
                        local vehicleIn = GetVehiclePedIsUsing(ped)
                        if vehicleIn and vehicleIn > 0 then
                            exports['core_dispatch']:sendCarTheftAlert(vehicleIn)
                        else
                            exports['core_dispatch']:sendCarTheftAlert(vehicleTrying)
                        end
                        carTheftTriggerred = false
                    end)
                end
            end
        end
    end)
end

function AreNPCsNearby(playerPos, radius)

    if not searchedNPCS then
        searchedNPCS = true
        local pedPool = GetGamePool('CPed')
        local foundNPC = false

        for k, npc in pairs(pedPool) do
            if #(GetEntityCoords(npc) - playerPos) < radius and not IsPedAPlayer(npc) and
                not IsPedDeadOrDying(npc, true) then
                foundNPC = npc
                break
            end
        end

        CreateThread(function()
            Citizen.Wait(Config.NPCReportTime * 1000)
            searchedNPCS = false
        end)

        foundNpcs = foundNPC
        return foundNPC

    else
        return foundNpcs
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        while ESX == nil do
            Wait(50)
        end

        job = ESX.GetPlayerData().job.name
        isLoggedIn = true

        for k, v in pairs(Config.SameDepartementJobs) do
            if k == job then
                job = v
            end
        end

        currentPlate = ""
        currentType = 0
        if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job then
            updateJobInfo()

            ESX.TriggerServerCallback("core_dispatch:getPersonalInfo", function(firstname, lastname)
                SendNUIMessage({
                    type = "Init",
                    firstname = firstname,
                    lastname = lastname,
                    jobInfo = jobInfo
                })
            end)
        end
    end
end)

RegisterKeyMapping('dispatch', "Open Dispatch using " .. Config.OpenMenuKey, "keyboard", Config.OpenMenuKey)

RegisterCommand('dispatch', function()
    openDispatch()
end, false)

RegisterCommand(Config.JobOne.callCommand, function(source, args, rawCommand)
    local msg = rawCommand:sub(string.len(Config.JobOne.callCommand) + 1)
    local cord = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("core_dispatch:addMessage", msg, {cord[1], cord[2], cord[3]}, Config.JobOne.job, 5000,
        Config.callCommandSprite, Config.callCommandColor)
end, false)

RegisterCommand(Config.JobTwo.callCommand, function(source, args, rawCommand)
    local msg = rawCommand:sub(string.len(Config.JobTwo.callCommand) + 1)
    local cord = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("core_dispatch:addMessage", msg, {cord[1], cord[2], cord[3]}, Config.JobTwo.job, 5000,
        Config.callCommandSprite, Config.callCommandColor)
end, false)

RegisterCommand(Config.JobThree.callCommand, function(source, args, rawCommand)
    local msg = rawCommand:sub(string.len(Config.JobThree.callCommand) + 1)
    local cord = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("core_dispatch:addMessage", msg, {cord[1], cord[2], cord[3]}, Config.JobThree.job, 5000,
        Config.callCommandSprite, Config.callCommandColor)
end, false)

function addBlipForCall(sprite, color, coords, text)
    local alpha = 250
    local radius = AddBlipForRadius(coords, 40.0)
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.3)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, false)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(tostring(text))
    EndTextCommandSetBlipName(blip)

    SetBlipHighDetail(radius, true)
    SetBlipColour(radius, color)
    SetBlipAlpha(radius, alpha)
    SetBlipAsShortRange(radius, true)

    table.insert(callBlips, blip)
    table.insert(callBlips, radius)

    while alpha ~= 0 do
        Citizen.Wait(Config.CallBlipDisappearInterval)
        alpha = alpha - 1
        SetBlipAlpha(radius, alpha)

        if alpha == 0 then
            RemoveBlip(radius)
            RemoveBlip(blip)

            return
        end
    end
end

function addBlipsForUnits()
    ESX.TriggerServerCallback("core_dispatch:getUnits", function(units)
        local id = GetPlayerServerId(PlayerId())

        for _, z in pairs(blips) do
            RemoveBlip(z)
        end

        blips = {}

        for k, v in pairs(units) do
            if k ~= id and (Config.JobOne.job == v.job or Config.JobTwo.job == v.job or Config.JobThree.job == v.job) then
                local color = 0
                local title = ""
                if Config.JobOne.job == v.job then
                    color = Config.JobOne.blipColor
                    title = Config.JobOne.label
                end
                if Config.JobTwo.job == v.job then
                    color = Config.JobTwo.blipColor
                    title = Config.JobTwo.label
                end
                if Config.JobThree.job == v.job then
                    color = Config.JobThree.blipColor
                    title = Config.JobThree.label
                end

                local new_blip = AddBlipForEntity(NetworkGetEntityFromNetworkId(v.netId))

                SetBlipSprite(new_blip, Config.Sprite[v.type])
                ShowHeadingIndicatorOnBlip(new_blip, true)
                HideNumberOnBlip(new_blip)
                SetBlipScale(new_blip, 0.85)
                SetBlipCategory(new_blip, 7)
                SetBlipColour(new_blip, color)
                SetBlipAsShortRange(new_blip, false)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("(" .. title .. ") " .. v.firstname .. " " .. v.lastname)
                EndTextCommandSetBlipName(new_blip)

                blips[k] = new_blip
            end
        end
    end)
end

function openDispatch()
    if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job then
        SetNuiFocus(false, false)
        ESX.TriggerServerCallback("core_dispatch:getInfo", function(units, calls, ustatus, callsigns)
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "open",
                units = units,
                calls = calls,
                ustatus = ustatus,
                job = job,
                callsigns = callsigns,
                id = GetPlayerServerId(PlayerId()),
                jobInfo = jobInfo
            })
        end)
    end
end

function updateJobInfo()

    for _, z in pairs(blips) do
        RemoveBlip(z)
    end

    jobInfo[Config.JobOne.job] = {
        color = Config.JobOne.color,
        column = 1,
        label = Config.JobOne.label,
        canRequestLocalBackup = Config.JobOne.canRequestLocalBackup,
        canRequestOtherJobBackup = Config.JobOne.canRequestOtherJobBackup,
        forwardCall = Config.JobOne.forwardCall,
        canRemoveCall = Config.JobOne.canRemoveCall
    }
    jobInfo[Config.JobTwo.job] = {
        color = Config.JobTwo.color,
        column = 2,
        label = Config.JobTwo.label,
        canRequestLocalBackup = Config.JobTwo.canRequestLocalBackup,
        canRequestOtherJobBackup = Config.JobTwo.canRequestOtherJobBackup,
        forwardCall = Config.JobTwo.forwardCall,
        canRemoveCall = Config.JobTwo.canRemoveCall
    }
    jobInfo[Config.JobThree.job] = {
        color = Config.JobThree.color,
        column = 3,
        label = Config.JobThree.label,
        canRequestLocalBackup = Config.JobThree.canRequestLocalBackup,
        canRequestOtherJobBackup = Config.JobThree.canRequestOtherJobBackup,
        forwardCall = Config.JobThree.forwardCall,
        canRemoveCall = Config.JobThree.canRemoveCall
    }
end

RegisterNetEvent("core_dispatch:callAdded")
AddEventHandler("core_dispatch:callAdded", function(id, call, j, cooldown, sprite, color)
    if job == j and alertsToggled then
        SendNUIMessage({
            type = "call",
            id = id,
            call = call,
            cooldown = cooldown
        })

        if Config.AddCallBlips then
            addBlipForCall(sprite, color, vector3(call.coords[1], call.coords[2], call.coords[3]), id)
        end
    end
end)

RegisterNUICallback("dismissCall", function(data)
    local id = data["id"]:gsub("call_", "")

    TriggerServerEvent("core_dispatch:unitDismissed", id)
    DeleteWaypoint()
end)

RegisterNUICallback("updatestatus", function(data)
    local id = data["id"]
    local status = data["status"]

    TriggerServerEvent("core_dispatch:changeStatus", id, status)
end)

RegisterNUICallback("sendnotice", function(data)
    local caller = data["caller"]

    if Config.EnableUnitArrivalNotice then
        TriggerServerEvent("core_dispatch:arrivalNotice", caller)
    end
end)

RegisterNetEvent("core_dispatch:SendTextMessage")
AddEventHandler("core_dispatch:SendTextMessage", function(msg)
    SendTextMessage(msg)
end)

RegisterNetEvent("core_dispatch:arrivalNoticeClient")
AddEventHandler("core_dispatch:arrivalNoticeClient", function()
    if not unitCooldown then
        SendTextMessage(Config.Text["someone_is_reacting"])
        unitCooldown = true
        Citizen.Wait(20000)
        unitCooldown = false
    end
end)

RegisterNUICallback("reqbackup", function(data)
    local j = data["job"]
    local req = data["requester"]
    local firstname = data["firstname"]
    local lastname = data["lastname"]
    SendTextMessage(Config.Text["backup_requested"])
    local cord = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("core_dispatch:addCall", "00-00", req .. " is requesting help", {{
        icon = "fa-user-friends",
        info = firstname .. " " .. lastname
    }}, {cord[1], cord[2], cord[3]}, j)
end)

RegisterNUICallback("toggleoffduty", function(data)
    ToggleDuty()
end)

RegisterNUICallback("togglecallblips", function(data)
    callBlipsToggled = not callBlipsToggled

    if callBlipsToggled then
        for _, z in pairs(callBlips) do
            SetBlipDisplay(z, 4)
        end
        SendTextMessage(Config.Text["call_blips_turned_on"])
    else
        for _, z in pairs(callBlips) do
            SetBlipDisplay(z, 0)
        end

        SendTextMessage(Config.Text["call_blips_turned_off"])
    end
end)

RegisterNUICallback("toggleunitblips", function(data)
    unitBlipsToggled = not unitBlipsToggled

    if unitBlipsToggled then
        addBlipsForUnits()
        SendTextMessage(Config.Text["unit_blips_turned_on"])
    else
        for _, z in pairs(blips) do
            RemoveBlip(z)
        end

        blips = {}
        SendTextMessage(Config.Text["unit_blips_turned_off"])
    end
end)

RegisterNUICallback("togglealerts", function(data)
    alertsToggled = not alertsToggled

    if alertsToggled then
        SendTextMessage(Config.Text["alerts_turned_on"])
    else
        SendTextMessage(Config.Text["alerts_turned_off"])
    end
end)

RegisterNUICallback("copynumber", function(data)
    SendTextMessage(Config.Text["phone_number_copied"])
end)

RegisterNUICallback("forwardCall", function(data)
    local id = data["id"]:gsub("call_", "")

    SendTextMessage(Config.Text["call_forwarded"])
    TriggerServerEvent("core_dispatch:forwardCall", id, data["job"])
end)

RegisterNUICallback("acceptCall", function(data)

    local id = data["id"]:gsub("call_", "")

    SetNewWaypoint(tonumber(data["x"]), tonumber(data["y"]))

    TriggerServerEvent("core_dispatch:unitResponding", id, job)
end)

RegisterNUICallback("changecallsign", function(data)

    local callsign = data["callsign"]

    TriggerServerEvent("core_dispatch:changeCallSign", callsign)
end)

RegisterNetEvent("core_dispatch:acceptCallClient")
AddEventHandler("core_dispatch:acceptCallClient", function(id, unit)
    if unit == GetPlayerServerId(PlayerId()) then
        SendTextMessage(Config.Text["accepted"])
    end

    SendNUIMessage({
        type = "accept",
        id = unit
    })
end)

RegisterNUICallback("removeCall", function(data)
    local id = data["id"]:gsub("call_", "")
    TriggerServerEvent("core_dispatch:removeCall", id)
end)

RegisterNetEvent("core_dispatch:removeCallClient")
AddEventHandler("core_dispatch:removeCallClient", function(id, unit)
    if unit == GetPlayerServerId(PlayerId()) then

        SendTextMessage(Config.Text["call_removed"])
    end
    SendNUIMessage({
        type = "remove",
        id = id
    })
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    while Config.EnableMapBlipsForUnits do
        if isLoggedIn then
            if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job then
                if unitBlipsToggled then
                    addBlipsForUnits()
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        if isLoggedIn then
            if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job then
                sleep = 1500

                local ped = PlayerPedId()

                status = {
                    carPlate = currentPlate,
                    type = currentType,
                    job = job,
                    netId = NetworkGetNetworkIdFromEntity(ped)
                }

                TriggerServerEvent("core_dispatch:playerStatus", status)
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 5000
        if isLoggedIn then
            if Config.JobOne.job == job or Config.JobTwo.job == job or Config.JobThree.job == job then
                sleep = 1500
                local ped = PlayerPedId()

                if IsPedInAnyVehicle(ped) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    currentPlate = plate
                    currentType = GetVehicleClass(vehicle)
                else
                    currentPlate = ""
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- EXPORTS

exports("addCall", function(code, title, extraInfo, coords, job, cooldown, sprite, color, priority)
    TriggerServerEvent("core_dispatch:addCall", code, title, extraInfo or {}, coords, job, cooldown or 5000,
        sprite or 11, color or 5, priority or false)
end)

exports("addMessage", function(message, coords, job, cooldown, sprite, color, priority)
    TriggerServerEvent("core_dispatch:addMessage", message, coords, job, cooldown or 5000, sprite or 11, color or 5,
        priority or false)
end)

exports('sendAlert', function(code, message, coords, priority, job, extraInfo, time, blip, color)
    local data = {
        code = code,
        message = message,
        extraInfo = extraInfo or {},
        coords = {coords.x, coords.y, coords.z},
        priority = priority or false,
        job = type(job) == 'table' and job or {job},
        time = time or 5000,
        blip = blip or 156,
        color = color or 1
    }

    TriggerServerEvent('core_dispatch:server:sendAlert', data)
end)

--- Use to open the disapatch
exports("openDispatch", function()
    openDispatch()
end)

--- Return the coords of the player
exports('getPlayerCoords', function()
    local ped = PlayerPedId()
    return GetEntityCoords(ped)
end)

--- Return the gender of the ped
exports('getPedGender', function(ped)
    if ped then
        return IsPedMale(ped) and 'male' or 'female'
    end
    return 'unknow'
end)
