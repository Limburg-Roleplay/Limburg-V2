-- config
local refreshCommand = "refreshdp" -- command naam van discord perms refresh

local allrolelist = {
    hasusergroup = false,
    hasvipblackmarketgroup = false,
    hasvipcardealergroup = false,
    hasstaffgroup = false,
    hasrefundsgroup = false,
    hashogeropgroup = false,
    hasownergroup = false,
}

RegisterNetEvent('sts_discordperms:setplayerroles')
AddEventHandler('sts_discordperms:setplayerroles', function(playerdata)
    for i,v in pairs(playerdata) do
        if v == true then
            print("you are added te the ^5"..i.."^0 group")
        end
    end

    allrolelist.hasusergroup = playerdata["user"]
    allrolelist.hasvipblackmarketgroup = playerdata["vipblackmarket"]
    allrolelist.hasvipcardealergroup = playerdata["vipcardealer"]
    allrolelist.hasstaffgroup = playerdata["staff"]
    allrolelist.hasrefundsgroup = playerdata["refunds"]
    allrolelist.hashogeropgroup = playerdata["hogerop"]
    allrolelist.hasownergroup = playerdata["owner"]

    TriggerEvent("refreshdcroles")
end)


-- client
Citizen.CreateThread(function()
    print("^3refreshing roles...") 
    TriggerServerEvent("sts_discordperms:getplayerroles")
end)

RegisterCommand(refreshCommand, function (source, args, raw)
    print("^3refreshing roles...") 
    TriggerServerEvent("sts_discordperms:getplayerroles")
end)

for i,v in pairs(allrolelist) do
    exports(i, function()
        return allrolelist[i]
    end)
end

exports("allroles", function()
    return allrolelist
end)

RegisterNetEvent('refreshdcroles')
AddEventHandler('refreshdcroles', function()
    -- dit kan je gebruiken om scripts te refreshen wanneer je /refreshdp typt
    print("^2roles refreshed!") 
end)



-- voorbeeld client export
-- exports["sts_discordperms"]:hasburgergroup()
-- if exports["sts_discordperms"]:hasburgergroup() then
--     print("ja")
-- else
--     print("nee")
-- end