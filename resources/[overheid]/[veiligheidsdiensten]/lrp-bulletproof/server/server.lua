ESX = exports['es_extended']:getSharedObject()
RegisterServerEvent('mr-bulletproof:create')
AddEventHandler('mr-bulletproof:create', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent(
        "td_logs:sendLog",
        "https://discord.com/api/webhooks/1268585921587052604/IdB3J2wbfees6rsDxGQhpxKIrBBG11cL25ItpO1SdOPhiZwvMEHzBO0uKni2b0qhOJ3Y",
        xPlayer.source,
        {
            title = GetPlayerName(xPlayer.source) .. ' heeft zojuist een bulletproof vest gebruikt!',
            desc = "Job: Politie"
        },
        0x000001
    )
end)