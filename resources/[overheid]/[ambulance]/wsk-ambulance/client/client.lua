ESX = exports["es_extended"]:getSharedObject()
isDead, disableKeys, inMenu, stretcher, stretcherMoving, isBusy = nil, nil, nil, nil, nil, nil
local isKnockoutThreadRunning = false
local playerLoaded
plyRequests = {}

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
	ESX.SetPlayerData('job', Job)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('wsk-ambulance:client:remove:brancard')
AddEventHandler('wsk-ambulance:client:remove:brancard', function(data)
    local entity = data.entity

    TriggerServerEvent('wsk-ambulance:server:remove:brancard', NetworkGetNetworkIdFromEntity(entity))
end)

AddEventHandler("onClientMapStart", function()
	exports.spawnmanager:spawnPlayer()
	Wait(5000)
	exports.spawnmanager:setAutoSpawn(false)
end)

DrawBlips = function()
	for i=1, #Config.Blips, 1 do
		local v = Config.Blips[i]
		local blip = AddBlipForCoord(v.Coords)
		SetBlipSprite(blip, Config.BlipSprite)
		SetBlipDisplay(blip, Config.BlipDisplay)
		SetBlipScale(blip, Config.BlipScale)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.BlipLabel)
		EndTextCommandSetBlipName(blip)
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    local ped = cache.ped
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    ESX.PlayerData = xPlayer
    playerLoaded = true

    -- Check of de speler dood is
    ESX.TriggerServerCallback('wasabi_ambulance:checkDeath', function(dead)
        if dead then
            respawnPlayer()
            ESX.ShowNotification('info', 'Je bent dood uitgelogd dus je inventory is gecleared. en je bent gerespawned bij ziekenhuis!')
            exports['wsk-ambulance']:combatlog()
        end
    end)

    if ESX.PlayerData.job.name == 'ambulance' then
        TriggerServerEvent('wasabi_ambulance:requestSync')
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if isKnockoutThreadRunning then
		isKnockoutThreadRunning = false
	end
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('wsk-ambulance:client:send:factuur')
AddEventHandler('wsk-ambulance:client:send:factuur', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))

	if distance < 2.0 then
		local options = {
			{
				['title'] = 'Zoek een dienst',
				['description'] = 'Zoek hiermee sneller een dienst',
				['event'] = 'wsk-ambulance:client:search:fine:list',
				['args'] = { entity = entity }
			}
		}

		for k,v in pairs(Config.Fines) do
			options[#options+1] = {
				title = k,
				event = 'wsk-ambulance:client:give:fine:list',
				args = { fineId = k, entity = entity }
			}
		end

		lib.registerContext({
			id = 'ambu:see-fines',
			title = 'Ambulance: bekijk diensten',
			options = options
		})

		lib.showContext('ambu:see-fines')
	end
end)

RegisterNetEvent('wsk-ambulance:client:search:fine:list')
AddEventHandler('wsk-ambulance:client:search:fine:list', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))

	if distance < 2.0 then
		local input = lib.inputDialog('Zoek een dienst', {'Dienst beschrijving'})
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
							['fineID'] = k,
							['number'] = i
						}
					end
				end
			end

			for i=1, #found do
				options[#options+1] = {
					title = found[i].label .. ' | € ' .. found[i].amount,
					event = 'wsk-ambulance:client:give:fine:finalise',
					args = { fineId = found[i].fineID, fine = found[i].number, entity = entity }
				}
			end

			if next(options) then
				lib.registerContext({
					id = 'ambu:searched-fines',
					title = 'Politie: bekijk diensten',
					options = options
				})
		
				lib.showContext('ambu:searched-fines')
			else
				ESX.ShowNotification('error', 'Er zijn geen diensten gevonden..')
			end
		end
	end
end)

AddEventHandler("entityDamaged", function(victim, culprit, weapon, baseDamage)
	if Config.knockOutWeapons[weapon] ~= nil then
		if victim == PlayerPedId() then
			if GetEntityHealth(victim) < 150 then
				KnockOutPlayerPed()
			end
		end
	end
end)

function KnockOutPlayerPed()
	if isKnockoutThreadRunning then
		return
	end
	TriggerServerEvent("wsk-ambulance:startKnockoutTimer")
	AnimpostfxPlay('DeathFailOut', 0, false)
	-- ESX.ShowNotification("Je bent bewusteloos.", { type = "warning", autoClose = 12000 })	
    lib.notify({
        title = 'Knockout',
        description = 'Je bent bewusteloos geslagen!',
        type = 'error'
    })
	isKnockoutThreadRunning = true
	Citizen.CreateThread(function ()
		while isKnockoutThreadRunning do
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
			Citizen.Wait(0)
		end
		isKnockoutThreadRunning = false
		WakeFromKnockout()
	end)
end

exports("IsKnockout", function()
	return isKnockoutThreadRunning
end)

RegisterNetEvent("wsk-ambulance:stopKnockout", function()
	isKnockoutThreadRunning = false
end)

function WakeFromKnockout()
	local playerPed = PlayerPedId()
	if AnimpostfxIsRunning("DeathFailOut") then
		AnimpostfxStop("DeathFailOut")
	end
	-- TriggerEvent("weapondeleter:playShakeEffect", 17)	
end

RegisterNetEvent('wsk-ambulance:client:give:fine:list')
AddEventHandler('wsk-ambulance:client:give:fine:list', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
	if distance < 2.0 then
		local options = {}
		for i=1, #Config.Fines[data.fineId] do
			options[#options+1] = {
				title = Config.Fines[data.fineId][i].label .. ' | € ' .. Config.Fines[data.fineId][i].amount,
				event = 'wsk-ambulance:client:give:fine:finalise',
				args = { fineId = data.fineId, fine = i, entity = entity }
			}
		end

		lib.registerContext({
			id = 'ambu:see-fines-list',
			title = 'ambulance: bekijk diensten',
			options = options
		})

		lib.showContext('ambu:see-fines-list')
	end
end)

