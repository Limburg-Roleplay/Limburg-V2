ESX = exports["es_extended"]:getSharedObject()
ESX.RegisterUsableItem("radio", function(source)
    TriggerClientEvent('frp-radio:use', source)
end)

local radioChannels = {}

local function AddPlayerToRadioChannel(playerId, channel)
    if not radioChannels[channel] then
        radioChannels[channel] = {}
    end

    radioChannels[channel][playerId] = true
end

local function RemovePlayerFromRadioChannel(playerId, channel)
    if radioChannels[channel] then
        radioChannels[channel][playerId] = nil
    end
end

local function SendRadioMessage(channel, message)
    if radioChannels[channel] then
        for playerId, _ in pairs(radioChannels[channel]) do
            TriggerClientEvent('receiveRadioMessage', playerId, message)
        end
    end
end

RegisterServerEvent('addToRadioChannel')
AddEventHandler('addToRadioChannel', function(channel)
    local playerId = source
    AddPlayerToRadioChannel(playerId, channel)
end)

RegisterServerEvent('removeFromRadioChannel')
AddEventHandler('removeFromRadioChannel', function(channel)
    local playerId = source
    RemovePlayerFromRadioChannel(playerId, channel)
end)

RegisterServerEvent('sendRadioMessage')
AddEventHandler('sendRadioMessage', function(channel, message)
    SendRadioMessage(channel, message)
end)
