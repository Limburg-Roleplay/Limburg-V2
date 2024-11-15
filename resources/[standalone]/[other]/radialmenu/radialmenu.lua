-- Menu state
local showMenu = false

-- Keybind Lookup table
local keybindControls = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118, ["LAlt"] = 19 
}

local IsDisabledControlPressed = IsDisabledControlPressed

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, menuConfig in pairs(menuConfigs) do
            DisableControlAction(0, keybindControls[menuConfig.data.keybind])
        end
    end
end)

-- Main thread
Citizen.CreateThread(function()
    -- Update every frame
    while true do
        Citizen.Wait(500)

        -- Loop through all menus in config
        for _, menuConfig in pairs(menuConfigs) do
            -- Check if menu should be enabled
            if menuConfig and menuConfig.enableMenu then
                -- When keybind is pressed toggle UI
                local keybindControl = keybindControls[menuConfig.data.keybind]
                if IsDisabledControlPressed(0, keybindControl) and IsInputDisabled(2) then
                    if IsControlEnabled(0, 164) then
                        -- Init UI
                        showMenu = true
                        SendNUIMessage({
                            type = 'init',
                            data = menuConfig.data,
                            resourceName = GetCurrentResourceName()
                        })

                        -- Set cursor position and set focus
                        SetCursorLocation(0.5, 0.5)
                        if IsControlPressed(0, 249) then
                            Citizen.CreateThread(function()
                                while showMenu do
                                    Citizen.Wait(0)
                                    SetControlNormal(0, 249, 1.0)
                                end
                            end)
                        end
                        SetNuiFocus(true, true)

                        -- Play sound
                        PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

                        -- Prevent menu from showing again until key is released
                        while showMenu == true do
                            Citizen.Wait(0)
                            DisableControlAction(0, keybindControl)
                            if IsControlJustPressed(0, keybindControls.BACKSPACE) then
                                SendNUIMessage({
                                    type = 'destroy'
                                })
                            end
                        end
                        Citizen.Wait(0)
                    end
                    DisableControlAction(0, keybindControl)
                    while IsDisabledControlPressed(0, keybindControl) do
                        DisableControlAction(0, keybindControl)
                        Citizen.Wait(0)
                    end
                end
            end
        end
    end
end)

-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Send ACK to callback function
    cb('ok')
end)

if GetResourceKvpString('firstEngine') ~= 'false' then
    AddEventHandler("baseevents:enteredVehicle", function(vehicle, seat, _, netId, model)
        if GetResourceKvpString('firstEngine') ~= 'false' then
            TriggerEvent('chat:addMessage', { args = { 'TUTORIAL: ', "Het lijkt erop dat je voor het eerst in een auto stapt. Houdt 3 ingedrukt en klik op de bovenste knop (motor icoontje) om je voertuig te starten." }, color = { 255, 50, 50 } })
            TriggerEvent('chat:addMessage', { args = { 'TUTORIAL: ', "Vergeet voor het uistappen niet je motor uit te zetten." }, color = { 255, 50, 50 } })
        end
    end)
end

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('sliceclicked', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    if data.command == 'engine' then
        SetResourceKvp('firstEngine', 'false')
    end
    -- Run command
    ExecuteCommand(data.command)

    -- Send ACK to callback function
    cb('ok')
end)

-- Callback function for testing
RegisterNUICallback('testprint', function(data, cb)
    -- Print message
    TriggerEvent('chatMessage', "[test]", {255,0,0}, data.message)

    -- Send ACK to callback function
    cb('ok')
end)
