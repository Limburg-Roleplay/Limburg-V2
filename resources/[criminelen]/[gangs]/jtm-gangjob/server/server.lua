ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- F6 fouileren

ESX.RegisterServerCallback('srp-gangmenu:getInventoryItems', function(source, cb, targetId)
    local targetXPlayer = ESX.GetPlayerFromId(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    lib.notify(targetId, {
        title = 'Criminele acties',
        description = 'Je word gefouilleerd door ' .. source .. ' | ' .. xPlayer.getJob().name,
        type = 'success'
    })
    local items = targetXPlayer.getInventory()

    local formattedItems = {}
    for k, v in pairs(items) do
        if v.count > 0 then
            table.insert(formattedItems, {
                label = ESX.GetItemLabel(v.name) .. ' x' .. v.count,
                value = v.name
            })
        end
    end

    cb(formattedItems)
end)

RegisterNetEvent('jtm-gangjob:notification', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    lib.notify(targetId, {
        title = 'Criminele acties',
        description = 'Je word gefouilleerd door ' .. source .. ' | ' .. xPlayer.getJob().name,
        type = 'success'
    })
end)

RegisterNetEvent('jtm_gangjob:sendLog', function(id, logTable, color)
    TriggerEvent('td_logs:sendLog', 
        'https://discord.com/api/webhooks/1283467508346654873/hGREVpjlsFXVg9SEgP_wOXfAKixGZjRqkjEgCtG-ACXlC7CLxpo1KkQxatNftxO1mwsw', 
        id, 
        logTable,
        color
    )
end)

RegisterServerEvent('srp-gangmenu:requestSearch')
AddEventHandler('srp-gangmenu:requestSearch', function(targetPlayerId)
    local source = source
    TriggerClientEvent('srp-gangmenu:notifySearchRequest', targetPlayerId, source)
end)

RegisterServerEvent('srp-gangmenu:searchResponse')
AddEventHandler('srp-gangmenu:searchResponse', function(requesterId, accepted)
    local source = source
    TriggerClientEvent('srp-gangmenu:searchResponse', requesterId, source, accepted)
end)

RegisterServerEvent('srp-gangmenu:sendNotification')
AddEventHandler('srp-gangmenu:sendNotification', function(targetPlayerId, playerId)
    TriggerClientEvent("frp-notifications:client:notify", targetPlayerId, "success", "Je wordt gefouilleerd door speler " .. playerId, "3000")
end)

RegisterServerEvent('jtm-development:client:read:radio')
AddEventHandler('jtm-development:client:read:radio', function(targetId)
    local currentRadio = Player(targetId).state.radioChannel
    local targetXPlayer = ESX.GetPlayerFromId(targetId)
    TriggerClientEvent("frp-notifications:client:notify", targetId, "success", "Je radio word afgelezen door speler " .. source, "3000")
    if currentRadio == 0 then
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Deze speler heeft geen radio aan!", "3000")
        return
    end
    TriggerClientEvent("frp-notifications:client:notify", source, "success", "Radio succesvol afgelezen! Radio: "..currentRadio, "3000")
end)


local stash1 = {
    id = 'Persoonlijkeopslag',
    label = 'Persoonlijke opslag',
}

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        exports.ox_inventory:RegisterStash(stash1.id, stash1.label, 50, 1000000, true)
    end
end)

local stash4 = {
    id = 'opslag_leiding',
    label = 'Opslag leiding',
}

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        exports.ox_inventory:RegisterStash(stash4.id, stash4.label, 50, 1000000, true)
    end
end)

local GangCooldowns = {}

-- Functie om te controleren of een speler tot een gang behoort
local function isPlayerInGang(player)
    local playerJob = player.getJob().name
    if playerJob ~= nil and Config.Wapeninkoopgangs[playerJob] ~= nil then
        return true
    else
        return false
    end
end

RegisterServerEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local player = ESX.GetPlayerFromId(playerId)
    local jobName = player.getJob().name
    if Config.Wapeninkoopgangs[jobName] ~= nil then
        TriggerClientEvent('wrp-gangjob:SyncBlip', playerId, jobName)
    end
end)

RegisterServerEvent('esx:setJob')
AddEventHandler('esx:setJob', function(playerId, job)
    local player = ESX.GetPlayerFromId(playerId)
    local jobName = job.name

    if Config.Wapeninkoopgangs[jobName] ~= nil then
        TriggerClientEvent('jtm-gangjob:SyncBlip', playerId, jobName)
    end
end)

local function SetBlipForGang(playerId, jobName)
    local coords = Config.Wapeninkoopgangs[jobName][1].coordswapeninkoop
    local x, y, z = coords.x, coords.y, coords.z

    TriggerClientEvent('jtm-gangjob:SetBlip', playerId, x, y, z, jobName)
