
Citizen.CreateThread(
	function()
		exports["qtarget"]:Player(
			{
				options = {
					{
						event = "jtm-rijbewijs:client:send:rijbewijs",
						icon = "fa-solid fa-id-card",
						label = "Geef rijbewijs"
					}
				},
				distance = 2
			}
		)
	end
)

RegisterNetEvent("jtm-rijbewijs:client:send:rijbewijs")
AddEventHandler(
	"jtm-rijbewijs:client:send:rijbewijs",
	function(data)
		local entity = data.entity
		local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
		local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

		if distance < 2.0 then
			local playerid = GetPlayerServerId(entityPlayer)
			TriggerServerEvent("jtm-rijbewijs:server:send:rijbewijs", playerid)
		else
			ESX.ShowNotification("error", "Deze persoon is niet meer in de buurt!", 3500)
		end
	end
)

RegisterNetEvent("jtm-rijbewijs:client:geefrijbewijs")
AddEventHandler(
	"jtm-rijbewijs:client:geefrijbewijs",
	function(name, type)
		local text = "Naam: " .. name .. "<br>Types: " .. type
		TriggerEvent("chatMessage", "Rijbewijs", "rijbewijs", text)
	end
)