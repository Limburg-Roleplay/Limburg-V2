---@diagnostic disable: lowercase-global
-- Gemaakt door discord.gg/jtm

-- Local's

local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local ShopOpen = false
JobName = nil
local PlayerData = {}
local JobName = nil
local Blipgang = nil
local canCuff = false

-- Local's

-- F6 Menu + actions begin

isAllowed = false

local mainElements = {
    { label = "Fouilleren",         value = "fouilleren" },
    { label = "Tie-wrap gebruiken", value = "cuff" },
    { label = "Tie-wrap losmaken",  value = "uncuff" },
    { label = "Begeleiden",         value = "escort" },
    { label = "In/uit voertuig",    value = "invoertuig" },
    { label = "Handboeien losbreken", value = "losbreken" },
    { label = "Radio aflezen",      value = "readradio" }
}

local keybind = lib.addKeybind({
    name = 'crimif6',
    description = 'F6-menu criminele organisaties',
    defaultKey = 'F6',
    onReleased = function(self)
        if IsActionAllowed() then
            OpenInteractionMenu()
        end
    end,
})

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    local temp = false

    for gangName, gangData in pairs(Config.Wapeninkoopgangs) do
        if ESX.PlayerData.job.name == gangName and gangData.f6menu then
            temp = true
            isAllowed = true
            keybind:disable(false)
            break
        end

        if ESX.PlayerData.job2.name == gangName and gangData.f6menu then
            temp = true
            isAllowed = true
            keybind:disable(false)
            break
        end
    end

    if not temp then
        isAllowed = false
        keybind:disable(true)
    end
end)

function IsActionAllowed()
    local hasPerm = false
    for gangName, gangData in pairs(Config.Wapeninkoopgangs) do
        if ESX.PlayerData.job.name == gangName and gangData.f6menu then
            -- print("gangname = " .. gangName)
            hasPerm = true
            break
        end
        if ESX.PlayerData.job2.name == gangName and gangData.f6menu then
            -- print("gangname = " .. gangName)
            hasPerm = true
            break
        end
    end

    if not hasPerm then
        -- print("gangname = " .. gangName)
        keybind:disable(true)
    end
    return hasPerm
end

function OpenClosestPlayersMenu()
    local players = {}
    local playerPed = PlayerPedId()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer ~= -1 and closestDistance <= 50.0 then
        table.insert(players, {
            label = "Speler " .. GetPlayerServerId(closestPlayer),
            value = closestPlayer
        })

        for _, player in ipairs(GetPlayers()) do
            if player ~= closestPlayer then
                local ped = GetPlayerPed(player)
                local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(ped))
                if distance <= 50.0 then
                    table.insert(players, {
                        label = "Speler " .. GetPlayerServerId(player),
                        value = player
                    })
                end
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_selection', {
            title = 'Selecteer een speler',
            align = 'top-right',
            elements = players
        }, function(data, menu)
            local selectedPlayer = data.current.value
            menu.close()
            OpenInteractionMenu(selectedPlayer)
        end, function(data, menu)
            menu.close()
        end)
    else
        exports['okokNotify']:Alert('Fout', 'Geen spelers dichtbij gevonden!', 5000, 'error')
    end
end

RegisterCommand('rs', function()
    local closestPlayer, targetDistance = ESX.Game.GetClosestPlayer()
    local maxDistance = 3.0

    if closestPlayer ~= -1 and targetDistance <= maxDistance and not IsPedInAnyVehicle(PlayerPedId(), false) then
        TriggerServerEvent('lrp-gangmenu:requestSearch', GetPlayerServerId(closestPlayer))
    else
        exports['okokNotify']:Alert('Fout', 'Geen spelers dichtbij gevonden!', 5000, 'error')
    end
end, false)


RegisterNetEvent('lrp-gangmenu:searchResponse')
AddEventHandler('lrp-gangmenu:searchResponse', function(targetId, accepted)
    if accepted then
        ESX.TriggerServerCallback('lrp-gangmenu:getInventoryItems', function(items)
            local ped = PlayerPedId()
            local p1 = GetEntityCoords(ped, true)
            local p2 = GetEntityCoords(GetPlayerPed(targetId), true)

            local dx = p2.x - p1.x
            local dy = p2.y - p1.y

            local heading = GetHeadingFromVector_2d(dx, dy)
            SetEntityHeading(ped, heading)
            FreezeEntityPosition(ped, true)

            ExecuteCommand('e parkingmeter')
            LocalPlayer.state.blockEmotes = true

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
                title = 'Fouilleer Menu',
                align = 'top-right',
                elements = items
            }, function(data, menu)
            end, function(data, menu)
                menu.close()
                LocalPlayer.state.blockEmotes = false
                FreezeEntityPosition(ped, false)
                ClearPedTasks(PlayerPedId())
            end)
        end, targetId)
    else
        exports['okokNotify']:Alert('Geweigerd', 'Fouileer verzoek is geweigerd', 4000, 'info')
    end
end)

RegisterNetEvent('lrp-gangmenu:notifySearchRequest')
AddEventHandler('lrp-gangmenu:notifySearchRequest', function(requesterId)
    exports["okokNotify"]:Alert("Fouilleerverzoek",
        "Speler " .. requesterId .. " Wilt je fouileren . Druk op Y om te accepteren en Z om te weigeren.", 4000, 'info')
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustReleased(0, 246) then
                TriggerServerEvent('lrp-gangmenu:searchResponse', requesterId, true)
                break
            elseif IsControlJustReleased(0, 20) then
                TriggerServerEvent('lrp-gangmenu:searchResponse', requesterId, false)
                break
            end
        end
    end)
end)

local isBezigMetRadio = false

