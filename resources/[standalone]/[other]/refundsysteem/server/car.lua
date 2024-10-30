RegisterCommand('claimcarrefunds', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifiers = GetPlayerIdentifiers(source)
    local steamID, discordID = nil, nil
    local foundRefund = false
    local refundsProcessed, totalRefunds = 0, 0

    for _, identifier in ipairs(identifiers) do
        if string.sub(identifier, 1, 5) == 'steam' then
            steamID = string.sub(identifier, 7)
        elseif string.sub(identifier, 1, 7) == 'discord' then
            discordID = string.sub(identifier, 9)
        end
    end
    print(steamID, discordID)

    MySQL.Async.fetchAll(
        [[
        SELECT car_model 
        FROM car_refunds 
        WHERE identifier LIKE CONCAT('%', @steamID) OR identifier LIKE CONCAT('%', @discordID)
        ]], 
        {
            ['@steamID'] = steamID,
            ['@discordID'] = discordID
        }, 
        function(results)
            totalRefunds = totalRefunds + #results
            for _, row in ipairs(results) do
                local car_model = row.car_model

                MySQL.Async.execute(
                    [[
                    DELETE FROM car_refunds 
                    WHERE (identifier LIKE CONCAT('%', @steamID) OR identifier LIKE CONCAT('%', @discordID)) 
                    AND car_model = @car_model
                    ]],
                    {
                        ['@steamID'] = steamID,
                        ['@discordID'] = discordID,
                        ['@car_model'] = car_model
                    }, 
                    function(affectedRows)
                        refundsProcessed = refundsProcessed + 1

                        if affectedRows > 0 then
                            local playerCoords = GetEntityCoords(GetPlayerPed(source))
                            local playerName = GetPlayerName(source)

                            TriggerClientEvent('esx_giveownedcar:spawnVehicle', source, car_model, playerName, "console", "car", playerCoords)
                            foundRefund = true
                        end

                        if refundsProcessed == totalRefunds then
                            if foundRefund then
                                TriggerClientEvent('okokNotify:Alert', source, 'Car refund(s) have been claimed.', 5000, 'success')
                            else
                                TriggerClientEvent('okokNotify:Alert', source, 'You do not have any car refunds available.', 5000, 'error')
                            end
                        end
                    end
                )
            end

            if not results or json.encode(results) == "[]" then
                TriggerClientEvent('okokNotify:Alert', source, 'You do not have any car refunds available.', 5000, 'error')
            end
        end
    )
end, false)




local function isNumeric(str)
    return str:match("^%d+$") ~= nil
end

RegisterCommand('givecarrefund', function(source, args, rawCommand)
    if source ~= 0 then
        print("This command can only be used from the console.")
        return
    end

    local playerIdentifier = args[1]  
    local carModel = args[2]     

    if not playerIdentifier or not carModel then
        print("Usage: createcarrefund [id] [carModel]")
        return
    end

    if not string.match(playerIdentifier, '^steam:') and not string.match(playerIdentifier, '^discord:') then
        local isSteamID = string.match(playerIdentifier, '%d')

        if not isNumeric(playerIdentifier) then
            playerIdentifier = "steam:" .. playerIdentifier
        else
            playerIdentifier = "discord:" .. playerIdentifier
        end
    end

    MySQL.Async.execute('INSERT INTO car_refunds (identifier, car_model) VALUES (@id, @car_model)', {
        ['@id'] = playerIdentifier,
        ['@car_model'] = carModel
    }, function(affectedRows)
        if affectedRows > 0 then
            print("Car refund created successfully for player: " .. playerIdentifier)
        else
            print("Failed to create car refund for player: " .. playerIdentifier)
        end
    end)
end, false)
