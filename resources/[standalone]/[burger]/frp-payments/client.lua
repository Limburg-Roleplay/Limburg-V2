RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    for i = 1, #ESX.PlayerData.accounts do 
        if ESX.PlayerData.accounts[i].name == account.name then 
            ESX.PlayerData.accounts[i].money = account.money
            break
        end
    end
end)

local currentCallback = nil
local currentData = {}

exports('startPayment', function(data, callback)
    -- print(ESX.DumpTable(ESX.PlayerData))
    for i = 1, #ESX.PlayerData.accounts do 
        if ESX.PlayerData.accounts[i].name == 'bank' then 
            data.pin = ESX.PlayerData.accounts[i].money
        elseif ESX.PlayerData.accounts[i].name == 'money' then
            data.cash = ESX.PlayerData.accounts[i].money
        end
    end

    currentData, currentCallback = data, callback

    SendNUIMessage({
        action = 'open',
        data = data
    })
    
    SetNuiFocus(true, true)

end)

RegisterNUICallback('finishPayment', function(data)
    SetNuiFocus(false, false)

    local paymentMethod = data.paymentMethod
    print("Payment method received: " .. paymentMethod) -- Add this line for debugging
    ESX.TriggerServerCallback('frp-payments:callback:remove:money', function(success)
        currentCallback(success)
    end, paymentMethod, currentData.price)
end)



RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
    currentCallback(false)
end)


