ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('jtm-idkaart:server:send:idkaart')
AddEventHandler('jtm-idkaart:server:send:idkaart', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local firstname = xPlayer.get('firstName')
    local lastname = xPlayer.get('lastName')
    local sex = xPlayer.get('sex')
    local dob = xPlayer.get('dateofbirth')
    local height = xPlayer.get('height') -- Assuming 'dateOfBirth' is the key for date of birth in player data

    --print(playerId, firstname, lastname, sex, dob)

    TriggerClientEvent('jtm-idkaart:client:geefidkaart', playerId, firstname, lastname, sex, dob, height)
    TriggerClientEvent("frp-notifications:client:notify", source, "success", "Je hebt je idkaart geven aan de dichtstbijzijnde persoon!", 3000)
end)
