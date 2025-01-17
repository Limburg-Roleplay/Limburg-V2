local function CreateCardSwipe()
    local card_swipe_coords = vec3(133.997, -762.857, 46.1)
    card_swipe = CreateObject(`tr_prop_tr_fp_scanner_01a`, card_swipe_coords.x, card_swipe_coords.y, card_swipe_coords.z - 0.2, true, true, false)
    SetEntityHeading(card_swipe, 337.5087)

    CardSwipeZone = exports.ox_target:addBoxZone({
        coords = vec3(card_swipe_coords.x, card_swipe_coords.y, card_swipe_coords.z),
        size = vec3(0.3, 0.3, 0.3),
        rotation = 360,
        debug = Config.Debugger,
        options = {
            {
                onSelect = function ()
                    TriggerEvent('nw-human-labs:client:StartCardSwipe', card_swipe_coords)
                    exports.ox_target:removeZone(CardSwipeZone)
                end,
                distance = Config.GeneralTargetDistance,
                icon = 'fa fa-credit-card',
                label = 'Swipe kaart',
            },
        }
    })
    return card_swipe_coords
end

--- @param custom_hash string
--- @param hash_name_door string
--- @param coords number
local function LockDoors(custom_hash, hash_name_door, coords)
    AddDoorToSystem(custom_hash, hash_name_door, coords.x, coords.y, coords.z)
    DoorSystemSetDoorState(custom_hash, 1)
end

--- @param blip_x number
--- @param blip_y number
--- @param blip_z number
--- @param sprite number
--- @param scale number
--- @param colour number
--- @param route boolean
--- @param blip_name string
function CreateBlip(blip_x, blip_y, blip_z, sprite, scale, colour, route, blip_name)
    local blip = AddBlipForCoord(blip_x, blip_y, blip_z)
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, colour)
    SetBlipRoute(blip, route)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blip_name)
    EndTextCommandSetBlipName(blip)
    return blip
end

--- @param prop_coords table
--- @param prop_hash string
--- @param event string
--- @param prop_heading number
--- @param fa_icon string
--- @param target_label string
--- @param use_blip boolean
--- @param blip_info string
function CreateProp(prop_coords, prop_hash, event, prop_heading, fa_icon, target_label, use_blip, blip_info)
    if use_blip then
        prop_blip = CreateBlip(prop_coords.x, prop_coords.y, prop_coords.z, blip_info[1], blip_info[2], blip_info[3], blip_info[4], blip_info[5])
    end

    while true do
        Wait(1500)
        local player = PlayerPedId()
        local player_coords = GetEntityCoords(player)
        local distance = #(player_coords - prop_coords)
        
        if distance < 200 then
            break
        end
    end

    local prop = CreateObject(prop_hash, prop_coords.x, prop_coords.y, prop_coords.z, true, false, false)
    SetEntityHeading(prop, prop_heading)
    
    if event ~= "StartPickingSerum" then
        PlaceObjectOnGroundProperly(prop)
    end

    boxZone = exports.ox_target:addBoxZone({
        coords = vec3(prop_coords.x, prop_coords.y, prop_coords.z),
        size = vec3(0.7, 0.7, 0.7),
        rotation = 360,
        debug = Config.Debugger,
        options = {
            {
                onSelect = function ()
                    TriggerEvent('nw-human-labs:client:'..event, {prop_coords, prop})
                    exports.ox_target:removeZone(boxZone)
                end,
                distance = Config.GeneralTargetDistance,
                icon = 'fa fa-'..fa_icon,
                label = target_label,
            },
        }
    })
end

CreateThread(function()
    for _, value in pairs(Config.HeistNPC) do
        RequestModel(GetHashKey(value.model))
        while not HasModelLoaded(GetHashKey(value.model)) do
            Wait(1)
        end

        npc = CreatePed(2, value.model, value.location.x, value.location.y, value.location.z - 1, value.location.w,  false, true)

        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)

        TaskStartScenarioInPlace(npc, 'WORLD_HUMAN_AA_SMOKE', 0, true)

        exports.ox_target:addBoxZone({
    coords = vec3(value.location.x, value.location.y, value.location.z),
    size = vec3(1, 1, 1),
    rotation = 360,
    debug = Config.Debugger,
    options = {
        {
            -- Using onSelect instead of serverEvent
            onSelect = function()
                -- Trigger the server event manually
                TriggerServerEvent('nw-human-labs:server:CheckIfHeistOccupied')
            end,
            distance = Config.GeneralTargetDistance,
            icon = 'fa fa-syringe',
            label = Config.Translations["HeistStart"].heist_title,
        },
    }
})
    end
