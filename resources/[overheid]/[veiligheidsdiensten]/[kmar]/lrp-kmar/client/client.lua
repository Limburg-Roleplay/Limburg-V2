local ox_inventory = exports['ox_inventory']
local lrp = { Functions = {} }
ESX = nil

local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
JobName = nil
local PlayerData = {}
local JobName = nil

        
clothing = {
	ped = false,
	headBlend = false,
	faceFeatures = false,
	headOverlays = false,
	components = true,
	props = true,
	tattoos = false,
	text = '[E] - Kleding'
},

Citizen.CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()

	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	DrawBlips()
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
	ESX.SetPlayerData('job', Job)
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(Job)
	ESX.PlayerData.job2 = Job
	ESX.SetPlayerData('job2', Job)
end)

local targetVehPed
local noodknopBlip

RegisterNetEvent('lrp-kmar:client:people:shooted')
AddEventHandler('lrp-kmar:client:people:shooted', function(label, shooterCoords)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = Vdist(coords, shooterCoords)
	if ESX.PlayerData.job.name == 'kmar' or ESX.PlayerData.job2.name == 'bsb' then
		if distance <= 2700 then
			if distance <= 1150 then
				if distance <= 100 then
					ESX.ShowNotification('info', label..' gesignaleerd in de buurt, melding staat op de gps aangegeven!', 5000)
				else
					Citizen.Wait(35)
					ESX.ShowNotification('info', label..' gesignaleerd in de buurt, melding staat op de gps aangegeven!', 5000)
					local gunshotBlip = AddBlipForRadius(shooterCoords, 1200.0)
					SetBlipSprite(gunshotBlip, 161)
					SetBlipColour(gunshotBlip, 1)
					SetBlipAsShortRange(gunshotBlip, 0)
					Wait(25000)
					RemoveBlip(gunshotBlip)
				end
			elseif math.random(3) > 1 then
				Citizen.Wait(35)
				ESX.ShowNotification('info',label..' gesignaleerd in de buurt, melding staat op de gps aangegeven!', 5000)
				local gunshotBlip = AddBlipForRadius(shooterCoords, 1200.0)
				SetBlipSprite(gunshotBlip, 161)
				SetBlipColour(gunshotBlip, 1)
				SetBlipAsShortRange(gunshotBlip, 0)
				Wait(25000)
				RemoveBlip(gunshotBlip)
			end
		end
	else
		if distance <= 2000 then
			if distance <= 450 then
				if distance <= 100 then
					ESX.ShowNotification('info',label..' gesignaleerd in de buurt, melding staat op de gps aangegeven!', 5000)
				else
					Citizen.Wait(35)
					ESX.ShowNotification('info',label..' gesignaleerd in de buurt, melding staat op de gps aangegeven!', 5000)
					local gunshotBlip = AddBlipForRadius(shooterCoords, 1200.0)
					SetBlipSprite(gunshotBlip, 161)
					SetBlipColour(gunshotBlip, 1)
					SetBlipAsShortRange(gunshotBlip, 0)
					Wait(20000)
					RemoveBlip(gunshotBlip)
				end
			elseif math.random(3) == 3 then
				Citizen.Wait(35)
				ESX.ShowNotification('info',label..' gesignaleerd in de buurt, melding staat op de gps aangegeven!', 5000)
				local gunshotBlip = AddBlipForRadius(shooterCoords, 1200.0)
				SetBlipSprite(gunshotBlip, 161)
				SetBlipColour(gunshotBlip, 1)
				SetBlipAsShortRange(gunshotBlip, 0)
				Wait(20000)
				RemoveBlip(gunshotBlip)
			end
		end
	end
end)

RegisterNetEvent('lrp-kmar:client:noodknop')
AddEventHandler('lrp-kmar:client:noodknop', function(name, coords)
    local playerJob = ESX.PlayerData.job.name
    if playerJob == 'kmar' or playerJob == 'kmar' or playerJob == 'bsb' then
        ESX.ShowNotification('noodknop', 'Spoedassistentie! ' .. name .. ' heeft de Noodknop ingedrukt!', 10000)
        noodknopgeluid()
        local noodknopBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(noodknopBlip, 161)
        SetBlipDisplay(noodknopBlip, 4)
        SetBlipScale(noodknopBlip, 1.0)
        SetBlipAsShortRange(noodknopBlip, true)
        SetBlipColour(noodknopBlip, 59)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName('Noodknop [' .. name .. ']')
        EndTextCommandSetBlipName(noodknopBlip)

        local blip = noodknopBlip
        Citizen.SetTimeout(115000, function()
            if blip then
                RemoveBlip(blip)
            end
        end)
    else
    end
end)

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end

	exports['qtarget']:Player({
		options = {
			{
				event = 'lrp-kmar:client:give:fine',
				icon = 'fa-solid fa-clipboard',
				label = 'Boete uitschrijven',
				job = 'kmar',
		    },
		    {
			    event = "lrp-ambulance:client:ped-inter:revive",
			    icon = "fas fa-suitcase-medical",
			    label = "Omhoog helpen",
			    job = 'kmar',
			},      
		},
		distance = 2
	})



	exports['qtarget']:Vehicle({
		options = {
			{
				event = 'lrp-kmar:client:shut:vehicle',
				icon = 'fa-solid fa-car',
				label = 'Voertuig openbreken',
				job = 'kmar'
			},
		},
		distance = 2
	})
end)

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end
	local weapons = exports['es_extended']:getWeaponConfig()
	while true do
		local sleep = 1
		local ped = PlayerPedId()
		local shooting = IsPedShooting(ped)
		local shooterCoords = GetEntityCoords(ped)
		if ESX.PlayerData.job.name ~= 'kmar' and ESX.PlayerData.job.name ~= 'kmar' and shooting then
			while IsPedShooting(ped) do
				Wait(5000) -- 5 seconde
			end

			local weapon = GetSelectedPedWeapon(ped)

			if weapon ~= GetHashKey('WEAPON_STUNGUN') and weapon ~= GetHashKey('weapon_fireextinguisher') and not IsPedCurrentWeaponSilenced(ped) then
				for k,v in pairs(weapons) do
					if GetHashKey(v.name) == weapon then
						if IsPedArmed(ped, 4) then
							TriggerServerEvent('lrp-kmar:server:people:shooted', v.name, 'Vuurwapen', shooterCoords)
							break
						end
					end
				end
			end
		end
		Wait(sleep)
	end
end)

