ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ################################
-- FUNCTIONS
-- ################################
local function debugLog(message)
    --print("[DEBUG] " .. message)
end

local function sendLog(title, desc, color)
    TriggerEvent("td_logs:sendLogNoFields", "https://discord.com/api/webhooks/1263625753161891882/P5mNJ-9fqVtWworJyA7TaFx-tq-BwBzAqclxVTyXAV28U1gjLEaVZijObAdsFuIV9V3l", {
        title = title,
        desc = desc
    }, color)
end

local function loadTasks(callback)
    MySQL.query('SELECT * FROM player_tasks', {}, function(result)
        local tasks = {}
        for _, row in ipairs(result) do
            tasks[row.player_identifier] = {
                tasksLeft = row.tasks_left,
                reason = row.reason,
                staffName = row.staff_name
            }
        end
        callback(tasks)
    end)
end

local function saveTask(playerIdentifier, tasksLeft, reason, staffName)
    MySQL.update('REPLACE INTO player_tasks (player_identifier, tasks_left, reason, staff_name) VALUES (?, ?, ?, ?)', {
        playerIdentifier, tasksLeft, reason, staffName
    }, function(affectedRows)
        debugLog("SaveTask - Affected rows: " .. affectedRows)
    end)
end

local function removeTask(playerIdentifier)
    MySQL.update('DELETE FROM player_tasks WHERE player_identifier = ?', {playerIdentifier}, function(affectedRows)
        debugLog("RemoveTask - Affected rows: " .. affectedRows)
    end)
end

local playerTasks = {}
loadTasks(function(tasks)
    playerTasks = tasks
    debugLog("Tasks loaded at server start.")
end)

-- ################################
-- EVENTS
-- ################################
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    Citizen.Wait(100)
    local identifiers = GetPlayerIdentifiers(playerId)
    local playerIdentifier = identifiers[1]
    
    debugLog("ESX player loaded: " .. playerIdentifier)

    MySQL.query('SELECT * FROM player_tasks WHERE player_identifier = ?', {playerIdentifier}, function(result)
        if #result > 0 then
            local taskInfo = result[1]
            playerTasks[playerIdentifier] = {
                tasksLeft = taskInfo.tasks_left,
                reason = taskInfo.reason,
                staffName = taskInfo.staff_name
            }
            TriggerClientEvent('communityService:assignTasks', playerId, taskInfo.tasks_left, taskInfo.reason, taskInfo.staff_name)
            debugLog("Tasks assigned to player on ESX load: " .. playerIdentifier)
        else
            debugLog("No tasks found for player on ESX load: " .. playerIdentifier)
        end
    end)
end)

RegisterNetEvent('communityService:updateTasks')
AddEventHandler('communityService:updateTasks', function(tasksLeft)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local playerIdentifier = identifiers[1]

    if playerTasks[playerIdentifier] then
        playerTasks[playerIdentifier].tasksLeft = tasksLeft
        saveTask(playerIdentifier, tasksLeft, playerTasks[playerIdentifier].reason, playerTasks[playerIdentifier].staffName)
    else
        debugLog("No task found for player: " .. playerIdentifier)
    end
end)

RegisterNetEvent('communityService:completeService')
AddEventHandler('communityService:completeService', function()
    local source = source
    local playerName = GetPlayerName(source)

    local identifiers = GetPlayerIdentifiers(source)
    local playerIdentifier = identifiers[1]
    playerTasks[playerIdentifier] = nil
    removeTask(playerIdentifier)

    local targetCoords = vector3(-11.9888, -1084.8748, 26.6860)
    local targetHeading = 156.7972
    SetEntityCoords(GetPlayerPed(source), targetCoords.x, targetCoords.y, targetCoords.z)
    SetEntityHeading(GetPlayerPed(source), targetHeading)

    local logEntry = {
        title = "Service Complete",
        desc = "Player: " .. playerName .. "\nMessage: Player has completed their community service",
    }

    print("Verzend logboekvermelding:", logEntry)

    sendLog("Taakstraf afgerond", "Player: " .. playerName .. "\nMessage: Speler is klaar met zijn taakstraf", 0x00ff00)
end)

RegisterNetEvent('communityService:checkTasks')
AddEventHandler('communityService:checkTasks', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local steamIdentifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT tasks_left, reason, staff_name FROM player_tasks WHERE player_identifier = @identifier', {
        ['@identifier'] = steamIdentifier
    }, function(result)
        if result and #result > 0 then
            local tasksLeft = result[1].tasks_left
            local reason = result[1].reason
            local staffName = result[1].staff_name

            TriggerClientEvent('communityService:assignTasks', _source, tasksLeft, reason, staffName)
        end
    end)
end)

