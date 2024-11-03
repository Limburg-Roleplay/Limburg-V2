RegisterNetEvent('exios-nonwhitelistedjobs:client:action:startJob')
AddEventHandler('exios-nonwhitelistedjobs:client:action:startJob', function(number, job)
	if job == 'postnl' then
		startPostNL(number)
	end
end)

startPostNL = function(number)
    ::takeVehicle::
    local taken = true
    local hasVehicle = false
    local playerPed = PlayerPedId()
    local pressedButton = false
    local hasMessage = false

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

	ESX.ShowNotification('success', 'Pak je voertuig en bekijk de map om de pakketten te bezorgen!', 7500)

	local props = {['plate'] = getPlate()}

	ESX.Game.SpawnVehicle(Shared.Locations[number]['vehicle']['spawnname'], Shared.Locations[number]['vehicle']['coords'][hasVehicle]['vector'], Shared.Locations[number]['vehicle']['coords'][hasVehicle]['heading'], function(veh)
        SetVehicleNumberPlateText(veh, props.plate)
        TriggerServerEvent('exios-carkeys:server:give:car:keys:burgers', ESX.Game.GetVehicleProperties(veh), ESX.Math.Trim(props.plate))
		TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
		Shared.Locations[number]['vehicle']['activevehicle'] = veh
		-- -- exports['exios-benzine']:setFuel(veh, 100.0)
	end, true, props)

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
    
    ESX.ShowNotification('info', 'Let op! Lever je voertuig aan het eind <b>heel</b> in, anders krijg jij je borg gedeeltelijk terug!', 7500)

    Citizen.CreateThread(function()
        while OnDuty do 
            local sleep = 500 
            local coords = GetEntityCoords(playerPed)

            if #(coords - Shared.Locations[number]['vehicle']['removeLocation']) < 15.0 and IsPedInAnyVehicle(playerPed) and not pressedButton then 
                sleep = 0
                ESX.Game.Utils.DrawMarker(Shared.Locations[number]['vehicle']['removeLocation'], 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)
                if #(coords - Shared.Locations[number]['vehicle']['removeLocation']) <= 10.0 and IsPedInAnyVehicle(playerPed) then 
                    exports['frp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] - Zet voertuig weg', Shared.Locations[number]['vehicle']['removeLocation'], 10.0, GetCurrentResourceName())
                    if IsControlJustPressed(0, 38) then 
                        local veh = GetVehiclePedIsIn(playerPed)
                        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(veh))
                        if Shared.Locations[number]['vehicle']['activevehicle'] == veh then
                            pressedButton = true
                            ESX.TriggerServerCallback('exios-nonwhitelistedjobs:server:create:borg', function(bool)
                                if bool then
                                    exports['frp-interaction']:clearInteraction()
                                    pressedButton = false
                                end
                            end, plate, GetVehicleEngineHealth(veh), NetworkGetNetworkIdFromEntity(veh))
                        else 
                            ESX.ShowNotification('error', 'Dit is niet het goede voertuig!', 5000)
                        end
                    end
                end
            end

            if taken then
                DisableControlAction(0, 22, true)
            end

            for i=1, #Shared.Locations[number]['actions'] do
				if not Shared.Locations[number]['actions'][i].ready and Shared.Locations[number]['vehicle']['activevehicle'] then
                    if not IsPedInAnyVehicle(playerPed) then
                        local TruckCoords = GetWorldPositionOfEntityBone(Shared.Locations[number]['vehicle']['activevehicle'], GetEntityBoneIndexByName(Shared.Locations[number]['vehicle']['activevehicle'], "handle_pside_r"))

                        local distDeliver = #(coords - Shared.Locations[number]['actions'][i].coords)
                        local distcar = #(coords - TruckCoords)

                        if distDeliver < 25 and taken then 
                            sleep = 0
                            ESX.Game.Utils.DrawMarker(Shared.Locations[number]['actions'][i].coords, 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)
                            if distDeliver <= 1.5 and taken then

                                exports['frp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] - Lever pakket aan huis', Shared.Locations[number]['actions'][i].coords, 1.5, GetCurrentResourceName())
                                if IsControlJustPressed(0, 38) then
                                    taken = true
                                    exports['lrp-progressbar']:Progress({
                                        name = 'exios-nonwhitelistedjobs/postnl/deliver',
                                        duration = 3500,
                                        label = 'Pakketje afgeven',
                                        useWhileDead = false,
                                        canCancel = true,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        },
                                        animation = {
                                            animDict = 'timetable@jimmy@doorknock@',
                                            anim = 'knockdoor_idle',
                                            flags = 0,
                                        },
                                    }, function(cancelled)
                                        if not cancelled then
                                            exports['dpemotes']:EmoteCancel(true)
                                            ESX.ShowNotification('success', 'Pakket afgeleverd', 7500)
                                            Shared.Locations[number]['actions'][i].ready = true
                                            RemoveBlip(Shared.Locations[number]['actions'][i].blip)
                                            Shared.Locations[number]['actions'][i].blip = nil
                                            TriggerServerEvent('exios-nonwhitelistedjobs:server:action:addAction', number, Shared.Locations[number].job, i)
                                            ClearPedTasks(playerPed)
                                            TaskPlayAnim(playerPed, 'timetable@jimmy@doorknock@', 'exit', 3.0, 3.0, -1, 1, 0, false, false, false)

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
                                        else
                                            taken = true
                                            ClearPedTasks(playerPed)
                                            TaskPlayAnim(playerPed, 'timetable@jimmy@doorknock@', 'exit', 3.0, 3.0, -1, 1, 0, false, false, false)
                                        end
                                    end)
                                end
                            end
                        end

                        if distcar < 25 and not taken then 
                            sleep = 0
                            ESX.Game.Utils.DrawMarker(vector3(TruckCoords.x, TruckCoords.y, TruckCoords.z), 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)
                            if distcar <= 1.5 and not taken and distDeliver < 120 then
                                exports['frp-interaction']:Interaction({r = '252', g = '144', b = '3'}, '[E] - Pak pakket uit voertuig', TruckCoords, 1.5, GetCurrentResourceName())
                                if IsControlJustReleased(0, 38) then

                                    Wait(1)

                                    SetVehicleDoorOpen(Shared.Locations[number]['vehicle']['activevehicle'], 3, false, false)
                                    SetVehicleDoorOpen(Shared.Locations[number]['vehicle']['activevehicle'], 2, false, false)

                                    Wait(1000)

                                    exports['lrp-progressbar']:Progress({
                                        name = 'exios-nonwhitelistedjobs/postnl/deliver',
                                        duration = 3500,
                                        label = 'Pakketje pakken',
                                        useWhileDead = false,
                                        canCancel = true,
                                        controlDisables = {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        },
                                        animation = {
                                            animDict = 'mini@repair',
                                            anim = 'fixing_a_ped',
                                            flags = 0,
                                        },
                                    }, function(cancelled)

                                        if not cancelled then
                                            ClearPedTasks(playerPed)
                                            ESX.ShowNotification('success', 'Lever het pakketje af', 7500)

                                            local randomEmote = Shared.Locations[number]['animations'][math.random(1, #Shared.Locations[number]['animations'])]
                                            exports['dpemotes']:EmoteCommandStart(randomEmote)

                                            taken = true

                                            Wait(1000)

                                            SetVehicleDoorShut(Shared.Locations[number]['vehicle']['activevehicle'], 3, false)
                                            SetVehicleDoorShut(Shared.Locations[number]['vehicle']['activevehicle'], 2, false)
                                        else
                                            taken = true
                                            ClearPedTasks(playerPed)

                                            SetVehicleDoorShut(Shared.Locations[number]['vehicle']['activevehicle'], 3, false)
                                            SetVehicleDoorShut(Shared.Locations[number]['vehicle']['activevehicle'], 2, false)
                                        end
                                    end)
                                end
                            end
                        end
                    end
				end
            end

            Citizen.Wait(sleep)
        end
    end)
end