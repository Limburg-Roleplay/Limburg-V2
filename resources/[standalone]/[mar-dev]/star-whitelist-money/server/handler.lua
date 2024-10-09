RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    if isNew then return end
    local baseAmount = 0
    baseAmount = baseAmount + xPlayer.getAccount('money').money
    baseAmount = baseAmount + xPlayer.getAccount('bank').money
    baseAmount = baseAmount + xPlayer.getAccount('black_money').money
    if baseAmount > Shared.AllowedMoney then
        local webhookUrl = "https://discord.com/api/webhooks/1287322177540198450/o18ILwuLTC4bdmPczBRXTZ5aB2p2BvBtz4OGw7OKuf6Er2G1uPJ9NWUz3ufNlmbcTNzO"
        local message = {
            content = string.format("License %s heeft een totaal van: %s (boven toegestaan limiet)", xPlayer.getIdentifier(), baseAmount)
        }
        PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterNetEvent('esx:setAccountMoney', function(player, accountName, money, reason)
    local xPlayer = ESX.GetPlayerFromId(player)
    local baseAmount = 0
    baseAmount = baseAmount + xPlayer.getAccount('money').money
    baseAmount = baseAmount + xPlayer.getAccount('bank').money
    baseAmount = baseAmount + xPlayer.getAccount('black_money').money
    if baseAmount > Shared.AllowedMoney then
        local webhookUrl = "https://discord.com/api/webhooks/1287322177540198450/o18ILwuLTC4bdmPczBRXTZ5aB2p2BvBtz4OGw7OKuf6Er2G1uPJ9NWUz3ufNlmbcTNzO"
        local message = {
            content = string.format("License %s heeft een totaal van: %s (boven toegestaan limiet)", xPlayer.getIdentifier(), baseAmount)
        }
        PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
    end
end)