DrawBlips = function()
	for i=1, #Config.Blips, 1 do
		local v = Config.Blips[i]
		local blip = AddBlipForCoord(v.Coords)
		SetBlipSprite(blip, Config.BlipSprite)
		SetBlipDisplay(blip, Config.BlipDisplay)
		SetBlipScale(blip, Config.BlipScale)
		SetBlipColour(blip, Config.BlipColour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.BlipLabel)
		EndTextCommandSetBlipName(blip)
	end
end

IsPlayerJob = function()
	local bool = ESX.PlayerData.job.name == 'kmar' and true or ESX.PlayerData.job.name == 'offkmar' and true or false
	return bool
end

IsPlayerOnDuty = function()
	local bool = ESX.PlayerData.job.name == 'kmar' and true or false
	return bool
end

IsPlayerKmarOnDuty = function()
	local bool = ESX.PlayerData.job.name == 'kmar' and true or ESX.PlayerData.job.name == 'offkmar' and true or false
	return bool
end

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end

	for k,v in pairs(Config.Vehicles.cars) do 
		for l,v in pairs(v.vehicles) do
			AddTextEntry(v.spawnName, v.name)
		end	
	end

	for k,v in pairs(Config.Vehicles.air) do 
		for l,v in pairs(v.vehicles) do
			AddTextEntry(v.spawnName, v.name)
		end	
	end

	for k,v in pairs(Config.Vehicles.sea) do 
		for l,v in pairs(v.vehicles) do
			AddTextEntry(v.spawnName, v.name)
		end	
	end
    
    while true do
		local sleep = 500
		if IsPlayerOnDuty() then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			for k,v in pairs(Config.Locations) do
				if v.rank == nil then v.rank = 0 end
				if v.rank <= tonumber(ESX.PlayerData.job.grade) and (v.target == nil or v.target == false) then
					if (v.drawText == 'Voertuig wegzetten' and IsPedInAnyVehicle(playerPed, true)) or (v.drawText == 'Impound' and IsPedInAnyVehicle(playerPed, true)) or v.drawText ~= 'Voertuig wegzetten' or v.drawText ~= 'Impound' then
						local dist = #(coords - v.coords)
						if dist <= 20.0 and dist > 1.0 then
							sleep = 0
							if v.drawText == 'Voertuig wegzetten' or v.drawText == 'Impound' then
								if v.deleteType == 'heli' then
									if IsPedInAnyHeli(playerPed) then
										ESX.DrawBasicMarker(v.coords, 255, 0, 0)
									end
								elseif v.deleteType == 'boot' then
									if IsPedInAnyBoat(playerPed) then
										ESX.DrawBasicMarker(v.coords, 255, 0, 0)
									end
								else
									ESX.DrawBasicMarker(v.coords, 255, 0, 0)
								end
							else
								ESX.DrawBasicMarker(v.coords, 0, 74, 154)
							end
						elseif dist < 1.0 then
							sleep = 0
							if v.drawText ~= nil then
								if v.drawText == 'Voertuig wegzetten' or v.drawText == 'Impound' then
									if v.deleteType == 'heli' then
										if IsPedInAnyHeli(playerPed) then
											exports['frp-interaction']:Interaction('error', '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
											ESX.DrawBasicMarker(v.coords, 255, 0, 0)
										end
									elseif v.deleteType == 'boot' then
										if IsPedInAnyBoat(playerPed) then
											exports['frp-interaction']:Interaction('error', '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
											ESX.DrawBasicMarker(v.coords, 255, 0, 0)
										end
									else
										exports['frp-interaction']:Interaction('error', '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
										ESX.DrawBasicMarker(v.coords, 255, 0, 0)
									end
								else
									exports['frp-interaction']:Interaction({r = '0', g = '74', b = '154'}, '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
									ESX.DrawBasicMarker(v.coords, 0, 74, 154)
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
			for k,v in pairs(Config.Locations) do
				if v.drawText == 'In-/uitklokken' then
					local dist = #(coords - v.coords)
					if dist <= 20.0 and dist > 1.0 then
						sleep = 0
						ESX.DrawBasicMarker(v.coords, 0, 74, 154)
					elseif dist < 1.0 then
						sleep = 0
						if v.drawText ~= nil then
							exports['frp-interaction']:Interaction({r = '0', g = '74', b = '154'}, '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
							ESX.DrawBasicMarker(v.coords, 0, 74, 154)
							if IsControlJustReleased(0, 38) then
								if v.type == nil then v.type = 'default' end
								v['functionDefine'](v.type, k);
							end
						end
					end
				elseif v.drawText == 'Omkleden' then
					local dist = #(coords - v.coords)
					if dist <= 20.0 and dist > 1.0 then
						sleep = 0
						ESX.DrawBasicMarker(v.coords, 0, 74, 154)
					elseif dist < 1.0 then
						sleep = 0
						if v.drawText ~= nil then
							exports['frp-interaction']:Interaction({r = '0', g = '74', b = '154'}, '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
							ESX.DrawBasicMarker(v.coords, 0, 74, 154)
							if IsControlJustReleased(0, 38) then
								if v.type == nil then v.type = 'default' end
								v['functionDefine'](v.type, k);
							end
						end
					end
				end
			end
		elseif IsPlayerKmarOnDuty() then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			for k,v in pairs(Config.Locations) do
				if v.drawText == 'Omkleden' then
					local dist = #(coords - v.coords)
					if dist <= 20.0 and dist > 1.0 then
						sleep = 0
						ESX.DrawBasicMarker(v.coords, 0, 74, 154)
					elseif dist < 1.0 then
						sleep = 0
						if v.drawText ~= nil then
							exports['frp-interaction']:Interaction({r = '0', g = '74', b = '154'}, '[E] - ' .. v.drawText, v.coords, 2.5, GetCurrentResourceName() .. '-action-' .. tostring(k))
							ESX.DrawBasicMarker(v.coords, 0, 74, 154)
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
	if type == 'boten' then 
		configType = Config.Vehicles.sea
	end
	local categories = {}

	for i=1, #configType do
		if configType[i].rank <= tonumber(ESX.PlayerData.job.grade) then
 			if configType[i].category ~= 'Brigade Speciale BeveiligingsOpdrachten' and configType[i].category ~= 'Recherche' then
				categories[#categories+1] = {
					title = configType[i].category,
					description = configType[i].description,
					arrow = true,
					onSelect = function(args)
						OpenVehiclesMenu(type, configType, args)
					end,
					args = { category = i, garageIndex = id }
				}
			elseif configType[i].category == 'Brigade Speciale BeveiligingsOpdrachten' and ESX.PlayerData.job.name == 'kmar' and ESX.PlayerData.job.grade >= 8 then
				categories[#categories+1] = {
					title = configType[i].category,
					description = configType[i].description,
					arrow = true,
					onSelect = function(args)
						OpenVehiclesMenu(type, configType, args)
					end,
					args = { category = i, garageIndex = id }
				}
			elseif configType[i].category == 'Recherche' and ESX.PlayerData.job2.name == 'recherche' then
				categories[#categories+1] = {
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
	end

	lib.registerContext({
		id = 'p:garage-menu',
		title = 'KMAR: Garage',
		options = categories
	})

	lib.showContext('p:garage-menu')
end

OpenVehiclesMenu = function(type, configType, data)
	local vehicles = {}

	for i=1, #configType[data.category].vehicles do 
		vehicles[#vehicles+1] = {
			title = configType[data.category].vehicles[i].name,
			event = 'lrp-kmar:client:spawn:vehicle',
			args = { vehicleName = configType[data.category].vehicles[i].spawnName, garageIndex = data.garageIndex, category = data.category}
		}
	end

	lib.registerContext({
		id = 'p:garage-menu:vehicles',
		title = 'KMAR: Garage',
		options = vehicles
	})

	lib.showContext('p:garage-menu:vehicles')
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

JobName = nil
local JobName = nil

RegisterNetEvent('lrp-kmar:client:open:stash')
AddEventHandler('lrp-kmar:client:open:stash', function()
	if ESX.PlayerData.job.name == 'kmar' then
		exports.ox_inventory:openInventory('stash', {id=JobName .. '_stash'})
	end
end)


GetGear = function()
		local options = {
			[1] = {
				['title'] = 'KMAR | Uitrusting Kluis',
				['description'] = 'Bekijk de KMAR uitrusting kluis',
				['event'] = 'lrp-kmar:client:buy:weapon',
				['icon'] = 'fa-solid fa-gun'
			},
			[2] = {
				['title'] = 'BSB | Uitrusting Kluis',
				['description'] = 'Bekijk de bsb uitrusting kluis',
				['event'] = 'lrp-kmar:client:buy:bsbweapon',
				['icon'] = 'fa-solid fa-gun',
			},
			[3] = {
				['title'] = 'HRB | Uitrusting Kluis',
				['description'] = 'Bekijk de HRB uitrusting kluis',
				['event'] = 'lrp-kmar:client:buy:hrbweapon',
				['icon'] = 'fa-solid fa-gun',
			},
        	[4] = {
                title = "KMAR | Persoonlijke Opslag",
                description = "Open je persoonlijke opslag",
				icon = 'fa-solid fa-box',
                onSelect = function()
					exports.ox_inventory:openInventory('stash', {id='personalkmar', owner=ESX.PlayerData.identifier})
                end,
            
			},
			[5] = {
				['title'] = 'Wapens verwijderen',
				['description'] = 'Verwijder wapens uit je inventaris',
				['event'] = 'lrp-kmar:client:delete:weapon:menu',
            	['icon'] = 'fa-sold fa-gun'
			}
		}

		lib.registerContext({
			id = 'k:buy-stash',
			title = 'KMAR: Bekijk opties van wapenkamer',
			options = options
		})

		lib.showContext('k:buy-stash')
end


OnOffDuty = function()
	exports['lrp-jobsmenu']:ToggleDuty(ESX.PlayerData.job.name)
end

RegisterNetEvent('lrp-kmar:client:own:cloakroom')
AddEventHandler('lrp-kmar:client:own:cloakroom', function()
	if ESX.PlayerData.job.name == 'kmar' or ESX.PlayerData.job.name == 'offkmar' then
		--exports['ox_appearance']:showOutfitMenu()
		ESX.TriggerServerCallback('exios-appartments:server:receive:clothing', function(outfits)
        if outfits then 
            for i=1, #outfits do 
                opts[#opts+1] = {
                    title = outfits[i]['name'],
                    icon = 'fas fa-socks',
                    description = 'Opties bekijken van ' .. outfits[i]['name'] .. '.', 
                    args = { name = outfits[i]['name'], outfitModel = outfits[i]['outfitModel'], outfitComponents = outfits[i]['outfitComponents'], outfitProps = outfits[i]['outfitProps'] },
                    event = 'exios-appartments:client:change:clothing:menu'
                }
            end
        end

        lib.registerContext({
            id = 'exios-appartments:client:interaction:clothing',
            title = 'Kledingkast',
            options = opts
        })

        lib.showContext('exios-appartments:client:interaction:clothing')
    end)
	end
end)

RegisterNetEvent('lrp-kmar:client:kmar:cloakroom')
AddEventHandler('lrp-kmar:client:kmar:cloakroom', function()
	if ESX.PlayerData.job.name == 'kmar' or ESX.PlayerData.job.name == 'offkmar' then
		exports['lrp-jobsmenu']:OpenOutfitMenu(Config.Outfits)
	end
end)

RegisterNetEvent('lrp-kmar:client:kmar:cloakroom:shop')
AddEventHandler('lrp-kmar:client:kmar:cloakroom:shop', function()
	exports['fivem-appearance']:startPlayerCustomization(function(appearance)
		exports['es_extended']:staticBypass(false)
		
		if (appearance) then
			if ESX then
				TriggerServerEvent('esx_skin:save', appearance)
			else
				TriggerServerEvent('ox_appearance:save', appearance)
			end
		end
	end, clothing)
end)

RegisterNetEvent('lrp-kmar:client:buy:weapon')
AddEventHandler('lrp-kmar:client:buy:weapon', function()
	exports.ox_inventory:openInventory('shop', {type = 'kmarkluis'})
end)

RegisterNetEvent('lrp-kmar:client:buy:bsbweapon')
AddEventHandler('lrp-kmar:client:buy:bsbweapon', function()
	if ESX.PlayerData.job.name == 'kmar' then
		exports.ox_inventory:openInventory('shop', {type = 'bsbkluis'})
	else
		exports['lrp-notifications']:Notify('error', 'Hier ben jij niet bevoegd tot!', 5000)
		lib.showContext('k:buy-stash')
	end
end)

RegisterNetEvent('lrp-kmar:client:buy:hrbweapon')
AddEventHandler('lrp-kmar:client:buy:hrbweapon', function()
	if ESX.PlayerData.job.name == 'kmar' then
		exports.ox_inventory:openInventory('shop', {type = 'hrbkluis'})
	else
		exports['lrp-notifications']:Notify('error', 'Hier ben jij niet bevoegd tot!', 5000)
		lib.showContext('k:buy-stash')
	end
end)

RegisterNetEvent('lrp-kmar:client:buy:rechercheweapon')
AddEventHandler('lrp-kmar:client:buy:rechercheweapon', function()
	if ESX.PlayerData.job2.name == 'recherche' then
		exports.ox_inventory:openInventory('shop', {type = 'recherchekluis'})
	else
		exports['lrp-notifications']:Notify('error', 'Hier ben jij niet bevoegd tot!', 5000)
		lib.showContext('k:buy-stash')
	end
end)

CloakroomMenu = function()
	if ESX.PlayerData.job.name == 'kmar' or ESX.PlayerData.job.name == 'offkmar' then
		local options = {
			[1] = {
				['title'] = 'Algemene kleedkamer',
				['description'] = 'Bekijk de KMAR outfits',
				['event'] = 'lrp-kmar:client:kmar:cloakroom'
			},
			[2] = {
				['title'] = 'Kleding Menu',
				['description'] = 'Open een Kleding Menu zoals in de winkel.',
				['event'] = 'lrp-kmar:client:kmar:cloakroom:shop'
			}
		}

		lib.registerContext({
			id = 'p:check-cloakroom',
			title = 'KMAR: Bekijk opties van Kleedkamer',
			options = options
		})
		
		lib.showContext('p:check-cloakroom')
	elseif ESX.PlayerData.job.name == 'kmar' or ESX.PlayerData.job.name == 'offkmar' then
		local options = {
			[1] = {
				['title'] = 'Persoonlijke kleedkamer',
				['description'] = 'Bekijk je eigen outfits',
				['event'] = 'lrp-kmar:client:own:cloakroom'
			},
			[2] = {
				['title'] = 'Algemene kleedkamer',
				['description'] = 'Bekijk de Kmar outfits',
				['event'] = 'lrp-kmar:client:kmar:cloakroom'
			}
		}
	
		lib.registerContext({
			id = 'p:check-cloakroom',
			title = 'Kmar: Bekijk opties van Kleedkamer',
			options = options
		})
	
		lib.showContext('p:check-cloakroom')
	end
end

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do Wait(0) end
	RequestAnimDict('random@arrests')
	while true do
		local sleep = 500
		local count = 0
		if ESX.PlayerData.job.name == 'kmar' then
			sleep = 0
			if IsControlJustPressed(0, 57) then
					TaskPlayAnim(PlayerPedId(), 'random@arrests', 'generic_radio_chatter', 8.0, -8, -1, 49, 0, 0, 0, 0)
					noodknopgeluid()
				while IsControlPressed(0, 57) and count < 2 do
					Wait(1000)
					count = count + 1
				end

				if count >= 2 then
					TriggerServerEvent('lrp-kmar:server:noodknop')
					ClearPedTasks(PlayerPedId())
				else
					ESX.ShowNotification('error', 'Je hebt jouw Noodknop geannuleerd!')
				end
			end
		end

		Wait(sleep)
	end
end)

function noodknopgeluid()
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
	Wait(1000)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
	Wait(1000)
	PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0)
end

RegisterNetEvent('lrp-kmar:client:spawn:vehicle')
AddEventHandler('lrp-kmar:client:spawn:vehicle', function(data)
	local garage = Config.Locations[data.garageIndex]
	local vehicle = data.vehicleName
	local foundPoint = false
	local props = {['plate'] = 'POL' .. math.random(111111, 999999)}
	if data.category == 8 or data.category == 3 then -- bsb
		local props = {['plate'] = 'POL  '..math.random(111, 999)}
		for i=1, #garage.spawnPoints, 1 do 
			if ESX.Game.IsSpawnPointClear(vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), 2.0) then 
				ESX.Game.SpawnVehicle(vehicle, vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), garage.spawnPoints[i].w, function(veh)
					TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
					SetVehicleNumberPlateText(veh, props.plate)
					SetVehicleExtra(veh, 0, true)
					SetVehicleExtra(veh, 1, true)
					SetVehicleExtra(veh, 2, true)
					SetVehicleExtra(veh, 3, true)
					SetVehicleExtra(veh, 4, true)
					SetVehicleNumberPlateTextIndex(veh, 1)
					SetVehicleDirtLevel(veh, 0.0)
					props['modXenon'] = 1
					props['modTurbo'] = 1
					props['modEngine'] = 3
					props['modTransmission'] = 2
					props['modBrakes'] = 2
					props['modArmor'] = 4
					SetVehicleWindowTint(veh, 5)
					ESX.Game.SetVehicleProperties(veh, props)
					exports['lrp-benzine']:setFuel(veh, 100.0)
					TriggerServerEvent('lrp-garage:server:set:distanceculling', NetworkGetNetworkIdFromEntity(veh))
				end, true, props.plate)
				foundPoint = true 
				break
			end
		end
	elseif data.category == 9 then -- Recherche
		local props = {['plate'] = 'POL  '..math.random(111, 999)}
		for i=1, #garage.spawnPoints, 1 do 
			if ESX.Game.IsSpawnPointClear(vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), 2.0) then 
				ESX.Game.SpawnVehicle(vehicle, vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), garage.spawnPoints[i].w, function(veh)
					TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
					SetVehicleNumberPlateText(veh, props.plate)
					SetVehicleExtra(veh, 0, true)
					SetVehicleExtra(veh, 1, true)
					SetVehicleExtra(veh, 2, true)
					SetVehicleExtra(veh, 3, true)
					SetVehicleExtra(veh, 4, true)
					SetVehicleNumberPlateTextIndex(veh, 1)
					SetVehicleDirtLevel(veh, 0.0)
					props['modXenon'] = 1
					props['modTurbo'] = 1
					props['modEngine'] = 3
					props['modTransmission'] = 2
					props['modBrakes'] = 2
					props['modArmor'] = 4
					ESX.Game.SetVehicleProperties(veh, props)
					exports['lrp-benzine']:setFuel(veh, 100.0)
					TriggerServerEvent('lrp-garage:server:set:distanceculling', NetworkGetNetworkIdFromEntity(veh))
				end, true, props.plate)
				foundPoint = true 
				break
			end
		end
	elseif data.category ~= 3 then
		for i=1, #garage.spawnPoints, 1 do 
			if ESX.Game.IsSpawnPointClear(vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), 2.0) then 
				ESX.Game.SpawnVehicle(vehicle, vector3(garage.spawnPoints[i].x, garage.spawnPoints[i].y, garage.spawnPoints[i].z), garage.spawnPoints[i].w, function(veh)
					TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
					SetVehicleNumberPlateText(veh, props.plate)
					exports['lrp-benzine']:setFuel(veh, 100.0)
					TriggerServerEvent('lrp-garage:server:set:distanceculling', NetworkGetNetworkIdFromEntity(veh))
				end, true, props.plate)
				foundPoint = true 
				break
			end
		end
	end

	if not foundPoint then
		exports['lrp-notifications']:Notify('error', 'Er zijn geen lege parkeerplekken!', 5000)
	end
end)

