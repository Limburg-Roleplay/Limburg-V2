--local webhook = 'https://discord.com/api/webhooks/1108519931366101065/S596wUf7Oko_Y_4d_gq1hcbS8KXFbaHrVuUsgP0232tquRpbQ0b3BB9F7n8MxVFEBBBb'
ESX = exports["es_extended"]:getSharedObject()
RegisterServerEvent('frp-jobsmenu:server:toggleDuty')
AddEventHandler('frp-jobsmenu:server:toggleDuty', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    
    if (job == 'police' or job == 'ambulance' or job == 'mechanic')  or job == 'kmar' or job == 'pitstop' or job == 'advocaat' then
        xPlayer.setJob('off'..job, grade)
        TriggerClientEvent("frp-notifications:client:notify", _source, 'info', 'Je bent uitgeklokt als '.. xPlayer.job.label ..'')
	--exports['frp-logger']:createLog(webhook, 'Speler Uitgeklokt', '**Speler:** '..GetPlayerName(_source)..'\n**Baan:** '..xPlayer.job.label..'\n**Rang:** '..xPlayer.job.grade_label, false, 'Duty') 
    xPlayer.removeInventoryItem('WEAPON_STUNGUN', 1)
    xPlayer.removeInventoryItem('WEAPON_NIGHTSTICK', 1)
    xPlayer.removeInventoryItem('handcuffs', 2)
    xPlayer.removeInventoryItem('WEAPON_FLASHLIGHT', 1)
    xPlayer.removeInventoryItem('WEAPON_P99QNL', 1)
    xPlayer.removeInventoryItem('ammo-9', 50)
    xPlayer.removeInventoryItem('radio', 1)
    xPlayer.removeInventoryItem('WEAPON_FIREEXTINGUISHER', 1)
    elseif (job == 'offpolice') then
        xPlayer.setJob('police', grade)
        TriggerClientEvent("frp-notifications:client:notify", _source, 'success', 'Je bent ingeklokt als '.. xPlayer.job.label ..'')
	--exports['frp-logger']:createLog(webhook, 'Speler Ingeklokt', '**Speler:** '..GetPlayerName(_source)..'\n**Baan:** '..xPlayer.job.label..'\n**Rang:** '..xPlayer.job.grade_label, false, 'Duty') 
    elseif (job == 'offambulance') then
        xPlayer.setJob('ambulance', grade)
        TriggerClientEvent("frp-notifications:client:notify", _source, 'success', 'Je bent ingeklokt als '.. xPlayer.job.label ..'')
	--exports['frp-logger']:createLog(webhook, 'Speler Ingeklokt', '**Speler:** '..GetPlayerName(_source)..'\n**Baan:** '..xPlayer.job.label..'\n**Rang:** '..xPlayer.job.grade_label, false, 'Duty') 
    elseif (job == 'offmechanic') then
        xPlayer.setJob('mechanic', grade)
        TriggerClientEvent("frp-notifications:client:notify", _source, 'success', 'Je bent ingeklokt als '.. xPlayer.job.label ..'')
	--exports['frp-logger']:createLog(webhook, 'Speler Ingeklokt', '**Speler:** '..GetPlayerName(_source)..'\n**Baan:** '..xPlayer.job.label..'\n**Rang:** '..xPlayer.job.grade_label, false, 'Duty') 
    elseif (job == 'offkmar') then
    xPlayer.setJob('kmar', grade)
    TriggerClientEvent("frp-notifications:client:notify", _source, 'success', 'Je bent ingeklokt als '.. xPlayer.job.label ..'')
--exports['frp-logger']:createLog(webhook, 'Speler Ingeklokt', '**Speler:** '..GetPlayerName(_source)..'\n**Baan:** '..xPlayer.job.label..'\n**Rang:** '..xPlayer.job.grade_label, false, 'Duty') 
elseif (job == 'offpitstop') then
    xPlayer.setJob('pitstop', grade)
    TriggerClientEvent("frp-notifications:client:notify", _source, 'success', 'Je bent ingeklokt als '.. xPlayer.job.label ..'')
--exports['frp-logger']:createLog(webhook, 'Speler Ingeklokt', '**Speler:** '..GetPlayerName(_source)..'\n**Baan:** '..xPlayer.job.label..'\n**Rang:** '..xPlayer.job.grade_label, false, 'Duty') 
elseif (job == 'offadvocaat') then
    xPlayer.setJob('advocaat', grade)
    TriggerClientEvent("frp-notifications:client:notify", _source, 'success', 'Je bent ingeklokt als '.. xPlayer.job.label ..'')
--exports['frp-logger']:createLog(webhook, 'Speler Ingeklokt', '**Speler:** '..GetPlayerName(_source)..'\n**Baan:** '..xPlayer.job.label..'\n**Rang:** '..xPlayer.job.grade_label, false, 'Duty') 
end
end)