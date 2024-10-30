local status = {}

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(PlayerData)
        ESX.PlayerData = PlayerData
        ESX.PlayerLoaded = true
    end
)

RegisterNetEvent("esx:onPlayerLogout")
AddEventHandler(
    "esx:onPlayerLogout",
    function()
        ESX.PlayerLoaded = false
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(Job)
        ESX.PlayerData.job = Job
    end
)

Citizen.CreateThread(
    function()
        while ESX.GetPlayerData().job == nil do
            Wait(0)
        end

        ESX.PlayerData = ESX.GetPlayerData()

        Wait(1000)
        TriggerServerEvent("sl-status:get:status")
    end
)

RegisterNetEvent("sl-status:receive:status")
AddEventHandler(
    "sl-status:receive:status",
    function(statusData)
        for _, data in pairs(statusData) do
            local name = data.name
            local percent = data.percent
            if Config.Debug then
                print("Status data - Name: " .. name .. ", Percent: " .. percent)
            end
            status[name] = percent
        end

        TriggerEvent('esx_customui:updateStatus', statusData)
    end
)

Citizen.CreateThread(
    function()
        while next(status) == nil do
            Wait(0)
        end
        local shownMessage = false
        local dying = false
        while true do
            local playerPed = PlayerPedId()
            local prevHealth = GetEntityHealth(playerPed)
            local health = prevHealth

            for k, v in pairs(status) do
                if k == "hunger" or k == "thirst" and prevHealth > 0 then
                    if v <= 20 and not shownMessage and prevHealth > 0 then
                        exports['okokNotify']:Alert('Pas op!', 'Je eten of drinken is op een dusdanig laag niveau dat je bijna doodgaat.', 10000, 'warning')
                        shownMessage = true
                    end
                    if v <= 3 and prevHealth > 0 then
                        if Config.Debug then
                            print("dying...")
                        end 
                        dying = true
                        health = health - 5
                        
                    else 
                        dying = false
                    end
                end
            end

            if dying then
                exports['okokNotify']:Alert('Pas op!', 'Je gaat nu dood.', 1000, 'error')
            end

            if health ~= prevHealth then
                SetEntityHealth(playerPed, health)
            end

            Wait(1000)
        end
    end
)

exports(
    "getStatusFully",
    function()
        return status
    end
)

exports(
    "getStatus",
    function(bool)
        if status[bool] then
            return status[bool]
        else
            return 0
        end
    end
)
