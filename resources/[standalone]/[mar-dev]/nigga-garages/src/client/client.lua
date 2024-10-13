-- // [VARIABLES] \\ --

today = { ['Functions'] = { ['Utils'] = {} } }
local isInInteraction = false
local removingVehicle = false

-- // [STARTUP] \\ --

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
end)

-- // [THREADS] \\ --

CreateThread(function()
	ESX.TriggerServerCallback('today-garages:server:cb:receive:shared', function(data)
		Shared = data
	end)
	while not Shared do Wait(0) end

	for i = 1, #Shared.Locations do
		if not Shared.Locations[i]['invisible'] then
			local blip = AddBlipForCoord(Shared.Locations[i]['interactCoords'])
			local garageType = Shared.Locations[i]['garageType']
			local value = Shared.Blips[garageType]
	
			if value then
				SetBlipSprite(blip, value.sprite)
                SetBlipColour(blip, value.color)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, 0.65)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(value.text)
				EndTextCommandSetBlipName(blip)
			else
				print('^2[' .. GetCurrentResourceName() .. ']^7 Invalid garage type: ' .. garageType)
			end
		end
	end
	

	while true do 
		local sleep = 750
		local coords = GetEntityCoords(cache.ped)

		for i=1, #Shared.Locations do
			if not IsPedInAnyVehicle(cache.ped, false) then
				local dist = #(coords - Shared.Locations[i]['interactCoords'])
				if dist <= 35.0 then 
					sleep = 0
					today.Functions.Utils.DrawMarker(Shared.Locations[i]['interactCoords'], 33, 176, 23)
					if dist <= 1.5 then
						if Shared.Locations[i]['garageType'] ~= 'polimpound' then
							exports['frp-interaction']:Interaction('success', '[E] - Open Garage', Shared.Locations[i]['interactCoords'], 2.5, GetCurrentResourceName() .. '-garage')
							if IsControlJustPressed(0, 38)  then 
								today.Functions.OpenGarage(i)
							end
						else
							exports['frp-interaction']:Interaction('success', '[E] - Open Politie Impound', Shared.Locations[i]['interactCoords'], 2.5, GetCurrentResourceName() .. '-garage')
							if IsControlJustPressed(0, 38)  then 
								today.Functions.OpenPimpound(i)
							end
						end
					end
				end
			elseif IsPedInAnyVehicle(cache.ped, false) then 
				local dist = #(coords - Shared.Locations[i]['removeCoords'])
				if dist <= 35.0 then 
					sleep = 0
					today.Functions.Utils.DrawMarker(Shared.Locations[i]['removeCoords'], 176, 23, 23)
					if dist <= 3.5 then 
						if Shared.Locations[i]['garageType'] ~= 'polimpound' then
							exports['frp-interaction']:Interaction('error', '[E] - Zet voertuig weg', Shared.Locations[i]['removeCoords'], 2.5, GetCurrentResourceName() .. '-garage')
							if IsControlJustPressed(0, 38) and not removingVehicle then 
								removingVehicle =true
								today.Functions.RemoveVehicle(i)
							end
						else
							exports['frp-interaction']:Interaction('success', '[E] - Zet Auto in Impound', Shared.Locations[i]['removeCoords'], 2.5, GetCurrentResourceName() .. '-garageimpound')
							if IsControlJustPressed(0, 38)  then 
								today.Functions.RemoveVehicleP(i)
							end
						end
					end
				end
			end
		end

		Wait(sleep)
	end
end)

-- // [EVENTS] \\ --