function OpenInteractionMenu()
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "gang_main", {
        title = ESX.PlayerData.job.label,
        align = 'top-right',
        elements = mainElements
    }, function(data, menu)
        local playerPed = PlayerPedId()
        local targetPlayer, targetDistance = ESX.Game.GetClosestPlayer()
        local targetPed = GetPlayerPed(targetPlayer)
        local targetPedId = GetPlayerServerId(targetPed)
        local playerServerId = GetPlayerServerId(PlayerId())
        if DoesEntityExist(targetPed) then
            

            if data.current.value == "fouilleren" then
                if targetDistance ~= -1 and targetDistance <= 3.0 then
                    -- Check if the target player is performing the "hands up" animation
                    local animDict = "missminuteman_1ig_2"
                    local animName = "handsup_enter"

                    if IsEntityPlayingAnim(targetPed, animDict, animName, 3) then
                        -- Check if the player is armed
                        if IsPedArmed(playerPed, 6) then -- 6 checks for all types of weapons
                            -- Target player is performing the hands up animation and the player is armed, open ox inventory
                            menu.close()

                            -- Log details for opening inventory
                            local sellerName = GetPlayerName(PlayerId())
                            local targetPlayerName = GetPlayerName(targetPlayer)

                            local logTitle = "[" ..
                                playerServerId ..
                                "] " ..
                                sellerName ..
                                " heeft de inventaris van [" ..
                                GetPlayerServerId(targetPlayer) ..
                                "] " .. targetPlayerName .. " geopend met Gang F6 toestemming"
                            local logDesc = "Details:\n" ..
                                "Beheerder: " .. sellerName .. "\n" ..
                                "Doelpunt: " .. targetPlayerName .. "\n" ..
                                "Actie: Openen van inventaris\n" ..
                                "Locatie: " ..
                                string.format("(%s, %s, %s)", GetEntityCoords(playerPed).x, GetEntityCoords(playerPed).y,
                                    GetEntityCoords(playerPed).z)



                            -- Send log to Discord
                            -- TriggerServerEvent('td_logs:sendLog',
                            --     'https://discord.com/api/webhooks/1275949042207162400/gNhZPQLXFJSuun3viU9FR-QdmIWZg87AgtzVkmZD-K8Fz8mblO0FkLYuUqHyMrVNgSiI',
                            --     GetPlayerServerId(PlayerId()),
                            --     {
                            --         title = logTitle,
                            --         desc = logDesc
                            --     },
                            --     0xffffff
                            -- )

                            TriggerServerEvent('jtm_gangjob:sendLog', GetPlayerServerId(PlayerId()), {
                                title = logTitle,
                                desc = logDesc
                            }, 0xffffff)

                            TriggerServerEvent('jtm-gangjob:notification', GetPlayerServerId(targetPlayer))
                            TriggerEvent('ox_inventory:openInventory', 'player', GetPlayerServerId(targetPlayer))
                        else
                            exports['okokNotify']:Alert('Fout', 'Je moet bewapend zijn om iemand te fouilleren.', 5000,
                                'error')
                        end
                    else
                        exports['okokNotify']:Alert('Fout', 'De speler heeft zijn handen niet omhoog.', 5000, 'error')
                    end
                else
                    exports['okokNotify']:Alert('Fout', 'Geen speler dichtbij.', 5000, 'error')
                end
            elseif data.current.value == "cuff" then
                TriggerEvent('jtm-development:client:cuff:player', { entity = targetPed })
            elseif data.current.value == "losbreken" then
                TriggerEvent('jtm-development:client:losbreken:player', { entity = targetPed })
            elseif data.current.value == "uncuff" then
                TriggerEvent('jtm-development:client:uncuff:player', { entity = targetPed })
            elseif data.current.value == "escort" then
                TriggerEvent('jtm-development:client:dragging', { entity = targetPed })
            elseif data.current.value == "invoertuig" then
                TriggerEvent('jtm-development:client:set:player:vehicle', { entity = targetPed })

                -- elseif data.current.value == "uitvoertuig" then

                --     if IsPedInAnyVehicle(GetPlayerServerId(targetPed), true) == true then
                --         TriggerEvent('jtm-development:client:set:player:vehicle', { entity = targetPed })
                --     else
                --         exports['okokNotify']:Alert('Fout', 'Persoon zit niet in een voertuig', 5000, 'error')
                --     end
            elseif data.current.value == "readradio" then
                if isBezigMetRadio then
                    return
                end

                if targetDistance ~= -1 and targetDistance <= 3.0 then -- Check if player is close enough
                    isBezigMetRadio = true
                    local ped = PlayerPedId()
                    local p1 = GetEntityCoords(ped, true)
                    local p2 = GetEntityCoords(targetPed, true)

                    local dx = p2.x - p1.x
                    local dy = p2.y - p1.y

                    local heading = GetHeadingFromVector_2d(dx, dy)
                    -- FreezeEntityPosition(ped, true)

                    if lib.progressBar({
                            duration = 5000,
                            label = 'Radio aan het zoeken...',
                            canCancel = true,
                            useWhileDead = false,
                            anim = {
                                dict = 'anim@gangops@facility@servers@bodysearch@',
                                clip = 'player_search'
                            },
                            disable = {
                                move = true,
                                sprint = true
                            }
                        }) then
                        ClearPedTasks(PlayerPedId())
                        isBezigMetRadio = false
                        TriggerServerEvent('jtm-development:client:read:radio', GetPlayerServerId((targetPlayer)))
                    else
                        ClearPedTasks(PlayerPedId())
                        lib.cancelProgress()
                        isBezigMetRadio = false
                        return
                    end
                else
                    exports['okokNotify']:Alert('Fout', 'Geen speler dichtbij.', 5000, 'error')
                end
            end
        else
            exports['okokNotify']:Alert('Fout', 'Geen speler dichtbij.', 5000, 'error')
        end
    end, function(data, menu)
        menu.close()
    end)
    Citizen.CreateThread(
        function()
            while ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "gang_main") do
                Citizen.Wait(0)
                if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
                    ESX.UI.Menu.CloseAll()
                end
            end
        end
    )
end

function OpenBodySearchMenu(targetPlayer)
    local closestPlayer = targetPlayer
    local maxDistance = 3.0
    local playerPed = PlayerPedId()
    local ped = GetPlayerPed(closestPlayer)
    local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(ped))

    if closestPlayer ~= -1 and distance <= maxDistance and not IsPedInAnyVehicle(playerPed, false) then
        ESX.TriggerServerCallback('lrp-gangmenu:getInventoryItems', function(items)
            -- Debug: Print the items received

            -- Send the notification to the target player
            TriggerServerEvent('lrp-gangmenu:sendNotification', closestPlayer, GetPlayerServerId(PlayerId()))

            local p1 = GetEntityCoords(playerPed, true)
            local p2 = GetEntityCoords(ped, true)

            local dx = p2.x - p1.x
            local dy = p2.y - p1.y

            local heading = GetHeadingFromVector_2d(dx, dy)
            SetEntityHeading(playerPed, heading)
            FreezeEntityPosition(playerPed, true)

            PlayBodySearchAnimation()
            LocalPlayer.state.blockEmotes = true

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
                title = 'Fouilleer Menu',
                align = 'top-right',
                elements = items
            }, function(data, menu)
                -- Handle item selection
            end, function(data, menu)
                menu.close()
                OpenInteractionMenu(closestPlayer)
                LocalPlayer.state.blockEmotes = false
                FreezeEntityPosition(playerPed, false)
            end)
        end, GetPlayerServerId(closestPlayer))
    else
        exports['okokNotify']:Alert('Fout', 'Geen speler dichtbij of speler zit in een voertuig!', 5000, 'error')
    end
end

function PlayBodySearchAnimation()
    local playerPed = PlayerPedId()



    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Citizen.Wait(100)
    end

    -- local scenario = "PROP_HUMAN_PARKING_METER"

    if not IsPedOnFoot(playerPed) or not IsPedHuman(playerPed) then
        return
    end

    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, -1, 1, 0, false, false, false)
    Citizen.Wait(5000)
    ClearPedTasks(playerPed)

    -- TaskStartScenarioInPlace(playerPed, scenario, 0, true)
    -- ClearPedTasks(playerPed)
