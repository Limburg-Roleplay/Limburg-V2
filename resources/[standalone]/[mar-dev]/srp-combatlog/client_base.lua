local health = GetEntityHealth(PlayerPedId())
local timer = false
local ingame = false

AddEventHandler("playerSpawned", function()
    health = GetEntityHealth(PlayerPedId())
end)

TrackedEntities = {}

RegisterNetEvent('karneschoten:idle')
AddEventHandler('karneschoten:idle', function(bool)
    if bool then 
        ingame = true
    else
        ingame = false
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1000)  -- update every second.
        TrackEntityHealth()
    end
end)

function TrackEntityHealth()
    entities = GetActivePlayers()
    for k, v in ipairs(GetGamePool('CPed')) do
        table.insert(entities, v)
    end
    for i, ent in ipairs(entities) do
        if IsEntityAPed(ent) then
            TrackedEntities[ent] = {h = GetEntityHealth(ent)}
        end
    end
    for i, ent in ipairs(TrackedEntities) do
        if entities[ent] == nil and TrackedEntities[ent] then
            table.remove(TrackedEntities, IndexOf(TrackedEntities, ent))
        end
    end
end

function CalculateHealthLost(ent)
    local health = 0
    if IsEntityAPed(ent) then
        health = TrackedEntities[ent].h - GetEntityHealth(ent)
        TrackedEntities[ent].h = GetEntityHealth(ent)
    else
        health = 0
    end
    return health
end

function WalkMenuStart(name)
    RequestWalking(name)
    SetPedMovementClipset(PlayerPedId(), name, 0.2)
    RemoveAnimSet(name)
end

