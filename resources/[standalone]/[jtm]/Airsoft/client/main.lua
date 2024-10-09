ESX = exports['es_extended']:getSharedObject()

Threads = {
	marker = false
}

Aces = nil
Maintenance = true

LobbyCreator = json.decode(json.encode(Config.LobbyTemplate))
GameData = {
	ViewingLobby = nil,
	CurrentLobby = nil,
	lastGamemode = nil,
	starting = false,
	dropped = false,
	active = false,
	ending = false,
	inMap = true,
	dead = false,
	died = false,
	cage = nil,
	blips = {},
}

Citizen.CreateThread(function()
	TriggerServerEvent('ff_airsoft:login')
	while Config.Maps == nil do
		Citizen.Wait(1)
	end

	while true do
		if #(Config.LobbyMarker.Coords - GetEntityCoords(PlayerPedId(), 0)) <= 15 then
			if not NearMarker then
				NearMarker = true
				ThreadLobbyMarker(true)
			end
		else
			if NearMarker then
				NearMarker = false
				ThreadLobbyMarker(false)

				if GameData.CurrentLobby ~= nil and not GameData.starting then
					TriggerEvent('ff_airsoft:notification', Translations[Translations.language].KickedFromLobby)
					TriggerServerEvent('ff_airsoft:lobby:leave')
					TriggerEvent('ff_airsoft:lobby:update', nil)
					ESX.UI.Menu.CloseAll()
				end
			end
		end
		
		Wait(1500)
	end
end)

NearMarker = false
function ThreadLobbyMarker(bool)
	Threads.marker = bool
		
	Citizen.CreateThread(function()
		while Threads.marker do
			::continue::
			if GameData.starting or Maintenance then
				Citizen.Wait(0)
				goto continue
			end

			DrawMarker(
				Config.LobbyMarker.Type, Config.LobbyMarker.Coords.x, Config.LobbyMarker.Coords.y, Config.LobbyMarker.Coords.z,
				0.0, 0.0, 0.0, Config.LobbyMarker.Rotation.x, Config.LobbyMarker.Rotation.y, Config.LobbyMarker.Rotation.z,
				Config.LobbyMarker.Scale.x, Config.LobbyMarker.Scale.y, Config.LobbyMarker.Scale.z,
				Config.LobbyMarker.Color.r, Config.LobbyMarker.Color.g, Config.LobbyMarker.Color.b, Config.LobbyMarker.Color.a,
				false, false, 2, nil, nil, false
			)
			
			if #(Config.LobbyMarker.Coords - GetEntityCoords(PlayerPedId(), 0)) < (Config.LobbyMarker.Scale.x - 2) then
				if GameData.CurrentLobby ~= nil then
					if not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'lobby-menu') and IsPedOnFoot(PlayerPedId()) then
						GameData.ViewingLobby = GameData.CurrentLobby
						OpenLobbyMenu()
					end
				else
					if not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'lobbies-menu') and IsPedOnFoot(PlayerPedId()) then
						local elements = {
							{ label = Translations[Translations.language].Title, value = '' },
							{ label = '', value = '' },
							{ label = Translations[Translations.language].Lobbies, value = 'view_lobbies' },
							{ label = Translations[Translations.language].CreateLobby, value = 'create_lobby' }
						}

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobbies-menu', {
							title = Translations[Translations.language].Lobbies,
							align = 'top-right',
							elements = elements
						}, function(data, menu)
							if data.current.value == 'view_lobbies' then
								ViewLobbies()
							elseif data.current.value == 'create_lobby' then
								OpenGamemodeSelector()
							end
						end)
					end
				end
			else
				if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'lobbies-menu') or ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'lobby-menu') then
					ESX.UI.Menu.CloseAll()
				end
			end
			
			Citizen.Wait(1)
		end
	end)
end

function ViewLobbies()
	TriggerCallback('ff_airsoft:lobbies:get', function(data)
		lobbies = {}
		for _, lobby in pairs(data) do
			table.insert(lobbies, { label = lobby.name .. ' - ' .. lobby.playerNames[lobby.owner], lobby = lobby, password = lobby.password })
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobbies', {
			title = Translations[Translations.language].Lobbies,
			align = 'top-right',
			elements = lobbies
		}, function(data, menu)
			GameData.ViewingLobby = data.current.lobby
			OpenLobbyMenu()
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenLobbyMenu()
	local elements = LobbyViewTemplate(GameData.ViewingLobby)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobby-menu', {
		title = Translations[Translations.language].Lobbies,
		align = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			if data.current.value == 'join' then
				if #GameData.ViewingLobby.password > 0 then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lobby-creator-password', {
						title = Translations[Translations.language].LobbyPassword 
					}, function(dialog, dialogmenu)
						if GetHashKey(dialog.value) == GetHashKey(GameData.ViewingLobby.password) then
							if GameData.ViewingLobby.stake then
								StakeConfirm()
							else
								JoinLobby(GameData.ViewingLobby.key)
								ESX.UI.Menu.CloseAll()
							end
							dialogmenu.close()
						else
							dialogmenu.close()
						end
					end, function(dialog, dialogmenu)
						dialogmenu.close()
					end)
				else
					if GameData.ViewingLobby.stake then
						StakeConfirm()
					else
						JoinLobby(GameData.ViewingLobby.key)
						ESX.UI.Menu.CloseAll()
					end
				end
			elseif data.current.value == 'leave' then
				TriggerServerEvent('ff_airsoft:lobby:leave')
				TriggerEvent('ff_airsoft:lobby:update', nil)
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'quickstart' then
				GameData.starting = true
				TriggerServerEvent('ff_airsoft:lobby:quickstart')
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'loadouts' then
				ViewLobbyLoadouts()
			elseif data.current.value == 'team' then
				OpenLobbyTeamMenu()
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function JoinLobby(key)
	TriggerCallback('ff_airsoft:lobbies:get', function(data)
		for key2, _ in pairs(data) do
			if key == key2 then
				TriggerServerEvent('ff_airsoft:lobby:join', GameData.ViewingLobby.key)
				do return end
			end
		end
		TriggerEvent('ff_airsoft:notification', Translations[Translations.language].LobbyDeleted)
	end)

