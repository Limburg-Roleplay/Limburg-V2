ESX = exports["es_extended"]:getSharedObject()

local pedModel = `s_m_y_dealer_01`

CreateThread(function()
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(10)
    end

    local pedCoords = Config.PedCoords
    local ped = CreatePed(4, pedModel, pedCoords, 90.0, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped,true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addSphereZone({
        coords = pedCoords,
        radius = 2.0,
        debug = false,
        options = {
            {
                name = 'blackmarket',
                label = 'Toon Blackmarket',
                icon = 'fas fa-gun',
                onSelect = function()
                    TriggerEvent('bishway-blackmarket:checkAccess')
                end,
            },
        }
    })
end)

RegisterNetEvent('bishway-blackmarket:checkAccess')
AddEventHandler('bishway-blackmarket:checkAccess', function()
   TriggerServerEvent('bishway-blackmarket:grantAccess')
end)

RegisterNetEvent('bishway-blackmarket:openUI')
AddEventHandler('bishway-blackmarket:openUI', function()
        OpenBlackmarketUI()
    return
end)

function OpenBlackmarketUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openUI",
        weapons = Config.Weapons,
        ammoTypes = Config.AmmoTypes
    })
end

RegisterNUICallback('closeUI', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
end)

RegisterNUICallback('buyWeapon', function(data, cb)
    local weaponName = data.weapon
    local price = tonumber(data.price)

    ESX.TriggerServerCallback('bishway-blackmarket:checkFunds', function(hasMoney)
        if hasMoney then
            TriggerServerEvent('bishway-blackmarket:purchaseWeapon', weaponName)
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

RegisterNetEvent('bishway-blackmarket:purchaseSuccess')
AddEventHandler('bishway-blackmarket:purchaseSuccess', function()
    lib.notify({
        type = 'success',
        title = 'Blackmarket',
        description = 'Aankoop voltooid!'
    })
end)

RegisterNetEvent('bishway-blackmarket:purchaseFailed')
AddEventHandler('bishway-blackmarket:purchaseFailed', function()
    lib.notify({
        type = 'error',
        title = 'Blackmarket',
        description = 'Niet genoeg geld!'
    })
end)
