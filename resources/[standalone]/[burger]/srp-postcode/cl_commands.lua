-- optimizations
local ipairs = ipairs
local upper = string.upper
local format = string.format
-- end optimizations

---
--- [[ Nearest Postal Commands ]] ---
---

TriggerEvent('chat:addSuggestion', '/postcode', 'Zet jouw navigatie op een postcode.',
             { { name = 'Postcode', help = 'De postcode waar je heen wilt' } })

RegisterCommand('postcode', function(_, args)
    if #args < 1 then
        if pBlip then
            RemoveBlip(pBlip.hndl)
            pBlip = nil
            exports['okokNotify']:Alert('Navigatie', 'Route verwijderd', 3000, 'info')
        end
        return
    end

    local userPostal = upper(args[1])
    local foundPostal

    for _, p in ipairs(postals) do
        if upper(p.code) == userPostal then
            foundPostal = p
            break
        end
    end

    if foundPostal then
        if pBlip then RemoveBlip(pBlip.hndl) end
        local blip = AddBlipForCoord(foundPostal[1][1], foundPostal[1][2], 0.0)
        pBlip = { hndl = blip, p = foundPostal }
        SetBlipRoute(blip, true)
        SetBlipSprite(blip, config.blip.sprite)
        SetBlipColour(blip, config.blip.color)
        SetBlipRouteColour(blip, config.blip.color)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(format(config.blip.blipText, pBlip.p.code))
        EndTextCommandSetBlipName(blip)

        exports['okokNotify']:Alert('Navigatie', 'Je hebt jouw navigatie ingesteld naar postcode '..foundPostal.code, 3000, 'info')
    else
        exports['okokNotify']:Alert('Navigatie', 'De postcode '..userPostal..' kan niet gevonden worden.', 3000, 'error')
    end
end)

