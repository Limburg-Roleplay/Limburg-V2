ESX = nil
JobName = nil
local PlayerData = {}
local JobName = nil

Citizen.CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	DrawBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
	ESX.SetPlayerData('job', Job)
end)

DrawBlips = function()
	for i=1, #Config.Blips, 1 do
		local v = Config.Blips[i]
		local blip = AddBlipForCoord(v.Coords)
		SetBlipSprite(blip, Config.BlipSprite)
		SetBlipDisplay(blip, Config.BlipDisplay)
		SetBlipScale(blip, Config.BlipScale)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.BlipLabel)
		EndTextCommandSetBlipName(blip)
	end
end

IsPlayerJob = function()
	local bool = ESX.PlayerData.job.name == 'mechanic' and true or ESX.PlayerData.job.name == 'offmechanic' and true or false
	return bool
end

IsPlayerOnDuty = function()
	local bool = ESX.PlayerData.job.name == 'mechanic' and true or false
	return bool
end

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end

	DrawBlips()

	for i=1, #Config.Peds do
		local ped = Config.Peds[i]
		local script = GetCurrentResourceName()
		ESX.CreateFreezedPed(ped.model, ped.coords, ped.heading, ped.scenario, script)
	end

	for k,v in pairs(Config.Vehicles.cars) do 
		for l,v in pairs(v.vehicles) do
			AddTextEntry(v.spawnName, v.name)
		end	
	end
    
    while true do
		local sleep = 500
		if IsPlayerOnDuty() then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)

			for k,v in pairs(Config.Locations) do
				if v.rank == nil then v.rank = 0 end
				if v.rank <= tonumber(ESX.PlayerData.job.grade) and (v.target == nil or v.target == false) then
					if (v.drawText == 'Voertuig wegzetten' and IsPedInAnyVehicle(playerPed, true)) or v.drawText ~= 'Voertuig wegzetten' then
						local dist = #(coords - v.coords)
						if dist <= 20.0 and dist > 1.0 then
							sleep = 0
							if v.drawText == 'Voertuig wegzetten' then
								if v.deleteType == 'heli' then
									if IsPedInAnyHeli(playerPed) then
										ESX.DrawBasicMarker(v.coords, 255, 0, 0)
									end
								else
									ESX.DrawBasicMarker(v.coords, 255, 0, 0)
								end
							else
								ESX.DrawBasicMarker(v.coords, 242, 170, 0)
							end
						elseif dist < 1.0 then
							sleep = 0
							if v.drawText ~= nil then
								if v.drawText == 'Voertuig wegzetten' then
									if v.deleteType == 'heli' then
										if IsPedInAnyHeli(playerPed) then
											exports[''..Config.interaction..'']:Interaction('error', '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
											ESX.DrawBasicMarker(v.coords, 255, 0, 0)
										end
									else
										exports[''..Config.interaction..'']:Interaction('error', '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
										ESX.DrawBasicMarker(v.coords, 255, 0, 0)
									end
								else
									exports[''..Config.interaction..'']:Interaction({r = '242', g = '170', b = '0'}, '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
									ESX.DrawBasicMarker(v.coords, 242, 170, 0)
								end
								if IsControlJustReleased(0, 38) then
									if v.type == nil then v.type = 'default' end

									v['functionDefine'](v.type, k);
								end
							end
						end
					end
				end
			end
		elseif IsPlayerJob() then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			
			for k,v in pairs(Config.Locations) do
				if v.drawText == 'In-/uitklokken' then
					local dist = #(coords - v.coords)
					if dist <= 20.0 and dist > 1.0 then
						sleep = 0
						ESX.DrawBasicMarker(v.coords, 242, 170, 0)
					elseif dist < 1.0 then
						sleep = 0
						if v.drawText ~= nil then
							
							exports[''..Config.interaction..'']:Interaction({r = '242', g = '170', b = '0'}, '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
							ESX.DrawBasicMarker(v.coords, 242, 170, 0)

							if IsControlJustReleased(0, 38) then
								if v.type == nil then v.type = 'default' end

								v['functionDefine'](v.type, k);
							end
						end
					end
				end
			end
		end

		Wait(sleep)
    end
end)

OpenGarage = function(type, id)

	local configType = Config.Vehicles.cars
	if type == 'airport' then 
		configType = Config.Vehicles.air
	end
	local categories = {}

	for i=1, #configType do
		if configType[i].rank <= tonumber(ESX.PlayerData.job.grade) then
			categories[#categories+1] = {
				title = configType[i].category,
				description = configType[i].description,
				arrow = true,
				onSelect = function(args)
					OpenVehiclesMenu(type, configType, args)
				end,
				args = { category = i, garageIndex = id }
			}
		end
	end

	lib.registerContext({
		id = 'anwb:garage-menu',
		title = 'ANWB: Garage',
		options = categories
	})

	lib.showContext('anwb:garage-menu')
end

OpenVehiclesMenu = function(type, configType, data)
	local vehicles = {}

	for i=1, #configType[data.category].vehicles do 
		vehicles[#vehicles+1] = {
			title = configType[data.category].vehicles[i].name,
			event = 'frp-anwb:client:spawn:vehicle',
			args = { vehicleName = configType[data.category].vehicles[i].spawnName, garageIndex = data.garageIndex}
		}
	end

	lib.registerContext({
		id = 'anwb:garage-menu:vehicles',
		title = configType[data.category].category,
		onExit = function()
			OpenGarage(type, data.garageIndex)
		end,
		options = vehicles
	})

	lib.showContext('anwb:garage-menu:vehicles')
end

DeleteVehicle = function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
		ESX.Game.DeleteVehicle(vehicle)
    end
end

RemoveVehicle = function(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
end

OnOffDuty = function()
	exports[''..Config.Jobsmenu..'']:ToggleDuty(ESX.PlayerData.job.name)
end

RegisterNetEvent('frp-anwb:client:own:cloakroom')
AddEventHandler('frp-anwb:client:own:cloakroom', function()
	if ESX.PlayerData.job.name == 'mechanic' then
		exports[''..Config.Kleding..'']:openSavedOutfits()
		--exports['ox_appearance']:showOutfitMenu()
	end
end)

RegisterNetEvent('frp-anwb:client:anwb:cloakroom')
AddEventHandler('frp-anwb:client:anwb:cloakroom', function()
	if ESX.PlayerData.job.name == 'mechanic' then
		exports[''..Config.Jobsmenu..'']:OpenOutfitMenu(Config.Outfits)
	end
end)

CloakroomMenu = function()
	if ESX.PlayerData.job.name == 'mechanic' then
		local options = {
			[1] = {
				['title'] = 'Persoonlijke kleedkamer',
				['description'] = 'Bekijk je eigen outfits',
				['event'] = 'frp-anwb:client:own:cloakroom'
			},
			[2] = {
				['title'] = 'Algemene kleedkamer',
				['description'] = 'Bekijk de ANWB outfits',
				['event'] = 'frp-anwb:client:anwb:cloakroom'
			},
		}

		lib.registerContext({
			id = 'anwb:check-cloakroom',
			title = 'ANWB: Bekijk opties van Kleedkamer',
			options = options
		})
		
		lib.showContext('anwb:check-cloakroom')
	end
end

local CurrentlyTowedVehicle

RegisterNetEvent('frp-anwb:client:spawn:vehicle')
AddEventHandler('frp-anwb:client:spawn:vehicle', function(data)
	local garage = Config.Locations[data.garageIndex]
	local vehicle = data.vehicleName
	local foundPoint = false
	local props = {['plate'] = 'ANWB' .. math.random(111111, 999999)}

	for i=1, #garage.spawnPoints, 1 do 
		if ESX.Game.IsSpawnPointClear(vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), 2.0) then 
			ESX.Game.SpawnVehicle(vehicle, vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), garage.spawnPoints[i].w, function(veh)
				TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
				SetVehicleNumberPlateText(veh, props.plate)
				exports[''..Config.Carkeys..'']:giveCarKeys(GetVehicleNumberPlateText(veh), ESX.Game.GetVehicleProperties(veh))
				exports[''..Config.Benzine..'']:setFuel(veh, 100.0)
			end, true, props)
			foundPoint = true 
			break
		end
	end

	if not foundPoint then
		exports[''..Config.Notify..'']:Notify('error', 'Er zijn geen lege parkeerplekken!', 5000)
	end
end)

RegisterNetEvent('frp-anwb:client:toggle:flatbed')
AddEventHandler('frp-anwb:client:toggle:flatbed', function(data)
	local playerPed = PlayerPedId()
	
	Citizen.CreateThread(function()
		local attempt = 0
		if liftedVehicle == nil then
			firstvehicle = 0
			secondvehicle = 0
			while true do
				Wait(0)
				local coords = GetEntityCoords(PlayerPedId())
				local veh = ESX.Game.GetClosestVehicle()
				if firstvehicle == 0 then
					if veh ~= 0 and GetEntityModel(veh) == `flatbed` or veh ~= 0 and GetEntityModel(veh) == `flatbed2` or veh ~= 0 and GetEntityModel(veh) == `flatbed4` then
						local vehCoords = GetEntityCoords(veh)
						ESX.Game.Utils.DrawMarker(vehCoords, 2, 0.2, 38, 255, 0)
						ESX.Game.Utils.DrawText(vehCoords.x, vehCoords.y, vehCoords.z + 1.8, '~b~E~w~ - Selecteer Flatbed')
						if IsControlJustReleased(0, 38) then
							firstvehicle = veh
						end
					end
				elseif secondvehicle == 0 then
					if veh ~= 0 and GetEntityModel(veh) ~= `flatbed` and GetEntityModel(veh) ~= `flatbed2`  and GetEntityModel(veh) ~= `flatbed4` then
						local vehCoords = GetEntityCoords(veh)
						ESX.Game.Utils.DrawMarker(vehCoords, 2, 0.2, 38, 255, 0)
						ESX.Game.Utils.DrawText(vehCoords.x, vehCoords.y, vehCoords.z + 1.8, '~b~E~w~ - Selecteer Voertuig')
						if IsControlJustReleased(0, 38) then
							secondvehicle = veh
						end
					end
				else
					while not NetworkHasControlOfEntity(secondvehicle) and attempt < 100 and DoesEntityExist(secondvehicle) do
						Citizen.Wait(100)
						NetworkRequestControlOfEntity(secondvehicle)
						attempt = attempt + 1
					end
					if NetworkHasControlOfEntity(secondvehicle) then
						AttachEntityToEntity(secondvehicle, firstvehicle, 0, 0.0, -2.7, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						liftedVehicle = secondvehicle
						return
					end
				end
			end
		else
			local coords = GetEntityCoords(PlayerPedId())
			local vehpos = GetEntityCoords(liftedVehicle)
			local distance = GetDistanceBetweenCoords(vehpos, coords, true)
			if distance <= 3.0 then
				while not NetworkHasControlOfEntity(liftedVehicle) and attempt < 100 and DoesEntityExist(liftedVehicle) do
					Citizen.Wait(100)
					NetworkRequestControlOfEntity(liftedVehicle)
					attempt = attempt + 1
				end
				if NetworkHasControlOfEntity(liftedVehicle) then
					AttachEntityToEntity(liftedVehicle, firstvehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					DetachEntity(liftedVehicle, true, true)
					liftedVehicle = nil
					firstvehicle = 0
					secondvehicle = 0
				end
			end
		end
	end)
end)

Citizen.CreateThread(function()
	exports.qtarget:AddTargetModel(GetHashKey('prop_fncsec_04a'), {
		options = {
			{
				icon = "fa-solid fa-warehouse",
				label = "Pak Dranghek op",
				event = 'frp-resources:client:objDelete:pion',
				job = 'mechanic'
			},
		},
		distance = 2.5
	})

	exports.qtarget:AddTargetModel(GetHashKey('prop_roadcone02b'), {
		options = {
			{
				icon = "fa-solid fa-warehouse",
				label = "Pak Pilon op",
				event = 'frp-resources:client:objDelete:pion',
				job = 'mechanic'
			},
		},
		distance = 2.5
	})

	exports['qtarget']:Vehicle({
		options = {
			{
				event = 'frp-anwb:client:repair:vehicle',
				icon = 'fas fa-screwdriver-wrench',
				label = 'Voertuig repareren',
				item = 'repairkit'
			},
			{
				event = 'frp-anwb:client:wash:vehicle',
				icon = 'fas fa-hand-sparkles',
				label = 'Voertuig schoonmaken',
				item = 'washand'
			},
			{
				event = 'frp-anwb:client:toggle:flatbed',
				icon = 'fa-solid fa-car',
				label = 'Voertuig op flatbed zetten',
				canInteract = function(vehicle)
					local bool = GetEntityModel(vehicle) == GetHashKey('flatbed') and true or false
					return bool
				end,
				job = 'mechanic'
			},
			{
				event = 'frp-anwb:client:repair:vehicle',
				icon = 'fas fa-screwdriver-wrench',
				label = 'Voertuig repareren',
				job = 'mechanic'
			},
			{
				event = 'frp-anwb:client:wash:vehicle',
				icon = 'fas fa-hand-sparkles',
				label = 'Voertuig schoonmaken',
				job = 'mechanic'
			},
			{
				event = 'frp-politie:client:shut:vehicle',
				icon = 'fa-solid fa-car',
				label = 'Voertuig openbreken',
				job = 'mechanic'
			},
		},
		distance = 2
	})

	exports['qtarget']:Player({
		options = {
			{
				event = 'frp-anwb:client:send:factuur',
				icon = 'fa-solid fa-clipboard',
				label = 'Verstuur factuur',
				job = 'mechanic'
			},
		},
		distance = 2
	})
end)

RegisterNetEvent('frp-anwb:client:set:clothing')
AddEventHandler('frp-anwb:client:set:clothing', function(data)
	if not data or not data.item then return end 
	ESX.Game.PlayAnim('missmic4', 'michael_tux_fidget', 8.0, 1500, 51)
	Wait(1500)
	ESX.Game.PlayAnim('clothingtie', 'try_tie_negative_a', 8.0, 1200, 51)
	Wait(1200)
	ESX.Game.PlayAnim('re@construction', 'out_of_breath', 8.0, 1300, 51)
	Wait(1300)
	ESX.Game.PlayAnim('random@domestic', 'pickup_low', 8.0, 1200, 51)
	Wait(1200)
	setClothing(data.item, data.reset)
end)

RegisterNetEvent('frp-anwb:client:repair:vehicle')
AddEventHandler('frp-anwb:client:repair:vehicle', function(data)
	local vehicle = data.entity
	if vehicle ~= nil then 
		if Config.Actions.repairVehicle.actions.animation.enabled then 
			TaskStartScenarioInPlace(PlayerPedId(), Config.Actions.repairVehicle.actions.animation.scenario, 0, true) 
		end
		TriggerServerEvent('frp-anwb:server:repair:vehicle')
		exports[''..Config.Progress..'']:Progress({
			name = 'anwb:repair-vehicle',
			duration = Config.Actions.repairVehicle.actions.animation.duration,
			label = 'Voertuig aan het repareren',
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
		}, function(cancelled)
			if not cancelled then
				ClearPedTasks(PlayerPedId())
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				SetVehicleEngineOn(vehicle, true, true)
				SetVehicleOnGroundProperly(vehicle)
			end
		end)
	else
		ESX.ShowNotification('Dit voertuig bestaat niet', 'error')
	end
end)

RegisterNetEvent('frp-anwb:client:wash:vehicle')
AddEventHandler('frp-anwb:client:wash:vehicle', function(data)
	local vehicle = data.entity
	if vehicle ~= nil then 
		if Config.Actions.washVehicle.actions.animation.enabled then 
			TaskStartScenarioInPlace(PlayerPedId(), Config.Actions.washVehicle.actions.animation.scenario, 0, true) 
		end
		TriggerServerEvent('frp-anwb:server:wash:vehicle')
		exports[''..Config.Progress..'']:Progress({
			name = 'fitstop:wash-vehicle',
			duration = Config.Actions.washVehicle.actions.animation.duration,
			label = 'Voertuig aan het schoonmaken',
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
		}, function(cancelled)
			if not cancelled then
				ClearPedTasks(PlayerPedId())
				SetVehicleDirtLevel(vehicle, 0.0)
				exports[''..Config.Notify..'']:Notify('success', 'Je hebt het voertuig gewassen!', 5000)
				xPlayer.removeInventoryItem('washand', 1)
			end
		end)
	else
		exports[''..Config.Notify..'']:Notify('error', 'Dit voetuig bestaat niet!', 5000)
	end
end)

RegisterNetEvent('frp-anwb:client:send:factuur')
AddEventHandler('frp-anwb:client:send:factuur', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))

	if distance < 2.0 then
		local options = {
			{
				['title'] = 'Zoek een dienst',
				['description'] = 'Zoek hiermee sneller een dienst',
				['event'] = 'frp-anwb:client:search:fine:list',
				['args'] = { entity = entity }
			}
		}

		for k,v in pairs(Config.Fines) do
			options[#options+1] = {
				title = k,
				event = 'frp-anwb:client:give:fine:list',
				args = { fineId = k, entity = entity }
			}
		end

		lib.registerContext({
			id = 'ambu:see-fines',
			title = 'ANWB: bekijk diensten',
			options = options
		})

		lib.showContext('ambu:see-fines')
	end
end)

RegisterNetEvent('frp-anwb:client:search:fine:list')
AddEventHandler('frp-anwb:client:search:fine:list', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))

	if distance < 2.0 then
		local input = lib.inputDialog('Zoek een dienst', {'Dienst beschrijving'})
		if input then 
			local reason = input[1]
			local found = {}
			local options = {}

			for k,v in pairs(Config.Fines) do
				for i=1, #Config.Fines[k] do
					if string.find(Config.Fines[k][i].label, reason) then
						found[#found+1] = {
							['label'] = Config.Fines[k][i].label,
							['amount'] = Config.Fines[k][i].amount,
							['fineID'] = k,
							['number'] = i
						}
					end
				end
			end

			for i=1, #found do
				options[#options+1] = {
					title = found[i].label .. ' | € ' .. found[i].amount,
					event = 'frp-anwb:client:give:fine:finalise',
					args = { fineId = found[i].fineID, fine = found[i].number, entity = entity }
				}
			end

			if next(options) then
				lib.registerContext({
					id = 'ambu:searched-fines',
					title = 'Politie: bekijk diensten',
					options = options
				})
		
				lib.showContext('ambu:searched-fines')
			else
				ESX.ShowNotification('error', 'Er zijn geen diensten gevonden..')
			end
		end
	end
end)

