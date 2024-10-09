local apiUrl = Config.ApiUrl .. '/activePlayers'

function getDiscordIdentifier(playerId)
    if not Config.EnableDiscordCheck then return end
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "discord:") then
            return identifier
        end
    end
    return nil
end

function sendActivePlayersToAPI()
    if not Config.EnableActivePlayersAPI then return end
    local players = GetPlayers()
    local playerData = {}

    for _, playerId in ipairs(players) do
        local playerName = GetPlayerName(playerId)
        local discordId = getDiscordIdentifier(playerId)

        table.insert(playerData, {
            id = playerId,
            name = playerName,
            discord = discordId or "N/A"
        })
    end

    local jsonData = json.encode(playerData)

    PerformHttpRequest(apiUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            -- Data successfully sent to API
        else
            print("Failed to send data. Status Code: " .. statusCode)
        end
    end, 'POST', jsonData, { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    while true do
        sendActivePlayersToAPI()
        Citizen.Wait(30000)
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    if not Config.EnableDiscordCheck then 
        deferrals.done() 
        return 
    end
    
    local _source = source
    local identifiers = GetPlayerIdentifiers(_source)

    local discord_id, fivem, steam, license, license2

    for _, id in ipairs(identifiers) do
        if string.match(id, 'discord:') then
            discord_id = id
        elseif string.match(id, 'fivem:') then
            fivem = id
        elseif string.match(id, 'steam:') then
            steam = id
        elseif string.match(id, 'license:') then
            license = id
        elseif string.match(id, 'license2:') then
            license2 = id
        end
    end

    deferrals.defer()
    deferrals.update("Checking user data...")

    MySQL.Async.fetchScalar('SELECT id FROM identifiers WHERE discord_id = @discord_id', {
        ['@discord_id'] = discord_id
    }, function(existingUserId)
        if not existingUserId then
            MySQL.Async.execute('INSERT INTO identifiers (discord_id, fivem, steam, license, license2, playername) VALUES (@discord_id, @fivem, @steam, @license, @license2, @playername)', {
                ['@discord_id'] = discord_id,
                ['@fivem'] = fivem,
                ['@steam'] = steam,
                ['@license'] = license,
                ['@license2'] = license2,
                ['@playername'] = playerName
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    deferrals.done("Je moet Discord open hebben staan om hierdoor heen te komen.")
                end
            end)
        else
            deferrals.done()
        end
    end)
end)

RegisterCommand('givedonationpackage', function(source, args, rawCommand)
    if not Config.EnableDonationPackage then 
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'This feature is disabled.' } })
        print("[ERROR]: This feature is disabled")
        return 
    end

    if source == 0 or IsPlayerAceAllowed(source, 'tsm.admin') or IsPlayerAceAllowed(source, 'tsm.givedonation') then
        local playerId = args[1]
        local packageId = args[2]

        if not playerId or not packageId then
            TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'Please specify both a player ID and a package ID.' } })
            return
        end

        local apiUrl = Config.ApiUrl .. "/retrieveDonationPackages"

        PerformHttpRequest(apiUrl, function(statusCode, response, headers)
            if statusCode == 200 then
                local donationPackages = json.decode(response)

                for _, package in ipairs(donationPackages) do
                    if tostring(package.id) == packageId then
                        TriggerClientEvent('chat:addMessage', playerId, { args = { '^2Donation Package', 'You have received the donation package: ' .. package.package_name } })

                        for _, item in ipairs(package.items) do
                            if item.type == "item" then
                                local xPlayer = ESX.GetPlayerFromId(playerId)
                                xPlayer.addInventoryItem(item.modelName, item.itemCount)
                            elseif item.type == "car" then
                                TriggerClientEvent('esx:spawnVehicle', playerId, item.modelName)
                            end
                        end

                        return
                    end
                end

                TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'Donation package not found.' } })

            else
                TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'Failed to retrieve donation packages. Please try again later.' } })
            end
        end, 'GET', '', { ['secret-key'] = Config.SecretKey })
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'You do not have permission to use this command.' } })
    end
end)

RegisterCommand('tsm_claimrefunds', function(source, args, rawCommand)
    if not Config.EnableRefundsClaiming then 
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'This feature is disabled.' } })
        return 
    end

    local playerId = source

    if not playerId then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'Please specify a valid player ID.' } })
        return
    end

    local discordIdentifier
    for _, identifier in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(identifier, 1, 8) == "discord:" then
            discordIdentifier = identifier
            break
        end
    end

    if not discordIdentifier then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'No Discord identifier found for this player.' } })
        return
    end

    local apiUrl = Config.ApiUrl .. "/retrieveRefunds"

    PerformHttpRequest(apiUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            local refunds = json.decode(response)

            local foundRefunds = false

            for _, refund in ipairs(refunds) do
                if refund.identifier == discordIdentifier then
                    foundRefunds = true

                    local deleteUrl = Config.ApiUrl .. "/removeRefund"
                    PerformHttpRequest(deleteUrl, function(deleteStatusCode, deleteResponse, deleteHeaders)
                        if deleteStatusCode == 200 then
                            TriggerClientEvent('chat:addMessage', playerId, { args = { '^2Refunds', 'You have received the item: ' .. refund.item } })

                            local xPlayer = ESX.GetPlayerFromId(playerId)
                            xPlayer.addInventoryItem(refund.item, refund.itemCount)

                        else
                            TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'Failed to delete refund. Please try again later.' } })
                        end
                    end, 'POST', json.encode({ identifier = discordIdentifier, item = refund.item }), { ['Content-Type'] = 'application/json', ['secret-key'] = Config.SecretKey })
                    break
                end
            end

            if not foundRefunds then
                TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'No refunds found.' } })
            end

        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1Error', 'Failed to retrieve refunds. Please try again later.' } })
        end
    end, 'GET', '', { ['secret-key'] = Config.SecretKey })
end)

local apiURL = Config.ApiUrl .. "/console-logs"

function readLogFile(filePath)
    local file, err = io.open(filePath, "r")

    if not file then
        print("Could not open file: " .. err) 
        return
    end

    local contents = file:read("*all")
    file:close()

    if contents then
        sendLogToAPI(contents) 
    else
        print("The file is empty or could not be read.")
    end
end

function sendLogToAPI(logContents)
    PerformHttpRequest(apiURL, function(statusCode, response, headers)
        if statusCode == 200 then
            -- print("Log sent successfully: " .. response)
        else
            print("Failed to send log: " .. tostring(statusCode))
        end
    end, "POST", json.encode({ file_contents = logContents }), { ["Content-Type"] = "application/json" })
end

local logFilePath = "C:/Limburg/txData/default/logs/fxserver.log"

if Config.EnableLogSending then
    Citizen.CreateThread(function()
        while true do
            readLogFile(logFilePath)
            Citizen.Wait(5000)
        end
    end)
end
