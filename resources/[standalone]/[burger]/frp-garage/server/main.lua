ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('frp-garage:getMechanic', function(source, cb)

    local xPlayers = ESX.GetPlayers()
    Mechanics = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'anwb' then
            Mechanics = Mechanics + 1
        end
    end
    cb(Mechanics)
    SetTimeout(120 * 1000, mechanicss)
end)

ESX.RegisterServerCallback('frp-garage:server:receive:vehicles', function(source, cb, bool)
    local ownedCars = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    if bool == true then
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {
            ['@owner'] = xPlayer.getIdentifier(),
        }, function(data)
            for _,v in pairs(data) do
                table.insert(ownedCars, {
                    vehicle = json.decode(v.vehicle),
                    plate = v.plate,
                    type = v.type,
                    stored = v.stored,
                    wok = v.wok,
                    nickname = v.nickname,
                    garageid = v.stickyGarage,
                    pound = v.pound
                })
            end
            cb(ownedCars)
        end)
    else
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {
            ['@owner'] = xPlayer.getIdentifier(),
        }, function(data)
            for _,v in pairs(data) do
                table.insert(ownedCars, {
                    vehicle = json.decode(v.vehicle),
                    plate = v.plate,
                    type = v.type,
                    stored = v.stored,
                    wok = v.wok,
                    nickname = v.nickname,
                    garageid = v.stickyGarage,
                    pound = v.pound
                })
            end
            cb(ownedCars)
        end)
    end
end)

ESX.RegisterServerCallback('frp-garage:server:receive:impoundvehicles', function(source, cb, bool)
    local ownedCars = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    if bool == true then
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {
            ['@owner'] = xPlayer.getIdentifier(),
        }, function(data)
            for _,v in pairs(data) do
                table.insert(ownedCars, {
                    vehicle = json.decode(v.vehicle),
                    plate = v.plate,
                    type = v.type,
                    stored = v.stored,
                    wok = v.wok,
                    nickname = v.nickname,
                    garageid = v.stickyGarage,
                    pound = v.pound,
                    impoundcost = v.impoundcost
                })
            end
            cb(ownedCars)
        end)
    else
        MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {
            ['@owner'] = xPlayer.getIdentifier(),
        }, function(data)
            for _,v in pairs(data) do
                table.insert(ownedCars, {
                    vehicle = json.decode(v.vehicle),
                    plate = v.plate,
                    type = v.type,
                    stored = v.stored,
                    wok = v.wok,
                    nickname = v.nickname,
                    garageid = v.stickyGarage,
                    pound = v.pound,
                    impoundcost = v.impoundcost
                })
            end
            cb(ownedCars)
        end)
    end
end)

ESX.RegisterServerCallback('frp-garage:server:allowed:to:spawn', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = xPlayer.getIdentifier(),
        ['@plate'] = plate
    }, function (result)
        if result[1] ~= nil then
            if result[1].owner == xPlayer.getIdentifier() then
                cb(true)
            end
        else
            cb(false, 'Er is iets fout gegaan..!')
        end
    end)
end)

ESX.RegisterServerCallback('frp-garage:server:is:deleting:allowed', function(source, cb, plate, veh, props)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
        ['@owner'] = xPlayer.getIdentifier(),
        ['@plate'] = plate
    }, function (result)
        if result[1] ~= nil then
            if result[1].owner == xPlayer.getIdentifier() then
                MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
                    ['@owner'] = xPlayer.getIdentifier(),
                    ['@vehicle'] = json.encode(props),
                    ['@plate'] = plate,
                }, function(rows)
                    DeleteEntity(NetworkGetEntityFromNetworkId(veh))
                    cb(true)
                end)
            else
                cb(false, 'Dit is niet jouw voertuig!')
            end
        else
            cb(false, 'Er is iets fout gegaan..!')
                    print(plate)
        end
    end)
end)

