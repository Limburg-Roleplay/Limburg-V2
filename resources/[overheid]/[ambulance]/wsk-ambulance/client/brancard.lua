exports.qtarget:AddTargetModel(GetHashKey('v_med_emptybed'), {
    options = {
        {
            icon = "fa-solid fa-truck-medical",
            label = "Verwijder brancard",
            event = 'wsk-ambulance:client:remove:brancard',
            job = 'ambulance'
        },
		{
            icon = "fa-solid fa-truck-medical",
            label = "Pak brancard vast",
            event = 'wsk-ambulance:pick:up:brancard',
            job = 'ambulance'
        },
		{
            icon = "fa-solid fa-bed-pulse",
            label = "Liggen op brancard",
            event = 'wsk-ambulance:client:lay:brancard',
        },
    },
    distance = 2.5
})

exports['qtarget']:Vehicle({
	options = {
		{
			icon = 'fas fa-people-group',
			label = 'Pak brancard uit voertuig',
			job = 'ambulance',
			action = function(vehicle)
				if not Entity(vehicle).state.brancard then
					LoadModel('v_med_emptybed')
					local wheelchair = CreateObject(GetHashKey('v_med_emptybed'), GetEntityCoords(PlayerPedId()), true)
					TriggerEvent('wsk-ambulance:pick:up:brancard', {['entity'] = wheelchair})
				else
					local brancard = Entity(vehicle).state.brancard
					TriggerEvent('wsk-ambulance:pick:up:brancard', {['entity'] = brancard})
					TriggerServerEvent('wsk-ambulance:server:set:vehicle:busy:brancard', NetworkGetNetworkIdFromEntity(vehicle), false, false)
				end
			end,
			canInteract = function(vehicle)
				if not IsAttached then
					local model = GetEntityModel(vehicle)

					if not Entity(vehicle).state.brancard then
						for i=1, #Config.WhitelistedBrancard do
							if model == Config.WhitelistedBrancard[i] then
								return true
							end
						end
					else
						return true
					end

					return false
				end
			end
		},
		{
			icon = 'fas fa-people-group',
			label = 'Zet brancard in voertuig',
			job = 'ambulance',
			action = function(vehicle)
				local pos = Config.WhitelistedBrancard['coords'][GetEntityModel(vehicle)]
				DetachEntity(IsAttached, false, true)
				AttachEntityToEntity(IsAttached, vehicle, 0, pos.x, pos.y, pos.z, 0.0, 0.0, 360.0, 0.0, false, false, false, false, 2, true)
				TriggerServerEvent('wsk-ambulance:server:set:vehicle:busy:brancard', NetworkGetNetworkIdFromEntity(vehicle), IsAttached, true)
				TriggerServerEvent('wsk-ambulance:server:no:busy:brancard:pickup', NetworkGetNetworkIdFromEntity(IsAttached))
				IsAttached = false
				Wait(200)
				ClearPedTasks(PlayerPedId())
				exports[''..Config.interaction..'']:clearInteraction()
			end,
			canInteract = function(vehicle)
				if IsAttached then
					local model = GetEntityModel(vehicle)

					for i=1, #Config.WhitelistedBrancard do
						if model == Config.WhitelistedBrancard[i] then
							return true
						end
					end

					return false
				end
			end
		}
	},
	distance = 2
})

RegisterNetEvent('wsk-ambulance:client:remove:brancard')
AddEventHandler('wsk-ambulance:client:remove:brancard', function(data)
    local entity = data.entity

    TriggerServerEvent('wsk-ambulance:server:remove:brancard', NetworkGetNetworkIdFromEntity(entity))
end)

RegisterNetEvent('wsk-ambulance:pick:up:brancard')
AddEventHandler('wsk-ambulance:pick:up:brancard', function(data)
	local entity = data.entity
	local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)

	ESX.TriggerServerCallback('wsk-ambulance:server:is:brancard:busy:pickup', function(bool)
		if not bool then
			NetworkRequestControlOfEntity(entity)
			LoadAnim("anim@heists@box_carry@")
			TaskPlayAnim(PlayerPed, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
			SetTimeout(150, function()
				AttachEntityToEntity(entity, PlayerPed, GetPedBoneIndex(PlayerPed, 28422), 0.0, -1.0, -1.0, 195.0, 180.0, 180.0, 90.0, false, false, true, false, 2, true)
			end)
			FreezeEntityPosition(Obj, false)

			IsAttached = entity

			Citizen.CreateThread(function()
				while IsAttached do
					Wait(0)
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped)

					if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
						LoadAnim("anim@heists@box_carry@")
						TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
					end

					exports[''..Config.interaction..'']:Interaction({r = 130, g = 23, b = 23}, '[E] - Laat brancard los', coords, 1.0, GetCurrentResourceName() .. '-brancard')

					if IsControlJustPressed(0, 38) then
						TriggerServerEvent('wsk-ambulance:server:no:busy:brancard:pickup', NetworkGetNetworkIdFromEntity(entity))
						IsAttached = false
						DetachEntity(entity, false, true)
   						Wait(200)
    					ClearPedTasks(PlayerPedId())
						exports[''..Config.interaction..'']:clearInteraction()
						break
					end
				end
			end)
		else
			ESX.ShowNotification('error', 'De brancard wordt al vastgehouden, probeer het opnieuw..')
		end
	end, NetworkGetNetworkIdFromEntity(entity))
end)

RegisterNetEvent('wsk-ambulance:client:lay:brancard')
AddEventHandler('wsk-ambulance:client:lay:brancard', function(data)
	local entity = data.entity
	local inBedDicts = "anim@gangops@morgue@table@"
    local inBedAnims = "ko_front"
    local PlayerPed = PlayerPedId()
    local PlayerPos = GetEntityCoords(PlayerPed)

	ESX.TriggerServerCallback('wsk-ambulance:server:is:brancard:busy', function(bool)
		if not bool then
			LoadAnim(inBedDicts)
			TaskPlayAnim(PlayerPed, inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
			AttachEntityToEntity(PlayerPed, entity, 0, 0, 0.0, 1.6, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
			IsLayingOnBed = true

			while IsLayingOnBed do
				local sleep = 0
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)

				if not IsEntityPlayingAnim(ped, inBedDicts, inBedAnims, 69) then
					LoadAnim(inBedDicts)
					TaskPlayAnim(PlayerPed, inBedDicts, inBedAnims, 8.0, 8.0, -1, 69, 1, false, false, false)
				end

				AttachEntityToEntity(PlayerPed, entity, 0, 0, 0.0, 1.6, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

				exports[''..Config.interaction..'']:Interaction({r = 130, g = 23, b = 23}, '[E] - Sta op', coords, 1.0, GetCurrentResourceName() .. '-brancard')

				if IsControlJustPressed(0, 38) then
					TriggerServerEvent('wsk-ambulance:server:no:busy:brancard', NetworkGetNetworkIdFromEntity(entity))
					ClearPedTasks(PlayerPedId())
					IsLayingOnBed = false
					exports[''..Config.interaction..'']:clearInteraction()
					break
				end

				Wait(sleep)
			end
		else
			ESX.ShowNotification('error', 'Er ligt al iemand op de brancard, probeer het opnieuw..')
		end
	end, NetworkGetNetworkIdFromEntity(entity))
end)

LoadAnim = function(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(1)
    end
end

LoadModel = function(model)
 	while not HasModelLoaded(model) do
 		RequestModel(model)
		
 		Citizen.Wait(1)
 	end
end