RegisterNetEvent('frp-anwb:client:give:fine:list')
AddEventHandler('frp-anwb:client:give:fine:list', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
	if distance < 2.0 then
		local options = {}
		for i=1, #Config.Fines[data.fineId] do
			options[#options+1] = {
				title = Config.Fines[data.fineId][i].label .. ' | € ' .. Config.Fines[data.fineId][i].amount,
				event = 'frp-anwb:client:give:fine:finalise',
				args = { fineId = data.fineId, fine = i, entity = entity }
			}
		end

		lib.registerContext({
			id = 'ambu:see-fines-list',
			title = 'ANWB: bekijk diensten',
			options = options
		})

		lib.showContext('ambu:see-fines-list')
	end
end)

RegisterNetEvent('frp-anwb:client:give:fine:finalise')
AddEventHandler('frp-anwb:client:give:fine:finalise', function(data)
	local entityPlayer = ESX.Game.GetPlayerFromPed(data.entity)
	local playerid = GetPlayerServerId(entityPlayer)

	TriggerServerEvent('esx_billing:sendBill', playerid, 'society_mechanic', Config.Fines[data.fineId][data.fine].label,Config.Fines[data.fineId][data.fine].amount)
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Anwb',
		number     = 'mechanic',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTV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'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

sendDispatch = function()
    local message = "Auto Kapot"
    local location =
        "Location: X: " ..
        GetEntityCoords(PlayerPedId()).x ..
            ", Y: " .. GetEntityCoords(PlayerPedId()).y .. ", Z: " .. GetEntityCoords(PlayerPedId()).z

    if exports.ox_inventory:Search("count", "phone") > 0 then
        --[[exports["lb-phone"]:SendCompanyMessage('ambulance', message)
        exports["lb-phone"]:SendCompanyCoords('ambulance')--]]
        exports["esx_addons_gcphone"]:sendMessage("anwb", message, location)
    end
end

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and ESX.PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.EnableESXService and not playerInService then
			CancelEvent()
		end
	end
end)