end

function StakeConfirm()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobby-menu_confirm', {
		title = Translations[Translations.language].AreYouSure,
		align = 'top-right',
		elements = {
			{ label = string.format(Translations[Translations.language].StakeWarning, GameData.ViewingLobby.stake) },
			{ label = Translations[Translations.language].LobbyJoin, value = 'join' },
			{ label = Translations[Translations.language].Cancel },
		}
	}, function(data, menu)
		if data.current.value then
			if data.current.value == 'join' then
				JoinLobby(GameData.ViewingLobby.key)
				menu.close()
			end
		else
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ViewLobbyLoadouts()
	local elements = {}
	for _, k in pairs(GameData.ViewingLobby.loadouts) do
		table.insert(elements, { label = Config.Loadouts[k].Label })
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobby-menu_loadouts', {
		title = Translations[Translations.language].Lobbies,
		align = 'top-right',
		elements = elements
	}, function(data, menu)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenLobbyTeamMenu()
	local elements = {
		{ label = 'Team #1', value = 1 }
	}

	for _, id in pairs(GameData.ViewingLobby.teams[1]) do
		table.insert(elements, { label = GameData.ViewingLobby.playerNames[id] })
	end
	table.insert(elements, { label = 'Team #2', value = 2 })
	for _, id in pairs(GameData.ViewingLobby.teams[2]) do
		table.insert(elements, { label = GameData.ViewingLobby.playerNames[id] })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobby-menu_teams', {
		title = Translations[Translations.language].Lobbies,
		align = 'top-right',
		elements = elements
	}, function(data, menu)
		local playerId = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))

		if data.current.value then
			if table.contains(GameData.ViewingLobby.players, playerId) then
				TriggerServerEvent('ff_airsoft:lobby:team', data.current.value)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGamemodeSelector()
	local elements = {}

	for _, mode in ipairs(Config.GameModes) do
		if (not mode.Ace) or (mode.Ace and Aces[mode.Ace]) then
			table.insert(elements, { label = mode.Label, value = _ })
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gamemode-selector', {
		title = Translations[Translations.language].Lobbies,
		align = 'top-right',
		elements = elements
	}, function(data, menu)
		if GameData.lastGamemode == nil or GameData.lastGamemode ~= data.current.value then
			LobbyCreator = json.decode(json.encode(Config.LobbyTemplate))
		end
		GameData.lastGamemode = data.current.value

		LobbyCreator['gamemode'] = data.current.value

		if Config.GameModes[data.current.value].DisableSettings then
			for _, setting in pairs(Config.GameModes[data.current.value].DisableSettings) do
				LobbyCreator[setting] = nil
			end
		end

		menu.close()
		OpenLobbyCreator()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenLobbyCreator()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobby-creator', {
		title = Translations[Translations.language].Lobbies,
		align = 'top-right',
		elements = LobbyCreateTemplate()
	}, function(data, menu)
		if data.current.key ~= '' then
			LobbyCreator.current = data.current.key
			
			if data.current.type == 'text' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lobby-creator-input', {
					title = data.current.dialogLabel
				}, function(dialog, dialogmenu)
					LobbyCreator[LobbyCreator.current] = dialog.value and tostring(dialog.value) or ''
					LobbyCreator.current = nil
					dialogmenu.close()
					OpenLobbyCreator()
				end, function(dialog, dialogmenu)
					dialogmenu.close()
					OpenLobbyCreator()
				end)
			elseif data.current.type == 'list' then
				local listElements = {}
				
				for k, v in ipairs(data.current.listItems) do
					if data.current.listKeys then 
						if table.contains(data.current.listKeys, k) then
							table.insert(listElements, { label = v[data.current.listLabel], value = data.current.listValue and v[data.current.listValue] or k, resetValues = data.current.resetValues })
						end
					else
						table.insert(listElements, { label = v[data.current.listLabel], value = data.current.listValue and v[data.current.listValue] or k, resetValues = data.current.resetValues })
					end
				end
				
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobby-creator-map_selector', {
					title = Translations[Translations.language].Lobbies,
					align = 'top-right',
					elements = listElements
				}, function(data, menu)
					LobbyCreator[LobbyCreator.current] = data.current.value

					if data.current.resetValues then
						for _, reset in pairs(data.current.resetValues) do
							if not table.indexByValue(Config.GameModes[LobbyCreator.gamemode].DisableSettings, reset) then
								LobbyCreator[reset] = json.decode(json.encode(Config.LobbyTemplate[reset]))
							end
						end
					end

					menu.close()
					OpenLobbyCreator()
				end, function(data, menu)
					menu.close()
					OpenLobbyCreator()
				end)
			elseif data.current.type == 'number' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lobby-creator-input', {
					title = data.current.dialogLabel or ''
				}, function(dialog, dialogmenu)
					local amount = tonumber(dialog.value)
	
					LobbyCreator[LobbyCreator.current] = amount
					LobbyCreator.current = nil
					dialogmenu.close()
					OpenLobbyCreator()
				end, function(dialog, dialogmenu)
					dialogmenu.close()
					OpenLobbyCreator()
				end)
			elseif data.current.type == 'loadoutList' then
				local listElements = {}
				
				for k, v in ipairs(data.current.listItems) do
					if data.current.listKeys then 
						if table.contains(data.current.listKeys, k) then
							table.insert(listElements, { label = v[data.current.listLabel] .. ' ' .. (table.contains(LobbyCreator[LobbyCreator.current], data.current.listValue and v[data.current.listValue] or k) and '✓' or ''), value = data.current.listValue and v[data.current.listValue] or k })
						end
					else
						table.insert(listElements, { label = v[data.current.listLabel] .. ' ' .. (table.contains(LobbyCreator[LobbyCreator.current], data.current.listValue and v[data.current.listValue] or k) and '✓' or ''), value = data.current.listValue and v[data.current.listValue] or k })
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lobby-creator-map_selector', {
					title = Translations[Translations.language].Lobbies,
					align = 'top-right',
					elements = listElements
				}, function(data, menu2)
					if table.contains(LobbyCreator[LobbyCreator.current], data.current.value) then
						table.remove(LobbyCreator[LobbyCreator.current], table.indexByValue(LobbyCreator[LobbyCreator.current], data.current.value))
					else
						table.insert(LobbyCreator[LobbyCreator.current], data.current.value)
					end
					
					local newLabel = Config.Loadouts[data.current.value].Label .. (table.indexByValue(LobbyCreator[LobbyCreator.current], data.current.value) ~= nil and ' ✓' or '')
					menu2.update({ value = data.current.value }, { label = newLabel })
					menu2.refresh()
				end, function(data, menu)
					menu.close()
					OpenLobbyCreator()
				end)
			elseif data.current.type == 'yesno' then
				LobbyCreator[LobbyCreator.current] = not LobbyCreator[LobbyCreator.current]
				
				menu.close()
				OpenLobbyCreator()
			elseif data.current.type == 'confirm' then
				if (not LobbyCreator['loadouts']) or (LobbyCreator['loadouts'] and #LobbyCreator['loadouts'] > 0) then
					TriggerServerEvent('ff_airsoft:lobby:create', LobbyCreator)
				else
					ShowHelpNotification(Translations[Translations.language].NoLoadout, false, true, 5000)
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('ff_airsoft:lobby:joined', function(lobby)
	GameData.CurrentLobby = lobby
	GameData.ViewingLobby = lobby
	ESX.UI.Menu.CloseAll()
	OpenLobbyMenu()
end)

RegisterNetEvent('ff_airsoft:lobby:update', function(lobby)
	GameData.CurrentLobby = lobby
	if (not lobby) or (lobby and GameData.ViewingLobby.key == lobby.key) then
		GameData.ViewingLobby = lobby
	end

	for _, menu in pairs(ESX.UI.Menu.GetOpenedMenus()) do
		if menu.namespace == GetCurrentResourceName() then
			UpdateMenu(menu, lobby)
		end
	end
end)

RegisterNetEvent('ff_airsoft:notification', function(message, ...)
	ShowFreemodeMessage(string.format(message, ...), ' ', 5)
end)

RegisterNetEvent('ff_airsoft:lobby:start', function()
	LobbyThread()
	TriggerEvent('karneschoten:idle', true)
end)

RegisterNetEvent('ff_airsoft:lobby:ending', function()
	FreezeEntityPosition(PlayerPedId(), true)
	GameData.ending = true
	if GameData.CurrentLobby.teams then
		local teamKills = { [1] = 0, [2] = 0 }
		for player, kills in sortpairs(GameData.CurrentLobby.kills, function(t, a, b) return t[b] < t[a] end) do
			if table.contains(GameData.CurrentLobby.teams[1], player) then
				teamKills[1] = teamKills[1] + kills
			else
				teamKills[2] = teamKills[2] + kills
			end
		end

		local winningTeam = teamKills[1] > teamKills[2] and 1 or 2
		ShowFreemodeMessage(Translations[Translations.language].LobbyEnded, string.format(Translations[Translations.language].LobbyEnded2Teams, winningTeam, teamKills[winningTeam]), 5)
	else
		if Config.GameModes[GameData.CurrentLobby.gamemode].key == 'battle' then
			for player, kills in sortpairs(GameData.CurrentLobby.kills, function(t, a, b) return t[b] < t[a] end) do
				ShowFreemodeMessage(Translations[Translations.language].LobbyEnded, string.format(Translations[Translations.language].LobbyEnded2Royale, GameData.CurrentLobby.playerNames[GameData.CurrentLobby.players[1]], kills), 5)
				break
			end
		else
			for player, kills in sortpairs(GameData.CurrentLobby.kills, function(t, a, b) return t[b] < t[a] end) do
				ShowFreemodeMessage(Translations[Translations.language].LobbyEnded, string.format(Translations[Translations.language].LobbyEnded2, GameData.CurrentLobby.playerNames[player], kills), 5)
				break
			end
		end
	end
end)

RegisterNetEvent('ff_airsoft:pickup:ammo', function(type, amount)
	AddAmmoToPedByType(PlayerPedId(), GetHashKey(type), amount and amount or math.random(10, 15))
end)

RegisterNetEvent('ff_airsoft:pickup:health', function(health)
	SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + health)
end)

