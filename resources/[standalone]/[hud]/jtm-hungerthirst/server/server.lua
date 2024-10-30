local Slang = {}

local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end
local function updatePlayerStatus(playerId, itemType, amount)
    local player = ESX.GetPlayerFromId(playerId)
    for i, v in ipairs(Slang) do
        if v.id == playerId then
            local data = json.decode(v.data)
            for _, intdata in pairs(data) do
                if intdata.name == itemType then
                    if tonumber(intdata.percent) + tonumber(amount) >= 100 then
                        intdata.percent = 100
                    else
                        intdata.percent = tonumber(intdata.percent) + tonumber(amount)
                    end
                    if Config.Debug then
                        print("Updated " .. itemType .. ": " .. intdata.percent)
                    end
                end
            end
            v.data = json.encode(data)
            TriggerClientEvent("sl-status:receive:status", playerId, data)
            MySQL.Async.execute(
                "UPDATE users SET status = @status WHERE identifier = @identifier",
                {
                    ["@status"] = v.data,
                    ["@identifier"] = player.identifier
                },
                function(rowsChanged)
                    if not rowsChanged then
                        print("Failed to update status in the database for player: " .. player.identifier)
                    end
                end
            )
            break
        end
    end
end
AddEventHandler(
    "ox_inventory:usedItem",
    function(playerId, name, slotId, metadata)
        if Config.Items[name] then
            local itemData = Config.Items[name]
            if itemData.type == "hunger" or itemData.type == "thirst" or itemData.type == "drunk" then
                updatePlayerStatus(playerId, itemData.type, itemData.amount)
            end
        end
    end
)

AddEventHandler(
    "playerDropped",
    function(reason)
        local src = source
        local player = ESX.GetPlayerFromId(src)
        if not player then
            return
        end

        for i, v in ipairs(Slang) do
            if v.id == src then
                local data = v.data
                MySQL.Async.execute(
                    "UPDATE users SET status = @status WHERE identifier = @identifier",
                    {
                        ["@status"] = data,
                        ["@identifier"] = player.identifier
                    },
                    function(rowsChanged)
                        if not rowsChanged then
                            print("Failed to update status in the database for player: " .. player.identifier)
                        end
                    end
                )
                table.remove(Slang, i)
                break
            end
        end
    end
)

RegisterNetEvent("sl-status:get:status")
AddEventHandler(
    "sl-status:get:status",
    function(resetStatus)
        local src = source
        local player = ESX.GetPlayerFromId(src)
        if not player then
            return
        end

        if resetStatus then
            local defaultStatus =
                json.encode(
                {
                    {name = "hunger", percent = 100},
                    {name = "thirst", percent = 100},
                    {name = "drunk", percent = 0}
                }
            )
            MySQL.Async.execute(
                "UPDATE users SET status = @status WHERE identifier = @identifier",
                {
                    ["@status"] = defaultStatus,
                    ["@identifier"] = player.identifier
                },
                function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent("sl-status:receive:status", src, json.decode(defaultStatus))
                    end
                end
            )
        else
            MySQL.Async.fetchScalar(
                "SELECT status FROM users WHERE identifier = @identifier",
                {
                    ["@identifier"] = player.identifier
                },
                function(status)
                    if status then
                        local statusData = json.decode(status)
                        table.insert(Slang, {id = src, data = status})
                        TriggerClientEvent("sl-status:receive:status", src, statusData)
                    else
                        print("Failed to fetch status for player: " .. player.identifier)
                    end
                end
            )
        end
    end
)
-- Function to decay hunger, thirst, and drunk status
RegisterNetEvent("sl-status:decayStatus")
AddEventHandler("sl-status:decayStatus", function(playerId)
    local player = ESX.GetPlayerFromId(playerId)
    
    if player then
        for _, v in ipairs(Slang) do
            local statusData = json.decode(v.data)

            for _, stat in ipairs(statusData) do
                if stat.name == "hunger" or stat.name == "thirst" or stat.name == "drunk" then
                    local decayAmount = math.random(3, 5) -- Decrement by a random amount between 3 and 5
                    stat.percent = math.max(0, stat.percent - decayAmount) -- Ensure values don't go below 0
                end
            end

            v.data = json.encode(statusData) -- Re-encode and store the updated data
            TriggerClientEvent("sl-status:receive:status", v.id, statusData) -- Update client-side status

            MySQL.Async.execute(
                "UPDATE users SET status = @status WHERE identifier = @identifier",
                {
                    ["@status"] = v.data,
                    ["@identifier"] = player.identifier
                },
                function(rowsChanged)
                    if not rowsChanged then
                        print("Failed to update status in the database for player: " .. player.identifier)
                    end
                end
            )
        end
    end
end)

function startStatusDecay()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.Cooldown * 1000)

            local players = GetPlayers()
            for _, playerId in ipairs(players) do
                TriggerEvent("sl-status:decayStatus", playerId)
            end
        end
    end)
end

startStatusDecay()

RegisterCommand('heal', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if args[1] == "me" then
        targetId = source
    end
    
    if not targetId or targetId <= 0 then
        TriggerClientEvent('chat:addMessage', source, { args = { '[Heal]', 'Invalid player ID!' } })
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'owner' then
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        if targetPlayer then
            for _, v in ipairs(Slang) do
                if v.id == targetId then
                    local statusData = json.decode(v.data)

                    for _, stat in ipairs(statusData) do
                        if stat.name == "hunger" or stat.name == "thirst" then
                            stat.percent = 100
                        end
                    end

                    v.data = json.encode(statusData)
                    TriggerClientEvent("sl-status:receive:status", targetId, statusData)

                    MySQL.Async.execute(
                        "UPDATE users SET status = @status WHERE identifier = @identifier",
                        {
                            ["@status"] = v.data,
                            ["@identifier"] = targetPlayer.identifier
                        }
                    )
                    break
                end
            end

            TriggerClientEvent('chat:addMessage', source, { args = { '[Heal]', 'You have healed ' .. targetPlayer.name .. '!' } })
            TriggerClientEvent('chat:addMessage', targetId, { args = { '[Heal]', 'You have been healed!' } })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '[Heal]', 'Player not found!' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '[Heal]', 'Insufficient permissions!' } })
    end
end, false)


RegisterNetEvent('esx_status:setPlayerStatus')
AddEventHandler('esx_status:setPlayerStatus', function(executorId, targetId, hunger, thirst)
    local xPlayer = ESX.GetPlayerFromId(executorId)

    if executorId == 0 or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'owner' then
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        if targetPlayer then
            for _, v in ipairs(Slang) do
                if v.id == targetId then
                    local statusData = json.decode(v.data)

                    for _, stat in ipairs(statusData) do
                        if stat.name == "thirst" then
                            stat.percent = math.min(thirst, 100)
                        end
                        if stat.name == "hunger" then
                            stat.percent = math.min(hunger, 100)
                        end
                    end

                    v.data = json.encode(statusData)
                    TriggerClientEvent("sl-status:receive:status", targetId, statusData)

                    MySQL.Async.execute(
                        "UPDATE users SET status = @status WHERE identifier = @identifier",
                        {
                            ["@status"] = v.data,
                            ["@identifier"] = targetPlayer.identifier
                        }
                    )
                    break
                end
            end
        end
    end
end)


exports('setPlayerStatus', function(executorId, targetId, hunger, thirst)
    local _source = source
    TriggerEvent('esx_status:setPlayerStatus', executorId, targetId, hunger, thirst)
end)
