local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

PlayerData = {}

local jailTime = 0
local inJail = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(7)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(7)
    end

    PlayerData = ESX.GetPlayerData()

    -- LoadTeleporters()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
    PlayerData = newData

    Citizen.Wait(25000)

    ESX.TriggerServerCallback("Kaas_Gevangenis:retrieveJailTime", function(inJail, newJailTime)
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

exports("jtm-jailmenu", OpenJailMenu)

RegisterNetEvent("Kaas_Gevangenis:openJailMenu")
AddEventHandler("Kaas_Gevangenis:openJailMenu", function()
    OpenJailMenu()
end)

RegisterNetEvent("Kaas_Gevangenis:jailPlayer")
AddEventHandler("Kaas_Gevangenis:jailPlayer", function(newJailTime)
    jailTime = newJailTime
    Cutscene()
end)

RegisterNetEvent("Kaas_Gevangenis:unJailPlayer")
AddEventHandler("Kaas_Gevangenis:unJailPlayer", function()
    jailTime = 0
    UnJail()
end)

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function JailLogin()
    local JailPosition = Config.JailPositions["Cell"]
    SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)

    exports["frp-notifications"]:Notify("info", "Je was uitgelogd in de gevangenis dus je bent terug geplaatst!", 4000)

    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['gevangenis_wear'].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms['gevangenis_wear'].female)
        end
    end)

    InJail()
end

function UnJail()
    InJail()
    ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Boiling Broke"])

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    
    inJail = false
end

function InJail()
    inJail = true

    -- Jail Timer --
    Citizen.CreateThread(function()
        while jailTime > 0 do
            jailTime = jailTime - 1
            local jailTimeLabel = math.floor(jailTime)
            if jailTimeLabel == 1 then
                exports["frp-notifications"]:Notify("info", "Je hebt " .. jailTimeLabel .. " maand celstraf over!", 3000)
            else
                exports["frp-notifications"]:Notify("info", "Je hebt " .. jailTimeLabel .. " maanden celstraf over!", 3000)
            end
            TriggerServerEvent("Kaas_Gevangenis:updateJailTime", jailTime)

            if jailTime == 0 then
                UnJail()
                TriggerServerEvent("Kaas_Gevangenis:updateJailTime", 0)
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

function OpenJailMenu()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'jail_prison_menu',
        {
            title    = "Gevangenis Menu",
            align    = 'Top-right',
            elements = {
                { label = "Jail dichtsbijzijnde persoon", value = "jail_closest_player" },
                { label = "Unjail dichtsbijzijnde persoon", value = "unjail_player" }
            }
        }, 
    function(data, menu)
        local action = data.current.value
        if action == "jail_closest_player" then
            menu.close()
            ESX.UI.Menu.Open(
                'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
                {
                    title = "Jail Tijd (minutes)"
                },
            function(data2, menu2)
                local jailTime = tonumber(data2.value)
                if jailTime == nil then
                    exports["frp-notifications"]:Notify("error", "Tijd moet in minuten zijn!", 3000)
                else
                    menu2.close()
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        exports["frp-notifications"]:Notify("error", "Er is niemand in de buurt!", 3000)
                    else
                        ESX.UI.Menu.Open(
                            'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
                            {
                                title = "Jail Reden"
                            },
                        function(data3, menu3)
                            local reason = data3.value
                            if reason == nil then
                                exports["frp-notifications"]:Notify("error", "Je moet hier iets invullen!", 3000)
                            else
                                menu3.close()
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    exports["frp-notifications"]:Notify("error", "Er is niemand in de buurt!", 3000)
                                else
                                    TriggerServerEvent("Kaas_Gevangenis:jailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
                                end
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        elseif action == "unjail_player" then
            local elements = {}
            ESX.TriggerServerCallback("Kaas_Gevangenis:retrieveJailedPlayers", function(playerArray)
                if #playerArray == 0 then
                    ESX.ShowNotification("Your jail is empty!")
                    exports["frp-notifications"]:Notify("error", "Er zit niemand in de gevangenis!", 3000)
                    return
                end
                for i = 1, #playerArray, 1 do
                    table.insert(elements, {label = "Gevangene: " .. playerArray[i].name .. " | Jail Tijd: " .. playerArray[i].jailTime .. " minutes", value = playerArray[i].identifier })
                end
                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'jail_unjail_menu',
                    {
                        title = "Unjail Speler",
                        align = "top-right",
                        elements = elements
                    },
                function(data2, menu2)
                    local action = data2.current.value
                    TriggerServerEvent("Kaas_Gevangenis:unJailPlayer", action)
                    menu2.close()
                end, function(data2, menu2)
                    menu2.close()
                end)
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

exports("inJail", function()
    return inJail
end)
