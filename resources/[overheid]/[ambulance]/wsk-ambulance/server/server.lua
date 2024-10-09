ESX = exports["es_extended"]:getSharedObject()
plyRequests = {}

local weapon = nil

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if plyRequests[playerId] then
		plyRequests[playerId] = nil
		TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, true)
	end
end)

sqlSetStatus = function(id, isDead)
	local xPlayer = ESX.GetPlayerFromId(id)
	if isDead then
		isDead = 1
	else
		isDead = 0
	end
	MySQL.Async.execute('UPDATE users SET is_dead = @is_dead WHERE identifier = @identifier', {
		['@is_dead'] = isDead,
		['@identifier'] = xPlayer.identifier
	})
end

RegisterServerEvent('wasabi_ambulance:setDeathStatus')
AddEventHandler('wasabi_ambulance:setDeathStatus', function(isDead)
	Player(source).state.dead = isDead
	if not isDead then
		Player(source).state.injury = nil
		if plyRequests[source] then
			plyRequests[source] = nil
			TriggerClientEvent('wasabi_ambulance:syncRequests', -1, plyRequests, true)
		end
	end
	sqlSetStatus(source, isDead)
end)

RegisterServerEvent('wsk-ambulance:server:revive:player')
AddEventHandler('wsk-ambulance:server:revive:player', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xTarget then
        print("Target player with ID " .. tostring(targetId) .. " not found.")
        TriggerClientEvent('esx:showNotification', source, 'Target player not found.')
        return
    end

    TriggerClientEvent('wsk-ambulance:client:staffrevive:player', xTarget.source)
end)

RegisterServerEvent('wsk-ambulance:startKnockoutTimer')
AddEventHandler('wsk-ambulance:startKnockoutTimer', function()
	local _src = source
	local currentGameTime = GetGameTimer()

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			if GetGameTimer() - currentGameTime >= 30000 then
                lib.notify(_src, {
                    title = 'Bewusteloos',
                    description = 'Je bent weer bij bewust!',
                    type = 'success'
                })
				TriggerClientEvent('wsk-ambulance:stopKnockout', _src)
				break
			end
		end
	end)
end)
RegisterServerEvent('wsk-ambulance:server:heal:player')
AddEventHandler('wsk-ambulance:server:heal:player', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xJob = xPlayer.job.name
    
    if xJob == 'ambulance' then
        if xPlayer.source == targetId then
            exports["FIVEGUARD"]:screenshotPlayer(xPlayer.source, function(url)
                print("Got URL of screenshot: " .. url .. " from player: " .. xPlayer.source)
            end)
            exports["FIVEGUARD"]:fg_BanPlayer(xPlayer.source, "Suspicious activity detected: Player ID " .. xPlayer.source .. " Probeerde Zichzelf te healen", true)
        else
            TriggerClientEvent('wasabi_ambulance:heal', targetId, true)
        end
    else
        dropPlayer(source, "hackertje")
    end
end)


RegisterServerEvent('wsk-ambulance:donecpr')
AddEventHandler('wsk-ambulance:donecpr', function(xTarget)
	TriggerClientEvent('medSystem:donecpr', xTarget)
end)

ESX.RegisterServerCallback('wasabi_ambulance:checkDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
		cb(isDead)
	end)
end)

ESX.RegisterServerCallback('wsk-ambulance:server:callback:get:death:status', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
		cb(isDead)
	end)
end)

ESX.RegisterServerCallback('wasabi_ambulance:tryRevive', function(source, cb, cost, max, account)
	local xPlayers = ESX.GetPlayers()
	local ems = 0
	for i = 1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'ambulance' then
			ems = ems + 1
		end
	end
	if max then
		if ems > max then
			cb('max')
			return
		end
	end
	if cost then
		local xPlayer = ESX.GetPlayerFromId(source)
		local xFunds = xPlayer.getAccount(account).money
		if xFunds < cost then
			cb(false)
		else
			xPlayer.removeAccountMoney(account, cost)
			TriggerClientEvent('wasabi_ambulance:revive', source)
			cb('success')
		end
	else
		TriggerClientEvent('wasabi_ambulance:revive', source)
		cb('success')
	end
end)


ESX.RegisterCommand('reviveall', 'admin', function(xPlayer, args, showError)
	for _, playerId in ipairs(GetPlayers()) do
		if Player(playerId).state.dead then
			TriggerClientEvent('wsk-ambulance:client:staffrevive:player', playerId)
		end
	end
end, false)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
	if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
		return
	end

	if eventData.id == -1 then
		for _, playerId in ipairs(GetPlayers()) do
			if Player(playerId).state.dead then
				TriggerClientEvent('wsk-ambulance:client:staffrevive:player', playerId)
			end
		end
	else
		if Player(eventData.id).state.dead then
			TriggerClientEvent('wsk-ambulance:client:staffrevive:player', eventData.id)
		end
	end
