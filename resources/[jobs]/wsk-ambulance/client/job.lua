ESX = exports["es_extended"]:getSharedObject()
local LooptMank = nil
IsPlayerJob = function()
	local bool = ESX.PlayerData.job.name == 'ambulance' and true or ESX.PlayerData.job.name == 'offambulance' and true or
		false
	return bool
end

IsPlayerOnDuty = function()
	local bool = ESX.PlayerData.job.name == 'ambulance' and true or false
	return bool
end

Citizen.CreateThread(function()
	exports['qtarget']:Player({
		options = {
			{
				event = 'wsk-ambulance:client:send:factuur',
				icon = 'fa-solid fa-clipboard',
				label = 'Verstuur factuur',
				job = 'ambulance'
			},
		},
		distance = 2
	})

	exports.qtarget:AddTargetModel(GetHashKey('v_med_emptybed'), {
		options = {
			{
				icon = "fa-solid fa-truck-medical",
				label = "Verwijder brancard",
				event = 'wsk-ambulance:client:remove:brancard',
				job = 'ambulance'
			},
		},
		distance = 2.5
	})
end)

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end

	DrawBlips()

	for i = 1, #Config.Peds do
		local ped = Config.Peds[i]
		local script = GetCurrentResourceName()
		ESX.CreateFreezedPed(ped.model, ped.coords, ped.heading, ped.scenario, script)
	end

	for k, v in pairs(Config.Vehicles.cars) do
		for l, v in pairs(v.vehicles) do
			AddTextEntry(v.spawnName, v.name)
		end
	end

	for k, v in pairs(Config.Vehicles.air) do
		for l, v in pairs(v.vehicles) do
			AddTextEntry(v.spawnName, v.name)
		end
	end

	while true do
		local sleep = 500
		if IsPlayerOnDuty() then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)

			for k, v in pairs(Config.Locations) do
				if v.rank == nil then v.rank = 0 end
				if v.rank <= tonumber(ESX.PlayerData.job.grade) and (v.target == nil or v.target == false) then
					if (v.drawText == 'Voertuig wegzetten' and IsPedInAnyVehicle(playerPed, true)) or v.drawText ~= 'Voertuig wegzetten' then
						local dist = #(coords - v.coords)
						if dist <= 20.0 and dist > 1.0 then
							sleep = 0
							if v.drawText == 'Voertuig wegzetten' then
								if v.deleteType == 'heli' then
									if IsPedInAnyHeli(playerPed) then
										ESX.DrawBasicMarker(v.coords, 255, 0, 0)
									end
								else
									ESX.DrawBasicMarker(v.coords, 255, 0, 0)
								end
							else
								ESX.DrawBasicMarker(v.coords, 252, 236, 3)
							end
						elseif dist < 1.0 then
							sleep = 0
							if v.drawText ~= nil then
								if v.drawText == 'Voertuig wegzetten' then
									if v.deleteType == 'heli' then
										if IsPedInAnyHeli(playerPed) then
											exports['' .. Config.interaction .. '']:Interaction('error',
												'[E] - ' .. v.drawText, v.coords, 2.5,
												GetCurrentResourceName() .. '-action-' .. tostring(k))
											ESX.DrawBasicMarker(v.coords, 255, 0, 0)
										end
									else
										exports['' .. Config.interaction .. '']:Interaction('error',
											'[E] - ' .. v.drawText, v.coords, 2.5,
											GetCurrentResourceName() .. '-action-' .. tostring(k))
										ESX.DrawBasicMarker(v.coords, 255, 0, 0)
									end
								else
									exports['' .. Config.interaction .. '']:Interaction(
										{ r = '161', g = '161', b = '0' },
										'[E] - ' .. v.drawText, v.coords, 2.5,
										GetCurrentResourceName() .. '-action-' .. tostring(k))
									ESX.DrawBasicMarker(v.coords, 252, 236, 3)
								end
								if IsControlJustReleased(0, 38) then
									if v.type == nil then v.type = 'default' end

									v['functionDefine'](v.type, k);
								end
							end
						end
					end
				end
			end
		elseif IsPlayerJob() then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)

			for k, v in pairs(Config.Locations) do
				if v.drawText == 'In-/uitklokken' then
					local dist = #(coords - v.coords)
					if dist <= 20.0 and dist > 1.0 then
						sleep = 0
						ESX.DrawBasicMarker(v.coords, 252, 236, 3)
					elseif dist < 1.0 then
						sleep = 0
						if v.drawText ~= nil then
							exports['' .. Config.interaction .. '']:Interaction({ r = '161', g = '161', b = '0' },
								'[E] - ' .. v.drawText, v.coords, 2.5,
								GetCurrentResourceName() .. '-action-' .. tostring(k))
							ESX.DrawBasicMarker(v.coords, 252, 236, 3)

							if IsControlJustReleased(0, 38) then
								if v.type == nil then v.type = 'default' end

								v['functionDefine'](v.type, k);
							end
						end
					end
				end
			end
		end

		Wait(sleep)
	end
