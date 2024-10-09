local voiceModes = {
    [1] = { -- Whisper
        r = 15, g = 255, b = 255 
    },
    [2] = { -- Normal
        r = 15, g = 255, b = 255
    },
    [3] = { -- Shouting
       r = 15, g = 255, b = 255
    }
}
local lerpSpeed = 0.1

local bThreadCreated = false
local currentVoiceMode = voiceModes[1]
local endTime = GetGameTimer()
local proximityRange = 0.0
local lerpRange = 0.0
local drawDuration = 2000

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function createCircleThread()
    CreateThread(function()
        local ped = cache.ped
        while GetGameTimer() < endTime do
            local pos = GetEntityCoords(ped)
            pos = vec3(pos.x, pos.y, pos.z - 1.0)
            local drawAlpha = math.floor((endTime - GetGameTimer()) / drawDuration * 255)
            DrawMarker(1, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, lerpRange, lerpRange, 0.125, currentVoiceMode.r, currentVoiceMode.g, currentVoiceMode.b, drawAlpha, false, true, 2, nil, nil, false)
            DrawMarker(1, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, lerpRange, lerpRange, -0.125, currentVoiceMode.r, currentVoiceMode.g, currentVoiceMode.b, drawAlpha, false, true, 2, nil, nil, false)
            lerpRange = Lerp(lerpRange, proximityRange, lerpSpeed)
            Wait(0)
        end
    end)
end

local function updateVoiceInfo()
    local proximity = LocalPlayer.state.proximity
    if proximity then
        currentVoiceMode = voiceModes[proximity.index]
        proximityRange = (proximity.distance or 1) * 4
    end
end

AddEventHandler('pma-voice:setTalkingMode', function()
    updateVoiceInfo()
    if not (GetGameTimer() >= endTime) then
        createCircleThread()
    end
    endTime = GetGameTimer() + drawDuration
end)

CreateThread(function()
    while GetResourceState('pma-voice') ~= 'started' do
        Wait(50)
    end
    updateVoiceInfo()
end)