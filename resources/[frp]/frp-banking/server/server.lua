ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local withdrawalFee = 0
local depositFee = 0

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if tonumber(amount) > 0 then
        local balance = xPlayer.getAccount('bank').money
        
        if balance >= tonumber(amount) + withdrawalFee then
            xPlayer.removeAccountMoney('bank', tonumber(amount) + withdrawalFee)
            xPlayer.addMoney(tonumber(amount))
            TriggerClientEvent('frp-notifications:client:notify', _source, 'success', 'Je hebt €' .. tonumber(amount) .. ' opgenomen van je bankrekening.', '5000')
        else
            TriggerClientEvent('frp-notifications:client:notify', _source, 'error', 'Niet genoeg geld op je bankrekening.', '5000')
        end
    else
        TriggerClientEvent('frp-notifications:client:notify', _source, 'error', 'Ongeldige hoeveelheid.', '5000')
    end
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if tonumber(amount) > 0 then
        local cash = xPlayer.getMoney()
        
        if tonumber(cash) >= tonumber(amount) then
            xPlayer.removeMoney(tonumber(amount))
            xPlayer.addAccountMoney('bank', tonumber(amount) - depositFee)
            TriggerClientEvent('frp-notifications:client:notify', _source, 'success', 'Je hebt €' .. tonumber(amount) .. ' gestort op je bankrekening.', '5000')
        else
            TriggerClientEvent('frp-notifications:client:notify', _source, 'error', 'Niet genoeg contant geld.', '5000')
        end
    else
        TriggerClientEvent('frp-notifications:client:notify', _source, 'error', 'Ongeldige hoeveelheid.', '5000')
    end
end)

ESX.RegisterServerCallback('bank:getnames', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local bankBalance = xPlayer.getAccount('bank').money
        local playerId = xPlayer.getIdentifier()

        MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
            ['@identifier'] = playerId
        }, function(result)
            local playerName = 'Unknown Player'

            if result[1] then
                playerName = result[1].firstname
                local lastname = result[1].lastname
                if lastname then
                    playerName = playerName .. ' ' .. lastname
                end
            end

            cb({
                bank = bankBalance,
                firstname = playerName,
                lastname = ''
            })
        end)
    else
        cb({
            bank = 0,
            firstname = 'Unknown',
            lastname = 'Player'
        })
    end
end)