end)

OpenGarage = function(type, id)
	local configType = Config.Vehicles.cars
	if type == 'airport' then
		configType = Config.Vehicles.air
	end
	local categories = {}

	for i = 1, #configType do
		if configType[i].rank <= tonumber(ESX.PlayerData.job.grade) then
			categories[#categories + 1] = {
				title = configType[i].category,
				description = configType[i].description,
				arrow = true,
				onSelect = function(args)
					OpenVehiclesMenu(type, configType, args)
				end,
				args = { category = i, garageIndex = id }
			}
		end
	end

	lib.registerContext({
		id = 'a:garage-menu',
		title = 'Ambulance: Garage',
		options = categories
	})

	lib.showContext('a:garage-menu')
end

OpenVehiclesMenu = function(type, configType, data)
	local vehicles = {}

	for i = 1, #configType[data.category].vehicles do
		vehicles[#vehicles + 1] = {
			title = configType[data.category].vehicles[i].name,
			event = 'wsk-ambulance:client:spawn:vehicle',
			args = { vehicleName = configType[data.category].vehicles[i].spawnName, garageIndex = data.garageIndex }
		}
	end

	lib.registerContext({
		id = 'a:garage-menu:vehicles',
		title = 'Ambulance: Garage',
		onExit = function()
			OpenGarage(type, data.garageIndex)
		end,
		options = vehicles
	})

	lib.showContext('a:garage-menu:vehicles')
end

DeleteVehicle = function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if vehicle ~= 0 then
		ESX.Game.DeleteVehicle(vehicle)
	end
end

RemoveVehicle = function(vehicle)
	ESX.Game.DeleteVehicle(vehicle)
end

GetGear = function()
	TriggerServerEvent('wsk-ambulance:server:getGear', false)
end

OnOffDuty = function()
	exports['' .. Config.Jobsmenu .. '']:ToggleDuty(ESX.PlayerData.job.name)
end

OpenManagement = function()
	exports['' .. Config.Jobsmenu .. '']:OpenManagementMenu(ESX.PlayerData.job.name)
end

RegisterNetEvent('wsk-ambulance:client:own:cloakroom')
AddEventHandler('wsk-ambulance:client:own:cloakroom', function()
	if ESX.PlayerData.job.name == 'ambulance' then
		exports['' .. Config.Kleding .. '']:openSavedOutfits()
	end
end)

RegisterNetEvent('wsk-ambulance:client:ambu:cloakroom')
AddEventHandler('wsk-ambulance:client:ambu:cloakroom', function()
	if ESX.PlayerData.job.name == 'ambulance' then
		exports['' .. Config.Jobsmenu .. '']:OpenOutfitMenu(Config.Outfits)
	end
end)

