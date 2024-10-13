local curWeapon = nil
local ox_inventory = exports.ox_inventory
local ped = cache.ped
local playerLoaded = false
local Weapons = {
    -- Grote wapens --
    [`WEAPON_AK74_1`] = {item = 'WEAPON_AK74_1', rot = vector3(180,180,0)},
    [`WEAPON_NVRIFLE`] = {item = 'WEAPON_NVRIFLE', rot = vector3(180,180,0)},
    [`WEAPON_MCXRATTLER`] = {item = 'WEAPON_MCXRATTLER', rot = vector3(180,180,0)},
    [`WEAPON_FM1_HK416`] = {item = 'WEAPON_FM1_HK416', rot = vector3(180,180,0)},
    [`WEAPON_FM2_HK416`] = {item = 'WEAPON_FM2_HK416', rot = vector3(180,180,0)},
    [`WEAPON_MB47`] = {item = 'WEAPON_MB47', rot = vector3(180,180,0)},

    -- Kleinere wapens --
    [`WEAPON_MP5`] = {item = 'WEAPON_MP5', rot = vector3(180,180,0)},
    [`WEAPON_AKS74U`] = {item = 'WEAPON_AKS74U', rot = vector3(180,180,0)},
    [`WEAPON_HKUMP`] = {item = 'WEAPON_HKUMP', rot = vector3(180,180,0)},
    [`WEAPON_AGC`] = {item = 'WEAPON_AGC', rot = vector3(180,180,0)},

    -- Shotguns --
    [`WEAPON_REMINGTON`] = {item = 'WEAPON_REMINGTON', rot = vector3(180,180,0)},
    [`WEAPON_SAWNOFFSHOTGUN`] = {item = 'WEAPON_SAWNOFFSHOTGUN', rot = vector3(180,180,0)},
    [`WEAPON_BENELLIM4`] = {item = 'WEAPON_BENELLIM4', rot = vector3(180,180,0)},
    [`WEAPON_DOUBLEBARRELFM`] = {item = 'WEAPON_DOUBLEBARRELFM', rot = vector3(180,180,0)},

    -- Laatste wapen [NIET AANZITTEN!] --
    [`WEAPON_BAT`] = {item = 'WEAPON_BAT', rot = vector3(0,92.5,0)}
}


local slots = {
    [1] = {
        pos = vec3(0.13, -0.19, -0.04), -- Center Of Back
        entity = nil,
        hash = nil,
        wep = nil
    },
    [2] = {
        pos = vec3(0.13, -0.15, -0.16), -- Center-Right
        entity = nil,
        hash = nil,
        wep = nil
    },
    [3] = {
        pos = vec3(0.13, -0.15, 0.07), -- Center-Left
        entity = nil,
        hash = nil,
        wep = nil
    },
}

local entitieswhitelisted = {}

