ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- F6 fouileren

ESX.RegisterServerCallback('lrp-gangmenu:getInventoryItems', function(source, cb, targetId)
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

RegisterServerEvent('lrp-gangmenu:requestSearch')
AddEventHandler('lrp-gangmenu:requestSearch', function(targetPlayerId)
    local source = source
    TriggerClientEvent('lrp-gangmenu:notifySearchRequest', targetPlayerId, source)
end)



ESX.RegisterServerCallback('jtm-gangjob:gunshop:getvoorraad', function(src, cb, gangjob)
    MySQL.Async.fetchAll(
        "SELECT * FROM ganginkoop WHERE gangnaam = @gangnaam",
        {
            ["@gangnaam"] = gangjob
        },
        function(result)
            if result[1] then
                cb(result[1])
            end
        end
    )
end)

RegisterServerEvent('jtm-gangjob:koopwapen')
AddEventHandler('jtm-gangjob:koopwapen', function(gangnaam, wapenSpawnName, wapennaam)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll(
        "SELECT * FROM ganginkoop WHERE gangnaam = @gangnaam",
        {
            ["@gangnaam"] = gangnaam
        },
        function(result)
            if result[1] then
                local voorraad = result[1][wapennaam]

                if voorraad < 0 then
                    TriggerClientEvent('okokNotify:Alert', src, 'Geen voorraad', 'De voorraad van dit wapen is leeg!',
                        5000, 'error')
                    return
                end

                if xPlayer.getAccount('bank').money < Config.wapen_prijzen[wapennaam] then
                    TriggerClientEvent('okokNotify:Alert', src, 'Niet genoeg geld',
                        'Je hebt niet genoeg geld om dit wapen aan te kopen!',
                        5000, 'error')
                    return
                end
                if exports.ox_inventory:CanCarryItem(src, wapenSpawnName, 1) then
                    local gegeven, antwoord = exports.ox_inventory:AddItem(src, wapenSpawnName, 1)
                    if not gegeven then
                        return print(antwoord)
                    end
                    local overgeblevenGeld = xPlayer.getAccount('bank').money - Config.wapen_prijzen[wapennaam]
                    xPlayer.setAccountMoney('bank', overgeblevenGeld)

                    TriggerClientEvent('okokNotify:Alert', src, 'Gekocht!', 'Veel plezier met je wapen!', 5000, 'success')

                    MySQL.Async.execute(
                        string.format("UPDATE ganginkoop SET %s = @aantal WHERE gangnaam = @gangnaam", wapennaam),
                        {
                            ["@gangnaam"] = gangnaam,
                            ["@aantal"] = voorraad - 1,
                        }
                    )
                else
                    TriggerClientEvent('okokNotify:Alert', src, 'Te zwaar!', 'Je kan het wapen niet dragen.',
                        5000, 'error')
                end
            end
        end
    )
end)


ESX.RegisterCommand('resetwapenvoorraad', 'owner', function(xPlayer, args, showError)
        if not args.gang then
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Error!',
                'Je moet een gang invullen om deze command te gebruiken',
                5000, 'error')
        end
        if not Config.Wapeninkoopgangs[args.gang] then
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Error!', 'Deze gang bestaat niet',
                5000, 'error')
        end
        if not args.wapen then
            for k, v in pairs(Config.Wapeninkoopgangs[args.gang].wapeninkoop) do
                MySQL.Async.execute(
                    string.format("UPDATE ganginkoop SET %s = @aantal WHERE gangnaam = @gangnaam", k),
                    {
                        ["@gangnaam"] = args.gang,
                        ["@aantal"] = v,
                    }
                )

                
            end
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Gelukt!', args.gang .. ' kan nu weer alle wapens maximaal kopen', 5000,
                'success')
            return
        end

        if not Config.wapen_labels[args.wapen] then
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Error!', 'Dit wapen is niet bij ons bekend', 5000,
                'error')
            return
        end


        local maxVoorraad = Config.Wapeninkoopgangs[args.gang].wapeninkoop[args.wapen]
        local wapenLabel = Config.wapen_labels[args.wapen]
        MySQL.Async.execute(
            string.format("UPDATE ganginkoop SET %s = @aantal WHERE gangnaam = @gangnaam", args.wapen),
            {
                ["@gangnaam"] = args.gang,
                ["@aantal"] = maxVoorraad,
            }
        )
        TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Gelukt!', args.gang .. ' kan nu ' .. maxVoorraad .. 'x een ' .. wapenLabel .. ' kopen!', 5000,
        'success')

    end, true,
    { help = 'Reset de wapenvoorraad van een gang.', arguments = { { name = 'gang', help = 'De gang die de reset moet krijgen', type = 'any' }, {name = 'wapen',  help = 'De wapen die volledig beschikbaar moet zijn. Laat leeg voor alle wapens.', type = 'any' } } })


