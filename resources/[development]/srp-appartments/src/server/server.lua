-- // [VARIABLES] \\ --

local srp = { Functions = {} }
local purchaseTimers = {}

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('srp-appartments:server:cb:get:shared', function(source, cb)
    cb(Shared)
end)

ESX.RegisterServerCallback('srp-appartments:server:cb:receive:cooldownData', function(source, cb, appartmentName)
    if purchaseTimers[ESX.GetPlayerFromId(source).identifier] then 
        local mathes = (purchaseTimers[ESX.GetPlayerFromId(source).identifier][appartmentName] - os.time())
        if mathes >= 1 then
            cb(false, mathes)
        else 
            cb(true)
        end
    else 
        cb(true) 
    end
end)

ESX.RegisterServerCallback('srp-appartments:server:cb:receive:appartment:info', function(source, cb, indexId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false, nil) end

    if not Shared.Appartments[indexId] then cb(false, nil) end

    local isFound, isRent = srp.Functions.CheckOwner(xPlayer.identifier, indexId)

    cb(isFound, isRent)
end)

ESX.RegisterServerCallback('srp-appartments:server:cb:receive:allAppartments', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local checkAppartmentInfo = MySQL.query.await('SELECT * FROM `appartments` WHERE `owner` = ?', {
        xPlayer.identifier
    })
    cb(checkAppartmentInfo)
end)
ESX.RegisterServerCallback('srp-appartments:server:open:stash', function(source, cb, indexId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false, nil) end

    if not Shared.Appartments[indexId] then cb(false, nil) end

    local isFound, isRent = srp.Functions.CheckOwner(xPlayer.identifier, indexId)
    if not isFound then cb(false, nil) end
print(indexId)
    local stashName = xPlayer.identifier .. ':' .. indexId

    exports.ox_inventory:RegisterStash(stashName, 'Appartement', Shared.Appartments[indexId]['appartmentStash']['stashSlots'], Shared.Appartments[indexId]['appartmentStash']['stashWeight'] * 1000, xPlayer.identifier)
    cb(true, stashName)
end)

ESX.RegisterServerCallback('srp-appartments:server:receive:clothing', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false) return end

    local result = MySQL.query.await('SELECT * FROM `outfits` WHERE `owner` = ?', {
        xPlayer.identifier
    })

    local outfits = {}
    for i=1, #result do 
        outfits[#outfits + 1] = {
            outfitName = result[i].outfitName,
            outfitModel = result[i].outfitModel,
            outfitProps = json.decode(result[i].outfitProps),
            outfitComponents = json.decode(result[i].outfitComponents)
        }
    end
    cb(outfits)
end)

-- // [EVENTS] \\ --

RegisterNetEvent('srp-appartments:server:enter:appartment')
AddEventHandler('srp-appartments:server:enter:appartment', function()
    SetPlayerRoutingBucket(source, math.random(230, 630))
end)

RegisterNetEvent('srp-appartments:server:leave:appartment')
AddEventHandler('srp-appartments:server:leave:appartment', function()
    SetPlayerRoutingBucket(source, 0)
end)

RegisterNetEvent('srp-appartments:server:suspend:appartment')
AddEventHandler('srp-appartments:server:suspend:appartment', function(indexId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local isFound, isRent = srp.Functions.CheckOwner(xPlayer.identifier, indexId)
    if not isFound and isRent then return end

    local removeAppartmentInfo = MySQL.query.await('DELETE FROM `appartments` WHERE `owner` = ? AND `appartment` = ?', {
        xPlayer.identifier, indexId
    })

    TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'success', description = 'Je hebt de huur van je appartement opgezegd!', position = 'top' })
    TriggerClientEvent('srp-appartments:client:update:data', xPlayer.source)
    TriggerEvent('srp-logging:server:log', xPlayer.source, 'appartments', 'red', '*Speler heeft zijn huur van zijn appartement opgezegd.*\n\n**Appartementnaam:** ' .. indexId)
end)

RegisterNetEvent('srp-appartments:server:sell:appartment')
AddEventHandler('srp-appartments:server:sell:appartment', function(indexId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local isFound, isRent = srp.Functions.CheckOwner(xPlayer.identifier, indexId)
    if not isFound and not isRent then return end

    local removeAppartmentInfo = MySQL.query.await('DELETE FROM `appartments` WHERE `owner` = ? AND `appartment` = ?', {
        xPlayer.identifier, indexId
    })

    xPlayer.addAccountMoney('bank', Shared.Appartments[indexId]['appartmentPrices']['buyPrice'] * 0.60, 'Speler heeft zijn appartement verkocht.')

    TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'success', description = 'Je hebt je appartement verkocht!', position = 'top' })
    TriggerClientEvent('srp-appartments:client:update:data', xPlayer.source)

    TriggerEvent('srp-logging:server:log', xPlayer.source, 'appartments', 'red', '*Speler heeft zijn appartement verkocht.*\n\n**Appartementnaam:** ' .. indexId .. '\n**Terug gekregen geld:** ' .. Shared.Appartments[indexId]['appartmentPrices']['buyPrice'] * 0.60)
