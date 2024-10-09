local ESX = nil
local payloadFormat = "{ \"username\" : \"%s\", \"avatar_url\" : \"%s\", \"embeds\": [{ \"title\": \"%s\", \"type\": \"rich\", \"description\": \"%s\", \"color\": %d, \"footer\": {\"text\": \"esx_report | Warrnski#2002\"} }]}"
local delay = 0

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


RegisterCommand('reply', function(source, args, rawCommand)
    local commandParts = stringsplit(rawCommand, ' ')
    CancelEvent()

    if tablelength(commandParts) > 2 then
        local targetPlayerId = tonumber(commandParts[2])
        local senderName = GetPlayerName(source)
        local targetName = GetPlayerName(targetPlayerId)
        local message = table.concat(commandParts, ' ', 3)

        local senderPlayer = ESX.GetPlayerFromId(source)

        if senderPlayer.getGroup() ~= Config.defaultUserGroup then
            TriggerClientEvent('esx_report:textmsg', targetPlayerId, source, message, targetName, senderName)
            TriggerClientEvent('esx_report:sendReply', -1, source, message, targetName, senderName)

            local targetPlayerId = tonumber(commandParts[2])
            local targetName = GetPlayerName(targetPlayerId)

		if targetName then
   			 if Config.useDiscord then
    		    	local username = senderName .. ' ['.. source ..']'
     		    SendWebhookMessage(Config.webhookurl, username, "Reply", '-> ' .. targetName .. ' ['.. targetPlayerId ..'] '..':  ' .. message)
   					 end
			 else
   				 TriggerClientEvent("frp-notifications:client:notify", source, "error", "Deze speler is niet online!", 		 "3000")
             end
        else
            TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, 'Insufficient Permissions!')
        end
    end
end, false)

function StartCountingDown()
    delay = 30
    Citizen.CreateThread(function()
        Wait(1)
        while delay > 0 do
            delay = delay - 1
            Citizen.Wait(1000)
        end
    end)
end


local reports = {}
local reportedCooldowns = {} 

function stringsplit(inputstr, sep)
    sep = sep or '%s'
    local t = {}
    for str in string.gmatch(inputstr, '([^'..sep..']+)%s*') do
        table.insert(t, str)
    end
    return t
end

