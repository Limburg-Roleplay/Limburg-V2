ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('esx_outlawalert:robberyInProgress')
AddEventHandler('esx_outlawalert:robberyInProgress', function(targetCoords, streetName, playerGender, type)
    mytype = 'police'
    data = {["code"] = 'Prio 1', ["name"] = firstToUpper(type) .. ' Overval.', ["loc"] = streetName}
    length = 5500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:robberyInProgressCL', -1, targetCoords)
end, false)
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

RegisterServerEvent('esx_outlawalert:carJackInProgress')
AddEventHandler('esx_outlawalert:carJackInProgress', function(targetCoords, streetName, vehicleLabel, playerGender)
    mytype = 'police'
    data = {["code"] = 'prio', ["name"] = 'Diefstal van een '   ..vehicleLabel..  '.', ["loc"] = streetName}
    length = 3500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:combatInProgress', -1, targetCoords)
    TriggerClientEvent('esx_outlawalert:carJackInProgress', -1, targetCoords)
end, false)

RegisterServerEvent('esx_outlawalert:combatInProgress')
AddEventHandler('esx_outlawalert:combatInProgress', function(targetCoords, streetName, playerGender)
	mytype = 'police'
    data = {["code"] = 'prio', ["name"] = 'Gevecht gaande', ["loc"] = streetName}
    length = 2500
    TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
    TriggerClientEvent('esx_outlawalert:combatInProgress', -1, targetCoords)
end, false)
RegisterServerEvent('esx_outlawalert:gunshotInProgressSV')
AddEventHandler('esx_outlawalert:gunshotInProgressSV', function(targetCoords, streetName, playerGender)
    local _source = source
    local routingBucket = GetPlayerRoutingBucket(_source)
    
    -- if routingBucket == 0 then
        local mytype = 'police'
        local data = {["code"] = 'Status 11', ["name"] = 'Schoten gelost', ["loc"] = streetName}
        local length = 3800

        TriggerClientEvent('esx_outlawalert:outlawNotify', -1, mytype, data, length)
        TriggerClientEvent('esx_outlawalert:gunshotInProgress', -1, targetCoords)
    -- end
end, false)


RegisterServerEvent('esx_outlawalert:Gewondpersoon')
AddEventHandler('esx_outlawalert:Gewondpersoon', function(targetCoords, streetName, playerGender)
	mytype = 'police'
    data = {["code"] = 'Status 2', ["name"] = 'Bewusteloos Persoon', ["loc"] = streetName}
    length = 3800
   
    TriggerClientEvent('esx_outlawalert:outlawNotify2', -1, mytype, data, length) 
    TriggerClientEvent('esx_outlawalert:Gewondpersoon', -1, targetCoords)
end)

ESX.RegisterServerCallback('esx_outlawalert:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)