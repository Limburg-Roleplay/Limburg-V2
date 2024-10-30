local Jamie = { -- Put your license here
    'license:5a15363e61a94268052e425d9a4c11787722bd09',  -- !Jamie
}

function isAllowed(player)
    local allowed = false

    if player.group == "owner" or player.group == "admin" then
        return true
    end

    for i, id in ipairs(Jamie) do
        for x, pid in ipairs(GetPlayerIdentifiers(player.source)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end

    return allowed
end


RegisterCommand("CRATE", function(source, args)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	
	if isAllowed(xPlayer) then
		StartCrate()
		TriggerClientEvent('ox_lib:notify', xPlayer.source, { title = 'AIRDROP', description = 'Je hebt de airdrop gestart!', position = 'center-right', type = 'success', duration = 10000 })
		
		local message = "[" .. xPlayer.source .. "] " .. GetPlayerName(xPlayer.source) .. " heeft zojuist een airdorp gestart."
		TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1300608556218716191/u084I-gpOzlB6vB2EhrSJTtt377fBMyCA9rZWpp1Gw5yCcDbjJxLRh-LJqADI_HaEimn', xPlayer.source, {title = message, desc = message }, 0x00ffff)
	else
		TriggerClientEvent('ox_lib:notify', xPlayer.source, { title = 'AIRDROP', description = 'Je hebt hier niet genoeg perms voor!', position = 'center-right', type = 'error', duration = 10000 })
	end  
end, true)  

local Crate = false
local TakenCrate = true
local ox_inventory = exports.ox_inventory

CreateThread(function()
	while true do
		Wait(2 * 60 * 60 * 1000)
		StartCrate()
	end
end)

function StartCrate()
	if Crate then
		return
	end

	local crateid = math.random(1, #Config.CrateDrops)
    TriggerClientEvent("jtm_randomcrate:StartDropCrate", -1, Config.CrateDrops[crateid], crateid)
    TriggerClientEvent("jtm_randomcrate:PlaneDrop", -1, Config.PlaneSht[crateid])
	TriggerClientEvent("jtm_randomcrate:smoke", -1)
	Crate = true
    TakenCrate = false

	SetTimeout(17 * 60 * 1000, function() -- Set to 17 mits ung timer bago mawala ung crate pag walang kumukuha
        if not TakenCrate then
            TriggerClientEvent("jtm_randomcrate:AddExplosion", -1, Config.CrateDrops[crateid])  -- Kung gusto mo alisin ung sumasabog Comment mo to or remove mo line
            Sabotagecrate()
        end
    end)
end

function Sabotagecrate()
    Crate = false
    TriggerClientEvent("jtm_randomcrate:ResetCrate", -1, Config.CrateDrops[crate])
    TriggerClientEvent("jtm_randomcrate:ResetCrate", -1, Config.PlaneSht[crate])   
end

local openingState = {}
RegisterServerEvent('jtm_randomcrate:StartOpeningCrate', function(id)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if openingState[id] ~= true then
        openingState[id] = true
		local message = "[" .. xPlayer.source .. "] " .. GetPlayerName(xPlayer.source) .. " is airdrop met id " .. id .. " aan het openen.."
		TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1300608556218716191/u084I-gpOzlB6vB2EhrSJTtt377fBMyCA9rZWpp1Gw5yCcDbjJxLRh-LJqADI_HaEimn', xPlayer.source, {title = message, desc = message }, 0x00ff00)
    end
end)

RegisterServerEvent('jtm_randomcrate:StopOpeningCrate', function(id)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if openingState[id] ~= false then
        openingState[id] = false
		local message = "[" .. xPlayer.source .. "] " .. GetPlayerName(xPlayer.source) .. " is gestopt met het openen van airdrop met id " .. id
		TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1300608556218716191/u084I-gpOzlB6vB2EhrSJTtt377fBMyCA9rZWpp1Gw5yCcDbjJxLRh-LJqADI_HaEimn', xPlayer.source, {title = message, desc = message }, 0xff0000)
    end
end)

ESX.RegisterServerCallback('jtm_randomcrate:checkOpeningState', function(source, cb, id)
	if openingState[id] == true then
		cb(false)  -- If crate is already being opened, return false
	else
		cb(true)   -- If crate is not being opened, return true
	end
end)

RegisterServerEvent('jtm_randomcrate:PickUpCrate', function(bool, crateId)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	print(openingState[crateId])
	print(bool, crateId)
	if openingState[crateId] == true then
        return TriggerClientEvent('ox_lib:notify', xPlayer.source, { title = 'Fout!', description = 'Deze airdrop word al geopent!', position = 'center-right', type = 'error', duration = 10000 })
    end

	TakenCrate = false
	if bool then
		local rewardId = generateShipmentRewardIndex()
		local mystash = ox_inventory:CreateTemporaryStash({
			label = 'Airdrop',
			slots = #Config.Weapon.InventoryReward[rewardId],
			maxWeight = calculateInventoryWeight(Config.Weapon.InventoryReward[rewardId]),
			items = Config.Weapon.InventoryReward[rewardId]
		})
		TriggerClientEvent('ox_inventory:openInventory', src, 'stash', mystash)
		local message = "[" .. xPlayer.source .. "] " .. GetPlayerName(xPlayer.source) .. " heeft zojuist de airdrop met id " .. crateId .. " geopend"
		TriggerEvent('td_logs:sendLog', 'https://discord.com/api/webhooks/1300608556218716191/u084I-gpOzlB6vB2EhrSJTtt377fBMyCA9rZWpp1Gw5yCcDbjJxLRh-LJqADI_HaEimn', xPlayer.source, {title = message, desc = message }, 0x0000ff)
	end

	Wait(3000) -- Wait for the object remove
	openingState[bool] = false
	TriggerClientEvent("jtm_randomcrate:ResetCrate", -1, Config.CrateDrops[crate])
    TriggerClientEvent("jtm_randomcrate:ResetCrate", -1, Config.PlaneSht[crate])    
end)

function generateShipmentRewardIndex()
	return math.random(1, #Config.Weapon.InventoryReward)
end

function calculateInventoryWeight(data)
	local weight = 0
	for i = 1, #data do
		local item = data[i]
		local itemData = ox_inventory:Items(item[1])
		if itemData then 
			weight += itemData.weight * item[2]
		end
	end
	return weight
end