-- Boss menu

exports.ox_target:addBoxZone({
    coords = vector3(-339.8128, -156.6197, 45.4863-1),
    size = vector3(2,2,2),
    rotation = 45,
    options = {
        {
            name = "asq:anwbmenu",
            label = "ANWB Menu",
            icon = "fa-solid fa-clipboard",
            debug = drawZones,
            groups = { ['mechanic'] = 10 },
            onSelect = function ()
				lib.showContext('anwbmenu')
			end
        }
    }
})

lib.registerContext({
    id = 'anwbmenu', 
    title = 'ANWB Menu',
    options = {
      {
        title = 'Neem personeel aan',
        description = 'Neem een persoon aan.',
        icon = 'box',
        onSelect = function()
            Neempersonenaan()
        end,
      },
      {
        title = 'Beheer Personeel',
        description = 'Beheer het ANWB Personeel!',
        icon = 'clipboard',
        onSelect = function()
            Checkpersons()
        end,
      },
    }
})

Checkpersons = function()
    local check = {}
    local speler = PlayerPedId()
    local jobnaam = ESX.PlayerData.job.name
    ESX.TriggerServerCallback("frp-anwb:check:gangmembers", function(datagang)
        for k,v in pairs(datagang) do 
            table.insert(check, {
                title = v.voornaam .. " " .. v.achternaam,
                description = 'Rang: ' .. v.grade,
                icon = 'user',
                onSelect = function()
                    OpenMenumembersboss(v)
                end
            })
        end
        lib.registerContext({
            id = 'anwbmenu-members',
            title = "ANWB Menu | Personeel",
            options = check
        })
        lib.showContext('anwbmenu-members')
    end, jobnaam)
