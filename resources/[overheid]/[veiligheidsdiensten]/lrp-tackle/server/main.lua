ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('esx_kekke_tackle:tryTackle')
AddEventHandler('esx_kekke_tackle:tryTackle', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('esx_kekke_tackle:getTackled', targetPlayer.source, source)
	TriggerClientEvent('esx_kekke_tackle:playTackle', source)
end)