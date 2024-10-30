ESX = nil 
ESX = exports["es_extended"]:getSharedObject()

PlayerData = {}

local jailTime = 0
local inJail = false
local DichtbijReparatie = false
local MoetKeyPressChecken = false
local HuidigeRepairPunt = nil
local checkKeyPress = false

Citizen.CreateThread(function()
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(7)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
    PlayerData = newData

    Citizen.Wait(3000)

    ESX.TriggerServerCallback("lrp-jail:retrieveJailTime", function(inJail, newJailTime)
        if inJail then
            jailTime = newJailTime
            JailLogin()
        end
    end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
    PlayerData["job"] = response
end)

exports("OpenJailMenu", OpenJailMenu)

RegisterNetEvent("lrp-jail:openJailMenu")
AddEventHandler("lrp-jail:openJailMenu", function()
    OpenJailMenu()
end)

RegisterNetEvent("lrp-jail:jailPlayer")
AddEventHandler("lrp-jail:jailPlayer", function(newJailTime)
    jailTime = newJailTime
    Cutscene()
end)

RegisterNetEvent("lrp-jail:unJailPlayer")
AddEventHandler("lrp-jail:unJailPlayer", function()
    jailTime = 0
    UnJail()
end)

function ShowJailUI(time)
    SendNUIMessage({
        action = "showJailTime",
        jailTime = time
    })
end

function HideJailUI()
    SendNUIMessage({
        action = "hideJailTime"
    })
end

function JailLogin()
    local JailPosition = Config.JailPositions["Cell"]
    SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)

    exports['okokNotify']:Alert('Gevangenis', "Je was uitgelogd in de gevangenis dus je bent terug geplaatst!", 4000, 'info')

    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['gevangenis_wear'].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['gevangenis_wear'].female)
        end
    end)

    InJail()
end

function stopKeyPressCheck()
    checkKeyPress = false
end

function UnJail()
    inJail = false
    stopKeyPressCheck()
    RemoveJailBlips()

    ESX.Game.Teleport(PlayerPedId(), Config.VrijlatingTP)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)

    HideJailUI()
    exports['okokNotify']:Alert('Gevangenis', "Je bent vrij gelaten uit de gevangenis!", 4000, 'success')
end

function InJail()
    inJail = true
    CreateJailBlips()
    startKeyPressCheck()

    Citizen.CreateThread(function()
        while jailTime > 0 do
            jailTime = jailTime - 1
            ShowJailUI(jailTime)
            TriggerServerEvent("lrp-jail:updateJailTime", jailTime)

            if jailTime == 0 then
                UnJail()
                TriggerServerEvent("lrp-jail:updateJailTime", 0)
            end

            Citizen.Wait(60000)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            if jailTime > 0 then
                DisableControlAction(0, 288, true)
                DisableControlAction(0, 170, true)
                DisableControlAction(0, 171, true)
                DisableControlAction(0, 137, true)
                DisableControlAction(0, 217, true)
            end
            Citizen.Wait(0)
        end
    end)
end

function handleRepairPoints()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if HuidigeRepairPunt and HuidigeRepairPunt.repairable then
        local distance = #(playerCoords - HuidigeRepairPunt.coords)

        if distance < 10.0 then
            if distance < 2.0 then
                if not DichtbijReparatie then
                    lib.showTextUI('[E] - Fix Kast', {
                        position = "right-center",
                        icon = 'wrench',
                        style = {
                            borderRadius = 0,
                            backgroundColor = '#4e4e4e',
                            color = 'white'
                        }
                    })
                    DichtbijReparatie = true
                    MoetKeyPressChecken = true
                end
            elseif DichtbijReparatie then
                lib.hideTextUI()
                DichtbijReparatie = false
                MoetKeyPressChecken = false
            end
        end
    end
end

function startRepairTask()
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    Citizen.Wait(5000)
    ClearPedTasksImmediately(playerPed)

    jailTime = jailTime - 1
    exports['okokNotify']:Alert('Gevangenis', 'Je hebt een kast gerepareerd! Jailtime verminderd met 1 minuut.', 4000, 'success')
    TriggerServerEvent("lrp-jail:updateJailTime", jailTime)
    ShowJailUI(jailTime)

    selectRandomRepairPoint()

    lib.hideTextUI()
    DichtbijReparatie = false
    MoetKeyPressChecken = false

    if jailTime <= 0 then
        UnJail()
    end
end

function selectRandomRepairPoint()
    if HuidigeRepairPunt then
        SetBlipAlpha(HuidigeRepairPunt.blip, 0)
        HuidigeRepairPunt.repairable = false
    end

    local newIndex = math.random(1, #Config.RepairPunten)
    HuidigeRepairPunt = Config.RepairPunten[newIndex]

    HuidigeRepairPunt.repairable = true
    SetBlipAlpha(HuidigeRepairPunt.blip, 255)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if inJail then
            handleRepairPoints()
        end
    end
end)

