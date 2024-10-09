ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local rentedBikes = {}

ESX.RegisterServerCallback('frp-fietsverhuur:server:can:hire:fiets', function(source, cb, locationIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    local location = Config.Locations[locationIndex]

    if not location then
        cb(false)
        return
    end

    if xPlayer.getMoney() >= location.cost then
        xPlayer.removeMoney(location.cost)

        table.insert(rentedBikes, {
            playerId = source,
            locationIndex = locationIndex
        })

        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('frp-fietsverhuur:server:can:bringback:fiets', function(source, cb, locationIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    local location = Config.Locations[locationIndex]

    if not location then
        cb(false)
        return
    end

    for i, rentedBike in ipairs(rentedBikes) do
        if rentedBike.playerId == source and rentedBike.locationIndex == locationIndex then
            table.remove(rentedBikes, i)

            cb(true)
            return
        end
    end

    cb(false)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        local currentTime = os.time()

        for i, rentedBike in ipairs(rentedBikes) do
            local location = Config.Locations[rentedBike.locationIndex]

            local rentalTime = currentTime - rentedBike.startTime

            if rentalTime >= location.rentalDuration then
                local xPlayer = ESX.GetPlayerFromId(rentedBike.playerId)
                if xPlayer then
                    xPlayer.removeMoney(location.cost)
                end
                table.remove(rentedBikes, i)
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        rentedBikes = {}
    end
end)