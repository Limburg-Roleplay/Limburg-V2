zESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('pizzapunt', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pizzapunt', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('bigmac', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bigmac', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

ESX.RegisterUsableItem('spablauw', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('spablauw', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('sandwich', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

ESX.RegisterUsableItem('cola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
end)

TriggerEvent('es:addGroupCommand', 'heal', 'admin', function(source, args, user)
	-- heal another player - don't heal source

	if not exports["ah-staffdienst"]:inDienst(source) then 
		return exports["ah-staffdienst"]:stuurBericht(source, "fa fa-exclamation-triangle", "Arnhem Staffdienst", "Je bent niet in dienst /staffdienst", {
            r = 219, 
            g = 72, 
            b = 72
        })
	end

	if args[1] then
		local _source = source
		local playerId = tonumber(args[1])
		local target = tonumber(args[1])
		-- is the argument a number?
		if playerId then
			-- is the number a valid player?
			if GetPlayerName(playerId) then
				TriggerClientEvent('esx_basicneeds:healPlayer', playerId)
				--TriggerClientEvent('chat:addMessage', source, { args = { '^1[^5STAFFPANEEL]', ' Speler is succesvol gehealed.' } })
				TriggerClientEvent('chat:addMessage', source, {
					template = '<div class="bubble-message"<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(76,131,170,0.7); border-radius: 5px;"><i class="fas fa-heartbeat"></i><b> Medisch:</b><br></span>{0}</span></div>',
					args = { 'Speler is succesvol gehealed' }
				})
				exports.JD_logsV3:createLog({
					EmbedMessage = "HEAL | " ..source.." Healed "..target.."",
					player_id = source,
					player_2_id = target,
					channel = "admin",
					screenshot = true
				})
			else
				TriggerClientEvent('chat:addMessage', source, {
					template = '<div class="bubble-message"<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(76,131,170,0.7); border-radius: 5px;"><i class="fas fa-heartbeat"></i><b> Medisch:</b><br></span>{0}</span></div>',
					args = { 'Speler is niet online' }
				})
			end
		else
				TriggerClientEvent('chat:addMessage', source, {
					template = '<div class="bubble-message"<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(76,131,170,0.7); border-radius: 5px;"><i class="fas fa-heartbeat"></i><b> Medisch:</b><br></span>{0}</span></div>',
					args = { 'Incorrect Speler ID' }
				})
		end
	else
		TriggerClientEvent('esx_basicneeds:healPlayer', source)
				TriggerClientEvent('chat:addMessage', source, {
					template = '<div class="bubble-message"<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(76,131,170,0.7); border-radius: 5px;"><i class="fas fa-heartbeat"></i><b> Medisch:</b><br></span>{0}</span></div>',
					args = { 'Je hebt jezelf succesvol gehealed' }
				})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^5[^5STAFFPANEEL]', 'Onvoldoende Permissies.' } })
end, {help = 'Heal jezelf of een andere speler.', params = {{name = 'playerId', help = 'Heal jezelf of een andere speler'}}})