-- // [VARIABLES] \\ --

local Exios = { Functions = {} }

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('exios-eilandshop:server:cb:get:shared', function(source, cb)
    cb(Shared)
end)
ESX.RegisterServerCallback('frp-eilanddealer:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)
ESX.RegisterServerCallback('exios-eilandshop:server:cb:quickSell', function(source, cb, plate, props)
    local xPlayer = ESX.GetPlayerFromId(source)
    local ownerFound = false

    MySQL.prepare('SELECT `owner` FROM `owned_vehicles` WHERE `plate` = ?', {
        plate
    }, function(response)
        if not response then cb(false) end

        if response == xPlayer.identifier then 
            MySQL.update('DELETE FROM owned_vehicles WHERE plate = ?', { plate })
            cb(true)
        else 
            cb(false)
        end
    end, modelClass, modelId, data.colour)
end)

ESX.RegisterServerCallback('exios-eilandshop:server:cb:buyVehicle', function(source, cb, class, id, colour)
    local xPlayer = ESX.GetPlayerFromId(source)
    local veh = Shared.Vehicles[class][id+1]['model']

    if xPlayer.getAccount('bank').money <= Shared.Vehicles[class][id+1]['price'] then 
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Je hebt hier niet genoeg geld voor!", 4000)
       -- xPlayer.showNotification('error', 'Je hebt hier niet genoeg geld voor!', 4000)
        return 
    end

    local plate = Exios.Functions.GeneratePlate()

    xPlayer.removeAccountMoney('bank', Shared.Vehicles[class][id+1]['price'])
    cb({color1 = Shared.Fotobook.Colors[colour]['index']}, plate)
end)

ESX.RegisterServerCallback('exios-eilandshop:server:saveVehicle', function(source, cb, plate, props, model)
    local xPlayer = ESX.GetPlayerFromId(source)

    exports['oxmysql']:query('INSERT INTO `owned_vehicles` (owner, plate, vehicle, stored, type) VALUES (?, ?, ?, ?, ?)', { xPlayer.identifier, plate, json.encode(props), 0, 'eilandcar' })
    xPlayer.showNotification('Je hebt een nieuw voertuig gekocht, veel plezier!', 'success', 4000)
    TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1234467149301416028/IXUGT1xEif-ARb7UFY8d4gI3PqV91kz3JtibuTvCmwvJZspyXYM-AZPNZoaN9sr8PpLV', source, {title= GetPlayerName(source) .. " heeft zojuist een ".. model .." gekocht met kenteken " .. plate, GetPlayerName(source) .. " heeft zojuist een ".. model .." gekocht met kenteken " .. plate}, 0x00ff00)
    cb(true)
end)

-- // [EVENTS] \\ --

RegisterNetEvent('exios-eilandshop:server:handler:requestscreenshot')
AddEventHandler('exios-eilandshop:server:handler:requestscreenshot', function(vehName, cameraId, vehBrand, label)
    local src = source

    exports['screenshot-basic']:requestClientScreenshot(src, {
        fileName =  'resources/[frp]/frp-eilanddealer/src/html/voertuigen/' .. vehBrand .. '_' .. vehName .. '_' .. cameraId .. '_' .. label .. '.png'
    }, function(err, data)
        print(data)
    end)
end)

-- // [COMMANDS] \\ --

ESX.RegisterCommand('boatdealer_fotos', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('exios-eilandshop:client:handler:startFotobook', xPlayer.getGroup())
end, false, { help = 'Maak fotos voor de cardealer' } )

-- // [FUNCTIONS] \\ --

Exios.Functions.GeneratePlate = function()
    local str = nil
    repeat
        str = ESX.GetRandomString(8)
        local alreadyExists = MySQL.single.await('SELECT owner FROM owned_vehicles WHERE plate = ?', {str})
    until not alreadyExists?.owner
    return string.upper(str)
end