end

exports("OpenBodySearchMenu", OpenBodySearchMenu)

-- F6 Menu + actions eind

-- Gang Blip Begin

local function SetBlipForGang(JobName)
    if Config.Blip and Config.Wapeninkoopgangs[JobName] ~= nil then
        local ped = PlayerPedId()
        local x, y, z = Config.Wapeninkoopgangs[JobName][1].coordswapeninkoop.x,
            Config.Wapeninkoopgangs[JobName][1].coordswapeninkoop.y,
            Config.Wapeninkoopgangs[JobName][1].coordswapeninkoop.z

        if Blipgang ~= nil then
            RemoveBlip(Blipgang)
        end

        Blipgang = AddBlipForCoord(x, y, z)
        SetBlipSprite(Blipgang, 378)
        SetBlipColour(Blipgang, 0)
        SetBlipScale(Blipgang, 0.75)
        SetBlipAsShortRange(Blipgang, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Gang: " .. JobName)
        EndTextCommandSetBlipName(Blipgang)
    elseif not Config.Blip and Blipgang ~= nil then
        RemoveBlip(Blipgang)
        Blipgang = nil
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    PlayerData = playerData


    if Config.Wapeninkoopgangs[PlayerData.job.name] then
        JobName = PlayerData.job.name
    elseif Config.Wapeninkoopgangs[PlayerData.job2.name] then
        JobName = PlayerData.job2.name
    end

    if JobName then
        SetBlipForGang(JobName)
    else
        return
    end
    SetBlipForGang(JobName)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    if Config.Wapeninkoopgangs[PlayerData.job.name] then
        JobName = PlayerData.job.name
    elseif Config.Wapeninkoopgangs[PlayerData.job2.name] then
        JobName = PlayerData.job2.name
    end
    if JobName then
        SetBlipForGang(JobName)
    else
        return
    end
    SetBlipForGang(JobName)
end)

local function isPlayerWhitelisted()
    local playerJob = PlayerData.job and PlayerData.job.name
    local playerJob2 = PlayerData.job2 and PlayerData.job2.name
    if playerJob ~= nil and Config.Wapeninkoopgangs[playerJob] ~= nil then
        return true
    elseif playerJob2 ~= nil and Config.Wapeninkoopgangs[playerJob2] ~= nil
    then
        return true
    else
        return false
    end
end

Citizen.CreateThread(function()
    while ESX == nil do
        Wait(0)
        ESX = exports["es_extended"]:getSharedObject()
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    if Config.Wapeninkoopgangs[PlayerData.job.name] then
        JobName = PlayerData.job.name
    elseif Config.Wapeninkoopgangs[PlayerData.job2.name] then
        JobName = PlayerData.job2.name
    end
    SetBlipForGang(JobName)
end)

-- Gang blip eind

RegisterNetEvent('jtm-gangjob:OpenShopMenu')
AddEventHandler('jtm-gangjob:OpenShopMenu', function()
    OpenShopMenu()
end)

RegisterNetEvent('jtm-development:client:losbreken:player')
AddEventHandler('jtm-development:client:losbreken:player', function(targetPed)

    local entityPlayer = ESX.Game.GetPlayerFromPed(targetPed)
    
    local closestPlayer = entityPlayer
    local maxDistance = 4.0
    local playerPed = PlayerPedId()
    local ped = GetPlayerPed(closestPlayer)
    local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(ped))

    if closestPlayer ~= -1 and distance <= maxDistance and not IsPedInAnyVehicle(playerPed, false) then
        ESX.TriggerServerCallback('jtm-development:police:getCuffedTarget', function(cb)
            if cb == true then
                TriggerEvent('jtm-development:police:client:uncuff:player', { entity = targetPed })
            else
                exports['okokNotify']:Alert('Fout', 'Deze speler is niet geboeid door de politie!', 5000, 'error')
            end
        end, GetPlayerServerId(entityPlayer))
    else
        exports['okokNotify']:Alert('Fout', 'Geen speler dichtbij of speler zit in een voertuig!', 5000, 'error')
    end




    

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CooldownEnabled then
            Citizen.Wait(15000)
            CooldownEnabled = false
        end
    end
end)

-- Witwas Menu

local missionBlips = {}
local activeBlips = {}
local vehicle = nil
local missionActive = false
local amountToKeep = 0
local lastWitwasTime = 0
local requiredVehicleHash = GetHashKey("brickade")
local missionStarted = false

local function formatMoney(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

local function getRandomLocation(locations)
    if #locations == 0 then
        return nil
    end
    local index = math.random(1, #locations)
    return locations[index]
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        lastWitwasTime = 0
        missionActive = false
        missionStarted = false
        if vehicle then
            DeleteVehicle(vehicle)
            vehicle = nil
        end
        for _, blip in pairs(activeBlips) do
            RemoveBlip(blip)
        end
        activeBlips = {}
    end
end)

RegisterNetEvent('jtm-witwas:newMission')
AddEventHandler('jtm-witwas:newMission', function(src)
end)

RegisterNetEvent('jtm-witwas:updateBlip')
AddEventHandler('jtm-witwas:updateBlip', function(src, position)
    if activeBlips[src] then
        RemoveBlip(activeBlips[src])
    end
    local blip = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blip, 67)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Witwas Bus")
    EndTextCommandSetBlipName(blip)
    activeBlips[src] = blip
end)

RegisterNetEvent('jtm-witwas:removeBlip')
AddEventHandler('jtm-witwas:removeBlip', function(playerId)
    local blip = activeBlips[playerId]
    if blip then
        RemoveBlip(blip)
        activeBlips[playerId] = nil
    end
end)

