-- // [VARIABLES] \\ --

local Exios = { ['Functions'] = {}, ['Vehicles'] = {}, ['Peds'] = {} }
local inCardealer = false
local countdown = 0

-- // [ESX EVENTS] \\ --

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
    while not ESX.PlayerLoaded do Wait(0) end

    ESX.TriggerServerCallback('frp-luchtvaartdealer:server:cb:get:shared', function(data)
        Shared = data
    end)
    while not Shared do Wait(0) end

    Exios.Functions.SpawnShowroomBlips()
    Exios.Functions.SpawnPeds()

    while true do 
        local sleep = 750

        if IsPedInAnyVehicle(PlayerPedId(), false) then 
            local coords = GetEntityCoords(PlayerPedId())
            local dist = #(coords - Shared.QuickSell.coords)
            
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local props = ESX.Game.GetVehicleProperties(vehicle)
            local vehLabel = nil
            local model = type(props.model) == 'number' and props.model or joaat(props.model)
            local sellPercentage = Shared.QuickSell.sellPercentage
            local sellPrice = 0

            if dist <= 20.0 then 
                sleep = 0
                ESX.Game.Utils.DrawMarker(Shared.QuickSell.coords, 130, 23, 23)
                if dist <= 2.5 then 
                    for k,v in pairs(Shared.Vehicles) do 
                        for i=1, #Shared.Vehicles[k] do 
                            if joaat(Shared.Vehicles[k][i].model) == model then 
                                vehLabel = Shared.Vehicles[k][i].label
                                sellPrice = (Shared.Vehicles[k][i].price * sellPercentage)
                            end
                        end
                    end

                    exports['frp-interaction']:Interaction({r = 130, g = 23, b = 23}, '[E] - ' .. vehLabel .. ' verkopen voor €' .. ESX.Math.Round(sellPrice), Shared.QuickSell.coords, 2.5, GetCurrentResourceName() .. '-action-quicksell')
                
                    if IsControlJustReleased(0, 38) then
                        Exios.Functions.ConfirmQuickSellMenu(vehicle, vehLabel, sellPrice)
                    end
                end
            end
        end

        Wait(sleep)
    end
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

RegisterNetEvent('frp-luchtvaartdealer:client:open:catalogus')
AddEventHandler('frp-luchtvaartdealer:client:open:catalogus', function()
    local vehicles = {}
    for k, voertuigen in pairs(Shared.Vehicles) do 
        vehicles[k] = {}

        for i=1, #voertuigen do 
            local vehicle = voertuigen[i]

            table.insert(vehicles[k], {
                price = vehicle.price,
                model = vehicle.model,
                label = vehicle.label,
                voorraad = 999,

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

    ESX.TriggerServerCallback('frp-luchtvaartdealer:server:cb:buyVehicle', function(buyCallback, plateText)
        if not buyCallback then return end

        local vehicle = Shared.Vehicles[modelClass][modelId + 1]
        local spawnPlace
        if modelClass == 'helicopter' then
        for i=1, #Shared.HeliSpawnPlaces do
            if not ESX.Game.IsSpawnPointClear(Shared.HeliSpawnPlaces[i].coords, 1.5) then
                Wait(5000)
                spawnPlace = i
            else 
                spawnPlace = i
            end
            ESX.Game.SpawnVehicle(vehicle.model, Shared.HeliSpawnPlaces[spawnPlace].coords, Shared.HeliSpawnPlaces[spawnPlace].heading, function(veh)
                Exios.Functions.HandleCamera(Shared.HeliSpawnPlaces[spawnPlace].coords, Shared.HeliSpawnPlaces[spawnPlace].heading, veh)
                ESX.Game.SetVehicleProperties(veh, buyCallback)

                SendNUIMessage({
                    action = 'closeDealer'
                })

                SetVehicleNumberPlateText(veh, plateText)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                ESX.TriggerServerCallback('frp-luchtvaartdealer:server:saveVehicle', function(isDone)
                    if not isDone then return end
                end, modelClass, ESX.Math.Trim(ESX.Game.GetVehicleProperties(veh).plate), ESX.Game.GetVehicleProperties(veh), vehicle.model)
            end)
            return
        end
    else
        for i=1, #Shared.PlaneSpawnPlaces do
            if not ESX.Game.IsSpawnPointClear(Shared.PlaneSpawnPlaces[i].coords, 1.5) then
                Wait(5000)
                spawnPlace = i
            else 
                spawnPlace = i
            end
            ESX.Game.SpawnVehicle(vehicle.model, Shared.PlaneSpawnPlaces[spawnPlace].coords, Shared.PlaneSpawnPlaces[spawnPlace].heading, function(veh)
                Exios.Functions.HandleCamera(Shared.PlaneSpawnPlaces[spawnPlace].coords, Shared.PlaneSpawnPlaces[spawnPlace].heading, veh)
                ESX.Game.SetVehicleProperties(veh, buyCallback)

                SendNUIMessage({
                    action = 'closeDealer'
                })

                SetVehicleNumberPlateText(veh, plateText)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                ESX.TriggerServerCallback('frp-luchtvaartdealer:server:saveVehicle', function(isDone)
                    if not isDone then return end
                end, modelClass, ESX.Math.Trim(ESX.Game.GetVehicleProperties(veh).plate), ESX.Game.GetVehicleProperties(veh), vehicle.model)
            end)
            return
        end
    end
    end, modelClass, modelId, data.colour)
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
        id = 'frp-luchtvaartdealer:client:confirm:quickSell',
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

    lib.showContext('frp-luchtvaartdealer:client:confirm:quickSell')
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
                ESX.TriggerServerCallback('frp-luchtvaartdealer:server:cb:quickSell', function(bool)
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

            SetBlipSprite(blip, 580)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Luchtvaartdealer')
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
                event = 'frp-luchtvaartdealer:client:open:catalogus',
                label = 'Catalogus openen',
                icon = 'fas fa-plane-departure',
                distance = 2.5
            }
        })
    end
end

--[[Exios.Functions.SpawnShowroomVehicles = function()
    for i=1, #Shared.Showroom do 
        ESX.Game.SpawnLocalVehicle(Shared.Showroom[i]['model'], Shared.Showroom[i]['coords'], Shared.Showroom[i]['heading'], function(veh)
            Shared.Showroom[i]['vehicle'] = veh

            SetVehicleDirtLevel(Shared.Showroom[i]['vehicle'], 0)
            SetVehicleDoorsLockedForAllPlayers(Shared.Showroom[i]['vehicle'], true)
            SetVehicleDoorsLocked(Shared.Showroom[i]['vehicle'], 2)
            SetVehicleDoorOpen(Shared.Showroom[i]['vehicle'], 2, false, false)
            SetEntityInvincible(Shared.Showroom[i]['vehicle'], true)
            SetVehicleModColor_1(Shared.Showroom[i]['vehicle'],2,0,0)
            SetVehicleLivery(Shared.Showroom[i]['vehicle'],0)

            Wait(1000)
            FreezeEntityPosition(Shared.Showroom[i]['vehicle'], true)

            Exios.Vehicles[#Exios.Vehicles + 1] = Shared.Showroom[i]['vehicle']
        end)
    end
end ]]