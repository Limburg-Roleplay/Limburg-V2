-- // [VARIABLES] \\ --

local Exios = { Functions = {} }

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('jtm-vipcardealer:server:cb:get:shared', function(source, cb)
    cb(Shared)
end)

ESX.RegisterServerCallback('frp-cardealer:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('exios-vehicleshop:server:cb:quickSell', function(source, cb, plate, props)
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

ESX.RegisterServerCallback('jtm-development:server:cb:buyVehicle', function(source, cb, class, id, colour)
    local xPlayer = ESX.GetPlayerFromId(source)
    local veh = Shared.Vehicles[class][id+1]['model']

    if xPlayer.getAccount('bank').money < Shared.Vehicles[class][id+1]['price'] then 
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Je hebt hier niet genoeg geld voor!", 4000)
        return 
    end

    local plate = Exios.Functions.GeneratePlate()

    local vehicleColour = Shared.Fotobook.Colors[colour]
    if not vehicleColour then
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Ongeldige kleur geselecteerd!", 4000)
        return
    end

    local colorIndex = vehicleColour['index']

    xPlayer.removeAccountMoney('bank', Shared.Vehicles[class][id+1]['price'])

    cb({color1 = colorIndex}, plate)
end)


ESX.RegisterServerCallback('jtm-development:server:saveVehicle', function(source, cb, plate, props, model)
    local xPlayer = ESX.GetPlayerFromId(source)
    local steamName = GetPlayerName(source)
    local steamId = xPlayer.identifier
    local license = xPlayer.getIdentifier()
    local bankMoney = xPlayer.getAccount('bank').money
    local cashMoney = xPlayer.getMoney()
    
    local function formatNumber(number)
        local formatted = tostring(number)
        while true do  
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
            if (k == 0) then
                break
            end
        end
        return formatted
    end

    local formattedBankMoney = formatNumber(bankMoney)
    local formattedCashMoney = formatNumber(cashMoney)
    
    exports['oxmysql']:query('INSERT INTO `owned_vehicles` (owner, plate, vehicle, stored, type) VALUES (?, ?, ?, ?, ?)', { steamId, plate, json.encode(props), 0, 'car' })

    TriggerClientEvent('frp-notifications:client:notify', source, 'success','Bedankt voor je aankoop veel plezier met je voertuig!', 5000)

    local currentDate = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("Datum en tijd: %s\nSteam naam: %s\nSteam ID: %s\nRockstar license: %s\nKenteken: %s\nModel: %s\nBankgeld: €%s\nCashgeld: €%s",
                                      currentDate, steamName, steamId, license, plate, model, formattedBankMoney, formattedCashMoney)
    
    TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263162977289240627/kn3IJRcEGnkF_8iqF5wTZ31HUog2-OxCYlnwxt3XQ4QWbeiI6AkpwYLomdCZAdM_bkF8', source, {
        title = "Cardealer Logs",
        desc = logMessage
    })
    
    cb(true)
end)


-- // [EVENTS] \\ --

RegisterNetEvent('jtm-development:server:handler:requestscreenshot')
AddEventHandler('jtm-development:server:handler:requestscreenshot', function(vehName, cameraId, vehBrand, label)
    local src = source

    exports['screenshot-basic']:requestClientScreenshot(src, {
        fileName =  'resources/[jtm]/jtm-vipcardealer/src/html/voertuigen/' .. vehBrand .. '_' .. vehName .. '_' .. cameraId .. '_' .. label .. '.png'
    }, function(err, data)
        print(data)
    end)
end)

-- // [COMMANDS] \\ --

ESX.RegisterCommand('vipcardealer_fotos', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('jtm-development:client:handler:startFotobook', xPlayer.getGroup())
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