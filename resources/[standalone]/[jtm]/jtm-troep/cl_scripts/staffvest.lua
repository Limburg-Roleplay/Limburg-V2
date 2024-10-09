local groupArmorTypes = {
    ["owner"] = 0,
    ["hogerop"] = 1,
    ["staff"] = 2
}
function hasSpecificBodyArmor(playerPed, expectedDrawableId, expectedTextureId)
    local currentDrawableId = GetPedDrawableVariation(playerPed, 9)
    local currentTextureId = GetPedTextureVariation(playerPed, 9)

    return currentDrawableId == expectedDrawableId and currentTextureId == expectedTextureId
end
RegisterNetEvent("xadmin:staffvest")
AddEventHandler("xadmin:staffvest", function(playerGroup)
    local armorType = groupArmorTypes[playerGroup]
    local playerPed = PlayerPedId()
    if not armorType then return end
	local expectedDrawableId = 2
    if armorType and not hasSpecificBodyArmor(playerPed, expectedDrawableId, armorType) then
        local playerPed = PlayerPedId()
       	SetPedComponentVariation(playerPed, 9, 2, armorType, 0)
    else
        SetPedComponentVariation(playerPed, 9, 0, 0, 0)
    end
end)