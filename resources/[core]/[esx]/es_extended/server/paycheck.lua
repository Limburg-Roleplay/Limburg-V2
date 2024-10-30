function StartPayCheck()
	CreateThread(function()
		while true do
			Wait(Config.PaycheckInterval)
			local xPlayers = ESX.GetExtendedPlayers()
			for _, xPlayer in pairs(xPlayers) do
				local job     = xPlayer.job.grade_name
                local onDuty  = xPlayer.job.onDuty
				local salary  = xPlayer.job.grade_salary

				local job2     = xPlayer.job.grade_name
                local onDuty2  = xPlayer.job2.onDuty
				local salary2  = xPlayer.job2.grade_salary

				if salary > 0 then
					if job == 'unemployed' then
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_paycheck'), 5000, 'success')
						TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Info', _U('received_help', salary), 5000, 'info')
					elseif Config.EnableSocietyPayouts and onDuty then
						TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
							if society ~= nil then
								TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
									if account.money >= salary then 
										xPlayer.addAccountMoney('bank', salary)
										account.removeMoney(salary)
										TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_salary', salary), 5000, 'success')
									else
										TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Error', _U('company_nomoney'), 5000, 'error')
									end
								end)
							else 
								xPlayer.addAccountMoney('bank', salary)
								TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_salary', salary), 5000, 'success')
							end
						end)
					elseif onDuty then
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_salary', salary), 5000, 'success')
					end
				end

				if salary2 > 0 then
					if job2 == 'unemployed2' then 
						xPlayer.addAccountMoney('bank', salary2)
						TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_salary', salary2), 5000, 'success')
					elseif Config.EnableSocietyPayouts and onDuty then 
						TriggerEvent('esx_society:getSociety', xPlayer.job2.name, function (society)
							if society ~= nil then
								TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
									if account.money >= salary2 then
										xPlayer.addAccountMoney('bank', salary2)
										account.removeMoney(salary2)
										TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_salary', salary2), 5000, 'success')
									else
										TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Error', _U('company_nomoney'), 5000, 'error')
									end
								end)
							else 
								xPlayer.addAccountMoney('bank', salary2)
								TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_salary', salary2), 5000, 'success')
							end
						end)
					elseif onDuty2 then
						xPlayer.addAccountMoney('bank', salary2)
						TriggerClientEvent('okokNotify:Alert', xPlayer.source, 'Success', _U('received_salary', salary2), 5000, 'success')
					end
				end
			end
		end
	end)
end
