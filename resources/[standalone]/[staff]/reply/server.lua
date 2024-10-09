local xcustomcmd = ""
local xwebhook =
    GetConvar(
    "xwebhook",
    "https://discord.com/api/webhooks/1193597549563609208/duMT26l6RlpMpf5annq-dTpUBg_WRrPiXEzYwOIPZ1nEqXaoSvZ2QHY_4o4c-bq0uLzx"
)
local xswebhook =
    GetConvar(
    "xswebhook",
    "https://discord.com/api/webhooks/1193597187792322741/nxy7egjmvOzcxFYfjg46gmMwC-l2d1-OXX9Z_J4hAW-n-NS6CZ_jLj7co_AVxTY4y8AC"
)

-- admin chat
RegisterCommand(
    "a",
    function(source, args, rawCommand)
        if IsPlayerAceAllowed(source, "xadmin.all") or IsPlayerAceAllowed(source, "xadmin.a") and args[1] then
            local a = string.gsub(rawCommand, xcustomcmd .. "a ", "")
            local playerName = GetPlayerName(args[1])
            local admin = GetPlayerName(source)
            if xwebhook ~= "none" then
                PerformHttpRequest(
                    xwebhook,
                    function(err, text, headers)
                    end,
                    "POST",
                    json.encode({content = "**A**```Admin:" .. admin .. "\nA:" .. a .. "```"}),
                    {["Content-Type"] = "application/json"}
                )
            end
            for _, playerId in ipairs(GetPlayers()) do
                if IsPlayerAceAllowed(playerId, "xadmin.all") or IsPlayerAceAllowed(playerId, "xadmin.a") then
                    TriggerClientEvent(
                        "chatMessage",
                        playerId, "Admin Chat (Admin: " .. admin .. ")","staff",
                        a
                    )
                end
            end
        else
            print('You do not have permissions for this command')
		end
    end
)
-- reply
RegisterCommand(
    "reply",
    function(source, args, rawCommand)
        if
            IsPlayerAceAllowed(source, "xadmin.all") or
                IsPlayerAceAllowed(source, "xadmin.reply") and args[1] and args[2]
         then
            if GetPlayerName(args[1]) then
                local replay = string.gsub(rawCommand, xcustomcmd .. "reply " .. args[1] .. " ", "")
                local playerId2 = args[1]
                local playerName = GetPlayerName(args[1])
                local admin = GetPlayerName(source)
                if xwebhook ~= "none" then
                    PerformHttpRequest(
                        xwebhook,
                        function(err, text, headers)
                        end,
                        "POST",
                        json.encode(
                            {
                                content = "**Reply**```Admin:" ..
                                    admin .. "\nPlayer:" .. playerName .. "\nReplay:" .. replay .. "```"
                            }
                        ),
                        {["Content-Type"] = "application/json"}
                    )
                end
                for _, playerId in ipairs(GetPlayers()) do
                    if
                        IsPlayerAceAllowed(playerId, "xadmin.all") or IsPlayerAceAllowed(playerId, "xadmin.reply") or
                            playerId == playerId2
                     then
                        TriggerClientEvent(
                        "chatMessage",
                        playerId, "Reply: [" .. source .. "] ".. admin .. " -> [" .. playerId2 .. "] ".. playerName,"reply",
                        replay
                    )
                    end
                end
                --TriggerClientEvent(
                --        "chatMessage",
                --        source, "Report Reply (Admin: " .. admin .. ")","primary",
                --        "Sent!"
                --    )
            end
        else
            print('You do not have permissions for this command')
		end
    end
)

-- screenshot
RegisterCommand(
    "screenshot",
    function(source, args)
        if
            IsPlayerAceAllowed(source, "xadmin.all") or
                IsPlayerAceAllowed(source, "xadmin.screenshot") and args[1] and
                    GetResourceState("screenshot-basic") == "started"
         then
            if GetPlayerName(args[1]) then
                local playerId = args[1]
                local playerName = GetPlayerName(args[1])
                local admin = GetPlayerName(source)
                if xwebhook ~= "none" then
                    PerformHttpRequest(
                        xwebhook,
                        function(err, text, headers)
                        end,
                        "POST",
                        json.encode(
                            {content = "**Screenshot**```Admin:" .. admin .. "\nPlayer:" .. playerName .. "```"}
                        ),
                        {["Content-Type"] = "application/json"}
                    )
                end
                if xswebhook ~= "none" then
                    TriggerClientEvent("xadmin:screenshot", playerId, xswebhook)
                end
            end
        else
            print('You do not have permissions for this command')
		end
    end
)