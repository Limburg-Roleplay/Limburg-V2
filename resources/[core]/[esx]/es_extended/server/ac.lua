-- ESX = nil

local ac = {}
local tokens = {}
local bantokens = {}
local restartedresources = {}

-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    exports['ghmattimysql']:execute('SELECT * FROM `anticheat_bans`', function(result)
        for k,v in pairs(result) do
            local identifier = v.identifier
            local tokens = json.decode(v.tokens)
            bantokens[identifier] = {}
            bantokens[identifier]['reason'] = v.reden
            for k,v in pairs(tokens) do
                if k ~= 'identifier' then
                    bantokens[identifier][v] = {true}
                end
            end
        end
    end)
end)

RegisterCommand('refreshanticheat', function(source, args)
    local src = source
    if src ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getGroup() == 'superadmin' then
            bantokens = {}
            exports['ghmattimysql']:execute('SELECT * FROM `anticheat_bans`', function(result)
                for k,v in pairs(result) do
                    local identifier = v.identifier
                    local tokens = json.decode(v.tokens)
                    bantokens[identifier] = {}
                    bantokens[identifier]['reason'] = v.reden
                    for k,v in pairs(tokens) do
                        if k ~= 'identifier' then
                            bantokens[identifier][v] = {true}
                        end
                    end
                end
                print('[vESX] Succesvol anticheat gerefreshed')
            end)
        end
    else
        bantokens = {}
        exports['ghmattimysql']:execute('SELECT * FROM `anticheat_bans`', function(result)
            for k,v in pairs(result) do
                local identifier = v.identifier
                local tokens = json.decode(v.tokens)
                bantokens[identifier] = {}
                bantokens[identifier]['reason'] = v.reden
                for k,v in pairs(tokens) do
                    if k ~= 'identifier' then
                        bantokens[identifier][v] = {true}
                    end
                end
            end
        end)
    end
end, false)

exports('loadPlayer', function(id, identifier)
    tokens[id] = {}
    tokens[id]['identifier'] = identifier
    for i=1, GetNumPlayerTokens(id) do
        table.insert(tokens[id], GetPlayerToken(id, i))
    end
end)

exports('insertBan', function(identifier, tokens, reason)
    bantokens[identifier] = {}
    bantokens[identifier]['reason'] = reason
    for k,v in pairs(tokens) do
        bantokens[identifier][v] = {true}
    end
end)

exports('checkBan', function(src, reason, def)
    local identifier = nil
    local temptokens = {}
    for k,v in pairs(GetPlayerIdentifiers(src)) do
		if string.find(v, 'steam:') then
			identifier = v
		end
	end
    def.update("🚧: Anticheat Bans aan het bekijken..")
    for i=1, GetNumPlayerTokens(src) do
        local token = GetPlayerToken(src, i)
        if token then
            temptokens[token] = {true}
        end
    end
    for k,v in pairs(bantokens) do
        for x,y in pairs(bantokens[k]) do
            if temptokens[x] then
                def.done("🚧: Je bent aan het verbannen door de Anti-Cheat!\nReden van de verbanning: " .. bantokens[k]['reason'])
                return
            end
        end
    end
    def.done()
end)

exports('getTokens', function(id)
    return tokens[id], tokens[id]['identifier']
end)

exports('generateToken', function(resourcename, id)
    if not ac[id] then
        ac[id] = {}
    end
    if not ac[id][resourcename] then
        ac[id][resourcename] = {['token'] = ESX.GenerateRandomText(16), ['eventname'] = ESX.GenerateRandomText(32)}
        return ac[id][resourcename]['token'], ac[id][resourcename]['eventname']
    else
        if restartedresources[resourcename] then
            ac[id][resourcename] = {['token'] = ESX.GenerateRandomText(16), ['eventname'] = ESX.GenerateRandomText(32)}
            return ac[id][resourcename]['token'], ac[id][resourcename]['eventname']
        else
            ESX.BanPlayer(id, 'Heeft geprobeerd ' .. resourcename .. ' te manipuleren dmv. verifytokens')
        end
    end
end)

exports('verifyToken', function(resourcename, id, token)
    if ac[id][resourcename] then
        if ac[id][resourcename]['token'] == token then
            ac[id][resourcename]['token'] = ESX.GenerateRandomText(16)
            TriggerClientEvent(ac[id][resourcename]['eventname'], id, ac[id][resourcename]['token'])
            return true
        else
            ESX.BanPlayer(id, 'Heeft geprobeerd ' .. resourcename .. ' te manipuleren dmv. verifytokens')
        end
    else
        ESX.BanPlayer(id, 'Heeft geprobeerd ' .. resourcename .. ' te manipuleren dmv. verifytokens')
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    Wait(5000)
    if restartedresources[resourceName] then
        restartedresources[resourceName] = nil
    end
end)  

AddEventHandler('onResourceStop', function(resourceName)
    restartedresources[resourceName] = {true}
end)

AddEventHandler('playerDropped', function(reason)
	local src = source
    ac[src] = nil
end)