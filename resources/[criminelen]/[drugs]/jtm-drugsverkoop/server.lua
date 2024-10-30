ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

RegisterNetEvent("jtm-development:rewardMeth", function(input)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local inputValue = tonumber(input[1])
    
    if inputValue then
        local minReward = 1700
        local maxReward = 2700
        local money = inputValue * math.random(minReward, maxReward)

        if inputValue > xPlayer.getInventoryItem("methzakje").count then
            TriggerClientEvent('chat:addMessage', src, { args = { '^1Drugsdealer', 'Je hebt niet genoeg zakjes meth op zak!' } })
            return
        end

        local steamName = GetPlayerName(src)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.identifier
        local rockstarLicense = xPlayer.getIdentifier('license')
        local purchaseTime = os.date("%Y-%m-%d %H:%M:%S")
        local bankMoney = xPlayer.getAccount('bank').money
        local cashMoney = xPlayer.getMoney()
        local blackMoney = xPlayer.getAccount('black_money').money

        local logMessage = string.format(
            "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Naam: %s\nSteam ID: %s\nRockstar License: %s\nBank: %s\nCash: %s\nVerkocht: %d methzakjes\nBlack Money Verkregen: %s",
            purchaseTime, steamName, playerName, steamID, rockstarLicense, bankMoney, cashMoney, inputValue, money
        )

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263510885729701980/3Wo7FomBBy9NrpXGvp35zNJdZwZkK_rwOL6xN5wCa-3YWrcI8ovsxagNTu33rOAlyaBO', source, {
            title = "Meth Verkoop Logs",
            desc = logMessage
        })

        if xPlayer.getInventoryItem("methzakje").count > 0 then
           xPlayer.removeInventoryItem("methzakje", inputValue)
           xPlayer.addAccountMoney("black_money", money)
        else
            TriggerClientEvent('chat:addMessage', src, { args = { '^1Drugsdealer', 'Je hebt niet genoeg zakjes meth op zak!' } })
        end
    end
end)

RegisterNetEvent("jtm-development:rewardGhb", function(input)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not input then
        return 
    end
    
    local inputValue = tonumber(input[1])
    
    if inputValue then
        local minReward = 1200
        local maxReward = 2300
        local money = inputValue * math.random(minReward, maxReward)

        if inputValue > xPlayer.getInventoryItem("ghb").count then
            TriggerClientEvent('chat:addMessage', src, { args = { '^1Drugsdealer', 'Je hebt niet genoeg ghb poeder op zak!' } })
            return
        end

        local steamName = GetPlayerName(src)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.identifier
        local rockstarLicense = xPlayer.getIdentifier('license')
        local purchaseTime = os.date("%Y-%m-%d %H:%M:%S")
        local bankMoney = xPlayer.getAccount('bank').money
        local cashMoney = xPlayer.getMoney()
        local blackMoney = xPlayer.getAccount('black_money').money

        local logMessage = string.format(
            "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Naam: %s\nSteam ID: %s\nRockstar License: %s\nBank: %s\nCash: %s\nVerkocht: %d ghb\nBlack Money Verkregen: %s",
            purchaseTime, steamName, playerName, steamID, rockstarLicense, bankMoney, cashMoney, inputValue, money
        )

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263510824392065188/9rzNh2PaaI_RwLXc-pp_riunyFayhm2WSYmoLncRSRyHhKfzSYGAVVvIbXuc3_Q6v_GD', source, {
            title = "GHB Verkoop Logs",
            desc = logMessage
        })

        if xPlayer.getInventoryItem("ghb").count > 0 then
           xPlayer.removeInventoryItem("ghb", inputValue)
           xPlayer.addAccountMoney("black_money", money)
        else
            TriggerClientEvent('chat:addMessage', src, { args = { '^1Drugsdealer', 'Je hebt niet genoeg ghb poeder op zak!' } })
        end
    end
end)


RegisterNetEvent("jtm-development:rewardLSD", function(input)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local inputValue = tonumber(input[1])

    if not input[1] then
        print("^2Player^7 [" .. source .. "] might be cheating. They have unlawfully triggered a event")
    end
    
    if inputValue then
        local minReward = 2200
        local maxReward = 2900
        local money = inputValue * math.random(minReward, maxReward)

        if inputValue > xPlayer.getInventoryItem("lsd").count then
            TriggerClientEvent('chat:addMessage', src, { args = { '^1Drugsdealer', 'Je hebt niet genoeg LSD Tonnen op zak!' } })
            return
        end

        local steamName = GetPlayerName(src)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.identifier
        local rockstarLicense = xPlayer.getIdentifier('license')
        local purchaseTime = os.date("%Y-%m-%d %H:%M:%S")
        local bankMoney = xPlayer.getAccount('bank').money
        local cashMoney = xPlayer.getMoney()
        local blackMoney = xPlayer.getAccount('black_money').money

        local logMessage = string.format(
            "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Naam: %s\nSteam ID: %s\nRockstar License: %s\nBank: %s\nCash: %s\nVerkocht: %d LSD\nBlack Money Verkregen: %s",
            purchaseTime, steamName, playerName, steamID, rockstarLicense, bankMoney, cashMoney, inputValue, money
        )

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1265398048302043328/WMx1lSqlrvrktXLbyhOAixDFtqUHYbrnchn9TsdP0vMpLiG2hOMBuQGaIOa_HlDJjqAn', source, {
            title = "LSD Verkoop Logs",
            desc = logMessage
        })

        if xPlayer.getInventoryItem("lsd").count > 0 then
           xPlayer.removeInventoryItem("lsd", inputValue)
           xPlayer.addAccountMoney("black_money", money)
        else
            TriggerClientEvent('chat:addMessage', src, { args = { '^1Drugsdealer', 'Je hebt niet genoeg LSD Tonnen op zak!' } })
        end
    end
end)