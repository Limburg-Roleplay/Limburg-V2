local FRP = {}


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	ESX.PlayerData = PlayerData
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(Job)
	ESX.PlayerData.job = Job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(Job2)
	ESX.PlayerData.job2 = Job2
end)


-- functions
FRP.OpenManagementMenu = function(job)

	if type(job) == 'table' then
		job = job.name
	end
	
	lib.registerMenu({
		id = 'vesx_jobsmenu:managementMenu',
		title = 'Management',
		position = 'top-right',
		options = {
			{
				label = 'Werknemerlijst bekijken',
				icon = "people-group",
				description = 'Bekijk en beheer alle werknemers',
				args = {functionDefine = EmployeeManagement, job = job}
			},
			-- {
			-- 	label = 'Financiën',
			-- 	icon = "euro-sign",
			-- 	description = 'Bekijk en beheer het geld',
			-- 	args = {functionDefine = FinancialManagement, job = job}
			-- },
			{
				label = 'Werknemer aannemen',
				icon = "plus",
				description = 'Neem nieuwe werknemers aan',
				args = {functionDefine = HireEmployeeManagment, job = job}
			},
			{
				label = 'Reset Uren',
				icon = "xmark",
				description = 'Reset Dienst Uren',
				args = {functionDefine = ResetHours, job2 = job2}
			}
		}
	}, function(selected, scrollIndex, args)
		if args.functionDefine ~= nil then
			args.functionDefine(job)
		end
	end)

	lib.showMenu("vesx_jobsmenu:managementMenu")
end
exports('OpenManagementMenu', FRP.OpenManagementMenu)

