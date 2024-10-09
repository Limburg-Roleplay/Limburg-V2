function Notification(source, notif_type, message)
    if source and notif_type and message then
        if Config.NotificationType.client == 'esx' then
            TriggerClientEvent('esx:showNotification', source, message)

        elseif Config.NotificationType.client == 'chat' then
            TriggerClientEvent('chatMessage', source, message)

        elseif Config.NotificationType.client == 'okok' then
            if notif_type == 1 then
                TriggerClientEvent('okokNotify:Alert', source, 'Succes', message, 5000, 'success')
            elseif notif_type == 2 then
                TriggerClientEvent('okokNotify:Alert', source, 'Informatie', message, 5000, 'info')
            elseif notif_type == 3 then
                TriggerClientEvent('okokNotify:Alert', source, 'Fout', message, 5000, 'error')
            end
        end
    end
end
