ESX = exports.es_extended:getSharedObject()

local WebhookLink = 'https://discord.com/api/webhooks/1273639143045464104/sjVf0YSBvnpIxuvxpUbFdGNoAzJuD4BJMblgUMVS5eUk3ljwjNPgfHkm_NoNT7GbUzHr' -- PUT YOUR WEBHOOK LINK HERE

function Webhook()
	return WebhookLink
end

function MySQLexecute(query, values, func)
	return MySQL.Async.execute(query, values, func)
end

function MySQLfetchAll(query, values, func)
	return MySQL.Async.fetchAll(query, values, func)
end

function MySQLinsert(query, values, func)
	return MySQL.Async.insert(query, values, func)
end

function getAccountMoney(xPlayer, account)
	return xPlayer.getAccount(account).money
end

function addMoney(xPlayer, account, amount)
	xPlayer.addAccountMoney(account, tonumber(amount))
end

function removeMoney(xPlayer, account, amount)
	xPlayer.removeAccountMoney(account, tonumber(amount))
end

function isAdminF(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerGroup = xPlayer.getGroup()
	local isAdmin = false

	for k,v in ipairs(Config.AdminGroups) do
		if playerGroup == v then
			isAdmin = true
			break
		end
	end

	return isAdmin
end

RegisterServerEvent(Config.EventPrefix..':VehicleBought')
AddEventHandler(Config.EventPrefix..':VehicleBought', function (source, vehicleModel, price)
	-- Execute code after vehicle has been bought
end)

RegisterServerEvent(Config.EventPrefix..':setVehicleOwned')
AddEventHandler(Config.EventPrefix..':setVehicleOwned', function (vehicleProps, model, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if Config.Boats[model] == true then
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = vehicleProps.plate,
            ['@vehicle'] = json.encode(vehicleProps),
            ['@type'] = 'boat'
        }, function (rowsChanged)
        end)
	elseif Config.Aircrafts[model] == true then
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type) VALUES (@owner, @plate, @vehicle, @type)', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = vehicleProps.plate,
            ['@vehicle'] = json.encode(vehicleProps),
            ['@type'] = 'air'
        }, function (rowsChanged)
        end)
	else
		MySQLexecute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
		{
			['@owner'] = xPlayer.identifier,
			['@plate'] = vehicleProps.plate:match( "^%s*(.-)%s*$" ),
			['@vehicle'] = json.encode(vehicleProps)
		}, function (rowsChanged)
		end)
	end
end)

ESX.RegisterServerCallback(Config.EventPrefix..":HasLicense", function(source, cb, license)
	local hasLicense = false

	if license == "" then
		hasLicense = true
	elseif license == "boat" then
		-- Add the checks to see if the player has the license
		hasLicense = true
	end

	cb(hasLicense)
end)

ESX.RegisterServerCallback(Config.EventPrefix..":canBuy", function(source, cb, vehicle_id)
	local canBuyVehicle = true

	-- Usefull for limit checks

	if not canBuyVehicle then
		-- Add notification if needed
	end

	cb(canBuyVehicle)
end)

ESX.RegisterServerCallback(Config.EventPrefix..":canOpenMenu", function(source, cb, shop_id)
	local canOpenShop = true
	
	-- Here you can make the verifications you want,
	-- For example check if a no VIP person is trying to open a VIP shop, if so change canOpenShop to false

	cb(canOpenShop)
end)

ESX.RegisterServerCallback(Config.EventPrefix..':buyShop', function (source, cb, id, name, price, currency)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local bankMoney = xPlayer.getAccount(currency).money
	
	if bankMoney >= price then
		MySQLfetchAll('SELECT * FROM okokvehicleshop_shops WHERE owner = @owner', {
			['@owner'] = xPlayer.identifier,
		}, function(owning)
			if #owning < Config.MaxDealershipsPerPlayer then
				MySQLexecute('UPDATE okokvehicleshop_shops SET owner = @owner, owner_name = @name WHERE shop_id = @shop_id AND owner IS NULL', {
					['@owner'] = xPlayer.identifier,
					['@name'] = getName(xPlayer.identifier),
					['@shop_id'] = id,
				}, function (rowsChanged)
					if rowsChanged > 0 then
						removeMoney(xPlayer, currency, price)
						TriggerClientEvent(Config.EventPrefix..":updateShopsOwned", -1)
						TriggerClientEvent(Config.EventPrefix..':notification', _source, 'bought_veh', interp(notifyData['bought_veh'].text, {vehicle_name = name, vehiclePrice = price}))
						cb(true)
						if Webhook ~= '' and Config.BuyBusinessWebhook then
							local identifierlist = ExtractIdentifiers(xPlayer.source)
							local data = {
								playerid = xPlayer.source,
								identifier = identifierlist.license:gsub("license2:", ""),
								discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
								color = Config.BuyBusinessWebhookColor,
								type = "buyBusiness",
								action = "Bought a business",
								item = id,
								price = price,
								title = "Vehicle Shop - Business",
							}
							discordWenhook(data)
						end
					else
						TriggerClientEvent(Config.EventPrefix..':notification', _source, 'some_wrong', notifyData['some_wrong'].text)
						cb(false)
					end
				end)
			else
				TriggerClientEvent(Config.EventPrefix..':notification', _source, 'max_shops', notifyData['max_shops'].text)
			end
		end)
	else
		TriggerClientEvent(Config.EventPrefix..':notification', _source, 'not_enough_money', notifyData['not_enough_money'].text)
		cb(false)
	end
end)

