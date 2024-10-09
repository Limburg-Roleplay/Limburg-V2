FRP = { ['Functions'] = {} }

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
end)

Citizen.CreateThread(function()
	for i=1, #Config.Locations do 
		if Config.Locations[i]['Blip'] then 
			washPos = Config.Locations[i]['Coords']

			blip = AddBlipForCoord(washPos)
			SetBlipSprite(blip, 100)
			SetBlipScale(blip, 0.8)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString('Wasstraat')
			EndTextCommandSetBlipName(blip)
		end
	end
end)

Citizen.CreateThread(function()
	while true do 
		local sleep = 750
		local coords = GetEntityCoords(PlayerPedId())

		local washDist = #(coords - washPos)

		for i=1, #Config.Locations do 
			washPos = Config.Locations[i]['Coords']
			washDist = #(coords - washPos)

			if washDist < 15.0 and IsPedSittingInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then 
				sleep = 0
				ESX.Game.Utils.DrawMarker(washPos, 21, 0.2, 227, 173, 48)
				if washDist < 2.5 and IsPedSittingInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then 
					exports['frp-interaction']:Interaction('success', '[E] - Voertuig wassen', washPos, 2.5, GetCurrentResourceName())
					if IsControlJustPressed(0, 38) then 
						FRP.Functions.washVehicle()
					end
				end
			end
		end

		Citizen.Wait(sleep)
	end
end)

FRP.Functions.washVehicle = function()
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	local dirtLevel = GetVehicleDirtLevel(veh)
	print(dirtLevel)
	-- Check if vehicle is already clean
	if dirtLevel <= 0.2 then
		ESX.ShowNotification('info', 'Je voertuig is al schoon!')
		return
	end

	-- Trigger server callback to check payment
	ESX.TriggerServerCallback('frp-carwash:checkPayment', function(hasEnoughMoney)
		if hasEnoughMoney then
			SetVehicleDirtLevel(veh, 0.1) -- Clean the vehicle
			ESX.ShowNotification('success', 'Je hebt €250 betaald om je auto te wassen!')
		else
			ESX.ShowNotification('error', 'Je hebt niet genoeg geld om je auto te wassen.')
		end
	end)
end
