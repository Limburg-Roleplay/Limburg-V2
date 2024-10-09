ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    Citizen.Wait(100) -- Small delay
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

RegisterCommand('taakstraf', function(source, args, rawCommand)
    local staffName = ""

    if source == 0 then
        -- Command executed from the console
        staffName = "Console"
    else
        -- Command executed by a player
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local playerGroup = xPlayer.getGroup()
            staffName = GetPlayerName(source)

            if playerGroup ~= 'staff' and playerGroup ~= 'owner' and playerGroup ~= 'hogerop' then
                TriggerClientEvent('chat:addMessage', source, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"System", "Je hebt geen toestemming om dit commando te gebruiken."}
                })
                print("Unauthorized access attempt by player ID: " .. source)
                return
            end
        else
            print("Invalid player ID: " .. source)
            return
        end
    end

    if #args < 3 then
        if source == 0 then
            print("Gebruik: /taakstraf [playerId] [tasks] [reason]")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 255, 0},
                multiline = true,
                args = {"System", "Gebruik: /taakstraf [playerId] [tasks] [reason]"}
            })
        end
        return
    end
    
    local target = tonumber(args[1])
    local tasks = tonumber(args[2])
    local reason = table.concat(args, " ", 3)

    if not target or not tasks or not reason then
        if source == 0 then
            print("Fout: Ongeldige argumenten. Gebruik: /taakstraf [playerId] [tasks] [reason]")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 255, 0},
                multiline = true,
                args = {"System", "Fout: Ongeldige argumenten. Gebruik: /taakstraf [playerId] [tasks] [reason]"}
            })
        end
        return
    end
    
    local player = GetPlayerName(target)
    if player then
        TriggerClientEvent('communityService:assignTasks', target, tasks, reason, staffName)
        if source == 0 then
            print("Toegekend " .. tasks .. " taken aan speler " .. player .. " om reden: " .. reason .. " door staflid: " .. staffName)
        else
            TriggerClientEvent('chat:addMessage', -1, {
                color = {0, 255, 0},
                multiline = true,
                args = {"System", "Toegekend " .. tasks .. " taken aan speler " .. player .. " om reden: " .. reason .. " door staflid: " .. staffName}
            })
        end
        print("Toegekend " .. tasks .. " taken aan speler " .. player .. " om reden: " .. reason .. " door staflid: " .. staffName)

        local logEntry = {
            title = "Assign Service",
            desc = "Staff: " .. staffName .. "\nPlayer: " .. player .. "\nTasks: " .. tasks .. "\nReason: " .. reason,
        }

        print("Verzend logboekvermelding:", logEntry)

        local identifiers = GetPlayerIdentifiers(target)
        local playerIdentifier = identifiers[1]
        playerTasks[playerIdentifier] = {
            tasksLeft = tasks,
            reason = reason,
            staffName = staffName
        }
        saveTask(playerIdentifier, tasks, reason, staffName)

        sendLog("Taken gegeven", "Staff: " .. staffName .. "\nPlayer: " .. player .. "\nHoeveelheid Taken: " .. tasks .. "\nReden: " .. reason, 0x00ff00)
    else
        if source == 0 then
            print("Fout: Speler ID " .. target .. " niet gevonden.")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", "Fout: Speler ID " .. target .. " niet gevonden."}
            })
        end
    end
end, false)

RegisterCommand('offlinetaakstraf', function(source, args, rawCommand)
    local staffName = ""
    if source == 0 then
        staffName = "Console"
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin' then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", "Je hebt geen toestemming om deze opdracht uit te voeren."}
            })
            return
        end
        staffName = GetPlayerName(source)
    end

    if #args < 3 then
        if source == 0 then
            print("Fout: Ongeldige argumenten. Gebruik: /offlinetaakstraf [identifier] [tasks] [reason]")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", "Fout: Ongeldige argumenten. Gebruik: /offlinetaakstraf [identifier] [tasks] [reason]"}
            })
        end
        return
    end

    local identifier = args[1]
    local tasks = tonumber(args[2])
    local reason = table.concat(args, " ", 3)

    if not tasks or tasks <= 0 then
        if source == 0 then
            print("Fout: Ongeldig aantal taken.")
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", "Fout: Ongeldig aantal taken."}
            })
        end
        return
    end

    playerTasks[identifier] = {
        tasksLeft = tasks,
        reason = reason,
        staffName = staffName
    }
    saveTask(identifier, tasks, reason, staffName)

    if source == 0 then
        print("Toegekend " .. tasks .. " taken aan offline speler met identifier " .. identifier .. " om reden: " .. reason .. " door staflid: " .. staffName)
    else
        TriggerClientEvent('chat:addMessage', -1, {
            color = {0, 255, 0},
            multiline = true,
            args = {"System", "Toegekend " .. tasks .. " taken aan offline speler met identifier " .. identifier .. " om reden: " .. reason .. " door staflid: " .. staffName}
        })
    end

    sendLog("Offline Taken gegeven", "Staff: " .. staffName .. "\nIdentifier: " .. identifier .. "\nHoeveelheid Taken: " .. tasks .. "\nReden: " .. reason, 0x00ff00)