end)

RegisterNetEvent('srp-appartments:server:buy:appartment')
AddEventHandler('srp-appartments:server:buy:appartment', function(indexId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local isFound, isRent = srp.Functions.CheckOwner(xPlayer.identifier, indexId)
    if isFound then TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', description = 'Je hebt dit appartement al in bezit??', position = 'top' }) return end

    local accountMoney = xPlayer.getAccount('bank').money
    if accountMoney < Shared.Appartments[indexId]['appartmentPrices']['buyPrice'] then 
        TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', description = 'Je hebt hier niet genoeg geld voor!', position = 'top' })
        return 
    end

    xPlayer.removeAccountMoney('bank', Shared.Appartments[indexId]['appartmentPrices']['buyPrice'], 'Speler heeft een appartement gekocht.')

    local insertAppartmentInfo = MySQL.query.await('INSERT INTO `appartments` (owner, appartment, rent) VALUES (?, ?, ?)', {
        xPlayer.identifier, indexId, false
    })

    if not purchaseTimers[xPlayer.identifier] then 
        purchaseTimers[xPlayer.identifier] = {}
    end

    purchaseTimers[xPlayer.identifier][indexId] = (os.time() + 1800)


    TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'success', description = 'Gefeliciteerd met je nieuwe appartement!', position = 'top' })
    TriggerClientEvent('srp-appartments:client:update:data', xPlayer.source)

    TriggerEvent('srp-logging:server:log', xPlayer.source, 'appartments', 'green', '*Speler heeft een nieuw appartement gekocht.*\n\n**Appartementnaam:** ' .. indexId .. '\n**Appartementprijs:** ' .. Shared.Appartments[indexId]['appartmentPrices']['buyPrice'])
end)

RegisterNetEvent('srp-appartments:server:rent:appartment')
AddEventHandler('srp-appartments:server:rent:appartment', function(indexId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local isFound, isRent = srp.Functions.CheckOwner(xPlayer.identifier, indexId)
    if isFound then TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', description = 'Je hebt dit appartement al in bezit??', position = 'top' }) return end

    local accountMoney = xPlayer.getAccount('bank').money
    if accountMoney < Shared.Appartments[indexId]['appartmentPrices']['rentPrice'] then 
        TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', description = 'Je hebt hier niet genoeg geld voor!', position = 'top' })
        return 
    end

    xPlayer.removeAccountMoney('bank', Shared.Appartments[indexId]['appartmentPrices']['rentPrice'], 'Speler heeft een appartement gehuurd.')

    local insertAppartmentInfo = MySQL.query.await('INSERT INTO `appartments` (owner, appartment, rent) VALUES (?, ?, ?)', {
        xPlayer.identifier, indexId, true
    })

    if not purchaseTimers[xPlayer.identifier] then 
        purchaseTimers[xPlayer.identifier] = {}
    end

    purchaseTimers[xPlayer.identifier][indexId] = (os.time() + 1800)

    TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'success', description = 'Gefeliciteerd met je nieuwe appartement!', position = 'top' })
    TriggerClientEvent('srp-appartments:client:update:data', xPlayer.source)
    TriggerEvent('srp-logging:server:log', xPlayer.source, 'appartments', 'green', '*Speler heeft een nieuw appartement gehuurd.*\n\n**Appartementnaam:** ' .. indexId .. '\n**Appartementprijs:** ' .. Shared.Appartments[indexId]['appartmentPrices']['rentPrice'])
end)

RegisterNetEvent('srp-appartments:server:saveOutfit')
AddEventHandler('srp-appartments:server:saveOutfit', function(name, model, components, props)
    if not name or not model or not components or not props then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    local id = srp.Functions.InsertOutfit(xPlayer.identifier, name, model, json.encode(components), json.encode(props))
    if not id then return end

    TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'success', description = 'Je hebt een nieuwe outfit met de naam: ' .. name .. ' opgeslagen in je kledingkast!', position = 'top' })
end)

