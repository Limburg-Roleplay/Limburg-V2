-- // [VARIABLES] \\ --

local entities = {}

-- // [CALLBACKS] \\ --

local ServerVehicle = CreateVehicleServerSetter
lib.callback.register('today-garage:server:cb:createVehicle', function(source, data)
    local routing = GetPlayerRoutingBucket(source)
    local randomRoute = math.random(100, 999)

    ---@diagnostic disable-next-line: missing-parameter
    local vehicle = ServerVehicle and ServerVehicle(data.model, data.type, data.coord, data.heading) or CreateVehicle(data.model, data.coord.x, data.coord.y, data.coord.z, data.heading, true, true)
    while not ServerVehicle and not DoesEntityExist(vehicle) do Wait(0) end

    while NetworkGetEntityOwner(vehicle) == -1 do Wait(0) end

    if data.prop and data.prop.plate then
        SetVehicleNumberPlateText(vehicle, data.prop.plate)
    end
    
    SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)

    while NetworkGetEntityOwner(vehicle) ~= source do 
        SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
        Wait(10)
    end

    entities[data.prop.plate] = vehicle

    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    if ServerVehicle then 
        TriggerEvent('today-garage:server:entityCreated', vehicle)
    end

    TriggerClientEvent('today-garage:client:set:vehicleProperties', NetworkGetEntityOwner(vehicle), netId, data.prop)

    SetTimeout(1000, function()
        SetPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
    end)

    return netId
end)

ESX.RegisterServerCallback('today-garages:server:cb:allowed:spawning', function(source, cb, plate)
    local src = source
    local bool = true
    local value = entities[plate]

    if not DoesEntityExist(entities[plate]) then cb(true) entities[plate] = nil return end

    if entities[plate] then
        ---@diagnostic disable-next-line: cast-local-type
        bool = GetEntityCoords(value)
    end

    cb(bool)
end)

ESX.RegisterServerCallback('today-garages:server:cb:receive:shared', function(source, cb)
    cb(Shared)
end)

ESX.RegisterServerCallback('today-garages:server:cb:receive:vehicles', function(source, cb, garageType, stored)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicleResult = {}
    local response

    if stored then
        response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `type` = ? AND `stored` = ?', {
            xPlayer.identifier, garageType, stored
        })
    else
        response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `type` = ?', {
            xPlayer.identifier, garageType
        })
    end

    for i=1, #response do 
        vehicleResult[#vehicleResult + 1] = {
            ['vehiclePlate'] = response[i]['plate'],
            ['vehicleProps'] = json.decode(response[i]['vehicle']),
            ['vehicleLabel'] = response[i]['label'] and response[i]['label'] or nil,
            ['isStored'] = response[i]['stored'],
            ['polimpound'] = response[i]['polimpound'],
            ['currentGarage'] = tonumber(response[i]['garage'])
        }
    end

    cb(vehicleResult)
end)


ESX.RegisterServerCallback('today-garages:server:is:deleting:allowed', function(source, cb, plate, garageIndex, vehProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isOwner = false
    local isFound = false

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `plate` = ?', {
        plate
    })
    
    for i=1, #response do 
        if response[i]['owner'] == xPlayer.identifier then 
            isOwner = true
            break
        end
    end

    for i=1, #response do 
        if json.decode(response[i]['vehicle']).model == vehProps['model'] then
            isFound = true
            break 
        end
    end

    if not isOwner or not isFound then 
        cb(false)
        return
    end

    local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `garage` = ?, `vehicle` = ? WHERE `owner` = ? AND `plate` = ?', {
        garageIndex, json.encode(vehProps), xPlayer.identifier, plate
    })

    if affectedRows >= 1 then 
        cb(true)
    else 
        cb(false)
    end
end)

