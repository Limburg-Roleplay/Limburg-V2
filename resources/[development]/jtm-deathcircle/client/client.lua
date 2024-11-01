local deathPosition = nil
local blipDuration = Config.CircleTime * 1000

function updateNotification(message)
    exports['okokNotify']:Alert("Warning", message, 1000, 'error')
end

RegisterNetEvent('deathCircle:createZone')
AddEventHandler('deathCircle:createZone', function(coords)
    deathPosition = coords

    if deathPosition and deathPosition ~= vector3(0, 0, 0) then
        local blip = AddBlipForRadius(deathPosition.x, deathPosition.y, deathPosition.z, Config.CircleRadius)

        if blip then
            SetBlipColour(blip, Config.BlipColour)
            SetBlipAlpha(blip, 100)
        end

        local hastoleave = true
        local timerActive = false
        local startTime = 0

        Citizen.CreateThread(function()
            while hastoleave do
                Citizen.Wait(1000)

                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)

                if deathPosition then
                    local distance = #(playerCoords - deathPosition)

                    if distance < Config.CircleRadius then
                        if not timerActive then
                            timerActive = true
                            startTime = GetGameTimer()
                        end

                        local elapsedTime = (GetGameTimer() - startTime) / 1000
                        local remainingTime = Config.WarningTimer - elapsedTime

                        if remainingTime > 0 then
                            updateNotification(string.format("Verlaat dit gebied binnen %.0f seconden, anders zul je dood gaan.", remainingTime))
                        else
                            local health = GetEntityHealth(playerPed)
                            if health > 0 then
                                SetEntityHealth(playerPed, health - Config.DamageHealth)
                                updateNotification("Je bent te lang in deze zone, je gaat nu langszaam dood!")
                            else
                                hastoleave = false
                                local playerPed = PlayerPedId()
                                TriggerServerEvent('deathCircle:remove', GetPlayerServerId(playerPed))
                            end
                        end
                    else
                        if timerActive then
                            timerActive = false
                        end
                    end
                else
                    if timerActive then
                        timerActive = false
                    end
                end
            end
        end)

        Citizen.CreateThread(function()
            local canremove = false
            local fadeStart = GetGameTimer()
            while GetGameTimer() - fadeStart < blipDuration and not canremove do
                local progress = (GetGameTimer() - fadeStart) / blipDuration
                local newAlpha = 100 * (1 - progress)
                local newRadius = Config.CircleRadius * (1 - progress)
                
                if DoesBlipExist(blip) then
                    SetBlipAlpha(blip, math.floor(newAlpha))
                    if math.floor(newAlpha) == 0 then
                        canremove = true
                        hastoleave = false
                    end
                    
                end

                Citizen.Wait(500)

                if DoesBlipExist(blip) and canremove then
                    RemoveBlip(blip)
                    local playerPed = PlayerPedId()
                    TriggerServerEvent('deathCircle:remove', GetPlayerServerId(playerPed))
                end
            end
        end)

    end
end)
