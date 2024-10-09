ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function KrijgIdentifiers(src)
    local identifiers = {
        steam = "Onbekend",
        discord = "Onbekend",
        license = "Onbekend",
        license2 = "Onbekend",
        xbl = "Onbekend",
        live = "Onbekend",
        fivem = "Onbekend"
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam:") then
            identifiers['steam'] = id
        elseif string.find(id, "discord:") then
            identifiers['discord'] = id
        elseif string.find(id, "license:") then
            identifiers['license'] = id
        elseif string.find(id, "license2:") then
            identifiers['license2'] = id
        elseif string.find(id, "xbl:") then
            identifiers['xbl'] = id
        elseif string.find(id, "live:") then
            identifiers['live'] = id
        elseif string.find(id, "fivem:") then
            identifiers['fivem'] = id
        end
    end
    return identifiers
end

AddEventHandler("playerDropped", function(reason)
    createLog('https://discord.com/api/webhooks/1226482269858824263/TXBN00lPEn6AWB800xlIEJNjmJvW6XIwHugk3VHVfa1InBHM7uVeW-vPIROEvQnhrudv', 'Speler Geleaved', '**Speler:** '..GetPlayerName(source)..'\n**Eventuele Reden:** '..reason, false, 'Leave')
end)

RegisterServerEvent('frp-logger:schotenGelost')
AddEventHandler('frp-logger:schotenGelost', function(weapon, count)
    createLog('https://discord.com/api/webhooks/1226482349001408512/l2cW6PDrFeehiFyDXwjCe8XLP_XwhkoTe36TRE2bYuX9hS3Hl2bDW8KUVIn9YHENkQHK', 'Schoten Gelost', '**Speler:** '..GetPlayerName(source)..'\n**Wapen:** '..weapon..'\n**Aantal Schoten:** '..count, false, 'Schoten')
end)

RegisterServerEvent('frp-logger:createlog')
AddEventHandler('frp-logger:createlog', function(webhook, title, message, tag, type)
    createLog(webhook, title, message, tag, type)
end)

function createLog(webhook, title, message, tag, type)
    local WebHook = webhook

    local discordInfo = {
        ["color"] = 3447003,
        ["type"] = "rich",
        ["author"] = {                    
            name = "Limburg Schoten Logs",
            icon_url = "https://cdn.discordapp.com/attachments/1249792712689844325/1258731203729555536/BoinaVerde.png?ex=66891c49&is=6687cac9&hm=3a07eb6be26e981466b2675c7a45148db6ee81b8d8dd2975fef49b1d430a78f9&"
        },
        ["title"] = title,
        ["description"] = message,
        ["footer"] = {
            ["text"] = type .." Handeling • " ..os.date("%x %X %p"),
        }
    }
    if tag then
        PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Limburg Roleplay', content = "@here" }), { ['Content-Type'] = 'application/json' })
        PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Limburg Roleplay', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
    else
        PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Limburg Roleplay', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
    end
end