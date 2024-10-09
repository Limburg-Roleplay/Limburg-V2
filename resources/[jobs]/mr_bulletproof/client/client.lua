exports('bulletproofvest', function(data, slot)
    local playerPed = PlayerPedId()
    local armour = GetPedArmour(playerPed)
    if armour ~= 100 then
        exports.ox_inventory:useItem(data, function(data)
            if data then
                SetPedArmour(playerPed, 50)
                TriggerServerEvent('mr-bulletproof:create')
            end
        end)
    else
        exports.ox_lib.notify({
            title = 'Bulletproof Vest',
            description = 'Je hebt al een bulletproof vest zonder damage aan?',
            type = 'error',
            duration = 5000,
        })
    end
end)