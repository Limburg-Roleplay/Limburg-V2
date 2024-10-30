ESX = nil

if not Config.NewESX then
    TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)
else
    ESX = exports["es_extended"]:getSharedObject()
end

Id = 0

local Units = {}
local Calls = {}
local callSigns = {}
local UnitStatus = {}
local Names = {}

local function GetPlayerInformations(identifier)
    if not Names[identifier] then
        local playerInfo = MySQL.Sync.fetchScalar("SELECT firstname,lastname FROM users WHERE identifier = @identifier LIMIT 1 ", {
            ["@identifier"] = identifier
        })    
        Names[identifier] = {
            firstname = playerInfo.firstname,
            lastname = playerInfo.lastname
        }
    end
    return Names[identifier]
end

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT identifier,firstname,lastname FROM users WHERE 1", {}, function(info)
        for _, v in ipairs(info) do
            Names[v.identifier] = {
                firstname = v.firstname,
                lastname = v.lastname
            }
        end
    end)
end)

RegisterServerEvent("core_dispatch:playerStatus")
AddEventHandler("core_dispatch:playerStatus", function(status)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local identifier = Player.getIdentifier()

    if status.carPlate ~= "" then
        Units[src] = {
            plate = status.carPlate,
            type = status.type,
            job = status.job,
            netId = status.netId,
            identifier = identifier
        }
    else
        Units[src] = {
            plate = math.random(1111, 9999),
            type = 22,
            job = status.job,
            netId = status.netId,
            identifier = identifier
        }
    end
end)

RegisterServerEvent("core_dispatch:removePlayer")
AddEventHandler("core_dispatch:removePlayer", function()
    local src = source

    Units[src] = nil
end)

RegisterServerEvent("core_dispatch:removeCall")
AddEventHandler("core_dispatch:removeCall", function(id)
    local src = source

    if #Calls[tonumber(id)].respondingUnits == 0 then
        Calls[tonumber(id)] = nil
        TriggerClientEvent("core_dispatch:removeCallClient", -1, id, src)
    else
        TriggerClientEvent('core_dispatch:SendTextMessage', src, Config.Text['active_units_error'])
    end
end)

RegisterServerEvent("core_dispatch:unitResponding")
AddEventHandler("core_dispatch:unitResponding", function(id, job)
    local src = source

    if Calls[tonumber(id)] ~= nil then
        table.insert(Calls[tonumber(id)].respondingUnits, {
            unit = src,
            type = job
        })
        TriggerClientEvent("core_dispatch:acceptCallClient", src, id, src)

    else
        TriggerClientEvent('core_dispatch:SendTextMessage', src, Config.Text['cant_accept_call'])
    end
end)

RegisterServerEvent("core_dispatch:changeStatus")
AddEventHandler("core_dispatch:changeStatus", function(userid, status)
    UnitStatus[tostring(userid)] = status

end)

RegisterServerEvent("core_dispatch:unitDismissed")
AddEventHandler("core_dispatch:unitDismissed", function(id)
    local src = source
    local count = 1

    for _, v in ipairs(Calls[tonumber(id)].respondingUnits) do
        if v.unit == src then
            table.remove(Calls[tonumber(id)].respondingUnits, count)
        end
        count = count + 1
    end
end)

RegisterServerEvent("core_dispatch:forwardCall")
AddEventHandler("core_dispatch:forwardCall", function(id, job)
    local add = true
    for _, v in ipairs(Calls[tonumber(id)].job) do
        if v == job then
            add = false
        end
    end

    if add then
        table.insert(Calls[tonumber(id)].job, job)

        TriggerClientEvent("core_dispatch:callAdded", -1, tonumber(id), Calls[tonumber(id)], job, 5000)
    end
end)

local function addMessage(src, phone, message, location, job, cooldown, sprite, color, priority)
    Calls[Id] = {
        code = "",
        title = "",
        extraInfo = {},
        respondingUnits = {},
        coords = location,
        job = {job},
        phone = phone,
        priority = priority or false,
        message = message,
        type = "message",
        caller = src,
        id = Id
    }

    TriggerClientEvent("core_dispatch:callAdded", -1, Id, Calls[Id], job, cooldown or 5000, sprite or 11, color or 5)

    Id = Id + 1
end

exports('addMessage', addMessage)

RegisterServerEvent("core_dispatch:addMessage")
AddEventHandler("core_dispatch:addMessage", function(message, location, job, cooldown, sprite, color, priority)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local identifier = Player.getIdentifier()
    local phone = MySQL.Sync.fetchScalar("SELECT phone_number FROM users WHERE identifier = @identifier ", {
        ["@identifier"] = identifier
    })
    addMessage(src, phone, message, location, job, cooldown, sprite, color, priority)
end)

local function addCall(code, title, info, location, job, cooldown, sprite, color, priority)
    Calls[Id] = {
        code = code,
        title = title,
        extraInfo = info,
        priority = priority or false,
        respondingUnits = {},
        coords = location,
        job = {job},
        type = "call",
        id = Id
    }

    TriggerClientEvent("core_dispatch:callAdded", -1, Id, Calls[Id], job, cooldown or 3500, sprite or 11, color or 5)

    Id = Id + 1
end

exports('addCall', addCall)

