local ESX = nil
if config.Legacy then
    ESX = exports['es_extended']:getSharedObject()
else
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            Citizen.Wait(100)
        end
    end)
end

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
function SpawnNPCsFromConfig()
    for _, npcData in ipairs(config.NPCs) do
        CreateNPC(npcData.model, npcData.coords, npcData.heading)
    end
end

CreateThread(function()
    SpawnNPCsFromConfig()
end)

Citizen.CreateThread(function()
    for k,v in ipairs(config.weapon_shops) do
        if config.blip then
            blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, 123) -- icoon
            SetBlipScale(blip, 0.8) -- grootte
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(locale['blip'])
            EndTextCommandSetBlipName(blip)
        end
    end
    AddTarget()
    Wait(1000)
    SendNUIMessage({
        action = 'insert',
        locale = locale,
        weapons = config.weapons,
        attachments = config.attachments,
        bullets = config.bullets,
        overig = config.overig,
        currency = config.currency,
    })
end)


function AddTarget()
    for k,v in ipairs(config.weapon_shops) do
        exports.ox_target:addBoxZone({
            coords = vector3(v.coords.x, v.coords.y, v.coords.z + 0.1),
            size = vector3(2, 2, 2),  -- Pas de grootte van de zone aan zoals gewenst
            rotation = v.heading,  -- Gebruik de heading uit de config
            options = {
                {
                    name = v.name,
                    label = locale['access_menu'],
                    icon = "fa-solid fa-gun",
                    debug = false,  -- Zet op true als je de zones wilt debuggen
                    onSelect = function()
                        TriggerEvent("jtm-weaponshop:openmenu")
                    end
                }
            }
        })
    end
end

RegisterNetEvent('jtm-weaponshop:openmenu', function()
    local coords = GetEntityCoords(PlayerPedId())
    for k, v in ipairs(config.weapon_shops) do
        if #(coords - v.coords) < 3.0 then
            ESX.TriggerServerCallback('jtm-weaponshop:GetUserData', function(data)
                TriggerScreenblurFadeIn(500)
                SendNUIMessage({
                    action = 'menu',
                    show = true,
                    user_data = data,
                })
                SetNuiFocus(true, true)
            end)
            return
        end
    end
end)

RegisterNUICallback('buy', function(data)
    SendNUIMessage({
        action = 'menu',
        show = false,
    })
    TriggerScreenblurFadeOut(500)
    SetNuiFocus(false, false)
    ESX.TriggerServerCallback('jtm-weaponshop:buyweapon', function(data)
    end, data)
end)

RegisterNUICallback('close', function(data)
    SendNUIMessage({
        action = 'menu',
        show = false,
    })
    TriggerScreenblurFadeOut(500)
    SetNuiFocus(false, false)
end)

RegisterNetEvent('d-weaponshop:notify', function(icon, text, duration)
    SendNUIMessage({
        action = 'notify',
        icon = icon,
        text = text,
        duration = duration,
    })
end)

function pickmenu(text, price)
    ESX.TriggerServerCallback('jtm-weaponshop:GetUserData', function(data)
        SendNUIMessage({
            action = 'pickmenu',
            user_data = data,
            text = text,
            price = price,
        })
        SetNuiFocus(true, true)
    end)
end