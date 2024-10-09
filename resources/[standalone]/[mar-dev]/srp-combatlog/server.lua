local ESX = exports["es_extended"]:getSharedObject()

RegisterCommand("combatlog", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if Config.enableargs and args[1] then
        local targetId = tonumber(args[1])
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        
        if targetPlayer then
            TriggerClientEvent('sts:getcombatcache', targetId, targetId)
        else
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 0.6); border-radius: 3px;"><b>Error:</b> Speler niet gevonden</div>'
            })
        end
    else
        TriggerClientEvent('sts:getcombatcache', source, source)
    end
end, false)

RegisterNetEvent("sts:combatlog_sendback")
AddEventHandler("sts:combatlog_sendback", function(from, data, currenttime)
    local source = source
    TriggerClientEvent("sts:combatlog_receive", from, source, from, data, currenttime)
end)

RegisterNetEvent("sts:syncinstakill")
AddEventHandler("sts:syncinstakill", function(attackerId, data)
    TriggerClientEvent("sts:syncinstakilltarget", attackerId, data)
end)