RegisterNetEvent('ff_airsoft:pickup:armor', function(armour)
	local total
	if GetPedArmour(PlayerPedId()) + armour > 97 then
		total = 97
	else
		total = GetPedArmour(PlayerPedId()) + armour
	end

	SetPedArmour(PlayerPedId(), total)
end)

RegisterNetEvent('ff_airsoft:lobby:ended', function()
	GameData.active = false
	GameData.starting = false
	GameData.died = false
	GameData.dropped = false
	if GameData.cage then
		GameData.cage:destroy()
	end
	if GameData.CurrentLobby.teams then
		NetworkSetFriendlyFireOption(true)
	end
	if GameData.zone and GameData.zone.blip then
		RemoveBlip(GameData.zone.blip)
	end
	GameData.CurrentLobby = nil
	ESX.UI.Menu.CloseAll()
	SetWeaponsNoAutoreload(true)
	exports.ox_inventory:weaponWheel(false)
	LocalPlayer.state.blockEmotes = false

	for _, blip in pairs(GameData.blips) do
		RemoveBlip(blip)
	end
	GameData.blips = {}

	FreezeEntityPosition(PlayerPedId(), false)
	SetPedRelationshipGroupHash(PlayerPedId(), GetPedRelationshipGroupDefaultHash(PlayerPedId()))

	if DoesRelationshipGroupExist(GetHashKey('ff_airsoft_team1')) then
		RemoveRelationshipGroup(GetHashKey('ff_airsoft_team1'))
		RemoveRelationshipGroup(GetHashKey('ff_airsoft_team2'))
	end

	Citizen.Wait(500)
	Framework.Revive()
end)

