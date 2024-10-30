ESX = exports["es_extended"]:getSharedObject()


ESX.RegisterUsableItem('dsischild', function(source)
    TriggerClientEvent('lrp-dsischild:toggle', source)
    print("DSI-Schild word gebruikt")
end)