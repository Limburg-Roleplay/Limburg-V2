ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('sendPlayerJobs')
AddEventHandler('sendPlayerJobs', function()
    local playerJobs = {}

    local players = ESX.GetPlayers()
    for i=1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        playerJobs[players[i]] = xPlayer.job.name
    end

    TriggerClientEvent('updatePlayerJobs', -1, playerJobs)
end)

local webHook = "https://discord.com/api/webhooks/1275375879463108629/vlJEnm1MdjD7S6WQBP5FXHuCEffIY6NTyXsbxM7EhMYgC5wNlNz7YaHuIEicYqJTGpJ5"
local playerStaffNamesStatus = {}

local function GetFormattedGameTime()
    local milliseconds = GetGameTimer()
    local seconds = math.floor(milliseconds / 1000)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    seconds = seconds % 60
    minutes = minutes % 60

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function sendToDiscord(title, message, image, color)
    local headers = {
        ['Content-Type'] = 'application/json'
    }

    local gameTime = GetFormattedGameTime()

    PerformHttpRequest(webHook, function() end, 'POST', json.encode({
        username = 'Staffnames Logger', 
        embeds = {
            {
                title = title,
                color = color,
                footer = {
                    text = "In-game tijd: " .. gameTime,
                },
                description = message,
                thumbnail = {
                    url = image,
                    width = 100,
                }
            }
        }
    }), headers)
end

-- Server-side event listener
RegisterNetEvent('logToDiscord')
AddEventHandler('logToDiscord', function(title, message, image, color)
    sendToDiscord(title, message, image, color)
end)

local function GetPlayerGroup(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        return xPlayer.getGroup()
    else
        return nil
    end
end


local function IsPlayerAllowed(ply)
    local allowedGroups = {
        ["staff"] = true,
        ["hogerop"] = true,
        ["owner"] = true
    }
    local playerGroup = GetPlayerGroup(ply)
    return allowedGroups[playerGroup] == true
end


RegisterCommand("staffnames", function(source, args, rawCommand)
    if source == 0 then
        print("Dit commando kan niet worden gebruikt vanuit de console.")
        return
    end

    if not exports["frp-staffdienst"]:inDienst(source) then
        TriggerClientEvent("chat:addMessage", source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Systeem", "Je moet in staffdienst zijn om dit commando te gebruiken."}
        })
        return
    end

    if IsPlayerAllowed(source) then
        TriggerClientEvent("toggleStaffNames", source)
    else
        TriggerClientEvent("chat:addMessage", source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Systeem", "Je hebt geen toestemming om dit commando te gebruiken."}
        })
    end
end, false)

RegisterNetEvent('playerInService')
AddEventHandler('playerInService', function(playerId)
    if not playerStaffNamesStatus[playerId] and not playerStaffNamesStatus == "[]" then
        playerStaffNamesStatus[playerId] = true
        TriggerClientEvent("toggleStaffNames", playerId, true)
        TriggerEvent('logToDiscord', GetPlayerName(playerId), GetPlayerName(playerId) .. " heeft staffnames ingeschakeld omdat ze in dienst zijn gegaan.", nil, 65280)
    end
end)

RegisterNetEvent('playerOutOfService')
AddEventHandler('playerOutOfService', function(playerId)
    if playerStaffNamesStatus[playerId] then
        playerStaffNamesStatus[playerId] = false
        TriggerClientEvent("toggleStaffNames", playerId, false)
        TriggerEvent('logToDiscord', GetPlayerName(playerId), GetPlayerName(playerId) .. " heeft staffnames uitgeschakeld omdat ze uit dienst zijn gegaan.", nil, 16711680)
    end
end)
