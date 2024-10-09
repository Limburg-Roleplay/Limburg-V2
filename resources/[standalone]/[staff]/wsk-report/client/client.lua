local WSK = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true

	Wait(10000)

	TriggerServerEvent('wsk-report:server:joined:player')
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
end)

RegisterNetEvent('wsk-report:client:see:report:list')
AddEventHandler('wsk-report:client:see:report:list', function()
	SetNuiFocus(true, true)

	SendNUIMessage({
		type = 'seeReportList',
	})
end)

RegisterNetEvent('wsk-report:client:new:report')
AddEventHandler('wsk-report:client:new:report', function(steamName, reportId, msg, src, time, claimed)
	SendNUIMessage({
		type = 'newReport',
		data = {
			steamName = steamName,
			reportId = reportId,
			playerId = src,
			msg = msg,
			time = time
		}
	})

	if claimed then
		SendNUIMessage({
			type = 'claimReport',
			data = {
				reportId = reportId,
				claimedReport = ESX.PlayerData.identifier == claimed or false
			}
		})
	end
end)

RegisterNetEvent('wsk-report:client:claimed:report')
AddEventHandler('wsk-report:client:claimed:report', function(reportId, identifier)
	SendNUIMessage({
		type = 'claimReport',
		data = {
			reportId = reportId,
			claimedReport = ESX.PlayerData.identifier == identifier or false
		}
	})
end)

RegisterNetEvent('wsk-report:client:closed:report')
AddEventHandler('wsk-report:client:closed:report', function(reportId)
	SendNUIMessage({
		type = 'closeReport',
		data = {
			reportId = reportId,
		}
	})
end)

RegisterNUICallback('closeReports', function(data)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('claimReport', function(data)
	TriggerServerEvent('wsk-report:server:claim:report', tonumber(data.reportId))
end)

RegisterNUICallback('closeReport', function(data)
	TriggerServerEvent('wsk-report:server:close:report', tonumber(data.reportId))
end)

RegisterNUICallback('closeReportInstant', function(data)
	TriggerServerEvent('wsk-report:server:close:instant:report', tonumber(data.reportId))
end)