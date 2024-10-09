local threadStatus = false
local playerTags = {}

RegisterCommand('+showids', function(source, args, RawCommand)
    updateThread(true)
end)

RegisterCommand('-showids', function(source, args, RawCommand)
    updateThread(false)
end)

RegisterKeyMapping("+showids", "Laat id's zien van spelers", "KEYBOARD", "Z")

function updateThread(value)
    threadStatus = value

    local players = GetGamePool("CPed")
    local localPed = PlayerPedId()
    while threadStatus do

        local localCoords = GetEntityCoords(localPed)
        for i=1, #players do
            local player = players[i]

            if player ~= localPed then
                local ped = player
                local pedCoords = GetEntityCoords(ped)
                local distance = #(localCoords - pedCoords)

                if IsPedAPlayer(ped) or Entity(ped).state.clone then
                    if distance < 15 and HasEntityClearLosToEntity(localPed, ped, 273) and IsEntityVisible(ped) then

                        if not playerTags[ped] then
                            local haveState = Entity(ped).state.clone
                            local serverId = haveState and haveState.id or GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
                            local tag = CreateFakeMpGamerTag(ped, tostring(serverId), false, false, '', 0)
                            
                            if haveState then
                                local color = getColorFromLogoutReason(haveState.reason)
                                SetMpGamerTagColour(tag, 0, color)
                            end

                            playerTags[ped] = tag
                        end

                        SetMpGamerTagVisibility(playerTags[ped], 0, true)
                    else 
                        if playerTags[ped] then
                            RemoveMpGamerTag(playerTags[ped])
                            playerTags[ped] = nil
                        end
                    end
                end
            end
        end


        Wait(0)
    end

    for k,v in pairs(playerTags) do
        RemoveMpGamerTag(v)
        playerTags[k] = nil
    end
end

function getColorFromLogoutReason(reason)
    reason = reason:lower()
    if reason:lower() == "exiting" or reason == "disconnected" then
        return 6 -- rood
    end

    return 15 -- oranje
end