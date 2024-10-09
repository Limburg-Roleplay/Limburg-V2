local anchored = false
local boat = nil
Citizen.CreateThread(function()
	while true do

		Wait(1000)
		local ped = GetPlayerPed(-1)
		if IsPedInAnyBoat(ped) then
			if not anchored then
				boat  = GetVehiclePedIsIn(ped, true)
				anchored = false
			else
				TaskLeaveVehicle(ped,boat)
				ESX.ShowNotification('error', 'Je Anker ligt nog in het water!', 5000)
				Wait(2000)
				SetBoatAnchor(boat, true)
			end
		end
		if IsControlJustPressed(1, 82) and not IsPedInAnyVehicle(ped) and boat ~= nil then
		local distance = GetDistanceBetweenCoords(GetEntityCoords(boat), GetEntityCoords(ped), false)
			if IsVehicleEngineOn(boat) and distance <= 3 then
				ESX.ShowNotification('error', 'Zet je motor uit als als je een Anker wil uitgooien.', 5000)
			elseif distance <= 3 then
				if not anchored then
					SetBoatAnchor(boat, true)
					TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					Citizen.Wait(10000)
					ESX.ShowNotification('info', 'Anker in het water gegooid.', 5000)
					ClearPedTasks(ped)
				else
					TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
					Citizen.Wait(10000)
					SetBoatAnchor(boat, false)
					ESX.ShowNotification('info', 'Anker uit het water gehaald.', 5000)
					ClearPedTasks(ped)
				end
				anchored = not anchored
			else
				ESX.ShowNotification('error', 'Je bent niet in de buurt van je Boot.', 5000)
			end
		end
	end
end)
