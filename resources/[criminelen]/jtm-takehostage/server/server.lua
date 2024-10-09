ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('frp-takehostage:server:sync')
AddEventHandler('frp-takehostage:server:sync', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetPlayer = ESX.GetPlayerFromId(target)

	if xPlayer and targetPlayer then
		TriggerClientEvent('frp-takehostage:client:sync:target', targetPlayer.source, xPlayer.source)
	end
end)

RegisterServerEvent('frp-takehostage:server:release:hostage')
AddEventHandler('frp-takehostage:server:release:hostage', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetPlayer = ESX.GetPlayerFromId(target)

	if xPlayer and targetPlayer then
		TriggerClientEvent('frp-takehostage:client:release:hostage', targetPlayer.source)
		lib.notify(source, {
			title = 'Criminele acties',
			description = 'Je hebt je hostage succesvol losgelaten!',
			type = 'success'
		})
	end
end)

RegisterServerEvent('frp-takehostage:server:kill:hostage')
AddEventHandler('frp-takehostage:server:kill:hostage', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetPlayer = ESX.GetPlayerFromId(target)

	if xPlayer and targetPlayer then
		TriggerClientEvent('frp-takehostage:client:kill:hostage', targetPlayer.source)
		lib.notify(source, {
			title = 'Criminele acties',
			description = 'Je hebt je hostage succesvol afgemaakt!',
			type = 'success'
		})
	end
end)