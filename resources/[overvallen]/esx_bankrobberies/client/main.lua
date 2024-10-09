Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173
}

ESX = exports["es_extended"]:getSharedObject()

local robberyOngoing = false

local MinPolice = Config.MinPolice

Citizen.CreateThread(
    function()
        if ESX.IsPlayerLoaded() then
            ESX.PlayerData = ESX.GetPlayerData()
        end
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        ESX.PlayerData.job = job
    end
)

BankHeists = Config.BankHeists

RegisterNetEvent("esx_bankrobbery:alertCops")
AddEventHandler(
    "esx_bankrobbery:alertCops",
    function(bankId)
        local coords = BankHeists[bankId]["Start_Robbing"]
        street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords["x"], coords["y"], coords["z"]))
        TriggerServerEvent('esx_outlawalert:robberyInProgress', vec3(coords["x"], coords["y"], coords["z"]), street, 'Man', 'bank')
    end
)
RegisterNetEvent("esx_bankrobbery:startBank")
AddEventHandler(
    "esx_bankrobbery:startBank",
    function(bankId)
        if (exports.ox_inventory:GetItemCount("blowpipe") > 0) then
            ESX.TriggerServerCallback(
                "esx_bankrobbery:fetchCops",
                function(IsEnough)
                    if IsEnough then
                        local playerPed = GetPlayerPed(-1)
						
                        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
						
                        Citizen.Wait(10000)
                        ClearPedTasksImmediately(PlayerPedId())
                        TriggerServerEvent("esx_bankrobbery:startRobbery", bank)
                    else
                        exports['frp-notifications']:Notify('error', 'Er is niet genoeg politie!', 5000)
                    end
                end,
                MinPolice
            )
        else
            exports['frp-notifications']:Notify('error', 'Je hebt geen blowtorch!', 5000)
        end
    end
)

local uniqueValues = {}
Citizen.CreateThread(
    function()
        ResetDoors()
        while true do
            Citizen.Wait(5)

            if not robberyOngoing then
                for bank, values in pairs(BankHeists) do
                    if not uniqueValues[bank] then
                        uniqueValues[bank] = true
                        local StartPosition = values["Start_Robbing"]
                        local ped = PlayerPedId()
                        local pedCoords = GetEntityCoords(ped)
                        local distanceCheck =
                            GetDistanceBetweenCoords(
                            pedCoords,
                            StartPosition["x"],
                            StartPosition["y"],
                            StartPosition["z"],
                            true
                        )
                        exports.ox_target:addBoxZone(
                            {
                                coords = vector3(StartPosition["x"], StartPosition["y"], StartPosition["z"]),
                                size = vector3(0.5, 0.5, 0.5),
                                rotation = 45,
                                options = {
                                    {
                                        name = "Start Overval",
                                        event = "esx_bankrobbery:startBank",
                                        icon = "fa-solid fa-gun",
                                        label = "Start Overval",
                                        canInteract = function(entity)
                                            if (IsPedArmed(PlayerPedId(), 4)) and not robberyOngoing then
                                                return true
                                            else
                                                return false
                                            end
                                        end,
                                        onSelect = function()
                                            if (exports.ox_inventory:GetItemCount("blowpipe") > 0) then
                                                ESX.TriggerServerCallback(
                                                    "esx_bankrobbery:fetchCops",
                                                    function(IsEnough)
                                                        if IsEnough then
                                                            TriggerEvent("ox_inventory:disarm", true)
                                                            local playerPed = GetPlayerPed(-1)
                                                            TaskStartScenarioInPlace(
                                                                playerPed,
                                                                "WORLD_HUMAN_WELDING",
                                                                0,
                                                                true
                                                            )
                                                            Citizen.Wait(7500)
                                                            ClearPedTasksImmediately(PlayerPedId())
                                                            TriggerServerEvent("esx_bankrobbery:startRobbery", bank)
                                                        else
                                                            exports['frp-notifications']:Notify('error', 'Er is niet genoeg politie!', 5000)
                                                        end
                                                    end,
                                                    MinPolice
                                                )
                                            else
                                               	exports['frp-notifications']:Notify('error', 'Je hebt geen blowtorch', 5000)
                                            end
                                        end
                                    }
                                }
                            }
                        )
                    end
                end
            end
        end
    end
)
RegisterNetEvent("esx_bankrobbery:startRobbery")
AddEventHandler(
    "esx_bankrobbery:startRobbery",
    function(bankId)
        StartRobbery(bankId)
    end
)

