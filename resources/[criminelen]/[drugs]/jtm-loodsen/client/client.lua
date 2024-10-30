ESX = nil

ESX = exports["es_extended"]:getSharedObject()

local currentLoods = nil
RegisterNetEvent("loodsen:showNui")
AddEventHandler(
    "loodsen:showNui",
    function(loodsId)
        ESX.TriggerServerCallback(
            "loodsen:isOwner",
            function(isOwner)
                if isOwner then
                    TriggerServerEvent("loodsen:getOpslagDataOwner")
        			SetNuiFocus(true, true)
				else
                    TriggerServerEvent("loodsen:getOpslagData")
        			SetNuiFocus(true, true)
                end
            end,
            loodsId
        )
        
    end
)

RegisterNUICallback(
    "plukken",
    function(data, cb)
        TriggerServerEvent("loodsen:plukken")
        cb("ok")
    end
)
RegisterNetEvent('updatePlantGrowth')
AddEventHandler('updatePlantGrowth', function(loodsId, plantGrowth, opslag, maxopslag)
    SendNUIMessage({
        action = 'plantGrowthUpdate',
        loodsId = loodsId,
        plantGrowth = plantGrowth,
                opslag = opslag,
                maxopslag = maxopslag
    })
end)

RegisterNUICallback(
    "close",
    function(data, cb)
        SetNuiFocus(false, false)
        SendNUIMessage({action = "hide"})
        cb("ok")
    end
)


RegisterNUICallback(
    "closeOwner",
    function(data, cb)
        SetNuiFocus(false, false)
        SendNUIMessage({action = "hideowner"})
        cb("ok")
    end
)


RegisterNetEvent("loodsen:openMenu")
AddEventHandler("loodsen:openMenu", function(markerLocation, loodsId)
    local elements = {}

    ESX.TriggerServerCallback("loodsen:getLoodsData", function(loodsData)
        ESX.TriggerServerCallback("loodsen:isBought", function(isBought, isOwner, isRealOwner)
            if isBought == nil or isOwner == nil then
                print('error fetching data')
                return
            end

            for _, loods in ipairs(loodsData) do
                if
                    math.floor(json.decode(loods.location).x) == math.floor(markerLocation.x) and
                        math.floor(json.decode(loods.location).y) == math.floor(markerLocation.y) and
                        math.floor(json.decode(loods.location).z) == math.floor(markerLocation.z)
                then
                    if isBought then
                        if isOwner then
                            table.insert(elements, {label = "Binnengaan", value = "enter"})
                        else
                            table.insert(elements, {label = "Aankloppen", value = "knock"})
                        end
                        if isOwner and isRealOwner then
                            table.insert(elements, {label = "Verkopen", value = "sell"})
                        end
                    else
                        table.insert(elements, {label = "Aankopen (€" .. loods.price .. ")", value = loods.id})
                    end
                end
            end

            ESX.UI.Menu.Open(
                "default",
                GetCurrentResourceName(),
                "loodsen_menu",
                {
                    title = "Loods: #" .. loodsId,
                    align = "top-right",
                    elements = elements
                },
                function(data, menu)
                    if data.current.value == "enter" then
                        local teleportLocation = Config.InsideLoods
                        exports["lrp-interaction"]:clearInteraction()
                        DoScreenFadeOut(400)
                        Citizen.Wait(500)
                        SetEntityHeading(PlayerPedId(), teleportLocation.w)
                        SetEntityCoords(
                            PlayerPedId(),
                            teleportLocation.x,
                            teleportLocation.y,
                            teleportLocation.z,
                            false,
                            false,
                            false,
                            true
                        )
                        TriggerServerEvent("loodsen:setRoutingBucket", loodsId)

                        Citizen.Wait(500)
                        DoScreenFadeIn(500)

                        exports["lrp-interaction"]:clearInteraction()
                    elseif data.current.value == "sell" then
                        ESX.UI.Menu.Open(
                            "default",
                            GetCurrentResourceName(),
                            "loodsen_sell_confirmation",
                            {
                                title = "Bevestig Verkoop",
                                align = "top-right",
                                elements = {
                                    {label = "Bevestigen", value = "confirm"},
                                    {label = "Annuleren", value = "cancel"}
                                }
                            },
                            function(data2, menu2)
                                if data2.current.value == "confirm" then
                                    TriggerServerEvent("loodsen:sellLoods", loodsId)
                                    TriggerEvent('okokNotify:Alert', "Gelukt!", "Je hebt je loods verkocht.", 5000, 'success')
                                end
                                menu2.close()
                            end,
                            function(data2, menu2)
                                menu2.close()
                            end
                        )
                    else
                        local selectedLoodsId = data.current.value
                        local price = nil
                        for _, loods in ipairs(loodsData) do
                            if loods.id == selectedLoodsId then
                                price = loods.price
                            end
                        end
                        ESX.UI.Menu.Open(
                            "default",
                            GetCurrentResourceName(),
                            "loodsen_payment_menu",
                            {
                                title = "Betaalmethode",
                                align = "top-right",
                                elements = {
                                    {label = "Ingame (€" .. price .. ")", value = "ingame"}
                                }
                            },
                            function(data2, menu2)
                                local paymentType = data2.current.value
                                TriggerServerEvent("loodsen:buy", selectedLoodsId, paymentType)
                                menu2.close()
                            end,
                            function(data2, menu2)
                                menu2.close()
                            end
                        )
                    end

                    menu.close()
                end,
                function(data, menu)
                    menu.close()
                end
            )
        end, loodsId)
    end)
end)

