Citizen.CreateThread(function()    
        TriggerEvent('chat:addSuggestion', '/giverefund', _U('description_giverefund'), {
            { name="steam-id", help= _U('help_text_message_steamid') },
            { name="item name", help = _U('help_text_message_itemname') },
            { name="item count", help = _U('help_text_message_itemcount')}
        })
        TriggerEvent('chat:addSuggestion', '/claimrefunds', _U('description_claim'), {})
end)

