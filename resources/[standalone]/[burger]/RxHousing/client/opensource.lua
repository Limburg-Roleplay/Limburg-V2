--[[
BY RX Scripts © rxscripts.xyz
--]]

local function isNewQBInv()
    local version = GetResourceMetadata('qb-inventory', 'version', 0)
    if not version then return false end

    local vNums = {}

    for num in version:gmatch("(%d+)") do
        vNums[#vNums + 1] = tonumber(num)
    end

    return vNums and vNums[1] >= 2
end

function OpenStash(stashId, owner, weight, slots)
    if OXInv then
        OXInv:openInventory('stash', { id = stashId, owner = owner })
    elseif QBInv or QSInv or PSInv then
        if QBInv and isNewQBInv() then
            TriggerServerEvent('housing:openStash', stashId, owner, weight, slots)
        else
            TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, {
                maxweight = weight,
                slots = slots,
            })
            TriggerEvent('inventory:client:SetCurrentStash', stashId)
        end
    else
        Error("No inventory found for opening stash (client/opensource.lua:OpenStash)")
    end
end

function StoreVehicleInGarage(garageId)
    if OKOKG then
        TriggerEvent("okokGarage:StoreVehiclePrivate")
    elseif JGGARAGE then
        TriggerEvent("jg-advancedgarages:client:store-vehicle", "House: "..tostring(garageId), "car")
    elseif CODEMG then
        TriggerEvent("codem-garage:storeVehicle", garageId)
    else
        Error("No garage resource found (client/opensource.lua:StoreVehicleInGarage)")
    end
end

function OpenGarage(garageId, coords)
    if OKOKG then
        TriggerEvent("okokGarage:OpenPrivateGarageMenu", vector3(coords.x, coords.y, coords.z), coords.w)
    elseif JGGARAGE then
        TriggerEvent("jg-advancedgarages:client:open-garage", "House: "..tostring(garageId), "car", coords)
    elseif CODEMG then
        TriggerEvent("codem-garage:openHouseGarage", garageId)
    else
        Error("No garage resource found (client/opensource.lua:OpenGarage)")
    end
end

function ShowMarker(type, coords)
    if type == 'laptop' or type == 'stash' or type == 'clothing' then
        ESX.DrawBasicMarker({
            x = coords.x,
            y = coords.y,
            z = coords.z,
            type = 1,
            color = {r = 255, g = 0, b = 0},
            scale = {x = 1.5, y = 1.5, z = 1.5},
            alpha = 100
        })
    elseif type == 'door' then
        ESX.DrawBasicMarker({
            x = coords.x,
            y = coords.y,
            z = coords.z,
            type = 1,
            color = {r = 255, g = 0, b = 0},
            scale = {x = 1.5, y = 1.5, z = 1.5},
            alpha = 100
        })
    elseif type == 'entranceForSale' then
        ESX.DrawBasicMarker({
            x = coords.x,
            y = coords.y,
            z = coords.z,
            type = 1,
            color = {r = 255, g = 0, b = 0},
            scale = {x = 1.5, y = 1.5, z = 1.5},
            alpha = 100
        })
    elseif type == 'entranceHasKey' then
        ESX.DrawBasicMarker({
            x = coords.x,
            y = coords.y,
            z = coords.z + 1,
            type = 1,
            color = {r = 255, g = 0, b = 0},
            scale = {x = 1.5, y = 1.5, z = 1.5},
            alpha = 100
        })
    elseif type == 'entranceNoKey' then
        ESX.DrawBasicMarker({
            x = coords.x,
            y = coords.y,
            z = coords.z + 1,
            type = 1,
            color = {r = 210, g = 1, b = 3},
            scale = {x = 1.5, y = 1.5, z = 1.5},
            alpha = 100
        })
    elseif type == 'storeVehicle' then
        DrawMarker(1, coords, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, false, 1, false, false, false, false)
    elseif type == 'takeVehicle' then
        DrawMarker(1, coords, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, false, 1, true, false, false, false)
    end
end


---@param propertyId string The property ID (u can use this to make a unique identifier if needed)
function OpenWardrobe(propertyId)
    if FMAPP then
        FMAPP:openWardrobe()
    elseif ILA then
        TriggerEvent("illenium-appearance:client:openOutfitMenu")
    elseif QBClothing then
        TriggerEvent('qb-clothing:client:openMenu')
    else
        Error("No wardrobe resource found (client/opensource.lua:OpenWardrobe)")
    end
end

function BreakInMinigame()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)
    
    local result = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
    
    ClearPedTasks(PlayerPedId())
    return result
end

function RaidMinigame()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, true)
    
    local result = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
    
    ClearPedTasks(PlayerPedId())
    return result
end

function Notify(msg, type)
    if ESX then
        local notifyType = 'info'  -- standaard notificatie type
        if type == 'error' then
            notifyType = 'error'
        elseif type == 'success' then
            notifyType = 'success'
        elseif type == 'warning' then
            notifyType = 'warning'
        end
        
        exports['okokNotify']:Alert('Notificatie', msg, 5000, notifyType)
    elseif QB then
        if type == 'info' then type = nil end
        QB.Functions.Notify(msg, type)
    end
end

function GetPlayerData()
    if ESX then
        return ESX.GetPlayerData()
    elseif QB then
        return QB.Functions.GetPlayerData()
    end
end

function IsPlayerLoaded()
    if ESX then
        return GetPlayerData() and GetPlayerData().identifier
    elseif QB then
        return GetPlayerData() and GetPlayerData().citizenid
    end
end

function GetIdentifier()
    if ESX then
        return GetPlayerData().identifier
    elseif QB then
        return GetPlayerData().citizenid
    end
end

function GetJob()
    if ESX then
        return ESX.GetPlayerData().job
    elseif QB then
        return QB.Functions.GetPlayerData().job
    end
end

function GetJobGrade()
    local job = GetJob()

    if ESX then
        return job.grade
    elseif QB then
        return job.grade.level
    end
end

function ShowHelpNotification(msg, thisFrame, beep, duration)
    AddTextEntry('helpNotification', msg)

    if thisFrame then
        DisplayHelpTextThisFrame('helpNotification', false)
    else
        if beep == nil then
            beep = true
        end
        BeginTextCommandDisplayHelp('helpNotification')
        EndTextCommandDisplayHelp(0, false, beep, duration or -1)
    end
end