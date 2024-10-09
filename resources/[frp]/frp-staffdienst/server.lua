ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

StaffIndienst = {}

local lastCommandTime = {}

RegisterCommand("staffdienst", function(source)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Cooldown check
    if lastCommandTime[src] and os.time() - lastCommandTime[src] < 120 and not xPlayer.getGroup() == 'hogerop' and not xPlayer.getGroup() == 'owner' and not xPlayer.getGroup() == 'admin' then  -- 120 seconds cooldown
        TriggerClientEvent("frp-notifications:client:notify", src, 'info', 'Je moet nog wachten voor je deze commando weer kan gebruiken.')
        return
    end

    -- Update the last command execution time
    lastCommandTime[src] = os.time()

    if xPlayer.getGroup() == "user" then
        return
    end

    local discordlog = exports["frp-logging"]:createlog("https://discord.com/api/webhooks/1283468399741108234/l3hS07mQc484w5aCyuKlEjrF6fmzaZq8Me3T5xGZzyRvxWhAnemFZvbtQV4mrjAIFcwh", "Staffdienst - Uit Dienst")
    
    discordlog.addcolumns({
        Identifier = xPlayer.getIdentifier(),
        Naam = GetPlayerName(src),
    })

    if StaffIndienst[src] then
        local tijd = os.time() - StaffIndienst[src]
        TriggerClientEvent("frp-notifications:client:notify", src, 'info', 'Staff Dienst is succesvol uitgezet')
        discordlog.update("color", 15548997)
        if tonumber(tijd) < 300 then
            TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1283468399741108234/l3hS07mQc484w5aCyuKlEjrF6fmzaZq8Me3T5xGZzyRvxWhAnemFZvbtQV4mrjAIFcwh', src, {title = GetPlayerName(src) .. " is te kort in staff dienst geweest: " .. tijd .. " seconden", desc = GetPlayerName(src) .. " is te kort in staff dienst geweest: " .. tijd .. " seconden"}, 0x00ff00)
        end
        discordlog.addcolumn("Tijd in seconden", tijd)
        StaffIndienst[src] = nil
    else
        TriggerClientEvent("frp-notifications:client:notify", src, 'info', 'Staff Dienst is succesvol aangezet')
        discordlog.update("title", "Logs - In Dienst")
        StaffIndienst[src] = os.time()
    end

    discordlog.send()

    local dienst = false
    if StaffIndienst[src] then
        dienst = true
    end

    TriggerClientEvent("vl-staffdienst:toggle:dienst", src, src, dienst)
end)

exports("inDienst", function(playerId)
    return StaffIndienst[playerId] or false
end)

AddEventHandler("playerDropped", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not StaffIndienst[src] then
        return
    end

    local discordlog = exports["frp-logging"]:createlog("https://discord.com/api/webhooks/1283468399741108234/l3hS07mQc484w5aCyuKlEjrF6fmzaZq8Me3T5xGZzyRvxWhAnemFZvbtQV4mrjAIFcwh", " Staffdienst - Uit Dienst") 
    discordlog.addcolumns({
        Identifier = xPlayer.getIdentifier(),
        Naam = GetPlayerName(src),
    })

    local tijd = os.time() - StaffIndienst[src]
    TriggerClientEvent("frp-notifications:client:notify", src, 'info', 'Staff Dienst is successvol uitgezet')
    discordlog.update("color", 15548997)
    discordlog.addcolumn("Tijd", tijd)
    StaffIndienst[src] = nil
end)

RegisterNetEvent("vl-staffdienst:getSteamID")
AddEventHandler("vl-staffdienst:getSteamID", function()
    local _source = source
    local steamID = GetPlayerIdentifiers(_source)[1]
    TriggerClientEvent("vl-staffdienst:receiveSteamID", _source, steamID)
end)