function OpenWitwasMenu()
    if missionStarted then
        exports['okokNotify']:Alert('Fout', 'Je kunt deze missie niet opnieuw starten totdat de cooldown voorbij is.',
            5000, 'error')
        return
    end

    local currentTime = GetGameTimer() / 1000
    local cooldownTime = 1800

    if (lastWitwasTime + cooldownTime) > currentTime and missionActive then
        local remainingTime = math.ceil(lastWitwasTime + cooldownTime - currentTime)
        exports['okokNotify']:Alert('Fout', 'Je kunt deze missie pas weer starten na ' .. remainingTime .. ' seconden.',
            5000, 'error')
        return
    end

    -- Haal de configuratie op voor de huidige gang
    local jobData = Config.Wapeninkoopgangs[JobName]

    -- Controleer of de jobData correct is
    if not jobData then
        exports['okokNotify']:Alert('Fout', 'Onbekende gang of configuratie niet gevonden.', 5000, 'error')
        return
    end

    local startCoords = jobData[1].Startcoordswitwas

    -- Controleer of de startcoördinaten correct zijn opgehaald
    if not startCoords then
        exports['okokNotify']:Alert('Fout', 'Onbekende startcoördinaten gevonden.', 5000, 'error')
        print("Startcoordswitwas niet gevonden. Controleer je configuratie.")
        return
    end

    local gangName = JobName

    if exports.ox_inventory:GetItemCount("black_money") > 1000000 then
        local input = lib.inputDialog(Config.WitwasMissie.title, {
            {
                type = 'number',
                label = 'Witwas Missie menu',
                description = 'Hoeveel geld wil je inzetten op deze missie?'
            }
        })

        if not input then return end

        local amount = input[1]
        local playerMoney = exports.ox_inventory:GetItemCount("black_money")

        if amount < 1000000 then
            exports['okokNotify']:Alert('Fout', 'Je moet minimaal 1 miljoen inzetten op deze missie', 5000, 'error')
            return
        elseif amount > playerMoney then
            exports['okokNotify']:Alert('Fout', 'Je hebt niet genoeg zwart geld op zak!', 5000, 'error')
            return
        end

        amountToKeep = amount
        RequestModel(requiredVehicleHash)

        while not HasModelLoaded(requiredVehicleHash) do
            Wait(1)
        end

        local player = PlayerPedId()
        local heading = startCoords.heading or 0.0
        vehicle = CreateVehicle(requiredVehicleHash, startCoords.x, startCoords.y, startCoords.z, heading, true, false)
        SetPedIntoVehicle(player, vehicle, -1)
        SetModelAsNoLongerNeeded(requiredVehicleHash)

        if activeBlips[PlayerPedId()] then
            RemoveBlip(activeBlips[PlayerPedId()])
        end

        local witwasLocatie = getRandomLocation(Config.WitwasMissie.Aflevercoordswitwas)

        if not witwasLocatie then
            exports['okokNotify']:Alert('Fout', 'Geen witwaslocaties gevonden.', 5000, 'error')
            return
        end

        local blip = AddBlipForCoord(witwasLocatie.x, witwasLocatie.y, witwasLocatie.z)
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Witwas Locatie")
        EndTextCommandSetBlipName(blip)
        SetBlipRoute(blip, true)

        activeBlips[PlayerPedId()] = blip

        TriggerServerEvent('jtm-witwas:startMission', amount)
        lastWitwasTime = currentTime
        missionActive = true
        missionStarted = true

        Citizen.CreateThread(function()
            local timer = GetGameTimer() / 1000
            local inVehicle = true
            local notificationShown = false
            local textUIVisible = false

            local function updateBlip()
                while missionActive do
                    local waitTime = math.random(10000, 20000)
                    Citizen.Wait(waitTime)
                    if missionActive then
                        local playerPos = GetEntityCoords(PlayerPedId())
                        TriggerServerEvent('jtm-witwas:updateLocation', playerPos)
                    end
                end
            end

            Citizen.CreateThread(updateBlip)

            while missionActive do
                Citizen.Wait(0)
                local playerPos = GetEntityCoords(PlayerPedId())
                local distance = #(playerPos - witwasLocatie)

                if exports.ox_inventory:GetItemCount("black_money") < amountToKeep then
                    exports['okokNotify']:Alert('Witwas Stop',
                        'Witwasmissie geannuleerd omdat je niet genoeg zwart geld meer hebt.', 3000, 'error')
                    RemoveBlip(activeBlips[PlayerPedId()])
                    DeleteVehicle(vehicle)
                    missionActive = false
                    missionStarted = false
                    if textUIVisible then
                        lib.hideTextUI()
                        textUIVisible = false
                    end
                    return
                end

                if distance < 20.0 then
                    if not textUIVisible then
                        lib.showTextUI('[E] - Witwas voltooien', { position = "right-center" })
                        textUIVisible = true
                    end
                    DrawMarker(1, witwasLocatie.x, witwasLocatie.y, witwasLocatie.z - 1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0,
                        5.0, 0, 255, 0, 150, false, false, 2, false, nil, nil, false)
                    if distance < 1.5 then
                        if IsControlJustReleased(0, 38) then
                            if GetEntityModel(vehicle) ~= requiredVehicleHash then
                                exports['okokNotify']:Alert('Fout', 'Dit is niet het juiste voertuig voor de missie!',
                                    5000, 'error')
                                RemoveBlip(activeBlips[PlayerPedId()])
                                DeleteVehicle(vehicle)
                                missionActive = false
                                missionStarted = false
                                if textUIVisible then
                                    lib.hideTextUI()
                                    textUIVisible = false
                                end
                                return
                            end

                            local totalWitwasAmount = amount
                            TriggerServerEvent('jtm-witwas:witwasmissie', amount)
                            RemoveBlip(activeBlips[PlayerPedId()])
                            DeleteVehicle(vehicle)
                            missionActive = false
                            missionStarted = false
                            if textUIVisible then
                                lib.hideTextUI()
                                textUIVisible = false
                            end
                            return
                        end
                    end
                else
                    if textUIVisible then
                        lib.hideTextUI()
                        textUIVisible = false
                    end
                end

                if IsPedInVehicle(PlayerPedId(), vehicle, false) then
                    if not inVehicle then
                        notificationId = nil
                        notificationShown = false
                    end
                    timer = GetGameTimer() / 1000
                    inVehicle = true
                else
                    if inVehicle then
                        if not notificationShown then
                            if notificationId then
                                exports['okokNotify']:Remove(notificationId)
                            end
                            notificationId = exports['okokNotify']:Alert('Waarschuwing',
                                'Je hebt 20 seconden om terug in je voertuig te stappen zo niet? dan word de missie geannuleerd!',
                                10000, 'warning', true)
                            notificationShown = true
                        end
                        inVehicle = false
                    end

                    if (GetGameTimer() / 1000 - timer) > 20 then
                        exports['okokNotify']:Alert('Witwas Stop',
                            'Witwasmissie geannuleerd omdat je niet terug in je voertuig bent gestapt.', 3000, 'error')
                        RemoveBlip(activeBlips[PlayerPedId()])
                        DeleteVehicle(vehicle)
                        missionActive = false
                        missionStarted = false
                        TriggerServerEvent('jtm-witwas:endMission')
                        if textUIVisible then
                            lib.hideTextUI()
                            textUIVisible = false
                        end
                        return
                    end
                end
            end
        end)
    else
        exports['okokNotify']:Alert('Fout', 'Je hebt niet genoeg zwart geld om te witwassen!', 5000, 'error')
    end
end

