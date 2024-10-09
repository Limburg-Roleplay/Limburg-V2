RegisterNetEvent("frp-notify")
AddEventHandler("frp-notify", function(type, msg, duration, use_sound)
	Alert(type, msg, duration, use_sound)
end)

function Alert(type, msg, duration, use_sound)
	SendNUIMessage({ 
		notification = msg,
		notification_type = type,
		duration = duration ~= nil and duration or 4000,
		action_type = 'playSound',
		use_sound = use_sound ~= nil and use_sound or false,
	})
end