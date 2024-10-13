-- client.lua
local propList = {
    'stt_prop_stunt_track_start_02',
    'stt_prop_stunt_track_st_02',
    'stt_prop_stunt_track_start',
    'stt_prop_stunt_track_st_01',
    'stt_prop_stunt_track_exshort',
    'stt_prop_stunt_track_short',
    'stt_prop_stunt_track_straight',
    'stt_prop_stunt_track_turn',
    'stt_prop_stunt_track_sh15',
    'stt_prop_stunt_track_sh30',
    'stt_prop_stunt_track_sh45',
    'stt_Prop_Stunt_Track_SH45_a',
    'stt_prop_stunt_track_uturn',
    'stt_prop_stunt_track_cutout',
    'stt_prop_stunt_track_otake',
    'stt_prop_stunt_track_fork',
    'stt_prop_stunt_track_funnel',
    'stt_prop_stunt_track_funlng',
    'stt_prop_stunt_track_slope15',
    'stt_prop_stunt_track_slope30',
    'stt_prop_stunt_track_slope45',
    'stt_prop_stunt_track_hill',
    'stt_prop_stunt_track_hill2',
    'stt_prop_stunt_track_bumps',
    'stt_prop_stunt_track_jump',
    'stt_prop_stunt_jump15',
    'stt_prop_stunt_jump30',
    'stt_prop_stunt_jump45',
    'stt_prop_stunt_track_link',
    'stt_prop_stunt_track_dwlink',
    'stt_prop_stunt_track_dwlink_02',
    'stt_prop_stunt_track_dwshort',
    'stt_prop_stunt_track_dwsh15',
    'stt_prop_stunt_track_dwturn',
    'stt_prop_stunt_track_dwuturn',
    'stt_prop_stunt_track_dwslope15',
    'stt_prop_stunt_track_dwslope30',
    'stt_prop_stunt_track_dwslope45',
    'stt_prop_stunt_tube_xxs',
'stt_prop_stunt_tube_xs',
'stt_prop_stunt_tube_s',
'stt_prop_stunt_tube_m',
'stt_prop_stunt_tube_l',
'stt_prop_stunt_tube_crn',
'stt_prop_stunt_tube_crn_5d',
'stt_prop_stunt_tube_crn_15d',
'stt_prop_stunt_tube_crn_30d',
'stt_prop_stunt_tube_crn2',
'stt_prop_stunt_tube_fork',
'stt_prop_stunt_tube_cross',
'stt_prop_stunt_tube_gap_01',
'stt_prop_stunt_tube_gap_02',
'stt_prop_stunt_tube_gap_03',
'stt_prop_stunt_tube_qg',
'stt_prop_stunt_tube_hg',
'stt_prop_stunt_tube_jmp',
'stt_prop_stunt_tube_jmp2',
'stt_prop_stunt_tube_fn_01',
'stt_prop_stunt_tube_fn_02',
'stt_prop_stunt_tube_fn_03',
'stt_prop_stunt_tube_fn_04',
'stt_prop_stunt_tube_fn_05',
'stt_prop_stunt_tube_ent',
'stt_prop_stunt_tube_end',
'sr_prop_sr_tube_end',
'stt_prop_stunt_tube_speed',
'sr_Prop_Spec_Tube_Refill',
'stt_prop_track_tube_01',
    'stt_prop_track_tube_02'
}

local spawnedProps = {}

-- Functie om props te spawnen
local function spawnProp(propName)
    -- Zorg dat het prop model geladen is
    local propHash = GetHashKey(propName)
    if not IsModelInCdimage(propHash) or not IsModelValid(propHash) then
        lib.notify({ title = 'Fout', description = ('Model %s bestaat niet!'):format(propName), type = 'error' })
        return
    end

    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Wait(500)
    end

    -- Haal de speler en de positie op
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Spawn het prop object
    local spawnedProp = CreateObject(propHash, coords.x, coords.y, coords.z, true, true, false)
    SetEntityHeading(spawnedProp, GetEntityHeading(playerPed))
    PlaceObjectOnGroundProperly(spawnedProp)

    -- Voeg de prop toe aan de lijst van gespawnde props
    table.insert(spawnedProps, spawnedProp)
    lib.notify({ title = 'Prop Spawner', description = ('Prop %s succesvol gespawned!'):format(propName), type = 'success' })

    -- Release model memory
    SetModelAsNoLongerNeeded(propHash)
end

-- Functie om een menu te openen met props
local function openPropMenu()
    local menuOptions = {}

    -- Maak een menu optie voor elke prop in de lijst
    for _, propName in ipairs(propList) do
        table.insert(menuOptions, {
            title = propName,
            description = ('Spawn %s'):format(propName),
            event = 'spawn_prop',
            args = { propName = propName }
        })
    end

    -- Gebruik ox_lib's menu functie om een selectie-menu te openen
    lib.registerContext({
        id = 'prop_menu',
        title = 'Kies een prop om te spawnen',
        options = menuOptions
    })

    lib.showContext('prop_menu')
end

-- Event om een prop te spawnen wanneer er één uit het menu wordt gekozen
RegisterNetEvent('spawn_prop', function(data)
    spawnProp(data.propName)
end)

-- Command om het prop menu te openen
RegisterCommand('propmenu', function()
    openPropMenu()
end, false)

-- Verwijder alle props die gespawned zijn
local function deleteAllProps()
    for _, prop in pairs(spawnedProps) do
        DeleteObject(prop)
    end
    spawnedProps = {}
    lib.notify({ title = 'Prop Spawner', description = 'Alle props zijn verwijderd!', type = 'error' })
end

RegisterCommand('deleteprops', function()
    deleteAllProps()
end, false)