end)

ESX.RegisterCommand('revive', {'admin', 'mod', 'staff'}, function(xPlayer, args, showError)
	args.playerId.triggerEvent('wsk-ambulance:client:staffrevive:player')
end, true, {
	help = 'Een command om een speler te reviven',
	validate = true,
	arguments = {
		{ name = 'playerId', help = 'Speler id', type = 'player' }
	}
})

RegisterServerEvent('wsk-ambulance:server:getGear')
AddEventHandler('wsk-ambulance:server:getGear', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'ambulance' then
		if xPlayer.getMoney() > 500 then
			xPlayer.removeMoney(500)
			xPlayer.addInventoryItem('radio', 1)
		else
			TriggerClientEvent('frp-notifications:client:notify', source, 'error', 'Je hebt hier niet genoeg geld voor!', 5000)
		end
	else
		DropPlayer('Doei doei')
	end
end)

RegisterServerEvent('wsk-ambulance:removeItemsOnDeath')
AddEventHandler('wsk-ambulance:removeItemsOnDeath', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() > 0 then
        xPlayer.removeMoney(xPlayer.getMoney())
    end
    if xPlayer.getAccount('black_money').money > 0 then
        xPlayer.removeAccountMoney('black_money', xPlayer.getAccount('black_money').money)
    end
     exports.ox_inventory:ClearInventory(source)
end)


-------------------------- medsysyem ---------------------
local killdByWeapon = {}

RegisterServerEvent('medSystem:print', function(req, pulse, area, blood, a, b, c, bleeding)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	Wait(100)
	local xPlayers = ESX.GetPlayers()
	local weapon = killdByWeapon[_source]
	print(weapon)
	for i = 1, #xPlayers, 1 do
		TriggerClientEvent('medSystem:near', xPlayers[i], a, b, c, pulse, blood, _source, area, bleeding, weapon)
		--TriggerClientEvent('medSystem:me', req)
	end
end)

RegisterServerEvent('wsk-ambulance:death')
AddEventHandler('wsk-ambulance:death', function(PlayerId, weapon)
	print(PlayerId, weapon)
	if weapon ~= nil and weapon ~= "" then
		killdByWeapon[PlayerId] = weapon
	else
		killdByWeapon[PlayerId] = "Unknown"
	end
end)

RegisterCommand('med', function(source, args)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'ambulance' then
		if args[1] ~= nil then
			TriggerClientEvent('medSystem:send', args[1], source)
		else
			TriggerClientEvent('chatMessage',xPlayer.source, 'SYSTEEM', 'error',  'Onjuiste spelers-ID!')
		end
	elseif xPlayer.job.name == 'police' then
		if args[1] ~= nil then
			TriggerClientEvent('medSystem:send', args[1], source)
		else
			TriggerClientEvent('chatMessage',xPlayer.source, 'SYSTEEM', 'error',  'Onjuiste spelers-ID!')
		end
	elseif xPlayer.job.name == 'kmar' then
		if args[1] ~= nil then
			TriggerClientEvent('medSystem:send', args[1], source)
		else
			TriggerClientEvent('chatMessage',xPlayer.source, 'SYSTEEM', 'error',  'Onjuiste spelers-ID!')
		end
	else
		TriggerClientEvent('chatMessage',xPlayer.source, 'SYSTEEM', 'error',  'Je hebt geen permissies hier voor')
	end
end, false)

-- Boss Menu