Citizen.CreateThread(
    function()
        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local isInMarker = false
            local currentMarker = nil
            local markerLocation = nil
            local sleep = 1000
            local distance =
                #(playerCoords - vector3(Config.LeaveLocation.x, Config.LeaveLocation.y, Config.LeaveLocation.z))

            if distance < 5.0 then
                sleep = 0
                ESX.DrawBasicMarker(Config.LeaveLocation, 255, 0, 0)

                if distance < 1.5 then
                    isInMarker = true
                    currentMarker = 1
                    markerLocation = {
                        x = Config.LeaveLocation.x,
                        y = Config.LeaveLocation.y,
                        z = Config.LeaveLocation.z
                    }
                    exports["lrp-interaction"]:Interaction(
                        {r = "255", g = "0", b = "0"},
                        "[E] - Loods verlaten",
                        Config.LeaveLocation,
                        2.5,
                        "loods_marker",
                        Config.LeaveLocation
                    )
                    if isInMarker and IsControlJustReleased(0, 38) then
                        TriggerEvent("loodsen:showLeaveMenu")
                    end
                else
                    exports["lrp-interaction"]:clearInteraction()
                end
            end

            Citizen.Wait(sleep)
        end
    end
)

RegisterNetEvent("loodsen:noLoodsFound")
AddEventHandler("loodsen:noLoodsFound", function()
            TriggerEvent('okokNotify:Alert', "Error", "Geen loods gevonden.", 5000, 'error')
    end
)

Citizen.CreateThread(function()
    ESX.TriggerServerCallback("loodsen:getLoodsData", function(loodsData)
        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local isInMarker = false
            local currentMarker = nil
            local markerLocation = nil
            local sleep = 1000

            for _, loods in ipairs(loodsData) do
                local location = json.decode(loods.location)
                local distance = #(playerCoords - vector3(location.x, location.y, location.z))

                if distance < 5.0 then
                    sleep = 0
                    ESX.DrawBasicMarker(location, 0, 255, 0)

                    if distance < 1.5 then
                        isInMarker = true
                        currentMarker = loods.id
                        markerLocation = {x = location.x, y = location.y, z = location.z}

                        exports["lrp-interaction"]:Interaction(
                            {r = "0", g = "255", b = "0"},
                            "[E] - Loods menu",
                            location,
                            2.5,
                            "loods_marker",
                            location
                        )

                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("loodsen:openMenu", markerLocation, loods.id)
                        end
                    else
                        exports["lrp-interaction"]:clearInteraction()
                    end
                end
            end

            Citizen.Wait(sleep)
        end
    end)
end)


RegisterNetEvent("loodsen:setLoodsArea")
AddEventHandler("loodsen:setLoodsArea",function(location)
     local interiorCoords = vector3(location.x, location.y, location.z)
     SetEntityCoords(PlayerPedId(), interiorCoords.x, interiorCoords.y, interiorCoords.z)
 end)

RegisterNetEvent("loodsen:startPlukken")
AddEventHandler("loodsen:startPlukken", function()
    TriggerServerEvent("loodsen:plukken")
end)

