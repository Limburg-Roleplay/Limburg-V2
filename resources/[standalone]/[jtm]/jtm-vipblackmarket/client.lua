function CreateNPC(model, coords, heading)
    local npcHash = GetHashKey(model)
    RequestModel(npcHash)
    while not HasModelLoaded(npcHash) do
        Wait(500)
    end
    local npcPed = CreatePed(4, npcHash, coords.x, coords.y, coords.z, heading, false, false)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)

    return npcPed
end

local npcCoords = vector3(921.2661, 41.4979, 80.0960)
local npcHeading = 55.8511

CreateThread(function()
    CreateNPC("cs_chengsr", npcCoords, npcHeading)
end)

local blipCoords = vector3(921.2661, 41.4979, 81.0960)

local blip = AddBlipForCoord(blipCoords)

SetBlipSprite(blip, 304) -- icon
SetBlipColour(blip, 46) -- color
SetBlipScale(blip, 1.1) -- size
SetBlipAsShortRange(blip, true)

BeginTextCommandSetBlipName("STRING")
AddTextComponentString("VIP: Blackmarket")
EndTextCommandSetBlipName(blip)

exports.ox_target:addBoxZone({
    coords = vector3(921.2661, 41.4979, 81.0960 + 0.1),
    size = vector3(2, 2, 2),
    rotation = 45,
    options = {
        {
            name = "vipblackmarket",
            label = 'Open Blackmarket',
            icon = 'fas fa-crown',
            debug = drawZones,
            onSelect = function ()
                if exports["discordperms"]:hasvipblackmarketgroup() then
                    OpenStash()
                else 
                    lib.notify({
                        title = 'VIP Blackmarket',
                        description = 'Je hebt hier geen toegang tot, aanschaf VIP in de support discord!',
                        type = 'error'
                    })
                end
            end
        }
    }
})

RegisterNetEvent('zetrox-vip:client:openblackmarket')
AddEventHandler('zetrox-vip:client:openblackmarket', function()
    OpenStash()
end)

function OpenStash()
    lib.registerContext({
        id = 'zetrox-vip:inkoop',
        title = 'VIP Blackmarket',
        options = {
            {
                title = "Wapens",
                icon = "https://i.postimg.cc/4NJRhZMT/limburgroleplay.png",
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", {type = "vipwapen"})
                end
            },
            {
                title = "Ammo",
                icon = 'box',
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", {type = "vipammo"})
                end
            },
            {
                title = "Attachments",
                icon = 'boxes-stacked',
                onSelect = function()
                    exports.ox_inventory:openInventory("shop", {type = "vipattachments"})
                end
            }
        }
    })
    lib.showContext('zetrox-vip:inkoop')
end