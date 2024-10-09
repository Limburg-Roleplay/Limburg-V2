 --[[

ESX RP Chat

--]]

function GetCoords()
	if NetworkIsInSpectatorMode() then
		return GetFinalRenderedCamCoord()
	else
		return GetEntityCoords(PlayerPedId())
	end
end

local msgTypes = {
	[1] = "is gecrasht!",
	[2] = "is de connectie verloren!",
	[3] = "is gecombatlogged!"
}
RegisterNetEvent("chat:crashMessage")
AddEventHandler("chat:crashMessage", function(msgType, name, coords)
	local pedCoords = GetCoords()
	if #(pedCoords - coords) < 50 then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b><font color=grey></b></font> <b>{0}</b> {1}</div>',
			args = { name, msgTypes[msgType] }
		})
	elseif #(pedCoords - coords) < 200 then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b><font color=grey></b></font> <b>{0}</b> {1}</div>',
			args = { name, msgTypes[msgType] }
		})
	elseif IsAdmin or #(pedCoords - coords) < 300 then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b><font color=grey></b></font> <b>{0}</b> {1}</div>',
			args = { name, msgTypes[msgType] }
		})
	end
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	local coords = GetCoords()

	if pid == myId then
		TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
	elseif pid ~= -1 and #(coords - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
		TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
	end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	local coords = GetCoords()

	if pid == myId then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	elseif pid ~= -1 and #(coords - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	local coords = GetCoords()

	if pid == myId then
		TriggerEvent('chatMessage', "", {81, 245, 66}, " ^0* " .. name .."  ".."^0  " .. message)
	elseif pid ~= -1 and #(coords - GetEntityCoords(GetPlayerPed(pid))) < 19.999 then
		TriggerEvent('chatMessage', "", {81, 245, 66}, " ^0* " .. name .."  ".."^0  " .. message)
	end
end)

function IsLocal(pid, myId, range)
	range = range or 15.4
	local coords = GetCoords()
	if pid == myId then
		return true
	end
	if pid == -1 then
		return false
	end
	if #(coords - GetEntityCoords(GetPlayerPed(pid))) < range then
		return true
	end
end

local function getPlayerFromChange(bagName)
	local player = bagName:gsub("player:", "")
	player = tonumber(player)

	return player
end

RegisterNetEvent('esx-qalle-chat:me', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)

	if IsLocal(pid, myId) then
		TriggerEvent('chat:addMessage', {
			template = '<div class="bubble-message" style="background-color: rgba(255, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> <b>{0}:</b> {1}</div>',
			args = { name, message }
		})
	end
end)

RegisterNetEvent('esx-qalle-chat:do', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)

	if IsLocal(pid, myId) then
		TriggerEvent('chat:addMessage', {
			template = '<div class="bubble-message" style="background-color: rgba(81, 245, 66, 0.6); border-radius: 3px;"><i class="fas fa-user-circle"></i> <b>{0}:</b> {1}</div>',
			args = { name, message }
		})
	end
end)

RegisterNetEvent('esx-qalle-chat:looc', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)

	if IsLocal(pid, myId, 50.0) then
		TriggerEvent('chat:addMessage', {
			template = '<div class="bubble-message" style="background-color: rgba(41, 41, 41, 0.6); border-radius: 3px;"><i class="fas fa-globe"></i> <b><font color=grey>LOOC</b></font> <b>{0}:</b> {1}</div>',
			args = { name, message }
		})
	end
end)

function PrintFancyMessage(name, message, formatting)
	formatting = formatting or {}
	formatting.r = formatting.r or 41
	formatting.g = formatting.g or 41
	formatting.b = formatting.b or 41
	formatting.a = formatting.a or 0.6

local template = ('<div class="bubble-message" style="background-color: rgba(255, 255, 0, 255);"><b>{0}:</b> {1}</div>'):format(formatting.r, formatting.g, formatting.b, formatting.a)

	TriggerEvent('chat:addMessage', {
		template = template,
		args = { name, message },
		important = formatting and formatting.important or nil
	})
end

function SendReply(message, resource, formatting)
    if type(message) == "table" then
        resource = message.resource
        formatting = message.formatting
        message = message.message
    end
	formatting = formatting or {}
	if type(formatting) == "table" then
		formatting.important = true
	end

    resource = resource or GetInvokingResource()
    PrintFancyMessage(resource, message, formatting)
end

exports('printToChat', PrintFancyMessage)
exports('PrintToChat', PrintFancyMessage)

exports("SendReply", SendReply)
