local pedDisplaying = {}

local function Display(ped, text)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= 25 then

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        -- Timer
        local display = true

        Citizen.CreateThread(function()
            Wait(5000)
            display = false
        end)

        -- Display
        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                ESX.Game.Utils.DrawText(x, y, z, text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

RegisterNetEvent('frp-me:me:shareDisplay')
AddEventHandler('frp-me:me:shareDisplay', function(text, serverId, name)
    local player = GetPlayerFromServerId(serverId)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(serverId)
    if player ~= -1 and text ~= '' then
        local ped = GetPlayerPed(player)
        if IsLocal(pid, myId) then
            TriggerEvent('chat:addMessage', {
                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(116, 28, 230, 0.6); border-radius: 3px;"><i class="fas fa-user"></i> <b>{0}:</b><br> {1}</div>',
                args = { serverId, text }
            })
        end
        Display(ped, text)
    end
end)


function GetCoords()
	if NetworkIsInSpectatorMode() then
		return GetFinalRenderedCamCoord()
	else
		return GetEntityCoords(PlayerPedId())
	end
end

function IsLocal(pid, myId, range)
	range = range or 15.4
	local coords
    if NetworkIsInSpectatorMode() then
		coords = GetFinalRenderedCamCoord()
	else
		coords = GetEntityCoords(PlayerPedId())
	end
	if pid == myId then
		return true
	end
	if pid == -1 then
		return false
	end
	if #(coords - GetEntityCoords(GetPlayerPed(pid))) < range then
		return true
	end
end

local function getPlayerFromChange(bagName)
	local player = bagName:gsub("player:", "")
	player = tonumber(player)

	return player
end

local Sounds = {
    [1] = {['soundname'] = 'EXILE_2_SOUNDS'},
    [2] = {['soundname'] = 'exile_1'},
    [3] = {['soundname'] = 'NIGEL_02_SOUNDSET'},
    [4] = {['soundname'] = 'CAR_STEAL_3_AGENT'},
    [5] = {['soundname'] = '0'}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k,v in pairs(Sounds) do
            v.soundname = GetSoundId()
            StopSound(v.soundname)
            ReleaseSoundId(v.soundname)
        end
    end
end)