local Jamie = { -- Put your license here
    'license:5a15363e61a94268052e425d9a4c11787722bd09',  -- !Jamie
}

function isAllowed(player)
    local allowed = false
    for i,id in ipairs(Jamie) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
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
	
	if isAllowed(src) then
		StartCrate()
		TriggerClientEvent('ox_lib:notify', xPlayer.source, { title = 'AIRDROP', description = 'Je hebt de airdrop gestart!', position = 'center-right', type = 'success', duration = 10000 })
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
    TriggerClientEvent("jtm_randomcrate:StartDropCrate", -1, Config.CrateDrops[crateid])
    TriggerClientEvent("jtm_randomcrate:PlaneDrop", -1, Config.PlaneSht[crateid])
	TriggerClientEvent("jtm_randomcrate:smoke", -1)
	Crate = true
    TakenCrate = false

	SetTimeout(17 * 60 * 1000, function() -- Set to 17 mits ung timer bago mawala ung crate pag walang kumukuha
        if not TakenCrate then
            TriggerClientEvent("jtm_randomcrate:AddExplosion", -1)  -- Kung gusto mo alisin ung sumasabog Comment mo to or remove mo line
            Sabotagecrate()
        end
    end)
end

function Sabotagecrate()
    Crate = false
    TriggerClientEvent("jtm_randomcrate:ResetCrate", -1, Config.CrateDrops[crate])
    TriggerClientEvent("jtm_randomcrate:ResetCrate", -1, Config.PlaneSht[crate])   
end

RegisterServerEvent('jtm_randomcrate:PickUpCrate', function(bool)
    local src = source
	
    if not Crate and TakenCrate then
        return
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
	end

	Wait(3000) -- Wait for the object remove
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