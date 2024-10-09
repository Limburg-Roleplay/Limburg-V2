local TackleKey = 51 -- Change to a number which can be found here: https://wiki.fivem.net/wiki/Controls
local TackleTime = 3500 -- In milliseconds

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
	ESX.PlayerLoaded = true
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
end)

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job.name == 'police' and IsPedJumping(PlayerPedId()) and IsControlPressed(0, 21) and IsControlPressed(0, 47) then
			if not IsPedInAnyVehicle(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				local Tackled = {}

				SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

				while IsPedRagdoll(PlayerPedId()) do
					Citizen.Wait(0)
					for Key, Value in ipairs(GetTouchedPlayers()) do
						if not Tackled[Value] then
							Tackled[Value] = true
							TriggerServerEvent('Tackle:Server:TacklePlayer', GetPlayerServerId(Value), ForwardVector.x, ForwardVector.y, ForwardVector.z, GetPlayerName(PlayerId()))
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end
	while true do
		Citizen.Wait(0)
		if ESX.PlayerData.job.name == 'kmar' and IsPedJumping(PlayerPedId()) and IsControlPressed(0, 21) and IsControlPressed(0, 47) then
			if not IsPedInAnyVehicle(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				local Tackled = {}

				SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

				while IsPedRagdoll(PlayerPedId()) do
					Citizen.Wait(0)
					for Key, Value in ipairs(GetTouchedPlayers()) do
						if not Tackled[Value] then
							Tackled[Value] = true
							TriggerServerEvent('Tackle:Server:TacklePlayer', GetPlayerServerId(Value), ForwardVector.x, ForwardVector.y, ForwardVector.z, GetPlayerName(PlayerId()))
						end
					end
				end
			end
		end
	end
end)


RegisterNetEvent('Tackle:Client:TacklePlayer')
AddEventHandler('Tackle:Client:TacklePlayer', function(ForwardVectorX, ForwardVectorY, ForwardVectorZ, Tackler)
	SetPedToRagdollWithFall(PlayerPedId(), TackleTime, TackleTime, 0, ForwardVectorX, ForwardVectorY, ForwardVectorZ, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
end)

function GetPlayers()
    local Players = {}

    for i=1, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(Players, i)
        end
    end

    return Players
end

function GetTouchedPlayers()
    local TouchedPlayer = {}
    for Key, Value in ipairs(GetPlayers()) do
		if IsEntityTouchingEntity(PlayerPedId(), GetPlayerPed(Value)) then
			table.insert(TouchedPlayer, Value)
		end
    end
    return TouchedPlayer
end
