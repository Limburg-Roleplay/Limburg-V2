ESX = nil
local loodsPlayers = {}

TriggerEvent("esx:getSharedObject",function(obj)
    ESX = obj
 end)

local function applyUpgradesFromDatabase(source, loodsId)
    
    MySQL.Async.fetchAll(
        'SELECT * FROM loodsen WHERE id = @id',
        {
            ["@id"] = tonumber(loodsId)
        },
        function(result)
            if result and #result > 0 then
                local warehouseData = result[1]
                local upgradeLevel = warehouseData.upgrades
                if upgradeLevel == 0 then
                    TriggerClientEvent('bikerWeedFarm:setStyle', source, 'basic')
                    TriggerClientEvent('bikerWeedFarm:setSecurity', source, 'basic')
                    TriggerClientEvent('bikerWeedFarm:toggleDetail', source, 'detail')
                end
                if upgradeLevel == 1 then
                    TriggerClientEvent('bikerWeedFarm:toggleDetail', source, 'detail')
                    TriggerClientEvent('bikerWeedFarm:setStyle', source, 'basic')
                    TriggerClientEvent('bikerWeedFarm:setSecurity', source, 'upgrade')
                elseif upgradeLevel == 2 then
                    TriggerClientEvent('bikerWeedFarm:toggleDetail', source, 'detail')
                    TriggerClientEvent('bikerWeedFarm:setStyle', source, 'upgrade')
                    TriggerClientEvent('bikerWeedFarm:setSecurity', source, 'upgrade')
                elseif upgradeLevel == 3 then
                    TriggerClientEvent('bikerWeedFarm:toggleDetail', source, 'production')
                    TriggerClientEvent('bikerWeedFarm:setStyle', source, 'upgrade')
                    TriggerClientEvent('bikerWeedFarm:setSecurity', source, 'upgrade')
                end
            end
        end
    )
end

RegisterServerEvent("loodsen:buy")
AddEventHandler("loodsen:buy", function(locationId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        print("Error: Player not found.")
        return
    end

    -- Haal de naam van de speler en andere informatie op
    local playerName = xPlayer.getName() or "Onbekend"
    local steamName = GetPlayerName(source) or "Onbekend"
    local steamID = xPlayer.identifier or "Onbekend"
    local coords = xPlayer.getCoords(true) -- Coördinaten van de speler
    local coordsStr = string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.x, coords.y, coords.z)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S") -- Tijdstip van aankoop

    MySQL.Async.fetchAll(
        "SELECT * FROM loodsen WHERE id = @id",
        {
            ["@id"] = locationId
        },
        function(result)
            if #result > 0 then
                local selectedLoods = result[1]
                local price = selectedLoods.price
                local bankBalanceBefore = xPlayer.getAccount('bank').money -- Bank balans voor de aankoop

                if bankBalanceBefore >= price then
                    xPlayer.removeAccountMoney('bank', price)
                    local bankBalanceAfter = xPlayer.getAccount('bank').money -- Bank balans na de aankoop

                    MySQL.Async.execute(
                        "UPDATE loodsen SET owner = @owner WHERE id = @id",
                        {
                            ["@owner"] = xPlayer.identifier,
                            ["@id"] = locationId
                        },
                        function(rowsChanged)
                            if rowsChanged > 0 then
                                TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Gelukt!", "Je hebt een loods gekocht!", 5000, 'success')

                                TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1287533136196145354/h1nnyaE6kpA-jwxhYoUDGAunMBOH-H5R_qP7EUACA5jFRiFQZ85OhjfoQylPLI57hAfI', source, {
                                    title = "Loods Aankoop Logs",
                                    desc = string.format(
                                        "Ingame Naam Speler: %s\nSteam Naam: %s\nIdentifier Speler: %s\nCoords: %s\nLoods ID: %s\nPrijs: €%s\nBank Saldo Voor Aankoop: €%s\nBank Saldo Na Aankoop: €%s\nAankoop Tijdstip: %s",
                                        playerName, steamName, steamID, coordsStr, locationId, price, bankBalanceBefore, bankBalanceAfter, currentTime
                                    )
                                })

                            else
                                TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Er is iets misgegaan tijdens het updaten van de loods.", 5000, 'error')
                            end
                        end
                    )
                else
                    TriggerClientEvent('okokNotify:Alert', source, "Error", "Je hebt niet genoeg geld op je bank.", 5000, 'error')
                end
            else
                TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Ongeldige loods ID.", 5000, 'error')
            end
        end
    )
end)






