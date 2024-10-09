local FRP = {['Functions'] = {}, ['Cache'] = {}}

RegisterNetEvent('frp-clothingmenu:cl:sync:outfits', function(data)
    FRP.Cache = data
end)

RegisterNetEvent('frp-clothingmenu:cl:sv:outfit', function()
    FRP.Functions.saveOutfit()
end)

RegisterNetEvent('frp-clothingmenu:cl:choose:outfit', function(args)
    local id = args.id
    local cachedId = FRP.Cache[id]

    lib.registerContext({
		id = 'frp-clothing:cl:choose:option',
		title = 'Kies een optie',
		menu = 'wardrobe_menu',
		options = {
			{
				title = string.format('Trek %s aan', cachedId.outfitname),
				event = 'frp-clothingmenu:cl:use:outfit',
				args = {id = args.id}

			},
			{
				title = string.format('Verwijder %s uit kledingkast', cachedId.outfitname),
				event = 'frp-clothingmenu:cl:del:outfit',
				args = {id = args.id}
			},
            {
				title = string.format('Update de outfit van %s', cachedId.outfitname),
				event = 'frp-clothingmenu:cl:upd:outfit',
				args = {id = args.id}
			},
		}
	})

	lib.showContext('frp-clothing:cl:choose:option')
end)

RegisterNetEvent('frp-clothingmenu:cl:upd:outfit', function(args)
    local id = args.id

    local appearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())

    FRP.Cache[id]['outfit'] = appearance

    TriggerServerEvent('frp-clothingmenu:srv:upd:outfit', id, appearance)

    ESX.ShowNotification('success', 'Jouw outfit ' .. FRP.Cache[id].outfitname .. ' is geupdated!')
end)

RegisterNetEvent('frp-clothingmenu:cl:del:outfit', function(args)
    local id = args.id 

    ESX.ShowNotification('error', 'Jouw outfit ' .. FRP.Cache[id].outfitname .. ' is verwijderd!')

    table.remove(FRP.Cache, tonumber(id))

    TriggerServerEvent('frp-clothingmenu:srv:del:outfit', tonumber(id))
end)

RegisterNetEvent('frp-clothingmenu:cl:use:outfit', function(args)
    local id = args.id
    local outfit = FRP.Cache[id].outfit
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

--exports['frp-clothingmenu']:openSavedOutfits()

exports('openSavedOutfits', function()
    FRP.Functions.openSavedOutfits()
end)

--[[FRP.Functions.openSavedOutfits = function()
    local options = {}

    if #FRP.Cache <= 0 then return FRP.Functions.saveOutfit() end

    print(ESX.DumpTable(FRP.Cache))

    for k,v in pairs(FRP.Cache) do
        options[k+1] = {
            ['title'] = v.outfitname,
            ['event'] = 'frp-clothingmenu:cl:choose:outfit',
            ['args'] = {id = k}
        }
    end

    print(ESX.DumpTable(options))

    options[1] = {
        ['title'] = 'Sla nieuwe outfit op.',
        ['event'] = 'frp-clothingmenu:cl:sv:outfit',
        ['args'] = {id = i}
    }

    lib.registerContext({
        id = 'frp-clothing:cl:menu',
        menu = 'see_outfits',
        title = 'Kies jouw outfit',
        options = options
    })

    lib.showContext('frp-clothing:cl:menu')
end--]]

FRP.Functions.getTotalOutfits = function()
    local count = 0

    if FRP.Cache then
        for k,v in pairs(FRP.Cache) do
            count = count + 1
        end
    end

    return count
end

FRP.Functions.openSavedOutfits = function()
    local options = {}
    local totalOutfits = FRP.Functions.getTotalOutfits()

    if totalOutfits <= 0 then return FRP.Functions.saveOutfit() end

    for k,v in pairs(FRP.Cache) do
        options[#options+1] = {
            ['title'] = tostring(v.outfitname),
            ['event'] = 'frp-clothingmenu:cl:choose:outfit',
            ['args'] = {id = k}
        }
    end

    table.sort(options, function(a, b)
        return a.title < b.title
    end)

    options[#options+1] = {
        ['title'] = 'Sla nieuwe outfit op.',
        ['event'] = 'frp-clothingmenu:cl:sv:outfit',
        ['args'] = {id = 1}
    }

    lib.registerContext({
        id = 'frp-clothing:cl:menu',
        menu = 'see_outfits',
        title = 'Kies jouw outfit',
        options = options
    })

    lib.showContext('frp-clothing:cl:menu')
end

FRP.Functions.saveOutfit = function()
    local name = lib.inputDialog('Nieuwe outfit', {'Geef jouw outfit een naam.'})

    if name then
        local appearance = exports['fivem-appearance']:getPedAppearance(PlayerPedId())

        FRP.Cache[#FRP.Cache+1] = {
            ['outfitname'] = name[1],
            ['outfit'] = appearance
        }

        TriggerServerEvent('frp-clothingmenu:srv:save:outfit', name[1], appearance)

        ESX.ShowNotification('success', 'Jouw outfit ' .. tostring(name[1]) .. ' is opgeslagen!')
    end
end