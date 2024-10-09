local LastMedCheck = {}
local isBusy = false

exports.qtarget:Player({
	options = {
		{
			event = "wsk-ambulance:client:ped-inter:cpr",
			icon = "fa-solid fa-heart-pulse",
			label = "CPR Toedienen",
			canInteract = function(entity)
				local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

				return IsPlayerDead(entityPlayer)
			end,
		},
		{
			event = 'wsk-cuff:client:dragging:ambulance',
			icon = 'fas fa-people-group',
			label = 'Persoon Dragen',
			job = 'ambulance',
			canInteract = function(entity)
				local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

				return IsPlayerDead(entityPlayer)
			end,
		},
	},
	distance = 2
})

ESX = exports["es_extended"]:getSharedObject()

-- F6 Menu + actions begin

isAllowed = false

local mainElements = {
  {label = "ID kaart bekijken", value = "idkaart"},
  {label = "Pleister toedienen", value = "verzorgen"},
  {label = "Omhoog Helpen", value = "omhooghelpen"}
}

local keybind = lib.addKeybind({
  name = 'ambulancef6',
  description = 'F6-menu Ambulance',
  defaultKey = 'F6',
  onReleased = function(self)
      if IsActionAllowed() then
        OpenInteractionMenu()
      end
  end,
})

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    if ESX.PlayerData.job.name == 'ambulance' then
        keybind:disable(false)
    else
        keybind:disable(true)
    end
end)

function IsActionAllowed()
    if ESX.PlayerData.job.name == 'ambulance' then
        return true
    else
        keybind:disable(true)
        return false
    end
end

function OpenInteractionMenu()
  if IsActionAllowed() then
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "gang_main", {
      title = ESX.PlayerData.job.label,
      align = 'top-right',
      elements = mainElements
    }, function(data, menu)
      local playerPed = PlayerPedId()
      local target, distance = ESX.Game.GetClosestPlayer()

      if target ~= -1 and distance <= 3.0 then
        local targetPed = GetPlayerPed(target)

        if DoesEntityExist(targetPed) then
          if data.current.value == "verzorgen" then
            TriggerEvent('wsk-ambulance:client:ped-inter:verzorgen', { entity = targetPed })
          elseif data.current.value == "omhooghelpen" then
            TriggerEvent('wsk-ambulance:client:ped-inter:revive', { entity = targetPed })
          elseif data.current.value == "idkaart" then
            TriggerEvent('jtm-development:openIdkaartMenu', GetPlayerServerId(target))
          end
        else
          ESX.ShowNotification('Geen speler dichtbij!', 'error', 5000)
        end
      else
        ESX.ShowNotification('Geen speler dichtbij!', 'error', 5000)
      end
    end, function(data, menu)
      menu.close()
    end)
  else
    ESX.ShowNotification('Action not allowed!', 'error', 5000)
  end
end



RegisterNetEvent('wsk-ambulance:client:ped-inter:verzorgen', function(data)
    local entity = data.entity
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
    local entityPlayer = ESX.Game.GetPlayerFromPed(entity)
    local xTarget = GetPlayerServerId(entityPlayer)

    if distance < 2.0 then
        if IsPedDeadOrDying(entityPlayer, 1) then
            isBusy = true
            local playerPed = PlayerPedId()
            local lib, anim = 'amb@medic@standing@timeofdeath@base', 'base'

            exports["frp-progressbar"]:Progress({
                name = "Fouilleren",
                duration = Config.Pleistertimer * 1000,
                label = "Pleister aan het toedienen",
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true
                }
            })

            Citizen.CreateThread(function()
                for i = 1, (Config.Pleistertimer * 2) do
                    Wait(500)
                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
                    end)
                end
            end)

            Citizen.Wait(Config.Pleistertimer * 1000)

            ESX.TriggerServerCallback('wsk-ambulance:server:check:zorgverzekering', function(bool)
                if bool then
                    exports['frp-notifications']:notify('success',
                        'Je hebt de inwoner een pleister gegeven!<br>Deze kosten vallen onder de zorgverzekering van de inwoner.',
                        5000)
                    TriggerServerEvent('wsk-ambulance:server:heal:player', GetPlayerServerId(entityPlayer))
                else
                    exports['frp-notifications']:notify('success',
                        'Je hebt de inwoner een pleister gegeven!<br>Factuur verzonden, de inwoner heeft geen zorgverzekering.',
                        5000)
                    TriggerServerEvent('esx_billing:sendBill', xTarget, 'society_amblance', 'Pleister', 1000)
                    TriggerServerEvent('wsk-ambulance:server:heal:player', GetPlayerServerId(entityPlayer))
                end
            end, xTarget)
            
            isBusy = false
        else
            exports['frp-notifications']:notify('error', 'Deze inwoner heeft geen pleisster nodig!', 5000)
        end
    else
        exports['frp-notifications']:notify('error', 'Er is niemand in de buurt!', 5000)
    end
end)

RegisterNetEvent('wsk-ambulance:client:ped-inter:cpr', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
	local entityPlayer = ESX.Game.GetPlayerFromPed(entity)
	local xTarget = GetPlayerServerId(entityPlayer)

	if distance < 2.0 then
		if IsPedDeadOrDying(entityPlayer, 1) then
			if isBusy == false then
				isBusy = true
				local playerPed = PlayerPedId()
				local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
				for i = 1, 15 do
					Wait(900)
					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
					end)
					if i == 15 then
						TriggerServerEvent('wsk-ambulance:donecpr', xTarget)
					end
				end
			else
				exports['wsk-notifications']:notify('error', 'Je bent al met iets bezig!', 5000)
			end
		else
			exports['wsk-notifications']:notify('error', 'Deze inwoner heeft geen hulp nodig!', 5000)
		end
		isBusy = false
	else
		exports['wsk-notifications']:notify('error', 'Er is niemand in de buurt!', 5000)
	end
