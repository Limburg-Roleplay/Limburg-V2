-- // [VARIABLES] \\ --

local cooldown = {}
local vehicles = {}

-- // [EVENTS] \\ --

RegisterNetEvent('frp-carkeys:server:add:carKey')
AddEventHandler('frp-carkeys:server:add:carKey', function(plate, props)
    exports[''..Shared.Carkeys..'']:addCarKey(source, plate, props)
end)

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('frp-carkeys:server:can:unlock:vehicle', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local trimmedPlate = ESX.Math.Trim(plate)

    local response = MySQL.prepare.await('SELECT `owner`, `vehicle` FROM `owned_vehicles` WHERE `plate` = ?', { trimmedPlate })

    if not vehicles[source] then 
        vehicles[source] = {} 
    end

    if response then 
        if response.owner == xPlayer.identifier then
            if not vehicles[source][trimmedPlate] then 
                vehicles[source][trimmedPlate] = {
                    ['vehicleProps'] = response.vehicle,
                    ['owner'] = response.owner
                }
            end

            cb(true)
        else 
            cb(false, 'owned')
        end
    else 
        if vehicles[source] and vehicles[source][trimmedPlate] then 
            cb(true)
        else
            cb(false, 'owned')
        end
    end
end)



-- // [EXPORTS] \\ --

exports('addCarKey', function(src, plate, props)
    if not vehicles[src] then
        vehicles[src] = {}
    end

    vehicles[src][ESX.Math.Trim(plate)] = {
        ['vehicleProps'] = props,
        ['owner'] = ESX.GetPlayerFromId(source).identifier,
        ['trunkLocked'] = false
    }
end)

-- // [COMMANDS] \\ --

RegisterCommand('geefsleutels', function(source, args, user)
    TriggerClientEvent('esx_givecarkeys:keys', source)
    end)


-- // [/GEEFSLEUTELS] \\ --

    ESX.RegisterServerCallback('esx_givecarkeys:requestPlayerCars', function(source, cb, plate)

        local xPlayer = ESX.GetPlayerFromId(source)
    
        MySQL.Async.fetchAll(
            'SELECT * FROM owned_vehicles WHERE owner = @identifier',
            {
                ['@identifier'] = xPlayer.identifier
            },
            function(result)
    
                local found = false
    
                for i=1, #result, 1 do
    
                    local vehicleProps = json.decode(result[i].vehicle)
    
                    if trim(vehicleProps.plate) == trim(plate) then
                        found = true
                        break
                    end
    
                end
    
                if found then
                    cb(true)
                else
                    cb(false)
                end
    
            end
        )
    end)
    RegisterServerEvent('esx_givecarkeys:frommenu')
    AddEventHandler('esx_givecarkeys:frommenu', function ()
        TriggerClientEvent('esx_givecarkeys:keys', source)
    end)
    
    
    RegisterServerEvent('esx_givecarkeys:setVehicleOwnedPlayerId')
    AddEventHandler('esx_givecarkeys:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
        local xPlayer = ESX.GetPlayerFromId(playerId)
    
        MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate',
        {
            ['@owner']   = xPlayer.identifier,
            ['@plate']   = vehicleProps.plate
        },
    
        function (rowsChanged)
            TriggerClientEvent("frp-notifications:client:notify", xPlayer.playerId, 'success', 'U heeft een nieuwe auto met kenteken ' ..vehicleProps.plate..'')
        end)
    end)
    
    function trim(s)
        if s ~= nil then
            return s:match("^%s*(.-)%s*$")
        else
            return nil
        end
    end