Citizen.CreateThread(function()
    while true do 
        sleep = 750
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)

        local menus = Config.Teleports.menus
        for i=1, #menus do
            local distance = GetDistanceBetweenCoords(playerCoords, menus[i].coords, true)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
                if distance < 1.5 then 
                    sleep = 0
                    exports[''..Config.interaction..'']:Interaction({r = '161', g = '161', b = '0'}, '[E] - Lift gebruiken', menus[i].coords, 1.5, GetCurrentResourceName() .. '-lift')
                    if IsControlJustPressed(0, 38) then 
                        OpenLiftMenu()
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

OpenLiftMenu = function()
    local options = {}
    local configOptions = Config.Teleports.options

    for i=1, #configOptions do
        local lift = configOptions[i]
        if lift then
            options[#options+1] = {
                title = lift.label,
                description = lift.desc,
                event = 'wsk-ambulance:client:teleport:player',
                args = { index = i }
            }
        end
    end

    lib.registerContext({
        id = 'wsk-ambulance:lift:menu',
        title = 'Ambulance Lift',
        options = options
    })
    lib.showContext('wsk-ambulance:lift:menu')
end

RegisterNetEvent('wsk-ambulance:client:teleport:player', function(data)
    local lift = Config.Teleports.options[data?.index]
    if not lift then
        return
    end

    exports['wsk-progressbar']:Progress({
        name = 'lift-location-ambulance',
        duration = 4500,
        label = 'Lift aan het opvragen',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(cancelled)
        if not cancelled then
            DoScreenFadeOut(100)
            Citizen.Wait(750)
            ESX.Game.Teleport(PlayerPedId(), lift.coords, function() end)
            DoScreenFadeIn(100)
        end
    end)
end)