RegisterServerEvent('lrp-gangmenu:searchResponse')
AddEventHandler('lrp-gangmenu:searchResponse', function(requesterId, accepted)
    local source = source
    TriggerClientEvent('lrp-gangmenu:searchResponse', requesterId, source, accepted)
end)

RegisterServerEvent('lrp-gangmenu:sendNotification')
AddEventHandler('lrp-gangmenu:sendNotification', function(targetPlayerId, playerId)

        TriggerClientEvent('okokNotify:Alert', targetPlayerId, 'Fouilleren', "Je wordt gefouilleerd door speler " .. playerId, 5000, 'success')
end)

RegisterServerEvent('jtm-development:client:read:radio')
AddEventHandler('jtm-development:client:read:radio', function(targetId)
    local currentRadio = Player(targetId).state.radioChannel
    local targetXPlayer = ESX.GetPlayerFromId(targetId)
    TriggerClientEvent('okokNotify:Alert', targetId, 'Radio Afgelezen', 'Je radio wordt afgelezen door' .. source, 5000,
        'phonemessage')
    if currentRadio == 0 then
        TriggerClientEvent('okokNotify:Alert', source, 'Fout', 'Deze speler heeft geen radio aan!', 5000, 'error')
        return
    end
    TriggerClientEvent('okokNotify:Alert', source, 'Afgelezen', 'De radio is succesvol afgelezen. Radio: ' .. currentRadio,
        5000, 'success')
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
        TriggerClientEvent('okokNotify:Alert', src, 'Missie Mislukt',
            'Het bedrag is te laag om een missie te starten! Minimum inzet is €1.000.000', 5000, 'error')
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

    TriggerClientEvent('okokNotify:Alert', -1, 'Witwas Missie!',
        jobLabel ..
        ' heeft zojuist een witwasmissie gestart van €' ..
        formattedAmount .. '! Bekijk je map voor een mogelijke locatie!', 7500, 'info')
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
            print("Got URL of screenshot: " .. url .. " from player: " .. source)
        end)
        exports["FIVEGUARD"]:fg_BanPlayer(source,
            "Suspicious activity detected: Player ID " ..
            source .. " Probeerde de gangjob witwasmissie te triggeren zonder hem gestart te hebben", true)
        return
    end

    if xPlayer.getAccount('black_money').money >= amount then
        xPlayer.removeAccountMoney('black_money', amount)

        local procent = getRandomPercentage(Config.WitwasMissie.minProcent, Config.WitwasMissie.maxProcent) / 100

        local bedragTeOntvangen = amount * procent
        xPlayer.addMoney(bedragTeOntvangen)

        TriggerClientEvent('okokNotify:Alert', src, 'Witwas Voltooid',
            'Je hebt €' .. formatMoney(bedragTeOntvangen) .. ' wit gewassen voor (' .. procent * 100 .. '%)!', 3000,
            'success')


        local playerName = xPlayer.getName()
        local steamName = GetPlayerName(xPlayer.source)
        local steamID = xPlayer.identifier
        local playerCoords = GetEntityCoords(GetPlayerPed(src))
        local coordsStr = string.format("x: %.2f, y: %.2f, z: %.2f", playerCoords.x, playerCoords.y, playerCoords.z)

        local initialBlackMoney = formatMoney(amount)
        local totalReceiveFormatted = formatMoney(bedragTeOntvangen)
        local percentFormatted = string.format("%.2f", procent * 100)

        TriggerEvent('td_logs:sendLog',
            'https://discord.com/api/webhooks/1277595807511740467/RnxgmZrtwWvYn4GJOB20X-_icwTmIX_18fvQzp2ZzDhG8PkXk_usZ3esiOwoREnNoD0P',
            source, {
                title = "Gangjob Witwas Missie Logs",
                desc = string.format(
                    "Ingame Naam Speler: %s\nSteam Naam: %s\nIdentifier Speler: %s\nCoords: %s\nZwartgeld voor: %s\nWitgeld ontvangen: %s\nProcent: %s%%",
                    playerName, steamName, steamID, coordsStr, initialBlackMoney, totalReceiveFormatted, percentFormatted
                )
            })
    else
        TriggerClientEvent('okokNotify:Alert', src, 'Missie Mislukt',
            'Je hebt niet genoeg zwart geld om deze missie te voltooien!', 5000, 'error')
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

        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE job = @job OR job2 = @job",
            {
                ["@job"] = jobnaam
            },
            function(result)
                if result[1] then
                    for k, v in pairs(result) do
                        local grade = 'Niks gevonden'

                        if v.job == jobnaam then
                            grade = getJobGradeLabel(jobnaam, v.job_grade)
                        else
                            grade = getJobGradeLabel(jobnaam, v.job2_grade)
                        end


                        if grade then
                            table.insert(ganginfo, {
                                identifier = v.identifier,
                                voornaam = v.firstname,
                                achternaam = v.lastname,
                                grade = grade
                            })
                        end
                    end
                end
                callback(ganginfo)
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
    function(identifierplayer, voornaamplayer, gangnaam)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = gangnaam
        local currentgrade = 1
        if not currentjob then
            return
        end
        if targetPlayer then
            if targetPlayer.job.name == gangnaam then
                currentgrade = targetPlayer.job.grade + 1
                currentjob = targetPlayer.job.name

                if currentgrade > Config.Wapeninkoopgangs[gangnaam][1].mingrade then
                    currentgrade = Config.Wapeninkoopgangs[gangnaam][1].mingrade
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
            elseif targetPlayer.job2.name == gangnaam
            then
                currentgrade = targetPlayer.job2.grade + 1
                currentjob = targetPlayer.job2.name

                if currentgrade > Config.Wapeninkoopgangs[gangnaam][1].mingrade then
                    currentgrade = Config.Wapeninkoopgangs[gangnaam][1].mingrade
                end
                targetPlayer.setJob2(currentjob, currentgrade)
                MySQL.Async.execute(
                    "UPDATE users SET job2 = @job, job2_grade = @job_grade WHERE identifier = @identifier",
                    {
                        ["@job"] = currentjob,
                        ["@job_grade"] = currentgrade,
                        ["@identifier"] = identifierplayer
                    }
                )
            end
        else
            MySQL.Async.fetchAll(
                "SELECT * FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifierplayer
                },
                function(result)
                    if result[1] then
                        local user = result[1]
                        if user.job == gangnaam then
                            local newGrade = user.job_grade + 1


                            if newGrade > Config.Wapeninkoopgangs[gangnaam][1].mingrade then
                                newGrade = Config.Wapeninkoopgangs[gangnaam][1].mingrade
                            end

                            MySQL.Async.execute(
                                "UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier",
                                {
                                    ["@job_grade"] = newGrade,
                                    ["@identifier"] = identifierplayer
                                }
                            )
                        elseif user.job2 == gangnaam then
                            local newGrade = user.job2_grade + 1

                            if newGrade > Config.Wapeninkoopgangs[gangnaam][1].mingrade then
                                newGrade = Config.Wapeninkoopgangs[gangnaam][1].mingrade
                            end

                            MySQL.Async.execute(
                                "UPDATE users SET job2_grade = @job_grade WHERE identifier = @identifier",
                                {
                                    ["@job_grade"] = newGrade,
                                    ["@identifier"] = identifierplayer
                                }
                            )
                        end
                    end
                end
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

            TriggerClientEvent('okokNotify:Alert', src, 'Gepromoveerd', "Je hebt " .. voornaamplayer .. " gepromoveerd naar grade: " .. currentgrade, 5000, 'success')

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
            TriggerClientEvent('okokNotify:Alert', src, 'Gepromoveerd', "Je hebt " .. voornaamplayer .. " gepromoveerd naar grade: onbekend", 5000, 'success')
        end
    end
)

