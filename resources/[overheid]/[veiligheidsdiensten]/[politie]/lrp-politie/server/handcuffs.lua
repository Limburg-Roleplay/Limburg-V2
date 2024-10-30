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

RegisterNetEvent('jtm-development:police:server:set:player:vehicle')
AddEventHandler('jtm-development:police:server:set:player:vehicle', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        TriggerClientEvent('jtm-development:police:client:player:handler:vehicle', target)
    else
        print(('[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Player in Vehicle!'):format(source))
    end
end)


RegisterServerEvent('jtm-development:police:server:RemoveItem')
AddEventHandler('jtm-development:police:server:RemoveItem', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem("handcuffs", 1)
end)

RegisterServerEvent('jtm-development:police:server:GiveItem')
AddEventHandler('jtm-development:police:server:GiveItem', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifiers = GetPlayerIdentifiers(source)
    local license = nil

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "license:") then
            license = identifier
            break
        end
    end

    if xPlayer.job.name == 'police' then
        xPlayer.addInventoryItem('handcuffs', 1)
        --print(string.format("Player %s with license %s was given handcuffs.", xPlayer.getName(), license or "unknown"))
    else
        DropPlayer(source, "Verboden exploites te gebruiken")
        print(string.format("Player %s with license %s was dropped for exploiting.", xPlayer.getName(), license or "unknown"))
    end
end)


RegisterServerEvent('jtm-development:police:server:ProcessCuffs')
AddEventHandler('jtm-development:police:server:ProcessCuffs', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'police' then
        exports["FIVEGUARD"]:screenshotPlayer(xPlayer.source, function(url)
            print("Got URL of screenshot: " .. url .. " from player: " .. xPlayer.source)
        end)
        exports["FIVEGUARD"]:fg_BanPlayer(xPlayer.source, "Suspicious activity detected: Player ID " .. xPlayer.source .. " Probeerde Iedereen te boeien", true)
        return
    end
    
    if Handcuffed[source] then return end
    
    TriggerClientEvent('jtm-development:police:client:ProcessCuffs', tonumber(id), p)
    Handcuffed[source] = true
end)

RegisterServerEvent('jtm-development:police:server:RemoveCuffs')
AddEventHandler('jtm-development:police:server:RemoveCuffs', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'police' then
        exports["FIVEGUARD"]:screenshotPlayer(xPlayer.source, function(url)
            print("Got URL of screenshot: " .. url .. " from player: " .. xPlayer.source)
        end)
        exports["FIVEGUARD"]:fg_BanPlayer(xPlayer.source, "Suspicious activity detected: Player ID " .. xPlayer.source .. " Probeerde Iedereen te boeien", true)
        return
    end

    TriggerClientEvent('jtm-development:police:client:RemoveCuffs', tonumber(id), p)
    Handcuffed[source] = false
end)


RegisterServerEvent('jtm-development:police:server:dragServer')
AddEventHandler('jtm-development:police:server:dragServer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.job.name ~= 'police' and xPlayer.job.name ~= 'ambulance') then return end
    local needsCuff = true
    if (xPlayer.job.name == 'ambulance') then needsCuff = false end
    TriggerClientEvent('jtm-development:police:client:dragStart', target, source, needsCuff)
end)

ESX.RegisterServerCallback('jtm-development:police:getCuffed', function(source, cb)
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

RegisterServerEvent('jtm-development:police:server:onDrag')
AddEventHandler('jtm-development:police:server:onDrag', function(target)
  local _source = source
        TriggerClientEvent('jtm-development:police:client:startDragging', target, _source)
end)


RegisterServerEvent('jtm-development:police:server:syncs:drag')
AddEventHandler('jtm-development:police:server:syncs:drag', function(target)
  local _source = source
        TriggerClientEvent('jtm-development:police:client:syncs:drag', target, _source)
end)