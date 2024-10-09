-- Trigger an event to create a blip on all clients when the server starts
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Trigger client event to create the blip
        TriggerClientEvent('createBlip', -1)
    end
end)
