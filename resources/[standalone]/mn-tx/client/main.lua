ingeklokt = false

playerPerms = nil


Citizen.CreateThread(function()
    while true do 
        local sleep = 500
        -- Wait(3)
        local ped, coords = PlayerPedId(), GetEntityCoords(PlayerPedId())
        while not playerPerms do Wait(500) end

        for k,v in pairs(MN.markers) do 
            shouldLoop = true
            local x,y,z = table.unpack(v.coords)
            local dist = #(vector3(x,y,z) - coords)
            if v.type ~= 'klok' then 
                if not ingeklokt then shouldLoop = false end 
            end
            if (shouldLoop) then
                if (dist < 10) then 
                    sleep = 1
                    DrawMarker(20, x,y,z - 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.3, 0.2, 147,112,219, 100, false, true, 2, true, nil, nil, false)


                    if (dist < 1.5) then 
                        if (v.type == 'klok') then 
                            if ingeklokt then v.draw = '[E] Uitklokken' end
                            if not ingeklokt then v.draw = '[E] Inklokken' end
                        end
                    exports['vesx_ia']:Interaction('warning', v.draw, vector3(x,y,z), 1.5, GetCurrentResourceName())

                        if (IsControlJustReleased(0, 38)) then 
                            TriggerEvent(v.trigger)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)


RegisterNetEvent('txcl:setAdmin')
AddEventHandler("txcl:setAdmin", function(username, perms)
    txUsername = username
    playerPerms = perms
    print(txUsername, perms)

    if perms then 
        print("[mn-tx] Player Authenticated as Admin :-)")
    end
end)


RegisterNetEvent('mn-tx:client:klokken')
AddEventHandler('mn-tx:client:klokken', function()
    ingeklokt = not ingeklokt

    if (ingeklokt) then
        exports['okokNotify']:Alert("INFO", "Welkom in dienst lid!", 10000, 'info')
        -- ESX.ShowNotification("Welkom in dienst!")
        
        exports['vesx_jobsmenu']:OpenOutfitMenu(Config.Outfits)
    else
        exports['okokNotify']:Alert("DOEI", "Je bent met succes uitgeklokt! Bedankt voor je inzet!", 10000, 'success')
        -- ESX.ShowNotification("Jij bent uitgeklokt!")
        exports['vesx_jobsmenu']:OpenOutfitMenu(Config.Outfits)
    end
    TriggerEvent("mn-tx:client:txklok")
    TriggerServerEvent("mn-tx:server:discordlog", txUsername, ingeklokt)
end)

staffVehicles = {}


RegisterNetEvent('mn-tx:client:openVehicleMenu')
AddEventHandler('mn-tx:client:openVehicleMenu', function()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mn-scripts', {
        title = "Staff Garage",
        align = "top-right",
        elements = MN.staffGarage
    }, function(data, menu)
        local x,y,z,h = table.unpack(MN.vehicleSpawn)
        ESX.Game.SpawnVehicle(data.current.model, vector3(x,y,z), h, function(veh) 
            table.insert(staffVehicles, veh)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            SetVehicleNumberPlateText(veh, "STAFF")
            SetVehicleCanBeVisiblyDamaged(veh, false)
            SetVehicleCanBreak(veh, false)
            menu.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('[mn-tx] deleting all staff related vehicles xoxo mn ;P')

    for _,v in pairs(staffVehicles) do 
        ESX.Game.DeleteVehicle(v)
    end
end)


RegisterCommand("tx:deletestaffcars", function(source ,args)
    print('[mn-tx] deleting all staff related vehicles xoxo mn ;P')

    for _,v in pairs(staffVehicles) do 
        ESX.Game.DeleteVehicle(v)
    end
end)

function DrawScriptText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end

function Ingeklokt()
    return ingeklokt
end
exports('Ingeklokt', Ingeklokt)
   if not exports['mn-tx']:Ingeklokt() 
    then return 
end 