RegisterNetEvent('ff_airsoft:lobby:spawned', function(path)
	RefillAmmoInstantly(PlayerPedId())

	if path then
		local plane, pilot = 0, 0

		DoScreenFadeOut(0)
		Citizen.SetTimeout(2500, function()
			DoScreenFadeIn(250)
		end)

		local planeModel = 'bombushka'
		ReuqestModel(planeModel)
		ReuqestModel('s_m_m_pilot_01')

		SetEntityCoords(PlayerPedId(), path.start)
		GiveWeaponToPed(PlayerPedId(), GetHashKey('gadget_parachute'), 1, false, false)

		local plane = CreateVehicle(GetHashKey(planeModel), path.start.x, path.start.y, path.start.z, path.heading, false, true)
		local pilot = CreatePedInsideVehicle(plane, 4, GetHashKey('s_m_m_pilot_01'), -1, false, true)

		SetVehicleEngineOn(plane, true, true, false)
		SetVehicleEngineOn(plane, false, false, true)
		SetVehicleMaxSpeed(plane, 30.0)
		local velocity = GetEntityForwardVector(plane) * 120
		SetEntityVelocity(plane, velocity.x, velocity.y, velocity.z)
		TaskPlaneMission(pilot, plane, nil, nil, path.target.x, path.target.y, path.target.z, 6, 10.0, -1.0, 90.0, 0, -5000.0)
		ControlLandingGear(plane, 3)

		AttachEntityToEntity(PlayerPedId(), plane, 0, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0, false, true, false, true, 1, false)

		local deleted = false
		local dropped = false
		local parachute = false
		local landed = false

		Citizen.CreateThread(function()
			while GameData.starting do
				Citizen.Wait(0)

				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				local distance = #(GetEntityCoords(plane) - path.target)

				local _, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, true)
				local height = coords.z - groundZ

				SetEntityVisible(playerPed, dropped, 0)
				DisableControlAction(0, 145, true)

				if distance < path.minDropDistance then
					if IsControlJustReleased(0, 22) and not dropped then
						DetachEntity(playerPed, true, true)
						SetEntityHeading(playerPed, path.heading)
						SetEntityVelocity(playerPed, 0.0, 0.0, 0.0)
						dropped = true
						GameData.dropped = true
						TaskParachute(playerPed)
					end
					if not dropped then
						drawTxt(1.0, 1.45, 1.0, 1.0, 0.6, Translations[Translations.language].SpaceToJump, 255, 255, 255, 255)
					end
				end
				if distance < path.maxDropDistance and not dropped then
					DetachEntity(playerPed, true, true)
					SetEntityHeading(playerPed, path.heading)
					SetEntityVelocity(playerPed, 0.0, 0.0, 0.0)
					dropped = true
					GameData.dropped = true
					TaskParachute(playerPed)
				end

				if height > 250 then
					DisableControlAction(0, 144, true)
				else
					if not parachute and not landed then
						drawTxt(1.0, 1.45, 1.0, 1.0, 0.6, Translations[Translations.language].LMBToParachute, 255, 255, 255, 255)
					end
				end
				if GetPedParachuteState(playerPed) == 1 and not parachute then
					parachute = true
				end
				if height < 75 and not parachute then
					ForcePedToOpenParachute(playerPed)
					parachute = true
				end

				if not landed and parachute and GetPedParachuteState(playerPed) == -1 then
					landed = true
				end
				if not dropped then
					SetGameplayCamFollowPedThisUpdate(pilot)
				end

				if distance < path.delete and not deleted then
					deleted = true
					DeletePed(ped)
					DeleteVehicle(plane)
					break
				end
			end

			SetEntityVisible(PlayerPedId(), true, 0)
			DeletePed(pilot)
			DeleteVehicle(plane)
		end)
	end
