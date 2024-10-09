local blipCoords = vector3(-331.8369, -2444.7690, 7.358) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 403) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 1.1) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Verpak Loods") 
EndTextCommandSetBlipName(blip)

Citizen.CreateThread(function()
    -- Define the teleportation zones
    local drawZones = false  -- Set to true if you want to enable zone drawing for debugging

    exports.ox_target:addBoxZone({
        coords = vec3(-338.6817, -2444.6006, 7.2961),
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = "enterWarehouse",
                event = "warehouse:enter",
                icon = "fas fa-door-open",
                label = "Verpak Loods Binnengaan"
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = vec3(1088.5627, -3187.4624, -38.9935),
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = "exitWarehouse",
                event = "warehouse:exit",
                icon = "fas fa-door-open",
                label = "Verpak Loods Verlaten"
            }
        }
    })

    -- Event listeners for warehouse entering and exiting
    RegisterNetEvent('warehouse:enter')
    AddEventHandler('warehouse:enter', function()
        local player = PlayerPedId()
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetEntityCoords(player, 1088.5627, -3187.4624, -38.9935)
        SetEntityHeading(player, 280.6)
        Citizen.Wait(500)
        DoScreenFadeIn(1000)
    end)

    RegisterNetEvent('warehouse:exit')
    AddEventHandler('warehouse:exit', function()
        local player = PlayerPedId()
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetEntityCoords(player, -338.6817, -2444.6006, 7.2961)
        SetEntityHeading(player, 280.3163)
        Citizen.Wait(500)
        DoScreenFadeIn(1000)
    end)
end)
