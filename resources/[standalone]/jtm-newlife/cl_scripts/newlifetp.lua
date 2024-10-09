TriggerEvent('chat:addSuggestion', '/overheidnewlife', 'Geef jezelf een nieuw leven! [OVERHEID]')

RegisterNetEvent("hrp-troep:teleportPlayer")
AddEventHandler("hrp-troep:teleportPlayer", function(x, y, z)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, x, y, z, false, false, false, true)
end)

RegisterNetEvent("openNewLifeMenu")
AddEventHandler("openNewLifeMenu", function()
    lib.showContext('newlifemenu')
end)

-- Function to start the test drive timer
function StartTestDriveTimer()
    local inTestrit = true
    Citizen.CreateThread(function()
        while inTestrit do 
            SendNUIMessage({action = 'testdriveTimer', event = true})
            for i = 1, 120 do 
                Wait(1000)
                if inTestrit then
                    SendNUIMessage({action = 'testdriveTick'})
                else
                    break
                end
            end
        end
    end)
end

-- Register the context menu
lib.registerContext({
    id = "newlifemenu",
    title = "Newlife Menu",
    options = {
        {
            title = "Politie HB Newlife",
            description = "Je geeft jezelf een nieuw leven bij het politie HB!",
            onSelect = function()
                TriggerServerEvent('politiehbnewlife')
            end,
            icon = "building"
        },
        {
            title = "Paletto HB Newlife",
            description = "Je geeft jezelf een nieuw leven bij het politie HB!",
            onSelect = function()
                TriggerServerEvent('palettonewlife')
            end,
            icon = "building"
        },
        {
            title = "KMar HB Newlife",
            description = "Je geeft jezelf een nieuw leven bij het KMar HB!",
            onSelect = function()
                TriggerServerEvent('ziekenhuis-newlife')
                StartTestDriveTimer() -- Start the test drive timer
            end,
            icon = "hospital"
        }
    }
})


