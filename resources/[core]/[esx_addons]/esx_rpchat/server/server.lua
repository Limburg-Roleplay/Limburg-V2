-- Definieer een functie om de chatberichten te verwerken
RegisterServerEvent('esx_rpchat:sendProximityMessage')
AddEventHandler('esx_rpchat:sendProximityMessage', function(playerId, prefix, message, color)
    -- Stuur het bericht naar alle spelers in de buurt
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        TriggerClientEvent('chat:addMessage', playerId, {args = {prefix, message}, color = color})
    end
end)

-- Functie om alle spelers op te halen
function GetPlayers()
    local players = {}
    for _, player in ipairs(GetPlayersList()) do
        table.insert(players, tonumber(player))
    end
    return players
end

-- Definieer een commando om spelers in de buurt te waarschuwen
RegisterCommand('alert', function(source, args, rawCommand)
    local playerId = source
    local message = table.concat(args, ' ')
    local playerName = GetRealPlayerName(playerId)

    TriggerClientEvent('esx_rpchat:sendProximityMessage', -1, playerId, playerName, message, {255, 0, 0})
end, false)