CloakroomMenu = function()
	if ESX.PlayerData.job.name == 'ambulance' then
		local options = {
			[1] = {
				['title'] = 'Persoonlijke kleedkamer',
				['description'] = 'Bekijk je eigen outfits',
				['event'] = 'wsk-ambulance:client:own:cloakroom'
			},
			[2] = {
				['title'] = 'Algemene kleedkamer',
				['description'] = 'Bekijk de Ambulance outfits',
				['event'] = 'wsk-ambulance:client:ambu:cloakroom'
			},
		}

		lib.registerContext({
			id = 'wsk-ambulance:check-cloakroom',
			title = 'Ambulance: Bekijk opties van Kleedkamer',
			options = options
		})

		lib.showContext('wsk-ambulance:check-cloakroom')
	end
end

RegisterNetEvent('wsk-ambulance:client:spawn:vehicle')
AddEventHandler('wsk-ambulance:client:spawn:vehicle', function(data)
	local garage = Config.Locations[data.garageIndex]
	local vehicle = data.vehicleName
	local foundPoint = false

	for i = 1, #garage.spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), 2.0) then
			ESX.Game.SpawnVehicle(vehicle,
				vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z),
				garage.spawnPoints[i].w, function(veh)
					TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
					SetVehicleNumberPlateText(veh, 'AMBU' .. math.random(111111, 999999))
					exports['' .. Config.Carkeys .. '']:giveCarKeys(GetVehicleNumberPlateText(veh),
						ESX.Game.GetVehicleProperties(veh))
					exports['' .. Config.Benzine .. '']:setFuel(veh, 100.0)
				end)
			foundPoint = true
			break
		end
	end

	if not foundPoint then
		exports['' .. Config.Notify .. '']:Notify('error', 'Er zijn geen lege parkeerplekken!', 5000)
	end
end)

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,")
		:gsub(",(%-?)$", "%1"):reverse()
end

secondsToClock = function(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

isPlayerDead = function(serverId)
	local playerDead
	if not serverId then
		playerDead = LocalPlayer.state.dead or false
	else
		playerDead = Player(serverId).state.dead or false
	end
	return playerDead
end

exports('isPlayerDead', isPlayerDead)

DrawGenericTextThisFrame = function()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

respawnPed = function(ped, coords, heading)
	isDead = false
	EndDeathCam()
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
	exports['wsk-ambulance']:respawncombatlog()
end

-- Respawn en deadzones

local spawnPosition = vector3(351.9720, -588.6777, 28.7968)
local redCircleRadius = 50.0
local warningTimer = 30
local deathPosition = nil

local function getDistanceBetweenPoints(point1, point2)
    if point1 and point2 then
        return #(point1 - point2)
    else
        return nil
    end
end

local function drawText(text, x, y, scale, r, g, b, a)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local currentNotificationText = ""

local function updateNotification(text)
    currentNotificationText = text
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentNotificationText ~= "" then
            drawText(currentNotificationText, 0.5, 0.9, 0.5, 255, 255, 255, 255) -- Witte tekst onderaan in het midden van het scherm
        end
    end
end)