end)

RegisterNetEvent('ff_airsoft:lobby:respawn', function(spawn)
	DoScreenFadeOut(50)
	local ped = PlayerPedId()
	
	Citizen.Wait(500)
	DoScreenFadeIn(1500)

	Framework.Revive()

	Citizen.Wait(50)
	if GameData.CurrentLobby.teams then
		NetworkSetFriendlyFireOption(false)
	end

	if Config.GameModes[GameData.CurrentLobby.gamemode].key ~= 'battle' then
		TriggerServerEvent('ff_airsoft:lobby:respawn')
	end
	
	Citizen.CreateThread(function()
		SetEntityInvincible(ped, true)
		SetLocalPlayerAsGhost(true)
		local spawnShield = 0
		while spawnShield < 450 and GetSelectedPedWeapon(ped) == GetHashKey('WEAPON_UNARMED') do 
			SetEntityAlpha(ped, 150, false)
			spawnShield = spawnShield + 1
			Citizen.Wait(0)
		end
		Citizen.Wait(1000)
		SetEntityInvincible(ped, false)
		SetLocalPlayerAsGhost(false)
		ResetEntityAlpha(ped)
	end)

	if GameData.CurrentLobby.armor then
		SetPedArmour(PlayerPedId(), 97)
	end

	Citizen.Wait(1000)
	StopScreenEffect('DeathFailOut')
end)

RegisterNetEvent('ff_airsoft:perms', function(aces)
	Aces = aces
end)

Registered = false
RegisterNetEvent('ff_airsoft:maintenance', function(maintenance, debug)
	Maintenance = maintenance
	DebugMode = debug
	ESX.UI.Menu.CloseAll()

	if Registered then
		do return end
	end
	Registered = true
	if DebugMode then DebugEvents() end
end)

RegisterNetEvent('ff_airsoft:maps', function(data)
	Config.Maps = data
end)

RegisterNetEvent('ff_airsoft:return', function()
	DoScreenFadeOut(50)
	FreezeEntityPosition(PlayerPedId(), true)
	RemoveAllPedWeapons(PlayerPedId())
	Citizen.Wait(5000)
	DoScreenFadeIn(50)
	FreezeEntityPosition(PlayerPedId(), false)
	LocalPlayer.state.blockEmotes = false
end)

RegisterNetEvent('ff_airsoft:pickup:sound', function(coord)
	PlaySoundFromCoord(-1, 'CONFIRM_BEEP', coord, 'HUD_MINI_GAME_SOUNDSET', false, 5.0, false)
end)