RegisterServerEvent("jtm-gangjob:demote")
AddEventHandler(
    "jtm-gangjob:demote",
    function(identifierplayer, voornaamplayer, gangnaam)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = ''
        local currentgrade = 1
        if not currentjob then
            return
        end
        if targetPlayer then
            if xPlayer.job.name == gangnaam then
                currentgrade = targetPlayer.job.grade + 1
                currentjob = targetPlayer.job.name

                if currentgrade < 8 then
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
            elseif xPlayer.job2.name == gangnaam
            then
                currentgrade = targetPlayer.job2.grade - 1
                currentjob = targetPlayer.job2.name

                if currentgrade < 1 then
                    currentgrade = 1
                end
                targetPlayer.setJob2(currentjob, currentgrade)
                MySQL.Async.execute(
                    "UPDATE users SET job2 = @job, job2_grade = @job_grade WHERE identifier = @identifier",
                    {
                        ["@job"] = currentjob,
                        ["@job_grade"] = currentgrade,
                        ["@identifier"] = identifierplayer
                    }
                )
            end
        else
            MySQL.Async.fetchAll(
                "SELECT * FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifierplayer
                },
                function(result)
                    if result[1] then
                        local user = result[1]
                        if user.job == gangnaam then
                            local newGrade = user.job_grade - 1
                            if newGrade < 1 then
                                newGrade = 1
                            end
                            MySQL.Async.execute(
                                "UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier",
                                {
                                    ["@job_grade"] = newGrade,
                                    ["@identifier"] = identifierplayer
                                }
                            )
                        elseif user.job2 == gangnaam then
                            local newGrade = user.job2_grade - 1
                            if newGrade < 1 then
                                newGrade = 1
                            end
                            MySQL.Async.execute(
                                "UPDATE users SET job2_grade = @job_grade WHERE identifier = @identifier",
                                {
                                    ["@job_grade"] = newGrade,
                                    ["@identifier"] = identifierplayer
                                }
                            )
                        end
                    end
                end
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


            TriggerClientEvent('okokNotify:Alert', src, 'Gedegradeerd', "Je hebt " .. voornaamplayer .. " gedegradeerd naar grade: " .. currentgrade, 5000, 'success')
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



            TriggerClientEvent('okokNotify:Alert', src, 'Gedegradeerd', "Je hebt " .. voornaamplayer .. " gedegradeerd naar grade: onbekend", 5000, 'success')
        end
    end
)

