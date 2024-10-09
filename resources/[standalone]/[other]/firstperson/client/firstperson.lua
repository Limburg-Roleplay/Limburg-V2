local ped = nil
local PlayerData = {}
local cooldown = 0
  
Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Wait(30)
	end

	while ped == nil do
        Wait(7)
        ped = PlayerPedId()
    end
  
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setjob')
AddEventHandler('esx:setjob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setjob2')
AddEventHandler('esx:setjob2', function(job)
	PlayerData.job2 = job
end)

local pedCoords = nil

Citizen.CreateThread(function()
    while true do
        pedCoords = GetEntityCoords(ped, true)
        Wait(500)
    end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1
		local playerPed = PlayerPedId()

		if IsPedJumping(playerPed) then
			cooldown = 2
		end

		if cooldown > 0 then
			cooldown = cooldown - 0.01
			DisableControlAction(0, 22, true)
		end

		Wait(sleep)
	end
end)

local ExemptWeapons = {
	`WEAPON_UNARMED`,
	`WEAPON_AWM`,
	`WEAPON_M82`,
	`WEAPON_HEAVYSNIPER_MK2`,
	`WEAPON_MARKSMANRIFLE`,
	`WEAPON_MARKSMANRIFLE_MK2`,
	`WEAPON_BARRET50`,
}

local ExemptWeaponsFirstPerson = {
	`WEAPON_BZGAS`,
	`WEAPON_MOLOTV`,
	`WEAPON_STICKYBOMB`,
	`WEAPON_SNOWBALL`,
	`WEAPON_SMOKEGRENADE`,
	`WEAPON_FLARE`,
	`WEAPON_BALL`,
	`WEAPON_PROXIMINE`,
	`WEAPON_PETROLCAN`,
	`WEAPON_HAZARDCAN`,
	`WEAPON_FIREEXTINGUISHER`,
	`WEAPON_FLASHLIGHT`,
	`WEAPON_MARKSMANPISTOL`,
}

local ThirdPersonDisable = true
local FPTPCoverDisable = true
local shotCooldown = 0
local initialCamViewMode = nil

function lookingBehind()
	local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -24.0, 0.0)
    local onScreen = GetScreenCoordFromWorldCoord(coordB.x, coordB.y, coordB.z)
    return onScreen
end

function isWeaponExempt(weapon)
    local isExempt = false

    for k, v in pairs(ExemptWeapons) do
        if weapon == v then
            isExempt = true
            break
        end
    end
    return isExempt
end

function isWeaponBlacklistedFromFirstPerson(weapon)
    local isExempt = false

    for k, v in pairs(ExemptWeaponsFirstPerson) do
        if weapon == v then
            isExempt = true
            break
        end
    end
    return isExempt
end

Citizen.CreateThread(function()
	SetWeaponsNoAutoswap(true)
	SetWeaponsNoAutoreload(true)
	
	while true do
		Wait(1)
		if ped ~= nil then 
			-- Hide default component types
			HideHudComponentThisFrame(1)
			HideHudComponentThisFrame(3)
			HideHudComponentThisFrame(4)
			HideHudComponentThisFrame(5)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			InvalidateIdleCam()
			InvalidateVehicleIdleCam()

			local weapon = GetSelectedPedWeapon(ped)
			local isWeaponExempt = isWeaponExempt(weapon)
			local isNotFirstPerson = isWeaponBlacklistedFromFirstPerson(weapon)
			
			-- Set settings
			StatSetProfileSettingValue(237, false)
			
			-- Disable melee while aiming (may be not working)
			if ThirdPersonDisable and not isNotFirstPerson then
				local forceFirstPerson = false

				if IsPlayerFreeAiming(PlayerId()) then
					forceFirstPerson = true
				end
				
				if IsControlPressed(1, 25) then
					forceFirstPerson = true
				end

				if IsPedShooting(ped) then
					exports['dpemotes']:EmoteCancel()
					forceFirstPerson = true
					shotCooldown = 60
				end

				if shotCooldown > 0 then
					forceFirstPerson = true
					shotCooldown = shotCooldown - 1
				end

				if forceFirstPerson then
					if not initialCamViewMode then
						initialCamViewMode = GetFollowPedCamViewMode()
					end
					DisableControlAction(0)
					SetFollowVehicleCamViewMode(4)
					SetFollowPedCamViewMode(4)
				elseif initialCamViewMode ~= nil then
					SetFollowPedCamViewMode(initialCamViewMode)
					SetFollowVehicleCamViewMode(initialCamViewMode)
					initialCamViewMode = nil
				end
			end
			
			if IsPedArmed(ped, 6) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end

			DisableControlAction(1, 140, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 257, true)
			if IsControlPressed(1, 25) then
				EnableControlAction(1, 24, true)
			end
			
			-- Stop slaan met zaklamp
			if weapon == `WEAPON_FLASHLIGHT` then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end

			-- Disable ammo HUD
			DisplayAmmoThisFrame(false)
		end
	end
end)

