RegisterCommand('me', function(source, args)
    local text = table.concat(args, " ")
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('lrp-me:me:shareDisplay', -1, text, source, xPlayer.getName())
end)