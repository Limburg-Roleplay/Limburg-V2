-- // [VARIABLES] \\ --

local cheatcheck = {}
local cheatlocations = {}
local borg = {}

-- // [ESX EVENTS] \\ --

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(playerId, job)
    if source == 0 or source == '' then
        if cheatcheck[src] then
            cheatcheck[src] = nil
        end
    end
end)

-- // [CALLBACKS] \\ --

ESX.RegisterServerCallback('exios-nonwhitelistedjobs:server:cb:receive:done:locations', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(cheatlocations[xPlayer.identifier])
end)

ESX.RegisterServerCallback('exios-nonwhitelistedjobs:server:create:borg', function(source, cb, plate, engineHealth, vehId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not borg[source] then 
        local bankMoney = xPlayer.getAccount('bank').money
        if (bankMoney + 7500) < Shared.Borg then 
            xPlayer.showNotification('Je kan de borg niet betalen, je mist €' .. bankMoney - Shared.Borg .. '.','error')
            cb(false)
            return 
        end

        borg[source] = {['plate'] = plate}
        xPlayer.removeAccountMoney('bank', Shared.Borg)
        xPlayer.showNotification('Je hebt je borg betaald van €' .. Shared.Borg,'success')
        cb(true)
    else 
        if plate == borg[source]['plate'] then 
            borg[source] = nil

            local engineHealthClient = engineHealth / 10
            if engineHealthClient > 100 then 
                engineHealthClient = 100
            end

            local backBorg = ESX.Math.Round(Shared.Borg / 100 * engineHealthClient)
            local job = xPlayer.job.name

            xPlayer.addAccountMoney('bank', backBorg)
            xPlayer.showNotification('Je hebt je borg terug gekregen van €' .. backBorg,'success')

            if vehId then
                local veh = NetworkGetEntityFromNetworkId(vehId)
                DeleteEntity(veh)
            end
    
            cb(true)
        end
    end
end)

-- // [EVENTS] \\ --

RegisterNetEvent('exios-nonwhitelistedjobs:server:action:inklokken')
AddEventHandler('exios-nonwhitelistedjobs:server:action:inklokken', function(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coords = xPlayer.getCoords(true)
    local dist = #(coords - Shared.Locations[index]['inklok']['coords'])

    if not index then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if dist > 20.0 then 
        TriggerClientEvent('exios-nonwhitelistedjobs:client:action:not:correctly', source)
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if xPlayer.job2.name ~= Shared.Locations[index]['job'] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    cheatcheck[source] = {['job'] = Shared.Locations[index]['job'], ['totalActions'] = 0}
    if not cheatlocations[xPlayer.identifier] then 
        cheatlocations[xPlayer.identifier] = {}
        for i=1, #Shared.Locations[index]['actions'] do
            cheatlocations[xPlayer.identifier][i] = false
        end
    end
    TriggerClientEvent('exios-nonwhitelistedjobs:client:action:startJob', source, index, Shared.Locations[index]['job'])
end)

RegisterNetEvent('exios-nonwhitelistedjobs:server:action:uitklokken')
AddEventHandler('exios-nonwhitelistedjobs:server:action:uitklokken', function(index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coords = xPlayer.getCoords(true)
    local dist = #(coords - Shared.Locations[index]['inklok']['coords'])

    if not index then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if dist > 20.0 then 
        TriggerClientEvent('exios-nonwhitelistedjobs:client:action:not:correctly', source)
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if xPlayer.job2.name ~= Shared.Locations[index]['job'] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if not cheatcheck[source] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if cheatcheck[source]['totalActions'] > 0 then
        xPlayer.showNotification('Je bent uitgeklokt, lever je facturen in om geld te ontvangen.','error')
    else
        xPlayer.showNotification('Je hebt geen werk verricht dus je hebt geen geld ontvangen!','error')
    end

    borg[source] = nil
    cheatcheck[source] = nil
    local countCheck = 0

    for i=1, #cheatlocations[xPlayer.identifier] do 
        if cheatlocations[xPlayer.identifier][i] then 
            countCheck = countCheck + 1
        end
    end

    if countCheck >= #Shared.Locations[index]['actions'] then 
        cheatlocations[xPlayer.identifier] = nil
    end
    countCheck = 0
end)

RegisterNetEvent('exios-nonwhitelistedjobs:server:action:addAction')
AddEventHandler('exios-nonwhitelistedjobs:server:action:addAction', function(index, job, locaNumb, vehId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coords = xPlayer.getCoords(true)
    local locaNumb = tonumber(locaNumb)

    if not cheatcheck[source] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if not locaNumb then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if not Shared.Locations[index]['actions'][locaNumb] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end 

    if cheatlocations[xPlayer.identifier][locaNumb] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if cheatcheck[source]['totalActions'] > #Shared.Locations[index]['actions'] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    local job = cheatcheck[source]['job']
    local dist = #(coords - Shared.Locations[index]['actions'][locaNumb]['coords'])
    if job ~= xPlayer.job2.name then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if job ~= 'vuilnisman' then 
        if dist > 6 then 
            print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
            return 
        end
    else 
        if vehId then 
            local veh = NetworkGetEntityFromNetworkId(vehId)
            local vehLocation = GetEntityCoords(veh)
            local dist2 = #(xPlayer.getCoords(true) - vehLocation)

            if dist > 30 then 
                print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
                return 
            end

            if dist2 > 6 then 
                print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
                return 
            end
        else 
            print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
            return 
        end
    end

    exports['ox_inventory']:AddItem(source, 'factuur', 1)

    cheatcheck[source]['totalActions'] = cheatcheck[source]['totalActions'] + 1
    cheatlocations[xPlayer.identifier][locaNumb] = true

    xPlayer.showNotification('Je hebt een actie voltooid! Ga naar de volgende actie.','success')
end)

RegisterNetEvent('exios-nonwhitelistedjobs:server:action:verkoopfactuur')
AddEventHandler('exios-nonwhitelistedjobs:server:action:verkoopfactuur', function(index, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coords = xPlayer.getCoords(true)
    local dist = #(coords - Shared.Locations[index]['verkoop']['coords'])

    if dist > 20.0 then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if xPlayer.job2.name ~= Shared.Locations[index]['job'] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    if not cheatcheck[source] then 
        print('[^4' .. GetCurrentResourceName() .. '^7] Player-ID ^4' .. source .. '^7 might be ^5cheating^7, please consider ^5safe-banning ^7or ^5spectating')
        return 
    end

    local item = xPlayer.getInventoryItem('factuur')
    if item.count <= 0 then 
        xPlayer.showNotification('Je hebt geen facturen, probeer het opnieuw..','error')
        return 
    end

    local salary = Shared.Locations[index]['salaryPerAction']() * item.count
    xPlayer.removeInventoryItem('factuur', item.count)
    xPlayer.addAccountMoney('bank', salary)
    xPlayer.showNotification('Je hebt facturen verkocht voor €' .. salary .. '!','success')
end)