local inProgress, hostageType, targetSource = false, '', -1
local FRP = {}

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

Citizen.CreateThread(function()
	exports.qtarget:Player({
		options = {
			{
				event = 'frp-takehostage:client:send:hostage:rqst',
				icon = 'fas fa-gun',
				label = 'Persoon gijzelen',
				canInteract = function(entity)
					local ped = PlayerPedId()

					if IsPedArmed(ped, 4) or IsPedArmed(ped, 1) then	
						return true
					else
						return false
					end
				end,
			}
		},
		distance = 2
	})
end)

RegisterNetEvent('frp-takehostage:client:send:hostage:rqst')
AddEventHandler('frp-takehostage:client:send:hostage:rqst', function(data)
    local entity = data.entity
    local distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
    local entityPlayer = ESX.Game.GetPlayerFromPed(entity)

    if distance <= 2.0 then 
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)

        local canTakeHostage = false
        local weapon = Config.AllowedWeapons[GetSelectedPedWeapon(PlayerPedId())]
        local serverId = GetPlayerServerId(entityPlayer)

        if weapon then
            local count = exports.ox_inventory:Search('count', weapon)
            if count > 0 then 
                canTakeHostage = true
            end

            if canTakeHostage then 
				lib.showTextUI('[G] - Loslaten | [H] - Vermoorden', {
					icon = 'fa-solid fa-gun'
				})
                -- exports["frp-notifications"]:Notify("info", "Klik G om los te laten / H om de persoon af te maken!", 4000)
            end

            if not inProgress and canTakeHostage then 
                if entity then 
                    if entityPlayer ~= -1 and serverId ~= -1 and serverId ~= 0 then 
                        inProgress = true 
                        targetSource = serverId
                        TriggerServerEvent('frp-takehostage:server:sync', serverId)
                        LoadAnimDict(Config.Animations['Agressor']['animDict'])
                        hostageType = 'agressor'
						lib.notify({
							title = 'Criminele acties',
							description = 'Persoon succesvol hostage genomen',
							type = 'success'
						})
                        FRP.takeHostage()
                    end
                end
            end
        end
    else
        lib.notify({
			title = 'Criminele acties',
			description = 'Deze persoon is niet bij jou in de buurt!',
			type = 'error'
		})
    end
end)



RegisterNetEvent('frp-takehostage:client:sync:target')
AddEventHandler('frp-takehostage:client:sync:target', function(tgt)
	tgtPed = GetPlayerPed(GetPlayerFromServerId(tgt))
	inProgress = true
	LoadAnimDict(Config.Animations['Hostage']['animDict'])
	AttachEntityToEntity(PlayerPedId(), tgtPed, 0, Config.Animations['Hostage']['attachX'], Config.Animations['Hostage']['attachY'], Config.Animations['Hostage']['attachZ'], 0.5, 0.5, 0.0, false, false, false, false, 2, false)
	hostageType = 'hostage'
	FRP.takeHostage()
end)

