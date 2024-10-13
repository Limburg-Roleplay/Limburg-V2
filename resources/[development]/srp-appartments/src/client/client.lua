-- // [VARIABLES] \\ --
today = { ['Functions'] = { ['Utils'] = {} } }

local srp = { Functions = {}, Blips = {} }
local currentObject = nil
local isInAppartment = false
local geschotenTijd = 0

today.Functions.Utils.DrawMarker = function(coords, r, g, b)
    local r = r ~= nil and r or 2
    local g = g ~= nil and g or 156
    local b = b ~= nil and b or 227
    
    DrawMarker(20, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, -0.25, r, g, b, 100, true, false, false, true, false, false, false)
end

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
    -- Fetch shared data and wait until it's available
    ESX.TriggerServerCallback('srp-appartments:server:cb:get:shared', function(data)
        Shared = data
    end)
    while not Shared do
        Wait(0) -- Wait until Shared data is loaded
    end

    -- Wait until ESX.PlayerLoaded is true
    while not ESX.PlayerLoaded do
        Wait(0)
    end

    -- Fetch all apartments data
    ESX.TriggerServerCallback('srp-appartments:server:cb:receive:allAppartments', function(result)
        local appartments = {}

        -- Mark all existing apartments
        for i = 1, #result do
            appartments[result[i]['appartment']] = true
        end

        -- Manage blips for each apartment
        for k, v in pairs(Shared.Appartments) do
            if appartments[k] then
                -- Remove existing blip if it exists
                if srp.Blips[k] then
                    RemoveBlip(srp.Blips[k])
                end

                -- Create new blip
                srp.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(srp.Blips[k], 40)
                SetBlipScale(srp.Blips[k], 0.7)
                SetBlipDisplay(srp.Blips[k], 4)
                SetBlipAsShortRange(srp.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Eigen appartement')
                EndTextCommandSetBlipName(srp.Blips[k])
            else
                -- Handle blip creation for non-existing apartments
                if srp.Blips[k] then
                    RemoveBlip(srp.Blips[k])
                end

                srp.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(srp.Blips[k], 40)
                SetBlipDisplay(srp.Blips[k], 4)
                SetBlipScale(srp.Blips[k], 0.85)
                SetBlipAsShortRange(srp.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Appartement te huur')
                EndTextCommandSetBlipName(srp.Blips[k])
            end
        end
    end)

    -- Main loop for proximity checks and UI interactions
    while true do
        local sleep = 750                                   -- Default sleep value for optimization
        local playerCoords = GetEntityCoords(PlayerPedId()) -- Get player coordinates once per loop

        for k, v in pairs(Shared.Appartments) do
            local appartmentCoords = vec3(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
            local dist = #(playerCoords - appartmentCoords) -- Calculate distance between player and apartment

            if dist <= 35.0 then
                sleep = 0 -- If within 35 units, reduce sleep for real-time checks

                -- Optionally draw a marker here (for debugging or visualization)
                -- ESX.DrawBasicMarker(appartmentCoords)
                today.Functions.Utils.DrawMarker(Shared.Appartments[k]['appartmentCoords'])
                if dist <= 2.5 then -- If within 2.5 units, show interaction UI
                    lib.showTextUI('[E] - Apartment', { icon = 'warehouse' })

                    if IsControlJustPressed(0, 38) then -- Check if "E" is pressed
                        srp.Functions.Interaction(k)    -- Call the interaction function for the apartment
                    end
                else
                    lib.hideTextUI() -- Hide the interaction UI if the player moves away
                end
            end
        end

        Wait(sleep) -- Sleep to reduce resource usage
    end
end)


-- // [EVENTS] \\ --

RegisterNetEvent('srp-appartments:client:update:data')
AddEventHandler('srp-appartments:client:update:data', function()
    ESX.TriggerServerCallback('srp-appartments:server:cb:receive:allAppartments', function(result)
        local appartments = {}

        for i = 1, #result do
            appartments[result[i]['appartment']] = true
        end

        for k, v in pairs(Shared.Appartments) do
            if appartments[k] then
                if srp.Blips[k] then
                    RemoveBlip(srp.Blips[k])
                end

                srp.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(srp.Blips[k], 40)
                SetBlipScale(srp.Blips[k], 0.7)
                SetBlipAsShortRange(srp.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Appartement')
                EndTextCommandSetBlipName(srp.Blips[k])
            else
                srp.Blips[k] = AddBlipForCoord(v.appartmentCoords.x, v.appartmentCoords.y, v.appartmentCoords.z)
                SetBlipSprite(srp.Blips[k], 350)
                SetBlipScale(srp.Blips[k], 0.7)
                SetBlipAsShortRange(srp.Blips[k], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Appartement')
                EndTextCommandSetBlipName(srp.Blips[k])
            end
        end
    end)
end)

RegisterNetEvent('srp-appartments:client:suspend:appartment')
AddEventHandler('srp-appartments:client:suspend:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end

    local input = lib.inputDialog('Appartment verkopen?', {
        { type = 'checkbox', label = 'Ja, ik weet zeker dat ik mijn appartement wil verkopen!', required = true },
    })

    if not input[1] then
        TriggerEvent('ox_lib:notify',
            ({ type = 'error', description = 'Je moet de checkbox aanvinken om je appartement te verkopen!', position = 'top' }))
        return
    end

    TriggerServerEvent('srp-appartments:server:suspend:appartment', index)
end)

RegisterNetEvent('srp-appartments:client:sell:appartment')
AddEventHandler('srp-appartments:client:sell:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end

    local input = lib.inputDialog('Appartment verkopen?', {
        { type = 'checkbox', label = 'Ja, ik weet zeker dat ik mijn appartement wil verkopen!', required = true },
    })

    if not input[1] then
        TriggerEvent('ox_lib:notify',
            ({ type = 'error', description = 'Je moet de checkbox aanvinken om je appartement te verkopen!', position = 'top' }))
        return
    end

    TriggerServerEvent('srp-appartments:server:sell:appartment', index)
end)

RegisterNetEvent('srp-appartments:client:buy:appartment')
AddEventHandler('srp-appartments:client:buy:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end

    local input = lib.inputDialog(
    'Appartment kopen? (€' .. Shared.Appartments[index]['appartmentPrices']['buyPrice'] .. ')', {
        { type = 'checkbox', label = 'Ja, ik weet zeker dat ik het appartement wil kopen!', required = true },
    })
    if not input[1] then
        TriggerEvent('ox_lib:notify',
            ({ type = 'error', description = 'Je moet de checkbox aanvinken om het appartement te kopen!', position = 'top' }))
        return
    end

    TriggerServerEvent('srp-appartments:server:buy:appartment', index)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedShooting(PlayerPedId()) then
            geschotenTijd = GetGameTimer()
        end
    end
end)

RegisterNetEvent('srp-appartments:client:rent:appartment')
AddEventHandler('srp-appartments:client:rent:appartment', function(index)
    if not index or not Shared.Appartments[index] then return end

    -- local input = lib.inputDialog('Appartment huren? (€' .. Shared.Appartments[index]['appartmentPrices']['rentPrice'] .. ')', {
    --     {type = 'checkbox', label = 'Ja, ik weet zeker dat ik het appartement wil huren!', required = true},
    -- })
    -- if not input[1] then
    --     TriggerEvent('ox_lib:notify', ({type = 'error', description = 'Je moet de checkbox aanvinken om het appartement te huren!', position = 'top' }))
    --     return
    -- end

    TriggerServerEvent('srp-appartments:server:rent:appartment', index)
end)

RegisterNetEvent('srp-appartments:client:saveOutfit')
AddEventHandler('srp-appartments:client:saveOutfit', function(data)
    local response = lib.inputDialog('Sla je outfit op', {
        {
            type = 'input',
            label = 'Outfitnaam',
            placeholder = 'Dagelijkse outfit',
            required = true
        }
    })
    if not response then return end

    local outfitName = response[1]
    if outfitName then
        Wait(500)
        ESX.TriggerServerCallback('srp-appartments:server:receive:clothing', function(outfits)
            local outfitsExists = false
            for i = 1, #outfits do
                if outfits[i]['outfitName']:lower() == outfitName:lower() then
                    outfitsExists = true
                    break
                end
            end

            if outfitsExists then
                lib.notify({ description = 'Deze outfit heb je al in je kast.. (geef het een andere naam)', type =
                'error', position = 'top' })
                return
            end

            local pedModel = srp.Functions.GetPedModel(PlayerPedId())
            local pedComponents = srp.Functions.GetPedComponents(PlayerPedId())
            local pedProps = srp.Functions.GetPedProps(PlayerPedId())

            TriggerServerEvent('srp-appartments:server:saveOutfit', outfitName, pedModel, pedComponents, pedProps)
        end)
    end
end)

RegisterNetEvent('srp-appartments:client:change:clothing:menu')
AddEventHandler('srp-appartments:client:change:clothing:menu', function(data)
    lib.registerContext({
        id = 'srp-appartments:client:change:clothing:menu',
        title = 'Appartement: Kleding Menu',
        options = {
            {
                title = data['outfitName'] .. ' aantrekken.',
                description = 'Trek ' .. data['outfitName'] .. ' aan.',
                icon = 'fas fa-shirt',
                event = 'srp-appartments:client:change:clothing',
                args = data
            },
            {
                title = 'Naam van ' .. data['outfitName'] .. ' aanpassen.',
                description = 'Pas de naam van ' .. data['outfitName'] .. ' aan.',
                icon = 'fas fa-tag',
                event = 'srp-appartments:client:change:clothing:name',
                args = data
            },
            {
                title = data['outfitName'] .. ' verwijderen.',
                description = 'Verwijder ' .. data['outfitName'] .. ' uit je kledingkast!',
                icon = 'fas fa-x',
                event = 'srp-appartments:client:change:clothing:remove',
                args = data
            }
        }
    })

    lib.showContext('srp-appartments:client:change:clothing:menu')
end)

RegisterNetEvent('srp-appartments:client:change:clothing:name')
AddEventHandler('srp-appartments:client:change:clothing:name', function(data)
    local response = lib.inputDialog('Outfit naam aanpassen: ' .. data['outfitName'], {
        {
            type = 'input',
            label = 'Nieuwe outfitnaam',
            placeholder = 'Dagelijkse outfit',
            required = true
        }
    })
    if not response then return end

    TriggerServerEvent('srp-appartments:server:changeOutfitName', data['outfitName'], response[1])
end)

RegisterNetEvent('srp-appartments:client:change:clothing:remove')
AddEventHandler('srp-appartments:client:change:clothing:remove', function(data)
    local response = lib.inputDialog('Weetje zeker dat je  ' .. data['outfitName'] .. ' wilt verwijderen?', {
        { type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true },
    })
    if not response then return end

    TriggerServerEvent('srp-appartments:server:removeOutfit', data['outfitName'])
end)

RegisterNetEvent('srp-appartments:client:change:clothing')
AddEventHandler('srp-appartments:client:change:clothing', function(data)
    local currentAppearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())

    currentAppearance.components = data['outfitComponents']
    currentAppearance.props = data['outfitProps']

    if lib.progressCircle({
            duration = 100,
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missmic4',
                clip = 'michael_tux_fidget'
            },
        }) then
        local health = GetEntityHealth(PlayerPedId())
        exports['fivem-appearance']:setPlayerAppearance(currentAppearance)

        TriggerServerEvent('esx_skin:save', currentAppearance)

        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        SetPedMaxHealth(PlayerPedId(), 200)
        SetEntityHealth(PlayerPedId(), health)
    end
end)

-- // [FUNCTIONS] \\ --

srp.Functions.GetPedComponents = function(ped)
    local componentsId = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
    local components = {}

    for i = 1, #componentsId do
        local componentId = componentsId[i]
        components[i] = {
            component_id = componentId,
            drawable = GetPedDrawableVariation(ped, componentId),
            texture = GetPedTextureVariation(ped, componentId),
        }
    end
    return components
end

srp.Functions.GetPedProps = function(ped)
    local propsId = { 0, 1, 2, 6, 7 }
    local props = {}

    for i = 1, #propsId do
        local propId = propsId[i]
        props[i] = {
            prop_id = propId,
            drawable = GetPedPropIndex(ped, propId),
            texture = GetPedPropTextureIndex(ped, propId),
        }
    end
    return props
end

srp.Functions.GetPedModel = function(ped)
    for i = 1, #Shared.Peds do
        if joaat(Shared.Peds[i]) == GetEntityModel(ped) then
            return Shared.Peds[i]
        end
    end
end

srp.Functions.EnterAppartment = function(index)
    -- ESX.TriggerServerCallback('srp-appartments:server:cb:receive:cooldownData', function(done, time)
    --     if not done then
    --         TriggerEvent('ox_lib:notify',
    --             ({ type = 'error', description = "Ze zijn je huis aan het schilderen wacht nog " .. math.floor(ESX.Math.Round((time / 60), 0)) .. " minuten" }))
    --         isTimer = true
    --         return
    --     end

    --     if GetGameTimer() - geschotenTijd < 300000 then
    --         TriggerEvent('ox_lib:notify',
    --             ({ type = 'error', description = "Je hebt binnen deze 5 minuten geschoten, wacht nog 5 minuten." }))
    --     end

        local hash = joaat(Shared.Appartments[index]['appartmentModel'])
        local coords = GetEntityCoords(PlayerPedId())

        if not IsModelValid(Shared.Appartments[index]['appartmentModel']) then return end

        RequestModel(Shared.Appartments[index]['appartmentModel'])
        while not HasModelLoaded(Shared.Appartments[index]['appartmentModel']) do
            Wait(0)
        end

        TriggerEvent('ox_lib:notify', ({ type = 'info', description = "Appartement aan het inladen.." }))

        ESX.Game.SpawnLocalObject(hash,
            vector3(Shared.Appartments[index]['appartmentCoords']['x'],
                Shared.Appartments[index]['appartmentCoords']['y'],
                Shared.Appartments[index]['appartmentCoords']['z'] - 40.0), function(obj)
            currentObject = obj

            FreezeEntityPosition(currentObject, true)
            SetEntityAsMissionEntity(currentObject)
            SetModelAsNoLongerNeeded(currentObject)

            local x, y, z = Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['x'],
                Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['y'],
                Shared.Offsets[Shared.Appartments[index]['appartmentModel']]['exit']['z']
            local offset = GetOffsetFromEntityInWorldCoords(object, x, y, z)

            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(0)
            end

            TriggerServerEvent('srp-appartments:server:enter:appartment')
            SetEntityCoords(PlayerPedId(), Shared.AppartmentLocations.exitInteraction.x,
                Shared.AppartmentLocations.exitInteraction.y, Shared.AppartmentLocations.exitInteraction.z)

            Wait(1000)
            DoScreenFadeIn(500)

            isInAppartment = true

            srp.Functions.AppartmentHandler(index, Shared.Appartments[index]['appartmentModel'])
        end)
    -- end, index)
end


srp.Functions.AppartmentHandler = function(index, modelName)
    while isInAppartment do
        local sleep = 750
        local coords = GetEntityCoords(PlayerPedId())
        local dist = #(Shared.AppartmentLocations.exitInteraction - coords) -- Moved this above the distance check

        if dist <= 35.0 then
            sleep = 0
        end
        
        print(dist) -- Debugging: Prints the distance

        if dist <= 2.5 then -- If within 2.5 units, show interaction UI
            lib.showTextUI('[E] - Verlaat Appartement', { icon = 'warehouse' })
            if IsControlJustPressed(0, 38) then -- Check if "E" is pressed
                isInAppartment = false
                TriggerServerEvent('srp-appartments:server:leave:appartment')
                ClearPedTasks(PlayerPedId())
                srp.Functions.LeaveAppartment(index)
            end
        end


        local appartementName = 'blokkenpark'
        local appartement = Shared.Appartments[appartementName]
        if appartement then
            local storageCoords = appartement.positions.Storage
            local storageSize = appartement.positions.StorageSize
            local storageHeading = appartement.positions.StorageHeading
            inventoryZone = exports.ox_target:addBoxZone({
                name = 'apt-inventory',
                coords = storageCoords,
                size = storageSize,
                rotation = storageHeading,
                options = {
                    {
                        name = 'openInventory',
                        icon = 'fa-solid fa-user-ninja',
                        label = 'Opslag openen',
                        onSelect = function()
                            ESX.TriggerServerCallback('srp-appartments:server:open:stash',
                                function(bool, stashName)
                                    if not bool and not stashName then return end
                                    exports.ox_inventory:openInventory('stash',
                                        { id = stashName, owner = ESX.PlayerData.identifier })
                                end, index)
                        end,
                    }
                }
            })
        else
            print('Appartement niet gevonden in configuratie.')
        end

        for k, v in pairs(Shared.Offsets[Shared.Appartments[index]['appartmentModel']]) do
            local xCoords = Shared.Appartments[index]['appartmentCoords']['x'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']][k]['x']
            local yCoords = Shared.Appartments[index]['appartmentCoords']['y'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']][k]['y']
            local zCoords = Shared.Appartments[index]['appartmentCoords']['z'] + Shared.Offsets[Shared.Appartments[index]['appartmentModel']][k]['z'] - 40.0
            local totalCoords = vec3(xCoords, yCoords, zCoords)
            local dist = #(totalCoords - coords)

            if dist <= 1.5 then
                if k == 'clothing' then
                    if IsControlJustPressed(0, 38) then
                        local opts = {
                            {
                                title = 'Outfit opslaan',
                                description = 'Sla je outfit op in je kledingkast..',
                                event = 'srp-appartments:client:saveOutfit',
                                icon = 'fas fa-shirt',
                                arrow = true
                            }
                        }

                        ESX.TriggerServerCallback('srp-appartments:server:receive:clothing', function(outfits)
                            if outfits then
                                for i = 1, #outfits do
                                    opts[#opts + 1] = {
                                        title = outfits[i]['outfitName'],
                                        icon = 'fas fa-socks',
                                        description = 'Opties bekijken van ' .. outfits[i]['outfitName'] .. '.',
                                        args = { outfitName = outfits[i]['outfitName'], outfitModel = outfits[i]['outfitModel'], outfitComponents = outfits[i]['outfitComponents'], outfitProps = outfits[i]['outfitProps'] },
                                        event = 'srp-appartments:client:change:clothing:menu'
                                    }
                                end
                            end

                            lib.registerContext({
                                id = 'srp-appartments:client:interaction:clothing',
                                title = 'Appartement: Kledingkast',
                                options = opts
                            })

                            lib.showContext('srp-appartments:client:interaction:clothing')
                        end)
                    end
                end
            end
        end

        Wait(sleep)
    end
end


srp.Functions.LeaveAppartment = function(index)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    ESX.Game.DeleteObject(currentObject)
    SetEntityCoords(PlayerPedId(), Shared.Appartments[index]['appartmentCoords'].x, Shared.Appartments[index]['appartmentCoords'].y, Shared.Appartments[index]['appartmentCoords'].z)

    Wait(1000)
    DoScreenFadeIn(500)
end

srp.Functions.Interaction = function(index)
    ESX.TriggerServerCallback('srp-appartments:server:cb:receive:appartment:info', function(bool, isRent)
        local opts = {}

        if bool then
            opts[#opts + 1] = {
                title = 'Naar binnen gaan',
                description = 'Ga je appartment in',
                icon = 'door-open',
                onSelect = function()
                    srp.Functions.EnterAppartment(index)
                    -- TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_PARKING_METER', true, true)
                    -- Wait(1000)
                    -- ClearPedTasks(PlayerPedId())
                end
            }
        else
            opts[#opts + 1] = {
                title = 'Prijs: €' .. Shared.Appartments[index]['appartmentPrices']['rentPrice'] .. ' per week',
                -- description = 'Prijs: €' .. Shared.Appartments[index]['appartmentPrices']['buyPrice'],
                -- onSelect = function()
                --     TriggerEvent('srp-appartments:client:buy:appartment', index)
                -- end,
                -- icon = 'fas fa-euro-sign'
            }

            opts[#opts + 1] = {
                title = 'Appartment huren',
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = 'Weet je het zeker?',
                        content = 'Weet je zeker dat je dit appartment wilt huren voor €' ..
                        Shared.Appartments[index]['appartmentPrices']['rentPrice'] .. ' per week?',
                        centered = true,
                        cancel = true
                    })

                    if alert == 'confirm' then
                        TriggerEvent('srp-appartments:client:rent:appartment', index)
                    end
                end,
                icon = 'fas fa-euro-sign', -- corrected icon reference
            }
        end

        if bool then
            if not isRent then
                opts[#opts + 1] = {
                    title = 'Appartment verkopen..',
                    description = 'Verkopen voor: €' ..
                    math.floor(Shared.Appartments[index]['appartmentPrices']['buyPrice'] * 0.60),
                    icon = 'fas fa-file-contract',
                    onSelect = function()
                        TriggerEvent('srp-appartments:client:sell:appartment', index)
                    end
                }
            elseif isRent then
                opts[#opts + 1] = {
                    title = 'Huur opzeggen',
                    description = 'Je kan in de eerste week je huur niet opzeggen.',
                    icon = 'circle-xmark',
                    disabled = true,
                    onSelect = function()
                        TriggerEvent('srp-appartments:client:suspend:appartment', index)
                    end
                }
            end
        end

        lib.registerContext({
            id = 'srp-appartments:client:interaction',
            title = 'Appartment: ' .. Shared.Appartments[index]['appartmentLabel'],
            options = opts
        })

        lib.showContext('srp-appartments:client:interaction')
    end, index)
end


srp.Functions.DrawMarker = function(coords, r, g, b, bobbing)
    local r = r ~= nil and r or 2
    local g = g ~= nil and g or 156
    local b = b ~= nil and b or 227
    local bobbing = bobbing ~= nil and bobbing or false

    DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, r, g, b, 222, bobbing,
        false, false, true, false, false, false)
end

srp.Functions.DrawText = function(coords, text)
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