RegisterServerEvent("loodsen:plukken")
AddEventHandler("loodsen:plukken", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local loodsId = GetPlayerRoutingBucket(xPlayer.source)
    MySQL.Async.fetchAll("SELECT plants, opslag, maxopslag FROM loodsen WHERE id = @id", {
        ["@id"] = loodsId
    }, function(result)
        if result[1] then
            local plantGrowth = json.decode(result[1].plants) or {}
            local opslag = result[1].opslag
			local maxopslag = result[1].maxopslag
            local amountToAdd = 0

            for plantId, growth in pairs(plantGrowth) do
                if growth == 100 then
                    plantGrowth[plantId] = 0
                    amountToAdd = amountToAdd + math.random(1, 4)
                end
            end
            local editedOpslag = opslag + amountToAdd
            if editedOpslag > maxopslag then
                editedOpslag = maxopslag
            end
            MySQL.Async.execute(
                "UPDATE loodsen SET plants = @plants, opslag = @opslag WHERE id = @id",
                {
                    ["@plants"] = json.encode(plantGrowth),
                    ["@opslag"] = editedOpslag,
                    ["@id"] = loodsId
                },
                function(affectedRows)
                    if affectedRows > 0 then
                        TriggerClientEvent('updatePlantGrowth', -1, loodsId, plantGrowth, opslag, maxopslag)
                        TriggerClientEvent('updateOpslag', -1, loodsId, editedOpslag)
                    end
                end
            )
        end
    end)
    end
)

ESX.RegisterServerCallback(
    "loodsen:isBought",
    function(source, cb, loodsId)
        local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll(
            "SELECT owner, inhabitants FROM loodsen WHERE id = @id",
            {
                ["@id"] = loodsId
            },
            function(result)
                if result[1] then
                    local owner = result[1].owner
                    local inhabitants = result[1].inhabitants
                    local inhabitantsList = json.decode(inhabitants) or {}

                    if owner == xPlayer.identifier then
                        cb(true, true, true)
                    elseif TableIncludes(inhabitantsList, xPlayer.identifier) then
                        cb(true, true, false)
                    elseif not owner then
                        cb(false, false, false)
                    else
                        cb(true, false, false)
                    end
                else
                    cb(false, false, false)
                end
            end
        )
    end
)

RegisterServerEvent("loodsen:setRoutingBucket")
AddEventHandler("loodsen:setRoutingBucket", function(loodsId)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local currentLoodsId = GetPlayerRoutingBucket(xPlayer.source)
    if xPlayer then
        SetPlayerRoutingBucket(xPlayer.source, tonumber(loodsId))
        applyUpgradesFromDatabase(xPlayer.source, loodsId)

        if tonumber(loodsId) == 0 then
            MySQL.Async.fetchScalar(
                "SELECT current_inhabitants FROM loodsen WHERE id = @id",
                {["@id"] = currentLoodsId},
                function(currentInhabitants)
                    local inhabitantsList = json.decode(currentInhabitants or "[]")
                    local newInhabitantsList = {}

                    for _, identifier in ipairs(inhabitantsList) do
                        if identifier ~= xPlayer.identifier then
                            table.insert(newInhabitantsList, identifier)
                        end
                    end

                    MySQL.Async.execute(
                        "UPDATE loodsen SET current_inhabitants = @inhabitants WHERE id = @id",
                        {
                            ["@inhabitants"] = json.encode(newInhabitantsList),
                            ["@id"] = currentLoodsId
                        },
                        function(affectedRows)
                            if affectedRows > 0 then
                                --print("Player " .. xPlayer.identifier .. " removed from loods " .. loodsId .. " inhabitants list.")
                            end
                        end
                    )
                end
            )
        else
            MySQL.Async.fetchScalar(
                "SELECT current_inhabitants FROM loodsen WHERE id = @id",
                {["@id"] = loodsId},
                function(currentInhabitants)
                    local inhabitantsList = json.decode(currentInhabitants or "[]")

                    local isInList = false
                    for _, identifier in ipairs(inhabitantsList) do
                        if identifier == xPlayer.identifier then
                            isInList = true
                            break
                        end
                    end
                    if not isInList then
                        table.insert(inhabitantsList, xPlayer.identifier)

                        MySQL.Async.execute(
                            "UPDATE loodsen SET current_inhabitants = @inhabitants WHERE id = @id",
                            {
                                ["@inhabitants"] = json.encode(inhabitantsList),
                                ["@id"] = loodsId
                            },
                            function(affectedRows)
                                if affectedRows > 0 then
                                    --print("Player " .. xPlayer.identifier .. " added to loods " .. loodsId .. " inhabitants list.")
                                end
                            end
                        )
                    end
                end
            )
        end
    end
end)


RegisterNetEvent("loodsen:getLoodsCoords")
AddEventHandler("loodsen:getLoodsCoords", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local routingBucket = GetPlayerRoutingBucket(xPlayer.source)
    MySQL.Async.fetchAll(
        "SELECT * FROM loodsen WHERE id = @id",
        {
            ["@id"] = routingBucket
        },
        function(result)
            if #result > 0 then
                for _, loods in ipairs(result) do
                    if loods.id == routingBucket then
                        local location = json.decode(loods.location)
                        TriggerClientEvent("loodsen:setLoodsCoords", xPlayer.source, location.x, location.y, location.z)
                        return
                    end
                end
            end
            TriggerClientEvent("loodsen:noLoodsFound", xPlayer.source)
        end
    )
end)