RegisterServerEvent("jtm-gangjob:deletemember:serversided")
AddEventHandler(
    "jtm-gangjob:deletemember:serversided",
    function(identifierplayer, voornaamplayer, gangnaam)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        if targetPlayer then
            if targetPlayer.job.name == gangnaam then
                targetPlayer.setJob("unemployed", 0)
                MySQL.Async.execute(
                    "UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                    {
                        ["@job"] = "unemployed",
                        ["@job_grade"] = 0,
                        ["@identifier"] = identifierplayer
                    }
                )
            elseif targetPlayer.job2.name == gangnaam then
                targetPlayer.setJob2("unemployed", 0)
                MySQL.Async.execute(
                    "UPDATE users SET job2 = @job, job2_grade = @job_grade WHERE identifier = @identifier",
                    {
                        ["@job"] = "unemployed",
                        ["@job_grade"] = 0,
                        ["@identifier"] = identifierplayer
                    }
                )
            end
        else
            MySQL.Async.fetchAll(
                "SELECT * FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = identifierplayer
                },
                function(result)
                    if result[1] then
                        local user = result[1]
                        if user.job == gangnaam then
                            MySQL.Async.execute(
                                "UPDATE users SET job = @job2, job_grade = @job_grade WHERE identifier = @identifier",
                                {
                                    ["@job"] = 'unemployed',
                                    ["@job_grade"] = 0,
                                    ["@identifier"] = identifierplayer
                                }
                            )
                        elseif user.job2 == gangnaam then
                            MySQL.Async.execute(
                                "UPDATE users SET job2 = @job2, job2_grade = @job_grade WHERE identifier = @identifier",
                                {
                                    ["@job2"] = 'unemployed',
                                    ["@job_grade"] = 0,
                                    ["@identifier"] = identifierplayer
                                }
                            )
                        end
                    end
                end
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
            "lrp-notifications:client:notify",
            source,
            "success",
            "Je hebt " .. voornaamplayer .. " ontslagen",
            3000
        )

        TriggerClientEvent('okokNotify:Alert', src, 'Ontslagen', "Je hebt " .. voornaamplayer .. " succesvol ontslagen", 5000, 'success')
    end
)