local jobList = {
    ambulance = {
        [1] = "In Opleiding",
        [2] = "Ondersteunend Personeel",
        [3] = "Broeder",
        [4] = "Verpleegkundige",
        [5] = "Specialist",
        [6] = "Geneeskundige",
        [7] = "Hoofd Geneeskunde"
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
    "frp-ambulance:check:gangmembers",
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
                                grade = getJobGradeLabel("ambulance", v.job_grade)
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

RegisterServerEvent("frp-ambulance:promotemember")
AddEventHandler(
    "frp-ambulance:promotemember",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = "ambulance"
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
                    ["@job"] = "ambulance",
                    ["@job_grade"] = currentgrade,
                    ["@identifier"] = identifierplayer
                }
            )
        else
            MySQL.Async.execute(
                "UPDATE users SET job = @job, job_grade = job_grade + 1 WHERE identifier = @identifier",
                {
                    ["@job"] = "ambulance",
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
                    desc = "Job: Ambulance"
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
                    desc = "Job: Ambulance"
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

RegisterServerEvent("frp-ambulance:demote")
AddEventHandler(
    "frp-ambulance:demote",
    function(identifierplayer, voornaamplayer)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local playerHex = string.gsub(tostring(GetPlayerIdentifier(src)), "license:", "")
        local targetPlayer = ESX.GetPlayerFromIdentifier(identifierplayer)
        local currentjob = "ambulance"
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
                    ["@job"] = "ambulance",
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
                    desc = "Job: Ambulance"
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
                    desc = "Job: Ambulance"
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

RegisterServerEvent("frp-ambulance:deletemember:serversided")
AddEventHandler(
    "frp-ambulance:deletemember:serversided",
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
                    desc = "Job: Ambulance"
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
                    desc = "Job: Ambulance"
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
    "frp-ambulance:add:playertogang",
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
                        "Je hebt een nieuw lid aangenomen bij de Ambulance!",
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
                            desc = "Job: Ambulance"
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
                        "Deze persoon zit al bij de Ambulance!",
                        3000
                    )
                    callback(false)
                end
            end
        )
    end
)
-- server.lua

-- Function to get player's license by server ID and remove the "license:" prefix
function getPlayerLicense(serverId)
    local identifiers = GetPlayerIdentifiers(serverId)
    for _, id in ipairs(identifiers) do
        -- Look for the "license" identifier
        if string.match(id, "^license:") then
            -- Remove the "license:" prefix
            return string.sub(id, 9)  -- Removes the first 8 characters ("license:")
        end
    end
    return nil
end

-- Function to reset the player's inventory in the database if they are marked as dead
function resetPlayerInventory(identifier, source, reason)
    local fetchQuery = "SELECT is_dead, inventory FROM users WHERE identifier = @identifier"
    MySQL.Async.fetchAll(
        fetchQuery,
        {["@identifier"] = identifier},
        function(result)
            if result[1] then
                local isDead = result[1].is_dead
                local oldInventory = result[1].inventory
                --print(isDead)
                -- Log the old inventory

                if isDead then
                    
                   -- print("Old Inventory for [" .. identifier .. "]: " .. oldInventory)
                    local updateQuery = "UPDATE users SET inventory = '[]' WHERE identifier = @identifier"
                    MySQL.Async.execute(
                        updateQuery,
                        {["@identifier"] = identifier},
                        function(affectedRows)
                            if affectedRows > 0 then
                               -- print("[" .. identifier .. "] Inventory has been reset.")
                                if source ~= 0 then
                                    TriggerClientEvent(
                                        "chat:addMessage",
                                        source,
                                        {
                                            args = {
                                                "Server",
                                                "Inventory has been reset for identifier: " .. identifier
                                            }
                                        }
                                    )
                                end
                                local user = "console"
                                if source > 0 then
                                    user = GetPlayerName(source)
                                end
                                TriggerEvent(
                                    "td_logs:sendLogNoFields",
                                    "https://discord.com/api/webhooks/1278422407329353810/ndcQyojPz_iBVQRu_J7N1lMxOffKAz2pNp2Un0HuujXx4oO_6gqIH1ceojkv8Qb818ZB",
                                    {
                                        title = identifier ..
                                            " zijn inventory is zojuist gecleared door het combatlog systeem",
                                        desc = "Oude Inventory: " .. json.encode(oldInventory) .. "\n Reden: " .. reason
                                    },
                                    0xffffff
                                )
                            else
                               -- print("No user found with that identifier or unable to reset inventory.")
                                if source ~= 0 then
                                    TriggerClientEvent(
                                        "chat:addMessage",
                                        source,
                                        {
                                            args = {
                                                "Server",
                                                "No user found with that identifier or unable to reset inventory."
                                            }
                                        }
                                    )
                                end
                            end
                        end
                    )
                else
                    --print("Player with identifier [" .. identifier .. "] is not marked as dead.")
                    if source ~= 0 then
                        TriggerClientEvent(
                            "chat:addMessage",
                            source,
                            {
                                args = {"Server", "Player with identifier [" .. identifier .. "] is not marked as dead."}
                            }
                        )
                    end
                end
            else
                --print("No user found with that identifier.")
                if source ~= 0 then
                    TriggerClientEvent(
                        "chat:addMessage",
                        source,
                        {
                            args = {"Server", "No user found with that identifier."}
                        }
                    )
                end
            end
        end
    )
end

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local license = getPlayerLicense(playerId)
    --print("Reason: " .. reason)
    --print("License: " .. tostring(license))

    -- Only reset inventory if the reason is not "Exiting"
    --if reason == "Exiting" then
        Citizen.CreateThread(function()
            Citizen.Wait(1000)  -- Wait a moment to ensure player data is properly synced

            -- Directly use database check for is_dead status
            resetPlayerInventory(license, playerId, reason)
        end)
    --end
end)
