ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('frp-carwash:checkPayment', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local price = 250
        local playerCash = xPlayer.getMoney()
        local playerBank = xPlayer.getAccount('bank').money

        if playerCash >= price then
            xPlayer.removeMoney(price) 
            cb(true)

        elseif playerBank >= price then
            xPlayer.removeAccountMoney('bank', price)
            cb(true)

        else
            cb(false)
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('frp-carwash:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        cb(xPlayer.job.name)
    else
        cb(nil)
    end
end)