function RequestWalking(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        Citizen.Wait(1)
    end
end

RegisterNetEvent('combatlog:timer')
AddEventHandler('combatlog:timer', function(ped)
    if not timer then
        timer = true
        Citizen.Wait(300000)
        timer = false
        ResetPedMovementClipset(ped)
        LocalPlayer.state.blockWalks = false
    end
end)

AddEventHandler("esx_ambulancejob:Combatlog", function()
    stscombatlogcache = {}
    addCustomDamage({ weapon = "Dood ingelogt" })
end)

function addCustomDamage(customData)
    local data = {}
    
    data.distance = data.distance or 0
    data.victimId = customData.victimId or GetPlayerServerId(PlayerId())
    data.attackerId = customData.attackerId or GetPlayerServerId(PlayerId())
    data.bone = customData.bone or "Onbekend"
    data.weapon = customData.weapon or "Onbekend"
    data.health = customData.health or 0
    data.newHealth = customData.newHealth or 0
    data.speedAttacker = customData.speedAttacker or 0
    data.speedVictim = customData.speedVictim or 0
    data.skipFall = true

    addcombatcache(data, GetGameTimer())
end

exports("addCustomCombatlog", function(data)
    addCustomDamage(data, GetGameTimer())
end)

RegisterNetEvent("gameEventTriggered")
AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkEntityDamage" then
        local entity, destroyer, _, isFatal, weapon_old, weapon_old2, weapon = table.unpack(args)
        local PlayerPedId = PlayerPedId()

        local hit, bone = GetPedLastDamageBone(entity)
        local data = {}

        if destroyer == PlayerPedId then
            local isped = IsEntityAPed(entity)
            if isped == false then
                return
            end
            if weapon == 0 or weapon == 1 then
                weapon = weapon
            end
            local player = NetworkGetPlayerIndexFromPed(entity)
            local damage = CalculateHealthLost(entity)
            local dead = damage >= 100
            local newHealth = GetEntityHealth(entity)
            if dead then
                newHealth = 0.0
            end
            local temphealth = newHealth - math.floor(-damage)
            if not player or player <= 0 then
                player = PlayerId()
                data.distance = 0
            else
                data.distance = #(GetEntityCoords(PlayerPedId) - GetEntityCoords(entity))
            end
            local attacker = GetPlayerName(PlayerId())
            local victim = GetPlayerName(player)
            data.victimId = GetPlayerServerId(player)
            data.attackerId = GetPlayerServerId(PlayerId())
            data.bone = GetPedBoneLabelOrName(bone)
            data.weapon = tostring(Weapons[weapon] or weapon)
            data.health = temphealth
            data.newHealth = newHealth
            data.speedAttacker = GetPedSpeed(PlayerPedId)
            data.speedVictim = GetPedSpeed(entity)
            addcombatcache(data, GetGameTimer())
            if not ingame then
                if IsPedArmed(PlayerPedId, 4) and damage > 5 then
                    TriggerServerEvent('karnemelk:shooting', GetPlayerServerId(PlayerId()))
                end
            end
        end

        if entity == PlayerPedId then
            local newHealth = GetEntityHealth(entity)
            if newHealth ~= health then
                if weapon == 0 or weapon == 1 then
                    weapon = weapon
                end
                local player = NetworkGetPlayerIndexFromPed(destroyer)
                if not player or player <= 0 then
                    player = PlayerId()
                    data.distance = 0
                else
                    data.distance = #(GetEntityCoords(PlayerPedId) - GetEntityCoords(destroyer))
                end
                local syncserver = false
                if (Config.headshotinstakill or Config.syncheadshotkill) and weapon and Config.instaHeadshotWapens[weapon] and newHealth > 50.0 and not ingame then
                    if Config.killBones[bone] then
                        local data = Config.killBones[bone]
                        local rand = math.random()
                        if rand <= data.chance then
                            newHealth = 0.0
                            if Config.headshotinstakill then 
                                SetEntityHealth(PlayerPedId, 0.0)
                            end
                            if Config.syncheadshotkill then
                                newHealth = 0.0
                                syncserver = true
                            end
                        end
                    end
                end

                if hit then
                    if RagdollBones[bone] then
                        LocalPlayer.state.blockEmotes = true
                        local dmg = health - newHealth
                        if dmg >= Config.ragdollmindamage or GetPedArmour(PlayerPedId) > 0 then
                            if RagdollWeapons[weapon] then
                                local time = math.random(Config.rifleragdollmin, Config.rifleragdollmax)
                                if dmg >= 17 then
                                    local timer = time + 2
                                    SetPedToRagdoll(PlayerPedId, timer, timer, 0, 0, 0, 0)
                                    --SetPedToRagdollWithFall(PlayerPedId, timer, timer, 1, GetEntityForwardVector(entity))
                                    WalkMenuStart("move_m@injured")
                                    TriggerEvent('combatlog:timer', PlayerPedId)
                                    if not exports["Airsoft"]:isInAirsoft() then
                                        TriggerEvent('ox_inventory:disarm', true)
                                    end
                                    LocalPlayer.state.blockWalks = true
                                else
                                    SetPedToRagdoll(PlayerPedId, timer, timer, 0, 0, 0, 0)
                                    --SetPedToRagdollWithFall(PlayerPedId, time, time, 0, GetEntityForwardVector(entity))
                                    WalkMenuStart("move_m@injured")
                                    TriggerEvent('combatlog:timer', PlayerPedId)
                                    if not exports["Airsoft"]:isInAirsoft() then
                                        TriggerEvent('ox_inventory:disarm', true)
                                    end
                                    LocalPlayer.state.blockWalks = true
                                end
                            else
                                local time = math.random(Config.pistolragdollmin, Config.pistolragdollmax)
                                if dmg >= 17 then
                                    local timer = time + 2
                                    SetPedToRagdoll(PlayerPedId, timer, timer, 0, 0, 0, 0)
                                    --SetPedToRagdollWithFall(PlayerPedId, timer, timer, 1, GetEntityForwardVector(entity))
                                    WalkMenuStart("move_m@injured")
                                    TriggerEvent('combatlog:timer', PlayerPedId)
                                    if not exports["Airsoft"]:isInAirsoft() then
                                        TriggerEvent('ox_inventory:disarm', true)
                                    end
                                    LocalPlayer.state.blockWalks = true
                                else
                                    SetPedToRagdoll(PlayerPedId, timer, timer, 0, 0, 0, 0)
                                    --SetPedToRagdollWithFall(PlayerPedId, time, time, 0, GetEntityForwardVector(entity))
                                    WalkMenuStart("move_m@injured")
                                    TriggerEvent('combatlog:timer', PlayerPedId)
                                    if not exports["Airsoft"]:isInAirsoft() then
                                        TriggerEvent('ox_inventory:disarm', true)
                                    end
                                    LocalPlayer.state.blockWalks = true
                                end
                            end
                        end
                        SetTimeout(5000, function()
                            LocalPlayer.state.blockEmotes = false
                        end)
                    end
                end

                ---@type CombatlogData
                data.victimId = GetPlayerServerId(PlayerId())
                data.attackerId = GetPlayerServerId(player)
                data.bone = GetPedBoneLabelOrName(bone)
                data.weapon = tostring(Weapons[weapon] or weapon)
                data.health = health
                data.newHealth = newHealth
                data.speedAttacker = GetPedSpeed(destroyer)
                data.speedVictim = GetPedSpeed(PlayerPedId)
                if syncserver then
                    TriggerServerEvent("sts:syncinstakill", data.attackerId, data)
                end
                addcombatcache(data, GetGameTimer())

                health = newHealth
            end
        end
    end
end)

function GetPedSpeed(ped, vehicle)
    vehicle = vehicle or GetVehiclePedIsIn(ped)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then
        return GetEntitySpeed(vehicle)
    else
        return GetEntitySpeed(ped)
    end
end

function GetPedBoneLabelOrName(bone)
    if Bones[bone] then
        return Bones[bone].label or Bones[bone].name
    end

    return bone
end

function GetPedBoneLabel(bone)
    if Bones[bone] then
        return Bones[bone].label
    end
end