RegisterServerEvent(Config.EventPrefix..':checkSellVehicle')
AddEventHandler(Config.EventPrefix..':checkSellVehicle', function(plate, shop_id, type, hashKey, hasOwner)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	MySQLfetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @owner', {
		['@plate'] = plate:match( "^%s*(.-)%s*$" ),
		['@owner'] = xPlayer.identifier
	}, function (result)
		if result[1] ~= nil then
			MySQLfetchAll('SELECT * FROM okokvehicleshop_vehicles WHERE type = @type', {
				['@type'] = type,
			}, function (vehicles)
				if vehicles[1] ~= nil then
					local vehicle = nil
					for k,v in ipairs(vehicles) do
						if hashKey == GetHashKey(v.vehicle_id) then
							vehicle = v
							break
						end
					end
					if vehicle ~= nil then
						local payment = tonumber(vehicle.min_price)*(tonumber(Config.VehicleSellPercentage)/100)
						payment = math.floor(payment+0.5)
						TriggerClientEvent(Config.EventPrefix..":verifySell", _source, payment, shop_id, plate, vehicle.vehicle_id, vehicle.vehicle_name, type, hasOwner)
					else
						TriggerClientEvent(Config.EventPrefix..':notification', _source, 'dont_sell', notifyData['dont_sell'].text)
					end
				else
					TriggerClientEvent(Config.EventPrefix..':notification', _source, 'dont_sell', notifyData['dont_sell'].text)
				end
			end)
		else
			TriggerClientEvent(Config.EventPrefix..':notification', _source, 'not_your_vehicle', notifyData['not_your_vehicle'].text)
		end
	end)
end)

RegisterServerEvent(Config.EventPrefix .. ':HireNewEmploye')
AddEventHandler(Config.EventPrefix .. ':HireNewEmploye', function(identifier, shopId, grade)
    -- Executed when someone hires an employee
end)

RegisterServerEvent(Config.EventPrefix .. ':FireEmployeEvent')
AddEventHandler(Config.EventPrefix .. ':FireEmployeEvent', function(identifier, shopId)
    -- Executed when someone fires an employee
end)

RegisterServerEvent(Config.EventPrefix .. ':ChangeEmployeGrade')
AddEventHandler(Config.EventPrefix .. ':ChangeEmployeGrade', function(identifier, shopId, grade)
	-- Executed someone changes employee grade
end)

RegisterServerEvent(Config.EventPrefix .. ':SellShop')
AddEventHandler(Config.EventPrefix .. ':SellShop', function(playerId, shopId, employeeList)
    -- Executed when owner sells business
end)

