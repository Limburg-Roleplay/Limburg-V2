-- // [VARIABLES] \\ --

inTestrit = false 
testritVehicle = false

-- // [FUNCTIONS] \\ --

startTestDrive = function(vehicle)
    SendNUIMessage({action = 'closeDealer'})

    local ped = PlayerPedId()
    spawnPoints = Shared.TestritSpawns

    for i = 1, #spawnPoints, 1 do
        local location = spawnPoints[i]
        
		if ESX.Game.IsSpawnPointClear(location.coords, 3.0) then            
            DoScreenFadeOut(750)

            while not IsScreenFadedOut() do
                Wait(0)
            end

            NetworkSetPlayerIsPassive(true)

            SetEntityCoords(ped, location.coords)

            ESX.Game.SpawnVehicle(vehicle.model, location.coords, location.heading, function(veh)
                TaskWarpPedIntoVehicle(ped, veh, -1)
                SetVehicleNumberPlateText(veh, 'Testrit')
                SetVehicleDoorsLocked(veh, 2)

                testritVehicle = veh
                inTestrit = true

                lib.notify({ description = 'Je mag de ' .. vehicle.label .. ' testritten voor 2min.', type = 'inform' })

                DoScreenFadeIn(750)

                while not IsPedInAnyVehicle(PlayerPedId(), false) do
                    Wait(0)
                end

                Citizen.CreateThread(function()
                    while inTestrit do 
                        SendNUIMessage({action = 'testdriveTimer', event = true})
                        for i = 1, 120 do 
                            Wait(1000)
                            if inTestrit then
                                SendNUIMessage({action = 'testdriveTick'})
                            else
                                return
                            end
                        end
                
                        DoScreenFadeOut(750)
                        while not IsScreenFadedOut() do
                            Wait(0)
                        end
                
                        ESX.Game.DeleteVehicle(testritVehicle)
                        SendNUIMessage({action = 'testdriveTimer', event = false})
                        SetEntityCoords(ped, vector3(-805.8165, -1366.6023, 5.1783))
                        lib.notify({ description = 'Je testrit is beëindigd.', type = 'inform' })
                        NetworkSetPlayerIsPassive(false)
                        DoScreenFadeIn(750)
                        inTestrit = false
                        testritVehicle = false
                        return
                    end
                end)

                Citizen.CreateThread(function()
                    while inTestrit do
                        local sleep = 0
                        local coords = GetEntityCoords(PlayerPedId())
                        local dist = #(location.coords-coords)

                        if not IsPedInAnyVehicle(PlayerPedId(), false) then
                            ESX.Game.DeleteVehicle(testritVehicle)
                            DoScreenFadeOut(750)
                            while not IsScreenFadedOut() do
                                Wait(0)
                            end
                
                            SendNUIMessage({action = 'testdriveTimer', event = false})
                            SetEntityCoords(ped, vector3(-805.8165, -1366.6023, 5.1783))
                            lib.notify({ description = 'Je testrit is beëindigd.', type = 'inform' })
                            NetworkSetPlayerIsPassive(false)
                            DoScreenFadeIn(750)
                            inTestrit = false
                            testritVehicle = false
                            return
                        elseif dist >= 600 then
                            ESX.Game.DeleteVehicle(testritVehicle)
                            DoScreenFadeOut(750)
                            while not IsScreenFadedOut() do
                                Wait(0)
                            end
                
                            SendNUIMessage({action = 'testdriveTimer', event = false})
                            SetEntityCoords(ped, vector3(-805.8165, -1366.6023, 5.1783))
                            lib.notify({ description = 'Je testrit is beëindigd.', type = 'inform' })
                            NetworkSetPlayerIsPassive(false)
                            DoScreenFadeIn(750)
                            inTestrit = false
                            testritVehicle = false
                            return
                        end

                        Wait(sleep)
                    end
                end)
            end)

            break
		end
	end
end