RegisterNetEvent('lrp-kmar:client:search:player')
AddEventHandler('lrp-kmar:client:search:player', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
	local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

	if distance < 2.0 then 
		local targetPed = GetPlayerPed(entityPlayer)
		local targetHeading = GetEntityHeading(entityPlayer)
		local targetCoords = GetOffsetFromEntityInWorldCoords(targetPed, 0.0, -1.0, 0.0)
		local ped = PlayerPedId()

		ESX.Streaming.RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
		TaskPlayAnim(ped, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, 5500, 49, 0, false, false, false)

		exports.ox_inventory:openInventory('player', GetPlayerServerId(entityPlayer))
	else
		exports['lrp-notifications']:Notify('error', 'Deze persoon is niet meer in de buurt!', 5000)
	end
end)

RegisterNetEvent('lrp-kmar:client:shut:vehicle')
AddEventHandler('lrp-kmar:client:shut:vehicle', function(data)
	local entity = data.entity
	local ped = PlayerPedId()
	
	TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_WELDING', 0, true)
	Citizen.Wait(20000)
	ClearPedTasksImmediately(ped)

	TriggerServerEvent('lrp-kmar:server:unlock:vehicle', NetworkGetNetworkIdFromEntity(entity))

	SetVehicleDoorsLockedForAllPlayers(entity, false)
end)

