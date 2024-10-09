ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Hier kun je de serverlogica voor betalingen toevoegen, zoals geld van accounts verwijderen en transactiegeschiedenis bijhouden.
-- Dit script verwijdert geld van de "bank" en/of "money" account, afhankelijk van de betaalmethode.

ESX.RegisterServerCallback('frp-payments:callback:remove:money', function(source, cb, paymentMethod, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if paymentMethod == 'bank' then
        if xPlayer.getAccount('bank').money >= price then
            xPlayer.removeAccountMoney('bank', price)
            cb(true)
        else
            cb(false)
        end
    elseif paymentMethod == 'cash' then
        if xPlayer.getAccount('money').money >= price then
            xPlayer.removeMoney(price)
            cb(true)
        else
            cb(false)
        end
    else
        -- Onbekende betaalmethode, retourneer false (betaling mislukt).
        cb(false)
    end
end)