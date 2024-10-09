local inRadialMenu = false
local isDead = false

RegisterCommand('voertuigmenu', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(playerPed) then
        openRadial(true)
        SetCursorLocation(0.5, 0.5)
    else
        closeRadial(false)
    end
end)

RegisterKeyMapping('voertuigmenu', 'Open Voertuig  Menu', 'keyboard', 'U')

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

function openRadial(bool)
    if not isDead then

        SetNuiFocus(bool, bool)
        SendNUIMessage({
            action = "ui",
            radial = bool,
            items = Config.MenuItems
        })
        inRadialMenu = bool
    end
end

function closeRadial(bool)    
    SetNuiFocus(false, false)
    inRadialMenu = bool
end

function getNearestVeh()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

RegisterNUICallback('closeRadial', function()
    closeRadial(false)
end)

RegisterNUICallback('selectItem', function(data)
    local parameters = {}
    local itemData = data.itemData

    if itemData.optionalData ~= nil then
        for k, v in pairs(itemData.optionalData) do parameters[k] = v end
    end

    if itemData.type == 'client' then
        TriggerEvent(itemData.event, parameters)
    elseif itemData.type == 'server' then
        TriggerServerEvent(itemData.event, parameters)
    end
end)

RegisterNetEvent('radialmenu:client:noPlayers')
AddEventHandler('radialmenu:client:noPlayers', function(data)
    TriggerEvent('ox_lib:notify', { type = 'error', description = "Geen burgers in de buurt" })
end)

RegisterNetEvent("radialmenu:client:shuff")
AddEventHandler("radialmenu:client:shuff", function(data)
    local currentvehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetPedConfigFlag(PlayerPedId(), 184, false)
    SetPedIntoVehicle(PlayerPedId(), currentvehicle, data.id)
    SetPedConfigFlag(PlayerPedId(), 184, true)
end)

RegisterNetEvent('radialmenu:client:openDoor')
AddEventHandler('radialmenu:client:openDoor', function(data)
    local string = data.id
    local replace = string:gsub("door", "")
    local door = tonumber(replace)
    local ped = PlayerPedId()
    local closestVehicle = nil

    if IsPedInAnyVehicle(ped, false) then
        closestVehicle = GetVehiclePedIsIn(ped)
    else
        closestVehicle = getNearestVeh()
    end

    if closestVehicle ~= 0 then
        if closestVehicle ~= GetVehiclePedIsIn(ped) then
            local plate = GetVehicleNumberPlateText(closestVehicle)
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('radialmenu:trunk:server:Door', false, plate, door)
                else
                    SetVehicleDoorShut(closestVehicle, door, false)
                end
            else
                if not IsVehicleSeatFree(closestVehicle, -1) then
                    TriggerServerEvent('radialmenu:trunk:server:Door', true, plate, door)
                else
                    SetVehicleDoorOpen(closestVehicle, door, false, false)
                end
            end
        else
            if GetVehicleDoorAngleRatio(closestVehicle, door) > 0.0 then
                SetVehicleDoorShut(closestVehicle, door, false)
            else
                SetVehicleDoorOpen(closestVehicle, door, false, false)
            end
        end
    else
        --QBCore.Functions.Notify('There is no vehicle in sight...', 'error', 2500)
        TriggerEvent('ox_lib:notify', { type = 'error', description = "Er is geen voertuig in de buurt" })
    end
end)

RegisterNetEvent('radialmenu:client:setExtra')
AddEventHandler('radialmenu:client:setExtra', function(data)
    local string = data.id
    local replace = string:gsub("extra", "")
    local extra = tonumber(replace)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped)
    local enginehealth = 1000.0
    local bodydamage = 1000.0

    if veh ~= nil then
        local plate = GetVehicleNumberPlateText(closestVehicle)
    
        if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
            if DoesExtraExist(veh, extra) then 
                if IsVehicleExtraTurnedOn(veh, extra) then
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    SetVehicleExtra(veh, extra, 1)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    --QBCore.Functions.Notify('Extra ' .. extra .. ' Deactivated', 'error', 2500)
                    TriggerEvent('ox_lib:notify', { type = 'success', description = "Extra " .. extra .. " gedeactiveerd" })
                else
                    enginehealth = GetVehicleEngineHealth(veh)
                    bodydamage = GetVehicleBodyHealth(veh)
                    SetVehicleExtra(veh, extra, 0)
                    SetVehicleEngineHealth(veh, enginehealth)
                    SetVehicleBodyHealth(veh, bodydamage)
                    --QBCore.Functions.Notify('Extra ' .. extra .. ' Activated', 'success', 2500)
                    TriggerEvent('ox_lib:notify', { type = 'error', description = "Extra " .. extra .. " gedeactiveerd" })
                end    
            else
                --QBCore.Functions.Notify('Extra ' .. extra .. ' Its not pressent on this vehicle ', 'error', 2500)
                TriggerEvent('ox_lib:notify', { type = 'error', description = "Extra " .. extra .. " is niet op dit voertuig" })
            end
        else
            --QBCore.Functions.Notify('Your not a driver of a vehicle !', 'error', 2500)
            TriggerEvent('ox_lib:notify', { type = 'error', description = "Je bent de bestuurder niet!" })
        end
    end
end)

RegisterNetEvent('radialmenu:trunk:client:Door')
AddEventHandler('radialmenu:trunk:client:Door', function(plate, door, open)
    local veh = GetVehiclePedIsIn(PlayerPedId())

    if veh ~= 0 then
        local pl = GetVehicleNumberPlateText(veh)

        if pl == plate then
            if open then
                SetVehicleDoorOpen(veh, door, false, false)
            else
                SetVehicleDoorShut(veh, door, false)
            end
        end
    end
end)

