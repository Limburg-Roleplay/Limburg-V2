--[[
BY RX Scripts © rxscripts.xyz
--]]

Config = {}

Config.Locale = 'nl'
Config.DiscordWebhook = 'https://discord.com/api/webhooks/1298022465213038713/yMi4SHFMlURuAeQPFqWsPpduqNSl7acZW87GDSXsapySdpNMgfR2vtlRvQHd2zv4Gk5U'
Config.SaveInterval = 10 -- In Minutes
Config.DefaultRoutingBucket = 0
Config.UseMoney = 'bank' -- Money account used for payments
Config.PostMessageCooldown = 300 -- In Seconds, cooldown on sending post messages to a house
Config.MaxHouses = 5 -- Amount of houses a player can own
Config.SellReturn = 0.5 -- Percentage of the house price you get back when selling (0 - 1)
Config.LaptopProp = 'prop_laptop_01a' -- Prop used for the laptop
Config.UseStash = true -- Set to false if you dont want to make use of the stash & upgrading the stash
Config.UseStashUpgrade = true -- Set to false if you want to disable the stash upgrades (for if ur using an inventory that doesnt offer this feature)
Config.UseWardrobe = true -- Set to false if you dont want to make use of the wardrobe

Config.AllowedToCreate = {
    jobs = {
        -- 'real_estate_agent',
    },
    groups = {
        'owner',
        'superadmin',
    }
}

Config.Commands = {
    create = 'createhome',
    delete = 'deletehome',
    enterfix = 'huisfix', -- Used to tp back into the property if fallen through the map
}

Config.Ringing = {
    refreshCooldown = 3000, -- In MS
    canOpenStash = false, -- Can the player open the stash whilst being let in by ringing the doorbell?
    canOpenWardrobe = true, -- Can the player open the wardrobe whilst being let in by ringing the doorbell?
}

Config.Keyholders = {
    maxKeyholders = 5, -- false to make unlimited
    canOpenStash = true, -- Can the player open the stash as a keyholder?
    canOpenWardrobe = true, -- Can the player open the wardrobe as a keyholder?
}

Config.BreakIn = {
    enabled = false,
    canOpenStash = false,
    canOpenWardrobe = false,
    minimumCops = 0,
    copsJob = 'police',
    requiredItem = 'lockpick',
}

Config.Raid = {
    enabled = true,
    canOpenStash = true,
    canOpenWardrobe = true,
    requiredItem = 'phone',
    allowedJobs = { -- Minimum grade required
        { job = "police", grade = 8 },
    }
}

Config.Blips = {
    ownedPropertyOwner = { -- When you have the key to the property
        enabled = true,
        color = 4,
        sprite = 40,
        scale = 0.8,
        display = 4,
    },
    ownedPropertyStranger = { -- When you don't own the property
        enabled = false,
        color = 62,
        sprite = 40,
        scale = 0.8,
        display = 4,
    },
    unownedProperty = { -- When the property is unowned
        enabled = true,
        color = 0,
        sprite = 40,
        scale = 0.8,
        display = 4,
    },
}

Config.StashGrades = {
    { -- DEFAULT GRADE
        price = 0,
        weight = 250000,
        slots = 20,
    },
    {
        price = 500000,
        weight = 500000,
        slots = 30,
    },
    {
        price = 1500000,
        weight = 1000000,
        slots = 50,
    }
}

Config.ShellsZ = -50 -- Z axis for shells

--[[
    ONLY CHANGE THIS PART IF YOU HAVE RENAMED SCRIPTS SUCH AS FRAMEWORK, TARGET, INVENTORY ETC
    RENAME THE SCRIPT NAME TO THE NEW NAME
--]]
---@type table Only change these if you have changed the name of a resource
Resources = {
    ESX = { name = 'es_extended', export = 'getSharedObject' }, -- Puts the export in the ESX variable
    QB = { name = 'qb-core', export = 'GetCoreObject' },
    OXInv = 'ox_inventory', -- Puts all exports in the OXInv variable
    QBInv = 'qb-inventory',
    QSInv = 'qs-inventory',
    PSInv = 'ps-inventory',
    FMAPP = 'fivem-appearance',
    ILA = { name = 'illenium-appearance', export = false }, -- Sets ILA variable to 'true' if started (used for no exports, but events)
    OKOKG = { name = 'okokGarage', export = false },
    QBClothing = { name = 'qb-clothing', export = false },
    JGGARAGE = { name = 'jg-advancedgarages', export = false },
    CODEMG = { name = 'mGarage', export = false },
}
IgnoreScriptFoundLogs = false