RegisterNetEvent('srp-appartments:server:changeOutfitName')
AddEventHandler('srp-appartments:server:changeOutfitName', function(oldName, newName)
    if not oldName or not newName then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    local affectedRows = MySQL.update.await('UPDATE `outfits` SET outfitName = ? WHERE outfitName = ? AND owner = ?', {
        newName, oldName, xPlayer.identifier
    })
    if not affectedRows then TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', description = 'Er is wat fout gegaan, probeer het opnieuw!', position = 'top' }) return end

    TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'success', description = 'Je hebt de naam van ' .. oldName .. ' aangepast naar ' .. newName .. '!', position = 'top' })
end)

RegisterNetEvent('srp-appartments:server:removeOutfit')
AddEventHandler('srp-appartments:server:removeOutfit', function(outfitName)
    if not outfitName then return end

    local xPlayer = ESX.GetPlayerFromId(source)
    local response = MySQL.query.await('DELETE FROM `outfits` WHERE `owner` = ? AND `outfitName` = ?', {
        xPlayer.identifier, outfitName
    })

    if not response then TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', description = 'Er is wat fout gegaan, probeer het opnieuw!', position = 'top' }) return end

    TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'success', description = 'Je hebt de outfit ' .. outfitName .. ' verwijderd uit je kledingkast!', position = 'top' })
end)

-- // [FUNCTIONS] \\ --

srp.Functions.InsertOutfit = function(identifier, name, model, components, props)
    return MySQL.insert.await('INSERT INTO `outfits` (owner, outfitName, outfitModel, outfitComponents, outfitProps) VALUES (?, ?, ?, ?, ?)', {
        identifier, name, model, components, props
    })
end

srp.Functions.CheckOwner = function(identifier, indexId)
    local isFound = false
    local isRent = nil
    
    local checkAppartmentInfo = MySQL.query.await('SELECT * FROM `appartments` WHERE `owner` = ? AND `appartment` = ?', {
        identifier, indexId
    })

    for i=1, #checkAppartmentInfo do 
        if checkAppartmentInfo[i]['appartment'] == indexId then 
            if checkAppartmentInfo[i]['owner'] == identifier then 
                isFound = true

                if tonumber(checkAppartmentInfo[i]['rent']) ~= 1 then 
                    isRent = false 
                else 
                    isRent = true 
                end
            end
        end
    end

    return isFound, isRent
end

srp.Functions.PayRent = function(d, h, m)
    MySQL.Async.fetchAll('SELECT `owner`, `appartment` FROM `appartments` WHERE `rent` = 1', {}, function(result)
        for i=1, #result do 
            local xPlayer = ESX.GetPlayerFromIdentifier(result[i]['owner'])

            if xPlayer then 
                if xPlayer.getAccount('bank').money >= Shared.Appartments[result[i]['appartment']]['appartmentPrices']['rentPrice'] then 
                    xPlayer.removeAccountMoney('bank', Shared.Appartments[result[i]['appartment']]['appartmentPrices']['rentPrice'], 'Speler heeft huur van zijn appartement betaald.')
                    xPlayer.showNotification('success', 'Je hebt €' .. Shared.Appartments[result[i]['appartment']]['appartmentPrices']['rentPrice'] .. ' huur betaald voor je appartement.')
                else 
                    xPlayer.showNotification('error', 'Je hebt niet genoeg geld voor de kosten van je appartement, dus de huur is opgezegd.')
                    MySQL.Sync.execute('DELETE FROM `appartments` WHERE `owner` = ? AND `appartment` = ?', { result[i]['owner'], result[i]['appartment'] })
                end

                TriggerClientEvent('srp-appartments:client:update:data', xPlayer.source)
            else
                local extraResult = MySQL.prepare.await('SELECT `accounts` FROM `users` WHERE `identifier` = ?', { result[i].owner })
                if newResult and newResult.accounts then 
                    local oldAccounts = json.decode(newResult.accounts)
                    if tonumber(oldAccounts.bank) >= Shared.Appartments[result[i]['appartment']]['appartmentPrices']['rentPrice'] then 
                        oldAccounts.bank = (tonumber(oldAccounts.bank) - Shared.Appartments[result[i]['appartment']]['appartmentPrices']['rentPrice'])
                        local newAccounts = json.encode(oldAccounts)
                        MySQL.Sync.execute('UPDATE users SET accounts = ? WHERE identifier = ? LIMIT 1', { newAccounts, result[i].identifier})
                    else 
                        MySQL.Sync.execute('DELETE FROM `appartments` WHERE `owner` = ? AND `appartment` = ?', { result[i]['owner'], result[i]['appartment'] })
                    end
                end
            end
        end
    end)
end
TriggerEvent('cron:runAt', 18, 03, srp.Functions.PayRent)