end)

RegisterNetEvent("nw-human-labs:client:StartFirstPrep", function ()
    LockDoors(`fbi_elevator_left`, `v_ilev_fib_doore_l`, vector3(134.93751525879, -762.89825439453, 44.748867034912))
    LockDoors(`fbi_elevator_right`, `v_ilev_fib_doore_r`, vector3(136.35371398926, -763.41589355469, 44.74836730957))
    LockDoors(`human_labs_door_left`, `v_ilev_bl_shutter2`, vector3(3627.7131347656, 3746.7163085938, 27.69207572937))
    LockDoors(`human_labs_door_right`, `v_ilev_bl_shutter2`, vector3(3620.8427734375, 3751.5270996094, 27.69207572937))
    LockDoors(`fib_building_upstairs`, `v_ilev_fib_door2`, vector3(124.02368164062, -727.31359863281, 234.3017578125))
    lib.progressBar({
        duration = Config.Translations["Phases"].progressbar_timer, 
        position = 'bottom', 
        label = Config.Translations["Phases"].progress_label,
        canCancel = false, 
        anim = {
            dict = "misscarsteal4@actor", 
            lockX = true, 
            lockY = true, 
            lockZ = true, 
            clip = "actor_berating_loop"
        }
    })

    lib.notify({
        title = Config.Translations["Phases"].heist_boss_title,
        description = Config.Translations["Phases"]["FirstPreparationPhase"].fib_building_message.label,
        duration = Config.Translations["Phases"]["FirstPreparationPhase"].fib_building_message.timer, 
        position = Config.Notifies.position, 
        type = 'info'
    })

    local card_swipe_coords = CreateCardSwipe()
    card_swipe_blip = CreateBlip(card_swipe_coords.x, card_swipe_coords.y, card_swipe_coords.z, 763, 0.7, 60, true, "Kaart swipe")
end)

RegisterNetEvent("nw-human-labs:client:CreateZoneForElevator", function (x, y, z, event, fa_icon, zone_label)
    ElevatorZone = exports.ox_target:addBoxZone({
        coords = vec3(x, y, z),
        size = vec3(0.3, 0.3, 0.3),
        rotation = 360,
        debug = Config.Debugger,
        options = {
            {
                event = 'nw-human-labs:client:'..event,
                distance = Config.GeneralTargetDistance,
                icon = fa_icon,
                label = zone_label,
            },
        }
    })
end)

