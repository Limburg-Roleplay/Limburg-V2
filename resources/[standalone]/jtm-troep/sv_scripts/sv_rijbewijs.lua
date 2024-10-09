RegisterServerEvent("jtm-rijbewijs:server:send:rijbewijs")
AddEventHandler(
	"jtm-rijbewijs:server:send:rijbewijs",
	function(playerId)
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local targetPlayer = ESX.GetPlayerFromId(playerId)
		local licenses = ""
		if xPlayer and targetPlayer then
			MySQL.Async.fetchAll(
				"SELECT * FROM user_licenses WHERE owner = @identifier",
				{
					["@identifier"] = xPlayer.identifier
				},
				function(results)
					if results and #results > 0 then
						for i, row in ipairs(results) do
							licenses = licenses .. row.type .. ", "
						end
						TriggerClientEvent("jtm-rijbewijs:client:geefrijbewijs", playerId, GetPlayerName(xPlayer.source), licenses)
						TriggerClientEvent(
							"frp-notifications:client:notify",
							xPlayer.source,
							"success",
							"Je hebt je rijbewijs geven aan de dichtstbijzijnde persoon!",
							3000
						)
					else
						licenses = "Geen"
						TriggerClientEvent("jtm-rijbewijs:client:geefrijbewijs", playerId, GetPlayerName(xPlayer.source), licenses)
						TriggerClientEvent(
							"frp-notifications:client:notify",
							xPlayer.source,
							"success",
							"Je hebt geen rijbewijs om te delen!",
							3000
						)
					end
				end
			)
		end
	end
)
