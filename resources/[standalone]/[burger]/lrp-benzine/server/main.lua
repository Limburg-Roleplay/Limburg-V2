RegisterServerEvent('lrp-benzine:server:give:item')
AddEventHandler('lrp-benzine:server:give:item', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('jerrycan', 1)
end)

RegisterServerEvent('lrp-benzine:server:take:item')
AddEventHandler('lrp-benzine:server:take:item', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('jerrycan', 1)
end)

RegisterServerEvent('lrp-benzine:server:fuel:vehicle')
AddEventHandler('lrp-benzine:server:fuel:vehicle', function(moneytoPay)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('money', moneytoPay)
end)


exports('benzine', function(event, data, data1)
    local xPlayer = ESX.GetPlayerFromId(source)
    if data.name == 'jerrycan'and event == 'usingItem'then
        TriggerClientEvent('lrp-benzine:client:pumpvehicle',data1.id, data)
    end
end)