-- Witwas Menu


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        if isPlayerWhitelisted() then
            local jobData = Config.Wapeninkoopgangs[JobName] -- Assuming JobName is correctly defined elsewhere
            if jobData and jobData[1] then
                local gangCoords = jobData[1].coordswapeninkoop
                if gangCoords then
                    local dist = GetDistanceBetweenCoords(coords, gangCoords) <= Config.Markerdistance
                    local dist2 = GetDistanceBetweenCoords(coords, gangCoords) <= 1.5
                    local waitdistance = #(coords - gangCoords)
                    if dist then
                        ESX.DrawBasicMarker(gangCoords, 50, 50, 204)
                        if dist2 then
                            exports['frp-interaction']:Interaction({ r = '0', g = '74', b = '154' },
                                '[E] - Open Gang Menu', gangCoords, 2.5,
                                GetCurrentResourceName() .. '-action-' .. tostring(k))
                            if IsControlJustReleased(1, 38) then
                                Citizen.Wait(100)
                                if jobData[1].ganglevel == 5 then
                                    lib.showContext('gangmenu5')
                                elseif jobData[1].ganglevel == 4 then
                                    lib.showContext('gangmenu4')
                                elseif jobData[1].ganglevel == 3 then
                                    lib.showContext('gangmenu3')
                                elseif jobData[1].ganglevel == 2 then
                                    lib.showContext('gangmenu2')
                                else
                                    lib.showContext('gangmenu')
                                end
                            end
                        end
                    end
                end
            end
        else
            Wait(6000)
        end
    end
end)




lib.registerContext(
    {
        id = "gangmenu",
        title = "Gang Menu: Level 1",
        options = {
            {
                title = "Gang Inkoop",
                description = "Bekijk alle mogelijkheden om in te kopen",
                menu = "wapeninkoop",
                icon = "gun"
            },
            {
                title = "Gezamelijke Gang Stash",
                description = "Open je Gezamelijke gangstash",
                onSelect = function()
                    exports.ox_inventory:openInventory('stash', { id = JobName .. '_stash' })
                end,
                icon = "fa-brands fa-dropbox"
            },
            {
                title = "Persoonlijke Gang Stash",
                description = "Open je Persoonlijke gangstash",
                onSelect = function()
                    local identifier = ESX.PlayerData.identifier
                    exports.ox_inventory:openInventory('stash',
                        { id = 'Persoonlijkeopslag', owner = '' .. JobName .. '_' .. identifier .. '' })
                    print 'Stash....'
                end,
                icon = "box"
            },
            {
                title = "Gang Level",
                description = "Bekijk het level van je gang!",
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = '**Gang Level 1!**',
                        content = '🌟 Je gang is Level 1! Dit is het laagste Level! 🌟',
                        centered = true,
                        cancel = true
                    })
                end,
                icon = "star"
            }
        }
    }
)

lib.registerContext(
    {
        id = "gangmenu2",
        title = "Gang Menu: Level 2",
        options = {
            {
                title = "Gang Inkoop",
                description = "Bekijk alle mogelijkheden om in te kopen",
                menu = "wapeninkoop2",
                icon = "gun"
            },
            {
                title = "Gezamelijke Gang Stash",
                description = "Open je Gezamelijke gangstash",
                onSelect = function()
                    exports.ox_inventory:openInventory('stash', { id = JobName .. '_stash' })
                end,
                icon = "fa-brands fa-dropbox"
            },
            {
                title = "Persoonlijke Gang Stash",
                description = "Open je Persoonlijke gangstash",
                onSelect = function()
                    local identifier = ESX.PlayerData.identifier
                    exports.ox_inventory:openInventory('stash',
                        { id = 'Persoonlijkeopslag', owner = '' .. JobName .. '_' .. identifier .. '' })
                end,
                icon = "box"
            },
            {
                title = "Gang Level",
                description = "Bekijk het level van je gang!",
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = '**Gang Level 2!**',
                        content = '🌟 Je gang is Level 2! Dit kan beter! 🌟',
                        centered = true,
                        cancel = true
                    })
                end,
                icon = "star"
            }
        }
    }
)

lib.registerContext(
    {
        id = "gangmenu3",
        title = "Gang Menu: Level 3",
        options = {
            {
                title = "Gang Inkoop",
                description = "Bekijk alle mogelijkheden om in te kopen",
                menu = "wapeninkoop3",
                icon = "gun"
            },
            {
                title = "Gezamelijke Gang Stash",
                description = "Open je Gezamelijke gangstash",
                onSelect = function()
                    exports.ox_inventory:openInventory('stash', { id = JobName .. '_stash' })

                end,
                icon = "fa-brands fa-dropbox"
            },
            {
                title = "Persoonlijke Gang Stash",
                description = "Open je Persoonlijke gangstash",
                onSelect = function()
                    local identifier = ESX.PlayerData.identifier
                    exports.ox_inventory:openInventory('stash',
                        { id = 'Persoonlijkeopslag', owner = '' .. JobName .. '_' .. identifier .. '' })
                    print 'Stash....'
                end,
                icon = "box"
            },
            {
                title = "Gang Level",
                description = "Bekijk het level van je gang!",
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = '**Gang Level 3!**',
                        content = '🌟 Je gang is Level 3! Goed Bezig! 🌟',
                        centered = true,
                        cancel = true
                    })
                end,
                icon = "star"
            }
        }
    }
)

lib.registerContext(
    {
        id = "gangmenu4",
        title = "Gang Menu: Level 4",
        options = {
            {
                title = "Gang Inkoop",
                description = "Bekijk alle mogelijkheden om in te kopen",
                menu = "wapeninkoop4",
                icon = "gun"
            },
            {
                title = "Gezamelijke Gang Stash",
                description = "Open je Gezamelijke gangstash",
                onSelect = function()
                    exports.ox_inventory:openInventory('stash', { id = JobName .. '_stash' })

                end,
                icon = "fa-brands fa-dropbox"
            },
            {
                title = "Persoonlijke Gang Stash",
                description = "Open je Persoonlijke gangstash",
                onSelect = function()
                    local identifier = ESX.PlayerData.identifier
                    exports.ox_inventory:openInventory('stash',
                        { id = 'Persoonlijkeopslag', owner = '' .. JobName .. '_' .. identifier .. '' })
                    print 'Stash....'
                end,
                icon = "box"
            },
            {
                title = "Gang Level",
                description = "Bekijk het level van je gang!",
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = '**Gang Level 4!**',
                        content = '🌟 Je gang is Level 4! Dit is het ena hoogste Level! 🌟',
                        centered = true,
                        cancel = true
                    })
                end,
                icon = "star"
            }
        }
    }
)

