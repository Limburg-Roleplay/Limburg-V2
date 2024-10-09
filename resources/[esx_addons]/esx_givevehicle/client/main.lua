ESX = nil
local NumberCharset = {}
local Charset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

TriggerEvent('chat:addSuggestion', '/givecar', 'Give a car to player', {
	{ name="id", help="The ID of the player" },
    { name="vehicle", help="Vehicle model" },
    { name="<plate>", help="Vehicle plate, skip if you want random generate plate number" }
})

TriggerEvent('chat:addSuggestion', '/giveplane', 'Give an airplane to player', {
	{ name="id", help="The ID of the player" },
    { name="vehicle", help="Vehicle model" },
    { name="<plate>", help="Vehicle plate, skip if you want random generate plate number" }
})

TriggerEvent('chat:addSuggestion', '/giveboat', 'Give a boat to player', {
	{ name="id", help="The ID of the player" },
    { name="vehicle", help="Vehicle model" },
    { name="<plate>", help="Vehicle plate, skip if you want random generate plate number" }
})

TriggerEvent('chat:addSuggestion', '/giveheli', 'Give a helicopter to player', {
	{ name="id", help="The ID of the player" },
    { name="vehicle", help="Vehicle model" },
    { name="<plate>", help="Vehicle plate, skip if you want random generate plate number" }
})

TriggerEvent('chat:addSuggestion', '/delcarplate', 'Delete a owned vehicle by plate number', {
	{ name="plate", help="Vehicle's plate number" }
})

RegisterNetEvent('esx_giveownedcar:spawnVehicle')
AddEventHandler('esx_giveownedcar:spawnVehicle', function(model, playerName, type, vehicleType, coordsString)
    local playerPed = PlayerPedId()
    local coords
    print(GetPlayerServerId(PlayerId()), model, playerName, type, vehicleType, coordsString)
    
    -- Split the coordsString into separate components and convert them to numbers
    local coordsTable = {}
    for coord in string.gmatch(coordsString, "[^,]+") do
        table.insert(coordsTable, tonumber(coord))
    end
    
    -- Check if we have exactly 3 components for the vector3
    if #coordsTable ~= 3 then
    	coords = GetEntityCoords(playerPed)
    else
		coords = vector3(coordsTable[1], coordsTable[2], coordsTable[3])  
    end
    
    -- Create the vector3 from the coordinates
    
    local playerID = GetPlayerServerId(PlayerId())
    local playerPed = GetPlayerFromServerId(playerID)
    local carExist  = false
    print(playerID)
    
    ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle) --get vehicle info
        if DoesEntityExist(vehicle) then
            carExist = true
            
            local newPlate     = GeneratePlate()
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            vehicleProps.plate = newPlate
            TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID, vehicleType)
            ESX.Game.DeleteVehicle(vehicle)    
            
            if type ~= 'console' then
                ESX.ShowNotification(_U('gived_car', model, newPlate, playerName))
            else
                local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
                TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
            end                
        end        
    end)
    
    Wait(2000)
    if not carExist then
        if type ~= 'console' then
            ESX.ShowNotification(_U('unknown_car', model))
        else
            TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: "..model.." is an unknown vehicle model")
        end        
    end
end)


RegisterNetEvent('esx_giveownedcar:spawnVehiclePlate')
AddEventHandler('esx_giveownedcar:spawnVehiclePlate', function(playerID, model, plate, playerName, type, vehicleType)
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	local generatedPlate = string.upper(plate)
	local carExist  = false

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
		if not isPlateTaken then
			ESX.Game.SpawnVehicle(model, coords, 0.0, function(vehicle) --get vehicle info	
				if DoesEntityExist(vehicle) then
					carExist = true
					SetEntityVisible(vehicle, false, false)
					SetEntityCollision(vehicle, false)	
					
					local newPlate     = string.upper(plate)
					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
					vehicleProps.plate = newPlate
					TriggerServerEvent('esx_giveownedcar:setVehicle', vehicleProps, playerID, vehicleType)
					ESX.Game.DeleteVehicle(vehicle)
					if type ~= 'console' then
						ESX.ShowNotification(_U('gived_car',  model, newPlate, playerName))
					else
						local msg = ('addCar: ' ..model.. ', plate: ' ..newPlate.. ', toPlayer: ' ..playerName)
						TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
					end				
				end
			end)
		else
			carExist = true
			if type ~= 'console' then
				ESX.ShowNotification(_U('plate_already_have'))
			else
				local msg = ('ERROR: this plate is already been used on another vehicle')
				TriggerServerEvent('esx_giveownedcar:printToConsole', msg)
			end					
		end
	end, generatedPlate)
	
	Wait(2000)
	if not carExist then
		if type ~= 'console' then
			ESX.ShowNotification(_U('unknown_car', model))
		else
			TriggerServerEvent('esx_giveownedcar:printToConsole', "ERROR: "..model.." is an unknown vehicle model")
		end		
	end	
end)
function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end
-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end