RegisterNetEvent("lrp-kmar:client:delete:weapon:menu")
AddEventHandler("lrp-kmar:client:delete:weapon:menu", function()
	local items = exports.ox_inventory:GetPlayerItems()
	local options = {}

	for k, v in pairs(items) do
		if string.lower(v.name):match("^weapon_") then
			table.insert(options, {
				title = "Verwijder " .. v.label,
				description = 'Verwijder automatisch een vuurwapen',
				serverEvent = 'lrp-kmar:server:delete:weapon:menu',
				args = { weaponName = v.name }
			})
		end
	end
	
	if #options == 0 then
		ESX.ShowNotification('error', 'Je hebt geen vuurwapens op zak!', 5000)
	else
        lib.registerContext({
            id = 'mar_development_wapen',
            title = 'KMAR: Verwijder wapens',
            options = options
        })

        lib.showContext('mar_development_wapen')
	end
end)

RegisterNetEvent('lrp-kmar:client:give:fine')
AddEventHandler('lrp-kmar:client:give:fine', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))

	if distance < 2.0 then
		local options = {
			{
				['title'] = 'Zoek een boete',
				['description'] = 'Zoek hiermee sneller een boete',
				['event'] = 'lrp-kmar:client:search:fine:list',
				['args'] = { entity = entity }
			}
		}

		for k,v in pairs(Config.Fines) do
			options[#options+1] = {
				title = k,
				event = 'lrp-kmar:client:give:fine:list',
				args = { fineId = k, entity = entity }
			}
		end

		lib.registerContext({
			id = 'p:see-fines',
			title = 'KMAR: bekijk boetes',
			options = options
		})

		lib.showContext('p:see-fines')
	end
