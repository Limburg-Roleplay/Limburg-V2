local function sendAlert(data)
    TriggerServerEvent('core_dispatch:server:sendAlert', data)
end


local function SendShootingAlert(coords)
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local data = {
        code = '10-71',
        message = 'Shots in area',
        extraInfo = {
            {icon = 'fa-venus-mars', info = 'Gender: ' .. gender},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = Config.ShotFireIsPriority,
        job = { Config.JobOne.job },
        time = 5000,
        blip = 156,
        color = 1
    }

    sendAlert(data)
end

exports('sendShootingAlert', SendShootingAlert)

local function SendCarjackAlert(vehicle, coords)
    local ped = PlayerPedId()
    if not vehicle and not ped then return end
    if not vehicle then
        vehicle = GetVehiclePedIsUsing(ped)
    end
    if not vehicle then return end

    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local vehicleData = {
        name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))),
        plate = GetVehicleNumberPlateText(vehicle)
    }

    local data = {
        code = '10-35',
        message = 'Carjackin in progress',
        extraInfo = {
            {icon = 'fa-venus-mars', info = 'Gender: ' .. gender},
            {icon = 'fa-car', info = vehicleData.name},
            {icon = 'fa-list', info = vehicleData.plate},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = false,
        job = { Config.JobOne.job },
        time = 5000,
        blip = 225,
        color = 1
    }

    sendAlert(data)
end

exports('sendCarjackAlert', SendCarjackAlert)

local function SendCarTheftAlert(vehicle, coords)
    local ped = PlayerPedId()
    if not vehicle and not ped then return end
    if not vehicle then
        vehicle = GetVehiclePedIsUsing(ped)
    end
    if not vehicle then return end

    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local vehicleData = {
        name = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))),
        plate = GetVehicleNumberPlateText(vehicle)
    }

    local data = {
        code = '10-35',
        message = 'Car theft in progress',
        extraInfo = {
            {icon = 'fa-venus-mars', info = 'Gender: ' .. gender},
            {icon = 'fa-car', info = vehicleData.name},
            {icon = 'fa-list', info = vehicleData.plate},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = false,
        job = { Config.JobOne.job },
        time = 5000,
        blip = 225,
        color = 1
    }

    sendAlert(data)
end

exports('sendCarTheftAlert', SendCarTheftAlert)

local function SendStoreRobbery(coords)
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local data = {
        code = '10-90',
        message = 'Store robbery in progress',
        extraInfo = {
            {icon = 'fa-store', info = 'Gender : ' ..gender},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = false,
        job = { Config.JobOne.job },
        time = 5000,
        blip = 108,
        color = 1
    }

    sendAlert(data)
end

exports('sendStoreRobbery', SendStoreRobbery)

local function SendBankRobbery(coords)
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local data = {
        code = '10-90',
        message = 'Bank robbery in progress',
        extraInfo = {
            {icon = 'fa-vault', info = 'Gender: ' .. gender},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = false,
        job = { Config.JobOne.job },
        time = 5000,
        blip = 108,
        color = 1
    }

    sendAlert(data)
end

exports('sendBankRobbery', SendBankRobbery)

local function SendHouseRobbery(coords)
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local data = {
        code = '10-90',
        message = 'House robbery in progress',
        extraInfo = {
            {icon = 'fa-house', info = 'Gender: ' .. gender},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = false,
        job = { Config.JobOne.job },
        time = 5000,
        blip = 108,
        color = 1
    }

    sendAlert(data)
end

exports('sendHouseRobbery', SendHouseRobbery)

local function SendDrugSellAlert(coords)
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local data = {
        code = '10-13',
        message = 'Drug sell in progress',
        extraInfo = {
            {icon = 'fa-pills', info = 'Gender: ' .. gender},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = false,
        job = { Config.JobOne.job },
        time = 5000,
        blip = 51,
        color = 1
    }

    sendAlert(data)
end

exports('sendDrugSellAlert', SendDrugSellAlert)

local function SendInjuredPersonAlert(coords)
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local data = {
        code = '10-69',
        message = 'Person injured required help',
        extraInfo = {
            {icon = 'fa-skull', info = 'Gender: ' .. gender},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = true,
        job = { Config.JobTwo.job },
        time = 5000,
        blip = 153,
        color = 1
    }

    sendAlert(data)
end

exports('sendInjuredPersonAlert', SendInjuredPersonAlert)

local function SendOfficerDown(coords)
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'

    if not coords then
        coords = GetEntityCoords(ped)
    end

    local data = {
        code = '10-99',
        message = 'Officer down required help',
        extraInfo = {
            {icon = 'fa-skull', info = 'Gender: ' .. gender},
        },
        coords = { coords.x, coords.y, coords.z},
        priority = true,
        job = { Config.JobOne.job, Config.JobTwo.job },
        time = 5000,
        blip = 303,
        color = 1
    }

    sendAlert(data)
end

exports('sendOfficerDown', SendOfficerDown)