-- ################################
-- COMMANDS
-- ################################
RegisterCommand('taakstraf', function(source, args)
    local staffName = (source == 0) and "Console" or GetPlayerName(source)
    local xPlayer = (source ~= 0) and ESX.GetPlayerFromId(source)

    if xPlayer and not (xPlayer.getGroup() == 'staff' or xPlayer.getGroup() == 'owner' or xPlayer.getGroup() == 'hogerop') then
        return TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Je hebt geen toestemming om dit commando te gebruiken."}
        })
    end

    if #args < 3 then
        local usageMsg = "Gebruik: /taakstraf [playerId] [tasks] [reason]"
        return (source == 0) and print(usageMsg) or TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            multiline = true,
            args = {"System", usageMsg}
        })
    end

    local target = tonumber(args[1])
    local tasks = tonumber(args[2])
    local reason = table.concat(args, " ", 3)

    if not target or not tasks or not reason then
        local errorMsg = "Fout: Ongeldige argumenten. Gebruik: /taakstraf [playerId] [tasks] [reason]"
        return (source == 0) and print(errorMsg) or TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 0},
            multiline = true,
            args = {"System", errorMsg}
        })
    end

    local player = GetPlayerName(target)
    if player then
        TriggerClientEvent('communityService:assignTasks', target, tasks, reason, staffName)
        
        local successMsg = player .. " heeft " .. tasks .. " taken gekregen voor " .. reason
        if source == 0 then
            print(successMsg)
        else
            TriggerClientEvent('chat:addMessage', -1, {
                color = {0, 255, 0},
                multiline = true,
                args = {"System", successMsg}
            })
        end
        
        local xTarget = ESX.GetPlayerFromId(target)
        local playerIdentifier = xTarget.identifier
        playerTasks[playerIdentifier] = {
            tasksLeft = tasks,
            reason = reason,
            staffName = staffName
        }
        saveTask(playerIdentifier, tasks, reason, staffName)

        sendLog("Taken gegeven", "Staff: " .. staffName .. "\nPlayer: " .. player .. "\nHoeveelheid Taken: " .. tasks .. "\nReden: " .. reason, 0x00ff00)
    else
        local notFoundMsg = "Fout: Speler ID " .. target .. " niet gevonden."
        return (source == 0) and print(notFoundMsg) or TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", notFoundMsg}
        })
    end
end, false)


RegisterCommand('offlinetaakstraf', function(source, args)
    local staffName = (source == 0) and "Console" or GetPlayerName(source)
    local xPlayer = (source ~= 0) and ESX.GetPlayerFromId(source)

    if xPlayer and not (xPlayer.getGroup() == 'owner' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin') then
        return TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Je hebt geen toestemming om deze opdracht uit te voeren."}
        })
    end

    if #args < 3 then
        local errorMsg = "Fout: Ongeldige argumenten. Gebruik: /offlinetaakstraf [identifier] [tasks] [reason]"
        return (source == 0) and print(errorMsg) or TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", errorMsg}
        })
    end

    local identifier = args[1]
    local tasks = tonumber(args[2])
    local reason = table.concat(args, " ", 3)

    if not tasks or tasks <= 0 then
        local invalidTasksMsg = "Fout: Ongeldig aantal taken."
        return (source == 0) and print(invalidTasksMsg) or TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", invalidTasksMsg}
        })
    end

    playerTasks[identifier] = {
        tasksLeft = tasks,
        reason = reason,
        staffName = staffName
    }
    saveTask(identifier, tasks, reason, staffName)

    local successMsg = "Iemand heeft " .. tasks .. " offline taken gekregen voor " .. reason
    if source == 0 then
        print(successMsg)
    else
        TriggerClientEvent('chat:addMessage', -1, {
            color = {0, 255, 0},
            multiline = true,
            args = {"System", successMsg}
        })
    end

    sendLog("Offline Taken gegeven", "Staff: " .. staffName .. "\nIdentifier: " .. identifier .. "\nHoeveelheid Taken: " .. tasks .. "\nReden: " .. reason, 0x00ff00)
end, false)

RegisterCommand('removetaken', function(source, args)
    local staffName = (source == 0) and "Console" or GetPlayerName(source)
    local xPlayer = (source ~= 0) and ESX.GetPlayerFromId(source)

    if xPlayer and not (xPlayer.getGroup() == 'staff' or xPlayer.getGroup() == 'owner' or xPlayer.getGroup() == 'hogerop' or xPlayer.getGroup() == 'admin') then
        return TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Je hebt geen toestemming om dit command te gebruiken.' }})
    end

    local targetId = tonumber(args[1])
    if not targetId then
        local errorMsg = "Geef een geldige speler ID op."
        return (source == 0) and print(errorMsg) or TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', errorMsg }})
    end

    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not targetPlayer then
        local invalidIdMsg = "Ongeldige speler ID, gebruik /removetaken [speler ID]"
        print("Invalid target player ID: " .. targetId)
        return (source == 0) and print(invalidIdMsg) or TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', invalidIdMsg }})
    end

    local targetIdentifier = targetPlayer.identifier
    print("Target Identifier: " .. targetIdentifier)

    MySQL.query('DELETE FROM player_tasks WHERE player_identifier = ?', {targetIdentifier}, function(results, err)
        if err then
            local errorMsg = "Er is een fout opgetreden bij het verwijderen van de taken."
            print("Fout bij uitvoeren van query:", err)
            return (source ~= 0) and TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', errorMsg }})
        end

        local affectedRows = results and results.affectedRows or 0
        if affectedRows > 0 then
            local playerName = GetPlayerName(targetId)
            sendLog("Taken Verwijderd", "Staff: " .. staffName .. "\nPlayer: " .. playerName .. "\nMessage: Taken verwijderd door admin via command", 0xff0000)

            if source ~= 0 then
                TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEEM', 'Taken succesvol verwijderd voor speler ID: ' .. targetId }})
                TriggerClientEvent('chat:addMessage', targetId, { args = { 'SYSTEEM', 'Je taken zijn verwijderd door een admin.' }})
            else
                print("Taken succesvol verwijderd voor speler ID: " .. targetId)
            end

            TriggerClientEvent('jtm-taakstraf:afgerond', targetId)
        else
            local noTasksMsg = "Geen taken gevonden voor speler ID: " .. targetId
            return (source == 0) and print(noTasksMsg) or TriggerClientEvent('chat:addMessage', source, { args = { 'SYSTEEM', noTasksMsg }})
        end
    end)
end, false)
