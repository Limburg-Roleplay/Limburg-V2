RegisterNetEvent("lrp-notify")
AddEventHandler("lrp-notify", function(type, msg, duration, use_sound)
	Alert(type, msg, duration, use_sound)
end)

function Alert(type, msg, duration, use_sound)
	TriggerClientEvent("lrp-notify", source, type, msg, duration, use_sound)
end