function PetrisAdvancedDriveBy()
    local ped = PlayerPedId()
    local inveh = IsPedSittingInAnyVehicle(ped)
    local veh = GetVehiclePedIsUsing(ped)
    local vehspeed = GetEntitySpeed(veh) * 3.6
    
    -- Check if the player has the "ownergroup" permission
    local hasOwnerPerm = exports["discordperms"]:hasownergroup()
    
    if inveh then
        -- Allow drive-by for players with the owner group
        if hasOwnerPerm then
            SetPlayerCanDoDriveBy(PlayerId(), true)
        else
            -- Normal speed check for drive-by
            if vehspeed >= Config.MaxSpeedForDriveBy then
                SetPlayerCanDoDriveBy(PlayerId(), false)
            else
                SetPlayerCanDoDriveBy(PlayerId(), true)
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()
        
        if IsPedInAnyVehicle(playerPed, false) then
            local veh = GetVehiclePedIsIn(playerPed)
            local isDriver = GetPedInVehicleSeat(veh, -1) == playerPed
            
            if isDriver then
                -- If the player is in the driver's seat, always allow drive-by for owner group
                if exports["discordperms"]:hasownergroup() then
                    SetPlayerCanDoDriveBy(PlayerId(), true)
                else
                    PetrisAdvancedDriveBy()
                end
            else
                SetPlayerCanDoDriveBy(PlayerId(), false)
            end
        else
            SetPlayerCanDoDriveBy(PlayerId(), false)
        end
    end
end)

-- Weapon damage

local MeeleWeapons = {
	[`WEAPON_BAT`] = 0.20,
	[`WEAPON_KNIFE`] = 0.01,
	[`WEAPON_UNARMED`] = 0.20,
	[`WEAPON_NIGHTSTICK`] = 0.05,
	[`WEAPON_KNUCKLE`] = 0.50,
	[`WEAPON_BOTTLE`] = 0.40,
	[`WEAPON_HAMMER`] = 0.30,
	[`WEAPON_CROWBAR`] = 0.30,
	[`WEAPON_GOLFCLUB`] = 0.30,
	[`WEAPON_DAGGER`] = 0.20,
	[`WEAPON_SWITCHBLADE`] = 0.40,
	[`WEAPON_HATCHET`] = 0.65,
	[`WEAPON_FLASHLIGHT`] = 0.0,
	[`WEAPON_POOLCUE`] = 0.20,
	[`WEAPON_WRENCH`] = 0.30,
	[`WEAPON_BATTLEAXE`] = 0.85,
	[`WEAPON_CROWBAR`] = 0.25,
	[`WEAPON_BZGAS`] = 0.10,
	[`WEAPON_SNOWBALL`] = 0.0,
	[`WEAPON_VINTAGEPISTOL`] = 0.7,
}

Citizen.CreateThread(function()
	while true do
		Wait(100)
		-- SetPedSuffersCriticalHits(GetPlayerPed(-1), false)

		if ped ~= nil then
			for weapon, modifier in pairs(MeeleWeapons) do
				if GetSelectedPedWeapon(ped) == weapon then
					N_0x4757f00bc6323cfe(weapon, modifier)
					-- SetPlayerMeleeWeaponDamageModifier(weapon, modifier)
				end
			end 
		end
	end
end)

-- Ragdoll

local BONES = {
	--[[Pelvis]][11816] = true,
	--[[SKEL_L_Thigh]][58271] = true,
	--[[SKEL_L_Calf]][63931] = true,
	--[[SKEL_L_Foot]][14201] = true,
	--[[SKEL_L_Toe0]][2108] = true,
	--[[IK_L_Foot]][65245] = true,
	--[[PH_L_Foot]][57717] = true,
	--[[MH_L_Knee]][46078] = true,
	--[[SKEL_R_Thigh]][51826] = true,
	--[[SKEL_R_Calf]][36864] = true,
	--[[SKEL_R_Foot]][52301] = true,
	--[[SKEL_R_Toe0]][20781] = true,
	--[[IK_R_Foot]][35502] = true,
	--[[PH_R_Foot]][24806] = true,
	--[[MH_R_Knee]][16335] = true,
	--[[RB_L_ThighRoll]][23639] = true,
	--[[RB_R_ThighRoll]][6442] = true,
}

Citizen.CreateThread(function()
	while true do
		Wait(7)
		if ped ~= nil then
			if HasEntityBeenDamagedByAnyPed(ped) then
				if GetPedLastDamageBone(ped) then
					Disarm(ped)
				end
			end
		end
	 end
end)

function Bool(num) return num == 1 or num == true end

-- WEAPON DROP OFFSETS
local function GetDisarmOffsetsForPed(ped)
	local v

	if IsPedWalking(ped) then v = { 0.6, 4.7, -0.1 }
	elseif IsPedSprinting(ped) then v = { 0.6, 5.7, -0.1 }
	elseif IsPedRunning(ped) then v = { 0.6, 4.7, -0.1 }
	else v = { 0.4, 4.7, -0.1 } end

	return v
end

function Disarm(ped)
	if IsEntityDead(ped) then return false end

	local boneCoords
	local hit, bone = GetPedLastDamageBone(ped)

	hit = Bool(hit)

	if hit then
		if BONES[bone] then
			local kans = math.random(1, 2)
			if kans == 1 then
				return false
			else
				boneCoords = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, bone))
				SetPedToRagdoll(ped, 5000, 5000, 0, 0, 0, 0)
				-- Wait(5000)
				ClearEntityLastDamageEntity(ped)

				return true
			end
		end
	end

	return false
end