RegisterNetEvent("loodsen:startWassen")
AddEventHandler("loodsen:startWassen", function()
    TriggerServerEvent("loodsen:wassen")
end)

RegisterNetEvent("loodsen:notifyBlip")
AddEventHandler(
    "loodsen:notifyBlip",
    function(identifier, amount)
        local blip = AddBlipForCoord(Config.WashLocation.x, Config.WashLocation.y, Config.WashLocation.z)
        SetBlipSprite(blip, 1)
        SetBlipColour(blip, 2)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Mushroom Sale")
        EndTextCommandSetBlipName(blip)

        Citizen.Wait(20000)
        RemoveBlip(blip)
    end
)

RegisterNetEvent("loodsen:showLeaveMenu")
AddEventHandler(
    "loodsen:showLeaveMenu",
    function()
        ESX.TriggerServerCallback(
            "loodsen:isOwner",
            function(isOwner)
                local elements = {
                    {label = "Invite spelers", value = "invite"},
                    {label = "Verlaat loods", value = "leave"}
                }

                if isOwner then
                    table.insert(elements, {label = "Beheer upgrades", value = "upgrades"})
                    table.insert(elements, {label = "Geef sleutels", value = "givekey"})
                    table.insert(elements, {label = "Haal sleutels weg", value = "removekey"})
                    table.insert(elements, {label = "Verkoop Opslag", value = "sellstorage"})
                end

                ESX.UI.Menu.Open(
                    "default",
                    GetCurrentResourceName(),
                    "loodsen_leave_menu",
                    {
                        title = "Loods opties",
                        align = "top-right",
                        elements = elements
                    },
                    function(data, menu)
                        if data.current.value == "invite" then
                            TriggerEvent("loodsen:invitePlayers")
                        elseif data.current.value == "givekey" then
                            TriggerEvent("loodsen:giveKeys")
                        elseif data.current.value == "removekey" then
                            TriggerServerEvent("loodsen:getInhabitantsList")
                        elseif data.current.value == "leave" then
                            TriggerServerEvent("loodsen:getLoodsCoords")
                        elseif data.current.value == "upgrades" then
                            Seeupgrades()
                        elseif data.current.value == "sellstorage" then
                            TriggerServerEvent("jtm-loodsen:server:tpOutsideLoods")
                        end
                        menu.close()
                    end,
                    function(data, menu)
                        menu.close()
                    end
                )
            end,
            loodsId
        )
    end
)
Seeupgrades = function()
    ESX.UI.Menu.CloseAll()
    local elements = {}
    local currentUpgrade = nil
    ESX.TriggerServerCallback("jtm-loodsen:getupgrades", function(bought)
                currentUpgrade = bought[1].upgrades
            end)
    Citizen.Wait(100)
    for k,v in pairs(Config.upgrades) do
        local price = v.price
        if price then
            local currentUpdatePrice = Config.upgrades[tonumber(currentUpgrade) + 1].price
            if price > currentUpdatePrice then
                price = price - currentUpdatePrice
            end
            print(currentUpdatePrice)
            if v.value == tonumber(currentUpgrade) then
                table.insert(elements, {
                	label = ('%s - <span style="color:lightblue;">HUIDIG</span>'):format(v.string),
                	name = v.string,
                	price = price,
            	})
            else
                table.insert(elements, {
                	label = ('%s - <span style="color:green;">%s</span>'):format(v.string, "€" .. ESX.Math.GroupDigits(price)),
                	name = v.string,
                	price = price,
                	value = v.value
            	})
			end
            
        else
            TriggerEvent('okokNotify:Alert', "Error", "Er is iets fout gegaan, probeer het later opnieuw.", 5000, 'error')
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrades', {
        title    = 'Upgrades',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
            ESX.TriggerServerCallback("jtm-loodsen:server:buyupgrades", function(bought)
                if bought then
                    menu.close()
                    for k,v in pairs(Config.upgrades) do
                        if v.value == data.current.value then
            				TriggerEvent('okokNotify:Alert', "Gelukt!", "Je hebt upgrade: " .. v.string .. " gekocht!", 5000, 'success')
                        end
                    end
                end
            end, loods, data.current.name, data.current.price, data.current.value, loodscoords)
    end, function(data, menu)
        menu.close()
        menuOpen = false
    end)
end