end)

RegisterNetEvent('lrp-kmar:client:search:fine:list')
AddEventHandler('lrp-kmar:client:search:fine:list', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))

	if distance < 2.0 then
		local input = lib.inputDialog('Zoek een boete', {'Boete beschrijving'})
		if input then 
			local reason = input[1]
			local found = {}
			local options = {}

			for k,v in pairs(Config.Fines) do
				for i=1, #Config.Fines[k] do
					if string.find(Config.Fines[k][i].label, reason) then
						found[#found+1] = {
							['label'] = Config.Fines[k][i].label,
							['amount'] = Config.Fines[k][i].amount,
							['farmID'] = k,
							['number'] = i
						}
					end
				end
			end

			for i=1, #found do
				options[#options+1] = {
					title = found[i].label .. ' | € ' .. found[i].amount,
					event = 'lrp-kmar:client:give:fine:finalise',
					args = { fineId = found[i].farmID, fine = found[i].number, entity = entity }
				}
			end

			if next(options) then
				lib.registerContext({
					id = 'p:searched-fines',
					title = 'KMAR: bekijk boetes',
					options = options
				})
		
				lib.showContext('p:searched-fines')
			else
				ESX.ShowNotification('error', 'Er zijn geen boetes gevonden..')
			end
		end
	end
end)

RegisterNetEvent('lrp-kmar:client:give:fine:list')
AddEventHandler('lrp-kmar:client:give:fine:list', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))

	if distance < 2.0 then
		local options = {}
		for i=1, #Config.Fines[data.fineId] do
			options[#options+1] = {
				title = Config.Fines[data.fineId][i].label .. ' | € ' .. Config.Fines[data.fineId][i].amount,
				event = 'lrp-kmar:client:give:fine:finalise',
				args = { fineId = data.fineId, fine = i, entity = entity }
			}
		end

		lib.registerContext({
			id = 'p:see-fines-list',
			title = 'KMAR: bekijk boetes',
			options = options
		})

		lib.showContext('p:see-fines-list')
	end
end)

RegisterNetEvent('lrp-kmar:client:give:fine:finalise')
AddEventHandler('lrp-kmar:client:give:fine:finalise', function(data)
	local entityPlayer = ESX.Game.GetPlayerFromPed(data.entity)
	local playerid = GetPlayerServerId(entityPlayer)

	TriggerServerEvent('esx_billing:sendBill', playerid, 'society_kmar', Config.Fines[data.fineId][data.fine].label, Config.Fines[data.fineId][data.fine].amount)
    exports["lrp-notifications"]:Notify("success", "Je hebt je factuur verstuurd!", 3000)
end)