ESX.RegisterServerCallback(
    "loodsen:isInsideLoods",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsId = xPlayer.get("loodsId")
        if loodsId then
            cb(true)
        else
            cb(false)
        end
    end
)

RegisterServerEvent("loodsen:getNearbyPlayers")
AddEventHandler("loodsen:getNearbyPlayers", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local players = {}
    local radius = 10.0
    local coords = nil
    local routingBucket = GetPlayerRoutingBucket(xPlayer.source)

    MySQL.Async.fetchAll(
        "SELECT * FROM loodsen WHERE id = @id",
        {
            ["@id"] = routingBucket,
        },
        function(result)
            if #result > 0 then
                local loods = result[1]
                local location = json.decode(loods.location)
                coords = vector3(location.x, location.y, location.z)

                for _, playerId in ipairs(ESX.GetPlayers()) do
                    local targetPlayer = ESX.GetPlayerFromId(playerId)
                    if targetPlayer then
                        local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayer.source))
                        local distance = #(targetCoords - coords)
                        if distance < radius then
                            table.insert(players, {
                                id = targetPlayer.source,
                                name = GetPlayerName(targetPlayer.source)
                            })
                        end
                    end
                end
            end
            TriggerClientEvent("loodsen:receiveNearbyPlayers", xPlayer.source, players, coords)
        end
    )
end)


RegisterServerEvent("loodsen:sendInvite")
AddEventHandler(
    "loodsen:sendInvite",
    function(targetPlayerId, coords)
        local xPlayer = ESX.GetPlayerFromId(source)
        local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
        
        -- Validate coordinates
        if not coords or type(coords) ~= "table" or not coords.x or not coords.y or not coords.z then
            TriggerClientEvent('okokNotify:Alert', source, "Error", "Ongeldige coördinaten.", 5000, 'error')
            return
        end

        if targetPlayer then
            TriggerClientEvent("loodsen:receiveInvitation", targetPlayer.source, xPlayer.source, coords)
            TriggerClientEvent('okokNotify:Alert', source, "Gelukt!", "Uitnodiging gestuurd naar speler " .. GetPlayerName(targetPlayerId), 5000, 'success')
        else
            TriggerClientEvent('okokNotify:Alert', source, "Error", "Speler niet gevonden.", 5000, 'error')
        end
    end
)


RegisterServerEvent("loodsen:acceptInvite")
AddEventHandler(
    "loodsen:acceptInvite",
    function(senderId, playerCoords, loodsCoords)
        local xPlayer = ESX.GetPlayerFromId(source)
        local senderPlayer = ESX.GetPlayerFromId(senderId)
        local senderRouting = GetPlayerRoutingBucket(senderPlayer.source)
        local distance = #(playerCoords - vector3(loodsCoords.x, loodsCoords.y, loodsCoords.z))

        if distance > 10.0 then
            TriggerClientEvent('okokNotify:Alert', source, "Error", "Je bent te ver weg om de uitnodiging te accepteren.", 5000, 'error')
            return
        end
        if senderPlayer then
            TriggerClientEvent("loodsen:teleportToLoods", xPlayer.source, senderRouting)
            TriggerClientEvent('okokNotify:Alert', source, "Gelukt!", xPlayer.name .. " heeft je uitnodiging geaccepteerd.", 5000, 'success')
        end
    end
)

RegisterServerEvent("loodsen:declineInvite")
AddEventHandler(
    "loodsen:declineInvite",
    function(senderId)
        local xPlayer = ESX.GetPlayerFromId(source)
        local senderPlayer = ESX.GetPlayerFromId(senderId)

        if senderPlayer then
            TriggerClientEvent('okokNotify:Alert', source, "Error", xPlayer.name .. " heeft je uitnodiging afgewezen.", 5000, 'error')
        end
    end
)

