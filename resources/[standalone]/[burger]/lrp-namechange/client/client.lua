ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local npcModel = Config.NPC.model
local npcCoords = Config.NPC.coords
local npcHeading = Config.NPC.heading
local switchCost = Config.SwitchCost

function spawnNPC()
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(500)
    end

    local npc = CreatePed(0, npcModel, npcCoords.x, npcCoords.y, npcCoords.z, npcHeading, false, true)
    SetEntityInvincible(npc, true)
    SetEntityVisible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    exports.ox_target:addLocalEntity(npc, {
        {
            name = "name_switch",
            icon = "fa-solid fa-user-edit",
            label = "Switch naam",
            onSelect = function()
                openNameSwitchMenu()
            end,
        },
    })
end

function openNameSwitchMenu()
    local menuOptions = {
        {
            title = 'Switch naar nieuwe naam',
            description = 'Kosten: €' .. switchCost,
            icon = 'fa-solid fa-user-edit',
            event = 'lrp-namechange:namechangemenu'
        },
        {
            title = 'Annuleer',
            icon = 'fa-solid fa-times',
            event = 'nameSwitch:cancel'
        }
    }

    lib.registerContext({
        id = 'name_switch_menu',
        title = 'Naam Switch',
        options = menuOptions
    })

    lib.showContext('name_switch_menu')
end

RegisterNetEvent("lrp-namechange:namechangemenu", function()
    TriggerServerEvent("lrp-namechange:checkMoney")
end)

RegisterNetEvent("lrp-namechange:requestNewNames")
AddEventHandler("lrp-namechange:requestNewNames", function()
    local input = lib.inputDialog("Voer je nieuwe naam in", {"Voornaam", "Achternaam"})

    if input and input[1] and input[2] then
        TriggerServerEvent("lrp-namechange:process", input[1], input[2])
    else
        TriggerClientEvent("lib:notify", source, {
            title = "Fout",
            description = "Beide velden moeten ingevuld zijn.",
            type = "error",
        })
    end
end)

Citizen.CreateThread(function()
    spawnNPC()
end)
