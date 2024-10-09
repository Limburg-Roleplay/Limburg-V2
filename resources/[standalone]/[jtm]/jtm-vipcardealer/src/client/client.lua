-- // [VARIABLES] \\ --

local Exios = { ['Functions'] = {}, ['Vehicles'] = {}, ['Peds'] = {} }
local inCardealer = false
local countdown = 0

function getVehicleMaxSpeed(model)
    if model == nil then
        if Config and Config.Test then
            for key, value in pairs(Config.Test) do
                print(key .. ": " .. value)
            end
        end
        return 20
    end

    local modelName = string.lower(model)

    if Config and Config.SpeedLimit and Config.SpeedLimit[modelName] and Config.SpeedLimit[modelName].speed then
        return Config.SpeedLimit[modelName].speed
    else
        print("Model niet gevonden in Config.SpeedLimit: " .. modelName)
    end

    return 200
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
end)

-- // [THREADS] \\ --

CreateThread(function()
    -- Wait until the ESX player is loaded
    while not ESX.PlayerLoaded do 
        Wait(0) 
    end

    -- Retrieve shared data from the server
    ESX.TriggerServerCallback('jtm-vipcardealer:server:cb:get:shared', function(data)
        Shared = data
    end)

    -- Wait until the shared data is retrieved
    while not Shared do 
        Wait(0) 
    end

    -- Execute functions once all conditions are met
    Exios.Functions.SpawnShowroomBlips()
    Exios.Functions.SpawnPeds()
    Exios.Functions.SpawnShowroomVehicles()
end)


-- // [FIVEM EVENTS] \\ --

AddEventHandler('onResourceStop', function(resource)
	if resource ~= GetCurrentResourceName() then return end
    
    if Exios.Vehicles then 
        for _,v in pairs(Exios.Vehicles) do 
            DeleteVehicle(v) 
        end
    end

    if Exios.Peds then 
        for _,v in pairs(Exios.Peds) do 
            DeletePed(v) 
        end
    end
end)

-- // [EVENTS] \\ --

RegisterNetEvent('jtm-development:client:open:catalogus')
AddEventHandler('jtm-development:client:open:catalogus', function()
    local vehicles = {}
    for k, voertuigen in pairs(Shared.Vehicles) do 
        vehicles[k] = {}

        for i=1, #voertuigen do 
            local vehicle = voertuigen[i]
            local maxSpeed = getVehicleMaxSpeed(model)

            table.insert(vehicles[k], {
                price = vehicle.price,
                model = vehicle.model,
                label = vehicle.label,

                vehicleConfig = {
                    maxSpeed = maxSpeed and maxSpeed or 'N.v.t.',
                    seats = GetVehicleModelNumberOfSeats(GetHashKey(vehicle.model)),
                    trunkSpace = vehicle.trunkSpace,
                    horsePower = vehicle.horsePower,
                }
            })
        end
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openDealer',
        vehicles = vehicles,
    })
end)

-- // [NUI CALLBACKS] \\ --

RegisterNUICallback('buyVehicle', function(data, cb)
    local modelId = data.vehicleData.model
    local modelClass = data.vehicleData.class

    -- Check if the player has the required permissions
    if exports["discordperms"]:hasvipcardealergroup() then
        print("Done")

        ESX.TriggerServerCallback('jtm-development:server:cb:buyVehicle', function(buyCallback, plateText)
            if not buyCallback then
                return
            end

            local vehicle = Shared.Vehicles[modelClass][modelId + 1]
            local spawnPlace = nil

            -- Find a clear spawn point
            for i=1, #Shared.SpawnPlaces do
                if ESX.Game.IsSpawnPointClear(Shared.SpawnPlaces[i].coords, 1.5) then
                    spawnPlace = i
                    break
                end
            end

            -- If a spawn point was found
            if spawnPlace then
                ESX.Game.SpawnVehicle(vehicle.model, Shared.SpawnPlaces[spawnPlace].coords, Shared.SpawnPlaces[spawnPlace].heading, function(veh)
                    Exios.Functions.HandleCamera(Shared.SpawnPlaces[spawnPlace].coords, Shared.SpawnPlaces[spawnPlace].heading, veh)
                    ESX.Game.SetVehicleProperties(veh, buyCallback)

                    -- Close the dealer NUI
                    SendNUIMessage({
                        action = 'closeDealer'
                    })

                    -- Set vehicle properties
                    SetVehicleNumberPlateText(veh, plateText)
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)

                    -- Save the vehicle on the server
                    ESX.TriggerServerCallback('jtm-development:server:saveVehicle', function(isDone)
                        if not isDone then
                            return
                        end
                    end, ESX.Math.Trim(ESX.Game.GetVehicleProperties(veh).plate), ESX.Game.GetVehicleProperties(veh), vehicle.model)
                end)
            else
                print("No available spawn point found!")
            end
        end, modelClass, modelId, data.colour)
    else
        ESX.ShowNotification('error', 'Je bent geen Vip. Als je dit wel wilt worden maak dan een ticket aan in onze support discord!')
    end
end)