end

RegisterServerEvent('jtm-gangjob:OpenShopMenu')
AddEventHandler('jtm-gangjob:OpenShopMenu', function()
    local player = ESX.GetPlayerFromId(source)
    local jobName = player.getJob().name
    if Config.Wapeninkoopgangs[jobName] ~= nil then
    end
end)

local function IsPlayerNearWeaponStorage(player, jobName)
    local coords = player.getCoords()
    local dist = #(coords - Config.Wapeninkoopgangs[jobName][1].coordswapeninkoop)

    return dist <= Config.Markerdistance
end

local stash = {
    id = 'gangstash',
    label = 'Gang Stash',
    slots = 50,
    weight = 100000,
    owner = 'gangjob' -- Change the owner to the gang job name
}

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
    end
end)

-- witwas missie

local missionBlips = {}
local activeBlips = {}
local missionStatus = {}

RegisterServerEvent('jtm-witwas:startMission')
AddEventHandler('jtm-witwas:startMission', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local jobLabel = xPlayer.getJob().label

    if amount < 1000000 then
        TriggerClientEvent('okokNotify:Alert', src, 'Missie Mislukt', 'Het bedrag is te laag om een missie te starten! Minimum inzet is €1.000.000', 5000, 'error')
        return 
    end

    local formattedAmount = string.format("%0.0f", amount):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")

    missionBlips[src] = {
        amount = amount,
        startTime = os.time()
    }

    missionStatus[src] = true 
    print('witwas is troe')

    TriggerClientEvent('jtm-witwas:newMission', -1, src)

    TriggerClientEvent('okokNotify:Alert', -1, 'Witwas Missie!', jobLabel .. ' heeft zojuist een witwasmissie gestart van €' .. formattedAmount .. '! Bekijk je map voor een mogelijke locatie!', 7500, 'info')
end)

RegisterServerEvent('jtm-witwas:updateLocation')
AddEventHandler('jtm-witwas:updateLocation', function(position)
    local src = source
    if missionBlips[src] and missionStatus[src] then
        TriggerClientEvent('jtm-witwas:updateBlip', -1, src, position)
    end
end)

RegisterServerEvent('jtm-witwas:endMission')
AddEventHandler('jtm-witwas:endMission', function()
    local src = source
    if missionBlips[src] then
        missionBlips[src] = nil
        TriggerClientEvent('jtm-witwas:removeBlip', -1, src)
        missionStatus[src] = false 
        print('Witwas is fals')
    end
end)

function getRandomPercentage(min, max)
    return math.random(min, max)
end

function formatMoney(amount)
    return string.format("%.2f", amount) 
end

RegisterServerEvent('jtm-witwas:witwasmissie')
AddEventHandler('jtm-witwas:witwasmissie', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if missionStatus[src] ~= true then
        exports["FIVEGUARD"]:screenshotPlayer(source, function(url)
            print("Got URL of screenshot: ".. url .." from player: "..source)
        end)
        exports["FIVEGUARD"]:fg_BanPlayer(source, "Suspicious activity detected: Player ID " .. source .. " Probeerde de gangjob witwasmissie te triggeren zonder hem gestart te hebben", true)
        return
    end

    if xPlayer.getAccount('black_money').money >= amount then
        xPlayer.removeAccountMoney('black_money', amount)
        
        local procent = getRandomPercentage(Config.WitwasMissie.minProcent, Config.WitwasMissie.maxProcent) / 100
        
        local bedragTeOntvangen = amount * procent
        xPlayer.addMoney(bedragTeOntvangen)
        
        TriggerClientEvent('okokNotify:Alert', src, 'Witwas Voltooid', 'Je hebt €' .. formatMoney(bedragTeOntvangen) .. ' wit gewassen voor (' .. procent * 100 .. '%)!', 3000, 'success')
        
        
        local playerName = xPlayer.getName()
        local steamName = GetPlayerName(xPlayer.source)
        local steamID = xPlayer.identifier
        local playerCoords = GetEntityCoords(GetPlayerPed(src))
        local coordsStr = string.format("x: %.2f, y: %.2f, z: %.2f", playerCoords.x, playerCoords.y, playerCoords.z)

        local initialBlackMoney = formatMoney(amount)
        local totalReceiveFormatted = formatMoney(bedragTeOntvangen)
        local percentFormatted = string.format("%.2f", procent * 100)

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1277595807511740467/RnxgmZrtwWvYn4GJOB20X-_icwTmIX_18fvQzp2ZzDhG8PkXk_usZ3esiOwoREnNoD0P', source, {
            title = "Gangjob Witwas Missie Logs",
            desc = string.format(
                "Ingame Naam Speler: %s\nSteam Naam: %s\nIdentifier Speler: %s\nCoords: %s\nZwartgeld voor: %s\nWitgeld ontvangen: %s\nProcent: %s%%",
                playerName, steamName, steamID, coordsStr, initialBlackMoney, totalReceiveFormatted, percentFormatted
            )
        })

    else
        TriggerClientEvent('okokNotify:Alert', src, 'Missie Mislukt', 'Je hebt niet genoeg zwart geld om deze missie te voltooien!', 5000, 'error')
    end

    missionStatus[src] = false 
    print('Witwas is gefaald voor speler met ID ' .. src)
    TriggerClientEvent('jtm-witwas:removeBlip', -1, src)
