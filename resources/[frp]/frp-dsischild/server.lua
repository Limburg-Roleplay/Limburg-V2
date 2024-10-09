ESX = exports["es_extended"]:getSharedObject()


ESX.RegisterUsableItem('dsischild', function(source)
    TriggerClientEvent('frp-dsischild:toggle', source)
    print("DSI-Schild word gebruikt")
end)