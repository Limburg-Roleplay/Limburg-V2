local hurted = false

TriggerEvent('chat:addSuggestion', '/twt', 'Verstuur een chatter bericht!')

Citizen.CreateThread(function()
	while true do
		Wait(500)
        local ped = PlayerPedId()
		if not CrouchedForce then 
			if GetEntityHealth(ped) <= 120 then
				setHurt(ped)
				hurted = true
			elseif hurted and GetEntityHealth(ped) > 121 then
				hurted = false
				setNotHurt(ped)
			end
		end
	end
end)

function setHurt(ped)
	RequestAnimSet("move_m@injured")
	SetPedMovementClipset(ped, "move_m@injured", true)
end

function setNotHurt(ped)
	ResetPedMovementClipset(ped)
	ResetPedWeaponMovementClipset(ped)
	ResetPedStrafeClipset(ped)
end