RegisterServerEvent("core_dispatch:addCall")
AddEventHandler("core_dispatch:addCall", function(code, title, info, location, job, cooldown, sprite, color, priority)
    addCall(code, title, info, location, job, cooldown, sprite, color, priority)
end)

local function sendAlert(data)
    if data then
        if type(data.job) == 'table' then
            for _, v in ipairs(data.job) do
                Calls[Id] = {
                    code = data.code,
                    title = data.message,
                    extraInfo = data.extraInfo or {},
                    priority = data.priority or false,
                    respondingUnits = {},
                    coords = data.coords,
                    id = Id,
                    job = {v},
                    type = 'call'
                }

                TriggerClientEvent("core_dispatch:callAdded", -1, Id, Calls[Id], v, data.time or 3500, data.blip or 11, data.color or 5)
                Id = Id + 1
            end
        else
            Calls[Id] = {
                code = data.code,
                title = data.message,
                extraInfo = data.extraInfo or {},
                priority = data.priority or false,
                respondingUnits = {},
                coords = data.coords,
                id = Id,
                job = {data.job},
                type = "call"
            }
            TriggerClientEvent("core_dispatch:callAdded", -1, Id, Calls[Id], data.job, data.time or 3500, data.blip or 11, data.color or 5)

            Id = Id + 1
        end
    end
end

RegisterNetEvent('core_dispatch:server:sendAlert', function(data)
    sendAlert(data)
end)

exports('sendAlert', sendAlert)

RegisterServerEvent("core_dispatch:changeCallSign")
AddEventHandler("core_dispatch:changeCallSign", function(callsign)
    local src = source
    if string.len(callsign) <= 4 then
        local Player = ESX.GetPlayerFromId(src)
        Player.set("callsign", callsign)
        callSigns[tostring(src)] = callsign
        TriggerClientEvent('core_dispatch:SendTextMessage', src, Config.Text['callsign_changed'])
    else
        TriggerClientEvent('core_dispatch:SendTextMessage', src, Config.Text['callsign_char_long'])
    end
end)

RegisterServerEvent("core_dispatch:arrivalNotice")
AddEventHandler("core_dispatch:arrivalNotice", function(caller)
    if caller ~= nil then
        TriggerClientEvent("core_dispatch:arrivalNoticeClient", caller)
    end
end)

RegisterCommand("callsign", function(source, args, rawCommand)

    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local job = Player.getJob().name

    for k, v in pairs(Config.SameDepartementJobs) do
        if k == job then
            job = v
        end
    end

    if job == Config.JobOne.job or job == Config.JobTwo.job or job == Config.JobThree.job then
        if string.len(args[1]) <= 4 then

            local Player = ESX.GetPlayerFromId(src)
            Player.set("callsign", args[1])
            callSigns[tostring(src)] = args[1]
            TriggerClientEvent('core_dispatch:SendTextMessage', src, Config.Text['callsign_changed'])
        else
            TriggerClientEvent('core_dispatch:SendTextMessage', src, Config.Text['callsign_char_long'])
        end
    else
        TriggerClientEvent('core_dispatch:SendTextMessage', src, Config.Text['no_permission'])
    end

end)

RegisterServerEvent("core_dispatch:setCallSign")
AddEventHandler("core_dispatch:setCallSign", function(callsign)
    local src = source
    callSigns[tostring(src)] = callsign
end)

ESX.RegisterServerCallback("core_dispatch:getPersonalInfo", function(source, cb)
    local Player =  ESX.GetPlayerFromId(source)
    local identifier =Player.getIdentifier()
    local playerInfos = GetPlayerInformations(identifier)
    local firstname = playerInfos.firstname or "NOT"
    local lastname = playerInfos.lastname or "FOUND"
    cb(firstname, lastname)

end)

ESX.RegisterServerCallback("core_dispatch:getInfo", function(source, cb)
    local generated = {}

    for k, v in pairs(Units) do
        if ESX.GetPlayerFromId(k) then
            local identifier = v.identifier
            local playerInfos = GetPlayerInformations(identifier)
            local firstname = playerInfos.firstname or "NOT"
            local lastname = playerInfos.lastname or "FOUND"
            local job = ESX.GetPlayerFromId(source).job.name

            for k, v in pairs(Config.SameDepartementJobs) do
                if k == job then
                    job = v
                end
            end

            if generated[v.plate] == nil then

                generated[v.plate] = {
                    type = Config.Icons[v.type],
                    units = {{
                        id = k,
                        name = firstname .. " " .. lastname,
                        job = job
                    }},
                    job = v.job
                }
            else
                table.insert(generated[v.plate].units, {
                    id = k,
                    name = firstname .. " " .. lastname,
                    job = job
                })
            end
        end
    end
    cb(generated, Calls, UnitStatus, callSigns)
end)

ESX.RegisterServerCallback("core_dispatch:getUnits", function(source, cb)
    local generated = {}

    for k, v in pairs(Units) do
        if ESX.GetPlayerFromId(k) then
            local identifier = v.identifier
            local playerInfos = GetPlayerInformations(identifier)
            local firstname = playerInfos.firstname or "NOT"
            local lastname = playerInfos.lastname or "FOUND"

            generated[k] = {
                netId = v.netId,
                firstname = firstname,
                lastname = lastname,
                type = v.type,
                job = v.job
            }
        end
    end
    cb(generated)
end)