RegisterNetEvent("loodsen:invitePlayers")
AddEventHandler(
    "loodsen:invitePlayers",
    function()
        TriggerServerEvent("loodsen:getNearbyPlayers")
    end
)

RegisterNetEvent("loodsen:receiveNearbyPlayers")
AddEventHandler(
    "loodsen:receiveNearbyPlayers",
    function(players, coords)
        local playersElement = {}
        for _, player in ipairs(players) do
            table.insert(playersElement, {label = "Invite " .. player.name, value = player.id})
        end
        ESX.UI.Menu.Open(
            "default",
            GetCurrentResourceName(),
            "loodsen_invite_menu",
            {
                title = "Invite spelers",
                align = "top-right",
                elements = playersElement
            },
            function(data, menu)
                TriggerServerEvent("loodsen:sendInvite", data.current.value, coords)
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    end
)
RegisterNetEvent("loodsen:setLoodsCoords")
AddEventHandler(
    "loodsen:setLoodsCoords",
    function(x, y, z)
        local teleportLocation = vector3(x, y, z)
        local heading = 175.9785

        DoScreenFadeOut(400)
        Citizen.Wait(500)

        SetEntityHeading(PlayerPedId(), heading)
        SetEntityCoords(
            PlayerPedId(),
            teleportLocation.x,
            teleportLocation.y,
            teleportLocation.z,
            false,
            false,
            false,
            true
        )
        TriggerServerEvent("loodsen:setRoutingBucket", 0)
        Citizen.Wait(500)
        DoScreenFadeIn(500)
    end
)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vector3(x, y, z))
    local scale = 0.35 / dist

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(1)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
RegisterNetEvent("loodsen:receiveInvitation")
AddEventHandler(
    "loodsen:receiveInvitation",
    function(senderId, loodsCoords)
        local senderName = GetPlayerName(GetPlayerFromServerId(senderId))
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(loodsCoords.x, loodsCoords.y, loodsCoords.z))

        if distance > 10.0 then
            TriggerEvent('okokNotify:Alert', "Error", "Je bent te ver weg om de uitnodiging te accepteren.", 5000, 'error')
            return
        end

        ESX.UI.Menu.Open(
            "default",
            GetCurrentResourceName(),
            "loodsen_invitation_menu",
            {
                title = "Uitnodiging van " .. senderName,
                align = "top-right",
                elements = {
                    {label = "Accepteren", value = "accept"},
                    {label = "Afwijzen", value = "decline"}
                }
            },
            function(data, menu)
                if data.current.value == "accept" then
                    playerCoords = GetEntityCoords(playerPed)
                    TriggerServerEvent("loodsen:acceptInvite", senderId, playerCoords, loodsCoords)
                elseif data.current.value == "decline" then
                    TriggerServerEvent("loodsen:declineInvite", senderId)
                end
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    end
)

RegisterNetEvent("loodsen:teleportToLoods")
AddEventHandler(
    "loodsen:teleportToLoods",
    function(senderRouting)
        local teleportLocation = vector3(1065.8849, -3183.4270, -39.1635)
        local heading = 175.9785
        exports["lrp-interaction"]:clearInteraction()
        DoScreenFadeOut(400)
        Citizen.Wait(500)
        SetEntityHeading(PlayerPedId(), heading)
        SetEntityCoords(
            PlayerPedId(),
            teleportLocation.x,
            teleportLocation.y,
            teleportLocation.z,
            false,
            false,
            false,
            true
        )
        TriggerServerEvent("loodsen:setRoutingBucket", senderRouting)

        Citizen.Wait(500)
        DoScreenFadeIn(500)

        exports["lrp-interaction"]:clearInteraction()
    end
)

RegisterNetEvent("loodsen:giveKeys")
AddEventHandler(
    "loodsen:giveKeys",
    function(title, placeholder, callback)
        ShowInputDialog(
            "",
            "Voer het id van de speler in:",
            function(input)
                TriggerServerEvent("loodsen:grantKey", input)
            end
        )
    end
)

function ShowInputDialog(defaultText, placeholderText, callback)
    AddTextEntry("FMMC_KEY_TIP1", placeholderText)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", defaultText, "", "", "", 128)
    while UpdateOnscreenKeyboard() == 0 do
        Citizen.Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local result = GetOnscreenKeyboardResult()
        if callback then
            callback(result)
        end
    end
end

