-- Menu configuration, array of menus to display
menuConfigs = {
    ['emotes'] = {                                  -- Example menu for emotes when player is on foot
        lastCheck = 0,
        enableMenu = true,
        data = {                                    -- Data that is passed to Javascript
            keybind = "3",                         -- Wheel keybind to use
            style = {                               -- Wheel style settings
                sizePx = 600,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.40 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.60 },
                    selected = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 2, ['opacity'] = 0.40 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {                              -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.3, 
                    maxRadiusPercent = 0.6,        -- Minimum radius of wheel in percePORTO          maxRadiusPercent = 0.6,         -- Maximum radius of wheel in percentage
                    labels = {"PORTO", "SIGARET", "ARMEN", "PRATEN", "DENKEN", "TELEFOON"},
                    commands = {"e cop3", "e smoke2", "e crossarms5", "e argue", "e think4", "e phone"}
                },
                {
                    navAngle = 285,                 -- Oritentation of wheel
                    minRadiusPercent = 0.6,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                    labels = {"BEVEILIGER", " WTF", "DUIMPJES", "HURKEN", "PEACE", "KNUFFEL", "NOTITIE", "PARAPLU", "KNIEEN", "GEWOND", "HOLSTER", "AFSCHUDDEN"},
                    commands = {"e guard", "e boi", "e thumbsup", "e kneel3", "e peace", "nearby hug ", "e notepad", "e umbrella", "e surrender", "e shot", "e reaching", "e shakeoff"}
                }
            }
        }
    },
    ['vehicles'] = {                                -- Example menu for vehicle controls when player is in a vehicle
        lastCheck = 0,
        enableMenu = true,
        data = {                                    -- Data that is passed to Javascript
            keybind = "3",                         -- Wheel keybind to use
            style = {                               -- Wheel style settings
                sizePx = 400,                       -- Wheel size in pixels
                slices = {                          -- Slice style settings
                    default = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.40 },
                    hover = { ['fill'] = '#ff8000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.60 },
                    selected = { ['fill'] = '#000000', ['stroke'] = '#000000', ['stroke-width'] = 3, ['opacity'] = 0.40 }
                },
                titles = {                          -- Text style settings
                    default = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    hover = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' },
                    selected = { ['fill'] = '#ffffff', ['stroke'] = 'none', ['font'] = 'Helvetica', ['font-size'] = 16, ['font-weight'] = 'bold' }
                },
                icons = {
                    width = 64,
                    height = 64
                }
            },
            wheels = {    
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.0, 
                    maxRadiusPercent = 0.4,        -- Minimum radius of wheel in percePORTO          maxRadiusPercent = 0.6,         -- Maximum radius of wheel in percentage
                    labels = {"Raam L", "Raam R"},
                    commands = {"raam 0", "raam 1"},
                },                          -- Array of wheels to display
                {
                    navAngle = 270,                 -- Oritentation of wheel
                    minRadiusPercent = 0.4,         -- Minimum radius of wheel in percentage
                    maxRadiusPercent = 0.9,         -- Maximum radius of wheel in percentage
                    labels = {"imgsrc:engine.png", "imgsrc:doors.png", "imgsrc:doors.png", "imgsrc:trunk.png", "imgsrc:hood.png"},
                    commands = {"engine", "fdoors", "rdoors", "trunk", "hood"}
                }
            }
        }
    }
}