RegisterNetEvent('today-garages:client:open:garageOptions')
AddEventHandler('today-garages:client:open:garageOptions', function(data, voertuigmodel)
    lib.registerContext({
        id = 'today-garages:client:open:garageOptions',
        title = 'Garage Opties',
        options = {
            {
                title = 'Uit garage halen',
                event = 'today-garages:client:garage:spawnVehicle',
                icon = 'upload',
                args = data
            },
            {
                title = 'Voertuig hernoemen',
                icon = 'pencil-alt',
                onSelect = function()
                    local input = lib.inputDialog('Voertuig bijnaam geven.', {
                        { type = 'input', label = 'Specificeer de gewenste bijnaam' }
                    })

                    if not input or not input[1] then return end
                    TriggerServerEvent('today-garage:server:garage:vehicleLabel', data, input[1])
                end
            },
            {
                title = 'Schrijf voertuig over',
                icon = 'handshake',
                onSelect = function()
                    local input = lib.inputDialog('Voertuig overschrijven.', {
                        { type = 'input', label = 'Server-ID van de nieuwe eigenaar' },
                        { type = 'checkbox', label = 'Ik bevestig dat het bovenstaande Server-ID correct is en eigendom is van de nieuwe eigenaar.' },
                    })
            
                    if not input or not input[1] and not input[2] then return end
                    TriggerServerEvent('today-garage:server:garage:vehicleTransfer', data, input[1])
                end
            },
            {
                disabled = true
            },
            {
                title = 'Benzinelevel',
                icon = 'fas fa-gas-pump',
                progress = 65, -- Set the progress bar to the current fuel level
                colorScheme = 'blue'
            },
        }
    })

    lib.showContext('today-garages:client:open:garageOptions')
end)



RegisterNetEvent('today-garages:client:open:pimpound:garageOptions')
AddEventHandler('today-garages:client:open:pimpound:garageOptions', function(data)
	lib.registerContext({
		id = 'today-garages:client:open:pimpound:garageOptions',
		title = 'Garage Opties: Wat zou je graag willen doen?',
		options = {
			{
				title = 'Uit garage halen',
				event = 'today-garages:client:garage:spawnVehicle',
				description = 'Uit garage halen uit de garge | €15K',
				icon = 'upload',
				args = data
			},
		}
	})

	lib.showContext('today-garages:client:open:pimpound:garageOptions')
end)

RegisterNetEvent('today-garages:client:open:impoundOptions')
AddEventHandler('today-garages:client:open:impoundOptions', function(data)
	lib.registerContext({
		id = 'today-garages:client:open:impoundOptions',
		title = 'Inbeslagname Opties',
		options = {
			{
				title = 'Uit garage halen | €' .. Shared.Settings['prices']['impound'],
				event = 'today-garages:client:garage:spawnVehicle',
				icon = 'upload',
				args = data
			},
			{
				title = 'Voertuig hernoemen',
				icon = 'pencil-alt',
				onSelect = function()
					local input = lib.inputDialog('Voertuig bijnaam geven.', {
                        { type = 'input', label = 'Specificeer de gewenste bijnaam' }
                    })

					if not input or not input[1] then return end
					TriggerServerEvent('today-garage:server:garage:vehicleLabel', data, input[1])
				end
			},
			{
				title = 'Schrijf voertuig over',
				icon = 'handshake',
				onSelect = function()
					local input = lib.inputDialog('Voertuig overschrijven.', {
                        { type = 'input', label = 'Server-ID van de nieuwe eigenaar' },
                        { type = 'checkbox', label = 'Ik bevestig dat het bovenstaande Server-ID correct is en eigendom is van de nieuwe eigenaar.' },
                    })
            
					if not input or not input[1] and not input[2] then return end
					TriggerServerEvent('today-garage:server:garage:vehicleTransfer', data, input[1])
				end
			},
			{
				disabled = true
			},
			{
				title = 'Benzinelevel',
				icon = 'fas fa-gas-pump',
				progress = class ~= 13 and 75.0,
            	colorScheme = class ~= 13 and 'blue'
			}
		}
	})

	lib.showContext('today-garages:client:open:impoundOptions')
end)