RegisterNetEvent("loodsen:receiveInhabitantsList")
AddEventHandler(
    "loodsen:receiveInhabitantsList",
    function(inhabitantsList)
        local elements = {}
        for _, inhabitant in ipairs(inhabitantsList) do
            table.insert(elements, {label = inhabitant.name, value = inhabitant.identifier})
        end
        ESX.UI.Menu.Open(
            "default",
            GetCurrentResourceName(),
            "remove_key_menu",
            {
                title = "Sleutels weghalen",
                align = "top-right",
                elements = elements
            },
            function(data, menu)
                local selectedIdentifier = data.current.value
                TriggerServerEvent("loodsen:removeKey", selectedIdentifier)
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    end
)

Citizen.CreateThread(
    function()
        local computerLocation = vector3(Config.ComputerLocation.x, Config.ComputerLocation.y, Config.ComputerLocation.z)
        local distanceThreshold = 1.0

        while true do

            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - computerLocation)
            local sleep = 1000

            if distance < distanceThreshold then
                sleep = 0
                DisplayHelpText("Press ~INPUT_CONTEXT~ to interact with the computer.")

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("loodsen:openComputerNui")
                end
            end
            Citizen.Wait(sleep)
        end
    end
)

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("loodsen:sendOpslagData")
AddEventHandler(
    "loodsen:sendOpslagData",
    function(opslagData, maxopslagData)
        SendNUIMessage(
            {
                action = "show",
                opslag = opslagData,
                maxopslag = maxopslagData
            }
        )
    end
)

RegisterNetEvent("loodsen:sendOpslagDataOwner")
AddEventHandler(
    "loodsen:sendOpslagDataOwner",
    function(opslagData, maxopslagData)
        SendNUIMessage(
            {
                action = "showowner",
                opslag = opslagData,
                maxopslag = maxopslagData
            }
        )
    end
)
RegisterCommand(
    "createLoods",
    function(source, args, rawCommand)
        local loodsId = tonumber(args[1])

        if not loodsId then
            TriggerEvent('okokNotify:Alert', "Error", "Gebruik: /createLoods [ID]", 5000, 'error')
            return
        end

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local location = json.encode({x = pos.x, y = pos.y, z = pos.z})

        TriggerServerEvent("loodsen:createLoods", loodsId, location)
    end,
    false
)



RegisterCommand('setloodsen', function()
    local upgradeIPLs = {
        'weed_upgrade_equip',               -- Equipment upgrade
        'light_growtha_stage23_upgrade',    -- Lighting upgrade A
        'light_growthb_stage23_upgrade',    -- Lighting upgrade B
        'light_growthc_stage23_upgrade',    -- Lighting upgrade C
        'light_growthd_stage23_upgrade',    -- Lighting upgrade D
        'light_growthe_stage23_upgrade',    -- Lighting upgrade E
        'light_growthf_stage23_upgrade',    -- Lighting upgrade F
        'light_growthg_stage23_upgrade',    -- Lighting upgrade G
        'light_growthh_stage23_upgrade',    -- Lighting upgrade H
        'light_growthi_stage23_upgrade',    -- Lighting upgrade I
        'weed_security_upgrade'             -- Security upgrade
    }

    for _, ipl in ipairs(upgradeIPLs) do
        RequestIpl(ipl)
    end

    local interiorID = GetInteriorAtCoords(1051.491, -3196.536, -39.14842)

    if IsValidInterior(interiorID) then
        RefreshInterior(interiorID)
    end
end)

RegisterCommand('unsetloodsen', function()
    local upgradeIPLs = {
        'weed_upgrade_equip',               -- Equipment upgrade
        'light_growtha_stage23_upgrade',    -- Lighting upgrade A
        'light_growthb_stage23_upgrade',    -- Lighting upgrade B
        'light_growthc_stage23_upgrade',    -- Lighting upgrade C
        'light_growthd_stage23_upgrade',    -- Lighting upgrade D
        'light_growthe_stage23_upgrade',    -- Lighting upgrade E
        'light_growthf_stage23_upgrade',    -- Lighting upgrade F
        'light_growthg_stage23_upgrade',    -- Lighting upgrade G
        'light_growthh_stage23_upgrade',    -- Lighting upgrade H
        'light_growthi_stage23_upgrade',    -- Lighting upgrade I
        'weed_security_upgrade'             -- Security upgrade
    }

    for _, ipl in ipairs(upgradeIPLs) do
        RemoveIpl(ipl)
    end

    local interiorID = GetInteriorAtCoords(1051.491, -3196.536, -39.14842)

    if IsValidInterior(interiorID) then
        RefreshInterior(interiorID)
    end
end)