function respawnPlayer()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        
        Citizen.Wait(500)
        deathPosition = GetEntityCoords(playerPed)
        
        if deathPosition and deathPosition ~= vector3(0, 0, 0) then
            -- Uitvoeren van scherm fading
            DoScreenFadeOut(800)
            while not IsScreenFadedOut() do
                Citizen.Wait(10)
            end

            TriggerServerEvent('wasabi_ambulance:setDeathStatus', false)

            -- Stel spelerpositie en richting in
            SetEntityCoords(playerPed, spawnPosition.x, spawnPosition.y, spawnPosition.z, false, false, false, true)
            SetEntityHeading(playerPed, 248.5847)

            ESX.SetPlayerData('loadout', {})

            Citizen.Wait(10)
            DoScreenFadeIn(200)

            FreezeEntityPosition(playerPed, true)
            exports['wsk-ambulance']:respawncombatlog()
            TriggerServerEvent('wsk-ambulance:removeItemsOnDeath')

            while not HasCollisionLoadedAroundEntity(playerPed) do
                Citizen.Wait(0)
            end

            FreezeEntityPosition(playerPed, false)

            local playerId = GetPlayerServerId(PlayerId())
            TriggerServerEvent('wsk-ambulance:server:revive:player', playerId)

            Citizen.Wait(500)
            if deathPosition and deathPosition ~= vector3(0, 0, 0) then
                local blip = AddBlipForRadius(deathPosition.x, deathPosition.y, deathPosition.z, redCircleRadius)
                
                if blip then
                    SetBlipColour(blip, 47)
                    SetBlipAlpha(blip, 100)
                end

                local blipDuration = 15 * 60 * 1000

                Citizen.CreateThread(function()
                    Citizen.Wait(blipDuration)
                    if DoesBlipExist(blip) then
                        RemoveBlip(blip)
                    end
                end)

                local timerActive = false
                local startTime = 0
                
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(1000)

                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)

                        if deathPosition then
                            local distance = #(playerCoords - deathPosition)

                            if distance < redCircleRadius then
                                if not timerActive then
                                    timerActive = true
                                    startTime = GetGameTimer()
                                end

                                local elapsedTime = (GetGameTimer() - startTime) / 1000
                                local remainingTime = warningTimer - elapsedTime

                                if remainingTime > 0 then
                                    updateNotification(string.format("Verlaat deze zone binnen %.0f seconden, anders ga je langzaam dood.", remainingTime))
                                else
                                    local health = GetEntityHealth(playerPed)
                                    if health > 0 then
                                        SetEntityHealth(playerPed, health - 10)
                                    else
                                        updateNotification("Je bent dood Je was te lang in een zone waar je niet mocht komen!") 
                                    end
                                    updateNotification("Je bent te lang in de zone. Je begint nu langzaam dood te gaan!")
                                end
                            else
                                if timerActive then
                                    timerActive = false
                                    updateNotification("")
                                end
                            end
                        else
                            if timerActive then
                                timerActive = false
                                updateNotification("")
                            end
                        end
                    end
                end)
            end
        end
    end)
end




-- Respawn en deadzones

sendDispatch = function()
    local targetCoords = GetEntityCoords(PlayerPedId())
    local streetName = GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z)
    local playerGender = "male" 

     print(targetCoords, streetName)

    TriggerServerEvent('esx_outlawalert:Gewondpersoon', targetCoords, streetName, playerGender)
end

