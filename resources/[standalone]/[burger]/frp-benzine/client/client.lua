local isFueling = false
local vehicle
local moneytoPay = 0
local fuelBeforePaying = 0
local fuelSynced = false
local inBlacklisted = false
local mph = 0
local kmh = 0
local fuel = 0
local x = 0.01135
local y = 0.002
local objects = {}
ESX = exports["es_extended"]:getSharedObject()
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

Citizen.CreateThread(function()
	for k,v in pairs(Config.Settings['PumpModels']) do
		exports.qtarget:AddTargetModel(v, {
			options = {
				{
					event = 'frp-benzine:client:pumpvehicle',
					icon = 'fas fa-gas-pump',
					label = 'Tanken'
				},
				{
					event = 'frp-benzine:server:give:item',
					type = 'server',
					icon = 'fas fa-gas-pump',
					label = 'Koop een Jerrycan',
				}
			},
			distance = 2.5
		})
	end

	for i=1, #Config.Locations do 
		local blip = AddBlipForCoord(Config.Locations[i]['Coords'])

		SetBlipSprite(blip, 361)
		SetBlipScale(blip, 0.6)
		SetBlipColour(blip, 1)
		SetBlipDisplay(blip, 4)
		SetBlipAsShortRange(blip, true)
	
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Tankstation')
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('frp-benzine:client:not:enough:money')
AddEventHandler('frp-benzine:client:not:enough:money', function()
	SetFuel(vehicle, fuelBeforePaying)
end)

RegisterNetEvent('frp-benzine:client:pumpvehicle')
AddEventHandler('frp-benzine:client:pumpvehicle', function(data)
	if IsPedInAnyVehicle(PlayerPedId(), false) then return end
	local pos = GetEntityCoords(PlayerPedId())
    vehicle = ESX.Game.GetClosestVehicle(pos)
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))
	local ped = PlayerPedId()

	if distance < 3.5 then
		fuelBeforePaying = GetVehicleFuelLevel(vehicle)
		if fuelBeforePaying < 100.0 and not isFueling then
			TaskTurnPedToFaceEntity(PlayerPedId(), vehicle, 1000)
			Citizen.Wait(1000)
			LoadAnimDict('timetable@gardener@filling_can')
			TaskPlayAnim(PlayerPedId(), 'timetable@gardener@filling_can', 'gar_ig_5_filling_can', 3.0, 3.0, -1, 2, 0, 0, 0, 0)
			SendNUIMessage({
				type = 'openPlaceholder',
				text = '<b>[E]</b> Stoppen met tanken'
			})

			if data.jerrycan then
				TriggerServerEvent('frp-benzine:server:take:item')
			end

			isFueling = true
			moneytoPay = 0

			while isFueling do
				Citizen.Wait(500)
				local currentFuel = GetVehicleFuelLevel(vehicle)
				local oldFuel = GetFuel(vehicle)
				local fuelToAdd = math.floor(math.random(10, 20) / 10.0)
				if not data.jerrycan then
					moneytoPay = (fuelToAdd + math.floor(fuelToAdd * Config.Settings['Prices']['Refill']))
				end
				
				if IsPedInAnyVehicle(ped) then
					isFueling = false
				end

				if currentFuel >= 99.0 then
					currentFuel = 100.0
					isFueling = false
				end

				SetFuel(vehicle, currentFuel+fuelToAdd)

				if not isFueling then
					SendNUIMessage({
						type = 'closePlaceholder'
					})
					ClearPedTasks(PlayerPedId())
					RemoveAnimDict('timetable@gardener@filling_can')
					if ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'ambulance' and ESX.PlayerData.job.name ~= 'kmar' and ESX.PlayerData.job.name ~= 'mechanic' then
						TriggerServerEvent('frp-benzine:server:fuel:vehicle', moneytoPay)
					else
						ESX.ShowNotification('info', 'Je hebt €' .. moneytoPay .. ' betaald met je tankpas!')
					end
					return
				end
			end
		else
			ESX.ShowNotification('error', 'Je voertuig is al vol getankt..', 5000)
		end
	else
		ESX.ShowNotification('error', 'Je voertuig staat te ver weg..', 5000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		local pedCoords = GetEntityCoords(PlayerPedId())

		if isFueling then
			sleep = 0
			local coords = GetEntityCoords(vehicle)
			local currentFuel = tonumber(GetVehicleFuelLevel(vehicle))
			local text = currentFuel < 60 and '~r~' .. ESX.Math.Round(currentFuel) .. '%' or '~g~' .. ESX.Math.Round(currentFuel) .. '%'
			ESX.Game.Utils.DrawText(coords.x, coords.y, coords.z, '~b~Benzine: ~w~' .. text)
			if IsControlJustReleased(0, 38) then 
				isFueling = false
				SendNUIMessage({
					type = 'closePlaceholder'
				})
				ClearPedTasks(PlayerPedId())
				RemoveAnimDict('timetable@gardener@filling_can')
			end
		end

		for i=1, #Config.LocationsObjects do
			local coords = vec3(Config.LocationsObjects[i].coords.x, Config.LocationsObjects[i].coords.y, Config.LocationsObjects[i].coords.z)
			local dist = #(coords-pedCoords)

			if not Config.LocationsObjects[i].spawned and dist <= 25.0 then
				Config.LocationsObjects[i].spawned = true

				ESX.Game.SpawnLocalObject(-164877493, coords, function(object)
					objects[#objects+1] = object
					PlaceObjectOnGroundProperly(object)
					SetEntityHeading(object, Config.LocationsObjects[i].coords.w)
				end)
			end
		end

		Wait(sleep)
	end
end)

function GetFuel(veh)
	return DecorGetFloat(veh, Config.Settings['FuelDecor'])
end

function SetFuel(veh, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(veh, fuel + 0.0)
		DecorSetFloat(veh, Config.Settings['FuelDecor'], fuel + 0.0)
	end
end

exports('setFuel', SetFuel)
exports('getFuel', GetFuel)

function LoadAnimDict(AnimDict)
    RequestAnimDict(AnimDict)
    while not HasAnimDictLoaded(AnimDict) do
        Citizen.Wait(1)
    end
end

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		local sleep = 500

		if vehicle ~= 0 and not inBlacklisted then
			fuel = tostring(math.ceil(GetVehicleFuelLevel(vehicle)))
		end

		Wait(sleep)
	end
end)
	
local otherRpm = {
	[14] = true,
	[15] = true,
	[16] = true
}

function ManageFuelUsage(vehicle)
	if IsVehicleEngineOn(vehicle) then
		local class = GetVehicleClass(vehicle)
		if not otherRpm[class] then
			SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[class] or 1.0) / 10)
			return
		end

		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - 1.3 * (Config.Classes[class] or 1.0) / 10)
	end
end

Citizen.CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, index)
	end

	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if GetCurrentResourceName() ~= resourceName then return end

	for i=1, #objects do
		DeleteEntity(objects[i])
	end
end)