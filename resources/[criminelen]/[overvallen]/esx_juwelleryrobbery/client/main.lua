ESX = exports["es_extended"]:getSharedObject()
soundid = GetSoundId()
function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end
local isBreaking = false
local MinPolice = Config.MinPolice
local robberyStarted = false
local startTarget = Config.StartPoint
local targetIds = {}
local coordinatesList = Config.GrabPlaces
Citizen.CreateThread(
    function()
        Citizen.Wait(5)

        exports.ox_target:addBoxZone(
            {
                coords = startTarget,
                size = vector3(0.5, 0.5, 0.5),
                rotation = 45,
                options = {
                    {
                        name = "Start Overval",
                        event = "esx_juwelleryrobbery:startRobberyClient",
                        icon = "fa-solid fa-gun",
                        label = "Start Overval",
                        canInteract = function(entity)
                            if (IsPedArmed(PlayerPedId(), 4)) and not robberyStarted then
                                return true
                            else
                                return false
                            end
                        end,
                        onSelect = function(entity)
                            ESX.TriggerServerCallback(
                					"esx_juwelleryrobbery:fetchCops",
                				function(IsEnough)
                    				if IsEnough then
                                		TriggerServerEvent("esx_juwelleryrobbery:startRobbery", GetPlayerPed(-1))
                                        TriggerEvent('juwelier:alertCops')
                    				else
                        				exports['frp-notifications']:Notify('error', 'Er is niet genoeg politie!', 5000)
                    				end
                				end, MinPolice)
                            
                        end
                    }
                }
            }
        )
    end
)
RegisterNetEvent("juwelier:alertCops")
AddEventHandler(
    "juwelier:alertCops",
    function()
        local coords = vector3(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z)
        street =
            GetStreetNameFromHashKey(
            GetStreetNameAtCoord(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z)
        )
        TriggerServerEvent(
            "esx_outlawalert:robberyInProgress",
            vector3(Config.StartPoint.x, Config.StartPoint.y, Config.StartPoint.z),
            street,
            "Man",
            "Juwelier"
        )
    end
)
function table.indexOf(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end
RegisterNetEvent("esx_juwelleryrobbery:tooFarAway")
AddEventHandler(
    "esx_juwelleryrobbery:tooFarAway",
    function()
        robberyStarted = false
        StopSound(soundid)
        for _, v in ipairs(targetIds) do
            exports.ox_target:removeZone(tonumber(v))
            local index = table.indexOf(targetIds, v)
            table.remove(targetIds, index)
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if
                robberyStarted and
                    (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.MidPoint.x, Config.MidPoint.y, Config.MidPoint.z, true) >
                        11.5)
             then
                TriggerServerEvent("esx_juwelleryrobbery:toofar")
            end
        end
    end
)
RegisterNetEvent("esx_juwelleryrobbery:createTargets")
AddEventHandler(
    "esx_juwelleryrobbery:createTargets",
    function()
        for _, coords in ipairs(coordinatesList) do
            local targetZone =
                exports.ox_target:addSphereZone(
                {
                    coords = coords,
                    radius = .5,
                    debug = false,
                    options = {
                        {
                            name = "Juwelen Pakken",
                            event = "esx_juwelleryrobbery:grabJuwels",
                            icon = "fa-solid fa-ring",
                            label = "Juwelen Pakken",
                            canInteract = function()
                                local playerCoords = GetEntityCoords(PlayerPedId())
                                if
                                    not IsEntityPlayingAnim(PlayerPedId(), "missheist_jewel", "smash_case", 3)  and not isBreaking
                                 then
                                    return true
                                else
                                    return false
                                end
                            end,
                            onSelect = function(entity)
                                exports.ox_target:removeZone(entity.zone)
                                local smashCoords = entity.coords

                                PlaySoundFromCoord(
                                    -1,
                                    "Glass_Smash",
                                    smashCoords.x,
                                    smashCoords.y,
                                    smashCoords.z,
                                    "",
                                    0,
                                    0,
                                    0
                                )
                                if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
                                    RequestNamedPtfxAsset("scr_jewelheist")
                                end
                                while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                                    Citizen.Wait(0)
                                end
                                SetPtfxAssetNextCall("scr_jewelheist")
                                StartParticleFxLoopedAtCoord(
                                    "scr_jewel_cab_smash",
                                    smashCoords.x,
                                    smashCoords.y,
                                    smashCoords.z,
                                    0.0,
                                    0.0,
                                    0.0,
                                    1.0,
                                    false,
                                    false,
                                    false,
                                    false
                                )
                                loadAnimDict("missheist_jewel")
                                TaskPlayAnim(
                                    GetPlayerPed(-1),
                                    "missheist_jewel",
                                    "smash_case",
                                    8.0,
                                    1.0,
                                    -1,
                                    2,
                                    0,
                                    0,
                                    0,
                                    0
                                )
                                isBreaking = true
                                Citizen.Wait(5000)
                                isBreaking = false
                                ClearPedTasksImmediately(GetPlayerPed(-1))
                                TriggerServerEvent("esx_juwelleryrobbery:grabJewels", GetPlayerPed(-1))
                            end
                        }
                    }
                }
            )
            table.insert(targetIds, targetZone)
        end
    end
)
RegisterNetEvent("esx_juwelleryrobbery:startRobberyClient")
AddEventHandler(
    "esx_juwelleryrobbery:startRobberyClient",
    function()
        robberyStarted = true
        PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", -629.7775, -236.5887, 38.0571)
       
        
    end
)