end)

-- witwas missie

ESX.RegisterServerCallback(
    "jtm-gangjob:check:gangmembers",
    function(source, callback, jobnaam)
        local ganginfo = {}
        local xPlayer = ESX.GetPlayerFromId(source)
        local xPlayer2 = ESX.GetPlayerFromId(playerid)
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE job = @job",
            {
                ["@job"] = jobnaam
            },
            function(result)
                if result[1] then
                    for k, v in pairs(result) do
                        table.insert(
                            ganginfo,
                            {
                                identifier = v.identifier,
                                voornaam = v.firstname,
                                achternaam = v.lastname,
                                grade = getJobGradeLabel(jobnaam, v.job_grade)
                            }
                        )
                    end
                    callback(ganginfo)
                else
                    TriggerClientEvent(
                        "frp-notifications:client:notify",
                        source,
                        "error",
                        "Je instantie heeft geen leden!",
                        3000
                    )
                end
            end
        )
    end
)

Config = Config or {}
if not Config.Webhooks then
    dofile('config.lua')
end

RegisterServerEvent("jtm-gangjob:promotemember")
AddEventHandler(
    "jtm-gangjob:promotemember",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = xPlayer.job
        local currentgrade = 1
        if not currentjob then
            return
        end
        if targetPlayer then
            currentjob = targetPlayer.job.name
            currentgrade = targetPlayer.job.grade + 1
            if currentgrade > 8 then
                currentgrade = 8
            end
            targetPlayer.setJob(currentjob, currentgrade)
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                {
                    ["@job"] = currentjob,
                    ["@job_grade"] = currentgrade,
                    ["@identifier"] = identifierplayer
                }
            )
        else
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = job_grade + 1 WHERE identifier = @identifier",
                {
                    ["@job"] = currentjob,
                    ["@identifier"] = identifierplayer
                }
            )
        end
        if targetPlayer then
            TriggerEvent(
                "td_logs:sendLog",
                Config.Webhooks.PromoteWebhook,
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist gepromoveerd door " ..
                            GetPlayerName(xPlayer.source) .. " naar grade: " .. currentgrade,
                    desc = "Job: " .. currentjob
                },
                0x000001
            )
            TriggerClientEvent(
                "frp-notifications:client:notify",
                src,
                "success",
                "Je hebt " .. voornaamplayer .. " gepromoveerd naar grade: " .. currentgrade,
                3000
            )
        else
            TriggerEvent(
                "td_logs:sendLog",
                Config.Webhooks.PromoteWebhook,
                xPlayer.source,
                {
                    title = voornaamplayer ..
                        " is zojuist gepromoveerd door " .. GetPlayerName(xPlayer.source) .. " naar grade: onbekend",
                    desc = "Job: " .. currentjob
                },
                0x000001
            )
            TriggerClientEvent(
                "frp-notifications:client:notify",
                src,
                "success",
                "Je hebt " .. voornaamplayer .. " gepromoveerd naar grade: onbekend",
                3000
            )
        end
    end
)

