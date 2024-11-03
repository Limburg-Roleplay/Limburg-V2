-- // [VARIABLES] \\ --

local Exios = { Functions = {}, Blips = {} }
local currentObject = nil
local isInAppartment = false

-- // [STARTUP] \\ --

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
    ESX.TriggerServerCallback('exios-appartments:server:cb:get:shared', function(data)
        Shared = data
    end)
    while not Shared do Wait(0) end

    while not ESX.PlayerLoaded do Wait(0) end

    ESX.TriggerServerCallback('exios-appartments:server:cb:receive:allAppartments', function(result)
        local appartments = {}

        for i=1, #result do 
            appartments[result[i]['appartment']] = true
        end

        for k,v in pairs(Shared.Appartments) do 
            if appartments[k] then 
                if Exios.Blips[k] then 
                    RemoveBlip(Exios.Blips[k])
                end

                Exios.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(Exios.Blips[k], 40)
                SetBlipScale  (Exios.Blips[k], 0.7)
                SetBlipAsShortRange(Exios.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Eigen appartement')
                EndTextCommandSetBlipName(Exios.Blips[k])
            else 
                Exios.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(Exios.Blips[k], 350)
                SetBlipScale  (Exios.Blips[k], 0.7)
                SetBlipAsShortRange(Exios.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Appartement')
                EndTextCommandSetBlipName(Exios.Blips[k])
            end
        end
    end)

    while true do 
        local sleep = 750 
        local coords = GetEntityCoords(PlayerPedId())

        for k,v in pairs(Shared.Appartments) do 
            local dist = #(coords - Shared.Appartments[k]['appartmentCoords'])

            if dist <= 35.0 then 
                sleep = 0
                ESX.DrawBasicMarker(Shared.Appartments[k]['appartmentCoords'])
                if dist <= 2.5 then 
                    exports['frp-interaction']:Interaction('info', '[E] - Huis interacties', Shared.Appartments[k]['appartmentCoords'], 2.5, GetCurrentResourceName() .. '-appartments')
                    if IsControlJustPressed(0, 38) then 
                        Exios.Functions.Interaction(k)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

-- // [EVENTS] \\ --

RegisterNetEvent('exios-appartments:client:update:data')
AddEventHandler('exios-appartments:client:update:data', function()
    ESX.TriggerServerCallback('exios-appartments:server:cb:receive:allAppartments', function(result)
        local appartments = {}

        for i=1, #result do 
            appartments[result[i]['appartment']] = true
        end

        for k,v in pairs(Shared.Appartments) do 
            if appartments[k] then 
                if Exios.Blips[k] then 
                    RemoveBlip(Exios.Blips[k])
                end

                Exios.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(Exios.Blips[k], 40)
                SetBlipScale  (Exios.Blips[k], 0.7)
                SetBlipAsShortRange(Exios.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Appartement')
                EndTextCommandSetBlipName(Exios.Blips[k])
            else 
                Exios.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(Exios.Blips[k], 350)
                SetBlipScale  (Exios.Blips[k], 0.7)
                SetBlipAsShortRange(Exios.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Appartement')
                EndTextCommandSetBlipName(Exios.Blips[k])
            end
        end
    end)
end)

RegisterNetEvent('exios-appartments:client:suspend:appartment')
AddEventHandler('exios-appartments:client:suspend:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end
 
    local input = lib.inputDialog('Appartment verkopen?', {
        {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
    })

    if not input[1] then 
        TriggerEvent('ox_lib:notify', ({type = 'error', description = 'Je bent niet akkoord gegaan met het eindigen van het contract.', position = 'top' })) 
        return 
    end

    TriggerServerEvent('exios-appartments:server:suspend:appartment', index)
end)

RegisterNetEvent('exios-appartments:client:sell:appartment')
AddEventHandler('exios-appartments:client:sell:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end
 
    local input = lib.inputDialog('Appartment verkopen?', {
        {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
    })

    if not input[1] then 
        TriggerEvent('ox_lib:notify', ({type = 'error', description = 'Je bent niet akkoord gegaan met het eindigen van het contract.', position = 'top' })) 
        return 
    end

    TriggerServerEvent('exios-appartments:server:sell:appartment', index)
end)

RegisterNetEvent('exios-appartments:client:buy:appartment')
AddEventHandler('exios-appartments:client:buy:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end

    local input = lib.inputDialog('Appartment kopen? (€' .. Shared.Appartments[index]['appartmentPrices']['buyPrice'] .. ')', {
        {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
    })
    if not input[1] then 
        TriggerEvent('ox_lib:notify', ({type = 'error', description = 'Je bent niet akkoord gegaan met het starten van het contract.', position = 'top' })) 
        return 
    end

    TriggerServerEvent('exios-appartments:server:buy:appartment', index)
end)

RegisterNetEvent('exios-appartments:client:rent:appartment')
AddEventHandler('exios-appartments:client:rent:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end

    local input = lib.inputDialog('Appartment huren? (€' .. Shared.Appartments[index]['appartmentPrices']['rentPrice'] .. ')', {
        {type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true},
    })
    if not input[1] then 
        TriggerEvent('ox_lib:notify', ({type = 'error', description = 'Je bent niet akkoord gegaan met het starten van het contract.', position = 'top' })) 
        return 
    end

    TriggerServerEvent('exios-appartments:server:rent:appartment', index)
end)

-- // [COMMANDS] \\ --

RegisterCommand('kledingmenu', function(source, args, rawCommand)
    ESX.TriggerServerCallback('kledingperms', function(hasPermission)
        if hasPermission then
            local initialOptions = {
                {
                    title = 'Bekijk Outfits',
                    event = 'fivem-appearance:viewOutfits'
                },
                {
                    title = 'Verwijder Outfits',
                    event = 'fivem-appearance:deleteOutfitMenu:appartments' 
                }
            }

            lib.registerContext({
                id = 'kleding_menu',
                title = 'Staff Kledingkast Menu',
                options = initialOptions
            })

            lib.showContext('kleding_menu')
        else
            exports['okokNotify']:Alert('Geen perms', 'Je hebt hier niet de juiste perms voor pannenkoek', 5000, 'error')
        end
    end)
end)

RegisterNetEvent('fivem-appearance:viewOutfits', function()
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local Options = {}

    if outfits and #outfits > 0 then
        for i = 1, #outfits do 
            Options[#Options + 1] = {
                title = outfits[i].name,
                event = 'fivem-appearance:setOutfit',
                args = {
                    ped = outfits[i].ped,
                    components = outfits[i].components,
                    props = outfits[i].props
                }
            }
        end
    end

    lib.registerContext({
        id = 'outfit_menu',
        title = 'Staff Kledingkast Menu',
        options = Options
    })

    lib.showContext('outfit_menu')
end)

RegisterNetEvent('fivem-appearance:deleteOutfitMenu:appartments', function()
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local Options = {}

    if outfits then
        for i=1, #outfits do
            Options[#Options + 1] = {
                title = outfits[i].name,
                event = 'fivem-appearance:confirmDeleteOutfit:appartments',
                args = outfits[i].id 
            }
        end
    else
    end
    
    lib.registerContext({
        id = 'outfit_delete_menu',
        title = 'Staff Delete Outfits',
        options = Options
    })
    
    lib.showContext('outfit_delete_menu')
end)

RegisterNetEvent('fivem-appearance:confirmDeleteOutfit:appartments', function(outfitId)
    local confirmOptions = {
        {
            title = 'Ja',
            description = 'Ja, ik wil mijn outfit verwijderen',
            serverEvent = 'fivem-appearance:deleteOutfit',
            args = outfitId
        },
        {
            title = 'Nee',
            description = 'Nee, ik wil mijn outfit niet verwijderen',
            onSelect = function() 
                lib.showContext('kleding_menu')
            end
        }
    }

    lib.registerContext({
        id = 'outfit_confirm_delete_menu',
        title = 'Outfit Delete Menu',
        options = confirmOptions
    })

    lib.showContext('outfit_confirm_delete_menu')
end)

-- // [COMMANDS] \\ --


-- // [FUNCTIONS] \\ --

Exios.Functions.GetPedComponents = function(ped)
    local componentsId = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
    local components = {}

    for i=1, #componentsId do 
        local componentId = componentsId[i]
        components[i] = {
            component_id = componentId,
            drawable = GetPedDrawableVariation(ped, componentId),
            texture = GetPedTextureVariation(ped, componentId),
        }
    end
    return components
end

Exios.Functions.GetPedProps = function(ped)
    local propsId = {0, 1, 2, 6, 7}
    local props = {} 

    for i=1, #propsId do 
        local propId = propsId[i]
        props[i] = {
            prop_id = propId,
            drawable = GetPedPropIndex(ped, propId),
            texture = GetPedPropTextureIndex(ped, propId),
        }
    end
    return props
end

Exios.Functions.GetPedModel = function(ped)
    for i=1, #Shared.Peds do 
        if joaat(Shared.Peds[i]) == GetEntityModel(ped) then 
            return Shared.Peds[i]
        end
    end
end

Exios.Functions.EnterAppartment = function(index)
    ESX.TriggerServerCallback('exios-appartments:server:cb:receive:cooldownData', function(done, time)
        if not done then 
            TriggerEvent('ox_lib:notify', ({type = 'error', description = 'Ze zijn je huis aan het schilderen wacht nog '.. math.floor(ESX.Math.Round((time/60), 0)) ..' minuten', position = 'top' })) 
            isTimer = true
            return 
        end

        local hash = joaat(Shared.Appartments[index]['appartmentModel'])
        local coords = GetEntityCoords(PlayerPedId())

        if not IsModelValid(Shared.Appartments[index]['appartmentModel']) then return end

        RequestModel(Shared.Appartments[index]['appartmentModel'])
        while not HasModelLoaded(Shared.Appartments[index]['appartmentModel']) do 
            Wait(0)
        end

        TriggerEvent('ox_lib:notify', ({type = 'info', position = 'top', description = 'Appartement aan het inladen..' }))

        ESX.Game.SpawnLocalObject(hash, vector3(Shared.Appartments[index]['appartmentCoords']['x'], Shared.Appartments[index]['appartmentCoords']['y'], Shared.Appartments[index]['appartmentCoords']['z'] - 40.0), function(obj)
            currentObject = obj

            FreezeEntityPosition(currentObject, true)
            SetEntityAsMissionEntity(currentObject)
            SetModelAsNoLongerNeeded(currentObject)

            local x,y,z = Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['x'], Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['y'], Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['z']
            local offset = GetOffsetFromEntityInWorldCoords(object, x, y, z)

            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(0)
            end

            TriggerServerEvent('exios-appartments:server:enter:appartment')

            SetEntityCoords(PlayerPedId(), Shared.Appartments[index]['appartmentCoords']['x'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['x'], Shared.Appartments[index]['appartmentCoords']['y'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['y'], Shared.Appartments[index]['appartmentCoords']['z'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['z'] - 40.0)
        
            Wait(1000)
            DoScreenFadeIn(500)

            isInAppartment = true

            Exios.Functions.AppartmentHandler(index, Shared.Appartments[index]['appartmentModel'])
			
			TriggerServerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1203502743642312745/wnF6oCPGXADIMuGfRrPqYDDnoQ1SfcXnfjelD_tVMGLrLDZjZ3-r5QNT3BhNqOVXlNbp', GetPlayerServerId(PlayerPedId()), {title = "Appartement ingegaan", desc = "[".. GetPlayerServerId(PlayerPedId()) .."] ".. GetPlayerName(PlayerPedId()) .." is zojuist zijn appartement ingegaan"})
        end)
    end, index)
end

Exios.Functions.AppartmentHandler = function(index, modelName)
    local clothingContextRegistered = false  -- Boolean om te controleren of de context is geregistreerd

    while isInAppartment do 
        local sleep = 0
        local coords = GetEntityCoords(PlayerPedId())

        for k, v in pairs(Shared.Offsets[Shared.Appartments[index]['appartmentModel']]) do 
            local xCoords = Shared.Appartments[index]['appartmentCoords']['x'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']][k]['x']
            local yCoords = Shared.Appartments[index]['appartmentCoords']['y'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']][k]['y']
            local zCoords = Shared.Appartments[index]['appartmentCoords']['z'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']][k]['z'] - 40.0

            local totalCoords = vec3(xCoords, yCoords, zCoords)
            local dist = #(totalCoords - coords)

            if dist <= 1.5 then
                if k == 'exit' then 
                    exports['frp-interaction']:Interaction('error', '[E] - Verlaten', totalCoords, 2.5, GetCurrentResourceName() .. '-appartments')
                    if IsControlJustPressed(0, 38) then 
                        isInAppartment = false
                        TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', true, true)
                        Wait(1000)
                        TriggerServerEvent('exios-appartments:server:leave:appartment')
                        ClearPedTasks(PlayerPedId())
                        Exios.Functions.LeaveAppartment(index)
                        TriggerServerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1203502743642312745/wnF6oCPGXADIMuGfRrPqYDDnoQ1SfcXnfjelD_tVMGLrLDZjZ3-r5QNT3BhNqOVXlNbp', GetPlayerServerId(PlayerPedId()), {title = "Appartement verlaten", desc = "[".. GetPlayerServerId(PlayerPedId()) .."] ".. GetPlayerName(PlayerPedId()) .." heeft zojuist zijn appartement verlaten"})
                    end
                elseif k == 'stash' then 
                    exports['frp-interaction']:Interaction('info', '[E] - Opslag', totalCoords, 2.5, GetCurrentResourceName() .. '-appartments')
                    if IsControlJustPressed(0, 38) then 
                        ESX.TriggerServerCallback('exios-appartments:server:open:stash', function(bool, stashName)
                            if not bool and not stashName then return end
                            exports.ox_inventory:openInventory('stash', { id = stashName, owner = ESX.PlayerData.identifier })
                        end, index)
                    end
                elseif k == 'clothing' then 
                    exports['frp-interaction']:Interaction('info', '[E] - Kleding', totalCoords, 2.5, GetCurrentResourceName() .. '-appartments')
                    if IsControlJustPressed(0, 38) then 
                        if not clothingContextRegistered then
                            local opts = {}

                            local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
                            if outfits then 
                                opts[#opts + 1] = { 
                                    title = 'Outfits bekijken',
                                    description = 'Bekijk de outfits in je kledingkast',
                                    event = 'fivem-appearance:browseOutfits:appartmentsinteraction',
                                    icon = 'fas fa-vest',
                                    arrow = true
                                }
                            end

                            opts[#opts + 1] = {
                                title = 'Outfit opslaan',
                                description = 'Sla je outfit op in je kledingkast..',
                                event = 'fivem-appearance:saveOutfit',
                                icon = 'fas fa-shirt',
                                arrow = true
                            }

                            opts[#opts + 1] = {
                                title = 'Outfit verwijderen',
                                description = 'Verwijder een outfit uit je kledingkast..',
                                event = 'fivem-appearance:deleteOutfitMenu:appartmentsinteraction',
                                icon = 'fas fa-trash',
                                arrow = true
                            }

                            lib.registerContext({
                                id = 'jamie-appartmentclothing',
                                title = 'Appartement: Kledingkast',
                                options = opts
                            })

                            clothingContextRegistered = true 
                        end

                        lib.showContext('jamie-appartmentclothing') 
                    end  
                end 
            end 
        end  
        Wait(sleep) 
    end  
end




-- Kledingkast

RegisterNetEvent('fivem-appearance:browseOutfits:appartmentsinteraction', function()
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local Options = {}
    if outfits then 
        for i=1, #outfits do 
            Options[#Options + 1] = {
                title = outfits[i].name,
                event = 'fivem-appearance:setOutfit',
                args = {
                    ped = outfits[i].ped,
                    components = outfits[i].components,
                    props = outfits[i].props
                }
            }
        end
    else
    end
    lib.registerContext({
        id = 'outfit_menu_appartmentsinteraction',
        title = 'Outfit Menu Appartement',
        options = Options
    })
    lib.showContext('outfit_menu_appartmentsinteraction')
end)

RegisterNetEvent('fivem-appearance:deleteOutfitMenu:appartmentsinteraction', function()
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local Options = {}

    if outfits then
        for i=1, #outfits do
            Options[#Options + 1] = {
                title = outfits[i].name,
                event = 'fivem-appearance:confirmDeleteOutfit:appartmentsinteraction',
                args = outfits[i].id 
            }
        end
    end
    
    lib.registerContext({
        id = 'outfit_delete_menu_appartmentsinteraction',
        title = 'Outfit Delete Menu',
        options = Options
    })
    
    lib.showContext('outfit_delete_menu_appartmentsinteraction')
end)

RegisterNetEvent('fivem-appearance:confirmDeleteOutfit:appartmentsinteraction', function(outfitId)
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local confirmOptions = {
        {
            title = 'Ja',
            description = 'Ja ik wil mijn outfit verwijderen',
            serverEvent = 'fivem-appearance:deleteOutfit',
            args = outfitId
        },
        {
            title = 'Nee',
            description = 'Nee ik wil mijn outfit niet verwijderen', 
            onSelect = function() 
                lib.showContext('jamie-appartmentclothing') 
            end
        }
    }

    lib.registerContext({
        id = 'outfit_confirm_delete_menu_appartmentsinteraction',
        title = 'Outfit Delete Menu',
        options = confirmOptions
    })

    lib.showContext('outfit_confirm_delete_menu_appartmentsinteraction')
end)

-- Kledingkast

Exios.Functions.LeaveAppartment = function(index)

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    ESX.Game.DeleteObject(currentObject)
    SetEntityCoords(PlayerPedId(), Shared.Appartments[index]['appartmentCoords']['x'], Shared.Appartments[index]['appartmentCoords']['y'], Shared.Appartments[index]['appartmentCoords']['z'])

    Wait(1000)
    DoScreenFadeIn(500)
end

Exios.Functions.Interaction = function(index)
    ESX.TriggerServerCallback('exios-appartments:server:cb:receive:appartment:info', function(bool, isRent)
        local opts = {}

        if bool then 
            opts[#opts + 1] = {
                title = 'Naar binnen gaan..',
                icon = 'fas fa-house',
                onSelect = function()
                    Exios.Functions.EnterAppartment(index)
                    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', true, true)
                    Wait(1000)
                    ClearPedTasks(PlayerPedId())
                end
            }
        else 
            opts[#opts + 1] = {
                title = 'Appartment kopen..',
                description = 'Prijs: €' .. Shared.Appartments[index]['appartmentPrices']['buyPrice'],
                onSelect = function()
                    TriggerEvent('exios-appartments:client:buy:appartment', index)
                end,
                icon = 'fas fa-euro-sign'
            }

            opts[#opts + 1] = {
                title = 'Appartment huren..',
                description = 'Prijs: €' .. Shared.Appartments[index]['appartmentPrices']['rentPrice'] .. ' p/d',
                onSelect = function()
                    TriggerEvent('exios-appartments:client:rent:appartment', index)
                end,
                icon = 'fas fa-file-contract'
            }
        end

        if bool then 
            if not isRent then 
                opts[#opts + 1] = {
                    title = 'Appartment verkopen..',
                    description = 'Verkopen voor: €' .. math.floor(Shared.Appartments[index]['appartmentPrices']['buyPrice'] * 0.60),
                    icon = 'fas fa-file-contract',
                    onSelect = function()
                        TriggerEvent('exios-appartments:client:sell:appartment', index)
                    end
                }
            elseif isRent then
                opts[#opts + 1] = {
                    title = 'Huur opzeggen..',
                    icon = 'fas fa-file-contract',
                    onSelect = function()
                        TriggerEvent('exios-appartments:client:suspend:appartment', index)
                    end
                }
            end
        end

        lib.registerContext({
            id = 'exios-appartments:client:interaction',
            title = 'Appartment: ' .. Shared.Appartments[index]['appartmentLabel'],
            options = opts
        })

        lib.showContext('exios-appartments:client:interaction')
    end, index)
end

Exios.Functions.DrawMarker = function(coords, r, g, b, bobbing)
    local r = r ~= nil and r or 2
    local g = g ~= nil and g or 156
    local b = b ~= nil and b or 227
    local bobbing = bobbing ~= nil and bobbing or false
    
    DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, r, g, b, 222, bobbing, false, false, true, false, false, false)
end

Exios.Functions.DrawText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords['x'], coords['y'], coords['z'])
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end