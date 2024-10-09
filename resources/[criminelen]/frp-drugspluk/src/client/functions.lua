DRM.Functions.SpawnObjects = function(objType, coords)
    while #DRM.Data[objType] < Shared.Settings[objType]['Max Spawn Limit'] do
        Wait(0)
        local drugCoords = DRM.Functions.GenerateCoords(coords, objType)

        ESX.Game.SpawnLocalObject(Shared.Settings[objType]['ObjectHash'], drugCoords, function(obj)
            PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

            DRM.Data[objType][#DRM.Data[objType]+1] = obj
        end)
    end
end

DRM.Functions.ValidateCoord = function(objType, plantCoord, coords)
	if #DRM.Data[objType] > 0 then
		local validate = true

		for k, v in pairs(DRM.Data[objType]) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end

		if #(plantCoord - coords) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

DRM.Functions.GenerateCoords = function(coords, objType)
    while true do 
        Wait(1) 

        local drugsCoordX, drugsCoordY

        math.randomseed(GetGameTimer())
        local modX = math.random(-20, 20)

        Wait(100)

        math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

        drugsCoordX = coords.x + modX
		drugsCoordY = coords.y + modY

        local coordZ = DRM.Functions.GetZCoordinate(drugsCoordX, drugsCoordY)
		local coord = vector3(drugsCoordX, drugsCoordY, coordZ)

        if DRM.Functions.ValidateCoord(objType, coord, coords) then return coord end
    end
end

DRM.Functions.GetZCoordinate = function(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then return z end
	end
	return 53.85
end