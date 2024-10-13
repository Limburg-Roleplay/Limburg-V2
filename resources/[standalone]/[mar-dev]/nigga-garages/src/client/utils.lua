-- // [UTIL FUNCTIONS] \\ --

today.Functions.Utils.LoadModel = function(model)
	if not IsModelValid(model) then return end

	RequestModel(joaat(model))
	while not HasModelLoaded(joaat(model)) do
		Wait(5)
	end
end

today.Functions.Utils.GetVehicleType = function(model)
    if model == `submersible` or model == `submersible2` then
		return 'submarine'
	end

	local class = GetVehicleClassFromName(model)
	local types = {
		[8] = "bike",
		[11] = "trailer",
		[13] = "bike",
		[14] = "boat",
		[15] = "heli",
		[16] = "plane",
		[21] = "train",
	}

	return types[class] or "automobile"
end

today.Functions.Utils.DrawMarker = function(coords, r, g, b)
    local r = r ~= nil and r or 2
    local g = g ~= nil and g or 156
    local b = b ~= nil and b or 227
    
    DrawMarker(36, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, r, g, b, 70, true, false, false, true, false, false, false)
end

today.Functions.Utils.DrawText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords['x'], coords['y'], coords['z'])
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end