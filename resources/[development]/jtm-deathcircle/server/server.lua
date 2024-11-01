local deathZones = {}

-- Helper function to get the Discord identifier
local function getDiscordIdentifier(playerId)
    for _, identifier in ipairs(GetPlayerIdentifiers(playerId)) do
        if identifier:find("discord:") then
            return identifier
        end
    end
    return nil
end

RegisterNetEvent('deathCircle:create')
AddEventHandler('deathCircle:create', function(coords, playerId)
    -- print('test')
    local discordId = getDiscordIdentifier(playerId)
    
    if discordId then
        -- print('a discord id found')
        deathZones[discordId] = {
            position = coords,
            radius = Config.CircleRadius,
            warningTimer = Config.WarningTimer,
            blipDuration = GetGameTimer() + Config.CircleTime * 1000
        }
        TriggerClientEvent('deathCircle:createZone', playerId, coords)
    else
        -- print('no discord id found')
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId)
    local discordId = getDiscordIdentifier(playerId)

    if discordId and deathZones[discordId] then
        -- print('found2 death circle for discrod: ' .. discordId)

        local deathZone = deathZones[discordId]
        print(GetGameTimer(), deathZone.blipDuration)
        if GetGameTimer() < deathZone.blipDuration then
            -- print('found death circle for discrod: ' .. discordId)
            TriggerClientEvent('deathCircle:createZone', playerId, deathZone.position)
        else
            deathZones[discordId] = nil
        end
    end
end)

RegisterNetEvent('deathCircle:remove')
AddEventHandler('deathCircle:remove', function(id)
    local playerId = id
    local discordId = getDiscordIdentifier(playerId)
    
    deathZones[discordId] = nil
    -- print('removed death circle for discrod: ' .. discordId)
end)

-- RegisterCommand("fetchdeathzones", function() 
--     print(json.encode(deathZones))
-- end, restricted)