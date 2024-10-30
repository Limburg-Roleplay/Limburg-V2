ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('lrp-takehostage:server:sync')
AddEventHandler('lrp-takehostage:server:sync', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetPlayer = ESX.GetPlayerFromId(target)

	if xPlayer and targetPlayer then
		TriggerClientEvent('lrp-takehostage:client:sync:target', targetPlayer.source, xPlayer.source)
	end
end)

RegisterServerEvent('lrp-takehostage:server:release:hostage')
AddEventHandler('lrp-takehostage:server:release:hostage', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetPlayer = ESX.GetPlayerFromId(target)

	if xPlayer and targetPlayer then
		TriggerClientEvent('lrp-takehostage:client:release:hostage', targetPlayer.source)
		lib.notify(source, {
			title = 'Criminele acties',
			description = 'Je hebt je hostage succesvol losgelaten!',
			type = 'success'
		})
	end
end)

RegisterServerEvent('lrp-takehostage:server:kill:hostage')
AddEventHandler('lrp-takehostage:server:kill:hostage', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local targetPlayer = ESX.GetPlayerFromId(target)

	if xPlayer and targetPlayer then
		TriggerClientEvent('lrp-takehostage:client:kill:hostage', targetPlayer.source)
		lib.notify(source, {
			title = 'Criminele acties',
			description = 'Je hebt je hostage succesvol afgemaakt!',
			type = 'success'
		})
	end
end)