RegisterServerEvent(Config.EventPrefix..':setVehicleInfo')
AddEventHandler(Config.EventPrefix..':setVehicleInfo', function(vehicle, vehicle_id, vehicle_name, min_price, max_price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local isAdmin = false

	isAdmin = isAdminF(source)

	if isAdmin then
		if tonumber(min_price) < tonumber(max_price) then
			local owner_buy_price = math.floor(tonumber(min_price) * (1 - tonumber(Config.OwnerBuyVehiclePercentage) / 100))
			MySQLexecute('UPDATE okokvehicleshop_vehicles SET vehicle_id = @vehicle_id, vehicle_name = @vehicle_name, min_price = @min_price, max_price = @max_price, owner_buy_price = @owner_buy_price WHERE vehicle_id = @vehicle_id2 AND type = @type AND category = @category', {
				['@vehicle_id'] = vehicle_id,
				['@vehicle_name'] = vehicle_name,
				['@min_price'] = min_price,
				['@max_price'] = max_price,
				['@owner_buy_price'] = owner_buy_price,
				['@vehicle_id2'] = vehicle.vehicle_id,
				['@type'] = vehicle.type,
				['@category'] = vehicle.category
			}, function (rowsChanged2)
				if rowsChanged2 > 0 then
					TriggerClientEvent(Config.EventPrefix..':updateAdminMenus', _source)
					TriggerClientEvent(Config.EventPrefix..':notification', _source, 'change_info', interp(notifyData['change_info'].text, {vehicle_name = vehicle.vehicle_name}))
				end
			end)
		else
			TriggerClientEvent(Config.EventPrefix..':notification', _source, 'min_max_price', notifyData['min_max_price'].text)
		end
	end
end)

RegisterServerEvent(Config.EventPrefix..':removeVehicle')
AddEventHandler(Config.EventPrefix..':removeVehicle', function(vehicle)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local isAdmin = false

	isAdmin = isAdminF(source)

	if isAdmin then
		MySQLexecute('DELETE FROM okokvehicleshop_vehicles WHERE vehicle_id = @vehicle_id AND type = @type AND category = @category', {
			['@vehicle_id'] = vehicle.vehicle_id,
			['@type'] = vehicle.type,
			['@category'] = vehicle.category
		}, function (rowsChanged2)
			if rowsChanged2 > 0 then
				TriggerClientEvent(Config.EventPrefix..':updateAdminMenus', _source)
				TriggerClientEvent(Config.EventPrefix..':notification', _source, 'remove_veh', interp(notifyData['remove_veh'].text, {vehicle_name = vehicle.vehicle_name}))
			end
		end)
	end
end)

RegisterServerEvent(Config.EventPrefix..':addVehicleToDB')
AddEventHandler(Config.EventPrefix..':addVehicleToDB', function(type, category, vehicle_id, vehicle_name, min_price, max_price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local isAdmin = false

	isAdmin = isAdminF(source)

	if isAdmin then
		if tonumber(min_price) < tonumber(max_price) then
			local owner_buy_price = math.floor(tonumber(min_price) * (1 - tonumber(Config.OwnerBuyVehiclePercentage) / 100))
			MySQLinsert('INSERT INTO okokvehicleshop_vehicles (type, category, vehicle_id, vehicle_name, min_price, max_price, owner_buy_price) VALUES (@type, @category, @vehicle_id, @vehicle_name, @min_price, @max_price, @owner_buy_price)', {
				['@type'] = type,
				['@category'] = category,
				['@vehicle_id'] = vehicle_id,
				['@vehicle_name'] = vehicle_name,
				['@min_price'] = min_price,
				['@max_price'] = max_price,
				['@owner_buy_price'] = owner_buy_price
			}, function (rowsChanged)
				TriggerClientEvent(Config.EventPrefix..':updateAdminMenus', _source)
				TriggerClientEvent(Config.EventPrefix..':notification', _source, 'created_veh', interp(notifyData['created_veh'].text, {vehicle_name = vehicle_name}))
			end)
		else
			TriggerClientEvent(Config.EventPrefix..':notification', _source, 'min_max_price', notifyData['min_max_price'].text)
		end
	end
end)

ESX.RegisterServerCallback(Config.EventPrefix..":GetShopsInfo", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer == nil then return end
	local myIdentifier = xPlayer.identifier
	local unownedShops = {}
	local ownedShops = {}
	local workingShops = {}

	MySQLfetchAll('SELECT * FROM okokvehicleshop_shops', {}, function(shops)
		for k,v in ipairs(shops) do
			local employees = json.decode(v.employees)
			if v.owner == nil then
				table.insert(unownedShops, v)
			elseif v.owner == myIdentifier then
				table.insert(ownedShops, v)
			else
				if employees ~= nil then
					if employees[myIdentifier] ~= nil then
						table.insert(workingShops, v)
					end
				end
			end
		end
		cb(unownedShops, ownedShops, workingShops)
	end)
end)

function getName(identifier)
	local name = nil
	MySQLfetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(db_name)
		if db_name[1] ~= nil then
			name = db_name[1].firstname.." "..db_name[1].lastname
		else
			name = ""
		end
	end)
	while name == nil do
		Citizen.Wait(2)
	end
	return name
end

function ExtractIdentifiers(id)
	local identifiers = {
		steam = "",
		ip = "",
		discord = "",
		license = "",
		xbl = "",
		live = ""
	}

	for i = 0, GetNumPlayerIdentifiers(id) - 1 do
		local playerID = GetPlayerIdentifier(id, i)

		if string.find(playerID, "steam") then
			identifiers.steam = playerID
		elseif string.find(playerID, "ip") then
			identifiers.ip = playerID
		elseif string.find(playerID, "discord") then
			identifiers.discord = playerID
		elseif string.find(playerID, "license") then
			identifiers.license = playerID
		elseif string.find(playerID, "xbl") then
			identifiers.xbl = playerID
		elseif string.find(playerID, "live") then
			identifiers.live = playerID
		end
	end

	return identifiers
end

function discordWenhook(data)
	local information = {}

	if data.type == 'buyBusiness' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Price:** '..data.price..'€\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'sellBusiness' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Received:** '..data.price..'€\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'deposit' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Deposited:** '..data.price..'€\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'withdraw' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Withdrawn:** '..data.price..'€\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'startOrder' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Vehicle:** '..data.vehicle..'\n**Reward:** '..data.price..'€\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'endOrder' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Vehicle:** '..data.vehicle..'\n**Reward:** '..data.price..'€\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'hire' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'fire' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'changeRank' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n**Rank:** '..data.rank..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'buyVehicle' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Vehicle:** '..data.vehicle..'\n**Price:** '..data.price..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'addSellingStock' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Vehicle:** '..data.vehicle..'\n**Amount:** '..data.amount..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'cancelSellingStock' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Vehicle:** '..data.vehicle..'\n**Amount:** '..data.amount..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'orderedVehicle' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Vehicle:** '..data.vehicle..'\n**Amount:** '..data.amount..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'quitBusiness' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	end
	


	PerformHttpRequest(WebhookLink, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end