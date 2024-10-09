RegisterCommand("sa", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer.getGroup()

    if playerGroup == 'staff' or playerGroup == 'owner' or playerGroup == 'hogerop' then
        if not exports["frp-staffdienst"]:inDienst(source) then
            return
                TriggerClientEvent("frp-notifications:client:notify", source, 'error',
                    'Je bent niet in dienst, zorg dat je <br> /staffdienst hebt gedaan')
        end
        TriggerClientEvent("frp-staffassist:client:openmenu", source)
    else
        TriggerClientEvent('chatMessage', source, 'SYSTEEM', 'error', 'Je hebt geen permissies hier voor')
    end
end)
---- check voor skinmenu
ESX.RegisterServerCallback('frp-staffassist:skinmenu', function(source, cb, action)
    local xPlayer = ESX.GetPlayerFromId(source)
    local discordlog = exports["frp-logging"]:createlog(Config.Webhook, " Staffassist")

    discordlog.addcolumns({
        staffId = source,
        staffIdentifier = xPlayer.identifier,
        Action = action
    })
    discordlog.send()
    cb(true)
end)

---- logger
ESX.RegisterServerCallback('frp-staffassist:commandlog', function(source, cb, action)
    local xPlayer = ESX.GetPlayerFromId(source)
    local discordlog = exports["frp-logging"]:createlog(Config.Webhook, "Staffassist")

    discordlog.addcolumns({
        staffId = source,
        staffIdentifier = xPlayer.identifier,
        Action = action
    })
    discordlog.send()
    cb(true)
end)

ESX.RegisterServerCallback('jtm-staffassist:giverefund', function(source, cb, identifier, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        cb(false, "Speler niet gevonden.")
        print('Speler niet gevonden.')
        return
    end

    local playerGroup = xPlayer.getGroup()
    if playerGroup ~= 'owner' and playerGroup ~= 'hogerop' and playerGroup ~= 'staff' then
        cb(false, "Je hebt geen toestemming om dit te doen.")
        print('Je hebt geen toestemming om dit te doen.')
        return
    end

    if not identifier then
        cb(false, "Geen identifier opgegeven.")
        print('Geen identifier opgegeven.')
        return
    end

    if not args or not args.item or not args.itemCount or tonumber(args.itemCount) <= 0 then
        cb(false, "Onvoldoende of ongeldige argumenten opgegeven.")
        print('Onvoldoende of ongeldige argumenten opgegeven.')
        return
    end

    local steamID = identifier
    local item = args.item
    local itemCount = tonumber(args.itemCount)

    MySQL.Async.execute('INSERT INTO user_refunds (steamID, item, itemCount) VALUES (@steamID, @item, @itemCount)', {
        ['@steamID'] = steamID,
        ['@item'] = item,
        ['@itemCount'] = itemCount
    }, function(rowsChanged)
        if rowsChanged > 0 then
            local user = (source > 0) and GetPlayerName(source) or "console"
            TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263084444126937139/mt-6esOqJ_oH2NTqjwrXz5PzlAEfbZl15h1wHQzYhgCIGe0GQh_2xiZV7DtGdSYTv38p', user, {
                title = "Naam Speler: " .. xPlayer.getName() .. " Identifier Speler: " .. steamID .. " Refund uitgeschreven door: " .. user,
                desc = "Betreft: " .. itemCount .. "x " .. item
            })

            cb(true, "Refund succesvol toegekend.")
            print('Refund succesvol toegekend.')
        else
            cb(false, "Kon geen refunds plaatsen.")
            print('Kon geen refunds plaatsen.')
        end
    end)
end)

