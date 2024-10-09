ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('jtm-weaponshop:GetUserData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb({money = xPlayer.getAccount('money').money, bank = xPlayer.getAccount('bank').money})
end)

ESX.RegisterServerCallback('jtm-weaponshop:buyweapon', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 1000
    data.item = '' .. data.item
    local item = 'suppressor'
    local amount = 1

    -- Determine the price and item details based on the item type
    if data.item_type == 'weapon' then
        for k, v in ipairs(config.weapons) do
            if data.item == v.weapon then
                price = v.price
                item = v.name
            end
        end
    elseif data.item_type == 'attachment' then
        for k, v in ipairs(config.attachments) do
            if data.item == v.attachment then
                price = v.price
                item = v.name
            end
        end
    elseif data.item_type == 'bullet' then
        for k, v in ipairs(config.bullets) do
            if data.item == v.bullet then
                price = v.price
                item = v.name
                amount = v.amount
            end
        end
    elseif data.item_type == 'overig' then
        for k, v in ipairs(config.overig) do
            if data.item == v.overig then
                price = v.price
                item = v.name
            end
        end
    end

    -- Function to format numbers with dots as thousand separators
    local function formatNumber(amount)
        local formatted = amount
        while true do  
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
            if (k==0) then
                break
            end
        end
        return formatted
    end

    -- Gather additional details for logging
    local steamName = GetPlayerName(source)
    local playerName = xPlayer.getName()
    local steamID = xPlayer.getIdentifier()
    local bankMoney = formatNumber(xPlayer.getAccount('bank').money)
    local cashMoney = formatNumber(xPlayer.getMoney())
    local purchaseTime = os.date('%Y-%m-%d %H:%M:%S')  -- Format: YYYY-MM-DD HH:MM:SS

    -- Prepare the log message
    local logMessage = string.format(
        "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Name: %s\nSteam ID: %s\nBank: %s\nCash: %s\nItem Gekocht: %s",
        purchaseTime, steamName, playerName, steamID, bankMoney, cashMoney, item
    )

    -- Send log to the logging endpoint
    TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263159302835667076/idYjv3MVEPEISonGW1mkAP5XJWJHcso0w9n3g6aPS3QH45kLUTuNtF1I_Hh50ESrjYR-', source, {
        title = "Wapenwinkel Logs",
        desc = logMessage
    })

    -- Check if the player has enough money and inventory space
    if xPlayer.getAccount('' .. data.type).money >= price then
        if xPlayer.canCarryItem(data.item, amount) then
            xPlayer.removeAccountMoney(data.type, price)
            xPlayer.addInventoryItem(data.item, amount)
            TriggerClientEvent('frp-notifications:client:notify', source, 'success', locale['bought'] .. string.lower(item) .. '.', 5000)
        else
            TriggerClientEvent('frp-notifications:client:notify', source, 'error', locale['inventoryspace'] .. '.', 5000)
        end
    else
        TriggerClientEvent('frp-notifications:client:notify', source, 'error', locale['geldteweinig'] .. '.', 5000)
    end
end)



