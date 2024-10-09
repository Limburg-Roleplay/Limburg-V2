ESX.RegisterServerCallback('exios-drugsfarm:server:cb:get:Shared', function(src, cb)
    cb(Shared)
end)

local playerEventCounts = {}

RegisterNetEvent('exios-drugsfarm:server:pickupObject')
AddEventHandler('exios-drugsfarm:server:pickupObject', function(entity, objectType)
    local source = source -- Ensure source is captured correctly
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not entity or not Shared.Settings[objectType] then
        print("[^1" .. GetCurrentResourceName() .. "^0] ^7Player " .. source .. " is possibly cheating!")
        return
    end

    if not playerEventCounts[source] then
        playerEventCounts[source] = {count = 0, firstTriggerTime = os.time()}
    end

    local currentTime = os.time()
    local eventCount = playerEventCounts[source]

    if currentTime - eventCount.firstTriggerTime > 3 then
        eventCount.count = 0
        eventCount.firstTriggerTime = currentTime
    end

    eventCount.count = eventCount.count + 1

    if eventCount.count > 5 then
        print("[^1ALERT^0] Player " .. source .. " triggered the drugs pickup too frequently!")
        exports["FIVEGUARD"]:screenshotPlayer(source, function(url)
            print("Got URL of screenshot: " .. url .. " from player: " .. source)
        end)
        exports["FIVEGUARD"]:fg_BanPlayer(source, "Suspicious activity detected: Player ID " .. source .. " attempted to trigger drugs pickup too frequently", true)
        return
    end

    local amount = Shared.Settings[objectType]['Items']['Add']['Amount']
    if Shared.Settings[objectType]['Items']['Add']['IsRandomized'] then
        amount = math.random(Shared.Settings[objectType]['Items']['Add']['Amount'][1], Shared.Settings[objectType]['Items']['Add']['Amount'][2])
    end
    local rand = math.random(1, #Shared.Settings[objectType]['Items']['Add']['Item'])

    local canCarry = xPlayer.canCarryItem(Shared.Settings[objectType]['Items']['Add']['Item'][rand], amount)
    if not canCarry then
        -- TriggerClientEvent('esx:showNotification', xPlayer.source, 'Je kan dit niet op je dragen..', 'error', 4000)
        lib.notify(source, {
            title = 'Drugspluk',
            description = 'Je hebt te veel op zak!',
            type = 'error'
        })
        return
    end

    xPlayer.addInventoryItem(Shared.Settings[objectType]['Items']['Add']['Item'][rand], amount)
end)