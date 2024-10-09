ESX = exports["es_extended"]:getSharedObject()

local isProcessing = false
local ox_target = exports.ox_target

CreateThread(function()
    ox_target:addBoxZone({
        coords = vec3(1090.5281, -3195.7178, -38.9042),
        size = vec3(1, 1, 1),
        options = {
            {
                name = "storage",
                icon = "fa-solid fa-flask",
                label = "GHB Verwerken",
                onSelect = function(data)
                    if exports.ox_inventory:GetItemCount("ghb_ton") > 20 then
                        TriggerEvent("jtm-drugsverpak:ghbverpak")
                    else
                        exports["frp-notifications"]:Notify("error", "Je hebt niet genoeg GHB Tonnetjes", 5000)
                    end
                end
            }
        }
    })

    while true do
        local wait = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if IsControlJustReleased(0, 38) and not isProcessing then
            if exports.ox_inventory:GetItemCount("ghb_ton") > 20 then
                ProcessGHB(xGHB)
            else
            end
        end

        Wait(wait)
    end
end)

RegisterNetEvent('jtm-drugsverpak:ghbverpak')
AddEventHandler('jtm-drugsverpak:ghbverpak', function(xGHB)
    ProcessGHB(xGHB)
end)


function ProcessGHB(xGHB)
    local playerPed = GetPlayerPed(-1)
    local isProcessing = true
    print(_U('ghb_processingstarted'))
    local success = lib.skillCheck({'easy','easy', {areaSize = 190, speedMultiplier = 1.75},}, {'e', 'e', 'e'})

    if success then
        getProcessemote()
        exports["frp-progressbar"]:Progress({
            name = "GHB Tonnetjes mixen met poeder",
            duration = Config.ProcessTimer * 1000,
            label = "GHB Tonnetjes mixen met poeder",
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
        TriggerServerEvent('jtm-drugsverpak:processGHB')
        isProcessing = false
    else 
        exports["frp-notifications"]:Notify("info", "Je handen waren te glibberig zweetnek.", 5000)
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
