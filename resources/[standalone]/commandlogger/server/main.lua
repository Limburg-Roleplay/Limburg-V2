local thisResource = GetCurrentResourceName()

local DiscordWebHookSettings = {
    url = Config.discordWebHookUrl,
    image = Config.discordWebHookImage
}

local blacklistedCommands = {
    "/me",
    "/rs",
    "/e",
    "/med",
    "/twt",
    "/radio",
    "/report",
    "/shuff",
    "/postcode",
}
local function isBlacklisted(command)
    local commandOnly = string.match(command, "^[^%s]+")
    
    for _, blacklistedCommand in ipairs(blacklistedCommands) do
        if commandOnly == blacklistedCommand then
            return true
        end
    end
    return false
end

RegisterServerEvent('td_logs:sendLog')
AddEventHandler('td_logs:sendLog', function(webhook, playerId, data, color)
        local webhook = Webhook(webhook, "https://cdn.discordapp.com/attachments/1058040700064776212/1262478090899292200/Limburg_Roleplay_Blauw.png?ex=66976698&is=66961518&hm=60644e07abcb9601328ec7a977e0ec7f65db747a533c7b6c45c212b734c04cca&")
        if not webhook or not playerId or not data then return print('no data') end
        webhook.sendLog(playerId, data.title, data.desc, color)
end)
RegisterServerEvent('td_logs:sendLogNoFields')
AddEventHandler('td_logs:sendLogNoFields', function(webhook, data, color)
        local webhook = Webhook(webhook, "https://cdn.discordapp.com/attachments/1058040700064776212/1262478090899292200/Limburg_Roleplay_Blauw.png?ex=66976698&is=66961518&hm=60644e07abcb9601328ec7a977e0ec7f65db747a533c7b6c45c212b734c04cca&")
        if not webhook or not data then return print('no data') end
        webhook.sendLogNoFields(data.title, data.desc, color)
end)

RegisterServerEvent('commandLoggerDiscord:commandWasExecuted')
AddEventHandler('commandLoggerDiscord:commandWasExecuted', function(playerId, data)
    local commandChecker = CommandChecker()

    if commandChecker.isCommand(data.message) then
        if not isBlacklisted(string.lower(data.message)) then
            local webhook = Webhook(DiscordWebHookSettings.url, DiscordWebHookSettings.image)
            webhook.send(playerId, data.message)
        end
    end
end)