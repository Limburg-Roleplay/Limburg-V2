local getOutDict = 'switch@franklin@bed'
local getOutAnim = 'sleep_getup_rubeyes'
local canLeaveBed = false
local canLeaveResearchtable = false

local bedOccupying = nil
local bedObject = nil
local bedOccupyingData = nil
local cam = nil
inBedDict = "anim@gangops@morgue@table@"
inBedAnim = "body_search"
isInHospitalBed = false
isOnResearchtable = false
isStatusChecking = false
statusChecks = {}
statusCheckTime = 0
sendedNotify = false

local function GetAvailableBed(bedId)
    local pos = GetEntityCoords(PlayerPedId())
    local retval = nil
    if bedId == nil then
        for i = 1, #Config.CheckIn.beds do
            if not Config.CheckIn.beds[i].taken then
                if #(pos - vector3(Config.CheckIn.beds[i].coords.x, Config.CheckIn.beds[i].coords.y, Config.CheckIn.beds[i].coords.z)) < 500 then
                    retval = i
                end
            end
        end
    else
        if not Config.CheckIn.beds[bedId].taken then
            if #(pos - vector3(Config.CheckIn.beds[bedId].coords.x, Config.CheckIn.beds[bedId].coords.y, Config.CheckIn.beds[bedId].coords.z)) < 500 then
                retval = bedId
            end
        end
    end

    return retval
end


local function SetClosestBed()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for k, _ in pairs(Config.CheckIn.beds) do
        local dist2 = #(pos - vector3(Config.CheckIn.beds[k].coords.x, Config.CheckIn.beds[k].coords.y, Config.CheckIn.beds[k].coords.z))
        if current then
            if dist2 < dist then
                current = k
                dist = dist2
            end
        else
            dist = dist2
            current = k
        end
    end
    if current ~= closestBed and not isInHospitalBed then
        closestBed = current
    end
end


