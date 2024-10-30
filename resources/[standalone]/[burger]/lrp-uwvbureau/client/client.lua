local LRP = {}
local LRPJobs

Citizen.CreateThread(function()
    for i=1, #Config.Locations do
        local blip = AddBlipForCoord(Config.Locations[i]['coords'])

        SetBlipHighDetail(blip, true)
        SetBlipSprite (blip, 430)
        SetBlipScale  (blip, 0.75)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Uitzendbureau")
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
    ESX.PlayerData = PlayerData
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.SetPlayerData('job', Job)
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local coords = GetEntityCoords(PlayerPedId())

        for i=1, #Config.Locations do
            local dist = #(coords-Config.Locations[i]['coords'])
            if dist < 10 then
                sleep = 0
                ESX.Game.Utils.DrawMarker(Config.Locations[i].coords, 2, 0.2, 224, 148, 25)
                if dist < 2.5 then
                    exports['lrp-interaction']:Interaction('info', '[E] - Bekijk UWV banen', Config.Locations[i]['coords'], 2.5, GetCurrentResourceName())
                    if IsControlJustReleased(0, 38) then
                        LRP.OpenUWV()
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

LRP.OpenUWV = function()
    if not LRPJobs then
        ESX.TriggerServerCallback('lrp-uwvbureau:server:requestJobs', function(jobsReturn)
            LRPJobs = jobsReturn
        end)
    end
    
    while not LRPJobs do Wait(0) end
    
    local options = {}

    for k,v in pairs(LRPJobs) do
        options[#options+1] = {
            title = v.label,
            description = 'Neem deze baan!',
            serverEvent = 'lrp-uwvbureau:server:join:job',
            args = { job = v.name }
        }
    end

    lib.registerContext({
        id = 'uwv-menu',
        title = 'Limburg UWV',
        options = options
    })

    lib.showContext('uwv-menu')
end