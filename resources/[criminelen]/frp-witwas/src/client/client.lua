-- // [VARIABLES] \\ --

local Exios = { Functions = { Utils = {} } }
local isWashing, isInRun = false
local routeBlip = nil

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

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(Job)
	ESX.PlayerData.job2 = Job
end)

function CreateNPC(model, coords, heading)
    local npcHash = GetHashKey(model)
    RequestModel(npcHash)
    while not HasModelLoaded(npcHash) do
        Wait(500)
    end
    local npcPed = CreatePed(4, npcHash, coords, heading, false, false)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)

    return npcPed
end

local npcCoords1 = vector3(-449.2009, -1724.4767, 18.6795-1)
local npcHeading1 = 76.0644

local blipCoords = vector3(-449.2009, -1724.4767, 18.6795) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 500) -- icon
SetBlipColour(blip, 40) -- color 
SetBlipScale(blip, 0.9) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Witwas Startlocatie") 
EndTextCommandSetBlipName(blip)

CreateThread(function()
    CreateNPC("cs_chengsr", npcCoords1, npcHeading1)
end)

-- // [THREADS] \\ --

CreateThread(function()
    ESX.TriggerServerCallback('exios-witwas:server:cb:get:shared', function(data)
        Shared = data
    end)
    while not Shared do Wait(0) end

    for i=1, #Shared.StartLocations do
        exports.ox_target:addSphereZone({
            coords = Shared.StartLocations[i]['coords'],
            options = {
                {
                    label = 'Witwassen',
                    icon = 'fas fa-clipboard',
                    distance = 1.5,
                    event = 'exios-witwas:client:start:cleaning',
                    args = { index = i },
                    items = { ['black_money'] = 1000 }
                }
            }
        })
    end
end)

-- // [EVENTS] \\ --
RegisterNetEvent('exios-witwas:client:start:cleaning')
AddEventHandler('exios-witwas:client:start:cleaning', function(data)
    local dist = #(GetEntityCoords(cache.ped) - Shared.StartLocations[data.args.index]['coords'])
    if dist > 1.5 then exports['frp-notifications']:notify('error', 'Deze actie is niet meer mogelijk, probeer het opnieuw') return end

    isInRun = true

    TriggerServerEvent('exios-witwas:server:start:cleaning', data.args.index)
end)

RegisterNetEvent('exios-witwas:client:started:cleaning')
AddEventHandler('exios-witwas:client:started:cleaning', function()
    if not isInRun then return end

    local locationNumber = math.random(1, #Shared.SellLocations)
    local location = Shared.SellLocations[locationNumber]

    local routeBlip = Exios.Functions.Utils.CreateBlip(location['coords'])
    ESX.ShowNotification('info', 'Ga naar de locatie die aangegeven staat op de map')

    while isInRun do 
        local sleep = 750
        local dist = #(GetEntityCoords(PlayerPedId()) - location['coords'])

        if dist <= 25.0 then 
            sleep = 0
            ESX.Game.Utils.DrawMarker(location['coords'], 2, 0.2, 33, 176, 23)
            if dist <= 3.0 and not IsPedInAnyVehicle(PlayerPedId(), false) and not isWashing then
                exports['frp-interaction']:Interaction('success', '[E] - Klop aan bij deur', location['coords'], 1.0, GetCurrentResourceName())
                if IsControlJustPressed(0, 38) then
                    ClearPedTasks(PlayerPedId())
                    isWashing = true
                    exports['frp-progressbar']:Progress({
                        name = 'exios-witwas/witwas/deliver',
                        duration = 15000,
                        label = 'Zwart geld afleveren',
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = 'timetable@jimmy@doorknock@',
                            anim = 'knockdoor_idle',
                            flags = 0,
                        },
                    }, function(cancelled)
                        ClearPedTasks(PlayerPedId())
                        TaskPlayAnim(PlayerPedId(), 'timetable@jimmy@doorknock@', 'exit', 3.0, 3.0, -1, 1, 0, false, false, false)
                        if not cancelled then
                            TriggerServerEvent('exios-witwas:server:delivered:witwas', locationNumber)

                            RemoveBlip(routeBlip)
                            locationNumber = math.random(1, #Shared.SellLocations)
                            location = Shared.SellLocations[locationNumber]
                            routeBlip = Exios.Functions.Utils.CreateBlip(location['coords'])  -- Create a new blip for the new location
                        else 
                            isWashing = false
                        end
                    end)
                end
            end
        end

        Wait(sleep)
    end
end)


RegisterNetEvent('exios-witwas:client:complete')
AddEventHandler('exios-witwas:client:complete', function(bool)
    isWashing = not bool
    if not bool then 
        isWashing = bool
        Exios.Functions.StopWitwas()
    end
end)

-- // [FUNCTIONS] \\ --

Exios.Functions.Utils.CreateBlip = function(coords)
    routeBlip = AddBlipForCoord(coords)
    SetBlipSprite(routeBlip, 465)
    SetBlipScale(routeBlip, 0.7)
    SetBlipColour(routeBlip, 1)
    SetBlipDisplay(routeBlip, 4)
    SetBlipAsShortRange(routeBlip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Deurklop locatie')
    EndTextCommandSetBlipName(routeBlip)
    SetBlipRoute(routeBlip, 1)
end

Exios.Functions.StopWitwas = function()
    RemoveBlip(routeBlip)
    exports["frp-notifications"]:Notify("error", "Je had niet genoeg Zwartgeld opzak! Of je hebt de missie handmatige gestopt!", 5000)
end

RegisterNetEvent('jtm-developmoney:client:witwas:stop')
AddEventHandler('jtm-developmoney:client:witwas:stop', function(bool)
    Exios.Functions.StopWitwas()
end)

TriggerEvent('chat:addSuggestion', '/stopwitwas', 'Stop het witwassen handmatig!')