local previousPlate = nil

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            local currentPlate = GetVehicleNumberPlateText(vehicle)
            print(previousPlate, currentPlate)

            if previousPlate and previousPlate ~= currentPlate then
                TriggerServerEvent("vehiclePlateChange:detected", previousPlate, currentPlate)
            end
            previousPlate = currentPlate
        elseif vehicle == 0 then
            previousPlate = nil
        end
    end
end)

RegisterCommand("changeplate", function(source, args)
    local newPlate = args[1]
    if newPlate and #newPlate <= 8 then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            SetVehicleNumberPlateText(vehicle, newPlate)
            print("Vehicle plate changed to: " .. newPlate)
        else
            print("You must be in the driver seat of a vehicle to change the plate.")
        end
    else
        print("Invalid plate. Please enter a valid plate (max 8 characters).")
    end
end, false)