Citizen.CreateThread(function()
	while true do 
		local sleep = 750 
		if isHandcuffed then 
			sleep = 0 
			DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1

            DisableControlAction(0, Config.Keys['R'], true) -- Reload
            DisableControlAction(0, Config.Keys['SPACE'], true) -- Jump
            DisableControlAction(0, Config.Keys['Q'], true) -- Cover
            DisableControlAction(0, Config.Keys['TAB'], true) -- Select Weapon
            DisableControlAction(0, Config.Keys['F'], true)
            DisableControlAction(0, Config.Keys['M'], true)
            DisableControlAction(0, Config.Keys['CAPS'], true) -- Also 'enter'?

            DisableControlAction(0, 157, true) -- 1
            DisableControlAction(0, 158, true) -- 2
            DisableControlAction(0, 160, true) -- 3
            DisableControlAction(0, 164, true) -- 4
            DisableControlAction(0, 165, true) -- 5

            DisableControlAction(0, Config.Keys['F1'], true) -- Disable phone
            DisableControlAction(0, Config.Keys['F2'], true) -- Inventory
            DisableControlAction(0, Config.Keys['F3'], true) -- Animations
            DisableControlAction(0, Config.Keys['F6'], true) -- Job

            DisableControlAction(0, Config.Keys['C'], true) -- Disable looking behind
            DisableControlAction(0, Config.Keys['X'], true) -- Disable clearing animation
            DisableControlAction(2, Config.Keys['P'], true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, Config.Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(0, 21, true) -- Disable Spriting

            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            if IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) ~= 1 and IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3) ~= 1 then
                RequestAnimDict("mp_arresting")
                TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
		else
			sleep = 750
		end
		Citizen.Wait(sleep)
	end
end)


ESX = exports["es_extended"]:getSharedObject()

-- F6 Menu + actions begin

local mainElements = {
  {label = "Fouilleren", value = "fouilleren"},
  {label = "Handboeien", value = "cuff"},
  {label = 'Bekijk ID', value = 'id_card'},
  {label = 'Bekijk rijbewijzen', value = "id_id_card"},
  {label = "Ontboeien", value = "uncuff"},
  {label = "Begeleiden", value = "escort"},
  {label = "In voertuig zetten", value = "invoertuig"},
  {label = "Uit voertuig zetten", value = "uitvoertuig"},
  {label = "Gevangenis Menu", value = "gevangenis"},
  {label = 'Reanimeren', value = "revive"},
  {label = 'Objecten plaatsen', value="place_objects"}
}

local elements = {
    {label = "OBJECT VERWIJDEREN", value = "object_delete"}
}

function OpenObjectSpawner()
    if not IsActionAllowed() then
        lib.notify({
            title = 'Actie mislukt',
            description = 'Je hebt geen toestemming om deze actie te gebruiken.',
            type = 'error'
        })
        return
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawner', {
        title = 'Objecten plaatsen',
        align = 'top-right',
        elements = elements
    }, function(data2, menu2)

        local model = data2.current.value
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local forward = GetEntityForwardVector(playerPed)
        local x, y, z = table.unpack(coords + forward * 1.0)
    
        if model == "object_delete" then
            DeleteNearbyObject()
            return
        elseif model == "p_ld_stinger_s" then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local closestSpikeMat = GetClosestSpikeMat(playerCoords)
            TriggerServerEvent('loaf_spikestrips:spikestripMenu', coords)
        end

        obj = CreateObject(model, x, y, z, true, false, true)
        PlaceObjectOnGroundProperly(obj)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        SetModelAsNoLongerNeeded(model)
        SetEntityAsMissionEntity(obj)
    
    end, function(data2, menu2)
        menu2.close()
    end)
end

function DeleteNearbyObject()
    if not IsActionAllowed then return end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local object = ESX.Game.GetClosestObject(coords)
    local model = GetEntityModel(object)

    if GetEntityModel(object) == GetHashKey('prop_roadcone02a') 
        or GetEntityModel(object) == GetHashKey('prop_fncsec_03c') 
        or GetEntityModel(object) == GetHashKey('prop_fnclink_02k') 
        or GetEntityModel(object) == GetHashKey('prop_dummy_01') 
        or GetEntityModel(object) == GetHashKey('prop_fncsec_03d') 
        or GetEntityModel(object) == GetHashKey('prop_portaloo_01a') 
        or GetEntityModel(object) == GetHashKey('prop_barier_conc_05c') 
        or GetEntityModel(object) == GetHashKey('prop_roadcone02a') 
        or GetEntityModel(object) == GetHashKey('prop_air_conelight') 
        or GetEntityModel(object) == GetHashKey('prop_barrier_work06a') 
        or GetEntityModel(object) == GetHashKey('prop_container_01a') 
        or GetEntityModel(object) == GetHashKey('prop_gazebo_02') 
        or GetEntityModel(object) == GetHashKey('prop_worklight_03b') then

        ESX.Game.DeleteObject(object)
    end
end

local keybind = lib.addKeybind({
  name = 'kmarf6',
  description = 'F6-menu kmar',
  defaultKey = 'F6',
  onReleased = function(self)
    if IsActionAllowed() then
      OpenInteractionMenu()
    end
  end,
})

local keybind = lib.addKeybind({
  name = 'kmarf5object',
  description = 'F5-Object menu kmar',
  defaultKey = 'F5',
  onReleased = function(self)
    if IsActionAllowed() then
      OpenObjectSpawner()
    end
  end,
})


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job

  if ESX.PlayerData.job.name == 'kmar' then
    keybind:disable(false)
  else
    keybind:disable(true)
  end
end)

exports.ox_target:addSphereZone({
	coords = vec3(-388.5, -386.45, 25.0),
	radius = 0.5,
  debug = false,
  options = {
      {
          name = 'box',
          event = 'lrp-kmar:client:analyse:fingerprint',
          icon = 'fa-solid fa-magnifying-glass',
          label = 'Analyseren',
          groups = 'kmar',
          canInteract = function(entity, dist, coords)
            if dist > 10 then return false else return true end
          end,
      }
  }
})

RegisterNetEvent('lrp-kmar:client:analyse:fingerprint', function () 
    local playerId, playerPed, playerCoords = lib.getClosestPlayer(vec3(-392.2903, -386.8076, 25.0988), 1.2, true)
    local networkPlayer = NetworkGetPlayerIndexFromPed(playerPed)
    local netId = GetPlayerServerId(networkPlayer)

    if playerId == nil then       
      lib.notify({
          title = 'Actie mislukt',
          description = 'Er kan niemand gevonden worden bij het afnameapparaat',
          type = 'error',
          position = 'top',
      })
      return
    end

    TriggerServerEvent('lrp-kmar:server:analyse:fingerprint', netId)
end)

RegisterNetEvent('lrp-kmar:client:show:fingerprint')
AddEventHandler('lrp-kmar:client:show:fingerprint', function(data)
    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        label = 'Vingerafdrukken aan het analyseren...',
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'missfam4',
            clip = 'base'
        },
        prop = {
            model = `p_amb_clipboard_01`,
            bone = 36029,
            pos = vec3(0.16, 0.08, 0.01),
            rot = vec3(-130.0, -50.0, 0.0)
        },
    }) then 

        lib.registerContext({
            id = 'fingerprint_analysis',
            title = 'Analyse',
            options = {
              {
                title = data.firstname,
                description = 'Voornaam',
              },
              {
                title = data.lastname,
                description = 'Achternaam',
              },
              {
                title = data.sex,
                description = 'Geslacht',
              },
              {
                title = data.dateofbirth,
                description = 'Geboortedatum',
              }
            }
        })
    
        lib.showContext('fingerprint_analysis') 
    end
