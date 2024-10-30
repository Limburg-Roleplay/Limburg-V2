ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local switchCost = Config.SwitchCost
local blacklistedWords = Config.BlacklistedWords

local function containsBlacklistedWord(name)
    for _, word in ipairs(blacklistedWords) do
        if name:lower():find(word:lower()) then
            return true
        end
    end
    return false
end

RegisterNetEvent("lrp-namechange:checkMoney")
AddEventHandler("lrp-namechange:checkMoney", function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId) 

    if xPlayer then
        local playerBankMoney = xPlayer.getAccount('bank').money 

        if playerBankMoney >= switchCost then
            TriggerClientEvent("lrp-namechange:requestNewNames", playerId)
        else
            TriggerClientEvent('okokNotify:Alert', playerId, 'Fout', 'Je hebt hier niet genoeg geld voor! Je hebt €50.000 Nodig!', 5000, 'error')
        end
    end
end)

RegisterNetEvent("lrp-namechange:process")
AddEventHandler("lrp-namechange:process", function(firstName, lastName)
    local src = source

    if firstName and lastName and firstName ~= "" and lastName ~= "" then
        if not firstName:match("^[%a%s]*$") or not lastName:match("^[%a%s]*$") then
            TriggerClientEvent('okokNotify:Alert', src, 'Fout', 'Voer alleen letters in voor voornaam en achternaam. Geen speciale tekens of spaties toegestaan.', 5000, 'error')
            return
        end

        if #firstName <= 10 and #lastName <= 10 
           and firstName:sub(1, 1):upper() == firstName:sub(1, 1) 
           and lastName:sub(1, 1):upper() == lastName:sub(1, 1) 
           and not containsBlacklistedWord(firstName) 
           and not containsBlacklistedWord(lastName) then
            
            local identifiers = GetPlayerIdentifiers(src)
            local rockstarIdentifier = nil
            
            for _, identifier in ipairs(identifiers) do
                if identifier:find("license:") then
                    rockstarIdentifier = identifier:gsub("license:", "")
                    break
                end
            end

            if rockstarIdentifier then
                MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = ?", {rockstarIdentifier}, function(result)
                    if result and #result > 0 then
                        MySQL.Async.execute("UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ?", {firstName, lastName, rockstarIdentifier}, function(rowsChanged)
                            if rowsChanged > 0 then
                                local xPlayer = ESX.GetPlayerFromId(src)
                                if xPlayer then
                                    xPlayer.removeAccountMoney('bank', switchCost)
                                    
                                    TriggerClientEvent('okokNotify:Alert', src, 'Succes', 'Je naam is succesvol gewijzigd naar ' .. firstName .. ' ' .. lastName .. ' Relog even zodat alles goed word overgezet!', 5000, 'success')
                                end
                            else
                                TriggerClientEvent('okokNotify:Alert', src, 'Fout', 'Naam wijziging is mislukt. Controleer of je identifier correct is en of de gebruiker bestaat.', 5000, 'error')
                            end
                        end)
                    else
                        TriggerClientEvent('okokNotify:Alert', src, 'Fout', 'Geen gebruiker gevonden met deze identifier. Maak een ticket aan voor meer info!', 5000, 'error')
                    end
                end)
            else
                TriggerClientEvent('okokNotify:Alert', src, 'Fout', 'Geen Rockstar license gevonden. Maak een ticket aan voor meer info!', 5000, 'error')
            end
        else
            TriggerClientEvent('okokNotify:Alert', src, 'Fout', 'Voer een geldige voornaam en achternaam in. Beide moeten beginnen met een hoofdletter, mogen maximaal 10 letters lang zijn, en mogen geen verboden woorden bevatten.', 5000, 'error')
        end
    else
        TriggerClientEvent('okokNotify:Alert', src, 'Fout', 'Beide velden moeten ingevuld zijn.', 5000, 'error')
    end
end)
