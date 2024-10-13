ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

StaffIndienst = {}
local whitelisted = {
    "steam:110000133c7f273",
    "steam:110000144cf9831",
    "steam:1100001550b537f",
    "steam:1100001493249e2",
    "steam:11000013c1388a9",
    "steam:110000149ffb275",
    "steam:11000014bb97d62"
}

local lastCommandTime = {}

function isSteamIDInList(steamID)
    for _, listID in ipairs(whitelisted) do
        if steamID == listID then
            return true
        end
    end
    return false
end

RegisterCommand("staffdienst", function(source)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)

    if lastCommandTime[src] and os.time() - lastCommandTime[src] < 180 and not xPlayer.getGroup() == 'hogerop' and not xPlayer.getGroup() == 'owner' and not xPlayer.getGroup() == 'admin' then  -- 120 seconds cooldown
        TriggerClientEvent("frp-notifications:client:notify", src, 'info', 'Je moet nog wachten voor je deze commando weer kan gebruiken.')
        return
    end

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
    local steamID = GetPlayerIdentifiers(playerId)[1]
    if isSteamIDInList(steamID) then
        return true
    else
        return StaffIndienst[playerId] or false
    end
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
