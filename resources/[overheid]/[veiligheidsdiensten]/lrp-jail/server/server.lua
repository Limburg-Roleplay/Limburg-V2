ESX = nil 
ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("unjail", function(src, args)
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getGroup() == "staff" or xPlayer.getGroup() == "owner" or xPlayer.getGroup() == "hogerop" then

        local jailPlayer = args[1]

        if GetPlayerName(jailPlayer) ~= nil then
            UnJail(jailPlayer)
        else
            TriggerClientEvent('okokNotify:Alert', src, 'Gevangenis', "Deze tijd is ongeldig!", 3000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', src, 'Gevangenis', "Je hebt geen rechten om dit te doen!", 3000, 'error')
    end
end)


RegisterServerEvent("lrp-jail:jailPlayer")
AddEventHandler("lrp-jail:jailPlayer", function(targetSrc, jailTime, jailReason)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetSrc = tonumber(targetSrc)
    local TargetPlayer = ESX.GetPlayerFromId(targetSrc)

    if not TargetPlayer then
        print("Error: Target player is niks")
        return
    end

    if xPlayer["job"]["name"] == "police" or xPlayer["job"]["name"] == "kmar" then
        JailPlayer(targetSrc, jailTime)
        TriggerClientEvent('okokNotify:Alert', source, 'Gevangenis', GetPlayerName(targetSrc) .. " is gejailed voor " .. jailTime .. " minuten!", 3000, 'success')

		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div class="bubble-message" style="background-color: rgba(249, 166, 0, 0.4); border-radius: 5px;"><i class="fas fa-user-alt-slash"></i> <b>{0}</b>: <br> {1}</div>',
			args = { "RECHTER", GetPlayerName(targetSrc) .. " is naar de gevangenis gestuurd met de reden: " .. tostring(jailReason) }
		})		

        local Time = os.date("%Y-%m-%d %H:%M:%S")
        local steamName = GetPlayerName(source)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.identifier
        local rockstarLicense = xPlayer.getIdentifier('license')

        local TargetsteamName = GetPlayerName(targetSrc)
        local TargetplayerName = TargetPlayer.getName()
        local TargetsteamID = TargetPlayer.identifier
        local TargetrockstarLicense = TargetPlayer.getIdentifier('license')

        local logMessage = 
        "Tijd en Datum: " .. Time .. "\n" ..
        "\n" ..
        "In gevangenis gezet door: " .. tostring(playerName) .. "\n" ..
        "Steam Naam: " .. tostring(steamName) .. "\n" ..
        "Steam ID: " .. tostring(steamID) .. "\n" ..
        "Rockstar License: " .. tostring(rockstarLicense) .. "\n" ..
        "\n" ..
        "Gevangen persoon: " .. tostring(TargetplayerName) .. "\n" ..
        "Steam Naam: " .. tostring(TargetsteamName) .. "\n" ..
        "Steam ID: " .. tostring(TargetsteamID) .. "\n" ..
        "Rockstar License: " .. tostring(TargetrockstarLicense) .. "\n" ..
        "\n" ..
        "Gevangen Tijd: " .. tostring(jailTime) .. " Minuten" .. "\n" ..
        "Gevangen Reden: " .. tostring(jailReason) .. "\n"

		TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263510824392065188/9rzNh2PaaI_RwLXc-pp_riunyFayhm2WSYmoLncRSRyHhKfzSYGAVVvIbXuc3_Q6v_GD', source, {
            title = "Gevangen Logs",
            desc = logMessage
        })
    end
end)


RegisterServerEvent("lrp-jail:unJailPlayer")
AddEventHandler("lrp-jail:unJailPlayer", function(targetIdentifier)
	local xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)

	if xPlayer ~= nil then
		UnJail(xPlayer.source)
	else
		MySQL.Async.execute(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
	end

	local Time = os.date("%Y-%m-%d %H:%M:%S")
	local steamName = GetPlayerName(source)
	local playerName = xPlayer.getName()
	local steamID = xPlayer.identifier
	local rockstarLicense = xPlayer.getIdentifier('license')

	local logMessage = 
	"Tijd en Datum: " .. Time .. "\n" ..
	"\n" ..
	"Vrijgelaten persoon: " .. tostring(playerName) .. "\n" ..
	"Steam Naam: " .. tostring(steamName) .. "\n" ..
	"Steam ID: " .. tostring(steamID) .. "\n" ..
	"Rockstar License: " .. tostring(rockstarLicense) .. "\n"

	TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263510824392065188/9rzNh2PaaI_RwLXc-pp_riunyFayhm2WSYmoLncRSRyHhKfzSYGAVVvIbXuc3_Q6v_GD', source, {
		title = "Vrijgelaten Logs",
		desc = logMessage
	})

	TriggerClientEvent('okokNotify:Alert', source, 'Gevangenis', xPlayer.name .. "Is uit de gevangenis gezet!", 3000, 'success')
end)

RegisterServerEvent("lrp-jail:updateJailTime")
AddEventHandler("lrp-jail:updateJailTime", function(newJailTime)
	EditJailTime(source, newJailTime)
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("lrp-jail:jailPlayer", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("lrp-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Identifier = xPlayer.identifier

	MySQL.Async.execute("UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, 
	function(result)
		data(result[1].firstname, result[1].lastname)
	end)
end

ESX.RegisterServerCallback("lrp-jail:retrieveJailedPlayers", function(source, cb)
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("lrp-jail:retrieveJailTime", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local Identifier = xPlayer.identifier

    MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		if result[1] and result[1].jail then
            local JailTime = tonumber(result[1].jail) or 0

            if JailTime > 0 then
                cb(true, JailTime)
            else
                cb(false, 0)
            end
        else
            cb(false, 0)
        end
    end)
end)