RegisterNetEvent('nw-human-labs:client:WarpPlayerToTopFBIbuilding', function ()
    RemoveBlip(card_swipe_blip)
    exports.ox_target:removeZone(ElevatorZone)
    DoScreenFadeOut(Config.HeistInformation['Elevator_fadeout_timer'])
    Citizen.Wait(Config.HeistInformation['Elevator_fadeout_timer'])
    local playerPed = GetPlayerPed(-1)
    SetEntityHeading(playerPed, 158.5520)
    SetEntityCoords(playerPed, 136.1620, -761.9215, 234.1519, true, false, false, false)
    Citizen.Wait(Config.HeistInformation['Elevator_fadeout_timer'])
    DoScreenFadeIn(Config.HeistInformation['Elevator_fadeout_timer'])

    lib.notify({
        title = Config.Translations["Phases"].heist_boss_title,
        description = Config.Translations["Phases"]["FirstPreparationPhase"].fib_top_building_message.label,
        duration = Config.Translations["Phases"]["FirstPreparationPhase"].fib_top_building_message.timer, 
        position = Config.Notifies.position, 
        type = 'info'
    })

    local blueprint_coords = vec3(121.160, -725.256, 233.959)
    Blueprint_prop = CreateObject(`prop_cd_paper_pile3`, blueprint_coords.x, blueprint_coords.y, blueprint_coords.z - 0.19, true, true, false)
    SetEntityRotation(Blueprint_prop, -89.630, -1.973, -20.810, 0, false)
    local blueprint_blip = CreateBlip(blueprint_coords.x, blueprint_coords.y, blueprint_coords.z, 764, 0.7, 60, true, "Kaart swipe")

    BluePrintZone = exports.ox_target:addBoxZone({
        coords = vec3(blueprint_coords.x, blueprint_coords.y, blueprint_coords.z),
        size = vec3(0.5, 0.5, 0.5),
        rotation = 360,
        debug = Config.Debugger,
        options = {
            {
                onSelect = function ()
                    lib.progressBar({duration = 2000, label = "Blueprint pakken", canCancel = false, anim = {dict = 'anim@move_m@trash', lockX = true, lockY = true, lockZ = true, clip = "pickup"}})
                    TriggerServerEvent('nw-human-labs:server:GivePlayerItem', blueprint_coords, Config.HeistItems["PrepPhaseItems"].blueprint.item_name, Config.HeistItems["PrepPhaseItems"].blueprint.amount)
                    RemoveBlip(blueprint_blip)
                    DeleteEntity(Blueprint_prop)
                    exports.ox_target:removeZone(BluePrintZone)

                    lib.notify({
                        title = Config.Translations["Phases"].heist_boss_title,
                        description = Config.Translations["Phases"]["SecondPreparationPhase"].blueprint_picked.label,
                        duration = Config.Translations["Phases"]["SecondPreparationPhase"].blueprint_picked.timer, 
                        position = Config.Notifies.position, 
                        type = 'info'
                    })
                end,
                distance = 1.0,
                icon = 'fa fa-scroll',
                label = 'Pak blueprint',
            },
        }
    })
end)

RegisterNetEvent('nw-human-labs:client:WarpPlayerDownFBIbuilding', function ()
    exports.ox_target:removeZone(ElevatorZone)
    DoScreenFadeOut(Config.HeistInformation['Elevator_fadeout_timer'])
    Citizen.Wait(Config.HeistInformation['Elevator_fadeout_timer'])
    local playerPed = GetPlayerPed(-1)
    SetEntityHeading(playerPed, 158.6431)
    SetEntityCoords(playerPed, 136.0172, -761.9059, 45.7520, true, false, false, false)
    Citizen.Wait(Config.HeistInformation['Elevator_fadeout_timer'])
    DoScreenFadeIn(Config.HeistInformation['Elevator_fadeout_timer'])
    
    lib.notify({
        title = Config.Translations["Phases"].heist_boss_title,
        description = Config.Translations["Phases"]["SecondPreparationPhase"].go_to_human_labs.label,
        duration = Config.Translations["Phases"]["SecondPreparationPhase"].go_to_human_labs.timer, 
        position = Config.Notifies.position, 
        type = 'info'
    })
    
    CreateProp(vec3(3530.969, 3736.867, 36.713), `h4_prop_h4_elecbox_01a`, 'StartHackElectricBox', -10.731, 'bolt', Config.Translations["Phases"]["SecondPreparationPhase"].electric_box_target_label, true, {354, 0.7, 60, true, "Elektriciteits Kast"})
end)

RegisterNetEvent('nw-human-labs:client:CreatePoliceBlip:PoliceBlip', function(ElectricBoxCoords)
    PoliceBlip = AddBlipForCoord(ElectricBoxCoords.x, ElectricBoxCoords.y, ElectricBoxCoords.z)
    SetBlipSprite(PoliceBlip, 161)
    SetBlipScale(PoliceBlip, 1.0)
    SetBlipColour(PoliceBlip, 59)
    SetBlipRoute(PoliceBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("Human Labs Overval")
    EndTextCommandSetBlipName(PoliceBlip)
end)

exports('triggerBlueprintUI', function ()
    SetNuiFocus(true, false)
    SendNUIMessage({
        action = "open",
    })
end)

RegisterNUICallback("nw-human-labs:client:closeBlueprintUI", function()
    SetNuiFocus(false,false)
end)