function LobbyThread()
	local playerId = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))

	exports.ox_inventory:weaponWheel(true)
	TriggerEvent('cd_easytime:PauseSync', true)

	LocalPlayer.state.blockEmotes = true

	GameData.starting = true
	ESX.UI.Menu.CloseAll()
	TriggerEvent('ff_airsoft:notification', Translations[Translations.language].LobbyStarting)

	Citizen.Wait(200)
	DoScreenFadeOut(750)
	Citizen.Wait(500)

	if Config.GameModes[GameData.CurrentLobby.gamemode].key ~= 'battle' then
		TriggerServerEvent('ff_airsoft:lobby:respawn')
	end

	GameData.active = true
	GameData.ending = false

	if GameData.CurrentLobby.map then
		GameData.cage = PolyZone:Create(Config.Maps[GameData.CurrentLobby.map].Zone, {
			name = GameData.CurrentLobby.map,
			debugPoly = true,
			minZ = -150.0,
			maxZ = 1200.0,
			debugColors = {walls = Config.PolyzoneColor, grid = Config.PolyzoneColor, outline = Config.PolyzoneColor}
		})
	else
		local center = GameData.CurrentLobby.Zone
		GameData.zone = {
			diameter = 1050.0,
			shrink = false,
			timeout = true,
			nextShrinktarget = 600,
			blip = AddBlipForRadius(center.x, center.y, center.z, diameter)
		}
		Citizen.SetTimeout(45000, function()
			if GameData.zone then
				GameData.zone.shrink = true
				GameData.zone.timeout = false
			end
		end)
	end

	-- grp only
	-- TriggerEvent('staffblips:togglenames', false)
	-- TriggerEvent('staffblips:toggle', false)
	SetWeaponsNoAutoreload(false)

	-- TriggerEvent('skinchanger:getSkin', function(skin)
	-- 	TriggerEvent('skinchanger:loadClothes', skin, { ['helmet_1'] = -1 })
	-- end)

	Citizen.Wait(1500)
	DoScreenFadeIn(500)
	FreezeEntityPosition(PlayerPedId(), false)

	if GameData.CurrentLobby.teams then
		local group
		if table.contains(GameData.CurrentLobby.teams[1], playerId) then
			group = 'ff_airsoft_team1'
		else
			group = 'ff_airsoft_team2'
		end

		AddRelationshipGroup('ff_airsoft_team1')
		AddRelationshipGroup('ff_airsoft_team2')

		SetRelationshipBetweenGroups(5, GetHashKey('ff_airsoft_team1'), GetHashKey('ff_airsoft_team2'))
		SetRelationshipBetweenGroups(5, GetHashKey('ff_airsoft_team2'), GetHashKey('ff_airsoft_team1'))

		NetworkSetFriendlyFireOption(false)
		SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey(group))
	else
		NetworkSetFriendlyFireOption(true)
	end

	Citizen.CreateThread(function()
		Citizen.Wait(500)
		if GameData.CurrentLobby.blips then
			for _, source in pairs(GameData.CurrentLobby.players) do
				if source ~= playerId then
					local targetPed = GetPlayerPed(GetPlayerFromServerId(source))
					local friendly = GetRelationshipBetweenPeds(PlayerPedId(), targetPed) == 1
					if not GameData.CurrentLobby.teams then friendly = false end
					
					CreateBlip(targetPed, friendly)
				end
			end
		else
			if GameData.CurrentLobby.teams then
				for _, source in pairs(GameData.CurrentLobby.players) do
					if source ~= playerId then
						local targetPed = GetPlayerPed(GetPlayerFromServerId(source))
						local friendly = GetRelationshipBetweenPeds(PlayerPedId(), targetPed) == 1
						
						if friendly then CreateBlip(targetPed, friendly) end
					end
				end
			end
		end
	end)

	local lastDamage = 0

	Citizen.CreateThread(function()
		
		if GameData.cage then
			GameData.cage:onPlayerInOut(function(inside)
				GameData.inMap = inside
	
				if not inside then
					Citizen.CreateThread(function()
						local timer = 5
						while not GameData.inMap and not GameData.ending do
							timer = timer - 1
							ShowFreemodeMessage(Translations[Translations.language].ReturnToMap, ' ', 1)
							if timer <= 0 and not GameData.ending then
								SetEntityHealth(PlayerPedId(), 0)
								break
							end
							Citizen.Wait(1000)
						end
					end)
				end
			end)
		end

		while GameData.active do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

			if IsEntityDead(ped) and not GameData.dead then
				GameData.dead = true
				Citizen.Wait(500)
				local killerId = GetPlayerServerId(NetworkGetEntityOwner(GetPedSourceOfDeath(ped)))
				
				if Config.GameModes[GameData.CurrentLobby.gamemode].key == 'battle' then
					GameData.died = true
				end
				StartScreenEffect('DeathFailOut', 0, true)
				TriggerServerEvent('ff_airsoft:lobby:died', killerId)

				if Config.GameModes[GameData.CurrentLobby.gamemode].key == 'battle' then
					local drops = {}

					for item, _ in pairs(Config.GameModes[GameData.CurrentLobby.gamemode].PickupModels) do
						if GetPedAmmoByType(ped, item) > 0 then
							drops[item] = GetPedAmmoByType(ped, item)
						end
					end

					TriggerServerEvent('ff_airsoft:lobby:dropLoot', drops)
				end
			elseif not IsEntityDead(ped) then
				GameData.dead = false
			end

			if GameData.CurrentLobby.night then
				NetworkOverrideClockTime(23, 0, 0)
			else
				NetworkOverrideClockTime(12, 0, 0)
			end

			ClearOverrideWeather()
			ClearWeatherTypePersist()
			SetWeatherTypeNowPersist("EXTRASUNNY")
			SetWeatherTypeNow("EXTRASUNNY")
			SetWeatherTypeNowPersist("EXTRASUNNY")

			if GameData.CurrentLobby.stamina then
				RestorePlayerStamina(PlayerId(), 1.0)
			end

			DrawLobbyScoreboard()

			if GameData.CurrentLobby.Zone then
				local center = GameData.CurrentLobby.Zone
				RemoveBlip(GameData.zone.blip)
				GameData.zone.blip = AddBlipForRadius(center.x, center.y, center.z, GameData.zone.diameter)
				SetRadiusBlipEdge(GameData.zone.blip, true)
				SetBlipColour(GameData.zone.blip, 79)
				DrawMarker(1, center.x, center.y, -20.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GameData.zone.diameter * 2, GameData.zone.diameter * 2, 400.0, 200, 0, 0, 200, false, false, 2, nil, nil, false)
			
				if GameData.zone.shrink then
					if GameData.zone.diameter > GameData.zone.nextShrinktarget then
						GameData.zone.diameter = GameData.zone.diameter - (2.5 * GetFrameTime())
					else
						if not GameData.zone.timeout then
							GameData.zone.timeout = true
							Citizen.SetTimeout(90000, function()
								if GameData.zone then
									GameData.zone.shrink = true
									GameData.zone.timeout = false
									GameData.zone.nextShrinktarget = GameData.zone.nextShrinktarget - 300
								end
							end)
						end
					end
				end

				if ((GetDistanceBetweenCoords(coords, center, false) - GameData.zone.diameter) - 10 > 0) or (GameData.zone.diameter < 0.5) then
					if GetGameTimer() - lastDamage > 750 and GameData.dropped and not GameData.died then
						ApplyDamageToPed(ped, 10, true)
						lastDamage = GetGameTimer()
					end
				end
			end

			if GameData.CurrentLobby.Pickups and not GameData.dead then
				for _, pickup in pairs(GameData.CurrentLobby.Pickups) do
					if NetworkDoesEntityExistWithNetworkId(pickup.entity) then
						SetEntityDrawOutlineColor(255, 255, 255, 90)
						local entity = NetworkGetEntityFromNetworkId(pickup.entity)
						local distance = #(GetEntityCoords(entity) - coords)
						
						if distance < 1.0 then
							TriggerServerEvent('ff_airsoft:pickup:collect', pickup.entity)
						elseif distance < 5 then
							SetEntityDrawOutline(entity, true)
						end
					end
				end
			end

			if GameData.CurrentLobby.timer == 0 then
				DisableAllControlActions(0)
			end

			Citizen.Wait(0)
		end
	end)