RegisterServerEvent("loodsen:grantKey")
AddEventHandler(
    "loodsen:grantKey",
    function(targetPlayerId)
        local xPlayer = ESX.GetPlayerFromId(source)
        local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
        local loodsId = GetPlayerRoutingBucket(xPlayer.source)

        if targetPlayer then
            MySQL.Async.fetchScalar(
                "SELECT inhabitants FROM loodsen WHERE id = @id",
                {
                    ["@id"] = loodsId
                },
                function(inhabitants)
                    local inhabitantsList = json.decode(inhabitants) or {}

                    if not TableIncludes(inhabitantsList, targetPlayer.identifier) then
                        table.insert(inhabitantsList, targetPlayer.identifier)
                    end

                    MySQL.Async.execute(
                        "UPDATE loodsen SET inhabitants = @inhabitants WHERE id = @id",
                        {
                            ["@inhabitants"] = json.encode(inhabitantsList),
                            ["@id"] = loodsId
                        },
                        function(rowsChanged)
            				TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Gelukt!", "Sleutels gegeven aan: " .. GetPlayerName(targetPlayerId), 5000, 'success')
            				TriggerClientEvent('okokNotify:Alert', targetPlayer.source, "Gelukt!", "Je hebt toegang gekregen tot een loods.", 5000, 'success')
                        end
                    )
                end
            )
        else
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Speler niet gevonden.", 5000, 'error')
        end
    end
)

