ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local claimed = json.decode(LoadResourceFile("jtm-bonus", "claimed.json")) or {}

RegisterCommand('bonus', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    if not claimed[identifier] then
        claimed[identifier] = true

        xPlayer.addAccountMoney('bank', 300000)

        SaveResourceFile("jtm-bonus", "claimed.json", json.encode(claimed, { indent = true }), -1)

        local steamName = GetPlayerName(source)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.getIdentifier()
        local bankMoney = formatNumber(xPlayer.getAccount('bank').money)
        local cashMoney = formatNumber(xPlayer.getMoney())
        local rockstarLicense = xPlayer.getIdentifier('license')
        local purchaseTime = os.date('%Y-%m-%d %H:%M:%S') 

        local logMessage = string.format(
            "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Naam: %s\nSteam ID: %s\nRockstar License: %s\nBank: %s\nCash: %s",
            purchaseTime, steamName, playerName, steamID, rockstarLicense, bankMoney, cashMoney
        )

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263161806201819197/Ko_z6PtE--82am9jWsmEoEcHqebJuw4C1f8DuG2zNsgWFCifJEPeT66QkJTMqXQDWFXA', source, {
            title = "Bonus Command Logs",
            desc = logMessage
        })

        TriggerClientEvent("frp-notifications:client:notify", source, "success", "Je hebt succesvol je bonus van 300.000 geclaimed!", 5000)
    else
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Je hebt je bonus al geclaimed!", 5000)
    end
end)

function formatNumber(number)
    local formatted = tostring(number)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end
