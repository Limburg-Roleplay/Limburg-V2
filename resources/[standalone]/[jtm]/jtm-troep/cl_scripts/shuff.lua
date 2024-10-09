RegisterCommand('shuff', function(source, args, RawCommand)
	local currentvehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local seat = ""
	if GetPedInVehicleSeat(currentvehicle, -1) == PlayerPedId() then
		seat = 0
	end
	if GetPedInVehicleSeat(currentvehicle, 0) == PlayerPedId() then
		seat = -1
	end
	SetPedConfigFlag(PlayerPedId(), 184, false)
	SetPedIntoVehicle(PlayerPedId(), currentvehicle, seat)
	SetPedConfigFlag(PlayerPedId(), 184, true)
end)