startDeathTimer = function()
    local earlySpawnTimer = ESX.Math.Round(Config.RespawnTimer / 1000)
    local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)
    local clickedButton = 0

    Citizen.CreateThread(function()
        while earlySpawnTimer > 0 and isDead and not doodVerklaard do
            Citizen.Wait(1000)
            if earlySpawnTimer > 0 then
                earlySpawnTimer = earlySpawnTimer - 1
                if clickedButton > 0 then
                    clickedButton = clickedButton - 1
                end
            end
        end

        while bleedoutTimer > 0 and isDead do
            Citizen.Wait(1000)
            if bleedoutTimer > 0 then
                bleedoutTimer = bleedoutTimer - 1
                if clickedButton > 0 then
                    clickedButton = clickedButton - 1
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        local text, timeHeld
        local sentDispatch = false
        while earlySpawnTimer > 0 and isDead and not doodVerklaard do
            Citizen.Wait(0)
            if not sentDispatch then
                drawTxt(0.91, 1.41, 1.0, 1.0, 0.6, "KLIK OP ~r~G ~w~OM EEN ~r~MELDING ~w~TE MAKEN", 255, 255, 255, 255)
                if IsControlJustPressed(0, 47) then
                    sendDispatch()
                     print("test")
                    sentDispatch = true
                end
            else
                drawTxt(0.91, 1.41, 1.0, 1.0, 0.6, "~r~JE HEBT EEN MELDING GEMAAKT NAAR DE AMBULANCE", 255, 255, 255, 255)
            end
            drawTxt(0.91, 1.38, 1.0, 1.0, 0.6, "KLIK OP ~r~E ~w~ALS NIEMAND JE ZIET", 255, 255, 255, 255)
            drawTxt(0.91, 1.44, 1.0, 1.0, 0.6, "RESPAWN: ~r~" .. math.ceil(earlySpawnTimer) .. " ~w~SECONDEN OVER", 255, 255, 255, 255)
            if IsControlJustPressed(0, 38) and clickedButton <= 0 then
                local coords = GetEntityCoords(PlayerPedId())
                ClearPedTasksImmediately(PlayerPedId())
                Citizen.Wait(5)
                SetEntityCoords(PlayerPedId(), coords)
                clickedButton = 10
            end
        end

        while doodVerklaard and isDead do
            Citizen.Wait(0)
            if bleedoutTimer <= 0 then
                respawnPlayer()
                break
            end
            drawTxt(0.91, 1.38, 1.0, 1.0, 0.6, "JE BENT ~r~DOOD~w~ VERKLAARD, JE KAN NIET MEER GEHOLPEN WORDEN.", 255, 255, 255, 255)
            drawTxt(0.91, 1.44, 1.0, 1.0, 0.6, "RESPAWN: ~r~" .. math.ceil(bleedoutTimer) .. " ~w~SECONDEN OVER", 255, 255, 255, 255)
        end

        while bleedoutTimer > 0 and isDead and not doodVerklaard do
            Citizen.Wait(0)
            if IsControlPressed(1, 38) then
                EHeld = EHeld - 1
                if EHeld < 1 then
                    respawnPlayer()
                    break
                end
            else
                EHeld = 500
            end

            if bleedoutTimer <= 0 then
                respawnPlayer()
                break
            end
            drawTxt(0.83, 1.44, 1.0, 1.0, 0.6, "~w~HOUD ~r~E ~w~(" .. math.ceil(EHeld / 100) .. ") ~w~INGEDRUKT OP TE ~r~RESPAWNEN ~w~OF WACHT OP EEN ~r~AMBULANCE", 255, 255, 255, 255)
        end
    end)
end



loadAnimDict = function(dict)
	RequestAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		Citizen.Wait(1)
	end
end

LoadAnimDict = function(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(10)
	end
end

drawTxt = function(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end


OnPlayerDeath = function()
	isDead = true

	StartDeathCam()
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('wasabi_ambulance:setDeathStatus', true)
	startDeathTimer()
end

RegisterNetEvent('wsk-ambulance:client:revive:player', function()
	local ScriptName = GetInvokingResource()
	if ScriptName ~= nil then
		print(hacker)
		return
	end
	local playerPed = PlayerPedId()
	RequestAnimSet("move_m@injured")
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('wasabi_ambulance:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		respawnPed(playerPed, formattedCoords, 0.0)
		DoScreenFadeIn(800)
		ESX.ShowNotification('info', 'Je bent omhoog geholpen door de Ambu,<br> Maar je lichaam moet nog even bijkomen..', 3500)
		Wait(30000)
		ResetPedMovementClipset(playerPed)
		ResetPedWeaponMovementClipset(playerPed)
		ResetPedStrafeClipset(playerPed)
	end)
end)

RegisterNetEvent('wsk-ambulance:client:staffrevive:player')
AddEventHandler('wsk-ambulance:client:staffrevive:player', function()
	local ScriptName = GetInvokingResource()
	if ScriptName ~= nil then
		if exports['Airsoft']:isInAirsoft() == nil then
            print("hacker")
            return
		end
	end
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('wasabi_ambulance:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end
		doodVerklaard = false
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		respawnPed(playerPed, formattedCoords, 0.0)
		DoScreenFadeIn(800)
	end)
end)



RegisterNetEvent('wasabi_ambulance:heal', function(full)
	local ped = cache.ped
	local maxHealth = 200
	if not full then
		local health = GetEntityHealth(ped)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(ped, newHealth)
	else
		SetEntityHealth(ped, maxHealth)
	end
end)

RegisterNetEvent('wsk-ambulance:client:noodvoeding:player', function(targetId)
	TriggerEvent('esx_status:set', 'hunger', 250000)
	TriggerEvent('esx_status:set', 'thirst', 250000)
end)
