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
            {
                label = "Toon Ammo-shop",
                icon = "fas fa-shop",
                onSelect = function()
                     TriggerEvent("zetrox-blackmarket:client:openblackmarket")
                end,
            },
        }
    })
end)

RegisterNetEvent('bishway-blackmarket:checkAccess')
AddEventHandler('bishway-blackmarket:checkAccess', function()
    local hasPerms = lib.callback.await("bishiewishie-blackmarket:getPerms")
    if exports["discordperms"]:hasblackmarketgroup() or hasPerms then
        TriggerServerEvent('bishway-blackmarket:grantAccess')
    else
        lib.notify({
            type = 'error',
            title = 'Toegang geweigerd',
            description = 'Je hebt geen toegang tot de VIP blackmarket.'
        })
    end
end)

RegisterNetEvent('bishway-blackmarket:openUI')
AddEventHandler('bishway-blackmarket:openUI', function()
    local hasPerms = lib.callback.await("bishiewishie-blackmarket:getPerms")
    if exports["discordperms"]:hasblackmarketgroup() or hasPerms then
        OpenBlackmarketUI()
        return
    end
    TriggerServerEvent("bishiesquishy:stopcheatin:dude")
end)

RegisterNetEvent('bishway-blackmarket:accessDenied')
AddEventHandler('bishway-blackmarket:accessDenied', function()
    lib.notify({
        type = 'error',
        title = 'Toegang geweigerd',
        description = 'Je hebt geen toegang tot de VIP blackmarket.'
    })
end)

function OpenBlackmarketUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openUI",
        weapons = Config.Weapons,
        ammoTypes = Config.AmmoTypes -- Add ammo types to the UI
    })
end

RegisterNUICallback('closeUI', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeUI" })
end)

-- Buying weapons
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

-- Buying ammo
RegisterNUICallback('buyAmmo', function(data, cb)
    local ammoType = data.ammoType
    local ammoAmount = tonumber(data.ammoAmount)
    local price = tonumber(data.price)

    ESX.TriggerServerCallback('bishway-blackmarket:checkFunds', function(hasMoney)
        if hasMoney then
            TriggerServerEvent('bishway-blackmarket:purchaseAmmo', ammoType, ammoAmount)
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

-- Notifications for purchase success or failure
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