ESX.RegisterServerCallback('today-garages:server:is:deleting:allowed:overheid', function(source, cb, plate, garageIndex, vehProps)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isOwner = false

    if xPlayer.job.name == 'police' then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('today-garages:server:cb:canPayImpound', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local accountMoney = xPlayer.getAccount('bank').money
    if accountMoney >= Shared.Settings['prices']['impound'] then 
        xPlayer.removeAccountMoney('bank', Shared.Settings['prices']['impound'], 'Impound kosten betaald')
        cb(true)
    else 
        cb(false)
    end
end)

-- // [FIVEM EVENTS] \\ --

local whiteListed = {
    [-2077365264] = true,
}

AddEventHandler('entityCreated', function(entity)
    if DoesEntityExist(entity) then 
        local src = NetworkGetEntityOwner(entity)
        local model = GetEntityModel(entity)
        local eType = GetEntityPopulationType(entity)
        if GetEntityType(entity) == 2 and not whiteListed[tonumber(GetEntityModel(entity))] then 
            if eType == 6 or eType == 7 then 
                DeleteEntity(entity)
                --ESX.FlagPlayer(src, 'Speler heeft geprobeerd een voertuig client-sided in te spawnen')
                CancelEvent()
            end
        end
    end
end)

-- // [EVENTS] \\ --

RegisterNetEvent('today-garages:server:set:vehicleState')
AddEventHandler('today-garages:server:set:vehicleState', function(state, plate, garageIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isOwner = false

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        xPlayer.identifier, plate
    })

    for i=1, #response do 
        if response[i]['owner'] == xPlayer.identifier then 
            isOwner = true
        end
    end
    if not isOwner then return end

    local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `garage` = ?, `stored` = ? WHERE `owner` = ? AND `plate` = ?', {
        garageIndex, state, xPlayer.identifier, plate
    })
end)

RegisterNetEvent('today-garages:server:set:polimpound')
AddEventHandler('today-garages:server:set:polimpound', function(type, plate, garageIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    local isOwner = false

    local money = xPlayer.getAccount('bank').money-15000
    if money >= 0 and xPlayer.getJob().name ~= 'police' then
        xPlayer.removeAccountMoney('bank', 15000, 'Heeft Politie impound kosten betaald')
    end

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        xPlayer.identifier, plate
    })

    for i=1, #response do 
        if response[i]['owner'] == xPlayer.identifier then 
            isOwner = true
        end
    end
    if not isOwner then return end

    local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `garage` = ?, `polimpound` = ? WHERE `owner` = ? AND `plate` = ?', {
        garageIndex, type, xPlayer.identifier, plate
    })
end)

RegisterNetEvent('today-garage:server:garage:vehicleTransfer')
AddEventHandler('today-garage:server:garage:vehicleTransfer', function(args, playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local isOwner = false

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        xPlayer.identifier, args.props.plate
    })
    for i=1, #response do 
        if response[i]['owner'] == xPlayer.identifier then 
            isOwner = true
        end
    end
    if not isOwner then return end

    local tPlayer = ESX.GetPlayerFromId(playerId)
    if not tPlayer then TriggerClientEvent('wsk-notify', xPlayer.source, 'error', 'Deze speler is niet in de stad..') return end

    local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `owner` = ? WHERE `owner` = ? AND `plate` = ?', {
        tPlayer.identifier, xPlayer.identifier, args.props.plate
    })
    
    TriggerEvent('today-logging:server:log', xPlayer.source, 'vehtransfer', 'green', '*Speler heeft een voertuig overgeschreven.*\n\n**Voertuigkenteken:** ' .. args.props.plate, tPlayer.source)
    TriggerClientEvent('wsk-notify', xPlayer.source, 'success', 'Voertuig met kentekenplaat: ' .. args.props.plate .. ' is overgeschreven!')
    TriggerClientEvent('wsk-notify', tPlayer.source, 'success', 'Voertuig met kentekenplaat: ' .. args.props.plate .. ' is overgeschreven!')
end)

RegisterNetEvent('today-garage:server:garage:vehicleLabel')
AddEventHandler('today-garage:server:garage:vehicleLabel', function(args, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local isOwned = false

    local response = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        xPlayer.identifier, args.props.plate
    })
    for i=1, #response do 
        if response[i]['owner'] == xPlayer.identifier then 
            isOwner = true
            break
        end
    end
    if not isOwner then return end

    local affectedRows = MySQL.update.await('UPDATE `owned_vehicles` SET `label` = ? WHERE `owner` = ? AND `plate` = ?', {
        label, xPlayer.identifier, args.props.plate
    })
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'success', 'Voertuig met kentekenplaat: ' .. args.props.plate .. ' heeft een nieuwe bijnaam: ' .. label .. '!')
end)