lib.registerContext(
    {
        id = "gangmenu5",
        title = "Gang Menu: Level 5",
        options = {
            {
                title = "Gang Inkoop",
                description = "Bekijk alle mogelijkheden om in te kopen",
                menu = "wapeninkoop5",
                icon = "gun"
            },
            {
                title = "Gezamelijke Gang Stash",
                description = "Open je Gezamelijke gangstash",
                onSelect = function()
                    exports.ox_inventory:openInventory('stash', { id = JobName .. '_stash' })
                end,
                icon = "fa-brands fa-dropbox"
            },
            {
                title = "Persoonlijke Gang Stash",
                description = "Open je Persoonlijke gangstash",
                onSelect = function()
                    local identifier = ESX.PlayerData.identifier
                    exports.ox_inventory:openInventory('stash',
                        { id = 'Persoonlijkeopslag', owner = '' .. JobName .. '_' .. identifier .. '' })
                    print 'Stash....'
                end,
                icon = "box"
            },
            {
                title = "Gang Level",
                description = "Bekijk het level van je gang!",
                onSelect = function()
                    local alert = lib.alertDialog({
                        header = '**Gang Level 5!**',
                        content = '🌟 Je gang is Level 5! Dit is het maximale Level! 🌟',
                        centered = true,
                        cancel = true
                    })
                end,
                icon = "star"
            }
        }
    }
)


function gunshop(gangnaam)
    local options = {}


    ESX.TriggerServerCallback('jtm-gangjob:gunshop:getvoorraad', function(cb)
        for _, wapennaam in ipairs(Config.wapen_volgorde) do
            local voorraad = cb[wapennaam]
            local maxVoorraad = Config.Wapeninkoopgangs[gangnaam].wapeninkoop[wapennaam]
            local wapenlabel = Config.wapen_labels[wapennaam]
            local wapenkosten = Config.wapen_prijzen[wapennaam]
            local disabled = false
            if voorraad == 0 then
                disabled = true
            end

            local verkocht = maxVoorraad - voorraad
            local percentage = (verkocht / maxVoorraad) * 100
            if maxVoorraad == 0 and voorraad == 0 then
                percentage = 0
            end

            local percentageInText = string.format("%.0f", percentage)

            --'     - ' .. percentageInText .. '% gekocht', voor als je de percentage wil toevoegen!

            local tabel = {
                title = wapenlabel,
                icon = Config.wapen_icons[wapennaam],
                description = 'Koop een ' ..
                    wapenlabel .. ' voor €' .. wapenkosten .. ',- \n' .. 'Voorraad: ' .. voorraad .. '/' .. maxVoorraad,
                onSelect = function()
                    koopWapen(gangnaam, wapennaam)
                end,
                disabled = disabled
            }

            table.insert(options, tabel)
        end




        lib.registerContext(
            {
                id = "gunwinkel",
                title = "Gang Inkoop",
                options = options
            }


        )

        lib.showContext('gunwinkel')
    end, gangnaam)
end

function koopWapen(gangnaam, wapen)
    local wapenSpawnName = Config.wapen_spawnnames[wapen]
    TriggerServerEvent('jtm-gangjob:koopwapen', gangnaam, wapenSpawnName, wapen)
end

