local Jobs = {}
local RegisteredSocieties = {}

function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

AddEventHandler('onResourceStart', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		local result = exports.oxmysql:executeSync('SELECT * FROM jobs')

		for i = 1, #result, 1 do
			Jobs[result[i].name] = result[i]
			Jobs[result[i].name].grades = {}
		end
	end
end)


-- RegisterNetEvent('vesx_jobsmenu:server:toggleDuty')
-- AddEventHandler('vesx_jobsmenu:server:toggleDuty', function(jobname)
-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	if xPlayer then
-- 		local duty = exports["vesx_jobsmenu"]:getDuty(xPlayer.identifier)
-- 		exports["vesx_jobsmenu"]:setDuty(xPlayer.identifier, not duty)
-- 		if Config.FiveLogs then
-- 			LogInfo = {["message"] = xPlayer.getName() .."" ..not duty}
-- 			exports["five-logs"]:addLog("duty-logs", LogInfo)
-- 		end
-- 	end
-- end)

ESX.RegisterServerCallback('vesx_jobsmenu:server:manageEmployee', function(source, cb, actionType, job, grade, identifier)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.job.grade_name == 'boss'
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if isBoss then

		if xTarget then
			xTarget.setJob(job, grade)

			if actionType == 'hire' then
				xTarget.showNotification(TranslateCap('sv_you_have_promoted', job))
				xPlayer.showNotification(TranslateCap("sv_you_have_hired", xTarget.getName()))
			elseif actionType == 'updated_grade' then
				xTarget.showNotification(TranslateCap('sv_you_have_been_promoted'))
				xPlayer.showNotification(TranslateCap("sv_you_have_promoted", xTarget.getName(), xTarget.getJob().label))
			elseif actionType == 'fire' then
				xTarget.showNotification(TranslateCap('sv_you_havev_fired', xTarget.getJob().label))
				xPlayer.showNotification(TranslateCap("sv_you_have_fired", xTarget.getName()))
			end
			-- if Config.FiveLogs then
			-- 	LogInfo = {["message"] = xPlayer.getName() .." "..actionType .." "..xTarget.getName()}
			-- 	exports["five-logs"]:addLog("jobslog", LogInfo)
			-- end

			cb()
		else
			MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {job, grade, identifier},
			function(rowsChanged)
				cb()
			end)
		end
	else
		print(('[^3WARNING^7] Player ^5%s^7 attempted to setJob for Player ^5%s^7!'):format(source, xTarget.source))
		cb()
	end
end)


ESX.RegisterServerCallback('vesx_bossmenu:server:get:employees', function(source, cb, society)
	local employees = {}

	local xPlayers = ESX.GetExtendedPlayers('job', society)
	for i=1, #(xPlayers) do 
		local xPlayer = xPlayers[i]

		local name = xPlayer.name
		if Config.EnableESXIdentity and name == GetPlayerName(xPlayer.source) then
			name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
		end

		table.insert(employees, {
			name = name,
			identifier = xPlayer.identifier,
			job = {
				name = society,
				label = xPlayer.job.label,
				grade = xPlayer.job.grade,
				grade_name = xPlayer.job.grade_name,
				grade_label = xPlayer.job.grade_label
			}
		})
	end
		
	local query = "SELECT identifier, job_grade FROM `users` WHERE `job`= ? ORDER BY job_grade DESC"

	if Config.EnableESXIdentity then
		query = "SELECT identifier, job_grade, firstname, lastname FROM `users` WHERE `job`= ? ORDER BY job_grade DESC"
	end

	MySQL.query(query, {society},
	function(result)
		for k, row in pairs(result) do
			local alreadyInTable
			local identifier = row.identifier

			for k, v in pairs(employees) do
				if v.identifier == identifier then
					alreadyInTable = true
				end
			end

			if not alreadyInTable then
				local name = "Name not found." -- maybe this should be a locale instead ¯\_(ツ)_/¯

				if Config.EnableESXIdentity then
					name = row.firstname .. ' ' .. row.lastname 
				end
				print(society, Jobs[society].label)
				print(row.job_grade)
				-- print(Jobs[society].grades[row.job_grade].name)
				table.insert(employees, {
					name = name,
					identifier = identifier,
					job = {
						name = society,
						label = Jobs[society].label,
						grade = row.job_grade,
						grade_name = Jobs[society].grades[tostring(row.job_grade)].name,
						grade_label = Jobs[society].grades[tostring(row.job_grade)].label
					}
				})
			end
		end

		cb(employees)
	end)

end)

ESX.RegisterServerCallback('vesx_jobsmenu:getJobGrades', function(source, cb, society)
	local job = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		print(grades, v)
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	cb(job)
end)


local getOnlinePlayers, onlinePlayers = false, {}
ESX.RegisterServerCallback('vesx_jobsmenu:getOnlinePlayers', function(source, cb)
	if getOnlinePlayers == false and next(onlinePlayers) == nil then -- Prevent multiple xPlayer loops from running in quick succession
		getOnlinePlayers, onlinePlayers = true, {}
		local xPlayers = ESX.GetExtendedPlayers()
		for i=1, #(xPlayers) do 
			-- print(xPlayer.job)
			local xPlayer = xPlayers[i]
			table.insert(onlinePlayers, {
				source = xPlayer.source, 
				identifier = xPlayer.identifier, 
				name = xPlayer.name, 
				firstname = xPlayer.firstname, 
				lastname = xPlayer.lastname, 
				job = xPlayer.job
			})
		end
		cb(onlinePlayers)
		getOnlinePlayers = false
		Wait(1000) -- For the next second any extra requests will receive the cached list
		onlinePlayers = {}
		return
	end
	while getOnlinePlayers do Wait(0) end -- Wait for the xPlayer loop to finish
	cb(onlinePlayers)
end)