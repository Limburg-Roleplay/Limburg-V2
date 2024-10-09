ESX.RegisterServerCallback('frp-uwvbureau:server:requestJobs', function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs WHERE whitelisted = 0')
	cb(result)
end)

RegisterServerEvent('frp-uwvbureau:server:join:job')
AddEventHandler('frp-uwvbureau:server:join:job', function(job)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.setJob(job.job, 0)
end)