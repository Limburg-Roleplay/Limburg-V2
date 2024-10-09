Citizen.CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()
end)

RegisterServerEvent('frp-kmar:server:people:shooted')
AddEventHandler('frp-kmar:server:people:shooted', function(weaponname, cat, coords)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'kmar' then
        TriggerClientEvent('frp-kmar:client:people:shooted', -1, cat, coords)
    end
end)
RegisterServerEvent('frp-kmar:server:remove:item')
AddEventHandler('frp-kmar:server:remove:item', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'kmar' then
		exports.ox_inventory:RemoveItem(xPlayer.source, 'medkit', 1)
	else
		exports["fiveguard"]:fg_BanPlayer(source, "heeft geprobeerd om een item te verwijderen via kmar job zonder kmar job!", true)
	end
end)

RegisterServerEvent('frp-kmar:server:delete:weapon:menu')
AddEventHandler('frp-kmar:server:delete:weapon:menu', function(weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'kmar' then
        exports.ox_inventory:RemoveItem(xPlayer.source, weaponName.weaponName, 1)
		TriggerEvent(
                "td_logs:sendLog",
                "https://discord.com/api/webhooks/1268582819458846852/4KKKaww2WtQJdYgNlNJ2UFEpsfaprcNOI1Wv1-4Ueq9Kn93oqUVSuQVKjp4IgKHTHASN",
                xPlayer.source,
                {
                    title = GetPlayerName(xPlayer.source) .. ' heeft zojuist een wapen verwijderd! Wapen: ' .. weaponName.weaponName,
                    desc = "Job: kmar"
                 },
                0x000001
            )
		
            TriggerClientEvent("frp-notifications:client:notify", xPlayer.source, 'success', 'Wapen succesvol verwijderd!')
    else
        exports["fiveguard"]:fg_BanPlayer(source, "heeft geprobeerd om een wapen te verwijderen via kmar job zonder kmar job!", true)
    end
end)

-- Server
local stash = {
    id = 'personalkmar',
    label = 'Persoonlijke Kluis kmar',
    slots = 100,
    weight = 1000000,
    owner = true
}

RegisterServerEvent('frp-kmar:server:get:id:id')
AddEventHandler('frp-kmar:server:get:id:id', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if xPlayer.job.name == 'kmar' then
        local Identifier = ESX.GetPlayerFromId(playerId).identifier
        MySQL.Async.fetchAll("SELECT type FROM user_licenses WHERE owner = @identifier", { ["@identifier"] = Identifier }, function(result)
            local licenses = {}

            for _, v in ipairs(result) do
                licenses[v.type] = true
            end
            
            local buildData = {
                rijbewijsB = licenses['rijbewijsB'] and "Ja" or "Nee",
                theorie = licenses['theorie'] and "Ja" or "Nee",
                rijbewijsA = licenses['rijbewijsA'] and "Ja" or "Nee"
            }
            
			xPlayer.triggerEvent('frp-kmar:client:show:id:id', buildData)
        end)
    else
        exports["fiveguard"]:fg_BanPlayer(source, "heeft geprobeerd een id te bekijken zonder kmar job!", true)
    end
end)
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
    end
end)


function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

RegisterServerEvent('frp-kmar:server:get:id')
AddEventHandler('frp-kmar:server:get:id', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if xPlayer.job.name == 'kmar' then
        local Identifier = ESX.GetPlayerFromId(playerId).identifier
        MySQL.Async.fetchAll("SELECT firstname, lastname, sex, dateofbirth FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
            xPlayer.triggerEvent('frp-kmar:client:show:id', result[1])
        end)
    else
        exports["fiveguard"]:fg_BanPlayer(source, "heeft geprobeerd een id te bekijken zonder kmar job!", true)
    end
end)

RegisterServerEvent('frp-kmar:server:analyse:fingerprint')
AddEventHandler('frp-kmar:server:analyse:fingerprint', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if xPlayer.job.name == 'kmar' then
        local Identifier = ESX.GetPlayerFromId(playerId).identifier
        MySQL.Async.fetchAll("SELECT firstname, lastname, sex, dateofbirth FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
            xPlayer.triggerEvent('frp-kmar:client:show:fingerprint', result[1])
        end)
    else
        exports["fiveguard"]:fg_BanPlayer(source, "heeft geprobeerd een id te bekijken zonder kmar job!", true)
    end
end)

RegisterServerEvent('frp-kmar:server:noodknop')
AddEventHandler('frp-kmar:server:noodknop', function(weaponname, cat, coords)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local coords = xPlayer.coords
    if xPlayer.job.name == 'kmar' then
        GetRPName(source, function(Firstname, Lastname)
            local volledig = Firstname.." ".. Lastname
			TriggerEvent(
                "td_logs:sendLog",
                "https://discord.com/api/webhooks/1268583039504744458/xwVJAMAKEssLvIH3c2iB8j99nYDhp39vMopyTGUG3QODlBp1d9zxIE9FFfFFniQHQ_v_",
                xPlayer.source,
                {
                    title = GetPlayerName(xPlayer.source) .. ' heeft zojuist een noodknop verstuurd!',
                    desc = "Job: kmar"
                 },
                0x000001
            )
            TriggerClientEvent('frp-kmar:client:noodknop', -1, volledig, coords)
        end)
    end
end)

