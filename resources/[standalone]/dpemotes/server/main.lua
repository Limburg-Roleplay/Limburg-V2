RegisterServerEvent('errormsgchat')
RegisterNetEvent('errormsgchat', function(bericht)
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 238, 136, 0.8); border-radius: 3px;"><i class="fas fa-map-marker-alt"></i> | '..bericht..'</div>',
    })
end)