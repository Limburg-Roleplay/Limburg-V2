local playersProcessingCannabis = {}
local outofbound = true
local alive = true

RegisterServerEvent('esx_drugs:outofbound')
AddEventHandler('esx_drugs:outofbound', function()
	outofbound = true
end)


playersProcessingMETH = playersProcessingMETH or {}

RegisterServerEvent('jtm-drugsverpak:processMETH')
AddEventHandler('jtm-drugsverpak:processMETH', function()
	if not playersProcessingMETH[source] then
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xMETH = xPlayer.getInventoryItem('meth')
		
		local removeCount = math.random(5, 20)
		local addCount = math.random(4, 10)
        local initialCount = xMETH.count
        local finalCount = initialCount - removeCount + addCount

        local steamName = GetPlayerName(source)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.getIdentifier()
        local bankMoney = formatNumber(xPlayer.getAccount('bank').money)
        local cashMoney = formatNumber(xPlayer.getMoney())
        local rockstarLicense = xPlayer.getIdentifier('license')
        local purchaseTime = os.date('%Y-%m-%d %H:%M:%S') 

        local logMessage = string.format(
            "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Naam: %s\nSteam ID: %s\nRockstar License: %s\nBank: %s\nCash: %s\nHoeveelheid voor Verpakken: %d\nHoeveelheid na Verpakken: %d",
            purchaseTime, steamName, playerName, steamID, rockstarLicense, bankMoney, cashMoney, initialCount, finalCount
        )

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263508226985558038/23-eROvlU-su5K-VQy5Po80UOy3fJSqrTzVPenVmEV7ArWlRUv7G3_iSCBiqzjfqySzF', source, {
            title = "METH Processing Logs",
            desc = logMessage
        })
		
		if xMETH.count >= removeCount then
			if xPlayer.canSwapItem('meth', removeCount, 'methzakje', addCount) then
				xPlayer.removeInventoryItem('meth', removeCount)
				xPlayer.addInventoryItem('methzakje', addCount)
			else
				TriggerEvent('esx_drugs:cancelProcessing')
			end
		else
			TriggerEvent('esx_drugs:cancelProcessing')
		end
		
		playersProcessingMETH[source] = nil
	else
		print(('JTM-Drugsverpak: %s Probeerd METH Te Triggeren!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

playersProcessingGHB = playersProcessingGHB or {}

RegisterServerEvent('jtm-drugsverpak:processGHB')
AddEventHandler('jtm-drugsverpak:processGHB', function()
	if not playersProcessingGHB[source] then
		local source = source
		local xPlayer = ESX.GetPlayerFromId(source)
		local xGHB = xPlayer.getInventoryItem('ghb_ton')
		
		local removeCount = math.random(5, 20)
		local addCount = math.random(4, 10)
        local initialCount = xGHB.count
        local finalCount = initialCount - removeCount + addCount

        local steamName = GetPlayerName(source)
        local playerName = xPlayer.getName()
        local steamID = xPlayer.getIdentifier()
        local bankMoney = formatNumber(xPlayer.getAccount('bank').money)
        local cashMoney = formatNumber(xPlayer.getMoney())
        local rockstarLicense = xPlayer.getIdentifier('license')
        local purchaseTime = os.date('%Y-%m-%d %H:%M:%S') 

        local logMessage = string.format(
            "Tijd en Datum: %s\nSteam Naam: %s\nIn-game Naam: %s\nSteam ID: %s\nRockstar License: %s\nBank: %s\nCash: %s\nHoeveelheid voor Verpakken: %d\nHoeveelheid na Verpakken: %d",
            purchaseTime, steamName, playerName, steamID, rockstarLicense, bankMoney, cashMoney, initialCount, finalCount
        )

        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263508067920777318/yU2RDzE_DSJUo-K86T6IjHu0p9zzJC44cKjPWThpsqYViH1KMnVxkhVXwOKl_X8L-qkJ', source, {
            title = "GHB Processing Logs",
            desc = logMessage
        })
		
		if xGHB.count >= removeCount then
			if xPlayer.canSwapItem('ghb_ton', removeCount, 'ghb', addCount) then
				xPlayer.removeInventoryItem('ghb_ton', removeCount)
				xPlayer.addInventoryItem('ghb', addCount)
			else
				TriggerEvent('esx_drugs:cancelProcessing')
			end
		else
			TriggerEvent('esx_drugs:cancelProcessing')
		end
		
		playersProcessingGHB[source] = nil
	else
		print(('JTM-Drugsverpak: %s Probeerd GHB Te Triggeren!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function formatNumber(number)
    local formatted = number
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end



function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ESX.ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('esx_drugs:cancelProcessing')
AddEventHandler('esx_drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
