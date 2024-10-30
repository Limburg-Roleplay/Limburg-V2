local LRP = {['Functions'] = {}, ['Cache'] = {}}

RegisterNetEvent('lrp-clothingmenu:cl:sync:outfits', function(data)
    LRP.Cache = data
end)

RegisterNetEvent('lrp-clothingmenu:cl:sv:outfit', function()
    LRP.Functions.saveOutfit()
end)

RegisterNetEvent('lrp-clothingmenu:cl:choose:outfit', function(args)
    local id = args.id
    local cachedId = LRP.Cache[id]

    lib.registerContext({
		id = 'lrp-clothing:cl:choose:option',
		title = 'Kies een optie',
		menu = 'wardrobe_menu',
		options = {
			{
				title = string.format('Trek %s aan', cachedId.outfitname),
				event = 'lrp-clothingmenu:cl:use:outfit',
				args = {id = args.id}

			},
			{
				title = string.format('Verwijder %s uit kledingkast', cachedId.outfitname),
				event = 'lrp-clothingmenu:cl:del:outfit',
				args = {id = args.id}
			},
            {
				title = string.format('Update de outfit van %s', cachedId.outfitname),
				event = 'lrp-clothingmenu:cl:upd:outfit',
				args = {id = args.id}
			},
		}
	})

	lib.showContext('lrp-clothing:cl:choose:option')
end)

RegisterNetEvent('lrp-clothingmenu:cl:upd:outfit', function(args)
    local id = args.id

    local appearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())

    LRP.Cache[id]['outfit'] = appearance

    TriggerServerEvent('lrp-clothingmenu:srv:upd:outfit', id, appearance)

    ESX.ShowNotification('success', 'Jouw outfit ' .. LRP.Cache[id].outfitname .. ' is geupdated!')
end)

RegisterNetEvent('lrp-clothingmenu:cl:del:outfit', function(args)
    local id = args.id 

    ESX.ShowNotification('error', 'Jouw outfit ' .. LRP.Cache[id].outfitname .. ' is verwijderd!')

    table.remove(LRP.Cache, tonumber(id))

    TriggerServerEvent('lrp-clothingmenu:srv:del:outfit', tonumber(id))
end)

RegisterNetEvent('lrp-clothingmenu:cl:use:outfit', function(args)
    local id = args.id
    local outfit = LRP.Cache[id].outfit
    local appearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())

    -- reset whole faces etc
    outfit.model = appearance.model
    outfit.faceFeatures = appearance.faceFeatures
    outfit.headBlend = appearance.headBlend
    outfit.headOverlays = appearance.headOverlays
    outfit.hair = appearance.hair
    outfit.eyeColor = appearance.eyeColor

    if lib.progressCircle({
        duration = 3000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'missmic4',
            clip = 'michael_tux_fidget'
        },
    }) then
		local health = GetEntityHealth(PlayerPedId())
		exports['fivem-appearance']:setPlayerAppearance(outfit)

		TriggerServerEvent('esx_skin:save', outfit)

		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
		SetPedMaxHealth(PlayerPedId(), 200)
		SetEntityHealth(PlayerPedId(), health)
    end
end)

--exports['lrp-clothingmenu']:openSavedOutfits()

exports('openSavedOutfits', function()
    LRP.Functions.openSavedOutfits()
end)

--[[LRP.Functions.openSavedOutfits = function()
    local options = {}

    if #LRP.Cache <= 0 then return LRP.Functions.saveOutfit() end

    print(ESX.DumpTable(LRP.Cache))

    for k,v in pairs(LRP.Cache) do
        options[k+1] = {
            ['title'] = v.outfitname,
            ['event'] = 'lrp-clothingmenu:cl:choose:outfit',
            ['args'] = {id = k}
        }
    end

    print(ESX.DumpTable(options))

    options[1] = {
        ['title'] = 'Sla nieuwe outfit op.',
        ['event'] = 'lrp-clothingmenu:cl:sv:outfit',
        ['args'] = {id = i}
    }

    lib.registerContext({
        id = 'lrp-clothing:cl:menu',
        menu = 'see_outfits',
        title = 'Kies jouw outfit',
        options = options
    })

    lib.showContext('lrp-clothing:cl:menu')
end--]]

LRP.Functions.getTotalOutfits = function()
    local count = 0

    if LRP.Cache then
        for k,v in pairs(LRP.Cache) do
            count = count + 1
        end
    end

    return count
end

LRP.Functions.openSavedOutfits = function()
    local options = {}
    local totalOutfits = LRP.Functions.getTotalOutfits()

    if totalOutfits <= 0 then return LRP.Functions.saveOutfit() end

    for k,v in pairs(LRP.Cache) do
        options[#options+1] = {
            ['title'] = tostring(v.outfitname),
            ['event'] = 'lrp-clothingmenu:cl:choose:outfit',
            ['args'] = {id = k}
        }
    end

    table.sort(options, function(a, b)
        return a.title < b.title
    end)

    options[#options+1] = {
        ['title'] = 'Sla nieuwe outfit op.',
        ['event'] = 'lrp-clothingmenu:cl:sv:outfit',
        ['args'] = {id = 1}
    }

    lib.registerContext({
        id = 'lrp-clothing:cl:menu',
        menu = 'see_outfits',
        title = 'Kies jouw outfit',
        options = options
    })

    lib.showContext('lrp-clothing:cl:menu')
end

LRP.Functions.saveOutfit = function()
    local name = lib.inputDialog('Nieuwe outfit', {'Geef jouw outfit een naam.'})

    if name then
        local appearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())

        LRP.Cache[#LRP.Cache+1] = {
            ['outfitname'] = name[1],
            ['outfit'] = appearance
        }

        TriggerServerEvent('lrp-clothingmenu:srv:save:outfit', name[1], appearance)

        ESX.ShowNotification('success', 'Jouw outfit ' .. tostring(name[1]) .. ' is opgeslagen!')
    end
end