RegisterNetEvent('today-garage:client:set:vehicleProperties')
AddEventHandler('today-garage:client:set:vehicleProperties', function(netId, data)
	local veh = NetworkGetEntityFromNetworkId(netId)
	SetEntityAsMissionEntity(veh, true)

	while not IsPedInAnyVehicle(cache.ped) do Wait(0) end

	ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(cache.ped), data)
	if veh == 'seasparrow' then ESX.Game.SetVehicleProperties(veh, { modRoof = 0 }) end
end)

RegisterCommand('jamie', function()
	lib.notify({
		title = 'Mar',
		description = 'Ik ga Sunnless zijn moeder creampien op PornHub!',
		type = 'success',
		icon = 'https://th.bing.com/th/id/OIP.nPbXoVqOCzk_8JqldYZ6XQHaEK?w=275&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7',
		duration = 100000000000
	})
end)

RegisterNetEvent('today-garages:client:garage:spawnVehicle')
AddEventHandler('today-garages:client:garage:spawnVehicle', function(data)
	local garage = Shared.Locations[data.index]['spawnCoords']
	local vehicle = data.props


	ESX.TriggerServerCallback('today-garages:server:cb:allowed:spawning', function(bool)

		if bool == true then
			if isInInteraction then return end
			isInInteraction = true

			if not data.impound and not data.polimpound then 
				for i=1, #garage do 
					if ESX.Game.IsSpawnPointClear(garage[i]['coords'], 5.0) then 
						today.Functions.Utils.LoadModel(vehicle.model)
						local netId = lib.callback.await('today-garage:server:cb:createVehicle', false, {
							model = vehicle.model,
							coord = vec3(garage[i]['coords']['x'], garage[i]['coords']['y'], garage[i]['coords']['z']),
							heading = garage[i]['coords']['w'],
							type = today.Functions.Utils.GetVehicleType(vehicle.model),
							prop = vehicle,
						})
						TriggerServerEvent('today-garages:server:set:vehicleState', 0, ESX.Math.Trim(vehicle.plate), data.index)
						isInInteraction = false
						return
					end
				end
				lib.notify({ type = 'error', title = 'Garage', description = 'Er staat al een voertuig op deze spawnpoint, probeer het opnieuw.' })
				isInInteraction = false
			elseif data.polimpound then 
				for i=1, #garage do 
					if ESX.Game.IsSpawnPointClear(garage[i]['coords'], 5.0) then 
						today.Functions.Utils.LoadModel(vehicle.model)
						local netId = lib.callback.await('today-garage:server:cb:createVehicle', false, {
							model = vehicle.model,
							coord = vec3(garage[i]['coords']['x'], garage[i]['coords']['y'], garage[i]['coords']['z']),
							heading = garage[i]['coords']['w'],
							type = today.Functions.Utils.GetVehicleType(vehicle.model),
							prop = vehicle,
						})
						TriggerServerEvent('today-garages:server:set:polimpound', 0, ESX.Math.Trim(vehicle.plate), data.index)
						isInInteraction = false
						return
					end
				end
				lib.notify({ type = 'error', title = 'Garage', description = 'Er staat al een voertuig op deze spawnpoint, probeer het opnieuw.' })
				isInInteraction = false
			else 
				for i=1, #garage do 
					if ESX.Game.IsSpawnPointClear(garage[i]['coords'], 5.0) then 
						ESX.TriggerServerCallback('today-garages:server:cb:canPayImpound', function(bool)
							if bool then 
								today.Functions.Utils.LoadModel(vehicle.model)
								local netId = lib.callback.await('today-garage:server:cb:createVehicle', false, {
									model = vehicle.model,
									coord = vec3(garage[i]['coords']['x'], garage[i]['coords']['y'], garage[i]['coords']['z']),
									heading = garage[i]['coords']['w'],
									type = today.Functions.Utils.GetVehicleType(vehicle.model),
									prop = vehicle,
								})
								TriggerServerEvent('today-garages:server:set:vehicleState', 0, ESX.Math.Trim(vehicle.plate), data.index)
								isInInteraction = false
							else 
								isInInteraction = false
							end
						end)
						return
					end
				end
				lib.notify({ type = 'error', title = 'Garage', description = 'Er staat al een voertuig op deze spawnpoint, probeer het opnieuw.' })
				isInInteraction = false
			end
		else
			lib.notify({ type = 'error', title = 'Garage', description = 'Deze voertuig staat al in today.' })
			local blip = AddBlipForCoord(bool)

			SetBlipSprite(blip, 409)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.6)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Jouw voertuig')
			EndTextCommandSetBlipName(blip)
			SetBlipRoute(blip, 1)
			Citizen.SetTimeout(60000, function()
				RemoveBlip(blip)
			end)
			isInInteraction = false
			return
		end
	end, vehicle.plate)
