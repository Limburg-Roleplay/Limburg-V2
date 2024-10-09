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

local npcCoords1 = vector3(3333.5410, 5160.4922, 18.3061-1)
local npcHeading1 = 147.5858
local npcCoords2 = vector3(84.6963, 3718.0383, 40.3293-1)
local npcHeading2 = 52.2261
local npcCoords3 = vector3(1509.3954, -2123.6931, 76.5648-1)
local npcHeading3 = 180.5341

-- Create NPC
CreateThread(function()
    CreateNPC("g_m_y_ballaeast_01", npcCoords1, npcHeading1)
    CreateNPC("g_m_y_ballaeast_01", npcCoords2, npcHeading2)
    CreateNPC("g_m_y_ballaeast_01", npcCoords3, npcHeading3)
end)


-- Ox targets

exports.ox_target:addBoxZone({
    coords = vector3(3333.5833, 5160.5796, 18.3063),
    size = vector3(2,2,2),
    rotation = 343.5858,
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
    coords = vector3(84.6963, 3718.0383, 40.3293),
    size = vector3(2,2,2),
    rotation = 52.2261,
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
    coords = vector3(1509.4047, -2124.2134, 76.5648+0.3),
    size = vector3(2,2,2),
    rotation = 91.8932,
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

local blipCoords = vector3(1509.3954, -2123.6931, 76.5648) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 484) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.8) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("LSD Verkoop") 
EndTextCommandSetBlipName(blip)

local blipCoords = vector3(2530.1804, 4816.1650, 33.9008) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 484) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.8) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("LSD Pluk") 
EndTextCommandSetBlipName(blip)

local blipCoords = vector3(84.6963, 3718.0383, 40.3293) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 499) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.8) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("GHB Verkoop") 
EndTextCommandSetBlipName(blip)

local blipCoords = vector3(256.4119, 6459.7852, 31.3985) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 499) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.8) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("GHB Pluk") 
EndTextCommandSetBlipName(blip)

local blipCoords = vector3(-47.8312, 3348.7878, 45.2680) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 514) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.7) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Meth Pluk") 
EndTextCommandSetBlipName(blip)

local blipCoords = vector3(3333.1455, 5160.0176, 18.3072) 

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 514) -- icon
SetBlipColour(blip, 3) -- color 
SetBlipScale(blip, 0.7) -- size
SetBlipAsShortRange(blip, true) 

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Meth Verkoop") 
EndTextCommandSetBlipName(blip)