local bank = 0

Citizen.CreateThread(function()
	for i=1, #Config.ATM.Props do
		exports.qtarget:AddTargetModel(GetHashKey(Config.ATM.Props[i]), {
			options = {
				{
					action = function() openGui() end,
					icon = "fa-solid fa-credit-card",
					label = "Open Pinautomaat",
				},
			},
			distance = 2.5
		})
	end
end)

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
-- Banks
local banks = {
	{['name'] = "Bank", ['coords'] = vector3(150.266, -1040.203, 29.374)},
	{['name'] = "Bank", ['coords'] = vector3(-1212.980, -330.841, 37.787)},
	{['name'] = "Bank", ['coords'] = vector3(-2962.582, 482.627, 15.703)},
	{['name'] = "Bank", ['coords'] = vector3(-109.2844, 6468.8804, 31.6341)},
	{['name'] = "Bank", ['coords'] = vector3(314.187, -278.621, 54.170)},
	{['name'] = "Bank", ['coords'] = vector3(237.3780, 217.8007, 106.2868)},
}
  
  -- Display Map Blips
Citizen.CreateThread(function()
	for k,v in pairs(banks) do
		v.blip = AddBlipForCoord(v.coords)
		SetBlipSprite(v.blip, 207)
		SetBlipScale(v.blip, 0.8)
		SetBlipAsShortRange(v.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.name)
		EndTextCommandSetBlipName(v.blip)
	end
end)

Citizen.CreateThread(function()
    while not ESX.PlayerLoaded do Wait(0) end
    while true do
        local sleep = 500
        local coords = GetEntityCoords(PlayerPedId())
		for i=1, #banks do
			if banks[i]['coords'] then
				local dist = #(coords-banks[i]['coords'])
				if dist <= 10.0 then
					sleep = 0
					DrawMarker(2, banks[i]['coords'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.3, 0.2, 255,255,255, 100, false, true, 2, true, nil, nil, false)
					if dist <= 2 then
						exports['frp-interaction']:Interaction('success', '[E] - Open bank', banks[i]['coords'], 2.5, GetCurrentResourceName() .. '-openBank')
						if IsControlJustPressed(0, 38) then
							openGui()
						end
					end
				end
			end
        end
        Wait(sleep)
    end
end)
  

  -- Open Gui and Focus NUI
function openGui()
	local playerPed = PlayerPedId()
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, true)
	exports['frp-progressbar']:Progress({
		name = 'use_bank',
		duration = 2500,
		label = 'Kaart wordt gelezen..',
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(cancelled)
		if not cancelled then
			SetNuiFocus(true, true)
			ESX.TriggerServerCallback('bank:getnames', function(data)
				SendNUIMessage({
					openBank = true,
					bank = data.bank,
					PlayerName = {['firstname'] = data.firstname, ['lastname'] = data.lastname}
				})
			end)
			ClearPedTasksImmediately(playerPed)
		else
			ClearPedTasksImmediately(playerPed)
			exports['frp-notifications']:Notify('error', 'Geannuleerd..!', 5000)
		end
	end)
end

  -- Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false, false)
	SendNUIMessage({openBank = false})
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
	closeGui()
	cb('ok')
end)
  
RegisterNUICallback('balance', function(data, cb)
	SendNUIMessage({openSection = "balance"})
	cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
	SendNUIMessage({openSection = "withdraw"})
	cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
	SendNUIMessage({openSection = "deposit"})
	cb('ok')
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
	TriggerServerEvent('bank:withdraw', data.amount)

	SetTimeout(500, function()
		ESX.TriggerServerCallback('bank:getnames', function(data)
			SendNUIMessage({
				updateBalance = true,
				bank = data.bank
			})
		end)
	end)
	cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
	TriggerServerEvent('bank:deposit', data.amount)

	SetTimeout(500, function()
		ESX.TriggerServerCallback('bank:getnames', function(data)
			SendNUIMessage({
				updateBalance = true,
				bank = data.bank
			})
		end)
	end)
	cb('ok')
end)