RegisterServerEvent('vesx_audio:server:play')
AddEventHandler('vesx_audio:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('vesx_audio:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('vesx_audio:server:play:source')
AddEventHandler('vesx_audio:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('vesx_audio:client:play', source, soundFile, soundVolume)
end)

ESX.RegisterServerCallback("vesx_audio:server:play:distance", function(source, cb, maxDistance, soundFile, soundVolume) 
    TriggerClientEvent('vesx_audio:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)

-- RegisterServerEvent('vesx_audio:server:play:distance') -- Depraced due to security
-- AddEventHandler('vesx_audio:server:play:distance', function(maxDistance, soundFile, soundVolume)
--     TriggerClientEvent('vesx_audio:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
-- end)