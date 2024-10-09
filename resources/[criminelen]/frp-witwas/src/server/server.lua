-- // [VARIABLES] \\ --

local Exios = { Functions = { Utils = {} }, Data = { inRuns = {} } }

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('exios-witwas:server:cb:get:shared', function(source, cb)
    cb(Shared)
end)

-- // [EVENTS] \\ --

RegisterNetEvent('exios-witwas:server:start:cleaning')
AddEventHandler('exios-witwas:server:start:cleaning', function(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    
    if not xPlayer then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning^7 or ^5spectating^7')
        return 
    end

    local dist = #(GetEntityCoords(GetPlayerPed(xPlayer.source)) - Shared.StartLocations[index]['coords'])
    if dist > 5 then 
        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1262719850262953995/0TCwgBit2-3JRkrIIK5Dz-U4VPzeYNqRE4Ew_n8i5VicF957OFvsfIP5v96YEkT-7-0u', source, { title = GetPlayerName(source) .. " has triggered money laundering outside the allowed range" }, 0x000001)
        exports["FIVEGUARD"]:screenshotPlayer(source, function(url)
            print("Got URL of screenshot: ".. url .." from player: "..source)
        end)
        exports["FIVEGUARD"]:fg_BanPlayer(source, "Suspicious activity detected: Player ID " .. source .. " attempted to trigger money laundering", true)
        return
    end

    local itemData = exports.ox_inventory:GetItem(xPlayer.source, 'black_money')
    if not itemData or itemData.count < 10000 then
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 does not have enough black money to start cleaning')
        return 
    end

    if Exios.Data.inRuns[xPlayer.source] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 is already in a money laundering run')
        return 
    end

    Exios.Data.inRuns[xPlayer.source] = true
    TriggerClientEvent('exios-witwas:client:started:cleaning', xPlayer.source)
end)


RegisterNetEvent('exios-witwas:server:delivered:witwas')
AddEventHandler('exios-witwas:server:delivered:witwas', function(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if not Exios.Data.inRuns[xPlayer.source] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
    local dist = #(playerCoords - Shared.SellLocations[index]['coords'])
    if dist > 5.0 then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    local itemData = exports.ox_inventory:GetItem(xPlayer.source, 'black_money')
    if not itemData or itemData.count < 500 then 
        TriggerClientEvent('exios-witwas:client:complete', xPlayer.source, false)
        Exios.Data.inRuns[xPlayer.source] = false
        return
    end

    local defaultPercentage = tonumber(Shared.percentage)
    if not defaultPercentage then
        print('[^4' .. GetCurrentResourceName() .. '^7] Fout: Shared.percentage is geen geldige numerieke waarde.')
        return
    end

    local minifiedPercentage = defaultPercentage / 100

    -- Process only 1/4 of the black money per event trigger
    local removedBlackAmount = math.floor(itemData.count / 4)
    local totalReceive = removedBlackAmount * minifiedPercentage

    exports.ox_inventory:RemoveItem(xPlayer.source, 'black_money', removedBlackAmount)
    exports.ox_inventory:AddItem(xPlayer.source, 'money', totalReceive)

    -- Format numbers with dots as thousands separators
    local function formatNumber(number)
        local formatted = tostring(number)
        while true do  
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
            if k == 0 then
                break
            end
        end
        return formatted
    end

    local playerName = xPlayer.getName()
    local steamName = GetPlayerName(xPlayer.source)
    local steamID = xPlayer.identifier
    local initialBlackMoney = formatNumber(itemData.count)
    local remainingBlackMoney = formatNumber(itemData.count - removedBlackAmount)
    local totalReceiveFormatted = formatNumber(totalReceive)
    local coordsStr = string.format("x: %.2f, y: %.2f, z: %.2f", playerCoords.x, playerCoords.y, playerCoords.z)

    TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263156391816855552/ztptifCsR4WXPbNS2ARJ9Lbl4qrMunRwtEOLkFH65JMyFMwiD24q1s1cTQHvgacp4B6h', source, {
        title = "Witwas Logs",
        desc = "Ingame Naam Speler: " .. playerName .. "\nSteam Naam: " .. steamName .. "\nIdentifier Speler: " .. steamID .. "\nCoords: " .. coordsStr .. "\nZwartgeld voor: " .. initialBlackMoney .. "\nZwartgeld na: " .. remainingBlackMoney .. "\nWitgeld ontvangen: " .. totalReceiveFormatted
    })

    TriggerClientEvent('exios-witwas:client:complete', xPlayer.source, true)

    -- Update player's inRun status and remaining black money
    Exios.Data.inRuns[xPlayer.source] = true
    itemData = exports.ox_inventory:GetItem(xPlayer.source, 'black_money')
    if not itemData or itemData.count < 500 then 
        Exios.Data.inRuns[xPlayer.source] = false
        TriggerClientEvent('exios-witwas:client:complete', xPlayer.source, false)
    end
end)



RegisterNetEvent('exios-witwas:server:start:cleaning')
AddEventHandler('exios-witwas:server:start:cleaning', function(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    local dist = #(GetEntityCoords(GetPlayerPed(xPlayer.source)) - Shared.StartLocations[index]['coords'])
    if dist > 1.5 then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return
    end

    local itemData = exports.ox_inventory:GetItem(xPlayer.source, 'black_money')
    if not itemData or itemData.count < 10000 then
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if Exios.Data.inRuns[xPlayer.source] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    Exios.Data.inRuns[xPlayer.source] = true
    TriggerClientEvent('exios-witwas:client:started:cleaning', xPlayer.source)
end)

RegisterCommand("stopwitwas", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
    TriggerClientEvent('jtm-developmoney:client:witwas:stop', xPlayer.source, true)
    else
        print("Witwas Niet gestopt")
    end
end, false)