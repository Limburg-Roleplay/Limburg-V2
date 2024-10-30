ESX = nil
local rentedBikes = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('lrp-voertuigverhuur:server:can:hire:voertuig', function(source, cb, locationIndex, cost)
    local xPlayer = ESX.GetPlayerFromId(source)
    local location = Config.Locations[locationIndex]

    if not location then
        cb(false)
        return
    end

    if xPlayer.getMoney() >= cost then
        xPlayer.removeMoney(cost)
        rentedBikes[source] = locationIndex
        cb(true)
    else
        TriggerClientEvent('okokNotify:Alert', source, 'Fout', 'Je hebt niet genoeg geld!', 5000, 'error')
        cb(false)
    end
end)

ESX.RegisterServerCallback('lrp-voertuigverhuur:server:can:bringback:voertuig', function(source, cb, locationIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    local location = Config.Locations[locationIndex]

    if not location then
        cb(false)
        return
    end

    if rentedBikes[source] == locationIndex then
        rentedBikes[source] = nil
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('lrp-voertuigverhuur:server:requestVehicles', function(source, cb)
    local vehicles = {
        { label = 'Scooter', model = 'frakas', cost = 5000 },
        { label = 'Fiets', model = 'tribike', cost = 750 }
    }

    cb(vehicles)
end)

RegisterNetEvent('lrp-voertuigverhuur:server:hireVehicle')
AddEventHandler('lrp-voertuigverhuur:server:hireVehicle', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount('bank').money >= data.cost then
        xPlayer.removeAccountMoney('bank', data.cost)
        TriggerClientEvent('lrp-voertuigverhuur:spawnVehicle', source, data.model, data.locationIndex)
        TriggerClientEvent('okokNotify:Alert', source, 'Succes', 'Je hebt succesvol een voertuig gehuurd voor $' .. data.cost, 5000, 'success')
    else
        TriggerClientEvent('okokNotify:Alert', source, 'Fout', 'Je hebt niet genoeg geld op je bankrekening!', 5000, 'error')
    end
end)


AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        rentedBikes = {}
    end
end)
