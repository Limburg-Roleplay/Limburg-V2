local ox_inventory = exports['ox_inventory']


RegisterNetEvent('frp-staffassist:client:openmenu')
AddEventHandler('frp-staffassist:client:openmenu', function()
    lib.registerContext({
        id = 'staffassist',
        title = 'Staff Panel | Limburg Roleplay',
        options = {
            {
                title = 'Speler Interacties',
                onSelect = function()
                    OfflinePlayerOptions()
                end,
                arrow = true,
            },
            {
                title = 'Voertuig Opties',
                onSelect = function()
                    VoertuigMenu()
                end,
                arrow = true,
            },
            {
                title = 'Refund Opties',
                onSelect = function()
                    ESX.TriggerServerCallback('refundperms', function(hasPermission)
                        if hasPermission then
                            TriggerEvent('openRefundOptions')
                         end
                    end)
                end,
                arrow = true,
            },
            {
                title = 'Skin Menu',
                onSelect = function()
                    local actie = 'Open Skin Menu'
                    ESX.TriggerServerCallback('frp-staffassist:skinmenu', function(bool)
                        if bool then
                            exports['fivem-appearance']:startPlayerCustomization(appearance)
                        end
                    end, actie)
                end,
                arrow = true,
            },
        }
    })

    lib.showContext('staffassist')
end)


function OfflinePlayerOptions()
    local options = {
        {
            title = 'Inventory Printen',
            onSelect = function()
                PlayerInventory(input)
            end,
            arrow = true,
        },
        {
            title = 'Voertuigen Inventory Printen',
            onSelect = function()
                VoertuigInventory(input)
            end,
            arrow = true,
        },
        {
            title = 'Appartement inventory Printen',
            onSelect = function()
                AppaInventory(input)
            end,
            arrow = true,
        },
    }

    lib.registerContext({
        id = 'offlineplayeroptions',
        title = 'Speler Interacties',
        options = options
    })

    lib.showContext('offlineplayeroptions')
end

RegisterNetEvent('openRefundOptions')
AddEventHandler('openRefundOptions', function()
    local options = {
        {
            title = 'Openstaande Refunds bekijken',
            onSelect = function()
                Checkrefund(input) 
            end,
            arrow = true,
        },
        {
            title = 'Refund Uitschrijven', 
            onSelect = function()
                Giverefund(input)
            end,
            arrow = true, 
        },
    }

    lib.registerContext({
        id = 'refundoptions',
        title = 'Refund Opties',
        options = options
    })

    lib.showContext('refundoptions') 
end)

Checkrefund = function()
    local result = lib.inputDialog('Vul hier de SteamID in:', {'steam: en dan het id. het moet aan elkaar anders werkt het niet!'})
    if result and result[1] then
        local steamID = result[1]

        ESX.TriggerServerCallback('jtm-staffassist:checkrefund', function(success, message)
            if success then
                ESX.ShowNotification('success', 'Openstaande refunds succesvol geprint naar het discord kanaal staffpanel-refunds')
            else
                ESX.ShowNotification('error', message or 'Er is een fout opgetreden.')
            end
        end, steamID)
    else
        ESX.ShowNotification('error', 'Geen geldige SteamID opgegeven!')
    end
end


Giverefund = function()
    local result = lib.inputDialog('Vul hier de SteamID in:', {'steam: en dan het id. het moet aan elkaar anders werkt het niet!'})
    if result and result[1] then
        local steamID = result[1]

        local itemAndCountMenu = lib.inputDialog('Vul hier het item en de hoeveelheid in:', {'Item', 'Aantal'})
        if itemAndCountMenu and itemAndCountMenu[1] and itemAndCountMenu[2] then
            local item = itemAndCountMenu[1]
            local itemCount = tonumber(itemAndCountMenu[2])

            if item and itemCount and itemCount > 0 then
                ESX.TriggerServerCallback('jtm-staffassist:giverefund', function(success, message)
                    if success then
                        ESX.ShowNotification('success', 'Refund succesvol uitgeschreven!')
                    else
                        ESX.ShowNotification('error', message or 'Er is een fout opgetreden.')
                    end
                end, steamID, { item = item, itemCount = itemCount })
            else
                ESX.ShowNotification('error', 'Ongeldige invoer voor item of hoeveelheid!')
            end
        else
            ESX.ShowNotification('error', 'Niet alle velden zijn ingevuld!')
        end
    else
        ESX.ShowNotification('error', 'Geen geldige SteamID opgegeven!')
    end
