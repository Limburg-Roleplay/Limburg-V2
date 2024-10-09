local outfits = {}

RegisterServerEvent('frp-clothingmenu:srv:save:outfit')
AddEventHandler('frp-clothingmenu:srv:save:outfit', function(name, outfit)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    outfits[playerId] = outfits[playerId] or {}
    table.insert(outfits[playerId], {name = name, outfit = outfit})

    TriggerClientEvent('frp-clothingmenu:cl:sync:outfits', source, outfits[playerId])
end)

RegisterServerEvent('frp-clothingmenu:srv:upd:outfit')
AddEventHandler('frp-clothingmenu:srv:upd:outfit', function(id, outfit)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    if outfits[playerId] and outfits[playerId][id] then
        outfits[playerId][id].outfit = outfit
        TriggerClientEvent('frp-clothingmenu:cl:sync:outfits', source, outfits[playerId])
    end
end)

RegisterServerEvent('frp-clothingmenu:srv:del:outfit')
AddEventHandler('frp-clothingmenu:srv:del:outfit', function(id)
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    if outfits[playerId] and outfits[playerId][id] then
        table.remove(outfits[playerId], id)
        TriggerClientEvent('frp-clothingmenu:cl:sync:outfits', source, outfits[playerId])
    end
end)

RegisterServerEvent('frp-clothingmenu:srv:get:outfits')
AddEventHandler('frp-clothingmenu:srv:get:outfits', function()
    local source = source
    local playerId = GetPlayerIdentifier(source, 0)

    TriggerClientEvent('frp-clothingmenu:cl:sync:outfits', source, outfits[playerId] or {})
end)
