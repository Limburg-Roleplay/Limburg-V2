local WeaponsNotLogged = {
    "WEAPON_SNOWBALL",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN"
}

CreateThread(function()
    Wait(1000)
    local currWeapon = 0
    local fireWeapon = nil
    local timeout = 0
    local fireCount = 0
    while true do
        Wait(0)
        local playerped = GetPlayerPed(PlayerId())
        if IsPedShooting(playerped) then
            fireWeapon = GetSelectedPedWeapon(playerped)
            fireCount = fireCount + 1
            timeout = 1000
        elseif not IsPedShooting(playerped) and fireCount ~= 0 and timeout ~= 0 then
            if timeout ~= 0 then
                timeout = timeout - 1
            end
            if fireWeapon ~= GetSelectedPedWeapon(playerped) then
                timeout = 0
            end
            if fireCount ~= 0 and timeout == 0 then
                isLoggedWeapon = true
                for k,v in pairs(WeaponsNotLogged) do
                    if fireWeapon == GetHashKey(v) then
                        isLoggedWeapon = false
                    end
                end
                if isLoggedWeapon then
                    TriggerServerEvent('frp-logger:schotenGelost', Weapons.WeaponNames[tostring(fireWeapon)], fireCount)
                end
                fireCount = 0
            end
        end
    end
end)