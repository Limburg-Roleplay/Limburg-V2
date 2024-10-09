RegisterServerEvent('mn-tx:server:discordlog')
AddEventHandler('mn-tx:server:discordlog', function(txUsername, ingeklokt)
    local src = source 
    local user = ESX.GetPlayerFromId(src)
    local message = ''

    if ingeklokt then 
        message = '**Steamnaam**: ' .. GetPlayerName(src) .. '\n**Steam Identifier**: ' .. user.identifier .. '\n**txAdmin username**: ' .. txUsername .. '\n**Datum/tijd van inklokken**: ' .. os.date ("%c") .. '\n**Klokstatus:** ' .. tostring(ingeklokt)
    else
        message = '**Steamnaam**: ' .. GetPlayerName(src) .. '\n**Steam Identifier**: ' .. user.identifier .. '\n**txAdmin username**: ' .. txUsername .. '\n**Datum/tijd van uitklokken**: ' .. os.date ("%c") .. '\n**Klokstatus:** ' .. tostring(ingeklokt)
    end

    local discordInfo = {
        ["color"] = "16711680",
        ["type"] = "rich",
        ["title"] = "[atlantic-tx]",
        ["description"] = message,
        ["footer"] = {
        ["text"] = "made with rickieplays atlantic roleplay"
        }
    }
    PerformHttpRequest(MN.webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Atlantic Roleplay', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('bc-logging:createlog')
AddEventHandler('bc-logging:createlog', function(webhook, message, tagg, type)
    sendtoDiscord(webhook, message, false, type)
end)


function sendtoDiscord(webhook, message, tagg, type)
    local WebHook = webhook

    local discordInfo = {
        ["color"] = "10565803",
        ["type"] = "rich",
        ["title"] = "[Atlantic Logging]",
        ["description"] = message,
        ["footer"] = {
        ["text"] = "Utopia " .. type .. " Loggs"
        }
    }
    if tagg then
        PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Utopia', content = "@here" }), { ['Content-Type'] = 'application/json' })
        PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Utopia', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
    else
        PerformHttpRequest(WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'Utopia', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
    end
end