function startKeyPressCheck()
    if checkKeyPress then return end
    checkKeyPress = true
    
    Citizen.CreateThread(function()
        while checkKeyPress and inJail do
            Citizen.Wait(0)
            if MoetKeyPressChecken and IsControlJustReleased(0, 38) then
                startRepairTask()
                MoetKeyPressChecken = false
            end
        end
        checkKeyPress = false
    end)
end

function CreateJailBlips()
    for i = 1, #Config.RepairPunten, 1 do
        Config.RepairPunten[i].blip = AddBlipForCoord(Config.RepairPunten[i].coords)
        SetBlipSprite(Config.RepairPunten[i].blip, 402)
        SetBlipDisplay(Config.RepairPunten[i].blip, 4)
        SetBlipScale(Config.RepairPunten[i].blip, 0.9)
        SetBlipColour(Config.RepairPunten[i].blip, 1)
        SetBlipAsShortRange(Config.RepairPunten[i].blip, true)

        SetBlipAlpha(Config.RepairPunten[i].blip, 0)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Reparatie Punt")
        EndTextCommandSetBlipName(Config.RepairPunten[i].blip)
    end

    selectRandomRepairPoint()
end

function RemoveJailBlips()
    for i = 1, #Config.RepairPunten, 1 do
        if Config.RepairPunten[i].blip then
            RemoveBlip(Config.RepairPunten[i].blip)
        end
    end
end

exports("inJail", function()
    return inJail
end)

RegisterCommand("jailmenu", function(source, args)
	if PlayerData.job.name == "police" or PlayerData.job.name == "kmar" then
        OpenJailMenu()
	else
        exports['okokNotify']:Alert('Gevangenis', "Je bent niet bevoegd om dit uit te voeren!", 3000, 'error')
	end
end)

function OpenJailMenu(args)
    lib.registerContext({
        id = 'lrp-jailmenu',
        title = 'Gevangenis Menu',
        icon = 'handcuffs',
        options = {
            {
                icon = 'handcuffs',
                title = 'Jail speler',
                description = 'Stuur speler naar de gevangenis',
                arrow = true,
                onSelect = function()
                    InputMaanden()
                end
            },
            {
                icon = 'handcuffs',
                title = 'Unjail speler',
                description = 'Haal speler uit de gevangenis!',
                arrow = true,
                onSelect = function()
                    ESX.TriggerServerCallback("lrp-jail:retrieveJailedPlayers", function(playerArray)
                        if #playerArray == 0 then
                            exports['okokNotify']:Alert('Gevangenis', "Er zit niemand in de gevangenis!", 3000, 'error')
                            return
                        end
                        
                        local GevangenenSpelers = {}
                        
                        for i = 1, #playerArray, 1 do
                            table.insert(GevangenenSpelers, {
                                icon = 'user',
                                title = playerArray[i].name,
                                description = 'Haal speler uit de gevangenis! ('..playerArray[i].jailTime..' maanden)',
                                arrow = true,
                                onSelect = function()
                                    local alert = lib.alertDialog({
                                        header = 'Bevestig vrijlating',
                                        content = 'Weet je zeker dat je '..playerArray[i].name..' uit de gevangenis wilt halen?',
                                        centered = true,
                                        cancel = true
                                    })
                                     
                                    if alert == 'confirm' then
                                        TriggerServerEvent("lrp-jail:unJailPlayer", playerArray[i].identifier)
                                    else
                                        lib.showContext('gevangenen_menu')
                                    end
                                end
                            })
                        end

                        lib.registerContext({
                            id = 'gevangenen_menu',
                            title = 'Gevangenen',
                            menu = 'lrp-jailmenu',
                            options = GevangenenSpelers
                        })

                        lib.showContext('gevangenen_menu')
                    end)
                end,
            }
        }
    })

    lib.showContext('lrp-jailmenu')
end

function InputMaanden()
    local options = {
        {
            type = "input",
            label = "Reden",
            placeholder = "Voer reden in",
            required = true
        },
        {
            type = "number",
            label = "Aantal Maanden",
            placeholder = "Voer aantal maanden in",
            required = true,
            min = 1,
            max = 60
        }
    }

    local input = lib.inputDialog('Jail Speler', options)

    if not input then
        lib.showContext('lrp-jailmenu')
        return
    else
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            exports['okokNotify']:Alert('Gevangenis', "Er is niemand in de buurt!", 3000, 'error')
        else
            TriggerServerEvent("lrp-jail:jailPlayer", GetPlayerServerId(closestPlayer), input[2], input[1])
        end
    end
end