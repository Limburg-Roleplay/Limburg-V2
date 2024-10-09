Citizen.CreateThread(function()    
        TriggerEvent('chat:addSuggestion', '/giverefund', 'description_giverefund', {
            { name="steam-id", help= 'help_text_message_steamid' },
            { name="item name", help = 'help_text_message_itemname' },
            { name="item count", help = 'help_text_message_itemcount'}
        })
        TriggerEvent('chat:addSuggestion', '/claimrefunds', 'description_claim', {})
end)