RegisterNetEvent('wsk-ambulance:client:give:fine:finalise')
AddEventHandler('wsk-ambulance:client:give:fine:finalise', function(data)
	local entityPlayer = ESX.Game.GetPlayerFromPed(data.entity)
	local playerid = GetPlayerServerId(entityPlayer)

	TriggerServerEvent('esx_billing:sendBill', playerid, 'society_ambulance', Config.Fines[data.fineId][data.fine].label, Config.Fines[data.fineId][data.fine].amount)
end)

RegisterNetEvent('wasabi_ambulance:notify', function(title, desc, style, icon)
    if icon then
        lib.notify({
            title = title,
            description = desc,
            duration = 3500,
            icon = icon,
            type = style
        })
    else
        lib.notify({
            title = title,
            description = desc,
            duration = 3500,
            type = style
        })
    end
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
    if job.name == 'ambulance' then
        TriggerServerEvent('wasabi_ambulance:requestSync')
    end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		if isDead then
			sleep = 0
			ProcessCamControls()
			local ped = PlayerPedId()
			DisableInputGroup(0)
			DisableInputGroup(1)
			DisableInputGroup(2)

			DisableControlAction(1, 19, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 9, true)
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 289, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 73, true)
			DisableControlAction(0, 79, true)
			DisableControlAction(0, 305, true)
			DisableControlAction(0, 82, true)
			DisableControlAction(0, 182, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 8, true)
			DisableControlAction(2, 31, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(1, 33, true)
			DisableControlAction(1, 34, true)
			DisableControlAction(1, 35, true)
			DisableControlAction(1, 21, true)  -- space
			DisableControlAction(1, 22, true)  -- space
			DisableControlAction(1, 23, true)  -- F
			DisableControlAction(1, 24, true)  -- F
			DisableControlAction(1, 25, true)  -- F
			DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(1, 140, true) --Disables Melee Actions
			DisableControlAction(1, 141, true) --Disables Melee Actions
			DisableControlAction(1, 142, true) --Disables Melee Actions 
			DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
			DisablePlayerFiring(ped, true) -- Disable weapon firing
			if GetEntityHealth(ped) ~= 0 then
				SetEntityHealth(ped, 0)
			end
		end

		Wait(sleep)
	end
end)

AddEventHandler('esx:onPlayerSpawn', function()
    isDead = false
    local ped = cache.ped
    SetEntityMaxHealth(ped, 200)
    SetEntityHealth(ped, 200)
    SetPlayerHealthRechargeLimit(PlayerId(), 0.0)
    if firstSpawn then
        firstSpawn = false
        while not playerLoaded do
            Wait(1000)
        end
        lib.requestAnimDict('get_up@directional@movement@from_knees@action', 100)
        TaskPlayAnim(ped, 'get_up@directional@movement@from_knees@action', 'getup_r_0', 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    else
        AnimpostfxStopAll()
        lib.requestAnimDict('get_up@directional@movement@from_knees@action', 100)
        TaskPlayAnim(ped, 'get_up@directional@movement@from_knees@action', 'getup_r_0', 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    end
    TriggerServerEvent('wasabi_ambulance:setDeathStatus', false)
    RemoveAnimDict('get_up@directional@movement@from_knees@action')
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    ESX.UI.Menu.CloseAll()
    OnPlayerDeath()
end)

-- esx_ambulancejob compatibility
RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
    TriggerEvent("wsk-ambulance:client:staffrevive:player")
end)

-- Boss Menu

exports.ox_target:addBoxZone({
    coords = vector3(360.1422, -600.1005, 44.2012-1),
    size = vector3(2,2,2),
    rotation = 45,
    options = {
        {
            name = "ambulancemenu",
            label = "Ambulance Menu",
            icon = "fa-solid fa-clipboard",
            debug = drawZones,
            groups = { ['ambulance'] = 7 },
            onSelect = function ()
				lib.showContext('ambulancemenu')
			end
        }
    }
})

lib.registerContext({
    id = 'ambulancemenu', 
    title = 'Ambulance Menu',
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
        description = 'Beheer al het Ambulance personeel.',
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
    ESX.TriggerServerCallback("frp-ambulance:check:gangmembers", function(datagang)
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
            id = 'ambulancemenu-members',
            title = "Ambulance Menu | Personeel",
            options = check
        })
        lib.showContext('ambulancemenu-members')
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
        id = 'ambulancemenu-members-boss',
        title = "Ambulance Menu | Members",
        options = options
    })
    lib.showContext('ambulancemenu-members-boss')
end

-- Example of how to trigger the promotion event from client-side
function PromotePlayer(identifier, playerName)
    TriggerServerEvent("frp-ambulance:promotemember", identifier, playerName)
end

-- Example of how to trigger the demotion event from client-side
function DemotePlayer(identifier, playerName)
    TriggerServerEvent("frp-ambulance:demote", identifier, playerName)
end


function Deletemembersboss(x, y)
	TriggerServerEvent("frp-ambulance:deletemember:serversided", x, y)
end


function Neempersonenaan()

	local jobnamegang = ESX.PlayerData.job.name

    local input = lib.inputDialog('Ambulance Menu | Aannemen', {'Voer een speler id in'})
	if not input then 
		return 
	end

	local playerid = tonumber(input[1])

	if playerid then
		ESX.TriggerServerCallback('frp-ambulance:add:playertogang', function(done)
			if done then
			end
		end, playerid, jobnamegang)
	else
	end
end