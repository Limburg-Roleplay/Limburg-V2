ESX.RegisterServerCallback('lrp-uwvbureau:server:requestJobs', function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs WHERE whitelisted = 0')
	cb(result)
end)

RegisterServerEvent('lrp-uwvbureau:server:join:job')
AddEventHandler('lrp-uwvbureau:server:join:job', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.setJob2(job.job, 0)
end)