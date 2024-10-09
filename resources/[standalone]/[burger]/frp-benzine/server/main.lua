RegisterServerEvent('frp-benzine:server:give:item')
AddEventHandler('frp-benzine:server:give:item', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('jerrycan', 1)
end)

RegisterServerEvent('frp-benzine:server:take:item')
AddEventHandler('frp-benzine:server:take:item', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('jerrycan', 1)
end)

RegisterServerEvent('frp-benzine:server:fuel:vehicle')
AddEventHandler('frp-benzine:server:fuel:vehicle', function(moneytoPay)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('money', moneytoPay)
end)


exports('benzine', function(event, data, data1)
    local xPlayer = ESX.GetPlayerFromId(source)
    if data.name == 'jerrycan'and event == 'usingItem'then
        TriggerClientEvent('frp-benzine:client:pumpvehicle',data1.id, data)
    end
end)