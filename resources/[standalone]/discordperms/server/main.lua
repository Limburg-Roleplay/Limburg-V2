-- config 
local guildid = '1249792709774938172' -- voer hier je discord guild id neer
local botToken = 'MTI1NjkxNTQ4NjAwNDg3NTI2NA.Gw6-HF.448SlJFEFVmqEynnR7E_wMQDhdGIIBCOP66lqc' -- Voer hier je discord bot token in

local verplichtrol = false -- Verplicht een bepaalde rol om de server te kunnen joinen. true of false
local verplichtteRol = "1232268867376517122" -- Voer hier het id in van de verplichte rol, hiervoor moet verplichtrol op true staan.

local RoleConfig = {
	[1249792709774938177] = "user", -- zorg ervoor dat het woord "burger" altijd hetzelfde is in het client script
	[1263626786860961842] = "vipblackmarket",
	[1270079380164710513] = "vipcardealer",
	[1249792709791842316] = "staff",
	[1258841221678497833] = "refunds",
	[1249792709808361540] = "hogerop",
	[1249792709825269792] = "owner"

}

-- server code
local FormattedToken = "Bot " .. botToken
function getdiscordroles(_source)
	local roleIDs = nil
	if ratelimiter[_source] then
		Wait(5000)
		getdiscordroles(_source)
		return
	else
		roleIDs = GetDiscordRoles(_source)
		ratelimiter[_source] = 1
		Citizen.Wait(5000)
		ratelimiter[_source] = nil
	end
	return roleIDs
end

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetDiscordRoles(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break;
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(guildid, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			return roles
		else
			return false
		end
	else
		return false
	end
	return false
end

local ratelimiter = {}
function getdiscordroles(_source)
	local roleIDs = nil
	if ratelimiter[_source] then
		Wait(5000)
		getdiscordroles(_source)
		return
	else
		roleIDs = GetDiscordRoles(_source)
		ratelimiter[_source] = 1
		Citizen.Wait(5000)
		ratelimiter[_source] = nil
	end
	return roleIDs
end

function ExtractIdentifiers(src)
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "discord") then
			return id
		end
	end
	return nil
end

RegisterServerEvent('sts_discordperms:getplayerroles')
AddEventHandler('sts_discordperms:getplayerroles', function()
	local src = source
	local identifierDiscord = ExtractIdentifiers(src)
	if identifierDiscord then
		local roleIDs = getdiscordroles(src)
		if not (roleIDs == false) then
			local allrolelist = {}
			for i,v in pairs(RoleConfig) do
				allrolelist[v] = false
			end

			for i,v in pairs(roleIDs) do
				local discordroleid = tonumber(v)
				local foundconfig = RoleConfig[discordroleid]
				if foundconfig then
					allrolelist[foundconfig] = true
				end
			end

			TriggerClientEvent("sts_discordperms:setplayerroles", src, allrolelist)
		end
	end
end)

if verplichtrol then
	local ratelimiter = {}
	AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
		deferrals.defer();
		local hasrole = false
		local roleIDs = getdiscordroles(source);
		if not (roleIDs == false) then
			for j = 1, #roleIDs do
				if (tostring(verplichtteRol) == tostring(roleIDs[j])) then
					hasrole = true
				end
			end
		end
		if hasrole == true then
			deferrals.done()
		else
			deferrals.done("Discord Whitelist: Om op onze server te kunnen spelen ben je verplicht om in onze discord te zitten en een burger rol te hebben: https://discord.gg/");
			CancelEvent();
		end
	end)
end