lib.registerContext(
    {
        id = "wapeninkoop",
        title = "Gang: Winkels Level 1",
        options = {
            {
                title = "Wapen Winkel",
                description = "Bekijk de wapens die op voorraad zijn!",
                icon = "gun",
                onSelect = function()
                    gunshop(JobName)
                    -- Hier naar menu met alle wapens !!
                    -- exports.ox_inventory:openInventory("shop", { type = "gangshop" })
                end
            },
            {
                title = "Ammo Winkel",
                description = "Bekijk alle mogelijke ammosoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopammo" })
                end
            },
            {
                title = "Attachment Winkel",
                description = "Bekijk alle mogelijke attachmentsoorten die we hebben in de kluis!",
                icon = "gun",
                menu = "weaponattachments",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopattachments" })
                end
            },
            {
                title = "Extra Winkel",
                description = "Bekijk alle mogelijke handcuffs die we hebben in de kluis!",
                icon = "shop",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "extra" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('opslag')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)



lib.registerContext(
    {
        id = "wapeninkoop2",
        title = "Gang: Winkels Level 2",
        options = {
            {
                title = "Wapen Winkel",
                description = "Bekijk alle mogelijke wapensoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    gunshop(JobName)
                    -- Hier naar menu met alle wapens !!
                    -- exports.ox_inventory:openInventory("shop", { type = "gangshop2" })
                end
            },
            {
                title = "Ammo Winkel",
                description = "Bekijk alle mogelijke ammosoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopammo2" })
                end
            },
            {
                title = "Attachment Winkel",
                description = "Bekijk alle mogelijke attachmentsoorten die we hebben in de kluis!",
                icon = "gun",
                menu = "weaponattachments2",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopattachments2" })
                end
            },
            {
                title = "Extra Winkel",
                description = "Bekijk alle mogelijke handcuffs die we hebben in de kluis!",
                icon = "shop",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "extra2" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('opslag')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "wapeninkoop3",
        title = "Gang: Winkels Level 3",
        options = {
            {
                title = "Wapen Winkel",
                description = "Bekijk alle mogelijke wapensoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    gunshop(JobName)
                    -- Hier naar menu met alle wapens !!
                    -- exports.ox_inventory:openInventory("shop", { type = "gangshop3" })
                end
            },
            {
                title = "Ammo Winkel",
                description = "Bekijk alle mogelijke ammosoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopammo3" })
                end
            },
            {
                title = "Attachment Winkel",
                description = "Bekijk alle mogelijke attachmentsoorten die we hebben in de kluis!",
                icon = "gun",
                menu = "weaponattachments3",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopattachments3" })
                end
            },
            {
                title = "Extra Winkel",
                description = "Bekijk alle mogelijke handcuffs die we hebben in de kluis!",
                icon = "shop",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "extra3" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('opslag')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "wapeninkoop4",
        title = "Gang: Winkels Level 4",
        options = {
            {
                title = "Wapen Winkel",
                description = "Bekijk alle mogelijke wapensoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    gunshop(JobName)
                    -- Hier naar menu met alle wapens !!
                    -- exports.ox_inventory:openInventory("shop", { type = "gangshop4" })
                end
            },
            {
                title = "Ammo Winkel",
                description = "Bekijk alle mogelijke ammosoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopammo4" })
                end
            },
            {
                title = "Attachment Winkel",
                description = "Bekijk alle mogelijke attachmentsoorten die we hebben in de kluis!",
                icon = "gun",
                menu = "weaponattachments4",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopattachments4" })
                end
            },
            {
                title = "Extra Winkel",
                description = "Bekijk alle mogelijke handcuffs die we hebben in de kluis!",
                icon = "shop",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "extra4" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('opslag')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "wapeninkoop5",
        title = "Gang: Winkels Level 5",
        options = {
            {
                title = "Wapen Winkel",
                description = "Bekijk alle mogelijke wapensoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    gunshop(JobName)
                    -- Hier naar menu met alle wapens !!
                    -- exports.ox_inventory:openInventory("shop", { type = "gangshop5" })
                end
            },
            {
                title = "Ammo Winkel",
                description = "Bekijk alle mogelijke ammosoorten die we hebben in de kluis!",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopammo5" })
                end
            },
            {
                title = "Attachment Winkel",
                description = "Bekijk alle mogelijke attachmentsoorten die we hebben in de kluis!",
                icon = "gun",
                menu = "weaponattachments5",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopattachments5" })
                end
            },
            {
                title = "Extra Winkel",
                description = "Bekijk alle mogelijke handcuffs die we hebben in de kluis!",
                icon = "shop",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "extra5" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('opslag')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "weaponattachments",
        title = "Gang: Attachments",
        options = {
            {
                title = "Suppressors",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopsuppressors" })
                end
            },
            {
                title = "Scopes",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopscopes" })
                end
            },
            {
                title = "Magazines",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopmagazines" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('wapeninkoop')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "weaponattachments2",
        title = "Gang: Attachments",
        options = {
            {
                title = "Suppressors",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopsuppressors2" })
                end
            },
            {
                title = "Scopes",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopscopes2" })
                end
            },
            {
                title = "Magazines",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopmagazines2" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('wapeninkoop2')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "weaponattachments3",
        title = "Gang: Attachments",
        options = {
            {
                title = "Suppressors",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopsuppressors3" })
                end
            },
            {
                title = "Scopes",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopscopes3" })
                end
            },
            {
                title = "Magazines",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopmagazines3" })
                end
            },
            {
                title = "Grips",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopgrips3" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('wapeninkoop3')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "weaponattachments4",
        title = "Gang: Attachments",
        options = {
            {
                title = "Suppressors",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopsuppressors4" })
                end
            },
            {
                title = "Scopes",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopscopes4" })
                end
            },
            {
                title = "Magazines",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopmagazines4" })
                end
            },
            {
                title = "Grips",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopgrips4" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('wapeninkoop4')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

lib.registerContext(
    {
        id = "weaponattachments5",
        title = "Gang: Attachments",
        options = {
            {
                title = "Suppressors",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopsuppressors5" })
                end
            },
            {
                title = "Scopes",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopscopes5" })
                end
            },
            {
                title = "Magazines",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopmagazines5" })
                end
            },
            {
                title = "Grips",
                icon = "gun",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", { type = "gangshopgrips5" })
                end
            },
            {
                title = 'Ga terug',
                onSelect = function()
                    lib.showContext('wapeninkoop5')
                end,
                icon = 'fas fa-arrow-left'
            }
        }
    }
)

Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Laten staan s.v.p, Anders start de bossmenu niet goed op vanwege inladen ESX

    while true do
        local sleep = 500
        local coords = GetEntityCoords(PlayerPedId())
        local jobData = nil

        for gangName, gangData in pairs(Config.Wapeninkoopgangs) do
            if ESX.PlayerData.job.name == gangData[1].gangname and ESX.PlayerData.job.grade >= gangData[1].mingrade then
                local dist = #(coords - gangData[1].coordsbossmenu)
                if dist < 10 then
                    sleep = 0
                    ESX.DrawBasicMarker(gangData[1].coordsbossmenu, 255, 0, 0)
                    if dist < 2.5 then
                        exports['frp-interaction']:Interaction('error', '[E] - Boss Menu ', gangData[1].coordsbossmenu,
                            2.5, GetCurrentResourceName() .. '-action-' .. tostring(gangName))
                        if IsControlJustReleased(1, 38) then
                            Citizen.Wait(100)
                            jobData = gangData[1] -- Set jobData to current gangData
                            if jobData.ganglevel == 5 then
                                lib.showContext('bossmenu5')
                            elseif jobData.ganglevel == 4 then
                                lib.showContext('bossmenu4')
                            elseif jobData.ganglevel == 3 then
                                lib.showContext('bossmenu3')
                            elseif jobData.ganglevel == 2 then
                                lib.showContext('bossmenu2')
                            else
                                lib.showContext('bossmenu')
                            end
                        end
                    end
                end
            elseif ESX.PlayerData.job2.name == gangData[1].gangname and ESX.PlayerData.job2.grade >= gangData[1].mingrade then
                local dist = #(coords - gangData[1].coordsbossmenu)
                if dist < 10 then
                    sleep = 0
                    ESX.DrawBasicMarker(gangData[1].coordsbossmenu, 255, 0, 0)
                    if dist < 2.5 then
                        exports['frp-interaction']:Interaction('error', '[E] - Boss Menu ', gangData[1].coordsbossmenu,
                            2.5, GetCurrentResourceName() .. '-action-' .. tostring(gangName))
                        if IsControlJustReleased(1, 38) then
                            Citizen.Wait(100)
                            jobData = gangData[1] -- Set jobData to current gangData
                            if jobData.ganglevel == 5 then
                                lib.showContext('bossmenu5')
                            elseif jobData.ganglevel == 4 then
                                lib.showContext('bossmenu4')
                            elseif jobData.ganglevel == 3 then
                                lib.showContext('bossmenu3')
                            elseif jobData.ganglevel == 2 then
                                lib.showContext('bossmenu2')
                            else
                                lib.showContext('bossmenu')
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)


lib.registerContext({
    id = 'bossmenu',
    title = 'Boss Menu',
    options = {
        {
            title = 'Persoon Aannemen',
            description = 'Neem een persoon aan.',
            icon = 'box',
            onSelect = function()
                Neempersonenaan()
            end,
        },
        {
            title = "Gang Boss Stash",
            description = "Open je Gang Boss Stash",
            onSelect = function()
                exports.ox_inventory:openInventory('stash', {
                    id = 'opslag_leiding',
                    owner = '' ..
                        JobName .. '_opslag_leiding'
                })
                print 'Leiding Stash....'
            end,
            icon = "fa-brands fa-dropbox"
        },
        {
            title = 'Beheer Members',
            description = 'Beheer al je gang members.',
            icon = 'clipboard',
            onSelect = function()
                Checkpersons()
            end,
        },
    }
})

lib.registerContext({
    id = 'bossmenu2',
    title = 'Boss Menu: Level 2',
    options = {
        {
            title = 'Persoon Aannemen',
            description = 'Neem een persoon aan.',
            icon = 'box',
            onSelect = function()
                Neempersonenaan()
            end,
        },
        {
            title = "Gang Boss Stash",
            description = "Open je Gang Boss Stash",
            onSelect = function()
                exports.ox_inventory:openInventory('stash', {
                    id = 'opslag_leiding',
                    owner = '' ..
                        JobName .. '_opslag_leiding'
                })
                print 'Leiding Stash....'
            end,
            icon = "fa-brands fa-dropbox"
        },
        {
            title = 'Beheer Members',
            description = 'Beheer al je gang members.',
            icon = 'clipboard',
            onSelect = function()
                Checkpersons()
            end,
        },
    }
})

lib.registerContext({
    id = 'bossmenu3',
    title = 'Boss Menu: Level 3',
    options = {
        {
            title = 'Persoon Aannemen',
            description = 'Neem een persoon aan.',
            icon = 'box',
            onSelect = function()
                Neempersonenaan()
            end,
        },
        {
            title = "Gang Boss Stash",
            description = "Open je Gang Boss Stash",
            onSelect = function()
                exports.ox_inventory:openInventory('stash', {
                    id = 'opslag_leiding',
                    owner = '' ..
                        JobName .. '_opslag_leiding'
                })
                print 'Leiding Stash....'
            end,
            icon = "fa-brands fa-dropbox"
        },
        {
            title = 'Beheer Members',
            description = 'Beheer al je gang members.',
            icon = 'clipboard',
            onSelect = function()
                Checkpersons()
            end,
        },
    }
})

lib.registerContext({
    id = 'bossmenu4',
    title = 'Boss Menu: Level 4',
    options = {
        {
            title = 'Persoon Aannemen',
            description = 'Neem een persoon aan.',
            icon = 'box',
            onSelect = function()
                Neempersonenaan()
            end,
        },
        {
            title = "Gang Boss Stash",
            description = "Open je Gang Boss Stash",
            onSelect = function()
                exports.ox_inventory:openInventory('stash', {
                    id = 'opslag_leiding',
                    owner = '' ..
                        JobName .. '_opslag_leiding'
                })
                print 'Leiding Stash....'
            end,
            icon = "fa-brands fa-dropbox"
        },
        {
            title = 'Beheer Members',
            description = 'Beheer al je gang members.',
            icon = 'clipboard',
            onSelect = function()
                Checkpersons()
            end,
        },
    }
})

lib.registerContext({
    id = 'bossmenu5',
    title = 'Boss Menu: Level 5',
    options = {
        {
            title = 'Persoon Aannemen',
            description = 'Neem een persoon aan.',
            icon = 'box',
            onSelect = function()
                Neempersonenaan()
            end,
        },
        {
            title = "Gang Boss Stash",
            description = "Open je Gang Boss Stash",
            onSelect = function()
                exports.ox_inventory:openInventory('stash', {
                    id = 'opslag_leiding',
                    owner = '' ..
                        JobName .. '_opslag_leiding'
                })
                print 'Leiding Stash....'
            end,
            icon = "fa-brands fa-dropbox"
        },
        {
            title = 'Witwas Missie',
            description = 'Witwas Missie menu openen!',
            icon = 'money-bill-1',
            onSelect = function()
                OpenWitwasMenu()
            end,
        },
        {
            title = 'Beheer Members',
            description = 'Beheer al je gang members.',
            icon = 'clipboard',
            onSelect = function()
                Checkpersons()
            end,
        },
    }
})

Checkpersons = function()
    local check = {}
    local speler = PlayerPedId()
    local jobnaam = JobName
    ESX.TriggerServerCallback("jtm-gangjob:check:gangmembers", function(datagang)
        for k, v in pairs(datagang) do
            table.insert(check, {
                title = v.voornaam .. " " .. v.achternaam,
                description = 'Rang: ' .. v.grade,
                icon = 'user',
                onSelect = function()
                    OpenMenumembersboss(v, jobnaam)
                end
            })
        end
        lib.registerContext({
            id = 'bossmenu-members',
            title = "Gang Menu | Personeel",
            options = check
        })
        lib.showContext('bossmenu-members')
    end, jobnaam)
end

OpenMenumembersboss = function(value, gangnaam)
    ESX.UI.Menu.CloseAll()

    local options = {
        {
            title = value.voornaam .. " Demoten",
            description = '',
            icon = 'fas fa-minus',
            onSelect = function()
                local input = lib.inputDialog(
                    'Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt degraderen?', {
                        { type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true },
                    })

                if not input[1] then
                    TriggerEvent('lrp-notifications', 'error',
                        'Je bent niet akkoord gegaan met deze medewerker te degraderen.')
                    return
                end
                DemotePlayer(value.identifier, value.voornaam, gangnaam)
            end
        },
        {
            title = value.voornaam .. " Promoveren",
            description = '',
            icon = 'fas fa-plus',
            onSelect = function()
                local input = lib.inputDialog(
                    'Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt promoveren?', {
                        { type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true },
                    })
                if not input[1] then
                    TriggerEvent('lrp-notifications', 'error',
                        'Je bent niet akkoord gegaan met deze medewerker te degraderen.')
                    return
                end
                PromotePlayer(value.identifier, value.voornaam, gangnaam)
            end
        },
        {
            title = value.voornaam .. " Ontslaan",
            description = '',
            icon = 'fas fa-fire',

            onSelect = function()
                local input = lib.inputDialog(
                    'Weet je zeker dat je ' .. value.voornaam .. ' ' .. value.achternaam .. ' wilt ontslaan?', {
                        { type = 'checkbox', label = 'Ja, ik weet het zeker!', required = true },
                    })

                if not input[1] then
                    TriggerEvent('lrp-notifications:client:notify', 'error',
                        'Je bent niet akkoord gegaan met deze medewerker te ontslaan.')
                    return
                end

                Deletemembersboss(value.identifier, value.voornaam, gangnaam)
            end
        },
        {
            title = 'Ga terug',
            onSelect = function()
                Checkpersons()
            end,
            icon = 'fas fa-arrow-left'
        }
    }

    lib.registerContext({
        id = 'bossmenu-members-boss',
        title = "Bossmenu",
        options = options
    })
    lib.showContext('bossmenu-members-boss')
end

function PromotePlayer(identifier, playerName, gangnaam)
    TriggerServerEvent("jtm-gangjob:promotemember", identifier, playerName, gangnaam)
end

function DemotePlayer(identifier, playerName, gangnaam)
    TriggerServerEvent("jtm-gangjob:demote", identifier, playerName, gangnaam)
end

function Deletemembersboss(x, y, z)
    TriggerServerEvent("jtm-gangjob:deletemember:serversided", x, y, z)
end

function Neempersonenaan()
    local gangnaam = JobName

    local input = lib.inputDialog('Gang Menu | Aannemen', {
        { label = 'Voer een speler id in', type = 'input', required = true },
        {
            label = 'Job1 of Job2?',
            type = 'select',
            default = 'job',
            options = {
                { label = 'Job1', value = 'job' },
                { label = 'Job2', value = 'job2' }
            }
        }
    }, {})
    if not input then
        return
    end

    local playerid = tonumber(input[1])
    local naarJob = input[2]

    if playerid then
        ESX.TriggerServerCallback('jtm-gangjob:add:playertogang', function(done)
            if done then
                -- exports['okokNotify']:Alert('Aangenomen', 'Persoon is succesvol aangenomen', 5000, 'succes')
            end
        end, playerid, gangnaam, naarJob)
    else
    end
end