end

OpenMenumembersboss = function(value)
    ESX.UI.Menu.CloseAll()

    local options = {
        {
            title = value.voornaam .. " Demoten",
            description = '',
            icon = 'fas fa-minus',
            onSelect = function()
                local input = lib.inputDialog('Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt degraderen?', {
                    {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
                })
            
                if not input[1] then 
                    TriggerEvent('eros-notifications', 'error', 'Je bent niet akkoord gegaan met deze medewerker te degraderen.')
                    return 
                end
                DemotePlayer(value.identifier, value.voornaam)
            end
        },
        {
            title = value.voornaam .. " Promoveren",
            description = '',
            icon = 'fas fa-plus',
            onSelect = function()
    -- Prevent default or stop propagation here if supported by your UI framework
    local input = lib.inputDialog('Confirmation', {})
    if input then
        PromotePlayer(value.identifier, value.voornaam)
    end
    return false -- Depending on what lib supports to prevent further propagation
end
        },
        {
            title = value.voornaam .. " Ontslaan",
            description = '',
            icon = 'fas fa-fire',
            
            onSelect = function()

                local input = lib.inputDialog('Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt ontslaan?', {
                    {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
                })
            
                if not input[1] then 
                    TriggerEvent('eros-notifications', 'error', 'Je bent niet akkoord gegaan met deze medewerker te ontslaan.')
                    return 
                end

                Deletemembersboss(value.identifier, value.voornaam)
            end
        },
        {
            title = 'Ga terug',
            onSelect = function()
                checkpersons()
            end,
            icon = 'fas fa-arrow-left'
        }
    }

    lib.registerContext({
        id = 'anwbmenu-members-boss',
        title = "ANWB Menu | Members",
        options = options
    })
    lib.showContext('anwbmenu-members-boss')
end

-- Example of how to trigger the promotion event from client-side
function PromotePlayer(identifier, playerName)
    TriggerServerEvent("frp-anwb:promotemember", identifier, playerName)
end

-- Example of how to trigger the demotion event from client-side
function DemotePlayer(identifier, playerName)
    TriggerServerEvent("frp-anwb:demote", identifier, playerName)
end


function Deletemembersboss(x, y)
	TriggerServerEvent("frp-anwb:deletemember:serversided", x, y)
end


function Neempersonenaan()

	local jobnamegang = ESX.PlayerData.job.name

    local input = lib.inputDialog('ANWB Menu | Aannemen', {'Voer een speler id in'})
	if not input then 
		return 
	end

	local playerid = tonumber(input[1])

	if playerid then
		ESX.TriggerServerCallback('frp-anwb:add:playertogang', function(done)
			if done then
			end
		end, playerid, jobnamegang)
	else
	end
end