end, false)

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

RegisterCommand('removetaken', function(source, args, rawCommand)
    local staffName = ""

    if source == 0 then
        -- Command executed from the console
        staffName = "Console"
    else
        -- Command executed by a player
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local playerGroup = xPlayer.getGroup()
            staffName = GetPlayerName(source)

            if playerGroup ~= 'staff' and playerGroup ~= 'owner' and playerGroup ~= 'hogerop' then
                TriggerClientEvent('chat:addMessage', source, {
                    args = { '^1SYSTEM', 'Je hebt geen toestemming om dit command te gebruiken.' }
                })
                print("Unauthorized access attempt by player ID: " .. source)
                return
            end
        else
            print("Invalid player ID: " .. source)
            return
        end
    end

    local targetId = tonumber(args[1])
    if not targetId then
        if source == 0 then
            print("Geef een geldige speler ID op.")
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = { '^1SYSTEM', 'Geef een geldige speler ID op.' }
            })
        end
        return
    end
    
    local targetIdentifiers = GetPlayerIdentifiers(targetId)
    if not targetIdentifiers or not targetIdentifiers[1] then
        if source == 0 then
            print("Ongeldige speler ID, gebruik /removetaken [speler ID]")
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = { '^1SYSTEM', 'Ongeldige speler ID, gebruik /removetaken [speler ID]' }
            })
        end
        print("Invalid target player ID: " .. targetId)
        return
    end

    local targetIdentifier = targetIdentifiers[1]
    print("Target Identifier: " .. targetIdentifier)
    
    MySQL.query('DELETE FROM player_tasks WHERE player_identifier = ?', {targetIdentifier}, function(results, err)
        if err then
            print("Fout bij uitvoeren van query:", err)
            if source ~= 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    args = { '^1SYSTEM', 'Er is een fout opgetreden bij het verwijderen van de taken.' }
                })
            end
        else
            if type(results) == 'table' then
                local affectedRows = results.affectedRows or 0

                if affectedRows > 0 then
                    local logEntry = {
                        title = "Taken Verwijderd",
                        desc = "Staff: " .. staffName .. "\nPlayer: " .. GetPlayerName(targetId) .. "\nMessage: Taken verwijderd door admin via command",
                    }

                    sendLog("Taken Verwijderd", "Staff: " .. staffName .. "\nPlayer: " .. GetPlayerName(targetId) .. "\nMessage: Taken verwijderd door admin via command", 0xff0000)

                    if source ~= 0 then
                        TriggerClientEvent('chat:addMessage', source, {
                            args = { 'SYSTEEM', 'Taken succesvol verwijderd voor speler ID: ' .. targetId }
                        })

                        TriggerClientEvent('chat:addMessage', targetId, {
                            args = { 'SYSTEEM', 'Je taken zijn verwijderd door een admin.' }
                        })
                    else
                        print("Taken succesvol verwijderd voor speler ID: " .. targetId)
                    end

                    TriggerClientEvent('jtm-taakstraf:afgerond', targetId)
                else
                    if source ~= 0 then
                        TriggerClientEvent('chat:addMessage', source, {
                            args = { 'SYSTEEM', 'Geen taken gevonden voor speler ID: ' .. targetId }
                        })
                    else
                        print("Geen taken gevonden voor speler ID: " .. targetId)
                    end
                end
            else
                print("Onverwacht type voor query resultaat:", type(results))
                if source ~= 0 then
                    TriggerClientEvent('chat:addMessage', source, {
                        args = { '^1SYSTEM', 'Onverwacht resultaat bij het verwijderen van taken.' }
                    })
                end
            end
        end
    end)
end, false)
