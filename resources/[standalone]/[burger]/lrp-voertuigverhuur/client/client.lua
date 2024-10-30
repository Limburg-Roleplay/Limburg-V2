ESX = nil
LRP = {}
local rentedByPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    for i = 1, #Config.Locations do
        local blip = AddBlipForCoord(Config.Locations[i]['coords'])
        SetBlipHighDetail(blip, true)
        SetBlipSprite(blip, 348)
        SetBlipScale(blip, 0.75)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Voertuig Verhuur")
        EndTextCommandSetBlipName(blip)

        Config.Locations[i]['isRented'] = false
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

        for i = 1, #Config.Locations do
            local dist = #(coords - Config.Locations[i]['coords'])
            if dist <= 5.0 then
                sleep = 0
                local isRented = rentedByPlayers[ESX.GetPlayerData().identifier] == i
                local color = isRented and {255, 0, 0} or {0, 255, 0}
                ESX.Game.Utils.DrawMarker(Config.Locations[i]['coords'], 2, 0.2, 10, color[1], color[2], color[3])

                if dist < 2.5 then
                    if not IsPedInAnyVehicle(PlayerPedId(), false) then
                        exports['lrp-interaction']:Interaction('info', isRented and '[E] - Breng je voertuig terug' or '[E] - Huur een voertuig', Config.Locations[i]['coords'], 2.5, GetCurrentResourceName())
                        if IsControlJustReleased(0, 38) then
                            if not isRented then
                                LRP.OpenHireMenu(i)
                            else
                                LRP.BringBackVoertuig(i)
                            end
                        end
                    elseif isRented then
                        exports['lrp-interaction']:Interaction('info', '[E] - Breng je voertuig terug', Config.Locations[i]['coords'], 2.5, GetCurrentResourceName())
                        if IsControlJustReleased(0, 38) then
                            LRP.BringBackVoertuig(i)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

LRP.OpenHireMenu = function(i)
    if not LRPVehicles then
        ESX.TriggerServerCallback('lrp-voertuigverhuur:server:requestVehicles', function(vehiclesReturn)
            LRPVehicles = vehiclesReturn
        end)
    end

    while not LRPVehicles do Wait(0) end
    
    local options = {}

    for _, vehicle in pairs(LRPVehicles) do
        options[#options+1] = {
            title = vehicle.label,
            description = 'Kosten: $' .. vehicle.cost,
            serverEvent = 'lrp-voertuigverhuur:server:hireVehicle',
            args = { model = vehicle.model, cost = vehicle.cost, locationIndex = i }
        }
    end

    lib.registerContext({
        id = 'hire-vehicle-menu',
        title = 'Voertuig Verhuur',
        options = options
    })

    lib.showContext('hire-vehicle-menu')
end

LRP.HireVoertuig = function(i, model)
    local spawnLocations = Config.Locations[i]['spawnlocations']
    local vehicleSpawned = false

    for a = 1, #spawnLocations do
        if ESX.Game.IsSpawnPointClear(spawnLocations[a].coords, 1.5) then
            ESX.Game.SpawnVehicle(model, spawnLocations[a].coords, spawnLocations[a].heading, function(veh)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                vehicleSpawned = true
            end)
            break
        end
    end

    Citizen.SetTimeout(5000, function()
        if vehicleSpawned then
            local playerIdentifier = ESX.GetPlayerData().identifier
            rentedByPlayers[playerIdentifier] = i
        else
            exports['okokNotify']:Alert('Fout', 'Geen locatie beschikbaar voor het voertuig, probeer later opnieuw.', 5000, 'error')
        end
    end)
end

LRP.BringBackVoertuig = function(i)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)

    if veh then
        TaskLeaveVehicle(PlayerPedId(), veh, 256)
        ESX.Game.DeleteVehicle(veh, true)
        local playerIdentifier = ESX.GetPlayerData().identifier
        rentedByPlayers[playerIdentifier] = nil
        exports['okokNotify']:Alert('Succes', 'Je hebt het voertuig succesvol teruggebracht!', 5000, 'success')
    end
end

RegisterNetEvent('lrp-voertuigverhuur:spawnVehicle')
AddEventHandler('lrp-voertuigverhuur:spawnVehicle', function(model, locationIndex)
    LRP.HireVoertuig(locationIndex, model)
end)

LRP.RemoveVehicle = function(vehicle)
    if DoesEntityExist(vehicle) then
        ESX.Game.DeleteVehicle(vehicle, true)
    end
end
