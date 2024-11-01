RegisterNetEvent('exios-nonwhitelistedjobs:client:action:startJob')
AddEventHandler('exios-nonwhitelistedjobs:client:action:startJob', function(number, job)
	if job == 'vuilnisman' then
		startVuilnisman(number)
	end
end)

startVuilnisman = function(number)
	::takeVehicle::
    local hasVehicle = false
	local pressedButton = false
	local hasMessage = false

	ESX.TriggerServerCallback('exios-nonwhitelistedjobs:server:cb:receive:done:locations', function(data)
        for i=1, #data do 
			if data[i] then
				Shared.Locations[number]['actions'][i]['ready'] = true
			end
		end

		for i=1, #Shared.Locations[number]['actions'] do
			if not Shared.Locations[number]['actions'][i]['ready'] then
				Shared.Locations[number]['actions'][i].blip = AddBlipForCoord(Shared.Locations[number]['actions'][i]['coords'])
				
				SetBlipHighDetail(Shared.Locations[number]['actions'][i].blip, true)
				SetBlipSprite (Shared.Locations[number]['actions'][i].blip, 11)
				SetBlipScale  (Shared.Locations[number]['actions'][i].blip, 1.0)
				SetBlipColour (Shared.Locations[number]['actions'][i].blip, 1)
				SetBlipAsShortRange(Shared.Locations[number]['actions'][i].blip, true)
	
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Actie")
				EndTextCommandSetBlipName(Shared.Locations[number]['actions'][i].blip)
			end
		end
    end)

    for i=1, #Shared.Locations[number]['vehicle']['coords'] do
        if ESX.Game.IsSpawnPointClear(Shared.Locations[number]['vehicle']['coords'][i]['vector'], 7.5) then
		    hasVehicle = i
			break
	    end
    end

    if not hasVehicle then
        ESX.ShowNotification('error', 'Je hebt nog geen voertuig, even geduld aub..')
        Wait(5000)
        goto takeVehicle
    end

	ESX.ShowNotification('success', 'Pak je voertuig en bekijk de map om jouw vuilniszakken op te halen!', 7500)

	local props = {['plate'] = getPlate()}

	ESX.Game.SpawnVehicle(Shared.Locations[number]['vehicle']['spawnname'], Shared.Locations[number]['vehicle']['coords'][hasVehicle]['vector'], Shared.Locations[number]['vehicle']['coords'][hasVehicle]['heading'], function(veh)
        SetVehicleNumberPlateText(veh, props.plate)
        TriggerServerEvent('exios-carkeys:server:give:car:keys:burgers', ESX.Game.GetVehicleProperties(veh), ESX.Math.Trim(props.plate))
		TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
		Shared.Locations[number]['vehicle']['activevehicle'] = veh
		-- -- exports['exios-benzine']:setFuel(veh, 100.0)
	end, true, props)

	ESX.ShowNotification('info', 'Let op! Lever je voertuig aan het eind <b>heel</b> in, anders krijg jij je borg gedeeltelijk terug!', 7500)

	Citizen.CreateThread(function()
		while OnDuty do 
			local sleep = 500
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)

			if #(coords - Shared.Locations[number]['vehicle']['removeLocation']) < 15.0 and IsPedInAnyVehicle(playerPed) and not pressedButton then 
                sleep = 0
                ESX.Game.Utils.DrawMarker(Shared.Locations[number]['vehicle']['removeLocation'], 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)
                
				if #(coords - Shared.Locations[number]['vehicle']['removeLocation']) <= 2.0 and IsPedInAnyVehicle(playerPed) then
                    exports['lrp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] - Zet voertuig weg', Shared.Locations[number]['vehicle']['removeLocation'], 2.0, GetCurrentResourceName())
                    if IsControlJustPressed(0, 38) then 
                        local veh = GetVehiclePedIsIn(playerPed)
                        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(veh))
                        if Shared.Locations[number]['vehicle']['activevehicle'] == veh then
							pressedButton = true
                            ESX.TriggerServerCallback('exios-nonwhitelistedjobs:server:create:borg', function(bool)
                                if bool then
									exports['lrp-interaction']:clearInteraction()
									pressedButton = false
                                end
                            end, plate, GetVehicleEngineHealth(veh), NetworkGetNetworkIdFromEntity(veh))
                        else 
                            ESX.ShowNotification('error', 'Dit is niet het goede voertuig!', 5000)
                        end
                    end
                end
            end

			for i=1, #Shared.Locations[number]['actions'] do
				if not Shared.Locations[number]['actions'][i].ready then
					local TruckCoords = GetWorldPositionOfEntityBone(Shared.Locations[number]['vehicle']['activevehicle'], GetEntityBoneIndexByName(Shared.Locations[number]['vehicle']['activevehicle'], "platelight"))
					local distGarbage = #(coords-Shared.Locations[number]['actions'][i].coords)
					local distcar = #(coords-TruckCoords)

					if distGarbage < 25 and not Shared.Locations[number]['actions'][i].taked then
						sleep = 0
						ESX.Game.Utils.DrawMarker(Shared.Locations[number]['actions'][i].coords, 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)

						if distGarbage <= 1.5 and not Shared.Locations[number]['actions'][i].taked  then
							exports['lrp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] - Raap vuilnis op', Shared.Locations[number]['actions'][i].coords, 2.5, GetCurrentResourceName())
							if IsControlJustPressed(0, 38) then
								Shared.Locations[number]['actions'][i].taked = true

								-- exports['dpemotes']:EmoteCommandStart('pickup')
								Wait(1250)
								DoVuilnisAni(number, i)
							end
						end	

					elseif distcar < 25 and Shared.Locations[number]['actions'][i].taked then
						sleep = 0
						ESX.Game.Utils.DrawMarker(TruckCoords, 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)

						if distcar <= 1.5 and Shared.Locations[number]['actions'][i].taked then
							exports['lrp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] - Leg vuilnis in vuilniswagen', TruckCoords, 1.5, GetCurrentResourceName())
							if IsControlJustPressed(0, 38) then
								Shared.Locations[number]['actions'][i].taked = false
								TriggerServerEvent('exios-nonwhitelistedjobs:server:action:addAction', number, Shared.Locations[number].job, i, NetworkGetNetworkIdFromEntity(Shared.Locations[number]['vehicle']['activevehicle']))
								
								SetVehicleDoorOpen(Shared.Locations[number]['vehicle']['activevehicle'], 5, false, false)

								DoVuilnisAniStop(number, i)

								Wait(1500)

								Shared.Locations[number]['actions'][i].ready = true
								RemoveBlip(Shared.Locations[number]['actions'][i].blip)
								Shared.Locations[number]['actions'][i].blip = nil

								SetVehicleDoorShut(Shared.Locations[number]['vehicle']['activevehicle'], 5, false)

								local count = 0
								local max = #Shared.Locations[number]['actions']
								for i=1, #Shared.Locations[number]['actions'] do
									if Shared.Locations[number]['actions'][i].ready then
										count = count + 1
									end
								end

								if count >= max and not hasMessage then
									hasMessage = true
									ESX.ShowNotification('success', 'Je hebt alle locaties gehad, deze kan je nu inleveren.')
								end

								Wait(250)
							end
						end
					end
				end
			end

			Wait(sleep)
		end
	end)
