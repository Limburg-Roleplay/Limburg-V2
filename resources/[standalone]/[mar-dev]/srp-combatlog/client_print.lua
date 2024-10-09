stscombatlogcache = {}

function removeFallData(data, time)
    for k,v in pairs(stscombatlogcache) do
        if v.time - time < 10000 then
            if v.weapon == "WEAPON_FALL" then
                table.remove(stscombatlogcache, k)
            end
        end
    end
end

function addcombatcache(data, time)
    if data.skipFall then
        removeFallData(data, time)
    end

    table.insert(stscombatlogcache, { 
        time = time, 
        attackerId = data.attackerId, 
        victimId = data.victimId, 
        health = data.health, 
        newHealth = data.newHealth,
        distance = data.distance, 
        speedAttacker = data.speedAttacker,
        speedVictim = data.speedVictim,
        weapon = data.weapon,
        bone = data.bone
    })
end

RegisterNetEvent("sts:syncinstakilltarget", function(data)
    addcombatcache(data, GetGameTimer())
end)

RegisterNetEvent('sts:getcombatcache')
AddEventHandler('sts:getcombatcache', function(sourcee, from)
    local currenttime = GetGameTimer()
    if from ~= nil then
        TriggerServerEvent("sts:combatlog_sendback", from, stscombatlogcache, currenttime)
        return
    end
	local defaultmsg = ("attacker       victim      where                             damage       oldhealth    newHealth       distance       weapon                                     a. speed      v. speed    time")
    local founddata = false
    for k,v in pairs(stscombatlogcache) do
        if sourcee == v.attackerId or sourcee == v.victimId then
			local atack = math.floor(v.attackerId).." ["..v.attackerId.."]"
			local devend = math.floor(v.victimId).." ["..v.victimId.."]"
			if sourcee == v.attackerId then
				atack = "me"
			end
			if sourcee == v.victimId then
				devend = "me"
			end

            attackid = string.format("%-15s", tostring(atack))
            victimid = string.format("%-12s", tostring(devend))
            damage = string.format("%-13s", tostring(math.floor(v.health - v.newHealth)))
            oldhealth = string.format("%-13s", tostring(math.floor(v.health)))
            newhealth = string.format("%-16s", tostring(math.floor(v.newHealth)))
            distance = string.format("%-15s", tostring(math.floor(v.distance)))
            local temptime = currenttime - v.time
            local temptime2 = temptime / 1000
            timeago = string.format("%-10s", tostring(math.floor(temptime2)))
            aspeed = string.format("%-14s", tostring(math.floor(v.speedAttacker)))
            vspeed = string.format("%-12s", tostring(math.floor(v.speedVictim)))
            weapon = string.format("%-43s", tostring(v.weapon))
            bone = string.format("%-34s", tostring(v.bone))
            local msg = ("%s%s%s%s%s%s%s%s%s%s%s"):format(attackid, victimid, bone, damage, oldhealth, newhealth, distance, weapon, aspeed, vspeed, timeago)
            if founddata == false then
                founddata = true
                TriggerEvent('okokNotify:Alert', 'Combatlog', 'Combatlog is succesvol naar je console geprint. Gebruik de F8 spier om deze te openen.', 3000, 'success')
                -- TriggerEvent("chat:serverPrint", defaultmsg)
                print(defaultmsg)
            end
			TriggerEvent("chat:serverPrint", msg)
        end
    end
    if founddata == false then
        TriggerEvent('okokNotify:Alert', 'Combatlog', 'Er kan geen combatlog gevonden worden.', 3000, 'error')
    end
end)

RegisterNetEvent("sts:combatlog_receive", function(sourcee, requestplayer, data, currenttime)
	local defaultmsg = ("attacker       victim        where                           damage       oldhealth    newHealth       distance       weapon                                     a. speed      v. speed    time")
    local founddata = false
    for k,v in pairs(data) do
        if sourcee == v.attackerId or sourcee == v.victimId then
			local atack = math.floor(v.attackerId).." ["..v.attackerId.."]"
			local devend = math.floor(v.victimId).." ["..v.victimId.."]"
			if requestplayer == v.attackerId then
				atack = "Me"
			end
			if requestplayer == v.victimId then
				devend = "Me"
			end

            attackid = string.format("%-15s", tostring(atack))
            victimid = string.format("%-14s", tostring(devend))
            damage = string.format("%-13s", tostring(math.floor(v.health - v.newHealth)))
            oldhealth = string.format("%-13s", tostring(math.floor(v.health)))
            newhealth = string.format("%-16s", tostring(math.floor(v.newHealth)))
            distance = string.format("%-15s", tostring(math.floor(v.distance)))
            local temptime = currenttime - v.time
            local temptime2 = temptime / 1000
            timeago = string.format("%-10s", tostring(math.floor(temptime2)))
            aspeed = string.format("%-14s", tostring(math.floor(v.speedAttacker)))
            vspeed = string.format("%-12s", tostring(math.floor(v.speedVictim)))
            weapon = string.format("%-43s", tostring(v.weapon))
            bone = string.format("%-32s", tostring(v.bone))
            local msg = ("%s%s%s%s%s%s%s%s%s%s%s"):format(attackid, victimid, bone, damage, oldhealth, newhealth, distance, weapon, aspeed, vspeed, timeago)
            if founddata == false then
                founddata = true
                TriggerEvent('okokNotify:Alert', 'Combatlog', 'Combatlog is succesvol naar je console geprint. Gebruik de F8 spier om deze te openen.', 3000, 'success')
                TriggerEvent("chat:serverPrint", defaultmsg)
            end
			TriggerEvent("chat:serverPrint", msg)
        end
    end
    if founddata == false then
        TriggerEvent('okokNotify:Alert', 'Combatlog', 'Er kan geen combatlog gevonden worden..', 3000, 'error')
    end
end)

function sts_ChatMessage(name, message, formatting)
	formatting = formatting or {}
	formatting.r = formatting.r or 41
	formatting.g = formatting.g or 41
	formatting.b = formatting.b or 41
	formatting.a = formatting.a or 0.6

	local template = ('<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(%s, %s, %s, %s); border-radius: 3px;"><b>{0}:</b> {1}</div>'):format(formatting.r, formatting.g, formatting.b, formatting.a)

	TriggerEvent('chat:addMessage', {
		template = template,
		args = { name, message },
		important = formatting and formatting.important or nil
	})
end
