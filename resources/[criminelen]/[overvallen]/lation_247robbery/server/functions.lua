-- Function that produces Discord Webhook logs
--- @param title string Title of the log
--- @param message string Message contents
--- @param color number Decimal value embed color
DiscordLogs = function(title, message, color)
    local connect = {{["color"] = color, ["title"] = "**".. title .."**", ["description"] = message, ["footer"] = {["text"] = os.date("%a %b %d, %I:%M%p"), ["icon_url"] = Config.WebhookFooterImage}}}
    PerformHttpRequest("https://discord.com/api/webhooks/1283467016757448776/2nrKT5dOJwURSzF2Sc3KwkOIqWoAFJ7V3_lR-E_RUt3c6224cweQFqoUZ1X_S2vTcMPu", function(err, text, headers) end, 'POST', json.encode({username = Config.WebhookName, embeds = connect, avatar_url = Config.WebhookImage}), { ['Content-Type'] = 'application/json' })
end