--[[
BY RX Scripts © rxscripts.xyz
--]]

function RegisterStash(stash)
    if OXInv then
        OXInv:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner, false)
    elseif not QBInv and not QSInv and not PSInv then
        Error("No inventory found for registering stash (server/opensource.lua:5)")
    end
end

function UpgradeStash(stashId, newWeight, newSlots)
    if OXInv then
        OXInv:SetMaxWeight(stashId, newWeight)
        OXInv:SetSlotCount(stashId, newSlots)
    else
        Error("No inventory found for upgrading stash (server/opensource.lua:11)")
    end
end

function Notify(src, msg, type)
    if ESX then
        local notifyType = 'info'  -- standaard notificatie type
        if type == 'error' then
            notifyType = 'error'
        elseif type == 'success' then
            notifyType = 'success'
        elseif type == 'warning' then
            notifyType = 'warning'
        end

        TriggerClientEvent('okokNotify:Alert', src, 'Notificatie', msg, 5000, notifyType)
    elseif QB then
        if type == 'info' then type = nil end
        TriggerClientEvent('QBCore:Notify', src, msg, type)
    end
end

function GetPlayerBySrc(src)
    if ESX then
        return ESX.GetPlayerFromId(src)
    elseif QB then
        return QB.Functions.GetPlayer(src)
    end
end

function HasGroup(src, group)
    if ESX then
        return ESX.GetPlayerFromId(src).getGroup() == group
    elseif QB then
        return QB.Functions.HasPermission(src, group)
    end
end

function GetJob(src)
    if ESX then
        return ESX.GetPlayerFromId(src).job
    elseif QB then
        return QB.Functions.GetPlayer(src).PlayerData.job
    end
end

function GetJobGrade(src)
    local job = GetJob(src)

    if ESX then
        return job.grade
    elseif QB then
        return job.grade.level
    end
end

function HasItem(src, item)
    if ESX then
        return ESX.GetPlayerFromId(src).getInventoryItem(item).count > 0
    elseif QB then
        item = QB.Functions.GetPlayer(src).Functions.GetItemByName(item)
        if not item then return false end
        return item.amount > 0
    end
end

function GetItemLabel(src, item)
    if ESX then
        return ESX.GetPlayerFromId(src).getInventoryItem(item).label
    elseif QB then
        return QB.Shared.Items[item].label
    end
end

function GetPlayerByIdentifier(identifier)
    if ESX then
        return ESX.GetPlayerFromIdentifier(identifier)
    elseif QB then
        return QB.Functions.GetPlayerByCitizenId(identifier)
    end
end

function GetIdentifier(src)
    if ESX then
        return ESX.GetPlayerFromId(src).identifier
    elseif QB then
        return QB.Functions.GetPlayer(src).PlayerData.citizenid
    end
end

--[[
    CURRENT FUNCTION = ESX 1.9+
    IF USING ESX <1.8, COMMENT OUT THE CURRENT FUNCTION AND UNCOMMENT THE FUNCTION BELOW
--]]
function GetJobOnlineSources(job)
    local players = {}

    if ESX then
        for _, player in pairs(ESX.GetExtendedPlayers("job", job)) do
            players[#players+1] = player.source
        end
    elseif QB then
        for _, src in pairs(QB.Functions.GetPlayers()) do
            if GetJob(src).name == job then
                players[#players+1] = src
            end
        end
    end

    return players
end

-- function GetJobOnlineSources(job)
--     local players = {}

--     if ESX then
--         local playerSources = GetPlayers()
--         for _, src in pairs(playerSources) do
--             if GetJob(src).name == job then
--                 players[#players+1] = src
--             end
--         end
--     elseif QB then
--         for _, src in pairs(QB.Functions.GetPlayers()) do
--             if GetJob(src).name == job then
--                 players[#players+1] = src
--             end
--         end
--     end

--     return players
-- end
--[[

--]]

function GetMoney(src, type)
    if ESX then
        return ESX.GetPlayerFromId(src).getAccount(type).money
    elseif QB then
        return QB.Functions.GetPlayer(src).PlayerData.money[type]
    end
end

ESX.RegisterServerCallback('RxHousing:hasItem', function(source, cb, itemName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemName)
    if item and item.count > 0 then 
        cb(true)
        TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1301330739689685092/V-JUN59-c0exRsCyCY0Y-CtRmZTqRWpAC-b37ONZZoDodipyK8pI7-11hfzxu1lX1stt', source, {title = "Huis ingevallen", desc = "[".. source .."] ".. GetPlayerName(source) .." is zojuist een huis binnen gevallen."})
    else
        cb(false)
    end
end)

function RemoveMoney(src, type, amount)
    if ESX then
        ESX.GetPlayerFromId(src).removeAccountMoney(type, amount)
    elseif QB then
        QB.Functions.GetPlayer(src).Functions.RemoveMoney(type, amount)
    end
end

function AddMoney(src, type, amount)
    if ESX then
        ESX.GetPlayerFromId(src).addAccountMoney(type, amount)
    elseif QB then
        QB.Functions.GetPlayer(src).Functions.AddMoney(type, amount)
    end
end

function GetPlayerName(src)
    if ESX then
        return ESX.GetPlayerFromId(src).name
    elseif QB then
        return QB.Functions.GetPlayer(src).PlayerData.charinfo.firstname .. " " .. QB.Functions.GetPlayer(src).PlayerData.charinfo.lastname
    end
end

function IsAdmin(src)
    if ESX then
        return ESX.GetPlayerFromId(src).getGroup() == "admin"
    elseif QB then
        return QB.Functions.HasPermission(src, "admin") or QB.Functions.HasPermission(src, "god")
    end
end

function GetSrcByPlayer(player)
    if ESX then
        return player.source
    elseif QB then
        return player.PlayerData.source
    end
end

RegisterNetEvent('housing:openStash', function(stashId, owner, weight, slots)
    local src = source
    
    exports['qb-inventory']:OpenInventory(src, stashId, {
        maxweight = weight,
        slots = slots,
    })
end)