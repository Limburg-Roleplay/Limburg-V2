Citizen.CreateThread(function()
    while true do
        local sleep = 100
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

		if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
			if IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) then
				SetVehicleEngineOn(veh, true, true, false)
				TaskLeaveVehicle(ped, veh, 0)
			end
		end

		Citizen.Wait(sleep)
	end
end)

RegisterCommand('engine', function()
	local veh = GetVehiclePedIsIn(ped, false)

	if veh then
		local engine = GetIsVehicleEngineRunning(veh)
		if engine then
			SetVehicleEngineOn(veh, false, false, true)
		else
			SetVehicleEngineOn(veh, true, false, false)
		end
	end
end, false)