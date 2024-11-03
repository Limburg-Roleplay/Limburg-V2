OnDuty = false
local blip
local blip2
local doingProgress = false
local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
	for i=1, #Shared.Locations do
		if Shared.Locations[i]['job'] == ESX.PlayerData.job.name or Shared.Locations[i]['job'] == ESX.PlayerData.job2.name then
			blip = AddBlipForCoord(Shared.Locations[i]['inklok']['coords'].x, Shared.Locations[i]['inklok']['coords'].y, Shared.Locations[i]['inklok']['coords'].z)
			while blip == 0 do Wait(0) blip = AddBlipForCoord(Shared.Locations[i]['inklok']['coords']) end

			SetBlipHighDetail(blip, true)
			SetBlipSprite (blip, Shared.Locations[i]['blip']['sprite'])
			SetBlipScale  (blip, 0.75)
			SetBlipColour (blip, Shared.Locations[i]['blip']['color'])
			SetBlipAsShortRange(blip, true)
	
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Shared.Locations[i]['blip']['text'])
			EndTextCommandSetBlipName(blip)

			blip2 = AddBlipForCoord(Shared.Locations[i]['verkoop']['coords'].x, Shared.Locations[i]['verkoop']['coords'].y, Shared.Locations[i]['verkoop']['coords'].z)
			while blip2 == 0 do Wait(0) blip2 = AddBlipForCoord(Shared.Locations[i]['verkoop']['coords']) end

			SetBlipHighDetail(blip2, true)
			SetBlipSprite (blip2, Shared.Locations[i]['blip']['sprite'])
			SetBlipScale  (blip2, 0.75)
			SetBlipColour (blip2, Shared.Locations[i]['blip']['color'])
			SetBlipAsShortRange(blip2, true)
	
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Shared.Locations[i]['blip']['text'] .. " Verkoop")
			EndTextCommandSetBlipName(blip2)
			break
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job

	OnDuty = false
	RemoveBlip(blip)
	blip = nil
	RemoveBlip(blip2)
	blip2 = nil

	for i=1, #Shared.Locations do
		if Shared.Locations[i]['job'] == ESX.PlayerData.job.name then
			blip = AddBlipForCoord(Shared.Locations[i]['inklok']['coords'])
			while blip == 0 do Wait(0) blip = AddBlipForCoord(Shared.Locations[i]['inklok']['coords']) end

			SetBlipHighDetail(blip, true)
			SetBlipSprite (blip, Shared.Locations[i]['blip']['sprite'])
			SetBlipScale  (blip, 0.75)
			SetBlipColour (blip, Shared.Locations[i]['blip']['color'])
			SetBlipAsShortRange(blip, true)
	
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Shared.Locations[i]['blip']['text'])
			EndTextCommandSetBlipName(blip)
			
			blip2 = AddBlipForCoord(Shared.Locations[i]['verkoop']['coords'].x, Shared.Locations[i]['verkoop']['coords'].y, Shared.Locations[i]['verkoop']['coords'].z)
			while blip2 == 0 do Wait(0) blip2 = AddBlipForCoord(Shared.Locations[i]['verkoop']['coords']) end

			SetBlipHighDetail(blip2, true)
			SetBlipSprite (blip2, Shared.Locations[i]['blip']['sprite'])
			SetBlipScale  (blip2, 0.75)
			SetBlipColour (blip2, Shared.Locations[i]['blip']['color'])
			SetBlipAsShortRange(blip2, true)
	
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Shared.Locations[i]['blip']['text'] .. " Verkoop")
			EndTextCommandSetBlipName(blip2)
			break
		end
		for a=1, #Shared.Locations[i]['actions'] do
			if Shared.Locations[i]['actions'][a].blip then
				RemoveBlip(Shared.Locations[i]['actions'][a].blip)
			end
		end
	end
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(Job)
 	ESX.PlayerData.job2 = Job

 	OnDuty = false
 	RemoveBlip(blip)
 	blip = nil
 	RemoveBlip(blip2)
 	blip2 = nil

 	for i=1, #Shared.Locations do
 		if Shared.Locations[i]['job'] == ESX.PlayerData.job2.name then
 			blip = AddBlipForCoord(Shared.Locations[i]['inklok']['coords'])
 			while blip == 0 do Wait(0) blip = AddBlipForCoord(Shared.Locations[i]['inklok']['coords']) end

 			SetBlipHighDetail(blip, true)
 			SetBlipSprite (blip, Shared.Locations[i]['blip']['sprite'])
 			SetBlipScale  (blip, 0.75)
 			SetBlipColour (blip, Shared.Locations[i]['blip']['color'])
 			SetBlipAsShortRange(blip, true)
	
			BeginTextCommandSetBlipName("STRING")
 			AddTextComponentString(Shared.Locations[i]['blip']['text'])
 			EndTextCommandSetBlipName(blip)
			
 			blip2 = AddBlipForCoord(Shared.Locations[i]['verkoop']['coords'].x, Shared.Locations[i]['verkoop']['coords'].y, Shared.Locations[i]['verkoop']['coords'].z)
 			while blip2 == 0 do Wait(0) blip2 = AddBlipForCoord(Shared.Locations[i]['verkoop']['coords']) end

 			SetBlipHighDetail(blip2, true)
 			SetBlipSprite (blip2, Shared.Locations[i]['blip']['sprite'])
 			SetBlipScale  (blip2, 0.75)
 			SetBlipColour (blip2, Shared.Locations[i]['blip']['color'])
			SetBlipAsShortRange(blip2, true)
	
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Shared.Locations[i]['blip']['text'] .. " Verkoop")
			EndTextCommandSetBlipName(blip2)
			break
		end
		for a=1, #Shared.Locations[i]['actions'] do
			if Shared.Locations[i]['actions'][a].blip then
				RemoveBlip(Shared.Locations[i]['actions'][a].blip)
			end
 		end
 	end
 end)


RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('exios-nonwhitelistedjobs:client:action:not:correctly')
AddEventHandler('exios-nonwhitelistedjobs:client:action:not:correctly', function()
	Wait(250)
	OnDuty = false
end)

local plate = 'JOB' .. math.random(11111, 99999)
getPlate = function()
	return ESX.Math.Trim(plate)
end

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end
	while true do
		local sleep = 500
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		for i=1, #Shared.Locations do
			local dist = #(coords-Shared.Locations[i]['inklok']['coords'])
			local dist2 = #(coords-Shared.Locations[i]['verkoop']['coords'])
			if dist < 25 and ESX.PlayerData.job.name == Shared.Locations[i].job and not doingProgress or dist < 25 and ESX.PlayerData.job2.name == Shared.Locations[i].job and not doingProgress then
				sleep = 0
				ESX.Game.Utils.DrawMarker(Shared.Locations[i]['inklok']['coords'], 2, 0.2, Shared.Locations[i]['color'].r, Shared.Locations[i]['color'].g, Shared.Locations[i]['color'].b)

				if dist < 2.5 then
					if OnDuty then
						exports['frp-interaction']:Interaction({r = tostring(Shared.Locations[i]['color'].r), g = tostring(Shared.Locations[i]['color'].g), b = tostring(Shared.Locations[i]['color'].b)}, '[E] - Uitklokken', Shared.Locations[i]['inklok']['coords'], 5.0, GetCurrentResourceName())
					else
						exports['frp-interaction']:Interaction({r = tostring(Shared.Locations[i]['color'].r), g = tostring(Shared.Locations[i]['color'].g), b = tostring(Shared.Locations[i]['color'].b)}, '[E] - Inklokken', Shared.Locations[i]['inklok']['coords'], 5.0, GetCurrentResourceName())
					end
					if IsControlJustReleased(0, 38) and not OnDuty then
						local veh = GetVehiclePedIsIn(playerPed)
						ESX.TriggerServerCallback('exios-nonwhitelistedjobs:server:create:borg', function(bool)
							if bool then
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, 1)
								OnDuty = true
								exports['lrp-progressbar']:Progress({
									name = 'exios-nonwhitelisted/basic/inklokken',
									duration = 3500,
									label = 'Inklokken',
									useWhileDead = false,
									canCancel = true,
									controlDisables = {
										disableMovement = true,
										disableCarMovement = true,
										disableMouse = false,
										disableCombat = true,
									},
								}, function(cancelled)
									ClearPedTasksImmediately(playerPed)
									Citizen.SetTimeout(250, function()
										TriggerServerEvent('exios-nonwhitelistedjobs:server:action:inklokken', i)
									end)
									ESX.TriggerServerCallback('ox_appearance:getPlayerSkin', function(data)
										if data.model == 'mp_m_freemode_01' then -- Male
											exports['ox_appearance']:SetJobOutfit(Shared.Locations[i]['Outfit']['Male']['props'], Shared.Locations[i]['Outfit']['Male']['components'])
										elseif data.model == 'mp_f_freemode_01' then -- Female
											exports['ox_appearance']:SetJobOutfit(Shared.Locations[i]['Outfit']['Female']['props'], Shared.Locations[i]['Outfit']['Female']['components'])
										end
									end)
									doingProgress = false
									if ESX.PlayerData.job.name == 'duiker' or ESX.PlayerData.job2.name == 'duiker' then 
										SetEnableScuba(playerPed, true)
										SetPedMaxTimeUnderwater(playerPed, 1500.00)
										local maskModel = GetHashKey("p_d_scuba_mask_s")
										local tankModel = GetHashKey("p_s_scuba_tank_s")
								
										RequestModel(tankModel)
										while not HasModelLoaded(tankModel) do
											Citizen.Wait(1)
										end
										TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
										local bone1 = GetPedBoneIndex(playerPed, 24818)
										AttachEntityToEntity(TankObject, playerPed, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
										currentGear.tank = TankObject
								
										RequestModel(maskModel)
										while not HasModelLoaded(maskModel) do
											Citizen.Wait(1)
										end
										
										MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
										local bone2 = GetPedBoneIndex(playerPed, 12844)
										AttachEntityToEntity(MaskObject, playerPed, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
										currentGear.mask = MaskObject
								
										SetEnableScuba(playerPed, true)
										SetPedMaxTimeUnderwater(playerPed, 2000.00)
										currentGear.enabled = true
										ClearPedTasks(playerPed)
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
									end
								end)
							end
						end, plate, GetVehicleEngineHealth(veh))
					elseif IsControlJustReleased(0, 38) and OnDuty and not doingProgress then
						doingProgress = true
						TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, 1)
						exports['lrp-progressbar']:Progress({
							name = 'exios-nonwhitelisted/basic/uitklokken',
							duration = 3500,
							label = 'Uitklokken',
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
						}, function(cancelled)
							ClearPedTasksImmediately(playerPed)
							
							if DoesEntityExist(Shared.Locations[i]['vehicle']['activevehicle']) then
								DeleteVehicle(Shared.Locations[i]['vehicle']['activevehicle'])
							end

							for a=1, #Shared.Locations[i]['actions'] do
								if Shared.Locations[i]['actions'][a].blip then
									RemoveBlip(Shared.Locations[i]['actions'][a].blip)
									Shared.Locations[i]['actions'][a].blip = nil
								end
							end

							local count = 0
							local max = #Shared.Locations[i]['actions']
							for a=1, #Shared.Locations[i]['actions'] do
								if Shared.Locations[i]['actions'][a].ready then
									count = count + 1
								end
							end

							if count >= max then
								for a=1, #Shared.Locations[i]['actions'] do
									Shared.Locations[i]['actions'][a].ready = false
								end
							end

							TriggerServerEvent('exios-nonwhitelistedjobs:server:action:uitklokken', i)
							exports['ox_appearance']:SetCivilianOutfit()

							if ESX.PlayerData.job.name == 'duiker' or ESX.PlayerData.job2.name == 'duiker' then 
								SetEnableScuba(playerPed, false)
								SetPedMaxTimeUnderwater(playerPed, 5.00)
								if currentGear.mask ~= 0 then
									DetachEntity(currentGear.mask, 0, 1)
									DeleteEntity(currentGear.mask)
									currentGear.mask = 0
								end
								
								if currentGear.tank ~= 0 then
									DetachEntity(currentGear.tank, 0, 1)
									DeleteEntity(currentGear.tank)
									currentGear.tank = 0
								end
							end

							OnDuty = false
							doingProgress = false
						end)
					end
				end
			end
			if dist2 < 25 and ESX.PlayerData.job.name == Shared.Locations[i].job and not doingProgress and OnDuty or ESX.PlayerData.job2.name == Shared.Locations[i].job and not doingProgress and OnDuty then
				sleep = 0
				ESX.Game.Utils.DrawMarker(Shared.Locations[i]['verkoop']['coords'], 2, 0.2, Shared.Locations[i]['color'].r, Shared.Locations[i]['color'].g, Shared.Locations[i]['color'].b)

				if dist2 < 2.5 then
					exports['frp-interaction']:Interaction({r = tostring(Shared.Locations[i]['color'].r), g = tostring(Shared.Locations[i]['color'].g), b = tostring(Shared.Locations[i]['color'].b)}, '[E] - Facturen verkopen', Shared.Locations[i]['verkoop']['coords'], 5.0, GetCurrentResourceName().."-verkoopfactuur")
					if IsControlJustReleased(0, 38) then
						doingProgress = true
						TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, 1)
						exports['lrp-progressbar']:Progress({
							name = 'exios-nonwhitelisted/basic/verkoopfactuur',
							duration = 3500,
							label = 'Facturen Verkopen',
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
						}, function(cancelled)
							ClearPedTasksImmediately(playerPed)
							Citizen.SetTimeout(250, function()
								TriggerServerEvent('exios-nonwhitelistedjobs:server:action:verkoopfactuur', i, Shared.Locations[i].job)
							end)
							doingProgress = false
						end)
					end
				end
			end
		end

		Wait(sleep)
	end
end)