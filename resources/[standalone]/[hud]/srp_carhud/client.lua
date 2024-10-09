local ind = {l = false, r = false}
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local showUI 	   = true
local data = {
	handbrake = nil, 
	engingeHealth = nil,
	hazerds = nil,
	lock = nil
}

AddEventHandler("ui:toggle", function(show)
	showUI = show
	SendNUIMessage({
		showhud = show
	})
end)

IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 8) or (vc >= 9 and vc <= 12) or (vc >= 14 and vc <= 16) or (vc >= 17 and vc <= 20)
end	

Fwv = function (entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then 
		hr = 360.0 + hr 
	end

	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local Ped = PlayerPedId()

		if IsPedInAnyVehicle(Ped, false) and showUI then
			sleep = 150

			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and (GetPedInVehicleSeat(PedCar, -1) == Ped or GetPedInVehicleSeat(PedCar, -1)) then
				if IsCar(PedCar) then
					local engingeHP = GetVehicleEngineHealth(PedCar)
					SendNUIMessage({
						engineHealth = engingeHP
					})

					local carSpeed = math.ceil(GetEntitySpeed(PedCar) * 4.0)
					SendNUIMessage({
						showhud = true,
						speed = carSpeed
					})

					_, feuPosition, feuRoute = GetVehicleLightsState(PedCar)
					if feuPosition == 0 and feuRoute == 0 then
						SendNUIMessage({
							feuPosition = false
						})
					else
						SendNUIMessage({
							feuPosition = true
						})
					end
					if feuPosition == 1 and feuRoute == 1 then
						SendNUIMessage({
							feuRoute = true
						})
					else
						SendNUIMessage({
							feuRoute = false
						})
					end
					
					local VehIndicatorLight = GetVehicleIndicatorLights(PedCar)
					if IsControlJustPressed(1, 190) then
						ind.l = not ind.l
						SetVehicleIndicatorLights(PedCar, 0, ind.l)
					end
					if IsControlJustPressed(1, 189) then
						ind.r = not ind.r
						SetVehicleIndicatorLights(PedCar, 1, ind.r)
					end
					local hazerds
					if VehIndicatorLight == 0 then
						indicatorsLeft = false
						indicatorsRight = false
						hazerds = false
					elseif VehIndicatorLight == 1 then
						indicatorsLeft = true
						indicatorsRight = false
						hazerds = false
					elseif VehIndicatorLight == 2 then
						indicatorsLeft = false
						indicatorsRight = true
						hazerds = false
					elseif VehIndicatorLight == 3 then
						indicatorsLeft = false
						indicatorsRight = false
						hazerds = false
					end

					if VehIndicatorLight == 0 then
						SendNUIMessage({
							clignotantGauche = false,
							clignotantDroite = false,
						})
					elseif VehIndicatorLight == 1 then
						SendNUIMessage({
							clignotantGauche = true,
							clignotantDroite = false,
						})
					elseif VehIndicatorLight == 2 then
						SendNUIMessage({
							clignotantGauche = false,
							clignotantDroite = true,
						})
					elseif VehIndicatorLight == 3 then
						SendNUIMessage({
							clignotantGauche = false,
							clignotantDroite = false,
						})
					end

					data.handbrake = GetVehicleHandbrake(PedCar)
					data.engineHealth = GetVehicleEngineHealth(PedCar)
					data.hazerds = hazerds

					data.lock = GetVehicleDoorLockStatus(PedCar) == 2
					
					local fuel = Entity(PedCar).state.fuel

					SendNUIMessage(data)		
					SendNUIMessage({
						showfuel = true,
						fuel = fuel
					})
				else
					SendNUIMessage({
						showhud = false
					})
				end
			else
				SendNUIMessage({
					showhud = false
				})
			end
		else
			SendNUIMessage({
				showhud = false
			})
		end

		Citizen.Wait(sleep)
	end
end)

local syncedSpeed = false

Citizen.CreateThread(function()
    while true do
        local timer = 2000

        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then

            local entity = GetVehiclePedIsIn(ped, false)
            local entitymodel = GetEntityModel(entity)

            CheckVehicleSpeed(entity, entitymodel)
        end

        Wait(timer)
    end
end)

function CheckVehicleSpeed(entity, model)
    if vehicles[model] then
        local kmU = vehicles[model]
        local mS = vehicles[model] / 4.0
		local Turbo = 0
        local engineTune = 0
		local armour = 0
	
		if IsToggleModOn(entity, 18) then
			Turbo = 1
		else
			Turbo = 0
		end

		if GetVehicleMod(entity, 11) == -1 then
			engineTune = 0
		elseif GetVehicleMod(entity, 11) == 0 then
			engineTune = 1
		elseif GetVehicleMod(entity, 11) == 1 then
			engineTune = 2
		elseif GetVehicleMod(entity, 11) == 2 then
			engineTune = 3
		else
			engineTune = 4
		end
		
		if GetVehicleMod(entity, 16) == -1 then
			armour = 0
		elseif GetVehicleMod(entity, 16) == 0 then
			armour = 1
		elseif GetVehicleMod(entity, 16) == 1 then
			armour = 2
		elseif GetVehicleMod(entity, 16) == 2 then
			armour = 3
		elseif GetVehicleMod(entity, 16) == 3 then
			armour = 4
		else 
			armour = 5
		end

        local percentage = 3 * engineTune
		local percentageturbo = 4 * Turbo
		local percentagearmour = 2 * armour
		local armourslow = mS/100*percentagearmour
		local turboboost = mS/100*percentageturbo
        local boost = mS/100*percentage
        SetVehicleMaxSpeed(entity, mS + boost + turboboost - armourslow)
    end
end

