ESX = exports["es_extended"]:getSharedObject()
local robbedLately = false
RegisterServerEvent("esx_bankrobbery:startRobbery")
AddEventHandler("esx_bankrobbery:startRobbery", function(bankId)
	if robbedLately then
        TriggerClientEvent('frp-notifications:client:notify', source, 'error', 'Er is recentelijk een bank overvallen, kom later terug!', '5000')
		return 
	end
	local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("esx_bankrobbery:openDoor", -1, bankId)
    TriggerClientEvent("esx_bankrobbery:startRobbery", -1, bankId)
	xPlayer.removeInventoryItem('blowpipe', 1)
	TriggerClientEvent("esx_bankrobbery:alertCops", xPlayer.source, bankId)
	robbedLately = true
    TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1193570935949774858/MsVHw-BY_l5d5eBiqeAMnK3JLTMwm9Ew11fjcT1uBhF6QlsqLZo8FAq6eW9Mklu0-Q82', source, {title = GetPlayerName(source) .. " heeft zojuist een juwelier overval gestart: " .. bankId , desc = GetPlayerName(source) .. " heeft zojuist een bank overval gestart: " .. bankId }, 0x000001)
    Citizen.Wait(1800000)
	robbedLately = false
end)

RegisterServerEvent("esx_bankrobbery:endRobbery")
AddEventHandler("esx_bankrobbery:endRobbery", function(bankId)
    TriggerClientEvent("esx_bankrobbery:endRobbery", -1, bankId)
end)

local playerCooldowns = {}

RegisterServerEvent("esx_bankrobbery:grabbedCash")
AddEventHandler("esx_bankrobbery:grabbedCash", function(bankId, oldCash, newCash)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Initialize or update the cooldown counter
    if not playerCooldowns[src] then
        playerCooldowns[src] = {count = 1, timestamp = os.time()}
    else
        local currentTime = os.time()
        local timeDiff = currentTime - playerCooldowns[src].timestamp

        if timeDiff <= 3 then
            playerCooldowns[src].count = playerCooldowns[src].count + 1
        else
            playerCooldowns[src] = {count = 1, timestamp = currentTime}
        end

        if playerCooldowns[src].count > 2 then
            exports["FIVEGUARD"]:screenshotPlayer(source, function(url)
                print("got url of screenshot: " .. url .. " from player: " .. source)
            end)
            return exports["FIVEGUARD"]:fg_BanPlayer(source, "Suspicious activity detected: Player ID " .. source .. " triggered esx_bankrobbery:grabbedCash more than twice within 3 seconds.", true)
        end
    end

    if not IsPlayerNearCashPile(xPlayer, bankId) then
        exports["FIVEGUARD"]:screenshotPlayer(source, function(url)
            print("got url of screenshot: " .. url .. " from player: " .. source)
        end)
        DropPlayer(source, "Goed geprobeerd :)")
        return exports["FIVEGUARD"]:fg_BanPlayer(source, "Suspicious activity detected: Player ID " .. source .. " tried to trigger esx_bankrobbery:grabbedCash without validation.", true)
    end

    xPlayer.addAccountMoney("black_money", newCash)

    TriggerClientEvent('frp-notifications:client:notify', source, 'success', "Je hebt zojuist €" .. newCash .. " zwart geld ontvangen", '5000')
    TriggerClientEvent("esx_bankrobbery:changeCash", -1, bankId, oldCash - newCash)
end)

function IsPlayerNearCashPile(xPlayer, bankId)
    local playerPed = GetPlayerPed(xPlayer.source) -- Get the player's ped
    local playerCoords = GetEntityCoords(playerPed) -- Get the player's current coordinates

    local cashPileCoords = vector3(
        Config.BankHeists[bankId]["Cash_Pile"].x,
        Config.BankHeists[bankId]["Cash_Pile"].y,
        Config.BankHeists[bankId]["Cash_Pile"].z
    ) -- Assuming BankHeists[bankId]["Cash_Pile"] has x, y, z fields

    local distance = #(playerCoords - cashPileCoords) -- Calculate the distance between the player and the cash pile

    return distance <= 20.0 -- Return true if within 20 units, false otherwise
end

ESX.RegisterServerCallback("esx_bankrobbery:fetchCops", function(source, cb, minCops)
    local copsOnDuty = 0

    local Players = ESX.GetPlayers()

    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer["job"]["name"] == "police" then
            copsOnDuty = copsOnDuty + 1
        end
    end

    if copsOnDuty >= minCops then
        cb(true)
    else
        cb(false)
    end
end)
