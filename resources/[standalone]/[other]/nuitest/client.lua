local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local isInMarker = false -- Houd bij of de speler in de marker is
local markerPosition = vector3(-54.7474, -2527.2168, 6.1559) -- De positie van je marker
local markerSize = 1.0 -- De grootte van de marker

-- Marker tekenen
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Teken de marker
        DrawMarker(1, markerPosition.x, markerPosition.y, markerPosition.z - 1, 0, 0, 0, 0, 0, 0, markerSize, markerSize, 0.5, 0, 255, 0, 255, false, true, 2, false, nil, nil, false, false)

        -- Controleer of de speler in de marker is
        local playerCoords = GetEntityCoords(PlayerPedId())
        if Vdist(playerCoords, markerPosition) < markerSize then
            isInMarker = true
            -- Geef aan de speler dat ze op E kunnen drukken
            SetTextComponentFormat("STRING")
            AddTextComponentString("Druk op ~g~E~s~ om het menu te openen")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        else
            isInMarker = false
        end

        -- Open het NUI-menu als de speler op E drukt
        if isInMarker and IsControlJustReleased(0, 38) then -- E toets
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "show"
            })
        end
    end
end)

-- Functie om de truck en trailer te spawnen
function start_travel()
    print("start_travel functie aangeroepen.")  -- Debug log
    local playerPed = GetPlayerPed(-1)
    local coords = vector3(-99.5932, -2525.3176, 6.0000)
    local heading = 292.1476

    ESX.Game.SpawnVehicle('phantom', coords, heading, function(vehicle)
        if vehicle then
            print("Vrachtwagen succesvol gespawned.")
            local platenum = math.random(10000, 99999)
            SetVehicleNumberPlateText(vehicle, "WAL" .. platenum)

            if Config.TeleportPlayerToTruck then
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                print("Speler in de vrachtwagen geplaatst.")
            end
        else
            print("Fout bij het spawnen van de vrachtwagen.")
        end
    end)
end




-- NUI Callback voor de Start Levering knop
RegisterNUICallback("startLevering", function(data, cb)
    print("Start Levering aanvraag ontvangen!")  -- Debug log
    start_travel()  -- Roep de functie aan
    cb("ok")  -- Bevestig de callback
end)

RegisterNUICallback("closeNUI", function(data, cb)
    SetNuiFocus(false, false) -- Zet de focus terug
    SendNUIMessage({ action = "hide" }) -- Verberg de NUI
    cb("ok") -- Bevestig de callback
end)

-- Sluit de NUI met de escape-toets
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 322) then -- Escape toets
            SetNuiFocus(false, false)
            SendNUIMessage({
                action = "hide"
            })
        end
    end
end)
