
ESX = nil

local playerServerId = GetPlayerServerId(PlayerId())


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end

	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(100)
	end

	Citizen.Wait(2000)
	isLoaded = true
end)

-- Functions


RegisterNetEvent("esx:playerLoaded", function()
	-- Native audio seems to cause some problems so restart mumble to make sure nativeAudio gets started correctly
	Citizen.Wait(2000)
	isLoaded = true
end)

--time
local timeZone = GetConvarInt("time_zone", 3)

local timeText, width = '', 0
Citizen.CreateThread(function()
	while true do
		local yearU, monthU, dayU, hourU, minuteU, secondU = GetUtcTime()
		hourU = hourU + timeZone
		if hourU >= 24 then
			hourU = hourU % 24
		end
		timeText = ("%04i-%02i-%02i %02i:%02i"):format(yearU, monthU, dayU, hourU - 1, minuteU, secondU)
		SendNUIMessage({time = timeText})
		Citizen.Wait(500)
	end
end)