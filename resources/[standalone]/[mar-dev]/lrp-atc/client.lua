local lastRadio
local inATC = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 then
            local model = GetEntityModel(vehicle)
            if IsThisModelAHeli(model) or IsThisModelAPlane(model) then
                if LocalPlayer.state.radioChannel ~= 100 and not inATC then
                    lastRadio = LocalPlayer.state.radioChannel
                    exports.ox_lib:notify({
                        title = "ATC",
                        description = "Je porto is automatisch naar de ATC geswitched.",
                    })
                    exports["pma-voice"]:setRadioChannel(100)
                    inATC = true 
                end
            else
                if inATC and LocalPlayer.state.radioChannel == 100 then
                    exports["pma-voice"]:setRadioChannel(lastRadio)
                    exports.ox_lib:notify({
                        title = "ATC",
                        description = "Je porto is terug naar je vorige kanaal geswitched.",
                    })
                end
                inATC = false 
                lastRadio = nil
            end
        else
            if lastRadio and LocalPlayer.state.radioChannel == 100 then
                exports["pma-voice"]:setRadioChannel(lastRadio)
                exports.ox_lib:notify({
                    title = "ATC",
                    description = "Je porto is terug naar je vorige kanaal geswitched.",
                })
                lastRadio = nil
            end
            inATC = false 
        end
    end
end)

RegisterNetEvent('pma-voice:channelChanged', function(newChannel)
    LocalPlayer.state.manualSwitch = (newChannel ~= 100)
end)
