-- Define the coordinates for the blip
local blipCoords = vector3(-56.9599, -1097.1337, 26.4224)
local blip

-- Define the maximum distance at which the blip is visible on the minimap
local maxDistance = 200.0 -- 200 units is the maximum distance

Citizen.CreateThread(function()
    -- Create the blip initially
    blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
    SetBlipSprite(blip, 225)  -- Blip icon (1 is a generic blip)
    SetBlipScale(blip, 1.0) -- Blip size
    SetBlipColour(blip, 3)  -- Blip color (3 is light blue)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cardealer")
    EndTextCommandSetBlipName(blip)

    while true do
        -- Get the player's position
        local playerCoords = GetEntityCoords(PlayerPedId())

        -- Calculate the distance between the player and the blip coordinates
        local distance = #(playerCoords - blipCoords)

        if distance <= maxDistance then
            -- Als de speler binnen het bereik is, laat de blip zien op de minimap
            SetBlipDisplay(blip, 2) -- 2 toont de blip op de minimap
        else
            -- Als de speler buiten het bereik is, verberg de blip op de minimap
            SetBlipDisplay(blip, 3) -- 3 verbergt de blip op de minimap
        end

        -- Wacht even voor het volgende frame
        Citizen.Wait(500)
    end
end)
