-- RegisterCommand(Config.commandName, function(source, args, rawCommand) TriggerClientEvent("delall", -1) end, Config.restricCommand)
local ESX = exports['es_extended']:getSharedObject()
RegisterCommand(Config.commandName, function(source, args, rawCommand)
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then
    if source == 0 then
      TriggerClientEvent('delall', -1)
      return
    end
  end
  if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'hogerop' or xPlayer.getGroup() == 'owner' or source == 0 then
    TriggerClientEvent("delall", -1)
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(1800000)
    ExecuteCommand(Config.commandName)
  end
end)

function CleanUpCronTask(d, h, m)
  TriggerClientEvent("delall", -1)
end


if Config.alerts then
  TriggerEvent('cron:runAt', 0, 55, CleanUpCronTask) -- time to run
  TriggerEvent('cron:runAt', 1, 55, CleanUpCronTask)     
  TriggerEvent('cron:runAt', 2, 55, CleanUpCronTask)    
  TriggerEvent('cron:runAt', 3, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 4, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 5, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 6, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 7, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 8, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 9, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 10, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 11, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 12, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 13, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 14, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 15, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 16, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 17, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 18, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 19, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 20, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 21, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 22, 55, CleanUpCronTask)
  TriggerEvent('cron:runAt', 23, 55, CleanUpCronTask)
else
  TriggerEvent('cron:runAt', 0, 00, CleanUpCronTask) -- time to run
  TriggerEvent('cron:runAt', 1, 00, CleanUpCronTask)     
  TriggerEvent('cron:runAt', 2, 00, CleanUpCronTask)    
  TriggerEvent('cron:runAt', 3, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 4, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 5, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 6, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 7, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 8, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 9, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 10, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 11, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 12, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 13, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 14, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 15, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 16, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 17, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 18, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 19, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 20, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 21, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 22, 00, CleanUpCronTask)
  TriggerEvent('cron:runAt', 23, 00, CleanUpCronTask)
end