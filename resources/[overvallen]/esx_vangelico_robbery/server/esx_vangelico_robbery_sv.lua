local rob = false
local robbers = {}
PlayersCrafting    = {}
local CopsConnected  = 0
ESX = exports["es_extended"]:getSharedObject()

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

function CountCops()
	local xPlayers = ESX.GetPlayers()
	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		end
	end

	SetTimeout(180 * 1000, CountCops)
end

CountCops()

RegisterServerEvent('esx_vangelico_robbery:toofar')
AddEventHandler('esx_vangelico_robbery:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' or xPlayer.job.name == 'kmar' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled_at') .. Stores[robb].nameofstore)
			TriggerClientEvent('esx_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('esx_vangelico_robbery:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_cancelled') .. Stores[robb].nameofstore)
	end
end)

RegisterServerEvent('esx_vangelico_robbery:endrob')
AddEventHandler('esx_vangelico_robbery:endrob', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' or xPlayer.job.name == 'kmar' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('end'))
			TriggerClientEvent('esx_vangelico_robbery:killblip', xPlayers[i])
		end
	end
	if(robbers[source])then
		TriggerClientEvent('esx_vangelico_robbery:robberycomplete', source)
		robbers[source] = nil
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_ended') .. Stores[robb].nameofstore)
	end
end)

RegisterServerEvent('esx_vangelico_robbery:rob')
AddEventHandler('esx_vangelico_robbery:rob', function(robb)

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.SecBetwNextRob and store.lastrobbed ~= 0 then

            TriggerClientEvent('esx_vangelico_robbery:togliblip', source)
			TriggerClientEvent('esx:showNotification', source, _U('already_robbed') .. (Config.SecBetwNextRob - (os.time() - store.lastrobbed)) .. _U('seconds'))
			return
		end

		if rob == false then

			rob = true
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer.job.name == 'police' or xPlayer.job.name == 'kmar' then
					TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog') .. store.nameofstore)
					TriggerClientEvent('esx_vangelico_robbery:setblip', xPlayers[i], Stores[robb].position)
				end
			end

			TriggerClientEvent('esx:showNotification', source, _U('started_to_rob') .. store.nameofstore .. _U('do_not_move'))
			TriggerClientEvent('esx:showNotification', source, _U('alarm_triggered'))
			TriggerClientEvent('esx:showNotification', source, _U('hold_pos'))
			TriggerClientEvent('esx_vangelico_robbery:currentlyrobbing', source, robb)
            CancelEvent()
			Stores[robb].lastrobbed = os.time()
		else
			TriggerClientEvent('esx:showNotification', source, _U('robbery_already'))
		end
	end
end)

RegisterServerEvent('esx_vangelico_robbery:gioielli')
AddEventHandler('esx_vangelico_robbery:gioielli', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem('jewels', math.random(Config.MinJewels, Config.MaxJewels)) 
end)

RegisterServerEvent('lester:vendita')
AddEventHandler('lester:vendita', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if IsPlayerNearSell(xPlayer) then
        local jewelsCount = xPlayer.getInventoryItem('jewels').count

        if jewelsCount >= Config.MaxJewelsSell then
            local reward = math.floor(Config.PriceForOneJewel * Config.MaxJewelsSell)

            TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1286311956273299489/crJI5HvDBSSLbzaQOLR3Um26WD5GcA7-aVd4XXK352P-Bh7P3yIt0je8efilotYZu1rX', source, {
                title = GetPlayerName(source) .. " heeft zojuist " .. Config.MaxJewelsSell .. " juwelen verkocht voor " .. reward .. " euro.",
                desc = GetPlayerName(source) .. " heeft zojuist " .. Config.MaxJewelsSell .. " juwelen verkocht voor " .. reward .. " euro."
            }, 0x000001)

            xPlayer.removeInventoryItem('jewels', Config.MaxJewelsSell)

            xPlayer.addMoney(reward)
        else
            TriggerClientEvent('okokNotify:Alert', _source, "Error", "Je hebt niet genoeg juwelen om te verkopen.", 5000, 'error')
        end
    else
        exports["FIVEGUARD"]:screenshotPlayer(source, function(url)
            print("got url of screenshot: ".. url .." from player: "..source)
        end)
        
        return exports["FIVEGUARD"]:fg_BanPlayer(source, "Suspicious activity detected: Player ID " .. source .. " tried to trigger lester:vendita without validation.", true)
    end
end)


function IsPlayerNearSell(xPlayer)
    local playerPed = GetPlayerPed(xPlayer.source) -- Get the player's ped
    local playerCoords = GetEntityCoords(playerPed) -- Get the player's current coordinates

    local cashPileCoords = vector3(706.669, -966.898, 30.413)

    local distance = #(playerCoords - cashPileCoords) -- Calculate the distance between the player and the cash pile

    return distance <= 20.0 -- Return true if within 20 units, false otherwise
end
ESX.RegisterServerCallback('esx_vangelico_robbery:conteggio', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(CopsConnected)
end)