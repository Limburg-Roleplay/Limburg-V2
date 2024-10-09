Citizen.CreateThread(function()
    exports['qtarget']:Player({
		options = {
            {
				event = 'jtm-idkaart:client:send:idkaart',
                icon = 'fa-solid fa-id-card',
				label = 'Geef Id kaart'
			},
		},
		distance = 2
	})
end)

RegisterNetEvent('jtm-idkaart:client:send:idkaart')
AddEventHandler('jtm-idkaart:client:send:idkaart', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
	local entityPlayer = ESX.Game.GetPlayerFromPed(entity)
    local options = {}

	if distance < 2.0 then 
		local playerid = GetPlayerServerId(entityPlayer)
        TriggerServerEvent("jtm-idkaart:server:send:idkaart", playerid)
	else
		ESX.ShowNotification('error', 'Deze persoon is niet meer in de buurt!', 3500)
	end
end)


RegisterNetEvent('jtm-idkaart:client:geefidkaart')
AddEventHandler('jtm-idkaart:client:geefidkaart', function(firstname, lastname, sex, dob, height)
    local text = "Naam: " .. firstname .. "<br>Achternaam: " .. lastname .. "<br>Geslacht: " .. sex .. "<br>Geboortedatum: " .. dob .. "<br>Lengte: " .. height
    TriggerEvent('chatMessage', 'IDkaart', 'idkaart', text)
end)

Citizen.CreateThread(function()
    while not ESX.PlayerLoaded do Citizen.Wait(10) end
    while true do
        local sleep = 500
        if IsControlJustReleased(0, 167) then
            FRP.Functions.openF6Menu()
        end
        Citizen.Wait(sleep)
    end
end)