ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('bishway-blackmarket:checkFunds', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    local playerBank = xPlayer.getAccount('bank').money

    if playerMoney >= price or playerBank >= price then
        cb(true)
    else
        cb(false)
    end
end)


RegisterServerEvent('bishway-blackmarket:purchaseWeapon')
AddEventHandler('bishway-blackmarket:purchaseWeapon', function(weaponName)
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
                TriggerClientEvent('bishway-blackmarket:purchaseSuccess', source)
            else
                TriggerClientEvent('bishway-blackmarket:purchaseFailed', source, "Not enough space in inventory")
            end
        elseif playerBank >= weapon.price then
            if xPlayer.canCarryItem(weapon.name, weapon.amount) then
                xPlayer.removeAccountMoney('bank', weapon.price)
                xPlayer.addInventoryItem(weapon.name, weapon.amount)
                TriggerClientEvent('bishway-blackmarket:purchaseSuccess', source)
            else
                TriggerClientEvent('bishway-blackmarket:purchaseFailed', source, "Not enough space in inventory")
            end
        else
            TriggerClientEvent('bishway-blackmarket:purchaseFailed', source, "Not enough money")
        end
    else
        TriggerClientEvent('bishway-blackmarket:purchaseFailed', source, "Weapon not found")
    end
end)



RegisterServerEvent('bishway-blackmarket:grantAccess')
AddEventHandler('bishway-blackmarket:grantAccess', function()
    TriggerClientEvent('bishway-blackmarket:openUI', source)
end)

RegisterServerEvent('bishiesquishy:stopcheatin:dude')
AddEventHandler('bishiesquishy:stopcheatin:dude', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Add your anti-cheat handling here (e.g., logging, kicking)
    print(('Player %s tried to access the blackmarket without permissions'):format(xPlayer.getIdentifier()))
end)
