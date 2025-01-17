ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local dienst = false
local shouldBlock = false
CreateThread(function()
    Wait(5000)
    TriggerEvent("txcl:setAdmin", false, false, "U heeft geen toegang tot dit command")
end)

local whitelisted = {
	"steam:110000133c7f273",
    "steam:110000144cf9831",
    "steam:1100001550b537f",
    "steam:1100001493249e2",
    "steam:11000013c1388a9",
    "steam:110000149ffb275",
    "steam:11000014bb97d62"
}

local steamID = nil -- Globale variabele om de Steam ID op te slaan

function isSteamIDInList(steamID)
    for _, listID in ipairs(whitelisted) do
        if listID:sub(1, 6) == "steam:" and steamID == listID then
            return true
        end
    end
    return false
end

RegisterNetEvent("vl-staffdienst:receiveSteamID")
AddEventHandler("vl-staffdienst:receiveSteamID", function(id)
    steamID = id
end)

RegisterNetEvent("vl-staffdienst:toggle:dienst", function(toggle)
    if steamID == nil then
        TriggerServerEvent("vl-staffdienst:getSteamID")
        Citizen.Wait(100)
    end

    dienst = toggle
    
    if dienst then
        TriggerServerEvent('txsv:checkIfAdmin')
        TriggerEvent("lrp-staffzaak:client:request:staff:outje")
        shouldBlock = true
        
        while shouldBlock and not isSteamIDInList(steamID) do
            Citizen.Wait(0)
            DisableControlAction(0, 24, true) -- Disables attack (shooting)
            DisableControlAction(0, 25, true) -- Disables aiming
            DisableControlAction(0, 142, true) -- Disables melee attack
            DisableControlAction(0, 257, true) -- Disables attack when in vehicle
            DisableControlAction(0, 140, true) -- Disables light melee attack
            DisableControlAction(0, 263, true) -- Disables heavy melee attack
        end
    else
        shouldBlock = false
        TriggerEvent("txcl:setAdmin", false, false, "Je bent uit dienst gegaan")
        exports['ox_appearance']:SetCivilianOutfit()
    end
end)

exports("inDienst", function()
    if steamID == nil then
        TriggerServerEvent("vl-staffdienst:getSteamID")
        Citizen.Wait(100)
    end

    if isSteamIDInList(steamID) then
        return true
    else
        return dienst
    end
end)

RegisterNetEvent('lrp-staffzaak:client:request:staff:vest')
AddEventHandler('lrp-staffzaak:client:request:staff:vest', function()
    local ped = PlayerPedId()

    if (IsPedModel(ped, "mp_m_freemode_01")) then
        exports['ox_appearance']:SetJobOutfit(Config.outfitman.Outfit2.props, Config.outfitman.Outfit2.components)
    elseif (IsPedModel(ped, "mp_f_freemode_01")) then
        exports['ox_appearance']:SetJobOutfit(Config.outfitvrouw.Outfit2.props, Config.outfitvrouw.Outfit2.components)
    end
end)

RegisterNetEvent('lrp-staffzaak:client:request:staff:uit')
AddEventHandler('lrp-staffzaak:client:request:staff:uit', function()
    exports['ox_appearance']:SetCivilianOutfit()
end)

TriggerEvent('chat:addSuggestion', '/staffdienst', 'Ga in/uit dienst als staff!')
TriggerEvent('chat:addSuggestion', '/staffvest', 'Doe je staffvest aan!')