end)

function IsActionAllowed()
  local iskmar = ESX.PlayerData.job.name == 'kmar'

  if not iskmar then
    keybind:disable(true)
  end

  return iskmar
end

function OpenInteractionMenu()
  if IsActionAllowed() then
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "gang_main", {
      title = ESX.PlayerData.job.label,
      align = 'top-right',
      elements = mainElements
    }, function(data, menu) -- OnSelect Function
      local playerPed = PlayerPedId()
      local target, distance = ESX.Game.GetClosestPlayer()

      if target ~= -1 and distance <= 3.0 then
        local targetPed = GetPlayerPed(target)

        if DoesEntityExist(targetPed) then
          if data.current.value == "fouilleren" then
            menu.close()
            OpenBodySearchMenu()
          elseif data.current.value == "cuff" then
            TriggerEvent('jtm-development:kmar:client:cuff:player', { entity = targetPed })
          elseif data.current.value == "uncuff" then
            TriggerEvent('jtm-development:kmar:client:uncuff:player', { entity = targetPed })
          elseif data.current.value == "escort" then
            TriggerEvent('jtm-development:kmar:client:dragging', { entity = targetPed })
            ESX.TriggerServerCallback('jtm-development:kmar:getCuffed', function(canCuffed)
              if canCuffed then
                -- Add logic if needed when the player can be cuffed
              end
            end, GetPlayerServerId(target))
          elseif data.current.value == "invoertuig" then
            TriggerEvent('jtm-development:kmar:client:set:player:vehicle', { entity = targetPed })
            ESX.TriggerServerCallback('jtm-development:kmar:getCuffed', function(canCuffed)
              if canCuffed then
                -- Add logic if needed when the player can be cuffed
              end
            end, GetPlayerServerId(target))
          elseif data.current.value == "uitvoertuig" then
            TriggerEvent('jtm-development:kmar:client:set:player:vehicle', { entity = targetPed })
            ESX.TriggerServerCallback('jtm-development:kmar:getCuffed', function(canCuffed)
              if canCuffed then
                -- Add logic if needed when the player can be cuffed
              end
            end, GetPlayerServerId(target))
          elseif data.current.value == "gevangenis" then
            TriggerEvent('lrp-jail:openJailMenu')
			menu.close()
		  elseif data.current.value == "revive" then
			local coords = GetEntityCoords(PlayerPedId())
			local playerId, playerPed, playerCoords = lib.getClosestPlayer(coords, 3, false)
		
			local networkPlayer = NetworkGetPlayerIndexFromPed(playerPed)
			local playerId = GetPlayerServerId(networkPlayer)
			local count = exports.ox_inventory:Search('count', 'medkit')
			if count == 0 then
				lib.notify({
					title = 'Actie mislukt',
					description = 'Je hebt geen med-kit opzak.',
					type = 'error'
				})
			return end
			TriggerServerEvent('lrp-kmar:server:remove:item')
			
			if IsPedDeadOrDying(playerPed, 1) then
				local playerPed = PlayerPedId()
				local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
		
		
				for i=1, 15 do
					Citizen.Wait(900)
		
					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
				end
		
				TriggerServerEvent('lrp-ambulance:server:revive:player', playerId)
			else
				lib.notify({
					title = 'Actie mislukt',
					description = 'Deze speler heeft nog een hartslag.',
					type = 'error'
				})
			end
			elseif data.current.value == "id_card" then
				local coords = GetEntityCoords(PlayerPedId())
				local playerId, playerPed, playerCoords = lib.getClosestPlayer(coords, 3, false)
				local networkPlayer = NetworkGetPlayerIndexFromPed(playerPed)
				local playerId = GetPlayerServerId(networkPlayer)
				TriggerServerEvent('lrp-kmar:server:get:id', playerId)
			elseif data.current.value == "id_card_card" then
				local coords = GetEntityCoords(PlayerPedId())
				local playerId, playerPed, playerCoords = lib.getClosestPlayer(coords, 3, false)
				local networkPlayer = NetworkGetPlayerIndexFromPed(playerPed)
				local playerId = GetPlayerServerId(networkPlayer)
	
				TriggerServerEvent('lrp-kmar:server:get:id:id', playerId)
			end
        else
          ESX.ShowNotification('error', 'Geen speler dichtbij!', 5000)
        end
      else
        ESX.ShowNotification('error', 'Geen speler dichtbij!', 5000)
      end
    end, function(data, menu) -- Cancel Function
      menu.close()
    end)
  else
    ESX.ShowNotification('error', 'Action not allowed!', 5000)
  end
end

RegisterNetEvent('lrp-kmar:client:show:id')
AddEventHandler('lrp-kmar:client:show:id', function(data)
    lib.registerContext({
        id = 'identiteitkaart',
        title = 'Identiteitskaart',
        options = {
          {
            title = data.firstname,
            description = 'Voornaam',
          },
          {
            title = data.lastname,
            description = 'Achternaam',
          },
          {
            title = data.sex,
            description = 'Geslacht',
          },
          {
            title = data.dateofbirth,
            description = 'Geboortedatum',
          },
        }
    })

    lib.showContext('identiteitkaart') 
end)
RegisterNetEvent('lrp-kmar:client:show:id:id')
AddEventHandler('lrp-kmar:client:show:id:id', function(data)
    lib.registerContext({
        id = 'rijbewijzen_id',
        title = 'Rijbewijzen van burger',
        options = {
          {
            title = data.theorie,
            description = 'Theorie',
          },
          {
            title = data.rijbewijsA,
            description = 'Rijbewijs A',
          },
          {
            title = data.rijbewijsB,
            description = 'Rijbewijs B',
          }
        }
    })

    lib.showContext('rijbewijzen_id') 
end)



function OpenBodySearchMenu(player)
  local target = player or false

  if not target then
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 3.0 then
      exports["lrp-notifications"]:Notify("error", "Geen speler in de buurt!", 5000)
      return
    end

    target = GetPlayerServerId(closestPlayer)
  end

  local targetPlayer = GetPlayerFromServerId(target)

  if targetPlayer == -1 then
    exports["lrp-notifications"]:Notify("error", "Speler niet gevonden!", 5000)
    return
  end

  local playerPed = GetPlayerPed(targetPlayer)

  if DoesEntityExist(playerPed) then
    PlayBodySearchAnimation()

    exports["lrp-progressbar"]:Progress({
      name = "Fouilleren",
      duration = 3000, -- Adjust the time as needed
      label = "Fouilleren",
      useWhileDead = false,
      canCancel = false,
      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
      }
    })

    Citizen.Wait(3000) -- Adjust the time as needed

    exports.ox_inventory:openNearbyInventory(target)
  else
    exports["lrp-notifications"]:Notify("error", "De persoon die je probeert te fouilleren is dood!", 5000)
  end