RegisterNetEvent('frp-takehostage:client:release:hostage')
AddEventHandler('frp-takehostage:client:release:hostage', function()
	inProgress = false 
	hostageType = nil
	Wait(5)
	DetachEntity(PlayerPedId(), true, false)
	LoadAnimDict('reaction@shove')
	TaskPlayAnim(PlayerPedId(), 'reaction@shove', 'shoved_back', 8.0, -8.0, -1, 0, 0, false, false, false)
	Wait(1000)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('frp-takehostage:client:kill:hostage')
AddEventHandler('frp-takehostage:client:kill:hostage', function()
	inProgress = false 
	hostageType = nil
	lib.hideTextUI()

	Wait(5)
	SetEntityHealth(PlayerPedId(), 0)
	DetachEntity(PlayerPedId(), true, false)
	LoadAnimDict('anim@gangops@hostage@')
	TaskPlayAnim(PlayerPedId(), 'anim@gangops@hostage@', 'victim_fail', 8.0, -8.0, -1, 168, 0, false, false, false)
	Wait(500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('frp-takehostage:client:stop')
AddEventHandler('frp-takehostage:client:stop', function()
	inProgress = false 
	hostageType = nil
	DetachEntity(PlayerPedId(), true, false)
	LoadAnimDict("reaction@shove")
	TaskPlayAnim(PlayerPedId(), "reaction@shove", "shoved_back", 8.0, -8.0, -1, 0, 0, false, false, false)
	Wait(250)
	ClearPedTasks(PlayerPedId())
end)

FRP.takeHostage = function()
	while hostageType == 'agressor' do 
		Citizen.Wait(0)

		if not IsEntityPlayingAnim(PlayerPedId(), Config.Animations['Agressor']['animDict'], Config.Animations['Agressor']['anim'], 3) then
			TaskPlayAnim(PlayerPedId(), Config.Animations['Agressor']['animDict'], Config.Animations['Agressor']['anim'], 8.0, -8.0, 100000, Config.Animations['Agressor']['flag'], 0, false, false, false)
		end
		DisableControlAction(0,24,true) -- disable attack
		DisableControlAction(0,25,true) -- disable aim
		DisableControlAction(0,47,true) -- disable weapon
		DisableControlAction(0,58,true) -- disable weapon
		DisableControlAction(0,21,true) -- disable sprint
		DisablePlayerFiring(PlayerPedId(),true)

		if IsEntityDead(PlayerPedId()) then	
			hostageType = ''
			inProgress = false
			lib.hideTextUI()
			LoadAnimDict('reaction@shove')
			TaskPlayAnim(PlayerPedId(), 'reaction@shove', 'shove_var_a', 8.0, -8.0, -1, 168, 0, false, false, false)
			TriggerServerEvent('frp-takehostage:server:release:hostage', targetSource)
		end 

		if IsDisabledControlJustPressed(0,47) then --release	
			hostageType = ''
			inProgress = false 
			lib.hideTextUI()
			LoadAnimDict('reaction@shove')
			TaskPlayAnim(PlayerPedId(), 'reaction@shove', 'shove_var_a', 8.0, -8.0, -1, 168, 0, false, false, false)
			TriggerServerEvent('frp-takehostage:server:release:hostage', targetSource)
		elseif IsDisabledControlJustPressed(0,74) then --kill 			
			hostageType = ''
			inProgress = false 		
			lib.hideTextUI()
			LoadAnimDict('anim@gangops@hostage@')
			TaskPlayAnim(PlayerPedId(), 'anim@gangops@hostage@', 'perp_fail', 8.0, -8.0, -1, 168, 0, false, false, false)
			TriggerServerEvent('frp-takehostage:server:kill:hostage', targetSource)
		end
	end

	while hostageType == 'hostage' do 
		Citizen.Wait(0)

		if GetEntityAttachedTo(PlayerPedId()) == 0 then
			AttachEntityToEntity(PlayerPedId(), tgtPed, 0, Config.Animations['Hostage']['attachX'], Config.Animations['Hostage']['attachY'], Config.Animations['Hostage']['attachZ'], 0.5, 0.5, 0.0, false, false, false, false, 2, false)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), Config.Animations['Hostage']['animDict'], Config.Animations['Hostage']['anim'], 3) then
			TaskPlayAnim(PlayerPedId(), Config.Animations['Hostage']['animDict'], Config.Animations['Hostage']['anim'], 8.0, -8.0, 100000, Config.Animations['Hostage']['flag'], 0, false, false, false)
		end

		DisableControlAction(0,21,true) -- disable sprint
		DisableControlAction(0,24,true) -- disable attack
		DisableControlAction(0,25,true) -- disable aim
		DisableControlAction(0,47,true) -- disable weapon
		DisableControlAction(0,58,true) -- disable weapon
		DisableControlAction(0,263,true) -- disable melee
		DisableControlAction(0,264,true) -- disable melee
		DisableControlAction(0,257,true) -- disable melee
		DisableControlAction(0,140,true) -- disable melee
		DisableControlAction(0,141,true) -- disable melee
		DisableControlAction(0,142,true) -- disable melee
		DisableControlAction(0,143,true) -- disable melee
		DisableControlAction(0,75,true) -- disable exit vehicle
		DisableControlAction(27,75,true) -- disable exit vehicle  
		DisableControlAction(0,22,true) -- disable jump
		DisableControlAction(0,32,true) -- disable move up
		DisableControlAction(0,268,true)
		DisableControlAction(0,33,true) -- disable move down
		DisableControlAction(0,269,true)
		DisableControlAction(0,34,true) -- disable move left
		DisableControlAction(0,270,true)
		DisableControlAction(0,35,true) -- disable move right
		DisableControlAction(0,271,true)
	end
end

LoadAnimDict = function(animDict)
	RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
end