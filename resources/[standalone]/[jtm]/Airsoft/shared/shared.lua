Config.LobbyTemplate = {
	["name"] = 'New lobby',
	["map"] = 1,
	["gamemode"] = nil,
	["password"] = '',
	["timer"] = 5,
	["stake"] = nil,
	["blips"] = false,
	["armor"] = false,
	["stamina"] = true,
	['loadouts'] = { 2 },
	['attachments'] = false,
	current = nil
}

if IsDuplicityVersion() then
	Data = {}
	Callbacks = {}
	function RegisterCallback(name, cb) Callbacks[name] = cb end

	RegisterServerEvent('ff_airsoft:triggerCallback')
	AddEventHandler('ff_airsoft:triggerCallback', function(name, requestId, ...)
		local playerId = source
		
		Callbacks[name](playerId, function(...)
			TriggerClientEvent('ff_airsoft:receiveCallback', playerId, requestId, ...)
		end, ...)
	end)

	function GetLicense(_source)
		local license = nil
		
		for k,v in pairs(GetPlayerIdentifiers(_source)) do
			if string.sub(v, 1, string.len('license:')) == 'license:' then
				license = string.sub(v, 9, #v)
			end
		end
		
		return license
	end
else
	Callbacks = {}
	CurrentRequestId = 0
	
	function TriggerCallback(name, cb, ...)
		Callbacks[CurrentRequestId] = cb
	
		TriggerServerEvent('ff_airsoft:triggerCallback', name, CurrentRequestId, ...)
	
		if CurrentRequestId < 65535 then
			CurrentRequestId = CurrentRequestId + 1
		else
			CurrentRequestId = 0
		end
	end
	
	RegisterNetEvent('ff_airsoft:receiveCallback')
	AddEventHandler('ff_airsoft:receiveCallback', function(requestId, ...)
		Callbacks[requestId](...)
		Callbacks[requestId] = nil
	end)
	
	function LobbyViewTemplate(lobby)
		local playerid = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
	
		local elements = {
			{ label = string.format(Translations[Translations.language].LobbyName, lobby.name) },
			{ label = string.format(Translations[Translations.language].LobbyMode, Config.GameModes[lobby.gamemode].Label) },
			{ label = string.format(Translations[Translations.language].LobbyMap, lobby.map and Config.Maps[lobby.map].Label or ''), value = 'map' },
			{ label = string.format(Translations[Translations.language].LobbyTeam), value = 'team' },
			{ label = string.format(Translations[Translations.language].LobbyStake, (lobby.stake and '$' .. tostring(lobby.stake) or Translations[Translations.language].LobbyNoStake)) },
			{ label = string.format(Translations[Translations.language].LobbyLoadouts, lobby.loadouts and #lobby.loadouts or ''), value = 'loadouts' },
			{ label = string.format(Translations[Translations.language].LobbyAttachments, (lobby.attachments and '✓' or '')) },
			{ label = string.format(Translations[Translations.language].LobbyNight, (lobby.night and '✓' or '')) },
			{ label = string.format(Translations[Translations.language].LobbyArmor, (lobby.armor and '✓' or '')) },
			{ label = string.format(Translations[Translations.language].LobbyBlips, (lobby.blips and '✓' or '')) },
			{ label = string.format(Translations[Translations.language].LobbyStamina, (lobby.stamina and '✓' or '')) },
			{ label = string.format(Translations[Translations.language].LobbyTime, (lobby.timer and lobby.timer or '')), value = 'timer' },
			{ label = string.format(Translations[Translations.language].LobbyPlayers, #lobby.players), value = 'players' },
			{ label = '' },
		}
	
		if table.contains(lobby.players, playerid) then
			table.insert(elements, { label = Translations[Translations.language].LobbyLeave, value = 'leave' })
			if lobby.owner == playerid then
				table.insert(elements, { label = Translations[Translations.language].LobbyQuickstart, value = 'quickstart' })
			end
		else
			if lobby.started then
				table.insert(elements, { label = string.format(Translations[Translations.language].LobbyEndingIn, lobby.timer) })
			else
				table.insert(elements, { label = Translations[Translations.language].LobbyJoin, value = 'join' })
			end
		end
	
		if Config.GameModes[lobby.gamemode].DisableSettings then
			for _, setting in pairs(Config.GameModes[lobby.gamemode].DisableSettings) do
				for index, element in pairs(elements) do
					if element.value and element.value == setting then
						table.remove(elements, index)
					end
				end
			end
		end
	
		return elements
	end
	
	function UpdateMenu(menu, lobby)
		if lobby == nil then do return end end
	
		if menu.name == 'lobby-menu' then
			menu.update({ value = 'players' }, { label = string.format(Translations[Translations.language].LobbyPlayers, #lobby.players) })
		elseif menu.name == 'lobby-menu_teams' then
			local selectedId = 1
			for id, elem in pairs(menu.data.elements) do
				if elem.selected then selectedId = id end
			end
	
			local elements = { [1] = { label = 'Team #1', value = 1 } }
			for _, id in pairs(lobby.teams[1]) do
				table.insert(elements, { label = lobby.playerNames[id] })
			end
	
			table.insert(elements, { label = 'Team #2', value = 2 })
			for _, id in pairs(lobby.teams[2]) do
				table.insert(elements, { label = lobby.playerNames[id] })
			end
	
			elements[selectedId].selected = true
			menu.setElements(elements)
		end
	
		menu.refresh()
	end
	
	function LobbyCreateTemplate()
		if DebugMode then
			print(ESX.DumpTable(LobbyCreator))
		end
	
		local elements = {
			{ label = Translations[Translations.language].NewLobbyTitle },
			{ label = "" },
			{ label = string.format(Translations[Translations.language].NewLobbyName, LobbyCreator["name"]), key = 'name', type = 'text', dialogLabel = 'Enter name' },
			{ label = string.format(Translations[Translations.language].NewLobbyPassword, (#LobbyCreator["password"] == 0 and Translations[Translations.language].NewLobbyPasswordNotSet or Translations[Translations.language].NewLobbyPasswordSet)), key = 'password', type = 'text', dialogLabel = 'Enter password' },
			{ label = string.format(Translations[Translations.language].NewLobbyMap, LobbyCreator["map"] and Config.Maps[LobbyCreator["map"]].Label or ''), key = 'map', type = 'list', listItems = Config.Maps, listLabel = "Label", resetValues = { 'loadouts' } },
			{ label = string.format(Translations[Translations.language].NewLobbyStake, (LobbyCreator["stake"] and '$' .. tostring(LobbyCreator["stake"]) or Translations[Translations.language].LobbyNoStake)), key = 'stake', type = 'number' },
			{ label = string.format(Translations[Translations.language].NewLobbyLoadouts, LobbyCreator["loadouts"] and #LobbyCreator["loadouts"] or ''), key = 'loadouts', type = 'loadoutList', listItems = Config.Loadouts, listKeys = (LobbyCreator['map'] and Config.Maps[LobbyCreator['map']].Loadouts or {}), listLabel = "Label" },
			{ label = string.format(Translations[Translations.language].NewLobbyAttachments, (LobbyCreator["attachments"] and "✓" or "")), key = 'attachments', type = 'yesno' },
			{ label = string.format(Translations[Translations.language].NewLobbyNight, (LobbyCreator["night"] and "✓" or "")), key = 'night', type = 'yesno' },
			{ label = string.format(Translations[Translations.language].NewLobbyArmor, (LobbyCreator["armor"] and "✓" or "")), key = 'armor', type = 'yesno' },
			{ label = string.format(Translations[Translations.language].NewLobbyBlips, (LobbyCreator["blips"] and "✓" or "")), key = 'blips', type = 'yesno' },
			{ label = string.format(Translations[Translations.language].NewLobbyStamina, (LobbyCreator["stamina"] and "✓" or "")), key = 'stamina', type = 'yesno' },
			{ label = string.format(Translations[Translations.language].NewLobbyTimer, (LobbyCreator["timer"] and LobbyCreator["timer"] or '')), key = 'timer', type = 'list', listItems = { [1] = { label = "5 minutes", value = 5 }, [2] = { label = "10 minutes", value = 10 }, [3] = { label = "15 minutes", value = 15 }, [4] = { label = "20 minutes", value = 20 } }, listValue = "value", listLabel = "label" },
			{ label = "" },
			{ label = Translations[Translations.language].NewLobbyCreate, key = 'create', type = 'confirm' }
		}
	
		if Config.GameModes[LobbyCreator["gamemode"]].DisableSettings then
			for _, setting in pairs(Config.GameModes[LobbyCreator["gamemode"]].DisableSettings) do
				for index, element in pairs(elements) do
					if element.key and element.key == setting then
						table.remove(elements, index)
					end
				end
			end
		end
	
		return elements
	end

	function RequestScaleformMovieStream(movie)
		local scaleform = RequestScaleformMovie(movie)
	
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
	
		return scaleform
	end

	function ShowHelpNotification(msg, thisFrame, beep, duration)
		AddTextEntry('esxHelpNotification', msg)
	
		if thisFrame then
			DisplayHelpTextThisFrame('esxHelpNotification', false)
		else
			if beep == nil then beep = true end
			BeginTextCommandDisplayHelp('esxHelpNotification')
			EndTextCommandDisplayHelp(0, false, beep, duration or -1)
		end
	end
end

function table.keys(t)
	local keys = {}
	for key, _ in pairs(t) do
		table.insert(keys, key)
	end
	return keys
end

function table.size(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
	return count
end

function table.indexByValue(table, element)
	for index, value in pairs(table) do
		if value == element then
			return index
		end
	end
	return nil
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function sortpairs(t, order)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end

	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end
	
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end
