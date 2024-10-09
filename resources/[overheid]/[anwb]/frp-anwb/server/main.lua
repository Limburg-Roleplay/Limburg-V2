ESX = exports["es_extended"]:getSharedObject()

TriggerEvent('esx_phone:registerNumber', 'mechanic', 'mechanic', true, true)
TriggerEvent('esx_society:registerSociety', 'mechanic', 'mechanic', 'society_mechanic', 'society_mechanic', 'society_mechanic', {type = 'public'})

RegisterServerEvent('frp-anwb:server:repair:vehicle')
AddEventHandler('frp-anwb:server:repair:vehicle', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('repairkit', 1)
	TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263186628504059996/KNzQNj5Xyof4yFSU7Cm9wdh2r6_SADO3zQsXsibfCLXq3Dt8bf219A1n8B1rM9EtNsm0', xPlayer.source, {title= GetPlayerName(xPlayer.source) .. " heeft zojuist zijn auto gerepareerd", desc = tostring(xPlayer.getCoords(true)) }, 0x000001)
end)

RegisterServerEvent('frp-anwb:server:wash:vehicle')
AddEventHandler('frp-anwb:server:wash:vehicle', function()
    local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('washand', 1)
end)

-- Boss Menu

-- Define jobs and their respective grades and labels
local jobList = {
    anwb = {
        [1] = "Stagair",
        [2] = "Monteur in Opleiding",
        [3] = "Monteur",
        [4] = "Eerste Monteur",
        [5] = "Hoofd Monteur",
        [6] = "Leermeester",
        [7] = "Teamleider In Opleiding",
        [8] = "Teamleider",
        [9] = "Directeur",
        [10] = "Hoofd Directeur"
    }
}

function getJobGradeLabel(jobName, gradeNumber)
    if not jobList[jobName] then
        return nil, "Job not found"
    end
    local label = jobList[jobName][gradeNumber]
    if not label then
        return nil, "Grade not found"
    end
    return label, nil
end
ESX.RegisterServerCallback(
    "frp-anwb:check:gangmembers",
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
                                grade = getJobGradeLabel("anwb", v.job_grade)
                            }
                        )
                    end
                    callback(ganginfo)
                else
                    TriggerClientEvent(
                        "frp-notifications:client:notify",
                        source,
                        "error",
                        "Je bedrijf heeft geen Medwerkers!",
                        3000
                    )
                end
            end
        )
    end
)

RegisterServerEvent("frp-anwb:promotemember")
AddEventHandler(
    "frp-anwb:promotemember",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = "mechanic"
        local currentgrade = 1

        if targetPlayer then
            currentjob = targetPlayer.job.name
            currentgrade = targetPlayer.job.grade + 1
            if currentgrade > 10 then
                currentgrade = 10
            end
            targetPlayer.setJob(currentjob, currentgrade)
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier",
                {
                    ["@job"] = "mechanic",
                    ["@job_grade"] = currentgrade,
                    ["@identifier"] = identifierplayer
                }
            )
        else
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = job_grade + 1 WHERE identifier = @identifier",
                {
                    ["@job"] = "mechanic",
                    ["@identifier"] = identifierplayer
                }
            )
        end
        if targetPlayer then
            TriggerEvent(
                "td_logs:sendLog",
                "https://discord.com/api/webhooks/1263186787866640527/rDYhN4vFdd_jyO7j2z4IkE7DDLb_8tPg6nQGuPppxw87UEP-MdnGxyMFiumoB9qvFpuP",
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist gepromoveerd door " ..
                            GetPlayerName(xPlayer.source) .. " naar grade: " .. currentgrade,
                    desc = "Job: ANWB"
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
                "https://discord.com/api/webhooks/1263186787866640527/rDYhN4vFdd_jyO7j2z4IkE7DDLb_8tPg6nQGuPppxw87UEP-MdnGxyMFiumoB9qvFpuP",
                xPlayer.source,
                {
                    title = voornaamplayer ..
                        " is zojuist gepromoveerd door " .. GetPlayerName(xPlayer.source) .. " naar grade: onbekend",
                    desc = "Job: ANWB"
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

RegisterServerEvent("frp-anwb:demote")
AddEventHandler(
    "frp-anwb:demote",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = "mechanic"
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
                    ["@job"] = "mechanic",
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
                "https://discord.com/api/webhooks/1263186787866640527/rDYhN4vFdd_jyO7j2z4IkE7DDLb_8tPg6nQGuPppxw87UEP-MdnGxyMFiumoB9qvFpuP",
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist gedemote door " .. GetPlayerName(xPlayer.source) .. " naar grade: " .. currentgrade,
                    desc = "Job: Politie"
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
                "https://discord.com/api/webhooks/1263186787866640527/rDYhN4vFdd_jyO7j2z4IkE7DDLb_8tPg6nQGuPppxw87UEP-MdnGxyMFiumoB9qvFpuP",
                xPlayer.source,
                {
                    title = voornaamplayer ..
                        " is zojuist gedemote door " .. GetPlayerName(xPlayer.source) .. " naar grade: onbekend",
                    desc = "Job: Politie"
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

RegisterServerEvent("frp-anwb:deletemember:serversided")
AddEventHandler(
    "frp-anwb:deletemember:serversided",
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
                "https://discord.com/api/webhooks/1263186787866640527/rDYhN4vFdd_jyO7j2z4IkE7DDLb_8tPg6nQGuPppxw87UEP-MdnGxyMFiumoB9qvFpuP",
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist ontslagen door " .. GetPlayerName(xPlayer.source),
                    desc = "Job: ANWB"
                },
                0x000001
            )
        else
            TriggerEvent(
                "td_logs:sendLog",
                "https://discord.com/api/webhooks/1263186787866640527/rDYhN4vFdd_jyO7j2z4IkE7DDLb_8tPg6nQGuPppxw87UEP-MdnGxyMFiumoB9qvFpuP",
                xPlayer.source,
                {
                    title = voornaamplayer .. " is zojuist ontslagen door " .. GetPlayerName(xPlayer.source),
                    desc = "Job: ANWB"
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
    "frp-anwb:add:playertogang",
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
                        "Je hebt een nieuw lid aangenomen bij de politie!",
                        3000
                    )
                    TriggerClientEvent(
                        "frp-notifications:client:notify",
                        playerid,
                        "success",
                        "Je bent aangenomen bij de " .. jobnamegang,
                        3000
                    )
                    TriggerEvent(
                        "td_logs:sendLog",
                        "https://discord.com/api/webhooks/1263186787866640527/rDYhN4vFdd_jyO7j2z4IkE7DDLb_8tPg6nQGuPppxw87UEP-MdnGxyMFiumoB9qvFpuP",
                        xPlayer2.source,
                        {
                            title = GetPlayerName(xPlayer2.source) ..
                                " is zojuist aangenomen door " .. GetPlayerName(xPlayer.source),
                            desc = "Job: ANWB"
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
                        "Deze persoon zit al bij de anwb!",
                        3000
                    )
                    callback(false)
                end
            end
        )
    end
)