end)

-- // [FUNCTIONS] \\ --

today.Functions.OpenGarage = function(garageIndex)
	if IsPedInAnyVehicle(cache.ped, false) then return end

	local garageType = Shared.Locations[garageIndex]['garageType']
	ESX.TriggerServerCallback('today-garages:server:cb:receive:vehicles', function(result)
		if not result then return end


		local opts = {}
		opts[#opts + 1] = {
			title = 'Impound bekijken',
			description = 'Haal je voertuigen uit de impound',
			arrow = true,
			icon = 'warehouse',
			onSelect = function()
				today.Functions.OpenImpound(garageIndex)
			end
		}
		for i=1, #result do
			desc = 'Kenteken: ' .. result[i]['vehiclePlate']
			local event = 'today-garages:client:open:garageOptions'
			if result[i]['isStored'] ~= 1 and result[i]['polimpound'] ~= 1 then 
				event = 'today-garages:client:open:impoundOptions'
			end

			local canClick = true
			if result[i]['isStored'] ~= 0 then 
				canClick = false
			end

			if result[i]['polimpound'] == 1 then 
				desc = 'Status: Politie Impound'
				canClick = true
			end

			local vehicleLabel = GetDisplayNameFromVehicleModel(result[i]['vehicleProps']['model'])
			if result[i]['vehicleLabel'] then 
				vehicleLabel = result[i]['vehicleLabel']
			end

			opts[#opts + 1] = {
				title = vehicleLabel,
				description = desc,
				event = event,
				disabled = canClick,
				args = { index = garageIndex, props = result[i]['vehicleProps'] }
			}
		end

		lib.registerContext({
			id = 'today-garages:client:ui:show:garage',
			title = Shared.Locations[garageIndex]['garageLabel'],
			options = opts
		})
		lib.showContext('today-garages:client:ui:show:garage')
	end, garageType)
end

today.Functions.OpenPimpound = function(garageIndex)
	if IsPedInAnyVehicle(cache.ped, false) then return end

	local garageType = Shared.Locations[garageIndex]['garageType']
	ESX.TriggerServerCallback('today-garages:server:cb:receive:vehicles', function(result)
		if not result then return end

		if #result < 1 then lib.notify({ type = 'error', title = 'Garage', description = 'Je hebt geen voertuig in de impound staan' }) return end

		local opts = {}
		for i=1, #result do 
			if not result[i]['isStored'] then
				local vehicleLabel = GetDisplayNameFromVehicleModel(result[i]['vehicleProps']['model']) .. ' | €' .. Shared.Settings['prices']['impound']
				if result[i]['vehicleLabel'] then 
					vehicleLabel = result[i]['vehicleLabel']
				end

				opts[#opts + 1] = {
					title = vehicleLabel,
					description = ('Kenteken: %s'):format(result[i]['vehiclePlate']),
					event = 'exios-garages:client:open:impoundOptions',
					args = { index = garageIndex, props = result[i]['vehicleProps'], impound = true }
				}
			end
		end

		lib.registerContext({
			id = 'today-garages:client:ui:show:garage',
			title = 'Garage: ' .. Shared.Locations[garageIndex]['garageLabel'],
			options = opts
		})
		lib.showContext('today-garages:client:ui:show:garage')
	end, 'car')