end

function DoVuilnisAni(number, i)
	local playerPed = PlayerPedId()

	RequestAnimDict('missfbi4prepp1')
	while not HasAnimDictLoaded('missfbi4prepp1') do Wait(10) end

	TaskPlayAnim(playerPed, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)

	garbageObject = CreateObject(`prop_cs_rub_binbag_01`, 0, 0, 0, true, true, true)
	AttachEntityToEntity(garbageObject, playerPed, GetPedBoneIndex(playerPed, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)
	StopAnimTask(playerPed, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)

	ESX.ShowNotification('success', 'Leg het vuilnis in je vuilniswagen', 7500)
end

function DoVuilnisAniStop(number, i)
	local playerPed = PlayerPedId()

	RequestAnimDict("anim@heists@narcotics@trash") 
	while not HasAnimDictLoaded("anim@heists@narcotics@trash") do Wait(10) end

	FreezeEntityPosition(playerPed, true)

	TaskPlayAnim(playerPed, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)

	SetEntityHeading(playerPed, GetEntityHeading(Shared.Locations[number]['vehicle']['activevehicle']))

	SetTimeout(1250, function()
		DetachEntity(garbageObject, 1, false)
		DeleteObject(garbageObject)
		FreezeEntityPosition(playerPed, false)
		garbageObject = nil
	end)
end