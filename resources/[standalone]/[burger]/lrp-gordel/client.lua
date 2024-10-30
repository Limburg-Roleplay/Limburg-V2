local isUiOpen = false 
local speedBuffer = {}
local velBuffer = {}
local SeatbeltON = false
local InVehicle = false

function Notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(false, true)
end

AddEventHandler('seatbelt:sounds', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType = 'playSound',
        transactionFile = soundFile,
        transactionVolume = soundVolume
    })
end)

function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end
 
Citizen.CreateThread(function() ---- Seatbelt
	while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local car = GetVehiclePedIsIn(ped)

        if car ~= 0 and (InVehicle or IsCar(car)) then
            sleep = 100
            InVehicle = true
            if isUiOpen == false and not IsPlayerDead(PlayerId()) then
                if Config.Blinker then
                    SendNUIMessage({displayWindow = 'true'})
                end
                    isUiOpen = true
                end

                if SeatbeltON then 
                    sleep = 0
                    DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
                    DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
                end

                speedBuffer[2] = speedBuffer[1]
                speedBuffer[1] = GetEntitySpeed(car)

                if not SeatbeltON and speedBuffer[2] ~= nil and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > (Config.Speed / 3.6) and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then
                    local co = GetEntityCoords(ped)
                    local fw = Fwv(ped)
                    SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                    SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                end
                
                velBuffer[2] = velBuffer[1]
                velBuffer[1] = GetEntityVelocity(car)
            
            elseif InVehicle then
                InVehicle = false
                SeatbeltON = false
                speedBuffer[1], speedBuffer[2] = 0.0, 0.0
                if isUiOpen == true and not IsPlayerDead(PlayerId()) then
                    if Config.Blinker then
                        SendNUIMessage({displayWindow = 'false'})
                    end
                    isUiOpen = false 
                end
            end
        Wait(sleep)
    end

end)

Citizen.CreateThread(function() --- Get Speed
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, true) then
            sleep = 500
            local Vehicle = GetVehiclePedIsIn(ped, false)
            local VehSpeed = GetEntitySpeed(Vehicle) * 3.6
    
            if Config.AlarmOnlySpeed and VehSpeed > Config.AlarmSpeed then
                ShowWindow = true
            else
                ShowWindow = false
                SendNUIMessage({displayWindow = 'false'})
            end
    
            if IsEntityDead(ped) or IsPauseMenuActive() then
                if isUiOpen == true then
                    SendNUIMessage({displayWindow = 'false'})
                end
            elseif not SeatbeltON and InVehicle and not IsPauseMenuActive() and not IsEntityDead(ped) and Config.Blinker then
                if Config.AlarmOnlySpeed and ShowWindow and VehSpeed > Config.AlarmSpeed then
                    SendNUIMessage({displayWindow = 'true'})
                end
            end
        end

        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
	while true do
        local sleep = 5000
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            sleep = 3500
            if not SeatbeltON and InVehicle and not IsPauseMenuActive() and Config.LoopSound and ShowWindow then
                TriggerEvent("seatbelt:sounds", "seatbelt", Config.Volume)
            end
        end   

        Wait(sleep)
	end
end)

RegisterCommand('+gordel', function()
    local ped = PlayerPedId()

    if IsCar(GetVehiclePedIsIn(ped)) and IsPedInAnyVehicle(ped) then
        SeatbeltON = not SeatbeltON 
        if SeatbeltON then
            Citizen.Wait(1)
            if Config.Sounds then  
                TriggerEvent("seatbelt:sounds", "buckle", Config.Volume)
            end
            isUiOpen = true 
        else 
            if Config.Sounds then
                TriggerEvent("seatbelt:sounds", "unbuckle", Config.Volume)
            end
            isUiOpen = true  
        end
    end
end, false)

RegisterKeyMapping('+gordel', 'Doe je gordel om/af', 'keyboard', 'G')

exports('seatbelton', function()
    return SeatbeltON
end)