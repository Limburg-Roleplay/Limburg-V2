local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Handcuffed = {}
AddEventHandler('esx:playerDropped', function(playerId, reason)
    if Handcuffed[playerId] then
        Handcuffed[playerId] = nil
    end
end)

RegisterNetEvent('jtm-development:kmar:server:set:player:vehicle')
AddEventHandler('jtm-development:kmar:server:set:player:vehicle', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        TriggerClientEvent('jtm-development:kmar:client:player:handler:vehicle', target)
    else
        print(('[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Player in Vehicle!'):format(source))
    end
end)


RegisterServerEvent('jtm-development:kmar:server:RemoveItem')
AddEventHandler('jtm-development:kmar:server:RemoveItem', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem("handcuffs", 1)
end)

RegisterServerEvent('jtm-development:kmar:server:GiveItem')
AddEventHandler('jtm-development:kmar:server:GiveItem', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifiers = GetPlayerIdentifiers(source)
    local license = nil

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "license:") then
            license = identifier
            break
        end
    end

    if xPlayer.job.name == 'kmar' then
        xPlayer.addInventoryItem('handcuffs', 1)
        print(string.format("Player %s with license %s was given handcuffs.", xPlayer.getName(), license or "unknown"))
    else
        DropPlayer(source, "Verboden exploites te gebruiken")
        print(string.format("Player %s with license %s was dropped for exploiting.", xPlayer.getName(), license or "unknown"))
    end
end)


RegisterServerEvent('jtm-development:kmar:server:ProcessCuffs')
AddEventHandler('jtm-development:kmar:server:ProcessCuffs', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'kmar' then
        -- exports["FIVEGUARD"]:screenshotPlayer(xPlayer.source, function(url)
        --     print("Got URL of screenshot: " .. url .. " from player: " .. playerId)
        -- end)
        -- exports["FIVEGUARD"]:fg_BanPlayer(xPlayer.source, "Suspicious activity detected: Player ID " .. xPlayer.source .. " Probeerde Iedereen te boeien", true)
        return
    end
    
    if Handcuffed[source] then return end
    
    TriggerClientEvent('jtm-development:kmar:client:ProcessCuffs', tonumber(id), p)
    Handcuffed[source] = true
end)

RegisterServerEvent('jtm-development:kmar:server:RemoveCuffs')
AddEventHandler('jtm-development:kmar:server:RemoveCuffs', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'kmar' then
        -- exports["FIVEGUARD"]:screenshotPlayer(xPlayer.source, function(url)
        --     print("Got URL of screenshot: " .. url .. " from player: " .. playerId)
        -- end)
        -- exports["FIVEGUARD"]:fg_BanPlayer(xPlayer.source, "Suspicious activity detected: Player ID " .. xPlayer.source .. " Probeerde Iedereen te boeien", true)
        return
    end

    TriggerClientEvent('jtm-development:kmar:client:RemoveCuffs', tonumber(id), p)
    Handcuffed[source] = false
end)


RegisterServerEvent('jtm-development:kmar:server:dragServer')
AddEventHandler('jtm-development:kmar:server:dragServer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.job.name ~= 'kmar' and xPlayer.job.name ~= 'ambulance') then return end
    local needsCuff = true
    if (xPlayer.job.name == 'ambulance') then needsCuff = false end
    TriggerClientEvent('jtm-development:kmar:client:dragStart', target, source, needsCuff)
end)

ESX.RegisterServerCallback('jtm-development:kmar:getCuffed', function(source, cb)
    if Handcuffed[source] then
        cb(true)
    else
        cb(false)
    end
end)

function GetCuffedStatus()
    if Handcuffed[source] then
        cb(true)
    else
        cb(false)
    end
end

RegisterServerEvent('jtm-development:kmar:server:onDrag')
AddEventHandler('jtm-development:kmar:server:onDrag', function(target)
  local _source = source
        TriggerClientEvent('jtm-development:kmar:client:startDragging', target, _source)
end)


RegisterServerEvent('jtm-development:kmar:server:syncs:drag')
AddEventHandler('jtm-development:kmar:server:syncs:drag', function(target)
  local _source = source
        TriggerClientEvent('jtm-development:kmar:client:syncs:drag', target, _source)
end)