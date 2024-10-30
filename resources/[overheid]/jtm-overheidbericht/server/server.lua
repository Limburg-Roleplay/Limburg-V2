RegisterCommand('overheid', function(source, raw, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getJob().label == 'Politie' or xPlayer.getJob().label == 'Kmar' then
        table.remove(raw, 2)
        TriggerClientEvent('chatMessage', -1, 'Overheids Bericht: ' .. xPlayer.getName() .. ' [' .. source .. "]", 'politie', table.concat(raw, ' '))
        else 
        TriggerClientEvent("lrp-notifications:client:notify", source, "error", "Je bent Geen overheids dienst", 4000)
    end
end, false)