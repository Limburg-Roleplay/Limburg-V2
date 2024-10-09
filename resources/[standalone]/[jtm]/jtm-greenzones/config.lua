Config = {}

Config.EnableNotifications = false -- Do you want notifications when a player enters and exits the preconfigured greenzones (The Config.GreenZones)?
Config.GreenzonesCommand = 'setzone' -- The command to run in-game to start creating a temporary greenzone
Config.GreenzonesClearCommand = 'clearzone' -- The command to run in-game to clear an existing temporary greenzone

Config.GreenZones = { -- These are persistent greenzones that exist constantly, at all times - you can create as many as you want here
    ['Taakstraf'] = {
        coords = vec3(1649.2489, 2605.6733, 45.5649),
        radius = 40.0,
        disablePlayerVehicleCollision = false,
        enableSpeedLimits = false,
        setSpeedLimit = 1000,
        removeWeapons = true,
        disableFiring = true,
        setInvincible = true,
        displayTextUI = true,
        textToDisplay = 'Taakstraf Greenzone',
        backgroundColorTextUI = '#06b30b',
        textColor = '#000000',
        displayTextPosition = 'top-center',
        displayTextIcon = 'broom',
        blip = true,
        blipType = 'radius',
        enableSprite = false,
        blipSprite = 621,
        blipColor = 2,
        blipScale = 0.8,
        blipAlpha = 100,
        blipName = 'Taakstraf Greenzone'
    },
    ['VIP'] = {
        coords = vec3(211.4591, -927.0460, 30.6920),
        radius = 10.0,
        disablePlayerVehicleCollision = false,
        enableSpeedLimits = false,
        setSpeedLimit = 1000,
        removeWeapons = true,
        disableFiring = true,
        setInvincible = true,
        displayTextUI = true,
        textToDisplay = 'VIP: Blackmarket Greenzone',
        backgroundColorTextUI = '#06b30b',
        textColor = '#000000',
        displayTextPosition = 'top-center',
        displayTextIcon = 'star',
        blip = true,
        blipType = 'radius',
        enableSprite = false,
        blipSprite = 621,
        blipColor = 2,
        blipScale = 0.8,
        blipAlpha = 100,
        blipName = 'VIP: Blackmarket Greenzone'
    },
    ['Drugloods'] = {
        coords = vec3(-332.7538, -2445.1897, 7.3581),
        radius = 30.0,
        disablePlayerVehicleCollision = false,
        enableSpeedLimits = false,
        setSpeedLimit = 1000,
        removeWeapons = true,
        disableFiring = true,
        setInvincible = true,
        displayTextUI = true,
        textToDisplay = 'Verpak Loods Green Zone',
        backgroundColorTextUI = '#06b30b',
        textColor = '#000000',
        displayTextPosition = 'top-center',
        displayTextIcon = 'pills',
        blip = true,
        blipType = 'radius',
        enableSprite = false,
        blipSprite = 621,
        blipColor = 2,
        blipScale = 0.8,
        blipAlpha = 100,
        blipName = 'Verpak Loods Greenzone'
    },
    ['Wapenwinkel'] = {
        coords = vec3(-644.4205, -248.5894, 38.2098),
        radius = 10.0,
        disablePlayerVehicleCollision = false,
        enableSpeedLimits = false,
        setSpeedLimit = 1000,
        removeWeapons = true,
        disableFiring = true,
        setInvincible = true,
        displayTextUI = true,
        textToDisplay = 'Wapenwinkel Green Zone',
        backgroundColorTextUI = '#06b30b',
        textColor = '#000000',
        displayTextPosition = 'top-center',
        displayTextIcon = 'gun',
        blip = true,
        blipType = 'radius',
        enableSprite = false,
        blipSprite = 621,
        blipColor = 2,
        blipScale = 0.8,
        blipAlpha = 100,
        blipName = 'Wapenwinkel Greenzone'
    },
    ['uwv'] = {
        coords = vec3(-266.8707, -960.2629, 31.2309),
        radius = 30.0,
        disablePlayerVehicleCollision = false,
        enableSpeedLimits = false,
        setSpeedLimit = 1000,
        removeWeapons = true,
        disableFiring = true,
        setInvincible = true,
        displayTextUI = true,
        textToDisplay = 'Uwv Green Zone',
        backgroundColorTextUI = '#06b30b',
        textColor = '#000000',
        displayTextPosition = 'top-center',
        displayTextIcon = 'shield-halved',
        blip = true,
        blipType = 'radius',
        enableSprite = false,
        blipSprite = 621,
        blipColor = 2,
        blipScale = 0.8,
        blipAlpha = 100,
        blipName = 'Uwv Greenzone'
    }
}

Config.Redzones = { -- These are persistent greenzones that exist constantly, at all times - you can create as many as you want here
    ['paletoredzone'] = {
        coords = vec3(47.9753, 6423.3789, 31.2940), -- The center-most location of the greenzone 
        radius = 35.0, -- The radius (how large or small) the greenzone is (note: this must include the .0 on the end of the number to work)
        disablePlayerVehicleCollision = false, -- Do you want to disable players & their vehicles collisions between each other? (true if yes, false if no)
        enableSpeedLimits = false, -- Do you want to enforce a speed limit in this zone? (true if yes, false if no)
        setSpeedLimit = 1000, -- The speed limit (in MPH) that will be enforced in this zone if enableSpeedLimits is true
        removeWeapons = false, -- Do you want to remove weapons completely from players hands while in this zone? (true if yes, false if no)
        disableFiring = false, -- Do you want to disable everyone from firing weapons/punching/etc in this zone? (true if yes, false if no)
        setInvincible = false, -- Do you want everyone to be invincible in this zone? (true if yes, false if no)
        displayTextUI = true, -- Do you want textUI to display on everyones screen while in this zone? (true if yes, false if no)
        textToDisplay = 'Paleto Redzone', -- The text to display on everyones screen if displayTextUI is true for this zone
        backgroundColorTextUI = '#06b30b', -- The color of the textUI background to display if displayTextUI is true for this zone
        textColor = '#000000', -- The color of the text & icon itself on the textUI if displayTextUI is true for this zone
        displayTextPosition = 'top-center', -- The position of the textUI if displayTextUI is true for this zone
        displayTextIcon = 'hospital', -- The icon to be displayed on the TextUI in this zone if displayTextUI is true
        blip = true, -- Do you want a blip to display on the map here? True for yes, false for no
        blipType = 'radius', -- Type can be 'radius' or 'normal'
        enableSprite = false, -- Do you want a sprite at the center of the radius blip? (If blipType = 'normal', this don't matter, it will display a sprite)
        blipSprite = 621, -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/) (only used if enableSprite = true, otherwise can be ignored)
        blipColor = 2, -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
        blipScale = 0.7, -- Blip size (0.01 to 1.0) (only used if enableSprite = true, otherwise can be ignored)
        blipAlpha = 100, -- The transparency of the radius blip if blipType = 'radius', otherwise not used/can be ignored
        blipName = 'Paleto Redzone' -- Blip name on the map (if enableSprite = true, otherwise can be ignored)
    }
}

Notifications = {
    position = 'top', -- The position for all notifications
    greenzoneTitle = 'Green Zone', -- Title when entering a greenzone
    greenzoneIcon = 'border-all', -- The icon displayed on the notifications
    greenzoneEnter = 'You have entered a greenzone and certain actions have been disabled', -- Description when entering a greenzone
    greenzoneExit = 'You have exited a greenzone and all actions have been restored', -- Description when exiting a greenzone
}