local lastSellLocation = nil
local isCarryingBox = false
local vehicle = nil
local currentSellLocation = nil
local oldblip = nil
local boxModel = GetHashKey("prop_cardbordbox_04a")
local deliveryTimeout = nil

RegisterNetEvent('jtm-loodsen:client:tpOutsideLoods')
AddEventHandler('jtm-loodsen:client:tpOutsideLoods', function(x, y, z, heading)
    ESX.TriggerServerCallback('jtm-loodsen:server:checkOpslagAmount', function(canSell)
        if canSell then
            SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
            SetEntityHeading(PlayerPedId(), heading)

            local model = GetHashKey("youga3")
            RequestModel(model)

            while not HasModelLoaded(model) do
                Wait(500)
            end
            
            if DoesBlipExist(oldblip) then
                RemoveBlip(oldblip)
            end
            
            vehicle = CreateVehicle(model, x, y, z, heading, true, false)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            
            SetVehicleRadioEnabled(vehicle, false)
            SetVehicleNumberPlateText(vehicle, "LOODS")
            SetModelAsNoLongerNeeded(model)

            repeat
                currentSellLocation = Config.SellLocations[math.random(#Config.SellLocations)]
            until currentSellLocation ~= lastSellLocation
            lastSellLocation = currentSellLocation

            oldblip = AddBlipForCoord(currentSellLocation.x, currentSellLocation.y, currentSellLocation.z)
            SetBlipRoute(oldblip, 1)

            CreateTrunkMarker(vehicle, currentSellLocation)
            TriggerEvent('okokNotify:Alert', "Info", "Ga naar de waypoint op je map om je goederen te verkopen.", 10000, 'warning')

            StartDeliveryTimeout(vehicle)
        else
            TriggerEvent('okokNotify:Alert', "Error", "Opslag in je loods is te laag om te verkopen.", 10000, 'error')
        end
    end)
end)

function StartDeliveryTimeout(vehicle)
    if deliveryTimeout then
        Citizen.ClearTimeout(deliveryTimeout)
    end

    deliveryTimeout = Citizen.SetTimeout(900000, function()
        if isCarryingBox == false then
            TriggerEvent('okokNotify:Alert', "Timeout", "Je hebt te lang gewacht, de run is verlopen.", 10000, 'error')
            EndDeliveryRun(vehicle)
        end
    end)
end

function EndDeliveryRun(vehicle)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end

    if DoesBlipExist(oldblip) then
        RemoveBlip(oldblip)
    end

    isCarryingBox = false
    currentSellLocation = nil
    lastSellLocation = nil
end

function CreateTrunkMarker(vehicle, currentSellLocation)
    Citizen.CreateThread(function()
        while not isCarryingBox do
            local sleep = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())
            local trunkCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -2.5, 0.0)
            local sellLocation = vector3(currentSellLocation.x, currentSellLocation.y, currentSellLocation.z)

            if #(playerCoords - trunkCoords) < 3.0 and not IsPedInAnyVehicle(PlayerPedId(), false) and #(playerCoords - sellLocation) < 50.0 then
                sleep = 0
                DrawMarker(1, trunkCoords.x, trunkCoords.y, trunkCoords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, nil, nil, false)
                DisplayHelpText("Druk op ~INPUT_CONTEXT~ om de doos te pakken.")

                if IsControlJustReleased(0, 38) then
                    TakeCardboardBox(vehicle)
                    break
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

function TakeCardboardBox(vehicle)
    local boxModel = 'prop_cardbordbox_02a'

    RequestModel(boxModel)
    while not HasModelLoaded(boxModel) do
        Wait(500)
    end

    local animDict = "anim@heists@box_carry@"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local box = CreateObject(boxModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)

    AttachEntityToEntity(box, playerPed, GetPedBoneIndex(playerPed, 57005), 0.1, -0.1, -0.5, 0.0, 280.0, 0.0, false, false, false, false, 2, true)

    TaskPlayAnim(playerPed, animDict, "idle", 8.0, -8.0, -1, 49, 0, false, false, false)

    isCarryingBox = true

    CreateSellMarker(vehicle)
end

function CreateSellMarker(vehicle)
    Citizen.CreateThread(function()
        while isCarryingBox do
            local sleep = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())

            if #(playerCoords - vector3(currentSellLocation.x, currentSellLocation.y, currentSellLocation.z)) < 15.0 then
                sleep = 0
                DrawMarker(1, currentSellLocation.x, currentSellLocation.y, currentSellLocation.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 100, false, true, 2, false, nil, nil, false)
                if #(playerCoords - vector3(currentSellLocation.x, currentSellLocation.y, currentSellLocation.z)) < 3.0 then
                    DisplayHelpText("Druk op ~INPUT_CONTEXT~ om de doos af te leveren.")
                    if IsControlJustReleased(0, 38) then

                        DeliverBox(vehicle)
                        break
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end


function DeliverBox(vehicle)
    local boxModel = 'prop_cardbordbox_02a'
    local playerPed = PlayerPedId()

    FreezeEntityPosition(playerPed, true)
    TriggerEvent('okokNotify:Alert', "Info", "Goederen afleveren...", 5000, 'info')

    local box = GetClosestObjectOfType(GetEntityCoords(playerPed), 2.0, boxModel, false, false, false)
    if box then
        DetachEntity(box, false, false)
        DeleteObject(box)
    end
    ClearPedTasksImmediately(playerPed)
    isCarryingBox = false
    local deliveryCoords = GetEntityCoords(vehicle)

    TriggerServerEvent('jtm-loodsen:server:notifyPoliceAndKmar', deliveryCoords)
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.Wait(15000)

    ClearPedTasksImmediately(playerPed)
    FreezeEntityPosition(playerPed, false)
    TriggerEvent('okokNotify:Alert', "Success", "De goederen zijn afgeleverd.", 5000, 'success')

    

    ESX.TriggerServerCallback('jtm-loodsen:server:deliverGoods', function(success)
        if success then
            TriggerEvent('jtm-loodsen:client:tpOutsideLoods', deliveryCoords.x, deliveryCoords.y, deliveryCoords.z, GetEntityHeading(vehicle))
            SetEntityAsMissionEntity(vehicle, true, true)
            if DoesEntityExist(vehicle) and success then
                DeleteVehicle(vehicle)
            end
        else
            TriggerEvent('okokNotify:Alert', "Error", "Kan geen nieuwe ronde starten. Te weinig opslag.", 5000, 'error')
            if DoesBlipExist(oldblip) then
                RemoveBlip(oldblip)
            end
        end
    end)
end



RegisterNetEvent('jtm-loodsen:client:createBlip')
AddEventHandler('jtm-loodsen:client:createBlip', function(coords)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 3)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Goederen Afgeleverd")
    EndTextCommandSetBlipName(blip)
    SetNewWaypoint(coords)
    Citizen.SetTimeout(30000, function()
        RemoveBlip(blip)
    end)
end)


