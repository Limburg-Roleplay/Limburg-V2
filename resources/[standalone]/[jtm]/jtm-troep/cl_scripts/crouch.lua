Crouched = false
CrouchedForce = false
Aimed = false
LastCam = 0
Cooldown = false

CoolDownTime = 500

Citizen.CreateThread(function()
	while true do
		local sleep = 0
		DisableControlAction(0, 36, true)

		Wait(sleep)
	end
end)

NormalWalk = function() 
	local ped = PlayerPedId()
	SetPedMaxMoveBlendRatio(ped, 1.0)
	ResetPedMovementClipset(ped, 0.55)
	ResetPedStrafeClipset(ped)
	SetPedCanPlayAmbientAnims(ped, true)
	SetPedCanPlayAmbientBaseAnims(ped, true)
	ResetPedWeaponMovementClipset(ped)
	Crouched = false
end

SetupCrouch = function()
	while not HasAnimSetLoaded('move_ped_crouched') do
		Citizen.Wait(5)
		RequestAnimSet('move_ped_crouched')
	end
end

RemoveCrouchAnim = function()
	RemoveAnimDict('move_ped_crouched')
end

CanCrouch = function()
	local playerped = PlayerPedId()
	if IsPedOnFoot(playerped) and not IsPedJumping(playerped) and not IsPedFalling(playerped) and not IsPedDeadOrDying(playerped) then
		return true
	else
		return false
	end
end

CrouchPlayer = function()
	local ped = PlayerPedId()
	SetPedUsingActionMode(ped, false, -1, "DEFAULT_ACTION")
	SetPedMovementClipset(ped, 'move_ped_crouched', 0.55)
	SetPedStrafeClipset(ped, 'move_ped_crouched_strafing')
	SetWeaponAnimationOverride(ped, "Ballistic")
	Crouched = true
	Aimed = false
end

SetPlayerAimSpeed = function()
	local Player = PlayerPedId()
	SetPedMaxMoveBlendRatio(Player, 0.2)
	Aimed = true
end

IsPlayerFreeAimed = function()
	local PlayerID = GetPlayerIndex()
	if IsPlayerFreeAiming(PlayerID) or IsAimCamActive() or IsAimCamThirdPersonActive() then
		return true
	else
		return false
	end
end

CrouchLoop = function()
	SetupCrouch()
	while CrouchedForce do
		local CanDo = CanCrouch()
		if CanDo and Crouched and IsPlayerFreeAimed() then
			SetPlayerAimSpeed()
		elseif CanDo and (not Crouched or Aimed) then
			CrouchPlayer()
		elseif not CanDo and Crouched then
			CrouchedForce = false
            ResetPedMovementClipset(PlayerPedId(), 0.0)
			NormalWalk()
		end

		Citizen.Wait(5)
	end
	NormalWalk()
	RemoveCrouchAnim()
end

RegisterCommand('crouch', function()
	if not Cooldown then
		CrouchedForce = not CrouchedForce

		if CrouchedForce then
			CreateThread(CrouchLoop)
		end

		Cooldown = true
		SetTimeout(CoolDownTime, function()
			Cooldown = false
		end)
	end
end, false)

RegisterKeyMapping('crouch', 'Crouch', 'keyboard', 'LCONTROL')

IsCrouched = function()
	return Crouched
end

exports("IsCrouched", IsCrouched)

