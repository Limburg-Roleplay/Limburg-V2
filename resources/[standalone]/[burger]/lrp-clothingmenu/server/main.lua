local outfits = {}

RegisterServerEvent('lrp-clothingmenu:srv:save:outfit')
AddEventHandler('lrp-clothingmenu:srv:save:outfit', function(name, outfit)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    outfits[playerId] = outfits[playerId] or {}
    table.insert(outfits[playerId], {name = name, outfit = outfit})

    TriggerClientEvent('lrp-clothingmenu:cl:sync:outfits', source, outfits[playerId])
end)

RegisterServerEvent('lrp-clothingmenu:srv:upd:outfit')
AddEventHandler('lrp-clothingmenu:srv:upd:outfit', function(id, outfit)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    if outfits[playerId] and outfits[playerId][id] then
        outfits[playerId][id].outfit = outfit
        TriggerClientEvent('lrp-clothingmenu:cl:sync:outfits', source, outfits[playerId])
    end
end)

RegisterServerEvent('lrp-clothingmenu:srv:del:outfit')
AddEventHandler('lrp-clothingmenu:srv:del:outfit', function(id)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    if outfits[playerId] and outfits[playerId][id] then
        table.remove(outfits[playerId], id)
        TriggerClientEvent('lrp-clothingmenu:cl:sync:outfits', source, outfits[playerId])
    end
end)

RegisterServerEvent('lrp-clothingmenu:srv:get:outfits')
AddEventHandler('lrp-clothingmenu:srv:get:outfits', function()
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    TriggerClientEvent('lrp-clothingmenu:cl:sync:outfits', source, outfits[playerId] or {})
end)
