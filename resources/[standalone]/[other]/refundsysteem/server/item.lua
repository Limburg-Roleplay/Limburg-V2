ESX = exports["es_extended"]:getSharedObject()

local function isNumeric(str)
    return str:match("^%d+$") ~= nil
end
RegisterCommand("giverefund", function(source, args, rawCommand)
    if source == 0 or IsPlayerAceAllowed(source, "xadmin.all") or IsPlayerAceAllowed(source, "xadmin.refunds") then
        if #args < 3 then
            print("Usage: /giverefund [player steam id] [item] [item-count]")
            return
        end

        local steamID, item, itemCount = table.unpack(args)
        if not string.match(steamID, '^steam:') and not string.match(steamID, '^discord:') then
            local isSteamID = string.match(steamID, '%d')
    
            if not isNumeric(steamID) then
                steamID = "steam:" .. steamID
            else
                steamID = "discord:" .. steamID
            end
        end
        TriggerEvent('td_refunds:insertRefund', source, steamID, item, itemCount)
    else
        print("Geen permissie.")
    end
end, true)

RegisterNetEvent('td_refunds:insertRefund')
AddEventHandler('td_refunds:insertRefund', function(source, steamID, item, itemCount)
    source = tonumber(source)
    if not source == 0 then
        return
    end
    MySQL.Async.execute(
        "INSERT INTO user_refunds (steamID, item, itemCount) VALUES (@steamID, @item, @itemCount)",
        {
            ["@steamID"] = steamID,
            ["@item"] = item,
            ["@itemCount"] = itemCount
        },
        function(rowsChanged)
            if rowsChanged > 0 then
                local user = (source > 0) or "console"
                local playerName = (source > 0) and GetPlayerName(source) or "console"
                TriggerEvent(
                    "td_logs:sendLog",
                    "https://discord.com/api/webhooks/1263084444126937139/mt-6esOqJ_oH2NTqjwrXz5PzlAEfbZl15h1wHQzYhgCIGe0GQh_2xiZV7DtGdSYTv38p",
                    user,
                    {
                        title = playerName .. " heeft zojuist een refund geplaatst.",
                        desc = "Betreft: " .. itemCount .. "x " .. item
                    }
                )
                print("Refund succesvol toegekent.")
            else
                print("Kon geen refunds vinden.")
            end
        end
    )
end)

RegisterCommand(
    "claimrefunds",
    function(source, args, rawCommand)
        local xPlayer = ESX.GetPlayerFromId(source)
        local playerIdentifiers = GetPlayerIdentifiers(source)
        local steamID = nil
        local discordID = nil

        for _, identifier in ipairs(playerIdentifiers) do
            if string.sub(identifier, 1, 5) == "steam" then
                steamID = identifier
            elseif string.sub(identifier, 1, 7) == "discord" then
                discordID = identifier
            end
        end

        MySQL.Async.fetchAll(
            "SELECT * FROM user_refunds WHERE steamID = @steamID OR steamID = @discordID",
            {
                ["@steamID"] = steamID,
                ["@discordID"] = discordID
            },
            function(results)
                if #results == 0 then
                    print("Je hebt geen refunds om te claimen.")
                    return
                end

                for _, refund in ipairs(results) do
                    local item = refund.item
                    local itemCount = refund.itemCount
                    -- Mark the refund as claimed
                    MySQL.Async.execute(
                        "DELETE FROM user_refunds WHERE id = @id",
                        {
                            ["@id"] = refund.id
                        },
                        function(rowsChanged)
                            if rowsChanged > 0 then
                                xPlayer.addInventoryItem(item, itemCount)
                                print("Refund toegekent.")
                                TriggerEvent(
                                    "td_logs:sendLog",
                                    "https://discord.com/api/webhooks/1263110371506524210/l8Ssiqtu-C49ErNLofSpc7eUmsJhZTuGbz2W1iaDsZznwOW9uLyuk9Q4ioLHJ10Usxju",
                                    source,
                                    {
                                        title = GetPlayerName(source) .. " heeft zojuist een refund geclaimed.",
                                        desc = "Betreft: " .. itemCount .. "x " .. item
                                    }
                                )
                            end
                        end
                    )
                end

                xPlayer.showNotification("All refunds claimed.")
            end
        )
    end
)