local disabledPickups = {
    `PICKUP_WEAPON_ADVANCEDRIFLE`,
    `PICKUP_WEAPON_APPISTOL`,
    `PICKUP_WEAPON_ASSAULTRIFLE`,
    `PICKUP_WEAPON_ASSAULTRIFLE_MK2`,
    `PICKUP_WEAPON_ASSAULTSHOTGUN`,
    `PICKUP_WEAPON_ASSAULTSMG`,
    `PICKUP_WEAPON_AUTOSHOTGUN`,
    `PICKUP_WEAPON_BAT`,
    `PICKUP_WEAPON_BATTLEAXE`,
    `PICKUP_WEAPON_BOTTLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE_MK2`,
    `PICKUP_WEAPON_BULLPUPSHOTGUN`,
    `PICKUP_WEAPON_CARBINERIFLE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2`,
    `PICKUP_WEAPON_COMBATMG`,
    `PICKUP_WEAPON_COMBATMG_MK2`,
    `PICKUP_WEAPON_COMBATPDW`,
    `PICKUP_WEAPON_COMBATPISTOL`,
    `PICKUP_ARMOUR_STANDARD`,
    `PICKUP_WEAPON_COMPACTLAUNCHER`,
    `PICKUP_WEAPON_COMPACTRIFLE`,
    `PICKUP_WEAPON_CROWBAR`,
    `PICKUP_WEAPON_DAGGER`,
    `PICKUP_WEAPON_DBSHOTGUN`,
    `PICKUP_WEAPON_DOUBLEACTION`,
    `PICKUP_WEAPON_LASSO`,
    `PICKUP_HEALTH_SNACK`,
    `PICKUP_WEAPON_FIREWORK`,
    `PICKUP_WEAPON_FLAREGUN`,
    `PICKUP_WEAPON_FLASHLIGHT`,
    `PICKUP_WEAPON_GRENADE`,
    `PICKUP_WEAPON_GRENADELAUNCHER`,
    `PICKUP_WEAPON_GUSENBERG`,
    `PICKUP_WEAPON_GolfClub`,
    `PICKUP_WEAPON_HAMMER`,
    `PICKUP_WEAPON_HATCHET`,
    `PICKUP_WEAPON_HEAVYPISTOL`,
    `PICKUP_WEAPON_HEAVYSHOTGUN`,
    `PICKUP_WEAPON_HEAVYSNIPER`,
    `PICKUP_WEAPON_HEAVYSNIPER_MK2`,
    `PICKUP_WEAPON_HOMINGLAUNCHER`,
    `PICKUP_WEAPON_KNIFE`,
    `PICKUP_WEAPON_KNUCKLE`,
    `PICKUP_WEAPON_MACHETE`,
    `PICKUP_WEAPON_MACHINEPISTOL`,
    `PICKUP_WEAPON_MARKSMANPISTOL`,
    `PICKUP_WEAPON_MARKSMANRIFLE`,
    `PICKUP_WEAPON_MARKSMANRIFLE_MK2`,
    `PICKUP_WEAPON_MG`,
    `PICKUP_WEAPON_MICROSMG`,
    `PICKUP_WEAPON_MINIGUN`,
    `PICKUP_WEAPON_MINISMG`,
    `PICKUP_WEAPON_MOLOTOV`,
    `PICKUP_WEAPON_MUSKET`,
    `PICKUP_WEAPON_NIGHTSTICK`,
    `PICKUP_WEAPON_PETROLCAN`,
    `PICKUP_WEAPON_PIPEBOMB`,
    `PICKUP_WEAPON_PISTOL`,
    `PICKUP_WEAPON_PISTOL50`,
    `PICKUP_WEAPON_PISTOL_MK2`,
    `PICKUP_WEAPON_POOLCUE`,
    `PICKUP_WEAPON_PROXMINE`,
    `PICKUP_WEAPON_PUMPSHOTGUN`,
    `PICKUP_WEAPON_PUMPSHOTGUN_MK2`,
    `PICKUP_WEAPON_RAILGUN`,
    `PICKUP_WEAPON_RAYCARBINE`,
    `PICKUP_WEAPON_RAYMINIGUN`,
    `PICKUP_WEAPON_RAYPISTOL`,
    `PICKUP_WEAPON_REVOLVER`,
    `PICKUP_WEAPON_REVOLVER_MK2`,
    `PICKUP_WEAPON_RPG`,
    `PICKUP_WEAPON_SAWNOFFSHOTGUN`,
    `PICKUP_WEAPON_SMG`,
    `PICKUP_WEAPON_SMG_MK2`,
    `PICKUP_WEAPON_SMOKEGRENADE`,
    `PICKUP_WEAPON_SNIPERRIFLE`,
    `PICKUP_WEAPON_SNSPISTOL`,
    `PICKUP_WEAPON_SNSPISTOL_MK2`,
    `PICKUP_WEAPON_SPECIALCARBINE`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2`,
    `PICKUP_WEAPON_STICKYBOMB`,
    `PICKUP_WEAPON_STONE_HATCHET`,
    `PICKUP_WEAPON_STUNGUN`,
    `PICKUP_WEAPON_SWITCHBLADE`,
    `PICKUP_WEAPON_VINTAGEPISTOL`,
    `PICKUP_WEAPON_NAVYREVOLVER`,
    `PICKUP_WEAPON_CERAMICPISTOL`,
    `PICKUP_WEAPON_WRENCH`
}

CreateThread(function()
    for _, hash in pairs(disabledPickups) do
        ToggleUsePickupsForPlayer(PlayerId(), hash, false)
    end
end)