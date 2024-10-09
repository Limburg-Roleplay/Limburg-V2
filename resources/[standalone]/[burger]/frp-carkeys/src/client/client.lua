local Exios = { Functions = { Utils = {} } }

local vehicleLocking = false

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

RegisterNetEvent('frp-carkeys:client:unl:vehicle')
AddEventHandler('frp-carkeys:client:unl:vehicle', function(status, entity)
	Exios.Functions.ToggleVehicleLock(entity, status)
end)

RegisterCommand('+lockVeh', function()
	Exios.Functions.LockVeh()
end)
RegisterKeyMapping('+lockVeh', 'Voertuig sloten', 'keyboard', 'L')

TriggerEvent('chat:addSuggestion', '/geefsleutels', 'Geef sleutels aan een Dichstbijzijnde speler')

Exios.Functions.Utils.TriggerLights = function(veh)
	for i=1, 2 do 
		SetVehicleLights(veh, 2)
		Wait(100)
		SetVehicleLights(veh, 0)
		Wait(100)
	end
end

Exios.Functions.Utils.CloseDoors = function(veh)
	for i = 0, 5 do
        SetVehicleDoorShut(veh, i, false)
    end
end

local isLocking = false

Exios.Functions.LockVeh = function()
    if isLocking then return end

    isLocking = true

    local veh = ESX.Game.GetClosestVehicle()
    local pos = GetEntityCoords(PlayerPedId())
    local otherpos = GetEntityCoords(veh)
    local dist = #(pos - otherpos)

    if veh ~= 0 and dist < 5.0 then
        local props = ESX.Game.GetVehicleProperties(veh)
        local status = GetVehicleDoorLockStatus(veh)
        local hasShownNotification = false 

        ESX.TriggerServerCallback('frp-carkeys:server:can:unlock:vehicle', function(bool, error)

            if bool then
                Exios.Functions.ToggleVehicleLock(veh, status)
            else
                if not hasShownNotification then
                    hasShownNotification = true

                    if error == 'owned' then
                        lib.notify({
                            title = 'Fout opgetreden',
                            description = 'Je hebt de sleutels van het voertuig niet!',
                            type = 'error',
                            position = 'center-left'
                        })
                    elseif error == 'cooldown' then 
                        lib.notify({
                            title = 'Fout opgetreden',
                            description = 'Je moet nog even wachten voordat je deze actie kan doen!',
                            type = 'error',
                            position = 'center-left'
                        })
                    end
                end
            end

            isLocking = false
        end, props.plate)
    else
        isLocking = false
    end
end




Exios.Functions.ToggleVehicleLock = function(veh, status)
	if vehicleLocking then return end
    vehicleLocking = true
	
	local vehCoords = GetEntityCoords(veh)
	if status == 2 then
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			ESX.Game.PlayAnim('anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 600, 51)
		end
		PlaySoundFromCoord(-1, "Remote_Control_Close", vehCoords.x, vehCoords.y, vehCoords.z, "PI_Menu_Sounds", soundRange, false) 
		local modelName = GetEntityModel(veh)
		if Shared.MirrorVehicles[modelName] then
			RaiseConvertibleRoof(veh, false)
		end
		Citizen.SetTimeout(750, function()
			ClearPedSecondaryTask(PlayerPedId())
		end)

		local lockStatusChanged = false
		local attempt = 0
		while attempt < 9 and GetVehicleDoorLockStatus(veh) == 2 do
			Wait(100)
			SetVehicleDoorsLocked(veh, 1)
			lockStatusChanged = true
			attempt = attempt + 1
		end

		if lockStatusChanged then
			lib.notify({
				title = 'Voertuig',
				description = 'Je hebt jouw voertuig ontgrendeld!',
				type = 'success',
				position = 'center-left'
			})
		elseif attempt >= 9 then
			lib.notify({
				title = 'SYSTEEM',
				description = 'Je voertuig kon niet worden ontgrendeld, probeer het opnieuw..',
				type = 'error',
				position = 'center-left'
			})
		end
	elseif status <= 1 then
		if not IsPedInAnyVehicle(PlayerPedId(), false) then
			ESX.Game.PlayAnim('anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 600, 51)
		end
		local modelName = GetEntityModel(veh)
		if Shared.MirrorVehicles[modelName] then
			LowerConvertibleRoof(veh, false)
		end
		PlaySoundFromCoord(-1, "Remote_Control_Open", vehCoords.x, vehCoords.y, vehCoords.z, "PI_Menu_Sounds", soundRange, false)  
		Citizen.SetTimeout(750, function()
			ClearPedSecondaryTask(PlayerPedId())
		end)

		local lockStatusChanged = false
		local attempt = 0
		while attempt < 9 and GetVehicleDoorLockStatus(veh) <= 1 do
			Wait(100)
			SetVehicleDoorsLocked(veh, 2)
			lockStatusChanged = true
			attempt = attempt + 1
		end

		if lockStatusChanged then
			lib.notify({
				title = 'Voertuig',
				description = 'Je hebt jouw voertuig & kofferbak vergrendeld!',
				type = 'success',
				position = 'center-left'
			})
		elseif attempt >= 9 then
			lib.notify({
				title = 'SYSTEEM',
				description = 'Je voertuig kon niet worden vergrendeld, probeer het opnieuw..',
				type = 'error',
				position = 'center-left'
			})
		end
	end
	
	Citizen.SetTimeout(1000, function()
        vehicleLocking = false
    end)
end

exports('giveCarKeys', function(src, plate, props)
	TriggerServerEvent('frp-carkeys:server:add:carKey', src, plate, props)
end)

RegisterNetEvent("esx_givecarkeys:keys")
AddEventHandler("esx_givecarkeys:keys", function()
	giveCarKeys()
end)

function giveCarKeys()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	
	ESX.TriggerServerCallback('esx_givecarkeys:requestPlayerCars', function(isOwnedVehicle)
		if not isOwnedVehicle then
			ESX.ShowNotification('error','Er is niemand in de buurt', 5000)
		elseif isOwnedVehicle then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification('error','Er is niemand in de buurt', 5000)
			else
				ESX.ShowNotification('success','Je hebt je auto overgeschreven naar de dichtstbijzijnde speler met kenteken '..vehicleProps.plate..'', 5000)
				TriggerServerEvent('esx_givecarkeys:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps)
			end
		end
	end, GetVehicleNumberPlateText(vehicle))
end