end

function DrawLobbyScoreboard()
	if GameData.CurrentLobby.timer == 0 then
		drawTxt(1.01, 0.55, 2.0, 1.0, 0.6, Translations[Translations.language].GameEnded, 255, 255, 255, 255)
	else
		drawTxt(1.01, 0.55, 2.0, 1.0, 0.6, string.format(Translations[Translations.language].TimeLeft, GameData.CurrentLobby.timer), 255, 255, 255, 255)
	end

	if GameData.CurrentLobby.teams then
		local killData = {}
		local teamKills = { [1] = 0, [2] = 0 }

		for player, kills in sortpairs(GameData.CurrentLobby.kills, function(t, a, b) return t[b] < t[a] end) do
			table.insert(killData, { player = player, kills = kills })

			if table.contains(GameData.CurrentLobby.teams[1], player) then
				teamKills[1] = teamKills[1] + kills
			else
				teamKills[2] = teamKills[2] + kills
			end
		end
		
		local i = 1

		for j = 1, 2, 1 do
			drawTxt(1.01, 0.58 + (i * 0.03), 2.0, 1.0, 0.6, string.format("Team kills: %s", teamKills[j]), 255, 255, 255, 255)
			i = i + 1
	
			for idx, data in pairs(killData) do
				if table.contains(GameData.CurrentLobby.teams[j], data.player) then
					local color = table.contains(GameData.CurrentLobby.players, data.player) and { r = 255, g = 255, b = 255, a = 255 } or { r = 255, g = 0, b = 0, a = 255 }
					drawTxt(1.01, 0.58 + (i * 0.03), 2.0, 1.0, 0.6, string.format(Translations[Translations.language].Scoreboard, idx, GameData.CurrentLobby.playerNames[data.player], data.kills), color.r, color.g, color.b, color.a)
					i = i + 1
				end
			end
			i = i + 1
		end
	else 
		local i = 1
		for player, kills in sortpairs(GameData.CurrentLobby.kills, function(t, a, b) return t[b] < t[a] end) do
			local color = table.contains(GameData.CurrentLobby.players, player) and { r = 255, g = 255, b = 255, a = 255 } or { r = 255, g = 0, b = 0, a = 255 }
			drawTxt(1.01, 0.58 + (i * 0.03), 2.0, 1.0, 0.6, string.format(Translations[Translations.language].Scoreboard, i, GameData.CurrentLobby.playerNames[player], kills), color.r, color.g, color.b, color.a)
			i = i + 1
		end
	end
end

exports('isInAirsoft', function()
    return GameData.CurrentLobby ~= nil
end)

function CreateBlip(entity, friendly)
	local blip = AddBlipForEntity(entity)
	SetBlipSprite(blip, 1)
	SetBlipColour(blip, 3)
	SetBlipAsFriendly(blip, friendly)
	ShowHeadingIndicatorOnBlip(blip, true)

	table.insert(GameData.blips, blip)
end

function ReuqestModel(model)
	local hash = GetHashKey(model)
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(0)
	end
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.50, 0.50)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

