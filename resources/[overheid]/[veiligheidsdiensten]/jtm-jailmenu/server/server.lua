ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("jail", function(src, args, raw)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" or xPlayer["job"]["name"] == "kmar" then

		local jailPlayer = args[1]
		local jailTime = tonumber(args[2])
		local jailReason = args[3]

		if GetPlayerName(jailPlayer) ~= nil then

			if jailTime ~= nil then
				JailPlayer(jailPlayer, jailTime)

            TriggerClientEvent("frp-notifications:client:notify", source, "success", GetPlayerName(targetSrc) .. " Gejailed voor " .. jailTime .. " minutes!", 3000)
				
				if args[3] ~= nil then
					GetRPName(jailPlayer, function(Firstname, Lastname)
						TriggerClientEvent('chat:addMessage', -1, {
							template = '<div class="bubble-message" style="background-color: rgba(249, 166, 0, 0.4); border-radius: 5px;"><i class="fas fa-user-alt-slash"></i> <b>{0}</b>: <br> {1}</div>',
							args = { "RECHTER",  Firstname .. " " .. Lastname .. " is naar de gevangenis gestuurd met de reden: " .. args[3] }
						})
					end)
				end
			else
                 TriggerClientEvent("frp-notifications:client:notify", source, "error", "Deze tijd is ongeldig!", 3000)
			end
		else
           TriggerClientEvent("frp-notifications:client:notify", source, "error", "De opgegeven id is niet online!", 3000)
		end
	else
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Je bent geen politie!", 3000)
	end
end)

RegisterCommand("unjail", function(src, args)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" or xPlayer["job"]["name"] == "kmar" then

		local jailPlayer = args[1]

		if GetPlayerName(jailPlayer) ~= nil then
			UnJail(jailPlayer)
		else
			TriggerClientEvent("frp-notifications:client:notify", source, "error", "Deze tijd is ongeldig!", 3000)
		end
	else
        TriggerClientEvent("frp-notifications:client:notify", source, "error", "Je bent geen politie!", 3000)
	end
end)

RegisterServerEvent("Kaas_Gevangenis:jailPlayer")
AddEventHandler("Kaas_Gevangenis:jailPlayer", function(targetSrc, jailTime, jailReason)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local targetSrc = tonumber(targetSrc)

    if xPlayer["job"]["name"] == "police" or xPlayer["job"]["name"] == "kmar" then
        -- Jail the target player
        JailPlayer(targetSrc, jailTime)

        -- Get the role-play name of the target player and announce the jailing in the chat
        GetRPName(targetSrc, function(Firstname, Lastname)
            TriggerClientEvent('chat:addMessage', -1, { args = { "Rechter",  Firstname .. " " .. Lastname .. " zit nu "  .. jailTime .. " minuten vast voor " .. jailReason }, color = { 249, 166, 0 } })
        end)

        -- Notify the police officer
        TriggerClientEvent("frp-notifications:client:notify", src, "success", GetPlayerName(targetSrc) .. " is gejailed voor " .. jailTime .. " minuten!", 3000)
    else
        -- Handle unauthorized attempt to jail a player
        exports["FIVEGUARD"]:screenshotPlayer(src, function(url)
            print("Got URL of screenshot: " .. url .. " from player: " .. src)
        end)
        return exports["FIVEGUARD"]:fg_BanPlayer(src, "Suspicious activity detected: Player ID " .. src .. " probeerde iemand te jailen", true)
    end
end)


RegisterServerEvent("Kaas_Gevangenis:unJailPlayer")
AddEventHandler("Kaas_Gevangenis:unJailPlayer", function(targetIdentifier)
	local src = source
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

   TriggerClientEvent("frp-notifications:client:notify", source, "success", xPlayer.name .. "Is Geunjailed!", 3000)
end)

RegisterServerEvent("Kaas_Gevangenis:updateJailTime")
AddEventHandler("Kaas_Gevangenis:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("Kaas_Gevangenis:jailPlayer", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("Kaas_Gevangenis:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier

	MySQL.Async.execute(
       "UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

ESX.RegisterServerCallback("Kaas_Gevangenis:retrieveJailedPlayers", function(source, cb)
	
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("Kaas_Gevangenis:retrieveJailTime", function(source, cb)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		local JailTime = tonumber(result[1].jail)

		if JailTime > 0 then

			cb(true, JailTime)
		else
			cb(false, 0)
		end

	end)
end)