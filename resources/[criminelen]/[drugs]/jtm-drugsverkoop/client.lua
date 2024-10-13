-- Creat NPC function

function CreateNPC(model, coords, heading)
    local npcHash = GetHashKey(model)
    RequestModel(npcHash)
    while not HasModelLoaded(npcHash) do
        Wait(500)
    end
    local npcPed = CreatePed(4, npcHash, coords, heading, false, false)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    return npcPed
end



-- Define NPC coordinates

local npcCoords1 = vector3(1672.6426, -26.0702, 172.7738) -- Meth --
local npcHeading1 = 100.8467
local npcCoords2 = vector3(1185.3896, -3109.6050, 5.0280) -- Lsd --
local npcHeading2 = 0.2503
local npcCoords3 = vector3(270.1448, -1705.8024, 28.3077) -- GHb --
local npcHeading3 = 49.3304

-- Create NPC
CreateThread(function()
    CreateNPC("g_m_y_ballaeast_01", npcCoords1, npcHeading1)
    CreateNPC("g_m_y_ballaeast_01", npcCoords2, npcHeading2)
    CreateNPC("g_m_y_ballaeast_01", npcCoords3, npcHeading3)
end)


-- Ox targets

exports.ox_target:addBoxZone({
    coords = vector3(1672.6768, -26.1274, 173.7738),
    size = vector3(2,2,2),
    rotation = 104.5638,
    options = {
        {
            name = "jtm-drugsverkoop",
            label = "Verkoop Meth Zakjes",
            icon = "fa-solid fa-flask",
            debug = drawZones,
            onSelect = function ()
                local input = lib.inputDialog('Meth Verkoop', {
                    {type = 'number', label = 'Hoeveel Meth Zakjes wil je verkopen?', description = 'Aantal Meth Zakjes dat je wilt verkopen', icon = 'fa-solid fa-flask'}
                })
                if input[1] == nil then
                    lib.notify({
                        title = 'Drugsverkoop',
                        description = 'Niet een geldige nummer, vul opnieuw in.',
                        type ='error'
                    })
                end
                TriggerServerEvent("jtm-development:rewardMeth", input)
            end
            
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vector3(270.1448, -1705.8024, 29.3077),
    size = vector3(2,2,2),
    rotation = 49.3304,
    options = {
        {
            name = "jtm-drugsverkoop",
            label = "Verkoop Ghb Poeder",
            icon = "fa-solid fa-flask",
            debug = drawZones,
            onSelect = function ()
                local input = lib.inputDialog('GHB Verkoop', {
                    {type = 'number', label = 'Hoeveel Ghb Poeder wil je verkopen?', description = 'Aantal Ghb Poeder dat je wilt verkopen', icon = 'fa-solid fa-flask'}
                  })
                  TriggerServerEvent("jtm-development:rewardGhb", input)
            end
            
        }
    }
})

exports.ox_target:addBoxZone({
    coords = vector3(1185.3896, -3109.6050, 6.0280),
    size = vector3(2,2,2),
    rotation = 0.2503,
    options = {
        {
            name = "jtm-drugsverkoop",
            label = "Verkoop LSD Ton",
            icon = "fa-solid fa-skull-crossbones",
            debug = drawZones,
            onSelect = function ()
                local input = lib.inputDialog('LSD Verkoop', {
                    {type = 'number', label = 'Hoeveel LSD Tonnen wil je verkopen?', description = 'Aantal LSD Tonnen dat je wilt verkopen', icon = 'fa-solid fa-skull-crossbones'}
                  })
                  TriggerServerEvent("jtm-development:rewardLSD", input)
            end
            
        }
    }
})
-- Blips


local blipCoords = vector3(270.9777, -1705.2170, 29.3049) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 499) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.8) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("GHB Verkoop") 
EndTextCommandSetBlipName(blip)

local blipCoords = vector3(-565.8213, -1459.0908, 10.2875) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 499) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.8) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("GHB Pluk") 
EndTextCommandSetBlipName(blip)

local blipCoords = vector3(-1547.7323, 2854.8201, 31.1417) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 514) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.7) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Meth Pluk") 
EndTextCommandSetBlipName(blip)
