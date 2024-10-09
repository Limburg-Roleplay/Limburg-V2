local radioMenu = false
local onRadio = false
local RadioChannel = 0
local RadioVolume = 50
local hasRadio = false
local radioProp = nil
local isDead = false

-- Voeg deze code toe aan je client.lua-bestand
RegisterCommand("radio", function()
    if not isDead then
        toggleRadio(not radioMenu)
    else
        ESX.ShowNotification('info', 'Je kan geen radio gebruiken als je dood bent!', 5000)
    end
end)

RegisterKeyMapping("toggleRadio", "Toggle Radio", "keyboard", "R") -- Dit maakt de 'R'-toets beschikbaar om de radio te openen/sluiten

Citizen.CreateThread(function()
	while not ESX.PlayerLoaded do
		Wait(0) 
	end

	Citizen.SetTimeout(5000, function()
		local item = exports.ox_inventory:Search('count', 'radio')
		if item > 0 then
			hasRadio = true
		end
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true

    Citizen.SetTimeout(5000, function()
		local item = exports.ox_inventory:Search('count', 'radio')
		if item > 0 then
			hasRadio = true
		end
	end)
end)

-- Voeg deze code toe om de radio te sluiten via de ESC-toets
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if radioMenu and IsControlJustReleased(0, 322) then -- 322 is de ESC-toets
            toggleRadio(false)
        end
    end
end)


--Function
local function LoadAnimDic(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

local function SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t+1] = str
    end
    return t
end

local function connecttoradio(channel)
    RadioChannel = channel
    if onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    exports["pma-voice"]:setRadioChannel(channel)
    if SplitStr(tostring(channel), ".")[2] ~= nil and SplitStr(tostring(channel), ".")[2] ~= "" then
        ESX.ShowNotification('info', Config.messages['joined_to_radio']..channel.. ' MHz', 5000)
    else
        ESX.ShowNotification('info', Config.messages['joined_to_radio'] ..channel.. '.00 MHz', 5000)

    end
end

local function closeEvent()
	TriggerEvent("InteractSound_CL:PlayOnOne","click",0.6)
end

local function leaveradio()
    closeEvent()
    RadioChannel = 0
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    ESX.ShowNotification('info', Config.messages['you_leave'], 5000)
end

local function toggleRadioAnimation(pState)
	LoadAnimDic("cellphone@")
	if pState then
		TriggerEvent("attachItemRadio","radio01")
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_in", 4.0, -1, -1, 50, -30, false, false, false)
        local co = GetEntityCoords(PlayerPedId())
        local he = GetEntityHeading(PlayerPedId())

        TaskPlayAnimAdvanced(PlayerPedId(), "cellphone@", "cellphone_text_in", co.x, co.y, co.z, 0, 0, he, 0.8, 1.0, -1, 50, 0.0, 0, 0)

		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		if radioProp ~= 0 then
			DeleteObject(radioProp)
			radioProp = 0
		end
	end
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    if radioMenu then
        if not IsPedSwimmingUnderWater(PlayerPedId()) then
            toggleRadioAnimation(true)
            SendNUIMessage({type = "open"})
        end
    else
        toggleRadioAnimation(false)
        SendNUIMessage({type = "close"})
    end
end

local function IsRadioOn()
    return onRadio
end

local function DoRadioCheck()
    while not ESX.PlayerLoaded do Wait(0) end
    local PlayerData = ESX.GetPlayerData()
    local _hasRadio = false
    local count = exports.ox_inventory:Search('count', 'radio')
    if count >= 1 then
        _hasRadio = true
    end

    return _hasRadio
end


exports("IsRadioOn", IsRadioOn)

RegisterCommand("radio", function(source, args, rawCommand)
    TriggerEvent('frp-radio:use', source)
end)

RegisterNetEvent('frp-radio:use', function()
    if not isDead then
        toggleRadio(not radioMenu)
    else
        ESX.ShowNotification('info', 'Je kan geen radio gebruiken als je dood bent!', 5000)
    end
end)

RegisterNetEvent('frp-radio:onRadioDrop', function()
    if RadioChannel ~= 0 then
        leaveradio()
    end
end)

-- NUI
RegisterNUICallback('joinRadio', function(data, cb)
    local PlayerData = ESX.GetPlayerData()
    local rchannel = tonumber(data.channel)
    
    if rchannel ~= nil then
        if rchannel <= Config.MaxFrequency and rchannel ~= 0 then
            if Config.RestrictedChannels[rchannel] ~= nil then
                if Config.RestrictedChannels[rchannel][PlayerData.job.name] then
                    connecttoradio(rchannel)
                else
                    ESX.ShowNotification('info', Config.messages['restricted_channel_error'], 5000)
                end
            else
                connecttoradio(rchannel)
            end
        else
           ESX.ShowNotification('info', Config.messages['invalid_radio'], 5000)
        end
    else
        ESX.ShowNotification('info', Config.messages['invalid_radio'], 5000)
    end
    cb("ok")
end)

