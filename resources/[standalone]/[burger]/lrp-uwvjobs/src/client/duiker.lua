local currentGear = {
    mask = 0,
    tank = 0,
    oxygen = 0,
    enabled = false
}

RegisterNetEvent('exios-nonwhitelistedjobs:client:action:startJob')
AddEventHandler('exios-nonwhitelistedjobs:client:action:startJob', function(number, job)
	if job == 'duiker' then
		startDuiker(number)
	end
end)

startDuiker = function(number)
	::takeVehicle::
    local hasVehicle = false
    local taken = true
    local pressedButton = false
    local hasMessage = false
    local anker = false

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

	ESX.ShowNotification('success', 'Pak je voertuig en bekijk de map om de wrak te repareren!', 7500)

	local props = {['plate'] = getPlate()}

	ESX.Game.SpawnVehicle(Shared.Locations[number]['vehicle']['spawnname'], Shared.Locations[number]['vehicle']['coords'][hasVehicle]['vector'], Shared.Locations[number]['vehicle']['coords'][hasVehicle]['heading'], function(veh)
        SetVehicleNumberPlateText(veh, props.plate)
        TriggerServerEvent('exios-carkeys:server:give:car:keys:burgers', ESX.Game.GetVehicleProperties(veh), ESX.Math.Trim(props.plate))
		TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
		Shared.Locations[number]['vehicle']['activevehicle'] = veh
		-- exports['exios-benzine']:setFuel(veh, 100.0)
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
            local sleep = 750 
            local coords = GetEntityCoords(PlayerPedId())

            if #(coords - Shared.Locations[number]['vehicle']['removeLocation']) < 15.0 and IsPedInAnyVehicle(PlayerPedId()) and not pressedButton then 
                sleep = 0
                ESX.Game.Utils.DrawMarker(Shared.Locations[number]['vehicle']['removeLocation'], 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)
                if #(coords - Shared.Locations[number]['vehicle']['removeLocation']) <= 2.0 and IsPedInAnyVehicle(PlayerPedId()) then 
                    exports['lrp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] - Zet voertuig weg', Shared.Locations[number]['vehicle']['removeLocation'], 2.0, GetCurrentResourceName())
                    if IsControlJustPressed(0, 38) then 
                        local veh = GetVehiclePedIsIn(PlayerPedId())
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
					local TruckCoords = GetEntityCoords(Shared.Locations[number]['vehicle']['activevehicle'])
					local dist = #(coords-Shared.Locations[number]['actions'][i].coords)
					local distcar = #(coords-TruckCoords)
                    if dist < 7.5 and taken and not IsPedInAnyVehicle(PlayerPedId()) then 
                        sleep = 0
                        ESX.Game.Utils.DrawMarker(Shared.Locations[number]['actions'][i].coords, 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)
                        if dist < 1.5 then 
                            exports['lrp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] - Repareer wrak', Shared.Locations[number]['actions'][i].coords, 1.5, GetCurrentResourceName())
                            if IsControlJustPressed(0, 38) and not Shared.Locations[number]['actions'][i].ready then 
                                Shared.Locations[number]['actions'][i].ready = true
                                exports['lrp-progressbar']:Progress({
                                    name = 'exios-nonwhitelistedjobs/duiker/clean',
                                    duration = 10000,
                                    label = 'Repareer Wrak',
                                    useWhileDead = false,
                                    canCancel = true,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
									animation = {
										animDict = "amb@world_human_welding@male@base",
										anim = "base",
                                        flags = 47,
                                    },

                                }, function(cancelled)
                                    if not cancelled then
                                        exports['dpemotes']:EmoteCancel(true)
                                        RemoveBlip(Shared.Locations[number]['actions'][i].blip)
                                        Shared.Locations[number]['actions'][i].blip = nil
                                        TriggerServerEvent('exios-nonwhitelistedjobs:server:action:addAction', number, Shared.Locations[number].job, i)
                                        ClearPedTasks(PlayerPedId())
                                        taken = true
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
                                        Shared.Locations[number]['actions'][i].ready = false
                                        ClearPedTasks(PlayerPedId())
                                    end
                                end)
                            end
                        end
                    end

                    if distcar < 7.5 and not taken and not IsPedInAnyVehicle(PlayerPedId(), false) then 
                        sleep = 0
                        ESX.Game.Utils.DrawMarker(vector3(TruckCoords.x, TruckCoords.y, TruckCoords.z + 1), 2, 0.2, Shared.Locations[number]['color'].r, Shared.Locations[number]['color'].g, Shared.Locations[number]['color'].b)
				        if distcar <= 1.5 then
                            if IsControlJustReleased(0, 47) then
                                Wait(1)
                                anker = not anker
                                FreezeEntityPosition(Shared.Locations[number]['vehicle']['activevehicle'], anker)
                                if anker then
                                    ESX.ShowNotification('info', 'Je hebt het anker erop gezet', 3000)
                                else
                                    ESX.ShowNotification('info', 'Je hebt het anker eraf gehaald', 3000)
                                end
                            end

                            if not taken then
                                exports['lrp-interaction']:Interaction({r = tostring(Shared.Locations[number]['color'].r), g = tostring(Shared.Locations[number]['color'].g), b = tostring(Shared.Locations[number]['color'].b)}, '[E] Pak spullen uit voertuig | [G] Gooi Anker in-/uit', vector3(TruckCoords.x, TruckCoords.y, TruckCoords.z + 1), 1.5, GetCurrentResourceName())
                                if IsControlJustReleased(0, 38) then
                                    Wait(1)
                                    taken = true
                                    exports['dpemotes']:EmoteCommandStart('mechanic')
                                    exports['lrp-progressbar']:Progress({
                                        name = 'exios-nonwhitelistedjobs/duiker/deliver',
                                        duration = 2500,
                                        label = 'Spullen pakken',
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
                                            exports['dpemotes']:EmoteCancel(true)
                                            ESX.ShowNotification('success', 'Repareer het wrak', 7500)
                                        else
                                            exports['dpemotes']:EmoteCancel(true)
                                            taken = true
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