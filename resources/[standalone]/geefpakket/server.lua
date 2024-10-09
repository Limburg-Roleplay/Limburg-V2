local function replacePlaceholders(params, playerSrc, playerSteam, playerName, playerCoords)
    local replacedParams = {}
    for k, v in pairs(params) do
        if type(v) == "string" then
            v = v:gsub(":playerSrc", tostring(playerSrc))
            v = v:gsub(":playerSteam", playerSteam)
            v = v:gsub(":playerName", playerName)
            v = v:gsub(":playerCoords", playerCoords)
        end
        replacedParams[k] = v
    end
    return replacedParams
end

local function triggerEventByType(itemData, params, playerID)
    local paramValues = {}
    for _, paramName in ipairs(itemData.paramOrder) do
        table.insert(paramValues, params[paramName])
    end

    if itemData.eventType == 'server' then
        TriggerEvent(itemData.event, playerID, table.unpack(paramValues))
    elseif itemData.eventType == 'client' then
        TriggerClientEvent(itemData.event, playerID, table.unpack(paramValues))
    else
        print("Unknown event type: " .. itemData.eventType)
    end
end

RegisterCommand("geefpakket", function(source, args, rawCommand)
    if source ~= 0 then
        print("This command can only be run from the console!")
        return
    end

    local packageName = args[1]
    local playerID = tonumber(args[2])

    if not packageName or not playerID then
        print("Usage: /geefpakket [package name] [player ID]")
        return
    end

    local identifiers = GetPlayerIdentifiers(playerID)
    local steamID
    for _, id in ipairs(identifiers) do
        if id:match("steam:") then
            steamID = id
            break
        end
    end
    if not steamID then
        print("No Steam ID found for player ID: " .. playerID)
        return
    end

    local playerName = GetPlayerName(playerID)
    local playerCoords = GetEntityCoords(GetPlayerPed(playerID))

    local package = Config.packages[packageName]
    if not package then
        print("Invalid package name: " .. packageName)
        return
    end

    for itemName, itemData in pairs(package.items) do
        local params = replacePlaceholders(itemData.params, playerID, steamID, playerName, tostring(playerCoords))
        triggerEventByType(itemData, params, playerID)
    end

    print("Package '" .. packageName .. "' has been processed for player ID: " .. playerID)

    -- Improved logging message
    local logMessage = string.format(
        "Package **%s** has been successfully given to player **%s** (ID: %d, Steam: %s).",
        packageName,
        playerName,
        playerID,
        steamID
    )

    -- Send log to Discord
    TriggerEvent('td_logs:sendLog',
        'https://discord.com/api/webhooks/1277030965629157409/8WFyu0fb32tNzVgoDGN0qLJaez_HHscE9MtcLnWQIoM6ZPZY3cf9T1BA7uGUYGF4AcuK',  -- Webhook URL
        source, 
        {
            title = "**Package Given** by Console",
            desc = logMessage
        },
        0x00ff00 -- Green color
    )
end, true)