-- snelheids tester
local running = false
RegisterCommand("get_speed_time", function(source, args)
	local speed = tonumber(args[1])
	if not speed and args[1] ~= "stop" then
		lib.notify({ title = "Actie Mislukt", description = "Vul aub een geldig getal in!", type = "error" })
		return
	end

	if args[1] == "stop" then
		running = false
		lib.notify({ description = "Je hebt de test gestopt", type = "error" })
		return
	end

	if running then
		lib.notify({ title = "Actie Mislukt", description = "Je hebt al een test lopen!", type = "error" })
		return
	end

	running = true
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped)
	local timer = GetGameTimer()

	while (GetEntitySpeed(veh) * 4.0) < 3.0 and GetGameTimer() - timer < 10000 and running do
		Wait(0)
	end

	if GetGameTimer() - timer > 10000 then
		lib.notify({ title = "Actie Mislukt", description = "Je hebt binnen 10 seconden geen gas gegeven waardoor je test is gestopt.", type = "error" })
		return
	end

	local startTimer = GetGameTimer()

	while (GetEntitySpeed(veh) * 4.0) < speed do
		Wait(0)

		if not running then
			return
		end

		if (GetEntitySpeed(veh) * 4.0) < 3.0 then
			lib.notify({ title = "Actie Mislukt", description = "Je test is gestopt.", type = "error" })
			return
		end
	end

	running = false
	lib.notify({ description = ("je voertuig heeft %skm/h gehaald in %.2f seconden."):format(speed, (GetGameTimer()-startTimer)/1000), type = "info" })
end)

-- cruise control/speedlimiter
local speedLimiter, cruiseControl, currentMode, currentSpeed = false, false, 'cruiseControl', 0

RegisterNetEvent("shyBaselogic:lVehicle", function()
	local veh = GetVehiclePedIsIn(PlayerPedId(), true)
	
	if cruiseControl then
		setCruiseControl(true)
	elseif speedLimiter then
		setSpeedLimiter(true)
	end
end)

RegisterCommand('set_vehicle_mode', function(source, args, RawCommand)
	if IsControlPressed(0, 21) then 
		return
	end

	if SRP.Functions.isRateLimited("srp_carhud:change:cruise:control", 2) then
		return
	end

	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
        return
    end

	if GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) ~= ped then 
		return
	end

	if currentMode == 'cruiseControl' then
		setCruiseControl()
	else
		setSpeedLimiter()
	end
end, false)

function setCruiseControl(fromSwitch)
	cruiseControl = not cruiseControl

	local veh = GetVehiclePedIsIn(PlayerPedId(), true)
	local speed = math.ceil(GetEntitySpeed(veh)*4.0)
	local time = GetGameTimer()

	if speed <= 10 and not fromSwitch then
		return
	end

	SendNUIMessage({
		cruise = cruiseControl,
		speed = speed
	})

	if not fromSwitch then
		lib.notify({ description = ("Cruisecontrol is %s %s"):format(cruiseControl and "geactiveerd op" or "uitgezet", cruiseControl and speed.."km/h" or "") })
	end

	SetEntityMaxSpeed(veh, GetEntitySpeed(veh))
	while cruiseControl do
		if IsControlPressed(0, 72) then
			cruiseControl = false
			lib.notify({ description = "Cruisecontrol is uitgezet" })
		end

		if IsControlPressed(0, 32) and GetGameTimer() - time > 2000 then
			local maxSpeed = GetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel")
			SetEntityMaxSpeed(veh, math.max(GetEntitySpeed(veh), maxSpeed * 20.0) + 1.0)

			while IsControlPressed(0, 32) do
				Wait(0)
			end

			SetEntityMaxSpeed(veh, GetEntitySpeed(veh))
		end


		SetControlNormal(0, 71, 1.5)
		Wait(0)
	end

	local maxSpeed = GetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel")
	SetEntityMaxSpeed(veh, math.max(GetEntitySpeed(veh), maxSpeed * 20.0) + 1.0)
end

function setSpeedLimiter(fromSwitch)	
	speedLimiter = not speedLimiter

	local veh = GetVehiclePedIsIn(PlayerPedId(), true)
	local speed = math.ceil(GetEntitySpeed(veh)*4.0)

	if speed <= 10 and not fromSwitch then
		return
	end

	SendNUIMessage({
		limiter = speedLimiter,
		speed = speed
	})

	if not fromSwitch then
		lib.notify({ description = ("Speedlimiter is %s %s"):format(speedLimiter and "geactiveerd op" or "uitgezet", speedLimiter and speed.."km/h" or "") })
	end

	if speedLimiter then
		SetEntityMaxSpeed(veh, GetEntitySpeed(veh))
	else
		local maxSpeed = GetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel")
		SetEntityMaxSpeed(veh, math.max(GetEntitySpeed(veh), maxSpeed * 20.0) + 1.0)
	end
end

RegisterCommand('switch_vehicle_mode', function(source, args, RawCommand)
	if SRP.Functions.isRateLimited("srp_carhud:change:vehicle:mode", 2) then
		return
	end

	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
        return
    end

	if GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) ~= ped then 
		return
	end

	if IsControlPressed(0, 21) then
		if currentMode == 'cruiseControl' then
			currentMode = 'speedLimiter'
			if cruiseControl then
				setCruiseControl(true)
			end
		else
			currentMode = 'cruiseControl'
			if speedLimiter then
				setSpeedLimiter(true)
			end
		end

		lib.notify({ description = ("Geswitched naar %s"):format(currentMode:lower()) })
	end
end, false)

RegisterKeyMapping("set_vehicle_mode", "activeer de cruisecontrol/speedlimiter in je voertuig", "keyboard", "B")
RegisterKeyMapping("switch_vehicle_mode", "switch van vehicle mode(cruisecontrol en speedlimiter)", "keyboard", "B")