function TableIncludes(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

RegisterServerEvent("loodsen:getInhabitantsList")
AddEventHandler(
    "loodsen:getInhabitantsList",
    function(loodsId)
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsId = GetPlayerRoutingBucket(xPlayer.source)
        MySQL.Async.fetchAll(
            "SELECT inhabitants FROM loodsen WHERE id = @id",
            {
                ["@id"] = loodsId
            },
            function(result)
                if result[1] then
                    local inhabitants = result[1].inhabitants
                    local inhabitantsList = json.decode(inhabitants) or {}
                    local inhabitantsNames = {}

                    for _, identifier in ipairs(inhabitantsList) do
                        local player = ESX.GetPlayerFromIdentifier(identifier)
                        if player then
                            table.insert(
                                inhabitantsNames,
                                {
                                    identifier = identifier,
                                    name = GetPlayerName(player.source)
                                }
                            )
                        end
                    end

                    TriggerClientEvent("loodsen:receiveInhabitantsList", xPlayer.source, inhabitantsNames)
                end
            end
        )
    end
)

RegisterServerEvent("loodsen:removeKey")
AddEventHandler(
    "loodsen:removeKey",
    function(targetIdentifier)
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsId = GetPlayerRoutingBucket(xPlayer.source)
        MySQL.Async.fetchScalar(
            "SELECT owner FROM loodsen WHERE id = @id",
            {
                ["@id"] = loodsId
            },
            function(owner)
                if owner == xPlayer.identifier then
                    MySQL.Async.fetchScalar(
                        "SELECT inhabitants FROM loodsen WHERE id = @id",
                        {
                            ["@id"] = loodsId
                        },
                        function(inhabitants)
                            local inhabitantsList = json.decode(inhabitants) or {}

                            for i, identifier in ipairs(inhabitantsList) do
                                if identifier == targetIdentifier then
                                    table.remove(inhabitantsList, i)
                                    break
                                end
                            end

                            MySQL.Async.execute(
                                "UPDATE loodsen SET inhabitants = @inhabitants WHERE id = @id",
                                {
                                    ["@inhabitants"] = json.encode(inhabitantsList),
                                    ["@id"] = loodsId
                                }
                            )
            				TriggerClientEvent('okokNotify:Alert', targetPlayer.source, "Gelukt!", "Sleutel weggehaald van: " .. GetPlayerName(targetIdentifier), 5000, 'success')
                            local targetPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
                            if targetPlayer then
                                TriggerClientEvent('okokNotify:Alert', targetPlayer.source, "Error", "Je sleutel van een loods is weggehaald.", 5000, 'error')
                            end
                        end
                    )
                else
            		TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "You do not own this loods.", 5000, 'error')
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "loodsen:isOwner",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsId = GetPlayerRoutingBucket(xPlayer.source)
        MySQL.Async.fetchScalar(
            "SELECT owner FROM loodsen WHERE id = @id",
            {
                ["@id"] = loodsId
            },
            function(owner)
                if owner == xPlayer.identifier then
                    cb(true)
                else
                    cb(false)
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "loodsen:isOwnerOrInhabitant",
    function(source, cb)
        
    end
)
RegisterNetEvent("loodsen:openComputerNui")
AddEventHandler(
    "loodsen:openComputerNui",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsId = GetPlayerRoutingBucket(xPlayer.source)
        
        MySQL.Async.fetchAll("SELECT opslag, maxopslag, plants FROM loodsen WHERE id = @id", {
            ["@id"] = loodsId
        }, function(result)
            if result[1] then
                local opslag = result[1].opslag
                local maxopslag = result[1].maxopslag
                local plantsData = result[1].plants
                local plantGrowth = json.decode(plantsData) or {}
                
                TriggerClientEvent('updatePlantGrowth', xPlayer.source, loodsId, plantGrowth, opslag, maxopslag)
                TriggerClientEvent("loodsen:showNui", xPlayer.source, loodsId)
            end
        end)
    end
)

RegisterNetEvent("loodsen:getOpslagData")
AddEventHandler(
    "loodsen:getOpslagData",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsid = GetPlayerRoutingBucket(xPlayer.source)
        if xPlayer then
            MySQL.Async.fetchAll(
                "SELECT opslag, maxopslag FROM loodsen WHERE id = @id",
                {
                    ["@id"] = loodsid
                },
                function(result)
                    local opslagData = result[1] and result[1].opslag or "No data available"
                    local maxopslagData = result[1] and result[1].maxopslag or "No data available"
                    TriggerClientEvent("loodsen:sendOpslagData", xPlayer.source, opslagData, maxopslagData)
                end
            )
        end
    end
)
RegisterNetEvent("loodsen:getOpslagDataOwner")
AddEventHandler(
    "loodsen:getOpslagDataOwner",
    function()
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsid = GetPlayerRoutingBucket(xPlayer.source)
        if xPlayer then
            MySQL.Async.fetchAll(
                "SELECT opslag, maxopslag FROM loodsen WHERE id = @id",
                {
                    ["@id"] = loodsid
                },
                function(result)
                    local opslagData = result[1] and result[1].opslag or "No data available"
                    local maxopslagData = result[1] and result[1].maxopslag or "No data available"
                    TriggerClientEvent("loodsen:sendOpslagDataOwner", xPlayer.source, opslagData, maxopslagData)
                end
            )
        end
    end
)
RegisterNetEvent("loodsen:sellLoods")
AddEventHandler(
    "loodsen:sellLoods",
    function(loodsId)
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsConfig = nil
        MySQL.Async.fetchAll(
        "SELECT * FROM loodsen WHERE id = @id",
        {
            ["@id"] = loodsId
        },
        function(result)
            if #result > 0 then
                loodsConfig = result[1]
                if not loodsConfig then
			TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Loods niet gevonden. Probeer het opnieuw.", 5000, 'error')
            return
        end

        local normalPrice = loodsConfig.price
        local salePrice = normalPrice * 0.7

        MySQL.Async.execute(
            "UPDATE loodsen SET owner = NULL, inhabitants = NULL, opslag = 0, upgrades = 1 WHERE id = @id",
            {
                ["@id"] = loodsId
            },
            function(rowsChanged)
                if rowsChanged > 0 then
                    xPlayer.addMoney(salePrice)
					TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Gelukt!", "Je hebt je loods verkocht voor €" .. salePrice, 5000, 'success')
                else
            		TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Het is niet gelukt om je loods te verkopen. Probeer het opnieuw.", 5000, 'error')
                end
            end
        )
			end
		end)

        
    end
)
RegisterNetEvent("loodsen:createLoods")
AddEventHandler(
    "loodsen:createLoods",
    function(loodsId, location)
        local xPlayer = ESX.GetPlayerFromId(source)

        if not xPlayer or not xPlayer.getGroup() or xPlayer.getGroup() ~= "admin" then
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Je hebt geen toestemming om dit commando te gebruiken.", 5000, 'error')
            return
        end

        if not loodsId or not location then
            TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Gebruik: /createLoods [ID]", 5000, 'error')
            return
        end

        MySQL.Async.execute(
            "INSERT INTO loodsen (id, location) VALUES (@id, @location)",
            {
                ["@id"] = loodsId,
                ["@location"] = location
            },
            function(affectedRows)
                if affectedRows > 0 then
					TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Gelukt!", "Loods succesvol aangemaakt met ID: " .. loodsId, 5000, 'success')
                else
            		TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Fout bij het aanmaken van de loods. Probeer het opnieuw.", 5000, 'error')
                end
            end
        )
    end
)
ESX.RegisterServerCallback(
    "jtm-loodsen:server:buyupgrades",
    function(source, cb, loodsje, upgradestring, price, valuedatabase, coordsvanloods)
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsConfig = nil
        local loodsid = GetPlayerRoutingBucket(xPlayer.source)

        MySQL.Async.fetchAll(
            "SELECT * FROM loodsen WHERE id = @id",
            {
                ["@id"] = loodsid
            },
            function(result)
                if #result > 0 then
                    loodsConfig = result[1]
                    local identifier = xPlayer.identifier

                    MySQL.Async.fetchAll(
                        "SELECT * FROM loodsen WHERE owner = @owner",
                        {
                            ["@owner"] = identifier
                        },
                        function(result)
                            if not result[1].owner == identifier then
                                TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Alleen de baas van deze loods kan de loods upgraden.", 5000, 'error')
                                return
                            end

                            if xPlayer.getAccount("bank").money >= price then
                                xPlayer.removeAccountMoney("bank", price)

                                MySQL.Async.execute(
                                    "UPDATE loodsen SET upgrades = @upgrades WHERE owner = @owner",
                                    {
                                        ["@owner"] = identifier,
                                        ["@upgrades"] = valuedatabase
                                    },
                                    function(rowsChanged)
                                        -- Check if upgrades were updated
                                        if rowsChanged > 0 then
                                            if valuedatabase == 3 then
                                                MySQL.Async.execute(
                                                    "UPDATE loodsen SET maxopslag = @maxopslag WHERE id = @id",
                                                    {
                                                        ["@maxopslag"] = 200,
                                                        ["@id"] = loodsid
                                                    }
                                                )
                                            else
                                                MySQL.Async.execute(
                                                    "UPDATE loodsen SET maxopslag = @maxopslag WHERE id = @id",
                                                    {
                                                        ["@maxopslag"] = 100,
                                                        ["@id"] = loodsid
                                                    }
                                                )
                                            end

                                            applyUpgradesFromDatabase(source, loodsid)
                                            cb(true)
                                        else
                                            TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Er is iets misgegaan tijdens het upgraden.", 5000, 'error')
                                            cb(false)
                                        end
                                    end
                                )
                            else
                                TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Error", "Je hebt niet genoeg geld op de bank.", 5000, 'error')
                                cb(false)
                            end
                        end
                    )
                end
            end
        )
    end
)


ESX.RegisterServerCallback(
    "jtm-loodsen:getupgrades",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local loodsConfig = nil
        local loodsid = GetPlayerRoutingBucket(xPlayer.source)
        MySQL.Async.fetchAll(
        "SELECT * FROM loodsen WHERE id = @id",
        {
            ["@id"] = loodsid
        },
        function(result)
            if #result > 0 then
                loodsConfig = result[1]
        local identifier = xPlayer.identifier
        
        MySQL.Async.fetchAll(
            "SELECT upgrades FROM loodsen WHERE owner = @owner",
            {
                ["@owner"] = identifier
            },
            function(result)
                cb(result)
            end
        )
                    end
                end)
    end
)

function isLoodsOwnerOrInhabitant(playerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    MySQL.Async.fetchAll(
        "SELECT id, owner, inhabitants FROM loodsen",
        {},
        function(result)
            for i = 1, #result do
                local loodsId = result[i].id
                local owner = result[i].owner
                local inhabitants = json.decode(result[i].inhabitants or "[]") 

                if owner == xPlayer.identifier then
                    cb(true, loodsId)
                    return
                end

                for _, inhabitant in ipairs(inhabitants) do
                    if inhabitant == xPlayer.identifier then
                        cb(true, loodsId)
                        return
                    end
                end
            end

            cb(false, nil)
        end
    )
end

AddEventHandler("esx:playerLoaded", function(playerId)
    isLoodsOwnerOrInhabitant(playerId, function(isOwnerOrInhabitant, loodsId)
        if isOwnerOrInhabitant then

            if not loodsPlayers[loodsId] then
                loodsPlayers[loodsId] = {}
            end

            table.insert(loodsPlayers[loodsId], playerId)
        else
        end
    end)
end)

AddEventHandler("playerDropped", function(reason)
    local playerId = source
    for loodsId, players in pairs(loodsPlayers) do
        for i = #players, 1, -1 do
            if players[i] == playerId then
                table.remove(players, i)
                break
            end
        end
    end
end)

AddEventHandler("esx:playerLoaded", function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if xPlayer then
        MySQL.Async.fetchAll(
            "SELECT id, current_inhabitants FROM loodsen",
            {},
            function(result)
                for i = 1, #result do
                    local loodsId = result[i].id
                    local currentInhabitants = json.decode(result[i].current_inhabitants or "[]")

                    for _, identifier in ipairs(currentInhabitants) do
                        if identifier == xPlayer.identifier then
                            SetPlayerRoutingBucket(xPlayer.source, tonumber(loodsId))
                            return
                        end
                    end
                end
            end
        )
    end
end)
Citizen.CreateThread(function()
    while true do
        for loodsId, players in pairs(loodsPlayers) do
            if #players > 0 then
                MySQL.Async.fetchAll("SELECT plants, upgrades FROM loodsen WHERE id = @id", {
                    ["@id"] = loodsId
                }, function(result)
                    if result[1] then
                        local plantsData = result[1].plants
                        local upgradeLevel = result[1].upgrades or 0

                        local plantGrowth = json.decode(plantsData) or {}

                        for plantId = 1, 10 do
                            if not plantGrowth[plantId] then
                                plantGrowth[plantId] = 0
                            end

                            local growthIncrement = 0

                            if upgradeLevel >= 2 then
                                growthIncrement = math.random(10, 15)
                            else
                                growthIncrement = math.random(5, 10)
                            end

                            plantGrowth[plantId] = math.min(100, plantGrowth[plantId] + growthIncrement)
                        end

                        MySQL.Async.execute(
                            "UPDATE loodsen SET plants = @plants WHERE id = @id",
                            {
                                ["@plants"] = json.encode(plantGrowth),
                                ["@id"] = loodsId
                            },
                            function(affectedRows)
                                if affectedRows > 0 then
                                    TriggerClientEvent('updatePlantGrowth', -1, loodsId, plantGrowth)
                                end
                            end
                        )
                    end
                end)
            end
        end
        Citizen.Wait(2700000)
    end
end)
function table.indexOf(tbl, element)
    for index, value in ipairs(tbl) do
        if value == element then
            return index
        end
    end
    return nil
end
AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local players = ESX.GetPlayers()

        for _, playerId in ipairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)

            if xPlayer then
                MySQL.Async.fetchAll(
                    "SELECT id, current_inhabitants, owner FROM loodsen",
                    {},
                    function(result)
                        for i = 1, #result do
                            local loodsId = result[i].id
                            local currentInhabitants = json.decode(result[i].current_inhabitants or "[]")
                            local owner = result[i].owner
                            if owner == xPlayer.identifier or table.indexOf(currentInhabitants, xPlayer.identifier) then
                                if not loodsPlayers[loodsId] then
                                    loodsPlayers[loodsId] = {}
                                end
                                table.insert(loodsPlayers[loodsId], xPlayer.source)
                                break 
                            end
                        end
                    end
                )
            end
        end
    end
end)


RegisterNetEvent('jtm-loodsen:server:tpOutsideLoods')
AddEventHandler('jtm-loodsen:server:tpOutsideLoods', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if xPlayer then
        MySQL.Async.fetchScalar('SELECT opslag FROM loodsen WHERE owner = @owner', {
            ['@owner'] = xPlayer.identifier
        }, function(opslag)
            if opslag then
                if opslag >= Config.MinSellStorage then
                    MySQL.Async.fetchAll('SELECT * FROM loodsen WHERE owner = @owner', {
                        ['@owner'] = xPlayer.identifier
                    }, function(loodsenData)
                        if #loodsenData > 0 then
                            local loods = loodsenData[1]
                            if loods.spawnlocation then
                                TriggerClientEvent('jtm-loodsen:client:tpOutsideLoods', _source, 
                                    json.decode(loods.spawnlocation).x, json.decode(loods.spawnlocation).y, 
                                    json.decode(loods.spawnlocation).z, json.decode(loods.spawnlocation).w)
                                TriggerClientEvent('okokNotify:Alert', _source, "Succes", "Begonnen met de verkoop missie.", 5000, 'success')
                            else
                                TriggerClientEvent('okokNotify:Alert', _source, "Error", "Loods geen spawn locatie beschikbaar.", 5000, 'error')
                            end
                        else
                            TriggerClientEvent('okokNotify:Alert', _source, "Error", "Loods niet gevonden in de database.", 5000, 'error')
                        end
                    end)
                else
                    TriggerClientEvent('okokNotify:Alert', _source, "Storage", "Je hebt minder als 25KG in je storage, kom terug wanneer je meer hebt..", 5000, 'error')
                end
            else
                TriggerClientEvent('okokNotify:Alert', _source, "Error", "Opslag niet gevonden in de database.", 5000, 'error')
            end
        end)
    end
end)

ESX.RegisterServerCallback('jtm-loodsen:server:getLoodsBlips', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        cb(nil)
        return
    end

    local identifier = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM loodsen WHERE owner = @identifier', {
        ['@identifier'] = identifier
    }, function(results)
        if results and #results > 0 then
            local blipData = {}

            for _, loods in ipairs(results) do
                table.insert(blipData, {
                    id = loods.id,
                    x = json.decode(loods.location).x,
                    y = json.decode(loods.location).y,
                    z = json.decode(loods.location).z
                })
            end

            cb(blipData)
        else
            cb(nil)
        end
    end)
