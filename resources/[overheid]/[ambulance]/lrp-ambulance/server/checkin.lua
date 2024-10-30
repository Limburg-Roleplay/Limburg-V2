RegisterNetEvent('lrp-ambulance:server:sendToBed', function(bedId, isRevive)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local response = MySQL.query.await('SELECT * FROM `users` WHERE `identifier` = ?', {
		xPlayer.getIdentifier()
	})

	TriggerClientEvent('lrp-ambulance:client:SendToBed', src, bedId, Config.CheckIn.beds[bedId], isRevive)
	TriggerClientEvent('lrp-ambulance:client:SetBed', -1, bedId, true)

	for i = 1, #response do
		if response[i]['zorgverzekering'] == 0 then
			xPlayer.removeAccountMoney("bank", Config.BillCost)
			TriggerClientEvent("lrp-notifications:client:notify", xPlayer.source, 'success',
				'Je hebt €' .. Config.BillCost .. ' betaald omdat je geen zorgverzekering hebt')
		else
			TriggerClientEvent("lrp-notifications:client:notify", xPlayer.source, 'success',
				'Je zorgverzekering dekt de kosten')
		end
	end
end)

RegisterNetEvent('lrp-ambulance:server:LeaveBed', function(id)
	TriggerClientEvent('lrp-ambulance:client:SetBed', -1, id, false)
end)
