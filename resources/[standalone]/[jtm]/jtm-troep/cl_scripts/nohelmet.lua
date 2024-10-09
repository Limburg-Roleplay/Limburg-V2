Citizen.CreateThread(function()
	while true do
		local sleep = 750
		if IsPedInAnyVehicle(playerped, false) and allowshuffle == false then
            sleep = 250
			SetPedConfigFlag(playerped, 184, true)
			if GetIsTaskActive(playerped, 165) then
				seat = 0
				if GetPedInVehicleSeat(currentvehicle, -1) == playerped then
					seat =- 1
				end
				SetPedIntoVehicle(playerped, currentvehicle, seat)
			end
		elseif IsPedInAnyVehicle(playerped, false) and allowshuffle == true then
			SetPedConfigFlag(playerped, 184, false)
		end

        Citizen.Wait(sleep)
	end
end)

