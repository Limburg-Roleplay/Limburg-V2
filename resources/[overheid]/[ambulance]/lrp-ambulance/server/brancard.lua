local busy = {}
local busypickup = {}
local IsAttachedstate = {}

RegisterNetEvent('lrp-ambulance:server:set:vehicle:busy:brancard', function(entity, IsAttached, state, state2)
    busy[entity] = state
    if not IsAttachedstate[entity] then
        IsAttachedstate[entity][IsAttached] = true
    end
end)

RegisterNetEvent('lrp-ambulance:server:no:busy:brancard:pickup', function(entity)
    busypickup[entity] = false
end)

RegisterNetEvent('lrp-ambulance:server:no:busy:brancard', function(entity)
    busy[entity] = false
end)

RegisterNetEvent('lrp-ambulance:server:remove:brancard', function(entity)
    DeleteEntity(NetworkGetEntityFromNetworkId(entity))
end)

ESX.RegisterServerCallback('lrp-ambulance:server:is:brancard:busy:pickup', function(source, cb, entity)
    if not busypickup[entity]  then
        busypickup[entity] = true
        cb(false)
    else
        cb(true)
    end
end)

ESX.RegisterServerCallback('lrp-ambulance:server:is:brancard:busy', function(source, cb, entity)
    if not busy[entity] then
        busy[entity] = true
        cb(false)
    else
        cb(true)
    end
end)