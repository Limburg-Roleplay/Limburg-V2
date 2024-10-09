local Vehicles

RegisterServerEvent('esx_lscustom:buyMod')

AddEventHandler('esx_lscustom:buyMod', function(price)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    local bankMoney = xPlayer.getAccount('bank').money
    local neededAmount = price - playerMoney  -- Bereken het ontbrekende bedrag dat nodig is

    local vehicle = 'N/A'                          -- Voertuigmodel (moet worden ingevuld door de client)
    local plate = 'N/A'                            -- Kenteken (moet worden ingevuld door de client)
    local steamName = GetPlayerName(source)        -- Steam naam
    local steamId = 'STEAM:' .. GetPlayerIdentifier(source, 0)  -- Steam ID
    local playerName = xPlayer.getName()           -- In-game naam
    local rockstarLicense = 'N/A'                  -- Rockstar license (moet worden ingevuld door de client)
    local bankBalance = bankMoney                  -- Bankgeld van de speler
    local cashBalance = playerMoney                -- Cashgeld van de speler
    local dateTime = os.date('%Y-%m-%d %H:%M:%S')  -- Datum en tijd van de transactie
    local modName = 'N/A'                          -- Naam van de tuning mod (moet worden ingevuld door de client)

    if playerMoney >= price then
        -- Speler heeft voldoende contant geld
        TriggerClientEvent('esx_lscustom:installMod', source)
        TriggerClientEvent("frp-notifications:client:notify", source, 'success', 'Je hebt €'..price..' betaald voor je tuning.<br>Sla het voertuig op in je Garage!')
        xPlayer.removeMoney(price) -- Trek het geld rechtstreeks af van de speler
    elseif bankMoney >= neededAmount then
        -- Speler heeft onvoldoende contant geld maar genoeg op de bank
        TriggerClientEvent('esx_lscustom:installMod', source)
        TriggerClientEvent("frp-notifications:client:notify", source, 'success', 'Je hebt €'..price..' betaald voor je tuning.<br>Sla het voertuig op in je Garage!')
        xPlayer.removeAccountMoney('bank', neededAmount) -- Trek het ontbrekende bedrag van de bank af
    else
        -- Speler heeft onvoldoende geld
        TriggerClientEvent('esx_lscustom:cancelInstallMod', source)
        TriggerClientEvent("frp-notifications:client:notify", source, 'error', 'Je hebt niet genoeg geld voor deze mod!')
        
        -- Log de ontoereikende geldtransactie (optioneel)
        -- local logMessage = string.format('[CARDEALER LOGS] Speler %s (%s) heeft niet genoeg geld voor de mod van €%d.', playerName, steamId, price)
        -- TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263162977289240627/kn3IJRcEGnkF_8iqF5wTZ31HUog2-OxCYlnwxt3XQ4QWbeiI6AkpwYLomdCZAdM_bkF8', source, {
        --     title = "Cardealer Logs",
        --     desc = logMessage
        -- })
        return
    end

local function formatNumber(number)
    local formatted = tostring(number)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

-- Binnen de AddEventHandler-functie, waar je de logMessage samenstelt
local logMessage = string.format('[Tuning LOGS]\n' ..
                                'Speler: %s\n' ..
                                'Steam ID: %s\n' ..
                                'Betaald bedrag: €%s\n' ..  -- Hier wordt formatNumber gebruikt voor prijs
                                'Tuning mod: %s\n' ..
                                'Voertuig: %s\n' ..
                                'Kenteken: %s\n' ..
                                'Datum: %s\n' ..
                                'Bankgeld: €%s\n' ..         -- Hier wordt formatNumber gebruikt voor bankBalance
                                'Cashgeld: €%s',
                                playerName, steamId, formatNumber(price), modName, vehicle, plate, dateTime, formatNumber(bankBalance), formatNumber(cashBalance))

    TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1263170257758195832/F7AHVNQSAEEDEzWCMG-MV27TIF8WMhwnxmns24Kap_eMp1lhgXzdezIPBnLx8PQxprCd', source, {
        title = "Tuning Logs",
        desc = logMessage
    })
end)



RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.single('SELECT vehicle FROM owned_vehicles WHERE plate = ?', {vehicleProps.plate},
	function(result)
		if result then
			local vehicle = json.decode(result.vehicle)

			if vehicleProps.model == vehicle.model then
				MySQL.update('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', {json.encode(vehicleProps), vehicleProps.plate})
			else
				print(('esx_lscustom: %s attempted to upgrade vehicle with mismatching vehicle model!'):format(xPlayer.identifier))
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		Vehicles = MySQL.query.await('SELECT model, price FROM vehicles')
	end
	cb(Vehicles)
end)