RegisterServerEvent('frp-kmar:server:buy:weapon')
AddEventHandler('frp-kmar:server:buy:weapon', function(a)
    xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'kmar' then
        if xPlayer.getAccount("bank").money >= a.price then 
            xPlayer.removeAccountMoney('bank', a.price)
            xPlayer.addInventoryItem(a.weaponName, a.count)
            TriggerClientEvent("frp-notifications:client:notify", xPlayer.source, 'success', 'Je hebt succesvol een item gekocht!')
        else
            TriggerClientEvent("frp-notifications:client:notify", xPlayer.source, 'error', 'Je hebt niet genoeg geld!')
        end
    end
end)

-- Boss Menu

-- Define jobs and their respective grades and labels
local jobList = {
    kmar = {
        [1] = "3eklasse",
        [2] = "2eklasse",
        [3] = "1eklasse",
        [4] = "wachtmeester",
        [5] = "wachtmeester1eklasse",
        [6] = "opperwachtmeester",
        [7] = "adjudant",
        [8] = "tweedeluitenant",
        [9] = "eersteluitenant",
        [10] = "kapitein",
        [11] = "majoor",
        [12] = "luitenantkolonel",
        [13] = "kolonel",
        [14] = "brigadegeneraal",
        [15] = "generaalmajoor",
        [16] = "luitenantgeneraal"
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
    "frp-kmar:check:gangmembers",
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
                                grade = getJobGradeLabel("kmar", v.job_grade)
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

RegisterServerEvent("frp-kmar:promotemember")
AddEventHandler(
    "frp-kmar:promotemember",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = "kmar"
        local currentgrade = 1

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
                    ["@job"] = "kmar",
                    ["@job_grade"] = currentgrade,
                    ["@identifier"] = identifierplayer
                }
            )
        else
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = job_grade + 1 WHERE identifier = @identifier",
                {
                    ["@job"] = "kmar",
                    ["@identifier"] = identifierplayer
                }
            )
        end
        if targetPlayer then
            TriggerEvent(
                "td_logs:sendLog",
                "https://discord.com/api/webhooks/1263185812132986920/GTOcgM_X4bHQvTiyIF7vi6a9CxfBxPMRNz4hObVCGFQKHKdCBHvZNFap37QfRbIrUHPa",
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist gepromoveerd door " ..
                            GetPlayerName(xPlayer.source) .. " naar grade: " .. currentgrade,
                    desc = "Job: kmar"
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
                "https://discord.com/api/webhooks/1263185812132986920/GTOcgM_X4bHQvTiyIF7vi6a9CxfBxPMRNz4hObVCGFQKHKdCBHvZNFap37QfRbIrUHPa",
                xPlayer.source,
                {
                    title = voornaamplayer ..
                        " is zojuist gepromoveerd door " .. GetPlayerName(xPlayer.source) .. " naar grade: onbekend",
                    desc = "Job: kmar"
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

RegisterServerEvent("frp-kmar:demote")
AddEventHandler(
    "frp-kmar:demote",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = "kmar"
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
                    ["@job"] = "kmar",
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
                "https://discord.com/api/webhooks/1263185812132986920/GTOcgM_X4bHQvTiyIF7vi6a9CxfBxPMRNz4hObVCGFQKHKdCBHvZNFap37QfRbIrUHPa",
                xPlayer.source,
                {
                    title = GetPlayerName(targetPlayer.source) ..
                        " is zojuist gedemote door " .. GetPlayerName(xPlayer.source) .. " naar grade: " .. currentgrade,
                    desc = "Job: kmar"
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
                "https://discord.com/api/webhooks/1263185812132986920/GTOcgM_X4bHQvTiyIF7vi6a9CxfBxPMRNz4hObVCGFQKHKdCBHvZNFap37QfRbIrUHPa",
                xPlayer.source,
                {
                    title = voornaamplayer ..
                        " is zojuist gedemote door " .. GetPlayerName(xPlayer.source) .. " naar grade: onbekend",
                    desc = "Job: kmar"
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

RegisterServerEvent("frp-kmar:deletemember:serversided")
AddEventHandler(
    "frp-kmar:deletemember:serversided",
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
                "https://discord.com/api/webhooks/1263185812132986920/GTOcgM_X4bHQvTiyIF7vi6a9CxfBxPMRNz4hObVCGFQKHKdCBHvZNFap37QfRbIrUHPa",
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
                "https://discord.com/api/webhooks/1263185812132986920/GTOcgM_X4bHQvTiyIF7vi6a9CxfBxPMRNz4hObVCGFQKHKdCBHvZNFap37QfRbIrUHPa",
                xPlayer.source,
                {
                    title = voornaamplayer .. " is zojuist ontslagen door " .. GetPlayerName(xPlayer.source),
                    desc = "Job: kmar"
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
    "frp-kmar:add:playertogang",
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
                        "Je hebt een nieuw lid aangenomen bij de kmar!",
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
                        "https://discord.com/api/webhooks/1263185812132986920/GTOcgM_X4bHQvTiyIF7vi6a9CxfBxPMRNz4hObVCGFQKHKdCBHvZNFap37QfRbIrUHPa",
                        xPlayer2.source,
                        {
                            title = GetPlayerName(xPlayer2.source) ..
                                " is zojuist aangenomen door " .. GetPlayerName(xPlayer.source),
                            desc = "Job: kmar"
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
                        "Deze persoon zit al bij de kmar!",
                        3000
                    )
                    callback(false)
                end
            end
        )
    end
)