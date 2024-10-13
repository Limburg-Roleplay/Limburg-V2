ESX = exports["es_extended"]:getSharedObject()

local pedModel = `s_m_y_dealer_01`

Citizen.CreateThread(function()
    for k, v in ipairs(Config.weapon_shops) do
        if Config.blip then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, 123)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Wapenwinkel")
            EndTextCommandSetBlipName(blip)
        end
    end
end)

CreateThread(function()
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
    end

    local pedCoords = Config.PedCoords
    local ped = CreatePed(4, pedModel, pedCoords, 90.0, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addSphereZone({
        coords = pedCoords,
        radius = 2.0,
        debug = false,
        options = {
            {
                name = 'blackmarket',
                label = 'Blackmarket Openen',
                icon = 'fas fa-gun',
                onSelect = function()
                    TriggerEvent('lrp-wapenwinkel:wapenwinkeltoegangcheck')
                end,
            },
        }
    })
end)

RegisterNetEvent('lrp-wapenwinkel:wapenwinkeltoegangcheck')
AddEventHandler('lrp-wapenwinkel:wapenwinkeltoegangcheck', function()
    TriggerServerEvent('lrp-wapenwinkel:grantAccess')
end)

RegisterNetEvent('lrp-wapenwinkel:openUI')
AddEventHandler('lrp-wapenwinkel:openUI', function()
    OpenBlackmarketUI()
    return
end)

function OpenBlackmarketUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openUI",
        weapons = Config.Weapons,
    })
end

RegisterNUICallback('closeUI', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
end)

RegisterNUICallback('buyWeapon', function(data, cb)
    local weaponName = data.weapon
    local price = tonumber(data.price)

    ESX.TriggerServerCallback('lrp-wapenwinkel:checkFunds', function(hasMoney)
        if hasMoney then
            TriggerServerEvent('lrp-wapenwinkel:purchaseWeapon', weaponName)
        else
            lib.notify({
                type = 'error',
                title = 'Blackmarket',
                description = 'Niet genoeg geld!'
            })
        end
    end, price)

    cb('ok')
end)

RegisterNetEvent('lrp-wapenwinkel:purchaseSuccess')
AddEventHandler('lrp-wapenwinkel:purchaseSuccess', function()
    lib.notify({
        type = 'success',
        title = 'Blackmarket',
        description = 'Aankoop voltooid!'
    })
end)

RegisterNetEvent('lrp-wapenwinkel:purchaseFailed')
AddEventHandler('lrp-wapenwinkel:purchaseFailed', function()
    lib.notify({
        type = 'error',
        title = 'Blackmarket',
        description = 'Niet genoeg geld!'
    })
end)
