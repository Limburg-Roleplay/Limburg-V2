ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Give car with a random plate - 1: playerID 2: carModel (3: plate)
RegisterCommand('givecar', function(source, args)
	givevehicle(source, args, 'car')
end)

-- Give plane with a random plate - 1: playerID 2: carModel (3: plate)
RegisterCommand('giveplane', function(source, args)
	givevehicle(source, args, 'airplane')
end)

-- Give boat with a random plate - 1: playerID 2: carModel (3: plate)
RegisterCommand('giveboat', function(source, args)
	givevehicle(source, args, 'boat')
end)
RegisterCommand('delcarplate', function(source, args, rawCommand)
    local playerId = source
    local plate = table.concat(args, " ")

    -- Check if the user has the 'xadmin.all' ace permission or is the console (source == 0)
    if source == 0 or IsPlayerAceAllowed(playerId, "xadmin.all") then
        if not plate or plate == "" then
            if source == 0 then
                print('[SYSTEM] You must provide a plate number!')
            else
                TriggerClientEvent('chat:addMessage', playerId, { args = { '^1SYSTEM', 'You must provide a plate number!' } })
            end
            return
        end

        -- Fetch the vehicle by plate and delete it if found
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        }, function(result)
            if #result > 0 then
                MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
                    ['@plate'] = plate
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        if source == 0 then
                            print('[SYSTEM] Vehicle with plate ' .. plate .. ' has been successfully deleted.')
                        else
                            TriggerClientEvent('chat:addMessage', playerId, { args = { '^2SYSTEM', 'Vehicle with plate ' .. plate .. ' has been successfully deleted.' } })
                        end
                    else
                        if source == 0 then
                            print('[SYSTEM] Error occurred while deleting the vehicle.')
                        else
                            TriggerClientEvent('chat:addMessage', playerId, { args = { '^1SYSTEM', 'Error occurred while deleting the vehicle.' } })
                        end
                    end
                end)
            else
                if source == 0 then
                    print('[SYSTEM] No vehicle found with plate number: ' .. plate)
                else
                    TriggerClientEvent('chat:addMessage', playerId, { args = { '^1SYSTEM', 'No vehicle found with plate number: ' .. plate } })
                end
            end
        end)
    else
        -- Notify the player that they don't have permission
        if source == 0 then
            print('[SYSTEM] You do not have permission to use this command.')
        else
            TriggerClientEvent('chat:addMessage', playerId, { args = { '^1SYSTEM', 'You do not have permission to use this command.' } })
        end
    end
end, false)



-- Give helicopter with a random plate - 1: playerID 2: carModel (3: plate)
RegisterCommand('giveheli', function(source, args)
	givevehicle(source, args, 'helicopter')
end)

function givevehicle(_source, _args, vehicleType)
	if havePermission(_source) or _source == 0 then
		if _args[1] == nil or _args[2] == nil then
			if _source == 0 then
				print("SYNTAX ERROR: givevehicle <playerID> <carModel> [plate]")
			else
				TriggerClientEvent('esx:showNotification', _source, '~r~/givevehicle playerID carModel [plate]')
			end
		else
			local target = tonumber(_args[1])
			local model = _args[2]
			local playerPed = GetPlayerPed(target)
			local playerName = GetPlayerName(target)
			local coords = GetEntityCoords(playerPed)
			if playerName == nil then
				if _source == 0 then
					print("Player ID " .. tostring(target) .. " does not exist")
				else
					TriggerClientEvent('esx:showNotification', _source, '~r~Player ID does not exist!')
				end
				return
			end

			if _args[3] ~= nil then
				local plate = _args[3]
				if #_args > 3 then
					for i=4, #_args do
						plate = plate .. " " .. _args[i]
					end
				end
				plate = string.upper(plate)
				TriggerClientEvent('esx_giveownedcar:spawnVehiclePlate', target, target, model, plate, playerName, 'player', vehicleType, coords)
			else
                print(target, target, model, playerName, 'player', vehicleType, coords)
				TriggerClientEvent('esx_giveownedcar:spawnVehicle', target, model, playerName, 'player', vehicleType, coords)
			end

			if _source == 0 then
				print("Vehicle given to player ID " .. target .. " with model " .. model)
			end
		end
	else
		if _source == 0 then
			print("You don't have permission to use this command!")
		else
			TriggerClientEvent('esx:showNotification', _source, '~r~You don\'t have permission to use this command!')
		end
	end
end

RegisterCommand('_givecar', function(source, args)
	_givevehicle(source, args, 'car')
end)

RegisterCommand('_giveplane', function(source, args)
	_givevehicle(source, args, 'airplane')
end)

RegisterCommand('_giveboat', function(source, args)
	_givevehicle(source, args, 'boat')
end)

RegisterCommand('_giveheli', function(source, args)
	_givevehicle(source, args, 'helicopter')
end)

function _givevehicle(_source, _args, vehicleType)
	if _source == 0 then
		local target = tonumber(_args[1])
		if _args[1] == nil or _args[2] == nil then
			print("SYNTAX ERROR: _givevehicle <playerID> <carModel> [plate]")
		else
			local model = _args[2]
			local playerName = GetPlayerName(target)

			if playerName == nil then
				print("Player ID " .. tostring(target) .. " does not exist")
				return
			end

			if _args[3] ~= nil then
				local plate = _args[3]
				if #_args > 3 then
					for i=4, #_args do
						plate = plate .. " " .. _args[i]
					end
				end
				plate = string.upper(plate)
				TriggerClientEvent('esx_giveownedcar:spawnVehiclePlate', target, target, model, plate, playerName, 'console', vehicleType)
			else
				TriggerClientEvent('esx_giveownedcar:spawnVehicle', target, target, model, playerName, 'console', vehicleType)
			end
			print("Vehicle given to player ID " .. target .. " with model " .. model)
		end
	end
end

-- Functions --
ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

RegisterServerEvent('esx_giveownedcar:setVehicle')
AddEventHandler('esx_giveownedcar:setVehicle', function (vehicleProps, playerID, vehicleType)
	local _source = playerID
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type) VALUES (@owner, @plate, @vehicle, @stored, @type)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@stored']  = 1,
		['type'] = vehicleType
	}, function ()
		if Config.ReceiveMsg then
			TriggerClientEvent('esx:showNotification', _source, _U('received_car', string.upper(vehicleProps.plate)))
		end
	end)
end)

RegisterServerEvent('esx_giveownedcar:printToConsole')
AddEventHandler('esx_giveownedcar:printToConsole', function(msg)
	print(msg)
end)

function havePermission(_source)
	if _source == 0 then
		return true
	end

	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerGroup = xPlayer.getGroup()
	local isAdmin = false

	for k,v in pairs(Config.AuthorizedRanks) do
		if v == playerGroup then
			isAdmin = true
			break
		end
	end
	
	if IsPlayerAceAllowed(_source, "giveownedcar.command") then isAdmin = true end
	
	return isAdmin
end
