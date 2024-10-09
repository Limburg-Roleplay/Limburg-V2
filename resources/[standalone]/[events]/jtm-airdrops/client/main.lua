ESX = exports['es_extended']:getSharedObject()

local crateID = nil
local planeID = nil
local CrateObject = 0
local PlaneObject = 0
local isOpening = false

RegisterNetEvent('jtm_randomcrate:PlaneDrop')
AddEventHandler('jtm_randomcrate:PlaneDrop', function(id)
	planeID = id
	
	if planeID ~= nil then
		
		local planecoords = vector3(planeID.x, planeID.y, planeID.z)
		local planecrash = math.random(#Config.Planes)

		while planeID ~= nil do
			local idle = 500
			local playerPed = PlayerPedId()
			local pedCoords = GetEntityCoords(playerPed)
			local dist2 = #(pedCoords - planecoords)


			if dist2 < 500.0 then
				if not DoesEntityExist(PlaneObject) then
					PlaneObject = CreateObject(Config.Planes[planecrash], planeID.x, planeID.y, planeID.z)
					PlaceObjectOnGroundProperly(PlaneObject)
					Citizen.Wait(1000)
					FreezeEntityPosition(PlaneObject, true)
				end				
			else
				if DoesEntityExist(PlaneObject) then
					ESX.Game.DeleteObject(PlaneObject)
					PlaneObject = 0
					end
				end
				Citizen.Wait(idle)
			end
		end
end)

RegisterNetEvent('jtm_randomcrate:StartDropCrate')
AddEventHandler('jtm_randomcrate:StartDropCrate', function(id)
    if Config.SoundAlert then
        SendNUIMessage({transactionType = 'playSound'})
    end

    crateID = id
    CreateCrateBlip(crateID)

    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(crateID.x, crateID.y, crateID.z, currentStreetHash, intersectStreetHash)
    local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)

    lib.notify({
        id = 'crate_drop',
        title = 'A I R D R O P',
        description = "Er is een vliegtuig gecrashed met leuke items bekijk je map voor de locatie!",
        duration = 10000,
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'exclamation',
        iconColor = '#C53030'
    })

    if crateID ~= nil then
        local cratecoords = vector3(crateID.x, crateID.y, crateID.z)
        local randcrates = math.random(#Config.Crates)

        while crateID ~= nil do
            local idle = 500
            local playerPed = PlayerPedId()
            local pedCoords = GetEntityCoords(playerPed)
            local dist = #(pedCoords - cratecoords)

            if dist < 200.0 then
                if not DoesEntityExist(CrateObject) then
                    CrateObject = CreateObject(Config.Crates[randcrates], crateID.x, crateID.y, crateID.z, false, false, false)
                    PlaceObjectOnGroundProperly(CrateObject)
                    Citizen.Wait(1000)
                    FreezeEntityPosition(CrateObject, true)
                    local objectId = NetworkGetNetworkIdFromEntity(CrateObject)
                    DecorSetBool(objectId, "CrateObject", true)
                end

                if dist < 3.0 and DoesEntityExist(CrateObject) and not isOpening then
                    idle = 1
                    local objCoords = GetEntityCoords(CrateObject)
                    Draw3DText(objCoords.x, objCoords.y, objCoords.z, '[~b~E~w~] Open Crate')

                    if IsControlJustReleased(0, 38) then
                        isOpening = true
                        local isProgSuccess = lib.progressCircle({
                            duration = 45000,
                            position = 'bottom',
                            label = "Airdrop aan het openen...",
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                move = true,
                                car = true,
                                combat = true,
                            },
                            anim = {
                                dict = 'mini@repair',
                                clip = 'fixing_a_player',
                                flags = 49,
                            }
                        }) 
                        
                        if isProgSuccess then
                            isOpening = false
                            RemoveCrateBlip()
                            TriggerServerEvent('jtm_randomcrate:PickUpCrate', crateID)
                            ClearPedTasksImmediately(PlayerPedId())
                        else
                            isOpening = false
                            exports["frp-notifications"]:Notify("error", "Je bent gestopt met de airdrop te openen!", 4000)
                        end
                    end
                end
            else
                if DoesEntityExist(CrateObject) then
                    DeleteEntity(CrateObject)
                    CrateObject = nil
                end
            end

            Citizen.Wait(idle)
        end
    end
end)


local CrateBlip = nil
local CrateBlip2 = nil

function RemoveCrateBlip()
    if DoesBlipExist(CrateBlip) and DoesBlipExist(CrateBlip2)then
        RemoveBlip(CrateBlip)
		RemoveBlip(CrateBlip2)
    end
end

function CreateCrateBlip(BUGOKAHAH)
    RemoveCrateBlip()
	CrateBlip2 = AddBlipForRadius(BUGOKAHAH.x, BUGOKAHAH.y, BUGOKAHAH.z, 100.0) -- You can use a higher number for a bigger zone

	SetBlipHighDetail(CrateBlip2, true)
	SetBlipColour(CrateBlip2, 1)
	SetBlipAlpha (CrateBlip2, 128)

    CrateBlip = AddBlipForCoord(BUGOKAHAH.x, BUGOKAHAH.y, BUGOKAHAH.z)
    SetBlipSprite(CrateBlip, 94)
    SetBlipScale(CrateBlip, 1.0)
    SetBlipAsShortRange(CrateBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Airdrop Zone")
    EndTextCommandSetBlipName(CrateBlip)
end

RegisterNetEvent('jtm_randomcrate:ResetCrate')
AddEventHandler('jtm_randomcrate:ResetCrate', function(id)

  	if crateID ~= nil then
    	RemovedCrateObject()
	end

	if planeID ~= nil then
		RemovedPlaneObject()
	end

	StopParticleFxLooped(smoke)
  	crateID = nil
  	planeID = nil
	
	RemoveCrateBlip()
end)

function RemovedCrateObject()
	if DoesEntityExist(CrateObject) then
		DeleteEntity(CrateObject)
		CrateObject = 0
	end
end

function RemovedPlaneObject()
	if DoesEntityExist(PlaneObject) then
		DeleteEntity(PlaneObject)
		PlaneObject = 0
	end
end

RegisterNetEvent('jtm_randomcrate:AddExplosion')
AddEventHandler('jtm_randomcrate:AddExplosion', function()
	AddExplosion(crateID.x, crateID.y, crateID.z + 1.00, 40, 0.00, true, false, 1.00)		
end)

RegisterNetEvent('jtm_randomcrate:smoke')
AddEventHandler('jtm_randomcrate:smoke', function()
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	crateActive = true
	SetPtfxAssetNextCall("core")
	smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", crateID.x, crateID.y, crateID.z + 1.7, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
	SetParticleFxLoopedAlpha(smoke, 0.8)
	SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
    Citizen.Wait(1500 * 1000)
    StopParticleFxLooped(smoke, 0)
	crateActive = false
end)

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end