RegisterNUICallback('leaveRadio', function(_, cb)
    if RadioChannel == 0 then
        ESX.ShowNotification('info', Config.messages['not_on_radio'], 5000)
    else
        leaveradio()
    end
    cb("ok")
end)

RegisterNUICallback("volumeUp", function(_, cb)
	if RadioVolume <= 95 then
		RadioVolume = RadioVolume + 5
        ESX.ShowNotification('info', Config.messages["volume_radio"] .. RadioVolume, 5000)
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
        ESX.ShowNotification('info',Config.messages["decrease_radio_volume"], 5000)
	end
    cb('ok')
end)

RegisterNUICallback("volumeDown", function(_, cb)
	if RadioVolume >= 10 then
		RadioVolume = RadioVolume - 5
        ESX.ShowNotification('info', Config.messages["volume_radio"] .. RadioVolume, 5000)
		exports["pma-voice"]:setRadioVolume(RadioVolume)
	else
        ESX.ShowNotification('info', Config.messages["increase_radio_volume"], 5000)
	end
    cb('ok')
end)

RegisterNUICallback("increaseradiochannel", function(_, cb)
    if cooldown > 0 then ESX.ShowNotification('error', 'Wacht ' .. cooldown .. ' met het wisselen van kanaal..') return end
    local newChannel = RadioChannel + 1
    exports["pma-voice"]:setRadioChannel(newChannel)
    QBCore.Functions.Notify(Config.messages["increase_decrease_radio_channel"] .. newChannel, "success")
    ESX.ShowNotification('info', Config.messages["increase_decrease_radio_channel"] .. newChannel, 5000)
    
    cb("ok")
end)

RegisterNUICallback("decreaseradiochannel", function(_, cb)
    if not onRadio then return end
    if cooldown > 0 then ESX.ShowNotification('error', 'Wacht ' .. cooldown .. ' met het wisselen van kanaal..') return end
    local newChannel = RadioChannel - 1
    if newChannel >= 1 then
        exports["pma-voice"]:setRadioChannel(newChannel)
        ESX.ShowNotification('info', Config.messages["increase_decrease_radio_channel"] .. newChannel, 5000)

        cb("ok")
    end
end)

RegisterNUICallback('poweredOff', function(_, cb)
    leaveradio()
    cb("ok")
end)

RegisterNUICallback('escape', function(_, cb)
    toggleRadio(false)
    cb("ok")
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    if RadioChannel ~= 0 then
        leaveradio()
    end
    isDead = true
    toggleRadio(false)
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

--Main Thread
CreateThread(function()
    while true do
        Wait(1000)
        if not DoRadioCheck() then
            hasRadio = false
            if RadioChannel ~= 0 then
                toggleRadio(false)
                leaveradio()
                ESX.ShowNotification('info', 'Je hebt geen radio in je inventory!', 5000)
            end
        else
            hasRadio = true
        end
    end
end)

RegisterKeyMapping('+Portoup', 'Porto kanaal omhoog', 'keyboard', 'PAGEUP')
RegisterKeyMapping('+Portodown', 'Porto kanaal omlaag', 'keyboard', 'PAGEDOWN')

RegisterCommand('+Portodown', function(source, args, RawCommand)
    if hasRadio and not isDead then
        local newChannel = RadioChannel - 1
        if newChannel >= 1 then
            if Config.RestrictedChannels[newChannel] and not Config.RestrictedChannels[newChannel][ESX.PlayerData.job.name] then return end
            exports["pma-voice"]:setRadioChannel(newChannel)
            RadioChannel = newChannel
            ESX.ShowNotification('info', Config.messages["increase_decrease_radio_channel"] .. newChannel, 5000)
        end
    end
end, false)

RegisterCommand('+Portoup', function(source, args, RawCommand)
    if hasRadio and not isDead then
        local newChannel = RadioChannel + 1
        if Config.RestrictedChannels[newChannel] and not Config.RestrictedChannels[newChannel][ESX.PlayerData.job.name] then return end
        exports["pma-voice"]:setRadioChannel(newChannel)
        RadioChannel = newChannel
        ESX.ShowNotification('info',  Config.messages["increase_decrease_radio_channel"] .. newChannel, 5000)
    end
end, false)