ESX.RegisterServerCallback('jtm-staffassist:checkrefund', function(source, cb, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        cb(false, "Speler niet gevonden.")
        return
    end

    local playerGroup = xPlayer.getGroup()
    if playerGroup ~= 'owner' and playerGroup ~= 'hogerop' and playerGroup ~= 'staff' then
        cb(false, "Je hebt geen toestemming om dit te doen.")
        return
    end

    if not identifier then
        cb(false, "Geen identifier opgegeven.")
        return
    end

    -- Voer de MySQL query uit
    MySQL.Async.fetchAll('SELECT steamID, item, itemCount FROM user_refunds WHERE steamID = @steamID LIMIT 1', {
        ['@steamID'] = identifier
    }, function(result)
        if result then
            if #result > 0 then
                -- Print de gevonden waarden
                local foundSteamID = result[1].steamID
                local foundItem = result[1].item
                local foundItemCount = result[1].itemCount

                TriggerEvent("td_logs:sendLogNoFields", "https://discord.com/api/webhooks/1263119656336490496/yKCJ3PkIjDFs5Vs9o6fi6UFuYIptjHBOmG16qcD2dYfXfoQR1zJHTAm3TaQRnadl0bmm", {
                    title = "Checkrefund: Gegevens gevonden in de database",
                    desc = "SteamID: " .. foundSteamID .. "\nItem: " .. foundItem .. "\nItemCount: " .. foundItemCount .. "\nOpgeroepen door: " .. xPlayer.getName()
                }, 0x00ff00)

                cb(true, "Gegevens succesvol opgehaald uit database.")
            else
                cb(false, "Geen overeenkomst gevonden in de database.")
            end
        else
            cb(false, "Fout bij het ophalen van gegevens uit de database.")
        end
    end)
end)


ESX.RegisterServerCallback('jtm-staffassist:checkinventory', function(source, cb, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local playerGroup = xPlayer.getGroup()
        if playerGroup == 'owner' or playerGroup == 'hogerop' or playerGroup == 'staff' then
            if not identifier then
                cb(false, "No identifier provided.")
                return
            end

            MySQL.Async.fetchAll(
                "SELECT firstname, lastname, inventory FROM users WHERE identifier = @identifier",
                {["@identifier"] = identifier},
                function(usersResult)
                    if #usersResult == 0 then
                        cb(false, "Geen speler gevonden met die identifier!")
                        return
                    end

                    local user = usersResult[1]
                    if user then
                        print("Name: " .. user.firstname .. " " .. user.lastname)
                        if user.inventory then
                            print("Inventory van [" .. identifier .. "]: " .. user.inventory)
                        else
                            print("No inventory data found for identifier " .. identifier)
                        end
                        cb(true, user.inventory)
                        
                        TriggerEvent(
                            "td_logs:sendLogNoFields",
                            "https://discord.com/api/webhooks/1263064042717708320/KMXl37nq_G4bfDFEFS76Oes3SK_a8rUi6PLKSbDJM78tqoKa-8lOgjyXU9ZETrkdpwaw",
                            {
                                title = "Naam Speler: " .. user.firstname .. " " .. user.lastname .." Identifier Speler: " .. identifier .. " Inventory opgezocht door Staff Naam: "  .. xPlayer.getName(),
                                desc = "Inventory: " .. json.encode(user.inventory)
                            },
                            0xffffff
                        )
                    else
                        cb(false, "User data is nil.")
                    end
                end
            )
        else
            print("You do not have permission to use this command.")
            cb(false, "Je hebt niet de juiste perms om deze command te gebruiken!")
        end
    else
        print("Player not found.")
        cb(false, "Speler niet gevonden!")
    end
end)

ESX.RegisterServerCallback('jtm-staffassist:checkappainventory', function(source, cb, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local playerGroup = xPlayer.getGroup()
        if playerGroup == 'owner' or playerGroup == 'hogerop' or playerGroup == 'staff' then
            if not identifier then
                cb(false, "No identifier provided.")
                return
            end

            MySQL.Async.fetchAll(
                "SELECT owner, name, data FROM ox_inventory WHERE owner = @identifier",
                {["@identifier"] = identifier},
                function(inventoryResult)
                    if #inventoryResult == 0 then
                        cb(false, "No inventory found for this identifier!")
                        return
                    end

                    local inventory = inventoryResult[1]
                    if inventory then
                        print("Owner: " .. inventory.owner)
                        print("Name: " .. inventory.name)
                        if inventory.data then
                            print("Data: " .. inventory.data)
                        else
                            print("No inventory data found for identifier " .. identifier)
                        end
                        cb(true, inventory.data)
                        
                        TriggerEvent(
                            "td_logs:sendLogNoFields",
                            "https://discord.com/api/webhooks/1263125004049055900/4CnmeoR9CXCOb-W2O2ijEwabIq4cmKEj59ocTweN-vE5Lx5D0lvmg32EzWimmK_DP3O6",
                            {
                                title = "Inventory Information",
                                desc = "Owner: " .. inventory.owner .. "\nName: " .. inventory.name .. "\nData: " .. inventory.data .. "\nSearched by: " .. xPlayer.getName()
                            },
                            0xffffff
                        )
                    else
                        cb(false, "Inventory data is nil.")
                    end
                end
            )
        else
            print("You do not have permission to use this command.")
            cb(false, "Je hebt niet de juiste perms om deze command te gebruiken!")
        end
    else
        print("Player not found.")
        cb(false, "Speler niet gevonden!")
    end
end)

ESX.RegisterServerCallback('jtm-staffassist:checkvoertuiginventory', function(source, cb, identifier)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local playerGroup = xPlayer.getGroup()
        if playerGroup == 'owner' or playerGroup == 'hogerop' or playerGroup == 'staff' then
            if not identifier then
                cb(false, "No identifier provided.")
                return
            end

            MySQL.Async.fetchAll(
                "SELECT owner, plate, vehicle, glovebox, trunk FROM owned_vehicles WHERE owner = @identifier",
                {["@identifier"] = identifier},
                function(vehiclesResult)
                    if #vehiclesResult == 0 then
                        cb(false, "Geen voertuigen gevonden voor deze identifier!")
                        return
                    end

                    local vehicleData = {}
                    for _, vehicle in ipairs(vehiclesResult) do
                        local data = {
                            owner = vehicle.owner,
                            plate = vehicle.plate,
                            glovebox = vehicle.glovebox or "Niet beschikbaar",  -- Handle nil case
                            trunk = vehicle.trunk or "Niet beschikbaar"  -- Handle nil case
                        }
                        table.insert(vehicleData, data)
                    end

                    cb(true, vehicleData)

                    -- Logging to Discord example
                    local playerName = xPlayer.getName()
                    for _, vehicle in ipairs(vehicleData) do
                        local gloveboxInfo = vehicle.glovebox or "Niet beschikbaar"  -- Handle nil case
                        local trunkInfo = vehicle.trunk or "Niet beschikbaar"  -- Handle nil case
                        TriggerEvent(
                            "td_logs:sendLogNoFields",
                            "https://discord.com/api/webhooks/1263122292821725285/0yJ41kMXvMTIVxEUujpdNxc13phcvfqUH1VfZv9LqrHE-mQtjMaP5dScTHMd16k65WcT",
                            {
                                title = "Voertuiginformatie opgezocht door Staff",
                                desc = "Eigenaar: " .. vehicle.owner .. "\n" ..
                                       "Kenteken: " .. vehicle.plate .. "\n" ..
                                       "Glovebox: " .. gloveboxInfo .. "\n" ..
                                       "Trunk: " .. trunkInfo .. "\n" ..
                                       "Opgezocht door: " .. playerName
                            },
                            0xffffff
                        )
                    end
                end
            )
        else
            print("You do not have permission to use this command.")
            cb(false, "Je hebt niet de juiste perms om deze command te gebruiken!")
        end
    else
        print("Player not found.")
        cb(false, "Speler niet gevonden!")
    end
end)


ESX.RegisterServerCallback('refundperms', function(source, cb, identifier)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        return
    end
    
    local playerGroup = xPlayer.getGroup()

    if playerGroup == 'owner' or playerGroup == 'hogerop' then
        TriggerClientEvent('openRefundOptions', source)
    else
      TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Je hebt niet de goede rang om dit te kunnen doen!')
    end
end)

-- // [PLAYER WARNED] \\ --
AddEventHandler('txAdmin:events:playerWarned', function(eventData)
    local author = eventData.author
    local target = eventData.target
    local reason = eventData.reason
    local targetName = GetPlayerName(target)

    local targetPlayerId = eventData.target
        
    local message = string.format(
        "%s is gewaarschuwd door '%s' voor %s",
        targetName,
        author,
        reason
    )

    TriggerClientEvent('chatMessage', -1, 'SYSTEEM', 'staffwarning', message)
end)

-- // [PLAYER BANNED] \\ --
AddEventHandler('txAdmin:events:playerBanned', function(eventData)
    local author = eventData.author
    local targetName = eventData.targetName
    local reason = eventData.reason

    local message = string.format(
        "%s is op vakantie gestuurd door '%s' voor %s",
        targetName,
        author,
        reason
    )

    TriggerClientEvent('chatMessage', -1, 'SYSTEEM', 'staffwarning', message)
end)

-- // [PLAYER KICKED] \\ --
AddEventHandler('txAdmin:events:playerKicked', function(eventData)
    local author = eventData.author
    local targetId = eventData.target
    local reason = eventData.reason

    local targetPlayer = ESX.GetPlayerFromId(targetId)
    local targetName = targetPlayer.name

    local message = string.format(
        "%s is de stad uit gestuurd door '%s' voor %s",
        targetName,
        author,
        reason
    )

    TriggerClientEvent('chatMessage', -1, 'SYSTEEM:', 'staffwarning', message)
end)

RegisterCommand('removecar', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerGroup = xPlayer and xPlayer.getGroup() or nil

    if source == 0 or playerGroup == 'owner' or playerGroup == 'hogerop' then
        local plate = table.concat(args, " ")

        print("Plate to remove: " .. tostring(plate))

        if plate == nil or plate == '' then
            if source ~= 0 then
                TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Ongeldig kenteken.' } })
            else
                print('Ongeldig kenteken.')
            end
            return
        end

        MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        }, function(affectedRows)
            print("Affected rows: " .. tostring(affectedRows))

            if affectedRows > 0 then
                if source ~= 0 then
                    TriggerClientEvent('chat:addMessage', -1, { args = { 'SYSTEEM:', 'Voertuig succesvol verwijderd.' } })
                else
                    print('Voertuig succesvol verwijderd.')
                end
            else
                if source ~= 0 then
                    TriggerClientEvent('chat:addMessage', -1, { args = { 'SYSTEEM:', 'Geen voertuig met dat kenteken gevonden!' } })
                else
                    print('Geen voertuig met dat kenteken gevonden!')
                end
            end
        end)
    else
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Je hebt geen toestemming om dit commando te gebruiken.' } })
        else
            print('Je hebt geen toestemming om dit commando te gebruiken.')
        end
    end
end, false)



function setOfflineGroup(identifier, group)
    local query = "UPDATE users SET `group` = @group WHERE `identifier` = @identifier"
    local parameters = {
        ['@group'] = group,
        ['@identifier'] = identifier
    }

    MySQL.Async.execute(query, parameters, function(affectedRows)
        if affectedRows > 0 then
            print("Group updated successfully for identifier: " .. identifier)
        else
            print("Failed to update group or identifier not found: " .. identifier)
        end
    end)
end

RegisterCommand('setofflinegroup', function(source, args, rawCommand)
    if source == 0 then
        local identifier = args[1]
        local group = args[2]

        if identifier and group then
            setOfflineGroup(identifier, group)
        else
            print("Usage: /setofflinegroup [identifier] [group]")
        end
    else
        print("This command can only be run from the server console.")
    end
end, true)