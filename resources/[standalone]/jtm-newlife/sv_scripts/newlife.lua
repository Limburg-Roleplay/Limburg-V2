ESX = exports["es_extended"]:getSharedObject()

local cooldowns = {}

local function isPlayerDead(player)
    return GetEntityHealth(GetPlayerPed(player)) <= 0
end

RegisterCommand("overheidnewlife", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and (xPlayer.job.name == "police" or xPlayer.job.name == "kmar") then
        if not cooldowns[source] or (os.time() - cooldowns[source]) >= 30 then
            TriggerClientEvent("openNewLifeMenu", source)
            cooldowns[source] = os.time()
        else
            local remainingTime = 30 - (os.time() - cooldowns[source])
            TriggerClientEvent('frp-notifications:client:notify', source, "error", 'Je kunt dit commando niet zo snel herhalen. Wacht ' .. remainingTime .. ' seconden.', 4000)
        end
    end
end, false)

RegisterServerEvent("politiehbnewlife")
AddEventHandler("politiehbnewlife", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer and (xPlayer.job.name == "police" or xPlayer.job.name == "kmar") then
        if isPlayerDead(src) then
            TriggerClientEvent('frp-notifications:client:notify', src, "info", 'Je zal over 2 minuten een nieuw leven krijgen!', 4000)
            Citizen.Wait(120000)
            if not isPlayerDead(src) then
                TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je bent niet meer dood! Actie geannuleerd!', 4000)
            else
                TriggerClientEvent('hrp-troep:teleportPlayer', src, -347.2685, -362.7626, 31.5773)
                TriggerClientEvent('wsk-ambulance:client:staffrevive:player', src)
                TriggerClientEvent('frp-notifications:client:notify', src, "success", 'Je hebt jezelf succesvol een nieuw leven gegeven!', 4000)
            end
        else
            TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je bent niet dood!', 4000)
        end
    else
        print("Error: xPlayer is nil for source " .. tostring(src) .. " or job is not allowed")
    end
end)

RegisterServerEvent("ziekenhuis-newlife")
AddEventHandler("ziekenhuis-newlife", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer and (xPlayer.job.name == "police" or xPlayer.job.name == "kmar") then
        if isPlayerDead(src) then
            TriggerClientEvent('frp-notifications:client:notify', src, "info", 'Je zal over 2 minuten een nieuw leven krijgen!', 4000)
            Citizen.Wait(120000)
            if not isPlayerDead(src) then
                TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je bent niet meer dood! Actie geannuleerd!', 4000)
            else
                TriggerClientEvent('hrp-troep:teleportPlayer', src, 1853.5934, 3702.2075, 34.2687)
                TriggerClientEvent('wsk-ambulance:client:staffrevive:player', src)
                TriggerClientEvent('frp-notifications:client:notify', src, "success", 'Je hebt jezelf succesvol een nieuw leven gegeven!', 4000)
            end
        else
            TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je bent niet dood!', 4000)
        end
    else
        print("Error: xPlayer is nil for source " .. tostring(src) .. " or job is not allowed")
    end
end)

RegisterServerEvent("palettohbnewlife")
AddEventHandler("palettohbnewlife", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer and (xPlayer.job.name == "police" or xPlayer.job.name == "kmar") then
        if isPlayerDead(src) then
            TriggerClientEvent('frp-notifications:client:notify', src, "info", 'Je zal over 2 minuten een nieuw leven krijgen!', 4000)
            Citizen.Wait(120000)
            if not isPlayerDead(src) then
                TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je bent niet meer dood! Actie geannuleerd!', 4000)
            else
                TriggerClientEvent('hrp-troep:teleportPlayer', src, -446.0279, 5984.5981, 31.4892)
                TriggerClientEvent('wsk-ambulance:client:staffrevive:player', src)
                TriggerClientEvent('frp-notifications:client:notify', src, "success", 'Je hebt jezelf succesvol een nieuw leven gegeven!', 4000)
            end
        else
            TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je bent niet dood!', 4000)
        end
    else
        print("Error: xPlayer is nil for source " .. tostring(src) .. " or job is not allowed")
    end
end)
