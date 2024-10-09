-- // [VARIABLES] \\ --

local Exios = { Functions = {} }

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('frp-luchtvaartdealer:server:cb:get:shared', function(source, cb)
    cb(Shared)
end)

ESX.RegisterServerCallback('frp-luchtvaartdealer:server:cb:quickSell', function(source, cb, plate, props)
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

ESX.RegisterServerCallback('frp-luchtvaartdealer:server:cb:buyVehicle', function(source, cb, class, id, colour)
    local xPlayer = ESX.GetPlayerFromId(source)
    local veh = Shared.Vehicles[class][id+1]['model']

    if xPlayer.getAccount('bank').money <= Shared.Vehicles[class][id+1]['price'] then 
        TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Je hebt hier niet genoeg geld voor!' )
        return 
    end

    local plate = Exios.Functions.GeneratePlate()
    TriggerClientEvent("frp-notifications:client:notify", source, 'success', 'Je hebt een '..Shared.Vehicles[class][id+1]['label']..' gekocht voor €'..Shared.Vehicles[class][id+1]['price']..'')
    xPlayer.removeAccountMoney('bank', Shared.Vehicles[class][id+1]['price'])
    cb({color1 = Shared.Fotobook.Colors[colour]['index']}, plate)
end)

ESX.RegisterServerCallback('frp-luchtvaartdealer:server:saveVehicle', function(source, cb, modelClass, plate, props, model)
    local xPlayer = ESX.GetPlayerFromId(source)
    if modelClass == 'helicopter' then
    exports['oxmysql']:query('INSERT INTO `owned_vehicles` (owner, plate, vehicle, stored, type) VALUES (?, ?, ?, ?, ?)', { xPlayer.identifier, plate, json.encode(props), 0, 'helicopter' })
    else
        print(type)
        exports['oxmysql']:query('INSERT INTO `owned_vehicles` (owner, plate, vehicle, stored, type) VALUES (?, ?, ?, ?, ?)', { xPlayer.identifier, plate, json.encode(props), 0, 'helicopter' })
    end
    TriggerClientEvent("frp-notifications:client:notify", source, 'success', 'je hebt de sleutels ontvangen, je nieuwe voertuig staat achteraan klaar!')
    cb(true)
end)

-- // [EVENTS] \\ --

RegisterNetEvent('frp-luchtvaartdealer:server:handler:requestscreenshot')
AddEventHandler('frp-luchtvaartdealer:server:handler:requestscreenshot', function(vehName, cameraId, vehBrand, label)
    local src = source

    exports['screenshot-basic']:requestClientScreenshot(src, {
        fileName =  'resources/[frp]/frp-luchtvaartdealer/html/voertuigen/' .. vehBrand .. '_' .. vehName .. '_' .. cameraId .. '_' .. label .. '.png'
    }, function(err, data)
        print(data)
    end)
end)

-- // [COMMANDS] \\ --

ESX.RegisterCommand('luchtvaartdealer_fotos', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('frp-luchtvaartdealer:client:handler:startFotobook', xPlayer.getGroup())
end, false, { help = 'Maak fotos voor de cardealer' } )

-- // [FUNCTIONS] \\ --

Exios.Functions.GeneratePlate = function()
    local str = nil
    repeat
        str = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(3))
        local alreadyExists = MySQL.single.await('SELECT owner FROM owned_vehicles WHERE plate = ?', {str})
    until not alreadyExists?.owner
    return string.upper(str)
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end



-- mixing async with sync tasks

function GetRandomNumber(length)
	Wait(0)
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Wait(0)
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end