local function applyWeaponComponents(weaponObject, weaponHash)
    local components = {
        `COMPONENT_AT_PI_SUPP`,
        `COMPONENT_AT_PI_SUPP_02`,
        `COMPONENT_CERAMICPISTOL_SUPP`,
        `COMPONENT_PISTOLXM3_SUPP`,
        `COMPONENT_FMSCOPE_01`,
        `COMPONENT_FMSCOPE_13`,
        `COMPONENT_FMSCOPE_12`,
        `COMPONENT_FMSCOPE_15`,
        `COMPONENT_FMSCOPE_17`,
        `COMPONENT_FMSCOPE_18`,
        `COMPONENT_FMSCOPE_23`,
        `COMPONENT_FMSCOPE_38`,
        `COMPONENT_FMFLSH_08`,
        `COMPONENT_FMGRIP_03`,
        `COMPONENT_FMGRIP_09`,
        `COMPONENT_FMSUPP_04`,
        `COMPONENT_FMSUPP_18`,
        `COMPONENT_FMSUPP_23`,
        `COMPONENT_FMSUPP_20`,
        `COMPONENT_FMSTOCK_29`,
        `COMPONENT_FMSTOCK_09`,
        `COMPONENT_FMSTOCK_24`,
        `COMPONENT_FMCLIP_10`,
        `COMPONENT_FMCLIP_08`,
        `COMPONENT_FMCLIP_05`,
        `COMPONENT_FMCLIP_02`,
        `COMPONENT_AT_AR_SUPP`,
        `COMPONENT_AT_AR_SUPP_02`,
        `COMPONENT_AT_SR_SUPP`,
        `COMPONENT_AT_SR_SUPP_03`,
        `COMPONENT_APPISTOL_CLIP_02`,
        `COMPONENT_CERAMICPISTOL_CLIP_02`,
        `COMPONENT_COMBATPISTOL_CLIP_02`,
        `COMPONENT_HEAVYPISTOL_CLIP_02`,
        `COMPONENT_PISTOL_CLIP_02`,
        `COMPONENT_PISTOL_MK2_CLIP_02`,
        `COMPONENT_PISTOL50_CLIP_02`,
        `COMPONENT_SNSPISTOL_CLIP_02`,
        `COMPONENT_SNSPISTOL_MK2_CLIP_02`,
        `COMPONENT_VINTAGEPISTOL_CLIP_02`,
        `COMPONENT_TECPISTOL_CLIP_02`,
        `COMPONENT_ASSAULTSMG_CLIP_02`,
        `COMPONENT_COMBATPDW_CLIP_02`,
        `COMPONENT_MACHINEPISTOL_CLIP_02`,
        `COMPONENT_MICROSMG_CLIP_02`,
        `COMPONENT_MINISMG_CLIP_02`,
        `COMPONENT_SMG_CLIP_02`,
        `COMPONENT_SMG_MK2_CLIP_02`,
        `COMPONENT_GLOCK19x_FLSH_01`,
        `COMPONENT_GLOCK19X_SUPP`,
        `COMPONENT_GLOCK19X_CLIP_02`,
        `COMPONENT_AT_SCOPE_MACRO`,
        `COMPONENT_AT_SCOPE_MACRO_02`,
        `COMPONENT_AT_SCOPE_MACRO_MK2`,
        `COMPONENT_AT_SCOPE_MACRO_02_MK2`,
        `COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2`,
        `w_at_mp5_scope`,
        `w_at_mp5_supp`,
        `COMPONENT_SIG_SCOPE_02`,
        `COMPONENT_SIG_CLIP_02`,
        `COMPONENT_SIG_SUPP_01`,
        `COMPONENT_FM1_M9A3_CLIP_02`,
        `COMPONENT_FMSUPP_10`,
        `COMPONENT_FMSCOPE_30`,
        `COMPONENT_MARKOMODS_SHARED_SCOPE_01`,
        `COMPONENT_MARKOMODS_SHARED_SCOPE_08`,
        `COMPONENT_MARKOMODS_SHARED_SUPP_12`,
        `w_at_sg_benellim4_supp`,
        `COMPONENT_MARKOMODSUZI_SCOPE_06`,
        `COMPONENT_MARKOMODSUZI_STOCK_02`,
        `COMPONENT_MARKOMODSUZI_CLIP_04`,
        `COMPONENT_MARKOMODSUZI_SUPP_02`,
        `COMPONENT_AKS74U_CLIP_09`,
        `COMPONENT_AKS74U_SCOPE_13`,
        `COMPONENT_AKS74U_FLSH_10`,
        `COMPONENT_AKS74U_MUZ_09`,
        `COMPONENT_UMP_SUPP_04`,
        `COMPONENT_UMP_SCOPE_03`,
        `COMPONENT_UMP_SCOPE_06`,
        `COMPONENT_UMP_GRIP_01`,
        `COMPONENT_UMP_FLSH_01`,
        `COMPONENT_UMP_CLIP_02`,
        `w_at_nvrifle_afgrip`,
        `w_ar_nvrifle_mag2`,
        `w_at_nvrifle_scope_small`,
        `w_at_nvrifle_supp`,
    }

    for _, component in pairs(components) do
        if HasPedGotWeaponComponent(ped, weaponHash, component) then
            GiveWeaponComponentToWeaponObject(weaponObject, component)
        end
    end
end

local function clearSlot(i)
    if slots[i] and slots[i].entity then
        if DoesEntityExist(slots[i].entity) then
            entitieswhitelisted[slots[i].entity] = nil
            DetachEntity(slots[i].entity)
            DeleteEntity(slots[i].entity)
        end
        slots[i].entity = nil
        slots[i].hash = nil
        slots[i].wep = nil
    end
end


local function removeFromSlot(hash)
    if Weapons[hash] == nil then return end
    local whatItem = Weapons[hash].item
    local count = ox_inventory:Search(2, whatItem)
    for i = 1, #slots do
        if slots[i].hash == hash then
            if not count or count <= 0 or hash == curWeapon then
                clearSlot(i)
            end
        end
    end
end

local function removeWeapon(hash)
    if Weapons[hash] then
        removeFromSlot(hash)
    end
end

local function removeFromInv(hash)
    removeFromSlot(hash)
end

local function checkForSlot(hash)
    for i = 1, #slots do
        if slots[i].hash == hash then return false end
    end
    for i = 1, #slots do
        local slot = slots[i]
        if not slot.entity then
            return i
        end
    end
    return false
