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

RegisterNetEvent('jtm-development:server:set:player:vehicle')
AddEventHandler('jtm-development:server:set:player:vehicle', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        TriggerClientEvent('jtm-development:client:player:handler:vehicle', target)
    else
        print(('[^3WARNING^7] Player ^5%s^7 Attempted To Exploit Player in Vehicle!'):format(source))
    end
end)


RegisterServerEvent('jtm-development:server:RemoveItem')
AddEventHandler('jtm-development:server:RemoveItem', function(p, id)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem("tiewraps", 1)
end)

RegisterServerEvent('jtm-development:server:ProcessCuffs')
AddEventHandler('jtm-development:server:ProcessCuffs', function(p, id)
    if Handcuffed[source] then return end
    
   TriggerClientEvent('jtm-development:client:ProcessCuffs', tonumber(id), p)
    Handcuffed[source] = true
end)

RegisterServerEvent('jtm-development:server:RemoveCuffs')
AddEventHandler('jtm-development:server:RemoveCuffs', function(p, id)
    TriggerClientEvent('jtm-development:client:RemoveCuffs', tonumber(id), p)
    Handcuffed[source] = false
end)

RegisterServerEvent('jtm-development:server:dragServer')
AddEventHandler('jtm-development:server:dragServer', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.job.name ~= 'police' and xPlayer.job.name ~= 'ambulance') then return end
    local needsCuff = true
    if (xPlayer.job.name == 'ambulance') then needsCuff = false end
    TriggerClientEvent('jtm-development:client:dragStart', target, source, needsCuff)
end)

ESX.RegisterServerCallback('jtm-development:getCuffed', function(source, cb)
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

RegisterServerEvent('jtm-development:server:onDrag')
AddEventHandler('jtm-development:server:onDrag', function(target)
  local _source = source
        TriggerClientEvent('jtm-development:client:startDragging', target, _source)
end)


RegisterServerEvent('jtm-development:server:syncs:drag')
AddEventHandler('jtm-development:server:syncs:drag', function(target)
  local _source = source
        TriggerClientEvent('jtm-development:client:syncs:drag', target, _source)
end)