local inVeh = false
local wheelId = {
    [0] = 0,
    [1] = 1,
    [4] = 2,
    [5] = 3
}
local brokenTyres = {}
local dist, distMore

lib.onCache('vehicle', function(value) 
    inVeh = value

    if not inVeh then
        distMore = false
        dist = nil
        brokenTyres = {} 
        return
    end

    local maxWheels = GetVehicleNumberOfWheels(inVeh)+1

    CreateThread(function()
        while inVeh do
            local sleep = 500
            local ped = PlayerPedId()

            for i=0, maxWheels do
                if IsVehicleTyreBurst(inVeh, i, true) then
                    sleep = 0
                    if not dist then dist = GetEntityCoords(ped) end

                    if #(dist-GetEntityCoords(ped)) > 150.0 or distMore then
                        distMore = true
                        BreakOffVehicleWheel(inVeh, wheelId[i], true, false, true, false)
                        brokenTyres[i] = true
                        if brokenTyres[0] and not brokenTyres[1] then
                            SetVehicleSteerBias(inVeh, 1.0)
                        elseif brokenTyres[1] then
                            SetVehicleSteerBias(inVeh, -1.0)
                        else
                            SetVehicleSteerBias(inVeh, 0.0)
                        end
                    end
                end
            end


            Wait(sleep)
        end
    end)
end)