end

today.Functions.OpenImpound = function(garageIndex)
	if IsPedInAnyVehicle(cache.ped, false) then return end

	local garageType = Shared.Locations[garageIndex]['garageType']
	ESX.TriggerServerCallback('today-garages:server:cb:receive:vehicles', function(result)
		if not result then return end
		

		if #result < 1 then lib.notify({ type = 'error', title = 'Garage', description = 'Je hebt geen voertuig in de impound staan' }) return end

		local opts = {}
		for i=1, #result do 
			if result[i]['isStored'] ~= 1 then
				if result[i]['polimpound'] == 0 then
					opts[#opts + 1] = {
						title = GetDisplayNameFromVehicleModel(result[i]['vehicleProps']['model']) .. ' | €' .. Shared.Settings['prices']['impound'],
						description = ('Kenteken: %s'):format(result[i]['vehiclePlate']),
						event = 'today-garages:client:open:impoundOptions',
						args = { index = garageIndex, props = result[i]['vehicleProps'], impound = true }
					}
				end
			end
		end

		lib.registerContext({
			id = 'today-garages:client:ui:show:impound',
			title = 'Impound: ' .. Shared.Locations[garageIndex]['garageLabel'],
			options = opts
		})
		lib.showContext('today-garages:client:ui:show:impound')
	end, garageType, 0)
end

today.Functions.RemoveVehicle = function(garageIndex)
	local vehicle = GetVehiclePedIsIn(cache.ped, false)
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

	ESX.TriggerServerCallback('today-garages:server:is:deleting:allowed', function(bool)
		if not bool then 
			lib.notify({ type = 'error', title = 'Garage', description = 'Dit voertuig is geen eigendom van jou!' })
			removingVehicle = false
			return 
		end

		TriggerServerEvent('today-garages:server:set:vehicleState', 1, plate, garageIndex)

		removingVehicle = false
		lib.notify({ type = 'success', title = 'Garage', description = 'Je voertuig is opgeslagen in de garage!' })
		ESX.Game.DeleteVehicle(vehicle)
	end, plate, garageIndex, ESX.Game.GetVehicleProperties(vehicle))
end

today.Functions.RemoveVehicleP = function(garageIndex)
	local vehicle = GetVehiclePedIsIn(cache.ped, false)
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

	ESX.TriggerServerCallback('today-garages:server:is:deleting:allowed:overheid', function(bool)
		if not bool then 
			lib.notify({ type = 'error', title = 'Garage', description = 'Jij bent geen Politie!' })
			removingVehicle = false
			return 
		end

		TriggerServerEvent('today-garages:server:set:polimpound', 1, ESX.Math.Trim(plate), garageIndex)

		removingVehicle = false
		lib.notify({ type = 'success', title = 'Garage', description = 'Je voertuig is opgeslagen in de Politie Impound!' })
		ESX.Game.DeleteVehicle(vehicle)
	end, plate, garageIndex, ESX.Game.GetVehicleProperties(vehicle))
end

local cachedData = {}

today.Functions.Utils.HandleCamera = function(garagePos, heading)
	if not garagePos then return end

	cachedData['cam'] = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

	SetCamCoord(cachedData['cam'], garagePos.x, garagePos.y, garagePos.z+0.5)
	SetCamNearDof(cachedData['cam'] , 0)
	SetCamActive(cachedData['cam'], true)
    RenderScriptCams(1, 1, 1, 1, 1)

    Citizen.SetTimeout(50, function()
        RenderScriptCams(0, 1, 1500, 1, 1)
        Citizen.SetTimeout(1500, function()
            DestroyCam(cachedData['cam'])
            cachedData['cam'] = nil
            isInInteraction = false
        end)
    end)
end