RegisterNetEvent("esx_bankrobbery:endRobbery")
AddEventHandler(
    "esx_bankrobbery:endRobbery",
    function(bankId)
        ResetDoors()
        robberyOngoing = false
    end
)

RegisterNetEvent("esx_bankrobbery:changeCash")
AddEventHandler(
    "esx_bankrobbery:changeCash",
    function(bankId, newCash)
        if newCash <= 0 then
            BankHeists[bankId]["Money"] = 0
        end

        BankHeists[bankId]["Money"] = newCash
    end
)

function StartRobbery(bankId)
    robberyOngoing = true

    local CashPosition = BankHeists[bankId]["Cash_Pile"]

    loadModel("bkr_prop_bkr_cashpile_04")
    loadAnimDict("anim@heists@ornate_bank@grab_cash_heels")

    local CashPile =
        CreateObject(
        GetHashKey("bkr_prop_bkr_cashpile_04"),
        CashPosition["x"],
        CashPosition["y"],
        CashPosition["z"],
        false
    )
    PlaceObjectOnGroundProperly(CashPile)
    SetEntityRotation(CashPile, 0, 0, CashPosition["h"], 2)
    FreezeEntityPosition(CashPile, true)
    SetEntityAsMissionEntity(CashPile, true, true)

    Citizen.CreateThread(
        function()
            while robberyOngoing do
                Citizen.Wait(1)

                local Cash = BankHeists[bankId]["Money"]

                local ped = PlayerPedId()
                local pedCoords = GetEntityCoords(ped)
                local distanceCheck =
                    GetDistanceBetweenCoords(pedCoords, CashPosition["x"], CashPosition["y"], CashPosition["z"], false)

                if distanceCheck <= 1.5 then
                    if Cash > 0 then
                        Draw3DText2({x = CashPosition["x"], y = CashPosition["y"], z = CashPosition["z"]}, "[E] Pak " .. Cash)
                    else
                        Draw3DText2({x = CashPosition["x"], y = CashPosition["y"], z = CashPosition["z"]}, "Er ligt geen geld meer!")
                        DeleteEntity(CashPile)

                        BankHeists[bankId]["Money"] = 0
						Citizen.Wait(120000)
                        TriggerServerEvent("esx_bankrobbery:endRobbery", bankId)
					end
                    if IsControlJustPressed(0, Keys["E"]) then
                        if Cash > 0 then
                            if Cash < 20000 then
                            	GrabCash(bankId, Cash)
							else
                                GrabCash(bankId, math.random(20000, 35000))
							end
                        end
                    end
                end
            end
        end
    )
    Citizen.Wait(300000)
    TriggerEvent("esx_bankrobbery:endRobbery", bankId)
end

function GrabCash(bankId, cash)
    TaskPlayAnim(
        PlayerPedId(),
        "anim@heists@ornate_bank@grab_cash_heels",
        "grab",
        8.0,
        -8.0,
        -1,
        1,
        0,
        false,
        false,
        false
    )

    Citizen.Wait(7500)

    ClearPedTasks(PlayerPedId())

    local cashRecieved = cash

    TriggerServerEvent("esx_bankrobbery:grabbedCash", bankId, BankHeists[bankId]["Money"], cashRecieved)
end
function Draw3DText2(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        local textWidth = string.len(text) / 280 -- Adjust this value based on your text length and scale
        local textHeight = 0.035 -- Adjust as needed for your scale

        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropShadow(0, 0, 0, 55)
        SetTextEdge(0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)

        -- Draw background
        DrawRect(_x, _y + 0.0125, textWidth, textHeight, 0, 0, 0, 150) -- Background color and alpha

        -- Then draw the text
        DrawText(_x, _y)
    end
end
function loadAnimDict(dict)
    Citizen.CreateThread(
        function()
            while (not HasAnimDictLoaded(dict)) do
                RequestAnimDict(dict)

                Citizen.Wait(1)
            end
        end
    )
end

function loadModel(model)
    Citizen.CreateThread(
        function()
            while not HasModelLoaded(model) do
                RequestModel(model)
                Citizen.Wait(1)
            end
        end
    )
end