RegisterServerEvent("jtm-gangjob:demote")
AddEventHandler(
    "jtm-gangjob:demote",
    function(identifierplayer, voornaamplayer, job)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = xPlayer.job.name
        local currentgrade = 1
        if targetPlayer then
            currentjob = targetPlayer.job.name
            currentgrade = targetPlayer.job.grade - 1
            if currentgrade < 1 then
                currentgrade = 1
            end
            targetPlayer.setJob(currentjob, currentgrade)
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                {
                    ["@job"] = currentjob,
                    ["@job_grade"] = currentgrade,
                    ["@identifier"] = identifierplayer
                }
            )
        else
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = job_grade - 1 WHERE identifier = @identifier",
                {
                    ["@job"] = currentjob,
                    ["@identifier"] = identifierplayer
                }
            )
        end
        if targetPlayer then
            TriggerEvent(
                "td_logs:sendLog",
                Config.Webhooks.DemoteWebhook,
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist gedemote door " .. GetPlayerName(xPlayer.source) .. " naar grade: " .. currentgrade,
                    desc = "Job: " .. currentjob
                },
                0x000001
            )

            TriggerClientEvent(
                "frp-notifications:client:notify",
                src,
                "success",
                "Je hebt " .. voornaamplayer .. " gedemote naar grade: " .. currentgrade,
                3000
            )
        else
            TriggerEvent(
                "td_logs:sendLog",
                Config.Webhooks.DemoteWebhook,
                xPlayer.source,
                {
                    title = voornaamplayer ..
                        " is zojuist gedemote door " .. GetPlayerName(xPlayer.source) .. " naar grade: onbekend",
                    desc = "Job: " .. currentjob
                },
                0x000001
            )

            TriggerClientEvent(
                "frp-notifications:client:notify",
                src,
                "success",
                "Je hebt " .. voornaamplayer .. " gedemote naar grade: onbekend",
                3000
            )
        end
    end
)

RegisterServerEvent("jtm-gangjob:deletemember:serversided")
AddEventHandler(
    "jtm-gangjob:deletemember:serversided",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        if targetPlayer then
            targetPlayer.setJob("unemployed", 0)
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                {
                    ["@job"] = "unemployed",
                    ["@job_grade"] = 0,
                    ["@identifier"] = identifierplayer
                }
            )
        else
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                {
                    ["@job"] = "unemployed",
                    ["@job_grade"] = 0,
                    ["@identifier"] = identifierplayer
                }
            )
        end
        if targetPlayer then
            TriggerEvent(
                "td_logs:sendLog",
                Config.Webhooks.OntslaanWebhook,
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist ontslagen door " .. GetPlayerName(xPlayer.source),
                    desc = "Job: " .. xPlayer.getJob().name
                },
                0x000001
            )
        else
            TriggerEvent(
                "td_logs:sendLog",
                Config.Webhooks.OntslaanWebhook,
                xPlayer.source,
                {
                    title = voornaamplayer .. " is zojuist ontslagen door " .. GetPlayerName(xPlayer.source),
                    desc = "Job: " .. xPlayer.getJob().name
                },
                0x000001
            )
        end
        TriggerClientEvent(
            "frp-notifications:client:notify",
            source,
            "success",
            "Je hebt " .. voornaamplayer .. " ontslagen",
            3000
        )
    end
)

ESX.RegisterServerCallback(
    "jtm-gangjob:add:playertogang",
    function(source, callback, playerid, jobnamegang)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xPlayer2 = ESX.GetPlayerFromId(playerid)

        if not xPlayer2 then
            TriggerClientEvent("frp-notifications:client:notify", source, "error", "Deze speler is niet online!", 3000)
            return
        end
        
        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = xPlayer2.identifier
            },
            function(result)
                if result[1] and result[1].job ~= jobnamegang then
                    xPlayer2.setJob(jobnamegang, 1)
                    TriggerClientEvent(
                        "frp-notifications:client:notify",
                        source,
                        "success",
                        "Je hebt een ganglid aangenomen!",
                        3000
                    )
                    TriggerClientEvent(
                        "frp-notifications:client:notify",
                        playerid,
                        "success",
                        "Je bent aangenomen bij " .. jobnamegang,
                        3000
                    )
                    TriggerEvent(
                        "td_logs:sendLog",
                        Config.Webhooks.AaneemWebhook,
                        xPlayer2.source,
                        {
                            title = GetPlayerName(xPlayer2.source) ..
                                " is zojuist aangenomen door " .. GetPlayerName(xPlayer.source),
                            desc = "Job: " .. jobnamegang
                        },
                        0x000001
                    )
                    MySQL.Async.execute(
                        "UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier",
                        {
                            ["@identifier"] = xPlayer2.identifier,
                            ["@job"] = jobnamegang,
                            ["@grade"] = 1
                        }
                    )
                    callback(true)
                else
                    TriggerClientEvent(
                        "frp-notifications:client:notify",
                        source,
                        "error",
                        "Deze persoon zit al bij je gang!",
                        3000
                    )
                    callback(false)
                end
            end
        )
    end
)

local stashes = {}

for gangId, gangData in pairs(Config.Wapeninkoopgangs) do
    local stash = {
        id = gangId .. '_stash',
        label = gangData[1].gangname .. ' Gezamelijke Stash',
        slots = 500,
        weight = 1000000,
        owner = false,
    }
    table.insert(stashes, stash)
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'jtm-gangjob' or resourceName == GetCurrentResourceName() then
        for _, stash in ipairs(stashes) do
            exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
        end
    end
end)