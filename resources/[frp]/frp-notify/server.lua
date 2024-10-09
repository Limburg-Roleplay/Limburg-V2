RegisterNetEvent("frp-notify")
AddEventHandler("frp-notify", function(type, msg, duration, use_sound)
	Alert(type, msg, duration, use_sound)
end)

function Alert(type, msg, duration, use_sound)
	TriggerClientEvent("frp-notify", source, type, msg, duration, use_sound)
end