local function SetBedCam()
    isInHospitalBed = true
    canLeaveBed = false
    local player = PlayerPedId()

    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Wait(0)
    end

    if IsPedDeadOrDying(player) then
        local pos = GetEntityCoords(player, true)
        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(player), true, false)
    end

    bedObject = GetClosestObjectOfType(bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z,
        1.0, bedOccupyingData.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(player, bedOccupyingData.coords.x, bedOccupyingData.coords.y, bedOccupyingData.coords.z + 0.02)
    --SetEntityInvincible(PlayerPedId(), true)
    Wait(500)
    FreezeEntityPosition(player, true)

    loadAnimDict(inBedDict)

    TaskPlayAnim(player, inBedDict, inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
    SetEntityHeading(player, bedOccupyingData.coords.w)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 1.0, 1.0, true)
    SetCamFov(cam, 90.0)
    local heading = GetEntityHeading(player)
    heading = (heading > 180) and heading - 180 or heading + 180
    SetCamRot(cam, -45.0, 0.0, heading, 2)

    DoScreenFadeIn(1000)

    Wait(1000)
    FreezeEntityPosition(player, true)
end

local function LeaveBed()
    local player = PlayerPedId()

    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Wait(0)
    end

    FreezeEntityPosition(player, false)
    SetEntityInvincible(player, false)
    SetEntityHeading(player, bedOccupyingData.coords.w + 90)
    TaskPlayAnim(player, getOutDict, getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Wait(4000)
    ClearPedTasks(player)
    TriggerServerEvent('wsk-ambulance:server:LeaveBed', bedOccupying)
    FreezeEntityPosition(bedObject, true)
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    bedOccupying = nil
    bedObject = nil
    bedOccupyingData = nil
    isInHospitalBed = false
    sendedNotify = false
end

local function LeaveResearchtable()
    local player = PlayerPedId()

    RequestAnimDict(getOutDict)
    while not HasAnimDictLoaded(getOutDict) do
        Wait(0)
    end

    local pos = GetEntityCoords(player, true)

    for i = 1, #Config.CheckIn.Researchtable do
        local coords = Config.CheckIn.Researchtable[i].coords
        local dist2 = #(pos - vector3(coords.x, coords.y, coords.z))
        if dist2 < 4 then
            ResearchtableCoords = Config.CheckIn.Researchtable[i].coords
        end
    end

    FreezeEntityPosition(player, false)
    SetEntityInvincible(player, false)
    SetEntityHeading(player, ResearchtableCoords.w + 90)
    TaskPlayAnim(player, getOutDict, getOutAnim, 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Wait(4000)
    ClearPedTasks(player)
    --TriggerServerEvent('wsk-ambulance:server:LeaveBed', bedOccupying)
    FreezeEntityPosition(bedObject, true)
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(cam, false)

    bedOccupying = nil
    bedObject = nil
    isOnResearchtable = false
    sendedNotify = false
    ResearchtableCoords = nil
end

RegisterNetEvent('wsk-ambulance:client:SendToBed', function(id, data, isRevive)
    bedOccupying = id
    bedOccupyingData = data
    SetBedCam()
    ESX.ShowNotification('success', 'Je word geholpen...')
    CreateThread(function()
        Wait(5)
        if isRevive then
            exports['frp-progressbar']:Progress({
                name = "healen",
                duration = Config.AIHealTimer * 1000,
                label = 'Healen',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(cancelled)
                if not cancelled then
                    local coords = GetEntityCoords(PlayerPedId())
                    local formattedCoords = {
                        x = ESX.Math.Round(coords.x, 1),
                        y = ESX.Math.Round(coords.y, 1),
                        z = ESX.Math.Round(coords.z, 1)
                    }
                    respawnPed(PlayerPedId(), formattedCoords, 0.0)
                    Wait(1500)
                    canLeaveBed = true
                    loadAnimDict(inBedDict)
                    TaskPlayAnim(PlayerPedId(), inBedDict, inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                    SetEntityHeading(PlayerPedId(), bedOccupyingData.coords.w)
                else
                    canLeaveBed = true
                    loadAnimDict(inBedDict)
                    TaskPlayAnim(PlayerPedId(), inBedDict, inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
                    SetEntityHeading(PlayerPedId(), bedOccupyingData.coords.w)
                end
            end)
        else
            canLeaveBed = true
        end
    end)

    TriggerServerEvent('qs-smartphone:server:sendNewMail', {
        sender = 'Ambulance Future',
        subject = 'Ambulance Kosten',
        message = 'Je hebt €' ..
        tostring(Config.BillCost) ..
        ' betaald voor verzorging in het ziekenhuis, bedankt voor je komst!\nMvg,\nAmbulance Administratie Future',
        button = {}
    })
end)

RegisterNetEvent('wsk-ambulance:client:SetBed', function(id, isTaken)
    Config.CheckIn.beds[id].taken = isTaken
end)

RegisterNetEvent('wsk-ambulance:client:SetBed2', function(id, isTaken)
    Config.Hospital["jailbeds"][id].taken = isTaken
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if isInHospitalBed and canLeaveBed then
            sleep = 0
            if not sendedNotify then
                sendedNotify = true
                ESX.ShowNotification('success', 'Druk op [E] om het bed te verlaten')
            end
            if IsControlJustReleased(0, 38) then
                LeaveBed()
            end
        end
        if isOnResearchtable and canLeaveResearchtable then
            sleep = 0
            if not sendedNotify then
                sendedNotify = true
                ESX.ShowNotification('success', 'Druk op [E] om de Onderzoekstafel te verlaten')
            end
            if IsControlJustReleased(0, 38) then
                LeaveResearchtable()
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        SetClosestBed()
        if isStatusChecking then
            statusCheckTime = statusCheckTime - 1
            if statusCheckTime <= 0 then
                statusChecks = {}
                isStatusChecking = false
            end
        end
    end
end)

RegisterNetEvent('qb-ambulancejob:checkin', function()
    ExecuteCommand("/e notepad")
    exports['frp-progressbar']:Progress({
        name = "hospital_checkin",
        duration = 2000,
        label = 'Inchecken...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        if not cancelled then
            ExecuteCommand("/e c")
            local bedId = GetAvailableBed()
            if bedId then
                TriggerServerEvent("wsk-ambulance:server:sendToBed", bedId, true)
            else
                exports['frp-notifications']:Notify('error', 'Alle bedden zijn bezet!', 5000)
            end
        end
    end)
end)

RegisterNetEvent('qb-ambulancejob:beds', function()
    if GetAvailableBed(closestBed) then
        TriggerServerEvent("wsk-ambulance:server:sendToBed", closestBed, true)
    else
        exports['frp-notifications']:Notify('error', 'Alle bedden zijn bezet!', 5000)
    end
end)

RegisterNetEvent('qb-ambulancejob:researchtable', function()
    isOnResearchtable = true
    canLeaveResearchtable = false
    local player = PlayerPedId()
    local ResearchtableCoords = nil

    local pos = GetEntityCoords(player, true)
    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, GetEntityHeading(player), true, false)

    for i = 1, #Config.CheckIn.Researchtable do
        local coords = Config.CheckIn.Researchtable[i].coords
        local dist2 = #(pos - vector3(coords.x, coords.y, coords.z))
        if dist2 < 4 then
            ResearchtableCoords = Config.CheckIn.Researchtable[i].coords
        end
    end

    Wait(1000)

    if ResearchtableCoords == nil then
        ESX.ShowNotification('error', 'Je staat te ver weg...')
        return
    end


    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Wait(0)
    end

    bedObject = GetClosestObjectOfType(ResearchtableCoords.x, ResearchtableCoords.y, ResearchtableCoords.z, 1.0,
        Config.CheckIn.Researchtable.model, false, false, false)
    FreezeEntityPosition(bedObject, true)

    SetEntityCoords(player, ResearchtableCoords.x, ResearchtableCoords.y, ResearchtableCoords.z + 0.02)
    --SetEntityInvincible(PlayerPedId(), true)
    Wait(500)
    FreezeEntityPosition(player, true)

    loadAnimDict(inBedDict)

    TaskPlayAnim(player, inBedDict, inBedAnim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
    SetEntityHeading(player, ResearchtableCoords.w)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(cam, player, 31085, 0, 1.0, 1.0, true)
    SetCamFov(cam, 90.0)
    local heading = GetEntityHeading(player)
    heading = (heading > 180) and heading - 180 or heading + 180
    SetCamRot(cam, -45.0, 0.0, heading, 2)
    DoScreenFadeIn(1000)
    Wait(1000)
    FreezeEntityPosition(player, true)
    canLeaveResearchtable = true
    ResearchtableCoords = nil
end)

CreateThread(function()
    for k, v in pairs(Config.CheckIn.checkIn) do
        exports.qtarget:AddBoxZone("checking" .. k, v.coords, v.length, v.height, {
                name = "checking" .. k,
                heading = v.heading,
                debugPoly = false,
                minZ = v.coords.z,
                maxZ = v.coords.z + 1.5,
            },
            {
                options = {
                    {
                        type = "client",
                        icon = "fa fa-clipboard",
                        event = "qb-ambulancejob:checkin",
                        label = "Inchecken",
                    }
                }
            })
    end

    exports.ox_target:addModel(Config.CheckIn.bedModels, {
        {
            name = 'wsk-ambulance:checkInBed',
            event = "qb-ambulancejob:beds",
            icon = "fas fa-bed",
            label = "In bed liggen",
        }
    })

    exports.ox_target:addModel(Config.CheckIn.researchtable, {
        {
            name = 'wsk-ambulance:researchtable',
            event = "qb-ambulancejob:researchtable",
            icon = "fas fa-user-doctor",
            label = "Op onderzoekstafel gaan liggen..",
        }
    })
end)
