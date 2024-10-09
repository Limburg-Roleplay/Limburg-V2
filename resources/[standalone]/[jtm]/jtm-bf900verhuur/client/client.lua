local ML = {}

Citizen.CreateThread(function()
    for i=1, #Config.Locations do
        local blip = AddBlipForCoord(Config.Locations[i]['coords'])

        SetBlipHighDetail(blip, true)
        SetBlipSprite (blip, 348)
        SetBlipScale  (blip, 0.75)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("sanchez verhuur")
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
            if dist <= 5.0 then
                sleep = 0
                ESX.Game.Utils.DrawMarker(Config.Locations[i]['coords'], 2, 0.2, 10, 78, 161)
                if dist < 2.5 and not IsPedInAnyVehicle(PlayerPedId(), false) then
                    exports['frp-interaction']:Interaction('info', '[E] - Huur een Sanchez', Config.Locations[i]['coords'], 2.5, GetCurrentResourceName())
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('frp-fietsverhuur:server:can:hire:fiets', function(bool)
                            if bool then
                                ML.Hirefiets(i)
                            end
                        end, i)
                    end
                elseif dist < 2.5 and IsPedInAnyVehicle(PlayerPedId(), false)  then
                    exports['frp-interaction']:Interaction('info', '[E] - Breng je Sanchez Terug', Config.Locations[i]['coords'], 2.5, GetCurrentResourceName())
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('frp-fietsverhuur:server:can:bringback:fiets', function(bool)
                            if bool then
                                ML.BringBackfiets(i)
                            end
                        end, i)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

ML.Hirefiets = function(i)
    local spawnLocations = Config.Locations[i]['spawnlocations']

    for a=1, #spawnLocations do
        if ESX.Game.IsSpawnPointClear(spawnLocations[a].coords, 1.5) then
            ESX.Game.SpawnVehicle(Config.Locations[i]["model"], spawnLocations[a].coords, spawnLocations[a].heading, function(veh)
                for i=1, 10 do
                    if i ~= 3 then
                        SetVehicleExtra(veh, i, false)
                    end
                end
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            end)
            return
            ESX.ShowNotification('success', 'Je hebt succesvol een Sanchez Gehuurd!')
        end
    end

    ESX.ShowNotification('error', 'Er is geen locatie beschikbaar voor een Sanchez, even geduld..')
    Citizen.SetTimeout(5000, function()
        ML.Hirefiets(i)
    end)
end

ML.BringBackfiets = function(i)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)

    if veh then
        TaskLeaveVehicle(PlayerPedId(), veh, 256)
        ESX.Game.DeleteVehicle(veh, true)
        ESX.ShowNotification('success', 'Je hebt je Sanchez succesvol terug gebracht!')
    end
end