end)


ESX.RegisterServerCallback('jtm-loodsen:server:checkOpslagAmount', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local opslagAmount = GetOpslagAmount(xPlayer.identifier)

    if opslagAmount >= Config.MinSellAmount then
        cb(true)
    else
        cb(false)
    end
end)

function GetOpslagAmount(identifier)
    local result = MySQL.Sync.fetchScalar("SELECT opslag FROM loodsen WHERE owner = @owner", {
        ['@owner'] = identifier
    })
    
    return result or 0 
end

ESX.RegisterServerCallback('jtm-loodsen:server:deliverGoods', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.execute('UPDATE loodsen SET opslag = opslag - @minSellAmount WHERE owner = @owner AND opslag >= @minSellAmount', {
        ['@minSellAmount'] = Config.MinSellAmount,
        ['@owner'] = identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            MySQL.Async.fetchScalar('SELECT opslag FROM loodsen WHERE owner = @owner', {
                ['@owner'] = identifier
            }, function(newOpslagAmount)
                local blackMoneyAmount = math.random(60000, 80000)
                xPlayer.addAccountMoney('black_money', blackMoneyAmount)

                TriggerClientEvent('esx:showNotification', source, "Je hebt ~r~€" .. blackMoneyAmount .. " zwart geld ontvangen.")
				
                if newOpslagAmount and newOpslagAmount >= Config.MinSellAmount then
                    cb(true)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('loodsen:getLoodsData', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM loodsen', {}, function(result)
        cb(result)
    end)
end)
RegisterServerEvent('jtm-loodsen:server:notifyPoliceAndKmar')
AddEventHandler('jtm-loodsen:server:notifyPoliceAndKmar', function(deliveryCoords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
	if not deliveryCoords then
            return
	end
    MySQL.Async.fetchScalar('SELECT upgrades FROM loodsen WHERE owner = @owner', {
        ['@owner'] = identifier
    }, function(upgrades)
        if upgrades then
            local notificationChance = 0.6
            
            if upgrades > 2 then
                notificationChance = 0.3
            end

            if math.random() < notificationChance then
                local players = ESX.GetPlayers()
                for _, playerId in ipairs(players) do
                    local targetPlayer = ESX.GetPlayerFromId(playerId)
                    if targetPlayer and (targetPlayer.job.name == 'police' or targetPlayer.job.name == 'kmar') then
                        TriggerClientEvent('okokNotify:Alert', targetPlayer.source, "Waarschuwing", "Er wordt (mogelijk) drugs verkocht!", 5000, 'warning')
                        TriggerClientEvent('jtm-loodsen:client:createBlip', targetPlayer.source, deliveryCoords)
                    end
                end
            end
        else
            print('Loods upgrades could not be found for owner: ' .. identifier)
        end
    end)
end)
ESX.RegisterCommand('setspawnlocation', 'admin', function(xPlayer, args, showError)
    local playerPed = GetPlayerPed(xPlayer.source)
    local playerCoords = GetEntityCoords(playerPed)
    
    local spawnLocation = json.encode({
        x = playerCoords.x,
        y = playerCoords.y,
        z = playerCoords.z
    })

    local loodsId = tonumber(args.loodsid)
    
    if loodsId then
        MySQL.Async.execute('UPDATE loodsen SET spawnlocation = @spawnlocation WHERE id = @id', {
            ['@spawnlocation'] = spawnLocation,
            ['@id'] = loodsId
        }, function(affectedRows)
            if affectedRows > 0 then
                xPlayer.showNotification("Spawnlocatie succesvol ingesteld voor loods ID: " .. loodsId)
                TriggerEvent('okokNotify:Alert', "Success", "Spawnlocatie ingesteld voor loods ID: " .. loodsId, 5000, 'success')
            else
                xPlayer.showNotification("Fout: Ongeldige loods ID of loods niet gevonden.")
                TriggerEvent('okokNotify:Alert', "Error", "Ongeldige loods ID of loods niet gevonden.", 5000, 'error')
            end
        end)
    else
        xPlayer.showNotification("Fout: Ongeldige loods ID.")
        TriggerEvent('okokNotify:Alert', "Error", "Ongeldige loods ID.", 5000, 'error')
    end
end, false, {help = 'Stel de spawnlocatie in voor een loods', validate = true, arguments = {
    {name = 'loodsid', help = 'De ID van de loods', type = 'number'}
}})
ESX.RegisterCommand('tptoloods', 'admin', function(xPlayer, args, showError)
    local loodsId = tonumber(args.loodsid)

    if loodsId then
        MySQL.Async.fetchScalar('SELECT location FROM loodsen WHERE id = @id', {
            ['@id'] = loodsId
        }, function(location)
            if location then
                local loc = json.decode(location)

                if loc and loc.x and loc.y and loc.z then
                    local playerPed = GetPlayerPed(xPlayer.source)
                    SetEntityCoords(playerPed, loc.x, loc.y, loc.z, false, false, false, true)

                    xPlayer.showNotification("Je bent geteleporteerd naar loods ID: " .. loodsId)
                    TriggerEvent('okokNotify:Alert', "Success", "Je bent geteleporteerd naar loods ID: " .. loodsId, 5000, 'success')
                else
                    xPlayer.showNotification("Fout: Ongeldige locatiegegevens.")
                    TriggerEvent('okokNotify:Alert', "Error", "Ongeldige locatiegegevens.", 5000, 'error')
                end
            else
                xPlayer.showNotification("Fout: Loods niet gevonden.")
                TriggerEvent('okokNotify:Alert', "Error", "Loods niet gevonden.", 5000, 'error')
            end
        end)
    else
        xPlayer.showNotification("Fout: Ongeldige loods ID.")
        TriggerEvent('okokNotify:Alert', "Error", "Ongeldige loods ID.", 5000, 'error')
    end
end, false, {help = 'Teleport naar een loods locatie', validate = true, arguments = {
    {name = 'loodsid', help = 'De ID van de loods', type = 'number'}
}})