RegisterCommand('report', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local cm = stringsplit(rawCommand, ' ')
    local textmsg = ''

    for _, report in ipairs(reports) do
        if report.src == source and not report.claimed then
            TriggerClientEvent('chatMessage', source, 'SYSTEEM', 'error', "Je hebt al een open report! Wacht tot het is afgehandeld.")
            return
        end
    end

    local lastReportedTime = reportedCooldowns[source] or 0
    local currentTime = os.time()
    local cooldownTime = Config.reportCooldown or 10
    if currentTime - lastReportedTime < cooldownTime then
        local remainingCooldown = cooldownTime - (currentTime - lastReportedTime)
        TriggerClientEvent('chatMessage', source, 'SYSTEEM', 'error', "Je staat nog op cooldown van: " .. remainingCooldown .. " seconden.")
        return
    end

    for i = 1, #cm do
        if i ~= 1 then
            textmsg = (textmsg .. ' ' .. tostring(cm[i]))
        end
    end


    local osTime = os.time()
    local formattedTime = os.date("%H:%M", osTime)
    
    local maxReportId = 0
    for _, report in ipairs(reports) do
        if report.reportid > maxReportId then
            maxReportId = report.reportid
        end
    end
    
    local newReportId = maxReportId + 1
    
    table.insert(reports, {
        reportid = newReportId,
        src = source,
        msg = textmsg,
        claimed = false,
        time = formattedTime
    })

    TriggerClientEvent('esx_report:sendReport', -1, source, playerName, textmsg)
    TriggerClientEvent("wsk-report:client:new:report", -1, playerName, newReportId, textmsg, source, formattedTime)
    TriggerClientEvent('srp-reportcounter:cl:updateCounter', -1, #reports)

    local message = "Speler: " .. playerName .. " [ID: " .. source .. "] heeft een report gemaakt:\n" .. textmsg
    SendWebhookMessage(Config.webhookurl, "Report Log", "Nieuw Report", message)

    reportedCooldowns[source] = currentTime
end, false)


RegisterCommand("reports", function(source, args, rawCommand)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getGroup() ~= 'user' then 
	TriggerClientEvent("wsk-report:client:see:report:list", source)
    else
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Je hebt hier geen permissies voor!!", "3000")
    end
end)

RegisterNetEvent("wsk-report:server:claim:report")
AddEventHandler("wsk-report:server:claim:report", function(reportid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local foundReport = nil
	local player = 0
    for _, report in ipairs(reports) do
        if report.reportid == reportid then
            foundReport = report
			player = report.src
            break
        end
    end

    
    if foundReport then
        foundReport.claimed = xPlayer.identifier
        TriggerClientEvent("wsk-report:client:claimed:report", src, reportid, xPlayer.identifier)

		local zplayer = ESX.GetPlayerFromId(foundReport.src)
		TriggerClientEvent('esx_report:textmsg', player, src, "Je report is geclaimed", GetPlayerName(player), GetPlayerName(src))
        if zplayer and zplayer.coords then
			xPlayer.setCoords(zplayer.coords)
            TriggerClientEvent("wsk-report:client:teleportToPlayer", src, xPlayer.coords.x, xPlayer.coords.y, xPlayer.coords.z)
        else
        end
    end
end)


RegisterNetEvent("wsk-report:server:close:instant:report")
AddEventHandler("wsk-report:server:close:instant:report", function(reportid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local foundIndex = nil
	local player = 0
    for i, report in ipairs(reports) do
        if report.reportid == reportid then
            foundIndex = i
			player = report.src
            break
        end
    end

    if foundIndex then
        TriggerClientEvent('srp-reportcounter:cl:updateCounter', -1, #reports)
        table.remove(reports, foundIndex)
    end

	local zplayer = ESX.GetPlayerFromId(player)
	if zplayer then
		TriggerClientEvent('esx_report:textmsg', player, src, "Je report is gesloten", GetPlayerName(player), GetPlayerName(src))
	end
	
	TriggerClientEvent("wsk-report:client:closed:report", -1, reportid)
end)

-- Event om een report te sluiten en het staff_report_count bij te werken
RegisterNetEvent("wsk-report:server:close:report")
AddEventHandler("wsk-report:server:close:report", function(reportid)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local foundIndex = nil
	local player = 0

    -- Zoeken naar het juiste report in de lokale tabel
    for i, report in ipairs(reports) do
        if report.reportid == reportid then
            foundIndex = i
			player = report.src
            break
        end
    end
    if foundIndex then
        table.remove(reports, foundIndex)
        TriggerClientEvent('srp-reportcounter:cl:updateCounter', -1, #reports)
        
        local zplayer = ESX.GetPlayerFromId(player)
        if zplayer then      
    
  UpdateStaffReportCount(xPlayer.identifier, xPlayer.getName())
  
                
            TriggerClientEvent('esx_report:textmsg', player, src, "Je report is gesloten", GetPlayerName(player), GetPlayerName(src))
        end
        
        TriggerClientEvent("wsk-report:client:closed:report", -1, reportid)
    end
end)

function UpdateStaffReportCount(staff_id, staff_name)
    MySQL.Async.fetchScalar('SELECT report_count FROM staff_report_count WHERE staff_id = @staff_id', {
        ['@staff_id'] = staff_id
    }, function(report_count)
        if report_count then
            MySQL.Async.execute('UPDATE staff_report_count SET report_count = report_count + 1 WHERE staff_id = @staff_id', {
                ['@staff_id'] = staff_id
            }, function(affectedRows)
                if affectedRows > 0 then

                    local message = staff_name .. " heeft een report gesloten. Totaal gesloten reports: " .. (report_count + 1)
                    SendWebhookMessage(Config.webhookurl, "Report Log", "Report Gesloten", message)
                else
                end
            end)
        else
            MySQL.Async.execute('INSERT INTO staff_report_count (staff_name, staff_id, report_count) VALUES (@staff_name, @staff_id, @report_count)', {
                ['@staff_name'] = staff_name,
                ['@staff_id'] = staff_id,
                ['@report_count'] = 1
            }, function(affectedRows)
                if affectedRows > 0 then

                    local message = staff_name .. " heeft een report gesloten. Totaal gesloten reports: 1"
                    SendWebhookMessage(Config.webhookurl, "Report Log", "Report Gesloten", message)
                else
                end
            end)
        end
    end)
end

RegisterCommand('leaderboard', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        MySQL.Async.fetchAll('SELECT staff_name, report_count FROM staff_report_count ORDER BY report_count DESC', {}, function(results)
            local leaderboardData = {}
            local maxReports = 175

            for _, row in ipairs(results) do
                if row.report_count > maxReports then
                    maxReports = row.report_count
                end
            end

            for _, row in ipairs(results) do
                local progress = math.floor((row.report_count / maxReports) * 100)
                table.insert(leaderboardData, {
                    title = row.staff_name,
                    description = 'Reports: ' .. row.report_count,
                    progress = progress
                })
            end

            TriggerClientEvent('esx_report:showLeaderboard', source, leaderboardData)
        end)
    else
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Je hebt hier geen permissies voor!", "3000")
    end
end, false)

ESX.RegisterServerCallback('esx_report:fetchUserRank', function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb('user')
        end
    else
        cb('user')
    end
end)

function SendWebhookMessage(webhookURL, username, title, message)
    local payload = {
        username = username,
        embeds = {{
            title = title,
            description = message,
            color = 16711680, -- Rood, kan je aanpassen naar een andere kleurcode als je wilt
            footer = {
                text = "esx_report",
                icon_url = "https://cdn.discordapp.com/attachments/1058040700064776212/1262478090899292200/Limburg_Roleplay_Blauw.png?ex=66d95198&is=66d80018&hm=772c85eb63d3174a17bd5e2cb39d64b667711dee69b8b03bac483a72dfa99a5b&" -- Optioneel, vervang met een geldige URL voor een afbeelding
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") -- Voeg een timestamp toe
        }}
    }
    
    PerformHttpRequest(webhookURL, function(err, text, headers)
        if err ~= 200 then
        end
    end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end




