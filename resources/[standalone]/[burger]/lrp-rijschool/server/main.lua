ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('lrp-rijschool:server:has:enough:money', function(source, cb, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cost = 0

    if type == 'theorie' then
        cost = Config.TheorieCost
    elseif type == 'praktijk' then
        cost = Config.PraktijkCost
    end

    if xPlayer.getMoney() >= cost then
        xPlayer.removeMoney(cost)
        cb(true)
    else
        TriggerClientEvent("lrp-notifications:client:notify", source, "error", "Je hebt niet genoeg geld!", "5000")
        cb(false)
    end
end)

ESX.RegisterServerCallback('lrp-rijschool:server:get:licenses', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local licenses = {}

    for _, licenseType in ipairs(Config.Types) do
        if xPlayer.getIdentifier() then
            table.insert(licenses, licenseType)
        end
    end

    cb(licenses)
end)

RegisterServerEvent('lrp-rijschool:server:maded:praktijk:test')
AddEventHandler('lrp-rijschool:server:maded:praktijk:test', function(type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local license = 'rijbewijs' .. type:sub(10)
	print(license)
    AddPlayerLicense(identifier, license, function(success)
        if success then
            TriggerClientEvent('okokNotify:Alert',  xPlayer.source,  'Je hebt je ' .. Config.Language[type] .. '-rijbewijs gehaald!', 5000, 'success')
        else
            TriggerClientEvent('okokNotify:Alert',  xPlayer.source, 'Er is iets fout gegaan bij het toekennen van je rijbewijs.', 5000, 'error')
        end
    end)    
end)

RegisterServerEvent('lrp-rijschool:server:succeed:test')
AddEventHandler('lrp-rijschool:server:succeed:test', function()
    local xPlayer = ESX.GetPlayerFromId(source)
	GrantTheorieLicense(xPlayer.source)
end)

function GrantTheorieLicense(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    AddPlayerLicense(identifier, 'theorie', function(success)
        if success then
            TriggerClientEvent('okokNotify:Alert',  xPlayer.source, 'Je hebt je theoretische licentie ontvangen!', 5000, 'success')
        else
            TriggerClientEvent('okokNotify:Alert',  xPlayer.source, 'Er is een fout opgetreden bij het verkrijgen van je licentie.', 5000, 'error')
        end
    end)
end
function AddPlayerLicense(identifier, licenseType, cb)
    MySQL.Async.execute('INSERT INTO user_licenses (owner, type) VALUES (@owner, @type)', {
        ['@owner'] = identifier,
        ['@type'] = licenseType
    }, function(rowsChanged)
        if cb then
            cb(rowsChanged > 0)
        end
    end)
end
function CheckPlayerLicense(identifier, licenseType, cb)
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM user_licenses WHERE owner = @owner AND type = @type', {
        ['@owner'] = identifier,
        ['@type'] = licenseType
    }, function(count)
        if cb then
            cb(count > 0)
        end
    end)
end
ESX.RegisterServerCallback('lrp-rijschool:server:check:license', function(source, cb, type)
    local xPlayer = ESX.GetPlayerFromId(source)
        
    local identifier = xPlayer.getIdentifier()
    CheckPlayerLicense(identifier, type, function(hasLicense)
        if hasLicense then
            cb(true)
        else
            cb(false)
        end
    end)
end)