local blips = {}

function showLoodsBlips(blipData)
    if blipData then
        for _, loods in pairs(blipData) do
            local exists = false

            for _, blipInfo in pairs(blips) do
                if blipInfo.id == loods.id then
                    exists = true
                    break
                end
            end

            if not exists then
                local blip = AddBlipForCoord(loods.x, loods.y, loods.z)

                SetBlipSprite(blip, 140)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, 2)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Gekochte Loods")
                EndTextCommandSetBlipName(blip)

                table.insert(blips, {id = loods.id, blip = blip})
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        ESX.TriggerServerCallback('jtm-loodsen:server:getLoodsBlips', function(blipData)
            if blipData then
                showLoodsBlips(blipData)
            else
                for _, blipInfo in pairs(blips) do
                    RemoveBlip(blipInfo.blip)
                end
                blips = {}
            end
        end)
            
        Citizen.Wait(10000) 
    end
end)


Citizen.CreateThread(function()
    local menus = {
        "loodsen_menu",
        "loodsen_leave_menu",
        "loodsen_invite_menu",
        "loodsen_invitation_menu",
        "remove_key_menu"
    }

    while true do
        Citizen.Wait(0)

        for _, menuName in ipairs(menus) do
            if ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), menuName) then
                if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
                    ESX.UI.Menu.CloseAll()
                end
            end
        end
    end
end)
