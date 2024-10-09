ESX = exports["es_extended"]:getSharedObject()

local isProcessing = false
local ox_target = exports.ox_target

CreateThread(function()
    -- Add the zone once at the start
    ox_target:addBoxZone({
        coords = vec3(1095.4828, -3195.2883, -39.1965),
        size = vec3(1, 1, 1),
        options = {
            {
                name = "methverpak",
                icon = "fa-solid fa-flask",
                label = "Meth Verpakken",
                onSelect = function(data)
                    if exports.ox_inventory:GetItemCount("meth") > 20 then
                        TriggerEvent("jtm-drugsverpak:methverpak")
                    else
                        exports["frp-notifications"]:Notify("error", "Je hebt niet genoeg Meth", 5000)
                    end
                end
            }
        }
    })

    while true do
        local wait = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        -- Check for player input
        if IsControlJustReleased(0, 38) and not isProcessing then
            if exports.ox_inventory:GetItemCount("meth") > 20 then
                ProcessMETH(xMETH)
            else
            end
        end

        Wait(wait)
    end
end)


RegisterNetEvent('jtm-drugsverpak:methverpak')
AddEventHandler('jtm-drugsverpak:methverpak', function(xMETH)
    ProcessMETH(xMETH)
end)


function ProcessMETH(xMETH)
    local playerPed = GetPlayerPed(-1)
    local isProcessing = true
    print(_U('meth_processingstarted'))
    local success = lib.skillCheck({'easy','easy', {areaSize = 190, speedMultiplier = 1.75},}, {'e', 'e', 'e'})

    if success then
        getProcessemote()
        exports["frp-progressbar"]:Progress({
            name = "Meth aan het verpakken in zakjes",
            duration = Config.ProcessTimer * 1000,
            label = "Meth aan het verpakken in zakjes",
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }
        })

        Citizen.Wait(Config.ProcessTimer * 1000)
        ClearPedTasks(playerPed)
        TriggerServerEvent('jtm-drugsverpak:processMETH')
        isProcessing = false
    else 
        exports["frp-notifications"]:Notify("info", "Je kan niet eens een zakje dichtmaken oelewapper", 5000)
    end 
end


function getProcessemote()
    local playerPed = PlayerPedId()
    
    TaskPlayAnim(PlayerPedId(), "anim@amb@business@standing@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
    
    local animDict = "mini@repair"
    local animName = "fixing_a_ped"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 0, 0, true, false, false)  
end