end


function PlayBodySearchAnimation()
  local playerPed = PlayerPedId()
  local scenario = "PROP_HUMAN_PARKING_METER"

  if not IsPedOnFoot(playerPed) or not IsPedHuman(playerPed) then
    return
  end

  TaskStartScenarioInPlace(playerPed, scenario, 0, true)
  ClearPedTasks(playerPed)
end

exports("OpenBodySearchMenu", OpenBodySearchMenu)


local coords = vector3(1862.5193, 3689.9741, 34.2578)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - coords) 
        
        -- Draw the marker if the player is within 10 units of distance
        if distance < 10.0 then
            ESX.DrawBasicMarker(coords, 255, 0, 0)
        end
        
        -- Check if the player is close enough (within 2 units of distance)
        if distance < 2.0 then
            -- Display hint to press E
            ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to open the menu") -- This shows "Press E" on screen
            
            -- Check if the player presses the E key (INPUT_CONTEXT is E by default)
            if IsControlJustPressed(0, 38) then  -- 38 is the control index for the 'E' key (INPUT_CONTEXT)
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'kmar' and ESX.PlayerData.job.grade >= 16 then
                    lib.showContext('kmarmenu')
                else
                    ESX.ShowNotification('error', "You don't have access to this menu.")
                end
            end
        end
    end
end)


local coords2 = vector3(-432.8284, 6005.9229, 36.9957)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - coords2) 
        
        -- Draw the marker if the player is within 10 units of distance
        if distance < 10.0 then
            ESX.DrawBasicMarker(coords2, 255, 0, 0)
        end
        
        -- Check if the player is close enough (within 2 units of distance)
        if distance < 2.0 then
            -- Display hint to press E
            ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to open the menu") -- This shows "Press E" on screen
            
            -- Check if the player presses the E key (INPUT_CONTEXT is E by default)
            if IsControlJustPressed(0, 38) then  -- 38 is the control index for the 'E' key (INPUT_CONTEXT)
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'kmar' and ESX.PlayerData.job.grade >= 16 then
                    lib.showContext('kmarmenu')
                else
                    ESX.ShowNotification('error', "You don't have access to this menu.")
                end
            end
        end
    end
end)

lib.registerContext({
    id = 'kmarmenu', 
    title = 'KMAR Menu',
    options = {
      {
        title = 'Neem personeel aan',
        description = 'Neem een persoon aan.',
        icon = 'box',
        onSelect = function()
            Neempersonenaan()
        end,
      },
      {
        title = 'Beheer Personeel',
        description = 'Beheer al het KMAR personeel.',
        icon = 'clipboard',
        onSelect = function()
            Checkpersons()
        end,
      },
    }
})

Checkpersons = function()
    local check = {}
    local speler = PlayerPedId()
    local jobnaam = ESX.PlayerData.job.name
    ESX.TriggerServerCallback("lrp-kmar:check:gangmembers", function(datagang)
        for k,v in pairs(datagang) do 
            table.insert(check, {
                title = v.voornaam .. " " .. v.achternaam,
                description = 'Rang: ' .. v.grade,
                icon = 'user',
                onSelect = function()
                    OpenMenumembersboss(v)
                end
            })
        end
        lib.registerContext({
            id = 'kmarmenu-members',
            title = "KMAR Menu | Personeel",
            options = check
        })
        lib.showContext('kmarmenu-members')
    end, jobnaam)
end

OpenMenumembersboss = function(value)
    ESX.UI.Menu.CloseAll()

    local options = {
        {
            title = value.voornaam .. " Demoten",
            description = '',
            icon = 'fas fa-minus',
            onSelect = function()
                local input = lib.inputDialog('Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt degraderen?', {
                    {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
                })
            
                if not input[1] then 
                    TriggerEvent('eros-notifications', 'error', 'Je bent niet akkoord gegaan met deze medewerker te degraderen.')
                    return 
                end
                DemotePlayer(value.identifier, value.voornaam)
            end
        },
        {
            title = value.voornaam .. " Promoveren",
            description = '',
            icon = 'fas fa-plus',
            onSelect = function()
                local input = lib.inputDialog('Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt Promoveren?', {
                    {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
                })

                if not input[1] then 
                    TriggerEvent('eros-notifications', 'error', 'Je bent niet akkoord gegaan met deze medewerker te Promoveren.')
                    return 
                end
           PromotePlayer(value.identifier, value.voornaam)
        end
        },
        {
            title = value.voornaam .. " Ontslaan",
            description = '',
            icon = 'fas fa-fire',
            
            onSelect = function()

                local input = lib.inputDialog('Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt ontslaan?', {
                    {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
                })
            
                if not input[1] then 
                    TriggerEvent('eros-notifications', 'error', 'Je bent niet akkoord gegaan met deze medewerker te ontslaan.')
                    return 
                end

                Deletemembersboss(value.identifier, value.voornaam)
            end
        },
        {
            title = 'Ga terug',
            onSelect = function()
                checkpersons()
            end,
            icon = 'fas fa-arrow-left'
        }
    }

    lib.registerContext({
        id = 'kmarmenu-members-boss',
        title = "KMAR Menu | Members",
        options = options
    })
    lib.showContext('kmarmenu-members-boss')
end

-- Example of how to trigger the promotion event from client-side
function PromotePlayer(identifier, playerName)
    TriggerServerEvent("lrp-kmar:promotemember", identifier, playerName)
end

-- Example of how to trigger the demotion event from client-side
function DemotePlayer(identifier, playerName)
    TriggerServerEvent("lrp-kmar:demote", identifier, playerName)
end


function Deletemembersboss(x, y)
	TriggerServerEvent("lrp-kmar:deletemember:serversided", x, y)
end


function Neempersonenaan()

	local jobnamegang = ESX.PlayerData.job.name

    local input = lib.inputDialog('KMAR Menu | Aannemen', {'Voer een speler id in'})
	if not input then 
		return 
	end

	local playerid = tonumber(input[1])

	if playerid then
		ESX.TriggerServerCallback('lrp-kmar:add:playertogang', function(done)
			if done then
			end
		end, playerid, jobnamegang)
	else
	end
end