ESX.RegisterServerCallback('frp-garage:server:can:pay:impound', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.Prices['ImpoundPrice']

    if xPlayer.getAccount('bank').money >= price then
        xPlayer.removeAccountMoney('bank', price)
        cb(true)
    else
        cb(false)
        TriggerClientEvent("frp-notifications:client:notify", xPlayer.source, 'error', 'Je hebt niet genoeg geld om jouw voertuig uit de impound te halen..')
    end
end)

ESX.RegisterServerCallback('frp-garage:server:can:pay:p:impound', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.Prices['PolitieImpound']

    if xPlayer.getAccount('bank').money >= price then
        xPlayer.removeAccountMoney('bank', price)
        cb(true)
    else
        cb(false)
        TriggerClientEvent("frp-notifications:client:notify", xPlayer.source, 'error', 'Je hebt niet genoeg geld om jouw voertuig uit de impound te halen..')
    end
end)

RegisterServerEvent('frp-garage:server:set:vehicle:state')
AddEventHandler('frp-garage:server:set:vehicle:state', function(state, plate, garage)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {["@owner"] = xPlayer.getIdentifier()}, function(result)
        if result[1] ~= nil then
            MySQL.Async.execute("UPDATE owned_vehicles SET stored = @stored, garageid = @garage, pound = '0', impoundcost = '0' WHERE plate = @plate", {
                ["@plate"] = plate,
                ["@stored"] = state,
                ["@garage"] = garage,
            }, function(RowsChanged)
            end)
        end
    end)
end)

RegisterNetEvent('frp-garage:server:garage:VehicleTransfer')
AddEventHandler('frp-garage:server:garage:VehicleTransfer', function(data, playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local isOwner = false

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        xPlayer.identifier, data.props.plate
    })
    for i=1, #response do 
        if response[i]['owner'] == xPlayer.identifier then 
            isOwner = true
        end
    end
    if not isOwner then return end

    local tPlayer = ESX.GetPlayerFromId(playerId)
    if not tPlayer then TriggerClientEvent('frp-notifications', xPlayer.source, 'error', 'Deze speler is niet in de stad..') return end
	TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1232365521043853315/_nNlI1cshQckqtmje-JrSCpSdad86BfxwDdxOv9EBsAsSmdJsqZ1II38cYgtQ5-1HAd6', src, 	id, {title = GetPlayerName(xPlayer.source) .. " heeft zijn auto met kenteken: " .. data.props.plate ..  " verkocht aan " .. GetPlayerName(tPlayer.source), desc = "[" .. xPlayer.source .. "] " .. GetPlayerName(xPlayer.source) .. " - " .. "[" .. tPlayer.source .. "] " .. GetPlayerName(tPlayer.source)}, 0x00ff00)
    local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `owner` = ? WHERE `owner` = ? AND `plate` = ?', {
        tPlayer.identifier, xPlayer.identifier, data.props.plate
    })
    -- TriggerClientEvent('frp-notifications', xPlayer.source, 'success', 'Voertuig met kentekenplaat: ' .. data.props.plate .. ' is overgeschreven!')
    lib.notify(xPlayer.source, {
        title = 'Garage',
        description = 'Voertuig met kentekenplaat: ' .. data.props.plate .. ' is overgeschreven!',
        type = 'success'
    })

    lib.notify(tPlayer.source, {
        title = 'Garage',
        description = 'Voertuig met kentekenplaat: ' .. data.props.plate .. ' is overgeschreven!',
        type = 'success'
    })
    -- TriggerClientEvent('frp-notifications', tPlayer.source, 'success', 'Voertuig met kentekenplaat: ' ..s data.props.plate .. ' is overgeschreven!')
end)

RegisterNetEvent('frp-garage:server:garage:VehicleRename')
AddEventHandler('frp-garage:server:garage:VehicleRename', function(data, nickname)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner", {["@owner"] = xPlayer.getIdentifier()}, function(result)
        if result[1] ~= nil then
    MySQL.Async.execute("UPDATE owned_vehicles SET nickname = @nickname WHERE plate = @plate", {
        ["@plate"] = data.props.plate,
        ["@nickname"] = nickname,
    }, function(RowsChanged)
            end)
        end
    end)
end)