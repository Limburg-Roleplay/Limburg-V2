ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('lrp-wapenwinkel:checkFunds', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    local playerBank = xPlayer.getAccount('bank').money

    if playerMoney >= price or playerBank >= price then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('lrp-wapenwinkel:purchaseWeapon')
AddEventHandler('lrp-wapenwinkel:purchaseWeapon', function(weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local weapon = nil

    for _, item in pairs(Config.Weapons) do
        if item.name == weaponName then
            weapon = item
            break
        end
    end

    if weapon then
        local playerCash = xPlayer.getMoney()
        local playerBank = xPlayer.getAccount('bank').money

        if playerCash >= weapon.price then
            if xPlayer.canCarryItem(weapon.name, weapon.amount) then
                xPlayer.removeMoney(weapon.price)
                xPlayer.addInventoryItem(weapon.name, weapon.amount)
                TriggerClientEvent('lrp-wapenwinkel:purchaseSuccess', source)

                local steamName = GetPlayerName(xPlayer.source)
                local steamID = xPlayer.getIdentifier()
                local playerLicense = xPlayer.getIdentifier('license')
                local purchaseTime = os.date('%Y-%m-%d %H:%M:%S')

                local logMessage = string.format(
                    "Tijd en Datum: %s\nSteam Naam: %s\nSteam ID: %s\nRockstar License: %s\nItem Gekocht: %s",
                    purchaseTime, steamName, steamID, playerLicense, weaponName
                )

                TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1294015929507643433/f48IQvn3P7piGyxkBdCuDowtOAccrZXg0KPsGW5u51s95doUXZaEDXVodLrxSws8ew1L', {
                    title = "Wapenwinkel Logs",
                    desc = logMessage
                })

            else
                TriggerClientEvent('lrp-wapenwinkel:purchaseFailed', source, "Niet genoeg ruimte in inventaris")
            end
        elseif playerBank >= weapon.price then
            if xPlayer.canCarryItem(weapon.name, weapon.amount) then
                xPlayer.removeAccountMoney('bank', weapon.price)
                xPlayer.addInventoryItem(weapon.name, weapon.amount)
                TriggerClientEvent('lrp-wapenwinkel:purchaseSuccess', source)

                local steamName = GetPlayerName(xPlayer.source)
                local steamID = xPlayer.getIdentifier()
                local playerLicense = xPlayer.getIdentifier('license')
                local purchaseTime = os.date('%Y-%m-%d %H:%M:%S')

                local logMessage = string.format(
                    "Tijd en Datum: %s\nSteam Naam: %s\nSteam ID: %s\nRockstar License: %s\nItem Gekocht: %s",
                    purchaseTime, steamName, steamID, playerLicense, weaponName
                )

                TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1294015929507643433/f48IQvn3P7piGyxkBdCuDowtOAccrZXg0KPsGW5u51s95doUXZaEDXVodLrxSws8ew1L', source, {
                    title = "Wapenwinkel Logs",
                    desc = logMessage
                })

            else
                TriggerClientEvent('lrp-wapenwinkel:purchaseFailed', source, "Niet genoeg ruimte in inventaris")
            end
        else
            TriggerClientEvent('lrp-wapenwinkel:purchaseFailed', source, "Niet genoeg geld")
        end
    else
        TriggerClientEvent('lrp-wapenwinkel:purchaseFailed', source, "Wapen niet gevonden")
    end
end)



RegisterServerEvent('lrp-wapenwinkel:grantAccess')
AddEventHandler('lrp-wapenwinkel:grantAccess', function()
    TriggerClientEvent('lrp-wapenwinkel:openUI', source)
end)