RegisterNUICallback('closeDealer', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('testDriveVehicle', function(data, cb)
    startTestDrive(data.vehicleData)
end)

-- // [FUNCTIONS] \\ --

local cachedData = {}
Exios.Functions.HandleCamera = function(garagePos, heading, vehicle, toggle)
    if not garagePos then return end

	if cachedData['cam'] then
		DestroyCam(cachedData['cam'])
	end
	cachedData['cam'] = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

	SetCamCoord(cachedData['cam'], garagePos.x, garagePos.y, garagePos.z+2)
	SetCamRot(cachedData['cam'], 0, 0, heading)
	SetCamNearDof(cachedData['cam'] , 0)
	SetCamActive(cachedData['cam'], true)

	RenderScriptCams(1, 1, 750, 1, 1)

	Citizen.SetTimeout(500, function()
        SetGameplayCamRelativeHeading(0.0)
        RenderScriptCams(0, 1, 250, 1, 1)
    end)
end

Exios.Functions.ConfirmQuickSellMenu = function(vehicle, vehLabel, sellPrice)
    local plate = GetVehicleNumberPlateText(vehicle)

    lib.registerContext({
        id = 'exios-vehicleshop:client:confirm:quickSell',
        title = 'Weet je zeker dat je je ' .. vehLabel .. ' wilt verkopen voor €' .. sellPrice .. '?',
        options = {
            {
                title = 'Ja, ik weet het zeker',
                onSelect = function()
                    if countdown <= 0 then 
                        lib.hideContext(false)
                        Exios.Functions.StartCountingDown()
                        Exios.Functions.ConfirmedQuickSell()
                    else 
                        lib.hideContext(false)
                        ESX.ShowNotification('Wacht nog ' .. countdown .. ' seconden voordat je weer een voertuig kan verkopen..')
                    end
                end
            },
            {
				title = 'Nee, alsjeblieft niet!',
				onSelect = function()
					lib.hideContext(false)
				end
			}
        }
    })

    lib.showContext('exios-vehicleshop:client:confirm:quickSell')
end

Exios.Functions.ConfirmedQuickSell = function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    local pedInVehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    local currentVehicle = GetEntityModel(pedInVehicle)
    local plate = GetVehicleNumberPlateText(pedInVehicle)
    local vehicles = {}

    for k,v in pairs(Shared.Vehicles) do 
        vehicles[k] = {}
        for i=1, #v do 
            local veh = v[i]
            local model = veh.model
            if GetHashKey(model) == currentVehicle then 
                ESX.TriggerServerCallback('exios-vehicleshop:server:cb:quickSell', function(bool)
                    if bool then 
                        ESX.Game.DeleteVehicle(vehhhh, true)
                    else 
                        ESX.ShowNotification('error', 'Er is iets fouts gegaan, probeer het opnieuw!')
                    end
                end, ESX.Math.Trim(plate), ESX.Game.GetVehicleProperties(pedInVehicle))
            end
        end
    end
end

Exios.Functions.StartCountingDown = function()
    running = true
    countdown = 30
    CreateThread(function()
        while countdown > 0 do
            Wait(1000)
            countdown = countdown - 1
        end
        running = false
    end)
end

Exios.Functions.LoadModel = function(model)
    if not IsModelValid(model) then return end

	RequestModel(joaat(model))
	while not HasModelLoaded(joaat(model)) do
		Wait(5)
	end
end

Exios.Functions.SpawnShowroomBlips = function()
    for i=1, #Shared.Locations do 
        if Shared.Locations[i]['blip'] then 
            local blip = AddBlipForCoord(Shared.Locations[i]['coords'])

            SetBlipSprite(blip, 523)
            SetBlipScale(blip, 0.6)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Vip Cardealer')
            EndTextCommandSetBlipName(blip)
        end
    end
end

Exios.Functions.SpawnPeds = function()
    Exios.Functions.LoadModel(`a_m_y_smartcaspat_01`)
    for i=1, #Shared.Locations do 
        Shared.Locations[i]['ped'] = CreatePed(4, `a_m_y_smartcaspat_01`, Shared.Locations[i]['coords']['x'], Shared.Locations[i]['coords']['y'], Shared.Locations[i]['coords']['z'] - 1.0, Shared.Locations[i]['coords']['w'], false, false)

        SetPedDiesWhenInjured(Shared.Locations[i]['ped'], true)
        SetEntityInvincible(Shared.Locations[i]['ped'], true)
        FreezeEntityPosition(Shared.Locations[i]['ped'], true)
        SetPedRelationshipGroupHash(Shared.Locations[i]['ped'], 'MISSION8')
        SetRelationshipBetweenGroups(0, 'MISSION8', 'PLExiosER')
        SetBlockingOfNonTemporaryEvents(Shared.Locations[i]['ped'], true)

        Exios.Peds[#Exios.Peds + 1] = Shared.Locations[i]['ped']

        exports.ox_target:addLocalEntity(Shared.Locations[i]['ped'], {
            {
                event = 'jtm-development:client:open:catalogus',
                label = 'Open catalogus',
                icon = 'fas fa-car',
                distance = 3.5
            }
        })
    end
end

Exios.Functions.SpawnShowroomVehicles = function()
    for i=1, #Shared.Showroom do 
        ESX.Game.SpawnLocalVehicle(Shared.Showroom[i]['model'], Shared.Showroom[i]['coords'], Shared.Showroom[i]['heading'], function(veh)
            Shared.Showroom[i]['vehicle'] = veh

            SetVehicleDirtLevel(Shared.Showroom[i]['vehicle'], 0)
            SetVehicleDoorsLockedForAllPlayers(Shared.Showroom[i]['vehicle'], true)
            SetVehicleDoorsLocked(Shared.Showroom[i]['vehicle'], 2)

            Wait(1000)
            FreezeEntityPosition(Shared.Showroom[i]['vehicle'], true)

            Exios.Vehicles[#Exios.Vehicles + 1] = Shared.Showroom[i]['vehicle']
        end)
    end
end