EmployeeManagement = function(job)

	ESX.TriggerServerCallback('vesx_jobsmenu:getJobGrades', function(jobGrades) 

		ESX.TriggerServerCallback('vesx_bossmenu:server:get:employees',function(cb)
			if cb then
				local employees = {}
				employees[#employees + 1] = {label = 'Aantal werknemers: ', icon = "hashtag"}
				employees[#employees + 1] = {label = 'Terug', icon = "arrow-left", args = {action = "back"}}
			
				for k, v in pairs(cb) do
					if v.callsign == nil then v.callsign = 0 end

					employees[#employees+1] = {
						label = v.name,
						icon = "person",
						description = 'Rang: ' .. jobGrades.grades[tonumber(v.job.grade) + 1].label,
						args = {identifier = v.identifier, name = v.name, grade = v.job.grade, firstname = v.firstname, lastname = v.lastname, job = job}
					}
				end
			
				if #employees == 2 then
					employees[#employees + 1] = {label = TranslateCap('cl_noemployees')}
				end
			
				lib.registerMenu({
					id = 'vesx_jobsmenu:employeeManagement',
					title = 'Werknemerlijst',
					position = 'top-right',
					onClose = function()
						lib.showMenu('vesx_jobsmenu:managementMenu')
					end,
					options = employees
				}, function(selected, scrollIndex, args)
					if args ~= nil then
						if args.action ~= nil then
							if args.action == 'back' then lib.showMenu("vesx_jobsmenu:managementMenu") end
						else
							if args.name ~= GetPlayerName(PlayerId()) then
								OpenEmployee(args)
							else
								lib.showMenu("vesx_jobsmenu:employeeManagement")
							end
						end
					else
						lib.showMenu("vesx_jobsmenu:employeeManagement")
					end
				end)
			
				lib.showMenu("vesx_jobsmenu:employeeManagement")
			end
		end, job)
	end, job)
end

OpenEmployee = function(employee)
	local grades = {}

	ESX.TriggerServerCallback('vesx_jobsmenu:getJobGrades', function(jobGrades)
  
		for k,v in pairs(jobGrades.grades) do
			if tonumber(v.grade) ~= tonumber(employee.grade) then
				grades[#grades + 1] = {label = v.label, description = 'Verander rang naar ' .. v.label}
			end
		end
  
		lib.registerMenu({
			id = 'vesx_jobsmenu:manageEmployee',
			title = employee.name,
			position = 'top-right',
			onClose = function()
				lib.showMenu('vesx_jobsmenu:employeeManagement')
			end,
			options = {
				{
					label = 'Rang veranderen',
					icon = "exchange-alt",
					description = 'Verander de rang',
					values = grades,
					args = {action = 'grade'}
				},
				{
					label = 'Ontslaan',
					icon = "door-open",
					description = 'Stop het arbeidscontract',
					args = {action = 'fire'}
				},
				{
					label = 'Terug',
					icon = "arrow-left",
					args = {action = 'back'}
				}
			}
		}, function(selected, scrollIndex, args)
	
			if args.action == 'back' then
				lib.showMenu("vesx_jobsmenu:employeeManagement")
			else
				local newGrade = nil
				if args.action == 'grade' then
					for i=1, #jobGrades.grades do
						if grades[scrollIndex].label == jobGrades.grades[i].label then
							newGrade = jobGrades.grades[i].grade
						end
					end
				end
		
				local function ChangeEmployee()
					ESX.TriggerServerCallback('vesx_jobsmenu:server:manageEmployee', function(success, task, err)
						if success then
							if task == 'updated_grade' then
								employee.grade = newGrade
								EmployeeManagement(employee.job)
							elseif task == 'fired_employee' then
								EmployeeManagement(employee.job)
							end
						else
							ESX.ShowNotification(err, 'error', 5000)
							OpenEmployee(employee)
						end
					end, args.action, employee.job, newGrade, employee.identifier)
				end
			
				ChangeEmployee()
			end
		end)

		lib.showMenu("vesx_jobsmenu:manageEmployee")
	end, employee.job)
end

--[[ FinancialManagement = function(job)
	ESX.TriggerServerCallback('vesx_jobsmenu:getSocietyFunds', function(currentMoney)

		local formatNumber = (function (n) n = tostring(n) return n:reverse():gsub("%d%d%d", "%1."):reverse():gsub("^,", "") end)
	
		lib.registerMenu({
		  id = 'vesx_jobsmenu:financialManagement',
		  title = TranslateCap('cl_emplo_geld'),
		  position = 'top-right',
		  onClose = function()
			lib.showMenu('vesx_jobsmenu:managementMenu')
		  end,
		  options = {
			{
			  label = TranslateCap('cl_emplo_huidigegeld', formatNumber(currentMoney)), 
			  icon = "euro-sign"
			},
			{
			  label = TranslateCap('cl_geldstorten'),
			  icon = "money-bill-transfer",
			  description = 'Verander het roepnummer',
			  args = {action = 'withdraw'}
			},
			{
			  label = TranslateCap('cl_geldopnemen'),
			  icon = "money-bill-transfer",
			  args = {action = 'deposit'}
			},
			{
			  label = TranslateCap('cl_employee_back'),
			  icon = "arrow-left",
			  args = {action = "back"}
			},
		}
		}, function(selected, scrollIndex, args)
			if args ~= nil then
			  if args.action == 'back' then
				lib.showMenu("vesx_jobsmenu:managementMenu")
			  else
				if args.action == 'withdraw' then
	
				else
	
				end
			  end
			else
			  lib.showMenu("vesx_jobsmenu:financialManagement")
			end
		end)
	
		lib.showMenu("vesx_jobsmenu:financialManagement")
		
	  end, job)
end ]]

HireEmployeeManagment = function(job, searchedPlayers)
  ESX.TriggerServerCallback('vesx_jobsmenu:getOnlinePlayers', function(players)

	local players = players
	local playerTable = {}

	if searchedPlayers ~= nil and next(searchedPlayers) ~= nil then
		players = searchedPlayers
	else
		playerTable[#playerTable + 1] = {label = 'Zoeken', icon = "search", description = 'Zoeken op ID of steamnaam', args = {action = "search"}}
	end

    playerTable[#playerTable + 1] = {label = 'Terug', icon = "arrow-left", args = {action = "back"}}

    for i=1, #players, 1 do
		if players[i].firstname and players[i].lastname and players[i].job.name == 'unemployed' then
			playerTable[#playerTable + 1] = {
			label = players[i].firstname .. ' ' .. players[i].lastname,
			icon = "plus",
			description = players[i].firstname .. ' ' .. players[i].lastname .. ' aannemen',
			args = {source = players[i].source, identifier = players[i].identifier, name = players[i].name, firstname = players[i].firstname, lastname = players[i].lastname, job = job}
			}
		end
    end

    if #playerTable == 1 then
      	playerTable[#playerTable + 1] = {label = TranslateCap('cl_geenburger')}
    end

    lib.registerMenu({
		id = 'vesx_jobsmenu:hireEmployees',
		title = 'Werknemers aannemen',
		position = 'top-right',
		onClose = function()
			lib.showMenu('vesx_jobsmenu:managementMenu')
		end,
		options = playerTable
    }, function(selected, scrollIndex, args)
        if args ~= nil then
			if args.action == 'back'  then
				if searchedPlayers ~= nil and next(searchedPlayers) ~= nil then
					HireEmployeeManagment(job)
				else
					lib.showMenu("vesx_jobsmenu:managementMenu")
				end
			elseif args.action == 'search' then
				FRP.SearchPlayerDialogue(job, players)
			else
				ESX.TriggerServerCallback('vesx_jobsmenu:server:manageEmployee', function(success, task, err)
					if success then
						if task == 'updated_grade' then
							EmployeeManagement(job)
						end
					else
						ESX.ShowNotification(err, 'error', 5000)
						HireEmployeeManagment(job)
					end
				end, 'hire', 0, {['identifier'] = args['identifier']}, args)
			end
        end
    end)

    lib.showMenu("vesx_jobsmenu:hireEmployees")
    
  end)
end

FRP.SearchPlayerDialogue = function(job, fullPlayers)
	local input = lib.inputDialog('Persoon zoeken', {
		{ type = "input", label = "Achternaam (vereist)"},
		{ type = "number", label = "ID (optioneel)", default = 0 }
	})

	if input ~= nil then
		local lastName = string.lower(input[1])
		local playerId = tonumber(input[2])
		local found = false

		local searchedPlayers = {}

		for i=1, #fullPlayers, 1 do
			print(fullPlayers[i].lastname)
			if playerId ~= nil and fullPlayers[i].source == playerId then
				print('found id')
				found = true
				searchedPlayers[#searchedPlayers + 1] = {
					source = fullPlayers[i].source,
					identifier = fullPlayers[i].identifier,
					name = fullPlayers[i].name,
					firstname = fullPlayers[i].firstname,
					lastname = fullPlayers[i].lastname,
					job = fullPlayers[i].job
				}

				HireEmployeeManagment(job, searchedPlayers)

				return
			elseif lastName ~= nil and string.match(string.lower(fullPlayers[i].lastname), lastName) then
				print('found lastname')
				found = true
				searchedPlayers[#searchedPlayers + 1] = {
					source = fullPlayers[i].source,
					identifier = fullPlayers[i].identifier,
					name = fullPlayers[i].name,
					firstname = fullPlayers[i].firstname,
					lastname = fullPlayers[i].lastname,
					job = fullPlayers[i].job
				}

				HireEmployeeManagment(job, searchedPlayers)

				return
			else
				found = false
			end
		end

		if not found then
			ESX.ShowNotification(TranslateCap('cl_niks'), 'error', 5000)
			FRP.SearchPlayerDialogue(job, fullPlayers)
		end
	else
		HireEmployeeManagment(job)
	end
end

FRP.OpenOutfitCategoryMenu = function(jobOutfits)
	if jobOutfits ~= nil then
		local categories = {}

		local playerPed = PlayerPedId()

		categories[#categories+1] = {
			title = 'Burgerkleding',
			description = 'Je alledaagse kleding',
			onSelect = function(args)

				ESX.Game.PlayAnim('missmic4', 'michael_tux_fidget', 8.0, 1500, 51)
				Wait(1500)
				ESX.Game.PlayAnim('clothingtie', 'try_tie_negative_a', 8.0, 1200, 51)
				Wait(1200)
				ESX.Game.PlayAnim('re@construction', 'out_of_breath', 8.0, 1300, 51)
				Wait(1300)
				ESX.Game.PlayAnim('random@domestic', 'pickup_low', 8.0, 1200, 51)
				Wait(1200)

				SetPedArmour(playerPed, 0)
				SetPedArmour(playerPed, 0)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
				ResetPedMovementClipset(playerPed, 0)

				exports['ox_appearance']:SetCivilianOutfit()
			end,
		}

		for k,v in pairs(jobOutfits) do
			categories[#categories+1] = {
				title = k,
				arrow = true,
				onSelect = function(args)
					FRP.OpenOutfitMenu(args)
				end,
				args = {category = k, outfits = jobOutfits}
			}
		end
		
		lib.registerContext({
			id = 'frp:jobmenu:clothingCategory',
			title = 'Outfitmenu',
			options = categories
		})

		lib.showContext('frp:jobmenu:clothingCategory')
	end
end
exports('OpenOutfitMenu', FRP.OpenOutfitCategoryMenu)


FRP.OpenOutfitMenu = function(data)
	local outfits = {}

	local playerPed = PlayerPedId()

	for k,v in pairs(data.outfits[data.category]) do
		outfits[#outfits+1] = {
			title = k,
			onSelect = function(args)
				ESX.TriggerServerCallback('ox_appearance:getPlayerSkin', function(data)
					if data.model == 'mp_m_freemode_01' then -- Male

						ESX.Game.PlayAnim('missmic4', 'michael_tux_fidget', 8.0, 1500, 51)
						Wait(1500)
						ESX.Game.PlayAnim('clothingtie', 'try_tie_negative_a', 8.0, 1200, 51)
						Wait(1200)
						ESX.Game.PlayAnim('re@construction', 'out_of_breath', 8.0, 1300, 51)
						Wait(1300)
						ESX.Game.PlayAnim('random@domestic', 'pickup_low', 8.0, 1200, 51)
						Wait(1200)

						SetPedArmour(playerPed, 0)
						SetPedArmour(playerPed, 0)
						ClearPedBloodDamage(playerPed)
						ResetPedVisibleDamage(playerPed)
						ClearPedLastWeaponDamage(playerPed)
						ResetPedMovementClipset(playerPed, 0)

						exports['ox_appearance']:SetJobOutfit(args.outfit.male.props, args.outfit.male.components)
					elseif data.model == 'mp_f_freemode_01' then -- Female

						ESX.Game.PlayAnim('missmic4', 'michael_tux_fidget', 8.0, 1500, 51)
						Wait(1500)
						ESX.Game.PlayAnim('clothingtie', 'try_tie_negative_a', 8.0, 1200, 51)
						Wait(1200)
						ESX.Game.PlayAnim('re@construction', 'out_of_breath', 8.0, 1300, 51)
						Wait(1300)
						ESX.Game.PlayAnim('random@domestic', 'pickup_low', 8.0, 1200, 51)
						Wait(1200)

						SetPedArmour(playerPed, 0)
						SetPedArmour(playerPed, 0)
						ClearPedBloodDamage(playerPed)
						ResetPedVisibleDamage(playerPed)
						ClearPedLastWeaponDamage(playerPed)
						ResetPedMovementClipset(playerPed, 0)

						exports['ox_appearance']:SetJobOutfit(args.outfit.female.props, args.outfit.female.components)
					end
				end)
			end,
			args = {outfit = v, label = k}
		}
	end

	lib.registerContext({
		id = 'frp:jobmenu:clothing',
		title = data.category,
		options = outfits
	})

	lib.showContext('frp:jobmenu:clothing')
end

local cooldown = 0

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		if cooldown >= 1 then
			cooldown = cooldown - 1
		end
	end
end)

FRP.ToggleDuty = function(job)
	if cooldown <= 0 then
		cooldown = 5
		TriggerServerEvent('frp-jobsmenu:server:toggleDuty', job)
	else
		ESX.ShowNotification('error', 'Wacht nog ' .. cooldown .. ' seconden met in-/uitklokken.')
	end
end

exports('ToggleDuty', FRP.ToggleDuty)