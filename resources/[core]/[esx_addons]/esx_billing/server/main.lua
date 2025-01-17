ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount        = ESX.Math.Round(amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)

		if amount < 0 then
			print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
		elseif account == nil then

			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target']      = xPlayer.identifier,
					['@label']       = label,
					['@amount']      = amount
				}, function(rowsChanged)
					TriggerClientEvent('okokNotify:Alert', xTarget.source, _U('received_invoice'), 5000, 'info')
				end)
			end

		else

			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target']      = sharedAccountName,
					['@label']       = label,
					['@amount']      = amount
				}, function(rowsChanged)
					TriggerClientEvent('okokNotify:Alert', xTarget.source, _U('received_invoice'), 5000, 'info')
				end)
			end

		end
	end)

end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)


ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)
    local bankMoney = xPlayer.getAccount('bank').money

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)

		local sender     = result[1].sender
		local targetType = result[1].target_type
		local target     = result[1].target
		local amount     = result[1].amount

		local xTarget = ESX.GetPlayerFromIdentifier(sender)

		if targetType == 'player' then

			if xTarget ~= nil then

				if xPlayer.getMoney() >= amount then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeMoney(amount)
						xTarget.addMoney(amount)

						TriggerClientEvent('okokNotify:Alert', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)), 5000, 'success')
						TriggerClientEvent('okokNotify:Alert', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)), 5000, 'success')

						cb()
					end)

				elseif bankMoney >= amount then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						xTarget.addAccountMoney('bank', amount)

						TriggerClientEvent('okokNotify:Alert', xPlayer.source, _U('paid_invoice', ESX.Math.GroupDigits(amount)), 5000, 'success')
						TriggerClientEvent('okokNotify:Alert', xTarget.source, _U('received_payment', ESX.Math.GroupDigits(amount)), 5000, 'success')

						cb()
					end)

				else
					TriggerClientEvent('okokNotify:Alert', xPlayer.source, _U('no_money'), 5000, 'error')
					TriggerClientEvent('okokNotify:Alert', xTarget.source, _U('target_no_money'), 5000, 'error')

					cb()
				end

			else
				TriggerClientEvent('okokNotify:Alert', xPlayer.source, _U('player_not_online'), 5000, 'error')
				cb()
			end

		else

			TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)

				if xPlayer.getMoney() >= amount then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeMoney(amount)
						account.addMoney(amount)

TriggerClientEvent("lrp-notifications:client:notify", xPlayer.source, "success", "Je hebt je factuur afbetaald en er is " .. ESX.Math.GroupDigits(amount) .. " uit je broekzakken gehaald!", 3000)
						if xTarget ~= nil then
TriggerClientEvent("lrp-notifications:client:notify", xTarget.source, "success", "Je factuur is van " .. ESX.Math.GroupDigits(amount) "is betaald", 3000)
						end

						cb()
					end)

				elseif bankMoney >= amount then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeAccountMoney('bank', amount)
						account.addMoney(amount)

TriggerClientEvent("lrp-notifications:client:notify", xPlayer.source, "success", "Je hebt je factuur afbetaald en er is " .. ESX.Math.GroupDigits(amount) .. " van je rekening afgeschreven", 3000)

						if xTarget ~= nil then
TriggerClientEvent("lrp-notifications:client:notify", xTarget.source, "success", "Je factuur is van " .. ESX.Math.GroupDigits(amount) "is betaald", 3000)
						end

						cb()
					end)

				else
                    TriggerClientEvent("lrp-notifications:client:notify", source, "error", "Je hebt niet genoeg geld!", 3000)

					if xTarget ~= nil then
                   TriggerClientEvent("lrp-notifications:client:notify", xTarget.source, "error", "De persoon die je factuur probeert te betalen heeft niet genoeg geld!", 3000)
					end

					cb()
				end
			end)

		end

	end)
end)