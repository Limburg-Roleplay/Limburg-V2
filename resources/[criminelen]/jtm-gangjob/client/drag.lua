local animName, animDict, cuffed = "", "", false
local dragStatus = {['isDragged'] = false}

RegisterNetEvent('jtm-development:client:player:handler:vehicle')
AddEventHandler('jtm-development:client:player:handler:vehicle', function()
    local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

    if not IsPedInAnyVehicle(playerPed, false) then
        if IsAnyVehicleNearPoint(coords, 5.0) then
            local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

            if DoesEntityExist(vehicle) then
                local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                for i=maxSeats - 1, 0, -1 do
                    if IsVehicleSeatFree(vehicle, i) then
                        freeSeat = i
                        break
                    end
                end

                if freeSeat then
					TaskEnterVehicle(playerPed, vehicle, 1.0, freeSeat, 1.0)
                end
            end
        end
    else
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        TaskLeaveVehicle(playerPed, vehicle, 256)
    end
end)

RegisterNetEvent('jtm-development:client:set:player:vehicle')
AddEventHandler('jtm-development:client:set:player:vehicle', function(data)
	if not targetVehPed then
		local entity = data.entity
		local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
		local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

		if distance < 2.0 then 
			TriggerServerEvent('jtm-development:server:set:player:vehicle', GetPlayerServerId(entityPlayer))
		else
			exports['vesx_ia']:Notify('error', 'Deze persoon is niet meer in de buurt!', 5000)
		end
	else
		local entity = targetVehPed
		local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
		local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

		if distance < 2.0 then 
			TriggerServerEvent('jtm-development:server:set:player:vehicle', GetPlayerServerId(entityPlayer))
		else
			ESX.ShowNotification('Deze persoon is niet meer in de buurt!', 'error')
		end
	end
end)

RegisterNetEvent('jtm-development:client:startDragging')
AddEventHandler('jtm-development:client:startDragging', function(copId)
	dragStatus['isDragged'] = not dragStatus['isDragged']
	dragStatus['copId'] = tonumber(copId)
end)

RegisterNetEvent('jtm-development:client:dragging')
AddEventHandler('jtm-development:client:dragging', function(data)
    local entity = data.entity
    local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

    dragStatus['isDragging'] = true
    dragStatus['targetId'] = GetPlayerServerId(entityPlayer)

    SendNUIMessage({
        type = 'openPlaceholder',
        text = '<b>[X]</b> Om de persoon los te laten'
    })

    TriggerServerEvent('jtm-development:server:onDrag', GetPlayerServerId(entityPlayer))

    Citizen.CreateThread(function()
        while dragStatus['isDragging'] do 
            local sleep = 0

            DisableControlAction(2, 21, true)

            local isWalking = IsPedWalking(PlayerPedId())

            -- Check if Config.Pushing is defined and has the necessary keys
            if Config.Pushing and Config.Pushing['pushingAnimDict'] and Config.Pushing['pushingAnim'] then
                local isPlayingAnim = IsEntityPlayingAnim(PlayerPedId(), Config.Pushing['pushingAnimDict'], Config.Pushing['pushingAnim'], 51)

                if IsControlJustReleased(0, 120) then
                    TriggerServerEvent('jtm-development:server:syncs:drag', dragStatus['targetId'])
                    SendNUIMessage({
                        type = 'closePlaceholder'
                    })
                    StopAnimTask(PlayerPedId(), Config.Pushing['pushingAnimDict'], Config.Pushing['pushingAnim'], -4.0)
                    dragStatus['isDragging'] = false
                    return
                end

                if isWalking and not isPlayingAnim then
                    ESX.Game.PlayAnim(Config.Pushing['pushingAnimDict'], Config.Pushing['pushingAnim'], 2.0, -1, 51)
                elseif not isWalking and isPlayingAnim then
                    StopAnimTask(PlayerPedId(), Config.Pushing['pushingAnimDict'], Config.Pushing['pushingAnim'], -4.0)
                end
            else
                print("Config.Pushing or necessary keys are not defined")
            end

            Citizen.Wait(sleep)
        end
    end)
end)


Citizen.CreateThread(function()
	while true do 
		local sleep = 750
		if dragStatus['isDragged'] then
			sleep = 0
			SetPedMoveRateOverride(PlayerPedId(), 0.8)
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus['copId'])) 
	
			if not IsPedSittingInAnyVehicle(targetPed) then 
				AttachEntityToEntity(PlayerPedId(), targetPed, 11816, 0.0, 0.64, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else 
				setIsDragged(false)
			end
	
			if IsPedDeadOrDying(targetPed, true) then 
				setIsDragged(false)
			end
	
			local isPlayingAnim = IsEntityPlayingAnim(PlayerPedId(), Config.Walking['walkingAnimDict'], Config.Walking['walkingAnim'], 3)
			local isCopWalking = IsPedWalking(targetPed)
	
			if isCopWalking and not isPlayingAnim then
				ESX.Game.PlayAnim(Config.Walking['walkingAnimDict'], Config.Walking['walkingAnim'], 2.0, -1, 3)
			elseif not isCopWalking and isPlayingAnim then 
				StopAnimTask(PlayerPedId(), Config.Walking['walkingAnimDict'], Config.Walking['walkingAnim'], -4.0)
			end
		else 
			StopAnimTask(PlayerPedId(), Config.Walking['walkingAnimDict'], Config.Walking['walkingAnim'], -4.0)
			DetachEntity(PlayerPedId(), true, false)
		end

		Wait(sleep)
	end
end)

RegisterNetEvent('jtm-development:client:syncz:drag')
AddEventHandler('jtm-development:client:syncz:drag', function()
	setIsDragged(true)
	dragStatus['isDragged'] = true
end)

RegisterNetEvent('jtm-development:client:syncs:drag')
AddEventHandler('jtm-development:client:syncs:drag', function()
	setIsDragged(false)
	dragStatus['isDragged'] = false
end)

setIsDragged = function(value)
	if not value and dragStatus['isDragged'] then 
		releasePed()
	end 

	dragStatus['isDragged'] = value
end

releasePed = function()
	dragStatus['isDragged'] = false 
	DetachEntity(PlayerPedId(), true, false)
	StopAnimTask(PlayerPedId(), walkingAnimDict, walkingAnim)
end