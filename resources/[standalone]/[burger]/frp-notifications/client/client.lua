Notification = function(messagetype, description, ms)
    local messagetype = messagetype ~= nil and messagetype or 'error'
    local description = description ~= nil and description or 'Geen verhaal toegevoegd.'
    local ms = type(ms) == 'number' and ms or 3500

    SendNUIMessage({
        type = 'createNotification',
        information = {
            type = messagetype,
            text = description,
            time = ms
        }
    })
end

RegisterNetEvent('frp-notifications:client:notify')
AddEventHandler('frp-notifications:client:notify', Notification)

RegisterNetEvent('ox_lib:notify')
AddEventHandler('ox_lib:notify', function(info)
    Notification(info.type, info.description, info.time)
end)

exports('notify', Notification)
exports('Notify', Notification)
exports('notification', Notification)
exports('Notification', Notification)

CreateThread(function()
    while true do
        Wait(0)

        ClearVehiclePhoneExplosiveDevice()
    end
end)