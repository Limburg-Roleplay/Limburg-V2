-- JTM-DEVELOPMENT UITLEG GANGJOB--



Om stashes aan te maken of ze werkend te laten krijgen moet je het volgende doen!


add the next lines to ox_inventory/data/stashes.lua:

-- je doet het als volgt je kopieert dit en vanderd de id dus bijvoorbeeld tmf_stash naar je gangnaam bijvoorbeeld reznikov naar reznikov_stash --

local stashes = {
    {
        id = 'tmf_stash',
        label = 'TMF Stash',
        slots = 100,
        weight = 100000,
        owner = false,
    },
    {
        id = 'crips_stash',
        label = 'Crips Stash',
        slots = 100,
        weight = 100000,
        owner = false,
    },
    -- Add more stashes here as needed
}

-- Register each stash when the resource starts
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        -- Iterate through each stash in the table and register it
        for _, stash in ipairs(stashes) do
            exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
        end
    end
end)


Om de shops werkend te krijgen moet je het volgende doen!

Daar kan je ook de wapens etc wat gangs mogen inkopen zetten!

add the next lines to ox_inventory/data/shops.lua:

    gangshop = {
        name = 'Gang Inkoop Wapens',
        inventory = {
                                 -- Grote Wapens -- 
            { name = 'WEAPON_REMINGTON680', price = 775000, metadata = { registered = true }, },

                                 -- MiddelGrote Wapens -- 
            { name = 'WEAPON_UMP45', price = 650000, metadata = { registered = true }, },
            { name = 'WEAPON_UZI', price = 520000, metadata = { registered = true }, },
            { name = 'WEAPON_MAC11', price = 490000, metadata = { registered = true }, },

                                 -- Kleine Wapens --             
            { name = 'WEAPON_M1911', price = 420000, metadata = { registered = true }, },
            { name = 'WEAPON_MEOS45', price = 400000, metadata = { registered = true }, },
            { name = 'WEAPON_SMITHWESSON', price = 340000, metadata = { registered = true }, },

                                 -- Slag Wapens --                         
			{ name = 'WEAPON_SwitchBlade', price = 70000 },
			{ name = 'WEAPON_Bayonet', price = 55000 },
			{ name = 'WEAPON_WIREBAT', price = 50000 },
			{ name = 'WEAPON_KATANA', price = 45000 },
			{ name = 'WEAPON_TRI-DAGGER', price = 50000 },
        }
	},

    gangshopammo = {
        name = 'Gang Ammo Inkoop',
        inventory = {
                                 -- Ammo -- 
			{ name = 'ammo-9', price = 175, },
            { name = 'ammo-45', price = 200, },
            { name = 'ammo-shotgun', price = 550, },
            { name = 'ammo-rifle', price = 650, },

        }
	},

    extra = {
        name = 'Gang Extra Inkoop',
        inventory = {
                                 -- Zooi -- 
            { name = 'phone', price = 750, metadata = { registered = false }, },
            { name = 'radio', price = 500, metadata = { registered = false }, },
            { name = 'handcuffs', price = 1250, metadata = { registered = false }, },

        }
	},

    gangshopattachmentsak47 = {
        name = 'Gang AK-47 Attachments Inkoop',
        inventory = {

            { name = 'at_ak47_scope_1', price = 50000, metadata = { registered = true }, },
            { name = 'at_ak47_suppressor', price = 70000, metadata = { registered = true }, },
         	{ name = 'w_ar_ak47_luxe', price = 25000, metadata = { registered = true }, },        
         	{ name = 'at_ak47_camo_silver', price = 25000, metadata = { registered = true }, },
            { name = 'at_ak47_camo_redtiger', price = 25000, metadata = { registered = true }, },
            { name = 'at_ak47_camo_roze', price = 25000, metadata = { registered = true }, },
            { name = 'at_ak47_flashlight', price = 30000, metadata = { registered = true }, },
            { name = 'at_ak47_grip', price = 50000, metadata = { registered = true }, },
            { name = 'at_ak47_clip_extended', price = 50000, metadata = { registered = true }, },
            { name = 'at_ak47_clip_drummag', price = 60000, metadata = { registered = true }, },

        }
	},

    gangshopattachmentsak47u = {
        name = 'Gang AK-47U Attachments Inkoop',
        inventory = {

            { name = 'at_ak47u_clip_extended', price = 40000, metadata = { registered = true }, },

        }
	},

    gangshopattachmentsump45 = {
        name = 'Gang UMP-45 Attachments Inkoop',
        inventory = {

            { name = 'at_ump45_scope_1', price = 50000, metadata = { registered = true }, },
            { name = 'at_ump45_suppressor', price = 50000, metadata = { registered = true }, },
            { name = 'at_ump45_flashlight', price = 30000, metadata = { registered = true }, },
            { name = 'at_ump45_grip', price = 35000, metadata = { registered = true }, },
         	{ name = 'at_ump45_camo_redtiger', price = 25000, metadata = { registered = true }, },
            { name = 'at_ump45_clip_extended', price = 45000, metadata = { registered = true }, },

        }
	},

    gangshopattachmentsuzi = {
        name = 'Gang UZI Attachments Inkoop',
        inventory = {

            { name = 'at_uzi_scope_3', price = 50000, metadata = { registered = true }, },
            { name = 'at_uzi_scope_4', price = 50000, metadata = { registered = true }, },
            { name = 'at_uzi_scope_5', price = 50000, metadata = { registered = true }, },
            { name = 'at_uzi_scope_6', price = 50000, metadata = { registered = true }, },
            { name = 'at_uzi_suppressor_1', price = 50000, metadata = { registered = true }, },
            { name = 'at_uzi_suppressor_2', price = 50000, metadata = { registered = true }, },
            { name = 'at_uzi_stock_1', price = 30000, metadata = { registered = true }, },
            { name = 'at_uzi_stock_2', price = 30000, metadata = { registered = true }, },
            { name = 'at_uzi_clip_extended_2', price = 40000, metadata = { registered = true }, },
            { name = 'at_uzi_clip_extended_3', price = 50000, metadata = { registered = true }, },

        }
	},

    gangshopattachmentsmac11 = {
        name = 'Gang MAC-11 Attachments Inkoop',
        inventory = {

            { name = 'at_mac11_suppressor', price = 50000, metadata = { registered = true }, },
            { name = 'at_mac11_clip_extended', price = 40000, metadata = { registered = true }, },

        }
	},

    gangshopattachmentsm1911 = {
        name = 'Gang M1911 Attachments Inkoop',
        inventory = {

            { name = 'at_m1911_suppressor', price = 40000, metadata = { registered = true }, },
         	{ name = 'at_m1911_flashlight', price = 20000, metadata = { registered = true }, },
            { name = 'at_m1911_clip_extended', price = 35000, metadata = { registered = true }, },

        }
	},

    gangshopattachmentsmeos45 = {
        name = 'Gang MEOS-45 Attachments Inkoop',
        inventory = {

            { name = 'at_meos45_clip_extended', price = 35000, metadata = { registered = true }, },
            { name = 'at_meos45_flashlight', price = 20000, metadata = { registered = true }, },
            { name = 'at_meos45_suppressor', price = 50000, metadata = { registered = true }, },

        }
	},

    gangshopattachmentssmithwesson = {
        name = 'Gang Smith Wesson Attachments Inkoop',
        inventory = {

            { name = 'at_smithwesson_suppressor', price = 45000, metadata = { registered = true }, },
            { name = 'at_smithwesson_clip_extended', price = 30000, metadata = { registered = true }, },
            { name = 'at_smithwesson_flashlight', price = 20000, metadata = { registered = true }, },

        }
	},
