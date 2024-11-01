RegisterCommand("nui", function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
end, false)

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

