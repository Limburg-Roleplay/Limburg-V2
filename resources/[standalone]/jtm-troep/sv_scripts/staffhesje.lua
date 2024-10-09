RegisterCommand(
    "staffvest",
    function(source, args)
        local src = source
       	TriggerClientEvent("xadmin:staffvest", source, ESX.GetPlayerFromId(src).getGroup())
    end
)