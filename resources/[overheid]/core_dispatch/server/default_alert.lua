local function sendAlert(data)
    exports['core_dispatch']:sendAlert(data)
end

local function SendShootingAlert(coords, gender)
    if not coords then 
        print('SendShootingAlert call without coords')
        return    
    end

    gender = gender or 'unknow'

    local data = {
        code = '10-71',
        message = 'Shots in de omgeving!',
        extraInfo = {
            {icon = 'fa-venus-mars', info = gender},
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

local function SendStoreRobbery(coords, gender)
    if not coords then 
        print('SendStoreRobbery call without coords')
        return    
    end

    local gender = gender or 'unknow'

    local data = {
        code = '10-90',
        message = 'Winkeloverval gaande',
        extraInfo = {
            {icon = 'fa-store', info = gender},
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


local function SendBankRobbery(coords, gender)
    if not coords then 
        print('SendBankRobbery call without coords')
        return    
    end

    local gender = gender or 'unknow'

    local data = {
        code = '10-90',
        message = 'Bankoverval gaande',
        extraInfo = {
            {icon = 'fa-vault', info = gender},
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

local function SendHouseRobbery(coords, gender)
    if not coords then 
        print('SendHouseRobbery call without coords')
        return    
    end

    local gender = gender or 'unknow'

    local data = {
        code = '10-90',
        message = 'Woninginbraak gaande',
        extraInfo = {
            {icon = 'fa-house', info = gender},
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

local function SendDrugSellAlert(coords, gender)
    if not coords then 
        print('SendDrugSellAlert call without coords')
        return    
    end

    local gender = gender or 'unknow'

    local data = {
        code = '10-13',
        message = 'Drugsverkoop gaande',
        extraInfo = {
            {icon = 'fa-pills', info = 'Gender:' .. gender},
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

local function SendInjuredPersonAlert(coords, gender)
    if not coords then 
        print('SendInjuredPersonAlert call without coords')
        return    
    end

    local gender = gender or 'unknow'

    local data = {
        code = '10-69',
        message = 'Persoon gewond, hulp vereist',
        extraInfo = {
            {icon = 'fa-skull', info = 'Gender:' .. gender},
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

local function SendOfficerDown(coords, gender)
    if not coords then 
        print('SendOfficerDown call without coords')
        return    
    end

    local gender = gender or 'unknow'

    local data = {
        code = '10-99',
        message = 'Agent neergeschoten, hulp vereist',
        extraInfo = {
            {icon = 'fa-skull', info = gender},
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