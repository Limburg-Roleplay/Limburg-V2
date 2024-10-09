ESX = exports["es_extended"]:getSharedObject()
local robberyStarted = false
local robbedLately = false
RegisterNetEvent("esx_juwelleryrobbery:startRobbery")
AddEventHandler(
    "esx_juwelleryrobbery:startRobbery",
    function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        if not IsPlayerNearStartPoint(xPlayer) then
			return exports["FIVEGUARD"]:fg_BanPlayer(src, "Suspicious activity detected: Player [" .. src .. "] ".. GetPlayerName(src) .. " tried to trigger esx_juwelleryrobbery:grabJewels without validation.", true)
    	end
        if robbedLately then
            TriggerClientEvent('frp-notifications:client:notify', source, 'error', 'Er is recentelijk een juwelier overvallen, kom later terug!', '5000')
			return  
        end
        robbedLately = true
        local src = source
        robberyStarted = true
        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1213976284049444925/wcISYwBZFmYzGshfVTn7vgeIQkvZn7NciGxsPtZhXOOk8K93JaDWozwPfneWGJoa9XVv', source, {title = GetPlayerName(source) .. " heeft zojuist een juwelier overval gestart." , desc = GetPlayerName(source) .. " heeft zojuist een juwelier overval gestart." }, 0x000001)
        TriggerClientEvent("esx_juwelleryrobbery:createTargets", source)
        TriggerClientEvent("esx_juwelleryrobbery:startRobberyClient", -1)
        Citizen.Wait(1800000)
		robbedLately = false
    end
)


local playerCooldowns = {}

RegisterServerEvent("esx_juwelleryrobbery:grabJewels")
AddEventHandler("esx_juwelleryrobbery:grabJewels", function(player)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
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
            exports["FIVEGUARD"]:screenshotPlayer(src, function(url)
                print("got url of screenshot: " .. url .. " from player: " .. src)
            end)
            return exports["FIVEGUARD"]:fg_BanPlayer(src, "Suspicious activity detected: Player [" .. src .. "] " .. GetPlayerName(src) .. " triggered esx_juwelleryrobbery:grabJewels more than twice within 3 seconds.", true)
        end
    end

    if not IsPlayerNearStartPoint(xPlayer) then
        return exports["FIVEGUARD"]:fg_BanPlayer(src, "Suspicious activity detected: Player [" .. src .. "] " .. GetPlayerName(src) .. " tried to trigger esx_juwelleryrobbery:grabJewels without validation.", true)
    end

    local jewels = math.random(Config.MinJewels, Config.MaxJewels)
    xPlayer.addInventoryItem("jewels", jewels)
    print(jewels)
end)

RegisterServerEvent("esx_juwelleryrobbery:toofar")
AddEventHandler(
    "esx_juwelleryrobbery:toofar",
    function(robb)
        local source = source
        TriggerClientEvent("esx_juwelleryrobbery:tooFarAway", source)
    end
)

function IsPlayerNearStartPoint(xPlayer)
    local playerPed = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(playerPed)
    local cashPileCoords = Config.MidPoint
    local distance = #(playerCoords - cashPileCoords)
    return distance <= 11.5
end


ESX.RegisterServerCallback("esx_juwelleryrobbery:fetchCops", function(source, cb, minCops)
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