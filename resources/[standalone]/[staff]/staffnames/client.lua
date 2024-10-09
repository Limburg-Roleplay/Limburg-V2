local ESX = nil
local playerJobs = {}
local staffNamesEnabled = false
local manualToggle = false
local proximityDistance = 20.0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end

    Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)  -- Verhoogde wachtijd naar 1 seconde

        local inService = exports["frp-staffdienst"]:inDienst()

        if inService and not staffNamesEnabled and not manualToggle then
            staffNamesEnabled = true
            TriggerServerEvent('playerInService')
        elseif not inService and staffNamesEnabled then
            staffNamesEnabled = false
            manualToggle = false
            TriggerServerEvent('playerOutOfService')
        end
    end
end)

RegisterNetEvent("toggleStaffNames")
AddEventHandler("toggleStaffNames", function(status)
    if status ~= nil then
        staffNamesEnabled = status
    else
        staffNamesEnabled = not staffNamesEnabled
    end

    manualToggle = true

    if staffNamesEnabled then
        TriggerServerEvent('logToDiscord', GetPlayerName(PlayerId()), "Heeft staffnames ingeschakeld.", nil, 65280)
        TriggerServerEvent('sendPlayerJobs')
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {"Systeem", "Staffnames zijn ingeschakeld."}
        })
    else
        TriggerServerEvent('logToDiscord', GetPlayerName(PlayerId()), "Heeft staffnames uitgeschakeld.", nil, 16711680)
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Systeem", "Staffnames zijn uitgeschakeld."}
        })
    end
end)

RegisterNetEvent('updatePlayerJobs')
AddEventHandler('updatePlayerJobs', function(serverPlayerJobs)
    playerJobs = serverPlayerJobs
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)  -- Verhoogd naar 500ms

        if staffNamesEnabled then
            local players = GetActivePlayers()
            for i = 1, #players do
                local ped = GetPlayerPed(players[i])
                local playerServerId = GetPlayerServerId(players[i])
                local playerName = GetPlayerName(players[i])
                local jobName = playerJobs[playerServerId]
                if jobName then
                    local x, y, z = table.unpack(GetEntityCoords(ped, true))
                    z = z + 1.2

                    DrawText3D(x, y, z, "[" .. playerServerId .. "]" .. playerName .. " | " .. jobName)
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextOutline()
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end