FreemodeScaleform = nil
FreemodeScaleformTimer = nil
ShowFreemodeMessage = function(title, msg, sec)
	FreemodeScaleform = RequestScaleformMovieStream('MP_BIG_MESSAGE_FREEMODE')

	BeginScaleformMovieMethod(FreemodeScaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	PushScaleformMovieMethodParameterString(title)
	PushScaleformMovieMethodParameterString(msg)
	EndScaleformMovieMethod()

	local start = FreemodeScaleformTimer == nil
	FreemodeScaleformTimer = sec

	if start then
		while FreemodeScaleformTimer > 0 do
			Citizen.Wait(1)
			FreemodeScaleformTimer = FreemodeScaleformTimer - 0.01
			DrawScaleformMovieFullscreen(FreemodeScaleform, 255, 255, 255, 255)
		end
		FreemodeScaleformTimer = nil
	end


	SetScaleformMovieAsNoLongerNeeded(FreemodeScaleform)
end

function DebugEvents()
	Translations[Translations.language].Lobbies = Translations[Translations.language].Lobbies .. " (DEBUG MODE ENABLED)"

	DebugMap = nil
	DebugZone = nil
	LastPoints = nil
	CreateMap = false

	RegisterNetEvent('ff_airsoft:debug:zone', function(points, name)
		LastPoints = {}
		for _, coord in pairs(points) do
			table.insert(LastPoints, vector2(coord.x, coord.y))
		end

		if CreateMap then
			table.insert(Config.Maps, {
				Label = name,
				Spawns = {},
				Loadouts = { 1 },
				Zone = LastPoints
			})

			CreateMap = false

			LastPoints = nil
			MapEditorList()
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			
			::continue::
			if DebugMap == nil then
				Citizen.Wait(100)
				goto continue
			end

			for _, coords in pairs(Config.Maps[DebugMap].Spawns) do
				DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, true, true, 2, false)
			end
		end
	end)

	function MapEditorView(map, ignoreTp)
		if DebugZone ~= nil then
			DebugZone:destroy()
			DebugZone = nil
		end

		DebugMap = map
		DebugZone = PolyZone:Create(Config.Maps[map].Zone, {
			name = map,
			debugPoly = true,
			minZ = -10.0,
			maxZ = 1000.0,
			debugColors = {walls = Config.PolyzoneColor, grid = Config.PolyzoneColor, outline = Config.PolyzoneColor}
		})

		if not ignoreTp then
			if #Config.Maps[DebugMap].Spawns > 0 then
				SetEntityCoords(PlayerPedId(), Config.Maps[DebugMap].Spawns[1])
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'airsoft_mapeditor_edit', {
			title = "Airsoft map editor (" .. Config.Maps[DebugMap].Label .. ")",
			align = 'top-right',
			elements = {
				{ label = 'Rename map', value = 'rename' },
				{ label = 'Delete map', value = 'delete' },
				{ label = 'Update zone', value = 'updatezone' },
				{ label = 'Add spawn point', value = 'addspawn' },
				{ label = 'Delete closest spawn point', value = 'removespawn' },
				{ label = 'Select loadouts', value = 'loadouts' }
			}
		}, function(data, menu)
			if data.current.value == 'addspawn' then
				table.insert(Config.Maps[DebugMap].Spawns, GetEntityCoords(PlayerPedId()))
			elseif data.current.value == 'removespawn' then
				local closestIdx, closest = nil, nil
				local playerCoords = GetEntityCoords(PlayerPedId())
				
				for idx, coords in pairs(Config.Maps[DebugMap].Spawns) do
					if closest == nil or #(playerCoords - coords) < closest then
						closestIdx = idx
						closest = #(playerCoords - coords)
					end
				end

				if closestIdx ~= nil then
					table.remove(Config.Maps[DebugMap].Spawns, closestIdx)
				end
			elseif data.current.value == 'rename' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'airsoft_mapeditor_rename', {
					title = "New lobby name"
				}, function(dialog, dialogmenu)
					if #dialog.value > 0 then
						dialogmenu.close()
						Config.Maps[DebugMap].Label = dialog.value
						MapEditorView(DebugMap, true)
					end
				end, function(dialog, dialogmenu)
					dialogmenu.close()
				end)
			elseif data.current.value == 'delete' then
				table.remove(Config.Maps, DebugMap)

				menu.close()
				DebugZone:destroy()
				DebugZone = nil
				DebugMap = nil

				TriggerServerEvent('ff_airsoft:mapeditor:save', Config.Maps)
	
				Citizen.Wait(1)
				MapEditorList()
			elseif data.current.value == 'updatezone' then
				if LastPoints ~= nil then
					Config.Maps[DebugMap].Zone = LastPoints

					menu.close()
					DebugZone:destroy()
					DebugZone = nil
		
					Citizen.Wait(1)
					MapEditorView(DebugMap, true)
				else
					ShowHelpNotification("\nFirst make a polyzone!", false, true, 5000)
				end
			elseif data.current.value == 'loadouts' then
				local elements = {}
				for _, loadout in pairs(Config.Loadouts) do
					table.insert(elements, { label = loadout.Label .. (table.indexByValue(Config.Maps[DebugMap].Loadouts, _) ~= nil and ' ✓' or ''), value = _ })
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'airsoft_mapeditor_loadouts', {
					title = "Edit allowed loadouts",
					align = 'top-right',
					elements = elements
				}, function(data, menu)
					if table.indexByValue(Config.Maps[DebugMap].Loadouts, data.current.value) == nil then
						table.insert(Config.Maps[DebugMap].Loadouts, data.current.value)
					else
						table.remove(Config.Maps[DebugMap].Loadouts, table.indexByValue(Config.Maps[DebugMap].Loadouts, data.current.value))
					end

					Citizen.Wait(1)

					local newLabel = Config.Loadouts[data.current.value].Label .. (table.indexByValue(Config.Maps[DebugMap].Loadouts, data.current.value) ~= nil and ' ✓' or '')
					menu.update({ value = data.current.value }, { label = newLabel })
					menu.refresh()
				end, function(data, menu)
					menu.close()
				end)
			end
		end, function(data, menu)
			menu.close()
			DebugZone:destroy()
			DebugZone = nil
			DebugMap = nil

			TriggerServerEvent('ff_airsoft:mapeditor:save', Config.Maps)

			Citizen.Wait(1)
			MapEditorList()
		end)
	end

	function MapEditorList()
		local elements = {}

		for index, map in pairs(Config.Maps) do
			table.insert(elements, { label = map.Label, value = index })
		end

		table.insert(elements, { label = '' })
		table.insert(elements, { label = 'Create new map', value = 'newmap'})

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'airsoft_mapeditor_overview', {
			title = "Airsoft map editor",
			align = 'top-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value and type(data.current.value) == 'number' then
				MapEditorView(data.current.value)
			elseif data.current.value and data.current.value == 'newmap' then
				CreateMap = true
				ExecuteCommand("pzcreate poly")
			end
		end, function(data, menu)
			menu.close()
		end)
	end

	RegisterCommand("airsoftmaps", function(_, args)
		MapEditorList()
	end)

	-- todo weghalen
	RegisterCommand("pickups", function(_, args)
		for _, pickups in pairs(Config.GameModes[5].Pickups) do
			for __, coords in pairs(pickups) do
				AddBlipForCoord(coords)
			end
		end
	end)
end

AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		if DebugZone ~= nil then
			DebugZone:destroy()
			DebugZone = nil
		end
	end
end)