local Seats = {
    ["-1"] = "Driver's Seat",
    ["0"] = "Passenger's Seat",
    ["1"] = "Rear Left Seat",
    ["2"] = "Rear Right Seat",
}

RegisterNetEvent('radialmenu:client:ChangeSeat')
AddEventHandler('radialmenu:client:ChangeSeat', function(data)
    local Veh = GetVehiclePedIsIn(PlayerPedId())
    local IsSeatFree = IsVehicleSeatFree(Veh, data.id)
    local speed = GetEntitySpeed(Veh)
    local HasHarnass = false
    if not HasHarnass then
        local kmh = (speed * 3.6);  

        if IsSeatFree then
            if kmh <= 100.0 then
                SetPedIntoVehicle(PlayerPedId(), Veh, data.id)
                --QBCore.Functions.Notify('Your now on the  '..data.title..'!')
                TriggerEvent('ox_lib:notify', { type = 'success', description = "Je zit nu op  "..data.title.."!" })
            else
                --QBCore.Functions.Notify('The vehicle goes to fast..')
                TriggerEvent('ox_lib:notify', { type = 'error', description = "Het voertuig gaat te snel" })
            end
        else
            --QBCore.Functions.Notify('This seat is occupied..')
            TriggerEvent('ox_lib:notify', { type = 'error', description = "Stoel is bezet" })
        end
    else
        --QBCore.Functions.Notify('You have a race harnas on u cant switch..', 'error')
        exports['notify']:Alert('error', 'You have a race harnas on u cant switch..', 5000, "info")
    end
end)


interactionDistance = 3.5

engineoff = false
saved = false
controlsave_bool = false
rollw = true

IsEngineOn = true
RegisterNetEvent('engine')
AddEventHandler('engine',function() 
	local player = PlayerPedId()
	
	if (IsPedSittingInAnyVehicle(player)) then 
		local vehicle = GetVehiclePedIsIn(player,false)
		
		if IsEngineOn == true then
			IsEngineOn = false
			SetVehicleEngineOn(vehicle,false,false,false)
		else
			IsEngineOn = true
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
		end
		
		while (IsEngineOn == false) do
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
		end
	end
end)

RegisterNetEvent('engineoff')
AddEventHandler('engineoff',function() 
		local player = PlayerPedId()

        if (IsPedSittingInAnyVehicle(player)) then 
            local vehicle = GetVehiclePedIsIn(player,false)
			engineoff = true
			ShowNotification("Moottori ~r~sammutettu~s~.")
			while (engineoff) do
			SetVehicleEngineOn(vehicle,false,false,false)
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
			end
		end
end)
RegisterNetEvent('engineon')
AddEventHandler('engineon',function() 
    local player = PlayerPedId()

        if (IsPedSittingInAnyVehicle(player)) then 
            local vehicle = GetVehiclePedIsIn(player,false)
			engineoff = false
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
			ShowNotification("Engine ~g~on~s~.")
	end
end)

RegisterNetEvent('trunk')
AddEventHandler('trunk',function() 
	local player = PlayerPedId()
			if controlsave_bool == true then
				vehicle = saveVehicle
			else
				vehicle = GetVehiclePedIsIn(player,true)
			end
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,5)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
				SetVehicleDoorOpen(vehicle,5,0,0)
				else
				SetVehicleDoorShut(vehicle,5,0)
				end
			else
				ShowNotification("~r~You must be near your vehicle to do that.")
			end
end)

RegisterNetEvent('rdoors')
AddEventHandler('rdoors',function() 
	local player = PlayerPedId()
    		if controlsave_bool == true then
				vehicle = saveVehicle
			else
				vehicle = GetVehiclePedIsIn(player,true)
			end
			local isopen = GetVehicleDoorAngleRatio(vehicle,2) and GetVehicleDoorAngleRatio(vehicle,3)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
					SetVehicleDoorOpen(vehicle,1,0,0)
					SetVehicleDoorOpen(vehicle,2,0,0)
					SetVehicleDoorOpen(vehicle,3,0,0)
					SetVehicleDoorOpen(vehicle,0,0,0)
					
				else
					SetVehicleDoorShut(vehicle,1,0)
					SetVehicleDoorShut(vehicle,2,0)
					SetVehicleDoorShut(vehicle,3,0)
					SetVehicleDoorShut(vehicle,0,0)
				end
			else
				ShowNotification("~r~You must be near your vehicle to do that.")
			end
end)		

RegisterNetEvent('hood')
AddEventHandler('hood',function() 
	local player = PlayerPedId()
    	if controlsave_bool == true then
			vehicle = saveVehicle
		else
			vehicle = GetVehiclePedIsIn(player,true)
		end
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,4)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
				SetVehicleDoorOpen(vehicle,4,0,0)
				else
				
				SetVehicleDoorShut(vehicle,4,0)
				end
			else
				ShowNotification("~r~You must be near your vehicle to do that.")
			end
end)

RegisterNetEvent('rollw')
AddEventHandler('rollw',function() 
	local player = PlayerPedId()
			if controlsave_bool == true then
				vehicle = saveVehicle
			else
				vehicle = GetVehiclePedIsIn(player,true)
			end

			if  rollw == true then
				RollDownWindows(vehicle)
				print("down")
				rollw = false
			else
				RollUpWindow(vehicle, 1)
				RollUpWindow(vehicle, 2)
				RollUpWindow(vehicle, 3)
				RollUpWindow(vehicle, 0)
				print("up")
				rollw = true
			end
end)

function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end


function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
