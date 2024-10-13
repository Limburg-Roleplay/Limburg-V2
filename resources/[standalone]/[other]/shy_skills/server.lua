-- Utility Functions
local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function logError(message)
    --print("[ERROR] " .. message)
end

local function logInfo(message)
    --print("[INFO] " .. message)
end

-- Database Functions
local function getPlayerSteamId(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "steam:") then
            return identifier
        end
    end
    return nil
end

local function initializePlayerSkills(identifier)
    logInfo("Initializing player skills for identifier: " .. identifier)
    MySQL.Async.fetchAll('SELECT * FROM user_skills WHERE Identifier = @identifier', {
        ['@identifier'] = identifier,
    }, function(result)
        if not result or not result[1] then
            logInfo("No existing skills found, creating new entry for identifier: " .. identifier)
            MySQL.Async.execute('INSERT IGNORE INTO user_skills (Identifier, lichaamskracht, conditie, schieten, autorijden, vliegen, drugs) VALUES (@identifier, 0, 0, 0, 0, 0, 0)', {
                ['@identifier'] = identifier,
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    logInfo('New player skills initialized for identifier: ' .. identifier)
                else
                    logError('Failed to initialize new player skills for identifier: ' .. identifier)
                end
            end)
        else
            logInfo('Player skills already initialized for identifier: ' .. identifier)
        end
    end)
end

local function getPlayerSkills(identifier, callback)
    logInfo("Fetching skills for identifier: " .. identifier)
    MySQL.Async.fetchAll('SELECT * FROM user_skills WHERE Identifier = @identifier', {
        ['@identifier'] = identifier,
    }, function(result)
        if result and result[1] then
            callback({
                strength = result[1].lichaamskracht,
                stamina = result[1].conditie,
                shooting = result[1].schieten,
                driving = result[1].autorijden,
                flying = result[1].vliegen,
                drugs = result[1].drugs
            })
        else
            callback(nil)
        end
    end)
end

local function savePlayerSkills(identifier, skills)
    logInfo("Saving skills for identifier: " .. identifier)
    MySQL.Async.execute('REPLACE INTO user_skills (Identifier, lichaamskracht, conditie, schieten, autorijden, vliegen, drugs) VALUES (@identifier, @strength, @stamina, @shooting, @driving, @flying, @drugs)', {
        ['@identifier'] = identifier,
        ['@strength'] = skills.strength,
        ['@stamina'] = skills.stamina,
        ['@shooting'] = skills.shooting,
        ['@driving'] = skills.driving,
        ['@flying'] = skills.flying,
        ['@drugs'] = skills.drugs
    }, function(affectedRows)
        if affectedRows == 0 then
            logError("Failed to save player skills for identifier: " .. identifier)
        else
            logInfo("Player skills saved for identifier: " .. identifier)
            TriggerEvent('shySkills:requestPlayerSkillsSV')
        end
    end)
end

-- Event Handlers
RegisterNetEvent('shySkills:playerLoaded')
AddEventHandler('shySkills:playerLoaded', function()
    local src = source
    local identifier = getPlayerSteamId(src)
    if identifier then
        logInfo("Player loaded with Steam ID: " .. identifier)
        initializePlayerSkills(identifier)
    else
        logError("Player loaded without a valid Steam ID")
    end
end)

RegisterNetEvent('shySkills:requestPlayerSkillsSV')
AddEventHandler('shySkills:requestPlayerSkillsSV', function()
    local src = source
    local identifier = getPlayerSteamId(src)
    logInfo("Requesting player skills for:", src, identifier) -- Log the request details

    if identifier then
        getPlayerSkills(identifier, function(skills)
            if skills then
                logInfo("Sending player skills:", json.encode(skills)) -- Log the skills being sent
                TriggerClientEvent('shySkills:sendPlayerSkills', src, skills)
            else
                local defaultSkills = {
                    strength = 0,
                    stamina = 0,
                    shooting = 0,
                    driving = 0,
                    flying = 0,
                    drugs = 0
                }
                savePlayerSkills(identifier, defaultSkills)
                print("Sending default skills:", json.encode(defaultSkills)) -- Log the default skills being sent
                TriggerClientEvent('shySkills:sendPlayerSkills', src, defaultSkills)
            end
        end)
    else
        logError("Player requested skills without a valid Steam ID")
    end
end)

local function incrementSkill(identifier, skill, increment, src)
    getPlayerSkills(identifier, function(skills)
        if skills then
            skills[skill] = round(skills[skill] + increment, 2)
            if skills[skill] > 100 then
                skills[skill] = 100
            end
            savePlayerSkills(identifier, skills)
            TriggerClientEvent('shySkills:sendPlayerSkills', src, skills)
            logInfo(string.format("Incremented %s by %s for identifier: %s", skill, increment, identifier))
        else
            logError("Could not retrieve player skills for identifier: " .. identifier)
        end
    end)
end

RegisterNetEvent('shySkills:addDriving')
AddEventHandler('shySkills:addDriving', function()
    local src = source
    local identifier = getPlayerSteamId(src)
    if identifier then
        incrementSkill(identifier, "driving", 0.1, src)
    else
        logError("addDriving called without a valid Steam ID")
    end
end)

RegisterNetEvent('shySkills:addFlying')
AddEventHandler('shySkills:addFlying', function()
    local src = source
    local identifier = getPlayerSteamId(src)
    if identifier then
        incrementSkill(identifier, "flying", 3.00, src)
    else
        logError("addFlying called without a valid Steam ID")
    end
end)

RegisterNetEvent('shySkills:addShooting')
AddEventHandler('shySkills:addShooting', function()
    local src = source
    local identifier = getPlayerSteamId(src)
    if identifier then
        incrementSkill(identifier, "shooting", 3.00, src)
    else
        logError("addShooting called without a valid Steam ID")
    end
end)

RegisterNetEvent('shySkills:addSrength')
AddEventHandler('shySkills:addStrength', function()
    local src = source
    local identifier = getPlayerSteamId(src)
    if identifier then
        local randomIncrement = math.random(1, 3) -- Genereer een willekeurig getal tussen 1 en 3
        incrementSkill(identifier, "strength", randomIncrement, src)
    else
        logError("addStrength called without a valid Steam ID")
    end
end)

RegisterNetEvent('shySkills:addStamina')
AddEventHandler('shySkills:addStamina', function()
    local src = source
    local identifier = getPlayerSteamId(src)
    if identifier then
        local randomIncrement = math.random(1, 3) -- Genereer een willekeurig getal tussen 1 en 3
        incrementSkill(identifier, "stamina", randomIncrement, src)
    else
        logError("addStamina called without a valid Steam ID")
    end
end)


AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local src = source
    local identifier = getPlayerSteamId(src)
    if identifier then
        logInfo("Player connecting with Steam ID: " .. identifier)
        initializePlayerSkills(identifier)
    else
        logError("Player connecting without a valid Steam ID")
    end
end)