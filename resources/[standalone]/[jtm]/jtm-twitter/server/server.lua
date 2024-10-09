local twtCooldown = {} -- Table to keep track of player cooldowns

RegisterCommand('twt', function(source, raw, args)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer ~= nil and xPlayer.getInventoryItem('phone').count > 0 then
        if not twtCooldown[src] then
            twtCooldown[src] = true
            local playerName = GetPlayerName(src)
            TriggerClientEvent('chatMessage', -1, "Chatter @" .. playerName, playerName .. ' twt', table.concat(raw, ' '))

            Citizen.CreateThread(function()
                Citizen.Wait(3000)
                twtCooldown[src] = nil
            end)
        else
            TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je zit nog in een Twitter-bericht cooldown!', 4000)
        end
    else
        TriggerClientEvent('frp-notifications:client:notify', src, "error", 'Je hebt een telefoon nodig om een Twitter-bericht te sturen!', 4000)
    end
end, false)