end)

RegisterNetEvent('wsk-ambulance:client:ped-inter:revive', function(data)
	local entity = data.entity
	local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
	local entityPlayer = ESX.Game.GetPlayerFromPed(entity)
	local xTarget = GetPlayerServerId(entityPlayer)

	if distance < 2.0 then
        if DoesEntityExist(entity) then
            local playerPed = PlayerPedId()
            local health = GetEntityHealth(entity)

            if health == 0 then
                isBusy = true
                local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
                for i = 1, 15 do
                    Wait(900)
                    ESX.Streaming.RequestAnimDict(lib, function()
                        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
                    end)
                end

                TriggerServerEvent('wsk-ambulance:server:revive:player', GetPlayerServerId(entityPlayer))
                exports['frp-notifications']:notify('success', 'Je hebt de inwoner omhoog geholpen.', 5000)

                isBusy = false
            else
                exports['frp-notifications']:notify('error', 'Deze inwoner heeft geen hulp nodig!', 5000)
            end
        else
            exports['frp-notifications']:notify('error', 'Er is niemand in de buurt!', 5000)
        end
	end
end)

--------------- Med Systeem ------------------------------
local health
local multi
local pulse = 70
local area = "Unknown"
local lastHit
local blood = 100
local bleeding = 0
local dead = false
local timer = 0
local showingUI = false

local cPulse = -1
local cBlood = -1
local cid = ""
local cArea = ""
local cBleeding = "NONE"
local combatlog = false


AddEventHandler('esx:onPlayerDeath', function(data)
	multi = 2.0
	blood = 100
	area = "Benen/Armen"
	local health = GetEntityHealth(PlayerPedId())
	local hit, bone = GetPedLastDamageBone(PlayerPedId())
	bleeding = 1
	if (bone == 31086) then
		multi = 0.0
		if HasPedBeenDamagedByWeapon(PlayerPedId(), 0, 2) then
			TriggerEvent('chatMessage', 'MEDSYSTEM', 'medsystem', 'Je bent geraakt in jouw hoofd door een wapen..')
		end
		bleeding = 5
		area = "Hoofd"
	end
	if bone == 24817 or bone == 24818 or bone == 10706 or bone == 24816 or bone == 11816 then
		multi = 1.0
		if HasPedBeenDamagedByWeapon(PlayerPedId(), 0, 2) then
			TriggerEvent('chatMessage', 'MEDSYSTEM', 'medsystem', 'Je bent geraakt in jouw lichaam door een wapen..')
		end
		bleeding = 2
		area = "Lichaam"
	end

	pulse = ((health / 4 + 20) * multi) + math.random(0, 4)
	dead = true
end)

RegisterNetEvent('medSystem:donecpr')
AddEventHandler('medSystem:donecpr', function()
	if pulse > 11 and blood > 0 then
		pulse = pulse + 1
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(6000)
		local hp = GetEntityHealth(PlayerPedId())
		if hp >= 1 and dead then
			dead = false
			bleeding = 0
			blood = 100
		end

		if dead and blood > 0 then
			blood = blood - bleeding
		end
	end
end)

RegisterNetEvent('medSystem:near')
AddEventHandler('medSystem:near', function(x, y, z, pulse, blood, id, area, bldn, Weapon)
	local md = Config.Declared
	LastMedCheck = { id = id, pulse = pulse, blood = blood }

	if area == "HEAD" then
		cBlood = 0
		cPulse = 0
		cid = id
		cArea = area
	end

	local a, b, c = GetEntityCoords(PlayerPedId())

	if GetDistanceBetweenCoords(x, y, z, a, b, c, false) < 10 then
		timer = Config.Timer
		cBlood = blood
		cPulse = pulse
		cid = id
		cArea = area

		if bldn == 1 then
			cBleeding = "Traag"
		elseif bldn == 2 then
			cBleeding = "Gemiddeld"
		elseif bldn == 5 then
			cBleeding = "Snel"
		elseif bldn == 0 then
			cBleeding = "Geen"
		end
		showingUI = true
		SendNUIMessage({
			type = 'showMed',
			playerid = cid,
			heartbeat = cPulse,
			bleed = cBlood,
			area = cArea,
			bleeding = cBleeding,
			weapon = Weapon
		})
	else
		timer = 0
		cBlood = -1
		cPulse = -1
		cid = ""
		cArea = ""
		cBleeding = "SLOW"
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if timer >= 1 then
			timer = timer - 1
		elseif showingUI then
			SendNUIMessage({
				type = 'closeMed',
			})
			showingUI = false
		end
	end
end)

exports('combatlog', function()
	combatlog = true
end)

exports('respawncombatlog', function()
	combatlog = false
end)

RegisterNetEvent('medSystem:send')
AddEventHandler('medSystem:send', function(req)
	local health = GetEntityHealth(PlayerPedId())
	if combatlog then
		local a, b, c = table.unpack(GetEntityCoords(PlayerPedId()))
		pulse = 0
		blood = 0
		bleeding = 0
		TriggerServerEvent('medSystem:print', req, math.floor(pulse * (blood / 90)), area, blood, a, b, c, bleeding, true)
		return
	end

	if health > 0 then
		pulse = (health / 4 + math.random(19, 28))
	end
	local a, b, c = table.unpack(GetEntityCoords(PlayerPedId()))

	TriggerServerEvent('medSystem:print', req, math.floor(pulse * (blood / 90)), area, blood, a, b, c, bleeding, false)
end)