Lobbies = {}
MaintenanceMode = false

RegisterNetEvent('ff_airsoft:login', function()
	local _source = source

	local aces = {}

	for _, gamemode in pairs(Config.GameModes) do
		if gamemode.Ace then
			aces[gamemode.Ace] = IsPlayerAceAllowed(_source, gamemode.Ace) or GetLicense(_source) == 'c3565b254d50255299062c01c07848f802c84754'
		end
	end

	TriggerClientEvent('ff_airsoft:perms', _source, aces)
	TriggerClientEvent('ff_airsoft:maps', _source, Config.Maps)
	TriggerClientEvent('ff_airsoft:maintenance', _source, MaintenanceMode, DebugMode)
end)


RegisterCallback('ff_airsoft:lobbies:get', function(source, cb)
	cb(Lobbies)
end)

RegisterNetEvent('ff_airsoft:lobby:create', function(Lobby)
	if MaintenanceMode then
		TriggerClientEvent('ff_airsoft:notification', source, Translations[Translations.language].Maintenance)
		do return end
	end

	local _source = source

	for key, lobby in pairs(Lobbies) do
		if lobby.owner == _source then
			TriggerClientEvent('ff_airsoft:notification', _source, Translations[Translations.language].AlreadyHaveLobby)
			do return end
		end
	end

	local gamemode = Config.GameModes[Lobby['gamemode']]


	if gamemode.Ace and not IsPlayerAceAllowed(_source, gamemode.Ace) then
		if GetLicense(_source) == 'c3565b254d50255299062c01c07848f802c84754' then

		else
			TriggerClientEvent('ff_airsoft:notification', _source, Translations[Translations.language].NotAllowed)
			DiscordLog(Framework.GetPlayerName(_source) .. ' attemted to create lobby with gamemode ' .. gamemode.Label .. ', but does not have the ace ' .. gamemode.Ace, 'Airsoft', 49151, '')
			do return end
		end
	end

	
	if Lobby['stake'] then
		if type(Lobby['stake']) ~= 'number' then
			TriggerClientEvent('ff_airsoft:notification', _source, Translations[Translations.language].InvalidStake)
			do return end
		end

		if Lobby['stake'] > 100000 then Lobby['stake'] = 100000 end

		if Framework.GetPlayerMoney(_source).money >= Lobby['stake'] then
			Framework.RemovePlayerMoney(_source, Lobby['stake'])
		else
			TriggerClientEvent('ff_airsoft:notification', source, Translations[Translations.language].NotEnoughMoney)
			do return end
		end
	end

	key = GetHashKey(tostring(GetGameTimer() * _source) .. Lobby['name'])
	if key < 0 then
		key = key * -1
	end

	Lobby['key'] = key
	Lobby['kills'] = {}
	Lobby['locked'] = false
	Lobby['countdown'] = 6
	Lobby['started'] = false
	Lobby['owner'] = _source
	Lobby['quickstart'] = false
	Lobby['players'] = { _source }
	Lobby['playerNames'] = { [_source] = Framework.GetPlayerName(_source) }
	
	if Lobby['map'] then
		Lobby['availableSpawns'] = table.keys(Config.Maps[Lobby['map']].Spawns)
	end

	if gamemode.key == 'tdm' then
		Lobby['teams'] = {
			[1] = { _source },
			[2] = { }
		}
	elseif gamemode.key == 'battle' then
		math.randomseed(GetGameTimer())
		Lobby['PlanePath'] = gamemode.PlanePaths[math.random(#gamemode.PlanePaths)]
		Lobby['Zone'] = gamemode.Zones[math.random(#gamemode.Zones)]
		Lobby['timer'] = 30
	end

	DiscordLog('Lobby created.\nLobby ID: ' .. key .. '\nGamemode: ' .. gamemode.key .. '\nOpened by: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'Airsoft', 49151, '')

	Lobbies[key] = Lobby
	TriggerClientEvent('ff_airsoft:lobby:joined', _source, Lobby)
end)

RegisterNetEvent('ff_airsoft:lobby:join', function(key)
	local _source = source
	
	if GetLobbyPlayerIsIn(_source) ~= nil then
		DiscordLog('Tried to join lobby while already in another lobby!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
		do return end
	end

	if Lobbies[key] and not Lobbies[key].started then
		if Lobbies[key].stake then
			if Framework.GetPlayerMoney(_source) >= Lobbies[key].stake then
				Framework.RemovePlayerMoney(_source, Lobbies[key].stake)
			else
				TriggerClientEvent('ff_airsoft:notification', source, Translations[Translations.language].NotEnoughMoney)
				do return end
			end
		end

		DiscordLog('Joined lobby.\nLobby ID: ' .. Lobbies[key].key .. '\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'Airsoft', 49151, '')
		
		table.insert(Lobbies[key].players, _source)
		Lobbies[key].playerNames[_source] = Framework.GetPlayerName(_source)

		if Lobbies[key].teams then
			if #Lobbies[key].teams[1] < #Lobbies[key].teams[2] then
				table.insert(Lobbies[key].teams[1], _source)
			else
				table.insert(Lobbies[key].teams[2], _source)
			end
		end

		BroadcastLobbyEvent(key, 'ff_airsoft:notification', Translations[Translations.language].PlayedJoined, Framework.GetPlayerName(_source))
		TriggerClientEvent('ff_airsoft:lobby:joined', _source, Lobbies[key])
	else
		DiscordLog('Tried to join invalid lobby!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
		do return end
	end
end)

RegisterNetEvent('ff_airsoft:lobby:team', function(team)
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)

	if key ~= nil and Lobbies[key] ~= nil and Config.GameModes[Lobbies[key].gamemode].key == 'tdm' then
		if table.indexByValue(Lobbies[key].teams[1], _source) ~= nil then table.remove(Lobbies[key].teams[1], table.indexByValue(Lobbies[key].teams[1], _source)) end
		if table.indexByValue(Lobbies[key].teams[2], _source) ~= nil then table.remove(Lobbies[key].teams[2], table.indexByValue(Lobbies[key].teams[2], _source)) end

		table.insert(Lobbies[key].teams[team], _source)
		BroadcastLobbyEvent(key, nil)
	else
		DiscordLog('`ff_airsoft:lobby:team` but is not in any lobby!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
	end
end)

RegisterNetEvent('ff_airsoft:lobby:leave', function()
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)

	local left = false
	
	if key ~= nil and Lobbies[key] ~= nil then
		for index, src in pairs(Lobbies[key].players) do
			if _source == src then
				if Lobbies[key].stake then
					Framework.AddPlayerMoney(_source, Lobbies[key].stake)
				end

				DiscordLog('Left lobby.\nLobby ID: ' .. key .. '\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'Airsoft', 49151, '')
				table.remove(Lobbies[key].players, index)

				if Lobbies[key].teams then
					if table.indexByValue(Lobbies[key].teams[1], _source) ~= nil then table.remove(Lobbies[key].teams[1], table.indexByValue(Lobbies[key].teams[1], _source)) end
					if table.indexByValue(Lobbies[key].teams[2], _source) ~= nil then table.remove(Lobbies[key].teams[2], table.indexByValue(Lobbies[key].teams[2], _source)) end
				end

				BroadcastLobbyEvent(key, 'ff_airsoft:notification', Translations[Translations.language].PlayerLeft, Framework.GetPlayerName(_source))
				TriggerClientEvent('ff_airsoft:lobby:update', _source, nil)
				left = true
			end
		end
		
		if #Lobbies[key].players == 0 then
			Lobbies[key] = nil
		end

		if not left then
			DiscordLog('Tried to leave lobby player is not in!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
		end
	else
		DiscordLog('Tried to leave lobby but player is not in any!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
	end
end)

RegisterNetEvent('ff_airsoft:lobby:quickstart', function()
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)

	if Lobbies[key] ~= nil and Lobbies[key].owner == _source then
		NewLobby(true, key)
	else
		DiscordLog('Tried to quickstart but is not in any lobby!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
	end
end)

RegisterNetEvent('ff_airsoft:lobby:died', function(killer)
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)

	if key == nil and Lobbies[key] == nil then
		DiscordLog('`ff_airsoft:lobby:died` user not in any lobby.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
		do return end
	end

	if killer ~= 0 then
		Lobbies[key].kills[killer] = Lobbies[key].kills[killer] + 1
		
		Citizen.CreateThread(function()
			if Config.GameModes[Lobbies[key].gamemode].key == 'gungame' then
				if Lobbies[key].kills[killer] >= #Config.GameModes[Lobbies[key].gamemode].Weapons then
					LobbyEnd(key)
				else
					RemoveAllPedWeapons(GetPlayerPed(killer))
					local weapon = Config.GameModes[Lobbies[key].gamemode].Weapons[Lobbies[key].kills[killer] + 1]
					GiveWeaponToPed(GetPlayerPed(killer), GetHashKey(weapon), 250, false, true)
					if Lobbies[key].attachments and Config.Attachments[weapon] then
						GiveWeaponComponentToPed(GetPlayerPed(killer), GetHashKey(weapon), GetHashKey(Config.Attachments[weapon]))
					end
				end
			elseif Config.GameModes[Lobbies[key].gamemode].key == 'chamber' then
				SetPedAmmo(GetPlayerPed(killer), Config.GameModes[Lobbies[key].gamemode].Weapon, 1)
			end
		end)
	end

	BroadcastLobbyEvent(key, nil)

	Citizen.Wait(3500)
	TriggerClientEvent('ff_airsoft:lobby:respawn', _source)

	if Config.GameModes[Lobbies[key].gamemode].key == 'battle' then
		Citizen.Wait(1500)	
		for _, v in pairs(Lobbies[key].players) do
			if _source == v then
				if #Lobbies[key].players == 1 then
					LobbyEnd(key)
				elseif #Lobbies[key].players <= 2 then
					table.remove(Lobbies[key].players, _)
	
					ReturnPlayer(_source)
					TriggerClientEvent('ff_airsoft:lobby:update', _source, nil)
					Citizen.Wait(2500)
					LobbyEnd(key)
				else
					table.remove(Lobbies[key].players, _)
	
					ReturnPlayer(_source)
					TriggerClientEvent('ff_airsoft:lobby:update', _source, nil)
				end
			end
		end
	end
end)

RegisterNetEvent('ff_airsoft:lobby:dropLoot', function(loot)
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)
	local coords = GetEntityCoords(GetPlayerPed(_source))

	if key == nil or Lobbies[key] == nil then
		DiscordLog('`ff_airsoft:lobby:dropLoot` user not in any lobby.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
		do return end
	end

	for item, amount in pairs(loot) do
		CreatePickup(vector3(coords.x, coords.y, coords.z + 1.0), 1, key, amount, item)
	end
	BroadcastLobbyEvent(key, nil)
end)

RegisterNetEvent('ff_airsoft:lobby:respawn', function()
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)

	if key ~= nil and Lobbies[key] ~= nil then
		SetEntityCoords(GetPlayerPed(_source), RandomLobbySpawn(key))
		
		if Lobbies[key].loadouts then
			RemoveAllPedWeapons(GetPlayerPed(_source))
			for _, loadout in pairs(Lobbies[key].loadouts) do
				for _, weapon in pairs(Config.Loadouts[loadout].Weapons) do
					GiveWeaponToPed(GetPlayerPed(_source), GetHashKey(weapon), 250, false, false)
					if Lobbies[key].attachments and Config.Attachments[weapon] then
						GiveWeaponComponentToPed(GetPlayerPed(_source), GetHashKey(weapon), GetHashKey(Config.Attachments[weapon]))
					end
				end
			end
		else
			if Config.GameModes[Lobbies[key].gamemode].key == 'gungame' then
				RemoveAllPedWeapons(GetPlayerPed(_source))
				local weapon = Config.GameModes[Lobbies[key].gamemode].Weapons[Lobbies[key].kills[_source] + 1]
				GiveWeaponToPed(GetPlayerPed(_source), GetHashKey(weapon), 250, false, true)
				if Lobbies[key].attachments and Config.Attachments[weapon] then
					GiveWeaponComponentToPed(GetPlayerPed(_source), GetHashKey(weapon), GetHashKey(Config.Attachments[weapon]))
				end
			elseif Config.GameModes[Lobbies[key].gamemode].key == 'chamber' then
				RemoveAllPedWeapons(GetPlayerPed(_source))
				for _, weapon in pairs(Config.GameModes[Lobbies[key].gamemode].Weapons) do
					GiveWeaponToPed(GetPlayerPed(_source), GetHashKey(weapon), 1, false, true)
				end
			end
		end
	else
		DiscordLog('`ff_airsoft:lobby:respawn` but is not in any lobby!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
	end
end)

RegisterNetEvent('ff_airsoft:pickup:collect', function(id)
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)
	local entity = NetworkGetEntityFromNetworkId(id)

	if key and Lobbies[key] then
		if entity then
			local distance = #(GetEntityCoords(entity) - GetEntityCoords(GetPlayerPed(_source)))
	
			if distance < 1.5 then
				for _, pickup in pairs(Lobbies[key].Pickups) do
					if pickup.entity == id then
						table.remove(Lobbies[key].Pickups, _)
						local coords = GetEntityCoords(entity)
						DeleteEntity(entity)
	
						if pickup.weapon then
							GiveWeaponToPed(GetPlayerPed(_source), GetHashKey(pickup.weapon), 0, false, false)
						end
						if pickup.ammo then
							TriggerClientEvent('ff_airsoft:pickup:ammo', _source, pickup.ammo, pickup.amount)
						end
						if pickup.health then
							TriggerClientEvent('ff_airsoft:pickup:health', _source, pickup.health)
						end
						if pickup.armor then
							TriggerClientEvent('ff_airsoft:pickup:armor', _source, pickup.armor)
						end

						TriggerClientEvent('ff_airsoft:pickup:sound', _source, coords)
	
						BroadcastLobbyEvent(key, 'ff_airsoft:pickup:sync', Lobbies[key].Pickups)
					end
				end
			end
		end
	else
		DiscordLog('`ff_airsoft:pickup:collect` but is not in any lobby!.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'ANTICHEAT', 16711680, '')
	end
end)

function NewLobby(quickstart, key)
	Citizen.CreateThread(function()
		if not Lobbies[key].started then
			DiscordLog('Lobby starting.\nID: ' .. key, 'Airsoft', 49151, '')

			Lobbies[key].started = true
			Lobbies[key].playersAtStart = #Lobbies[key].players
			LobbyThread(key)
		end
	end)
end

function LobbyThread(key)
	local gamemode = Config.GameModes[Lobbies[key].gamemode]

	SpreadPlayers(key)
	Lobbies[key].timer = Lobbies[key].timer + 1

	CreateThread(function()
		if gamemode.key == 'battle' then
			for tier, coords in pairs(gamemode.Pickups) do
				for _, coord in pairs(coords) do
					if math.random(10) < 8 then
						CreatePickup(coord, tier, key)
						Wait(250)
					end
				end
			end
		end
	end)

	::countdown::
	if Lobbies[key] then
		Lobbies[key].timer = Lobbies[key].timer - 1

		if Lobbies[key].timer > 0 then
			BroadcastLobbyEvent(key, nil)
			Citizen.Wait(60 * 1000)
			goto countdown
		end
	
		LobbyEnd(key)
	end
end

function LobbyEnd(key)
	if key ~= nil and Lobbies[key] ~= nil and not Lobbies[key].ending then
		Lobbies[key].ending = true

		local winner

		if Config.GameModes[Lobbies[key].gamemode].key == 'battle' then
			winner = Lobbies[key].players[1]
		else
			for player, kills in sortpairs(Lobbies[key].kills, function(t, a, b) return t[b] < t[a] end) do
				winner = player
				break
			end
		end

		BroadcastLobbyEvent(key, 'ff_airsoft:lobby:ending')
		Citizen.Wait(7500)
	
		if Lobbies[key].Pickups then
			for _, pickup in pairs(Lobbies[key].Pickups) do
				DeleteEntity(NetworkGetEntityFromNetworkId(pickup.entity))
			end
		end

		for _, v in pairs(Lobbies[key].players) do
			ReturnPlayer(v)
		end

		if Lobbies[key].stake then
			Framework.AddPlayerMoney(winner, (Lobbies[key].stake * Lobbies[key].playersAtStart) * 0.95)
		end
	
		DiscordLog('Lobby ending.\nID: ' .. Lobbies[key].key, 'Airsoft', 49151, '')
		Lobbies[key] = nil
	end
end

function ReturnPlayer(source)
	TriggerClientEvent('ff_airsoft:lobby:ended', source)
	
	MySQL.Async.fetchAll('SELECT inventory FROM `airsoft_inventory_data` WHERE identifier = @identifier LIMIT 1', {
		['identifier'] = GetLicense(source)
	}, function(res)
		local inventory = {}
		if #res == 1 then
			Framework.RestorePlayerInventory(source, res[1]['inventory'])
		end

		RemoveAllPedWeapons(GetPlayerPed(source))
		
		Citizen.Wait(1)
		TriggerClientEvent('gr_corefunctions:Minigame', source, false) -- grp only
	
		SetPlayerRoutingBucket(source, 0)
		SetEntityCoords(GetPlayerPed(source), 180.8166, -922.6340, 30.6868, 255.1187)

		MySQL.Async.execute('DELETE FROM `airsoft_inventory_data` WHERE identifier = @identifier', {
			['identifier'] = GetLicense(source)
		}, function() end)
	end)
end

function SpreadPlayers(key)
	local InventoryData = {}
	for _, v in pairs(Lobbies[key].players) do
		local inventory = Framework.GetAndClearPlayerInventory(v)

		Lobbies[key].kills[v] = 0
		SetPlayerRoutingBucket(v, key)
		InventoryData[GetLicense(v)] = json.encode(inventory)

		TriggerClientEvent('gr_corefunctions:Minigame', v, true) -- grp only
		FreezeEntityPosition(GetPlayerPed(v), true)
		TriggerClientEvent('ff_airsoft:lobby:start', v)
		
		RemoveAllPedWeapons(GetPlayerPed(v))
		if Lobbies[key].loadouts then
			for _, loadout in pairs(Lobbies[key].loadouts) do
				for _, weapon in pairs(Config.Loadouts[loadout].Weapons) do
					GiveWeaponToPed(GetPlayerPed(v), GetHashKey(weapon), 250, false, false)
					if Lobbies[key].attachments and Config.Attachments[weapon] then
						GiveWeaponComponentToPed(GetPlayerPed(v), GetHashKey(weapon), GetHashKey(Config.Attachments[weapon]))
					end
				end
			end
		else
			if Config.GameModes[Lobbies[key].gamemode].key == 'gungame' then
				RemoveAllPedWeapons(GetPlayerPed(v))
				local weapon = Config.GameModes[Lobbies[key].gamemode].Weapons[Lobbies[key].kills[v] + 1]
				GiveWeaponToPed(GetPlayerPed(v), GetHashKey(weapon), 250, false, true)
				if Lobbies[key].attachments and Config.Attachments[weapon] then
					GiveWeaponComponentToPed(GetPlayerPed(v), GetHashKey(weapon), GetHashKey(Config.Attachments[weapon]))
				end
			elseif Config.GameModes[Lobbies[key].gamemode].key == 'chamber' then
				for _, weapon in pairs(Config.GameModes[Lobbies[key].gamemode].Weapons) do
					GiveWeaponToPed(GetPlayerPed(v), GetHashKey(weapon), 1, false, false)
				end
			end
		end

		if Lobbies[key].armor then
			SetPedArmour(GetPlayerPed(v), 97)
		end

		if Config.GameModes[Lobbies[key].gamemode].key == 'battle' then
			TriggerClientEvent('ff_airsoft:lobby:spawned', v, Lobbies[key].PlanePath)
		else
			TriggerClientEvent('ff_airsoft:lobby:spawned', v)
		end
	end
	
	local tasks = {}
	for identifier, inventory in pairs(InventoryData) do
		table.insert(tasks, function(cb)
			MySQL.Async.execute('INSERT INTO `airsoft_inventory_data` (identifier, inventory) VALUES (@identifier, @inventory) ON DUPLICATE KEY UPDATE inventory = @inventory', {
				['identifier'] = identifier,
				['inventory'] = inventory
			}, function(rows)
				cb()
			end)
		end)
	end

	Async.parallelLimit(tasks, 5, function() end)
end

function GetLobbyPlayerIsIn(source)
	for key, lobby in pairs(Lobbies) do
		for _, player in pairs(lobby.players) do
			if player == source then
				return key
			end
		end
	end
	return nil
end

function BroadcastLobbyEvent(key, event, ...)
	for _, v in pairs(Lobbies[key].players) do
		if event ~= nil then
			TriggerClientEvent(event, v, ...)
		end
		TriggerClientEvent('ff_airsoft:lobby:update', v, Lobbies[key])
	end
end

RegisterCommand('airsoftleave', function(source, args)
	local _source = source
	if _source ~= 0 then
		local key = GetLobbyPlayerIsIn(_source)

		if key ~= nil and Lobbies[key] ~= nil then
			if Lobbies[key].started then
				for _, v in pairs(Lobbies[key].players) do
					if _source == v then
						DiscordLog('Left lobby.\nLobby ID: ' .. key .. '\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'Airsoft', 49151, '')
						table.remove(Lobbies[key].players, _)

						BroadcastLobbyEvent(key, 'ff_airsoft:notification', Translations[Translations.language].PlayerLeft, Framework.GetPlayerName(_source))
						ReturnPlayer(_source)
						TriggerClientEvent('ff_airsoft:lobby:update', _source, nil)

						Citizen.Wait(2500)

						if #Lobbies[key].players == 0 then
							LobbyEnd(key)
						end
					end
				end
			end
		end
	end
end)

RegisterCommand('airsoftmaintenance', function(source, arsg)
	if source == 0 then
		MaintenanceMode = not MaintenanceMode
		TriggerClientEvent('ff_airsoft:maintenance', -1, MaintenanceMode, DebugMode)
		if MaintenanceMode then
			print('[AIRSOFT] Maintenance mode is now enabled!')
		else
			print('[AIRSOFT] Maintenance mode is now disabled!')
		end
	end
end)

RegisterNetEvent('esx:playerLoaded', function(player)
	Citizen.Wait(50)

	MySQL.Async.fetchAll('SELECT inventory FROM `airsoft_inventory_data` WHERE identifier = @identifier LIMIT 1', {
		['identifier'] = GetLicense(player)
	}, function(res)
		local inventory = {}
		if #res == 1 then
			Framework.RestorePlayerInventory(player, json.decode(res[1]['inventory']))
			
			DiscordLog('Player receiving items back.\nIdentifier: ' .. GetLicense(player), 'Airsoft', 49151, '')
			TriggerClientEvent('ff_airsoft:return', player)
			Citizen.Wait(2500)
			
			RemoveAllPedWeapons(GetPlayerPed(player))
	
			MySQL.Async.execute('DELETE FROM `airsoft_inventory_data` WHERE identifier = @identifier', {
				['identifier'] = GetLicense(player)
			}, function() end)
	
			SetEntityCoords(GetPlayerPed(player), Config.LobbyMarker.Coords)
		end
	end)
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local key = GetLobbyPlayerIsIn(_source)

	if key ~= nil and Lobbies[key] ~= nil then
		for _, v in pairs(Lobbies[key].players) do
			if _source == v then
				table.remove(Lobbies[key].players, _)
				BroadcastLobbyEvent(key, 'ff_airsoft:notification', Translations[Translations.language].PlayerLeft, Framework.GetPlayerName(_source))
				DiscordLog('Player left during a game.\nUser: ' .. Framework.GetPlayerName(_source) .. '\nIdentifier: ' .. GetLicense(_source), 'Airsoft', 49151, '')

				Citizen.Wait(2500)

				if #Lobbies[key].players == 0 then
					LobbyEnd(key)
				end
			end
		end
	end
end)

function RandomLobbySpawn(key)
	math.randomseed(GetGameTimer())
	local spawnIdx = math.random(#Lobbies[key].availableSpawns)
	local spawn = Lobbies[key].availableSpawns[spawnIdx]
	table.remove(Lobbies[key].availableSpawns, spawnIdx)

	if #Lobbies[key].availableSpawns <= 0 then
		Lobbies[key].availableSpawns = table.keys(Config.Maps[Lobbies[key].map].Spawns)
	end
	
	return Config.Maps[Lobbies[key].map].Spawns[spawn]
end

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		LoadMapData()
	end
end)

function LoadMapData()
	local path = GetResourcePath(GetCurrentResourceName())
	path = path:gsub('//', '/') .. '/maps.json'
	local file = io.open(path, 'r')
	
	if file then
		local raw = file:read('*a')
		Config.Maps = json.decode(raw)
		CoordTableToVector(Config.Maps)
		TriggerClientEvent('ff_airsoft:maps', -1, Config.Maps)
	else
		Config.Maps = {}
	end
end

function CoordTableToVector(data)
	for k, v in pairs(data) do
		if type(v) == 'table' then
			if table.size(v) == 2 and v.x and v.y then
				data[k] = vector2(v.x, v.y)
			elseif table.size(v) == 3 and v.x and v.y and v.z then
				data[k] = vector3(v.x, v.y, v.z)
			else
				CoordTableToVector(v)
			end
		end
	end
end

function CreatePickup(coords, tier, key, amount, pickupType)
	if not Lobbies[key].Pickups then Lobbies[key].Pickups = {} end

	local pickup
	if pickupType then
		pickup = pickupType
	else
		pickup = Config.GameModes[Lobbies[key].gamemode].PickupTiers[tier][math.random(#Config.GameModes[Lobbies[key].gamemode].PickupTiers[tier])]
	end
	local entity = CreateObjectNoOffset(GetHashKey(Config.GameModes[Lobbies[key].gamemode].PickupModels[pickup]), coords.x, coords.y, coords.z, true, true, false)
	SetEntityRoutingBucket(entity, key)
	FreezeEntityPosition(entity, true)
	
	if tier == 1 then
		table.insert(Lobbies[key].Pickups, {
			entity = NetworkGetNetworkIdFromEntity(entity),
			ammo = pickup,
			tier = tier,
			amount = amount
		})
	elseif tier == 2 then
		if pickup:sub(1, 4) == "heal" then
			table.insert(Lobbies[key].Pickups, {
				entity = NetworkGetNetworkIdFromEntity(entity),
				health = tonumber(pickup:sub(5))
			})
		elseif pickup:sub(1, 4) == "body" then
			table.insert(Lobbies[key].Pickups, {
				entity = NetworkGetNetworkIdFromEntity(entity),
				armor = tonumber(pickup:sub(5))
			})
		end
	else
		table.insert(Lobbies[key].Pickups, {
			entity = NetworkGetNetworkIdFromEntity(entity),
			weapon = pickup,
			tier = tier
		})
	end
end

if DebugMode then
	RegisterNetEvent('polyzone:printPoly', function(obj)
		local _source = source
		TriggerClientEvent('ff_airsoft:debug:zone', _source, obj.points, obj.name)
	end)

	RegisterNetEvent('ff_airsoft:mapeditor:save', function(maps)
		local _source = source
		local path = GetResourcePath(GetCurrentResourceName())
		path = path:gsub('//', '/') .. '/maps.json'
		local file = io.open(path, 'w+')

		if file then
			Config.Maps = maps
			TriggerClientEvent('ff_airsoft:maps', -1, Config.Maps)
			local json = json.encode(maps)
			file:write(json)
			file:close()
		else
			print("UNABLE TO SAVE MAP DATA!")
			TriggerClientEvent('ff_airsoft:notification', source, 'ERROR SAVING MAPS')
		end
	end)
end

function DiscordLog(message, name, color, footer)
	if Config.Webhook == nil then
		do return end
	end
	local embed = {
		{
			['color'] = color,
			['title'] = '**'.. name ..'**',
			['description'] = message,
			['footer'] = {
				['text'] = footer,
			},
		}
	}
	
	PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Async = {}
function Async.parallelLimit(tasks, limit, cb)
	if #tasks == 0 then
		cb({})
		return
	end

	local remaining = #tasks
	local running   = 0
	local queue     = {}
	local results   = {}

	for i=1, #tasks, 1 do
		table.insert(queue, tasks[i])
	end

	local function processQueue()
		if #queue == 0 then
			return
		end

		while running < limit and #queue > 0 do
			local task = table.remove(queue, 1)
			running = running + 1

			task(function(result)
				table.insert(results, result)
				remaining = remaining - 1;
				running   = running - 1

				if remaining == 0 then
					cb(results)
				end
			end)
		end

		CreateThread(processQueue)
	end

	processQueue()
end
