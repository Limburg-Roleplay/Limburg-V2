local interactions = {}
local timeout = {}

Citizen.CreateThread(function()
    while true do
        local sleep = 1

        for title,k in pairs(interactions) do
            for _,v in pairs(k) do
                if v['opened'] then
                    local coords = GetEntityCoords(PlayerPedId())
                    local dist = #(coords-v['tempcoords'])
                    if dist >= v['dist'] then
                        v['opened'] = false
                        v['tempcoords'] = nil
                        SendNUIMessage({
                            type = 'closeInteraction',
                            information = {
                                id = v['id']
                            }
                        })
                        interactions[title] = nil
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

clearInteraction = function()
    for title,k in pairs(interactions) do
        for _,v in pairs(k) do
            v['opened'] = false
            v['tempcoords'] = nil
            SendNUIMessage({
                type = 'closeInteraction',
                information = {
                    id = v['id']
                }
            })
            interactions[title] = nil
            Wait(1)
        end
    end
end

startInteraction = function(messagetype, description, coords, dist, resourcename)
    while timeout[resourcename] do Wait(500) end
    local messagetype = messagetype ~= nil and messagetype or 'error'
    local description = description ~= nil and description or 'Geen verhaal toegevoegd.'

    if interactions[resourcename] and interactions[resourcename][description] and not interactions[resourcename][description]['opened'] then
        interactions[resourcename][description]['opened'] = true
        interactions[resourcename][description]['tempcoords'] = coords
        SendNUIMessage({
            type = 'openInteraction',
            information = {
                id = interactions[resourcename]['id']
            }
        })
    elseif not interactions[resourcename] then
        interactions[resourcename] = {}
        interactions[resourcename][description] = {['id'] = resourcename .. '-' .. math.random(00000, 99999), ['opened'] = true, ['tempcoords'] = coords, ['dist'] = dist}
        SendNUIMessage({
            type = 'createInteraction',
            information = {
                type = messagetype,
                text = description,
                id = interactions[resourcename][description]['id']
            }
        })
    elseif interactions[resourcename] and not interactions[resourcename][description] then

        for title,k in pairs(interactions) do
            for _,v in pairs(k) do
                v['opened'] = false
                v['tempcoords'] = nil
                SendNUIMessage({
                    type = 'closeInteraction',
                    information = {
                        id = v['id']
                    }
                })
                interactions[title] = nil
                Wait(1)
            end
        end

        interactions[resourcename] = {}
        interactions[resourcename][description] = {['id'] = resourcename .. '-' .. math.random(00000, 99999), ['opened'] = true, ['tempcoords'] = coords, ['dist'] = dist}
        SendNUIMessage({
            type = 'createInteraction',
            information = {
                type = messagetype,
                text = description,
                id = interactions[resourcename][description]['id']
            }
        })
    end
end

RegisterNetEvent('frp-interaction:client:interaction')
AddEventHandler('frp-interaction:client:interaction', startInteraction)

RegisterNetEvent('frp-interaction:client:clear:table')
AddEventHandler('frp-interaction:client:clear:table', function(resourcename)
    timeout[resourcename] = {true}

    if interactions[resourcename] then
        for _,v in pairs(interactions[resourcename]) do
            if v['opened'] then
                v['opened'] = false
                v['tempcoords'] = nil
                SendNUIMessage({
                    type = 'closeInteraction',
                    information = {
                        id = v['id']
                    }
                })
            end
        end
    end

    timeout[resourcename] = nil
end)

exports('interaction', startInteraction)
exports('Interaction', startInteraction)
exports('interact', startInteraction)
exports('Interact', startInteraction)
exports('clearInteraction', clearInteraction)