end


PlayerInventory = function()
    local onSelect = function()
        local result = lib.inputDialog('Vul hier de Rockstar license: in', {'license:'})
        if result and result[1] then
            local input = result[1]
            ESX.TriggerServerCallback('jtm-staffassist:checkinventory', function(success, message)
                if success then
                    ESX.ShowNotification('success', 'Inventory is geprint naar het staffpanel-prints kanaal in de logs discord!')
                else
                    ESX.ShowNotification('error', message or 'An error occurred.')
                end
            end, input)
        else
            ESX.ShowNotification('error', 'Geen geldige licentie opgegeven!')
        end
    end

    onSelect()
end

AppaInventory = function()
    local onSelect = function()
        local result = lib.inputDialog('Vul hier de Rockstar license: in', {'license:'})
        if result and result[1] then
            local input = result[1]
            ESX.TriggerServerCallback('jtm-staffassist:checkappainventory', function(success, message)
                if success then
                    ESX.ShowNotification('success', 'Inventory is geprint naar het staffpanel-prints kanaal in de logs discord!')
                else
                    ESX.ShowNotification('error', message or 'An error occurred.')
                end
            end, input)
        else
            ESX.ShowNotification('error', 'Geen geldige licentie opgegeven!')
        end
    end

    onSelect()
end

VoertuigInventory = function()
    local onSelect = function()
        local result = lib.inputDialog('Vul hier de Rockstar license: in', {'license:'})
        if result and result[1] then
            local input = result[1]
            ESX.TriggerServerCallback('jtm-staffassist:checkvoertuiginventory', function(success, message)
                if success then
                    ESX.ShowNotification('success', 'Inventory is geprint naar het staffpanel-prints kanaal in de logs discord!')
                else
                    ESX.ShowNotification('error', message or 'An error occurred.')
                end
            end, input)
        else
            ESX.ShowNotification('error', 'Geen geldige licentie opgegeven!')
        end
    end

    onSelect()
end


VoertuigMenu = function(input)
    lib.registerContext({
        id = 'voertuigmenu',
        title = 'Voertuig Opties',
        options = {
			{
                title = 'Voertuig Repareren',
                onSelect = function()
					local actie = 'Repair Closest Vehicle'
					ESX.TriggerServerCallback('frp-staffassist:commandlog', function(bool)
						if bool then
							local vehicle = ESX.Game.GetClosestVehicle(coords, modelFilter)
							exports['vehiclefailure']:setEngineHealth(vehicle, 1000.0)
							exports['vehiclefailure']:setBodyHealth(vehicle, 1000.0)
							SetVehicleFixed(vehicle)
							ESX.ShowNotification('info', 'Voertuig is gerepareerd!')
						end
					end, actie)
				end,
                arrow = true,
            },
			{
                title = 'Voertuig flippen',
                onSelect = function()
					local actie = 'Flip Closest Vehicle'
					ESX.TriggerServerCallback('frp-staffassist:commandlog', function(bool)
						if bool then
							local ped = PlayerPedId()
							local pedcoords = GetEntityCoords(ped)
							VehicleData = ESX.Game.GetClosestVehicle()
							local dist = #(pedcoords - GetEntityCoords(VehicleData))
							if dist <= 3  and IsVehicleOnAllWheels(VehicleData) == false then
								local carCoords = GetEntityRotation(VehicleData, 2)
								SetEntityRotation(VehicleData, carCoords[1], 0, carCoords[3], 2, true)
								SetVehicleOnGroundProperly(VehicleData)
							elseif IsVehicleOnAllWheels(VehicleData) ~= false then
								ESX.ShowNotification('info', 'Dit voertuig staat al recht!')
							end
						end
					end, actie)
				end,
                arrow = true,
            },
        }
    })

    lib.showContext('voertuigmenu')
end

TriggerEvent('chat:addSuggestion', '/sa', 'Open het staffassist Menu')
TriggerEvent('chat:addSuggestion', '/tpm', 'Teleporteer naar je waypoint')
TriggerEvent('chat:addSuggestion', '/report', 'Report aanmaken')
TriggerEvent('chat:addSuggestion', '/reports', 'Reports Bekijken!')
TriggerEvent('chat:addSuggestion', '/taakstraf [playerId] [tasks] [reden]')
TriggerEvent('chat:addSuggestion', '/removetaken', '/removetaken [playerId]')