ESX.RegisterServerCallback(
    "jtm-gangjob:add:playertogang",
    function(source, callback, playerid, jobnamegang, naarJob)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xPlayer2 = ESX.GetPlayerFromId(playerid)

        if not xPlayer2 then
            TriggerClientEvent('okokNotify:Alert', source, 'Fout', 'De speler met id ' .. playerid .. ' is niet online.',
                5000, 'error')
            return
        end



        MySQL.Async.fetchAll(
            "SELECT * FROM users WHERE identifier = @identifier",
            {
                ["@identifier"] = xPlayer2.identifier
            },
            function(result)
                if result[1] and result[1].job and result[1].job2 ~= jobnamegang then
                    if naarJob == 'job' then
                        xPlayer2.setJob(jobnamegang, 1)
                    end
                    if naarJob == 'job2' then
                        xPlayer2.setJob2(jobnamegang, 1)
                    end

                    TriggerClientEvent('okokNotify:Alert', source, 'Gelukt',
                        'De speler met id ' .. playerid .. ' is succesvol aangenomen.', 5000, 'succes')
                    TriggerClientEvent('okokNotify:Alert', playerid, 'Welkom!',
                        'U bent aangenomen bij de gang: ' .. jobnamegang '!', 5000, 'succes')
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

                    if naarJob == 'job' then
                        MySQL.Async.execute(
                            "UPDATE users SET job = @job, job_grade = @grade WHERE identifier = @identifier",
                            {
                                ["@identifier"] = xPlayer2.identifier,
                                ["@job"] = jobnamegang,
                                ["@grade"] = 1
                            }
                        )
                    end
                    if naarJob == 'job2' then
                        MySQL.Async.execute(
                            "UPDATE users SET job2 = @job, job2_grade = @grade WHERE identifier = @identifier",
                            {
                                ["@identifier"] = xPlayer2.identifier,
                                ["@job"] = jobnamegang,
                                ["@grade"] = 1
                            }
                        )
                    end

                    callback(true)
                else
                    TriggerClientEvent('okokNotify:Alert', source, 'Fout', 'Deze persoon zit al bij jouw gang!', 5000,
                        'error')
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
