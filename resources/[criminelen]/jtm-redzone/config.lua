Config = {}

Config.EnableNotifications = true -- Do you want notifications when a player enters and exits the preconfigured greenzones (The Config.GreenZones)?

Config.GreenZones = { -- These are persistent greenzones that exist constantly, at all times - you can create as many as you want here
    ['paletoredzone'] = {
        coords = vec3(103.5271, 6502.3828, 31.2347), -- The center-most location of the greenzone 
        radius = 400.0, -- The radius (how large or small) the greenzone is (note: this must include the .0 on the end of the number to work)
        displayTextUI = true, -- Do you want textUI to display on everyones screen while in this zone? (true if yes, false if no)
        textToDisplay = 'Paletto Redzone', -- The text to display on everyones screen if displayTextUI is true for this zone
        backgroundColorTextUI = '#FF0000', -- The color of the textUI background to display if displayTextUI is true for this zone
        textColor = '#000000', -- The color of the text & icon itself on the textUI if displayTextUI is true for this zone
        displayTextPosition = 'top-center', -- The position of the textUI if displayTextUI is true for this zone
        displayTextIcon = 'gun', -- The icon to be displayed on the TextUI in this zone if displayTextUI is true
        blip = true, -- Do you want a blip to display on the map here? True for yes, false for no
        blipType = 'radius', -- Type can be 'radius' or 'normal'
        enableSprite = false, -- Do you want a sprite at the center of the radius blip? (If blipType = 'normal', this don't matter, it will display a sprite)
        blipSprite = 621, -- Blip sprite (https://docs.fivem.net/docs/game-references/blips/) (only used if enableSprite = true, otherwise can be ignored)
        blipColor = 1, -- Blip color (https://docs.fivem.net/docs/game-references/blips/#blip-colors)
        blipScale = 0.7, -- Blip size (0.01 to 1.0) (only used if enableSprite = true, otherwise can be ignored)
        blipAlpha = 100, -- The transparency of the radius blip if blipType = 'radius', otherwise not used/can be ignored
        blipName = 'Eiland Redzone' -- Blip name on the map (if enableSprite = true, otherwise can be ignored)
    }
}

Notifications = {
    position = 'bottom',
    greenzoneTitle = 'Red Zone',
    greenzoneIcon = 'gun',
    greenzoneEnter = 'Je bent de redzone betreden! Je mag hier zonder reden geript worden! Alle andere regels gelden wel nog!', 
    greenzoneExit = 'Je bent uit de redzone gegaan! Je mag niet meer geript worden zonder reden!',
}