end

exports('getEntities', function()
    return entitieswhitelisted
end)

local function putOnBack(hash)
    local whatSlot = checkForSlot(hash)
    local hasWhitelistedBag = exports['ox_inventory']:hasWhitelistedBag()
    if whatSlot and not hasWhitelistedBag then
        curWeapon = nil
        local item = Weapons[hash].item
        local weaponHash = hash
        local coords = GetEntityCoords(ped)

        local weaponObject = CreateWeaponObject(weaponHash, 1, coords.x, coords.y, coords.z, true, 1.0, 0)
        entitieswhitelisted[weaponObject] = true
        slots[whatSlot].entity = weaponObject
        slots[whatSlot].hash = hash
        slots[whatSlot].wep = item

        applyWeaponComponents(weaponObject, weaponHash)

        if item == 'WEAPON_BAT' then
            AttachEntityToEntity(weaponObject, ped, GetPedBoneIndex(ped, 24816), (slots[whatSlot].pos.x - 0.2), slots[whatSlot].pos.y, slots[whatSlot].pos.z, Weapons[hash].rot.x, Weapons[hash].rot.y, Weapons[hash].rot.z, true, true, false, true, 2, true)
        elseif item == 'WEAPON_AKS74U' then -- voor kleinere wapens
            AttachEntityToEntity(weaponObject, ped, GetPedBoneIndex(ped, 24816), (slots[whatSlot].pos.x + 0.12), slots[whatSlot].pos.y, slots[whatSlot].pos.z, Weapons[hash].rot.x, Weapons[hash].rot.y, Weapons[hash].rot.z, true, true, false, true, 2, true)
        else
            -- For other weapons
            AttachEntityToEntity(weaponObject, ped, GetPedBoneIndex(ped, 24816), slots[whatSlot].pos.x, slots[whatSlot].pos.y, slots[whatSlot].pos.z, Weapons[hash].rot.x, Weapons[hash].rot.y, Weapons[hash].rot.z, true, true, false, true, 2, true)
        end
    end
end

local function respawningCheckWeapon()
    for i = 1, #slots do
        local slot = slots[i]
        if slot.entity ~= nil then
            if DoesEntityExist(slot.entity) then
                DeleteEntity(slot.entity)
            end
            local whatItem = Weapons[slot.hash].item
            local count = ox_inventory:Search(2, whatItem)
            local oldHash = slot.hash
            slots[i].entity = nil
            slots[i].hash = nil
            if count > 0 then
                putOnBack(oldHash)
            end
        end
    end
end

AddEventHandler('ox_inventory:currentWeapon', function(data)
    if data then
        if Weapons[data.hash] then
            putOnBack(curWeapon)
            curWeapon = data.hash
            removeWeapon(data.hash)
        end
    else
        if curWeapon then
            putOnBack(curWeapon)
        end
    end
end)

RegisterNetEvent('lrp-loadingscreen:client:done')
AddEventHandler('lrp-loadingscreen:client:done', function()
    playerLoaded = true
end)


AddEventHandler('ox_inventory:updateInventory', function(changes)
    while not playerLoaded do Wait(0) end

    for k, v in pairs(changes) do
        if type(v) == 'table' then
            local hash = joaat(v.name)
            if Weapons[hash] then
                if curWeapon ~= hash then
                    putOnBack(hash)
                else
                    removeFromInv(hash)
                end
            end
        end
        if type(v) == 'boolean' then
            for i = 1, #slots do
                local count = ox_inventory:Search(2, slots[i].wep)
                if not count or count <= 0 then
                    removeFromInv(slots[i].hash)
                end
            end
        end
    end
end)

local Whitelist = 196

lib.onCache('vehicle', function(value)
    if value then
        for i = 1, #slots do
            clearSlot(i)
        end
        local ZoekHelmID = GetPedPropIndex(ped, 0) -- Zoekt het helm ID
        if ZoekHelmID ~= Whitelist then
            SetPedConfigFlag(ped, 438, true)
        else
            SetPedConfigFlag(ped, 438, false)
        end
    else
        if GetResourceState('ox_inventory') ~= 'started' or not playerLoaded then return end
        for k, v in pairs(Weapons) do
            local count = ox_inventory:Search(2, v.item)
            if count and count >= 1 then
                putOnBack(k)
            end
        end
        local ZoekHelmID = GetPedPropIndex(ped, 0) -- Zoekt het helm ID
        if ZoekHelmID ~= Whitelist then
            SetPedConfigFlag(ped, 438, true)
        else
            SetPedConfigFlag(ped, 438, false)
        end
    end
end)

lib.onCache('ped', function(value)
    ped = value
end)