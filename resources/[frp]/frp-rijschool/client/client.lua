local FRP = {}

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
	"esx:playerLoaded",
	function(PlayerData)
		ESX.PlayerData = PlayerData
		ESX.PlayerLoaded = true
	end
)

RegisterNetEvent("esx:onPlayerLogout")
AddEventHandler(
	"esx:onPlayerLogout",
	function()
		ESX.PlayerLoaded = false
	end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
	"esx:setJob",
	function(Job)
		ESX.PlayerData.job = Job
	end
)

RegisterNetEvent("frp-rijschool:client:open:theorie")
AddEventHandler(
	"frp-rijschool:client:open:theorie",
	function(data)
		if data and data.dsad then
			ESX.TriggerServerCallback(
				"frp-rijschool:server:has:enough:money",
				function(bool)
					if bool then
						SendNUIMessage(
							{
								type = "openCBR"
							}
						)
						SetNuiFocus(true, true)
					else
					end
				end,
				"theorie"
			)
		end
	end
)

RegisterNetEvent("frp-rijschool:client:start:rijbewijs")
AddEventHandler(
	"frp-rijschool:client:start:rijbewijs",
	function(data)
		if data and data.type then
			ESX.TriggerServerCallback(
				"frp-rijschool:server:has:enough:money",
				function(bool, plate)
					if bool then
						FRP.startLicense(data.type, plate)
					end
				end,
				"praktijk"
			)
		end
	end
)

Citizen.CreateThread(
	function()
		for i = 1, #Config.Setup["Blip"] do
			blip = AddBlipForCoord(Config.Setup["Blip"][i]["Coords"])
			SetBlipSprite(blip, Config.Setup["Blip"][i]["Settings"]["Sprite"])
			SetBlipDisplay(blip, Config.Setup["Blip"][i]["Settings"]["Display"])
			SetBlipScale(blip, Config.Setup["Blip"][i]["Settings"]["Scale"])
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("CBR") 
			EndTextCommandSetBlipName(blip)
		end
	end
)

Citizen.CreateThread(
	function()
		while true do
			local sleep = 750
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

			for i = 1, #Config.Setup["Locations"], 1 do
				local distance = #(coords - Config.Setup["Locations"][i]["Position"])

				if distance < 15.0 then
					sleep = 0
					ESX.Game.Utils.DrawMarker(Config.Setup["Locations"][i]["Position"], 2, 0.2, 10, 78, 161)
					if distance < 2.5 then
						exports["frp-interaction"]:Interaction(
							"info",
							"[E] - Rijschool",
							Config.Setup["Locations"][i]["Position"],
							2.5,
							GetCurrentResourceName()
						)
						if IsControlJustPressed(0, 38) then
							openRijschoolMenu()
						end
					end
				end
			end

			Citizen.Wait(sleep)
		end
	end
)

openRijschoolMenu = function()
	ESX.TriggerServerCallback(
		"frp-rijschool:server:check:license",
		function(data)
			local options = {}
			if not data then
				options[#options + 1] = {
					title = "Theorie examen | €" .. Config.TheorieCost,
					description = "Dit is benodigd voor het halen van je praktijk examen!",
					event = "frp-rijschool:client:open:theorie",
					args = {dsad = "hoi "}
				}
			elseif data then
				ESX.TriggerServerCallback(
					"frp-rijschool:server:check:license",
					function(data3)
						if not data3 then
							options[#options + 1] = {
								title = "Rijbewijs B | €" .. Config.PraktijkCost,
								description = "Dit is benodigd voordat jij in een personenauto mag rijden!",
								event = "frp-rijschool:client:start:rijbewijs",
								args = {type = "rijbewijsB"}
							}
						end
					end,
					"rijbewijsB"
				)
				ESX.TriggerServerCallback(
					"frp-rijschool:server:check:license",
					function(data4)
						if not data4 then
							options[#options + 1] = {
								title = "Rijbewijs C | €" .. Config.PraktijkCost,
								description = "Dit is benodigd voordat jij in een vrachtwagen mag rijden!",
								event = "frp-rijschool:client:start:rijbewijs",
								args = {type = "rijbewijsC"}
							}
						end
					end,
					"rijbewijsC"
				)

				ESX.TriggerServerCallback(
					"frp-rijschool:server:check:license",
					function(data2)
						print(data2)
						if not data2 then
							options[#options + 1] = {
								title = "Rijbewijs A | €" .. Config.PraktijkCost,
								description = "Dit is benodigd voordat jij op een motor mag rijden!",
								event = "frp-rijschool:client:start:rijbewijs",
								args = {type = "rijbewijsA"}
							}
						end
					end,
					"rijbewijsA"
				)
			end
			Citizen.Wait(200)
			lib.registerContext(
				{
					id = "dmv:open-menu",
					title = "Rijschool: Licenties",
					options = options
				}
			)

			lib.showContext("dmv:open-menu")
		end,
		"theorie"
	)
end

RegisterNUICallback(
	"getResults",
	function(data, cb)
		if #data >= Config.GoodAnswers then
			cb(true)
			TriggerServerEvent("frp-rijschool:server:succeed:test")
		else
			cb(false)
		end
	end
)

RegisterNUICallback(
	"close",
	function(data, cb)
		SetNuiFocus(false, false)
	end
)

FRP.startLicense = function(dataType)
	local gotPoints = 0
	local number = 1
	local cooldown = false
	local spawnCar = Config.Vehicles[dataType]
	local location = Config.Locations
	local dehveh
	local maxSpeed = location[number].Speedlimit
	local maxNumber = #Config.Locations
	local oldblip

	ESX.Game.SpawnVehicle(
		spawnCar,
		vec3(location[number]["Position"].x, location[number]["Position"].y, location[number]["Position"].z),
		location[number].w,
		function(veh)
			TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
			ESX.ShowNotification("info", "Pasop! Hier is een snelheidlimiet van " .. location[number].Speedlimit .. "!")
			number = number + 1
			dehveh = veh
		end
	)

	while not IsPedInAnyVehicle(PlayerPedId(), false) do
		Wait(0)
	end

	oldblip =
		AddBlipForCoord(location[number]["Position"].x, location[number]["Position"].y, location[number]["Position"].z)
	SetBlipRoute(oldblip, 1)

	while true do
		local sleep = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local dist =
			#(coords - vec3(location[number]["Position"].x, location[number]["Position"].y, location[number]["Position"].z))
		local veh = GetVehiclePedIsIn(ped, false)
		local speed = GetEntitySpeed(veh)

		if veh ~= 0 then
			if not cooldown and (speed * 3.6 > maxSpeed) then
				gotPoints = gotPoints + 1
				ESX.ShowNotification(
					"info",
					"Je hebt een strafpunt begaan omdat je te hard reed, je hebt er " .. gotPoints .. "/4!"
				)
				if gotPoints >= 4 then
					if DoesBlipExist(oldblip) then
						RemoveBlip(oldblip)
					end
					DeleteEntity(dehveh)
					SetEntityCoords(ped, Config.TPCoords)
					return
				end
				cooldown = true
				Citizen.SetTimeout(
					5000,
					function()
						cooldown = false
					end
				)
			end

			if dist <= 50.0 then
				sleep = 0
				DrawMarker(
					1,
					vec3(location[number]["Position"].x, location[number]["Position"].y, location[number]["Position"].z - 1.0),
					0.0,
					0.0,
					0.0,
					0,
					0.0,
					0.0,
					2.5,
					2.5,
					0.5,
					245,
					66,
					66,
					100,
					false,
					true,
					2,
					true,
					false,
					false,
					false
				)
				if dist <= 2.5 then
					number = number + 1

					if DoesBlipExist(oldblip) then
						RemoveBlip(oldblip)
					end

					if number > maxNumber then
						TriggerServerEvent("frp-rijschool:server:maded:praktijk:test", dataType)
						DeleteEntity(dehveh)
						if DoesBlipExist(oldblip) then
							RemoveBlip(oldblip)
						end
						return
					end

					if location[number].Speedlimit then
						maxSpeed = location[number].Speedlimit
						ESX.ShowNotification("info", "Pas op! Hier is een snelheidlimiet van " .. location[number].Speedlimit .. "!")
					end

					oldblip =
						AddBlipForCoord(location[number]["Position"].x, location[number]["Position"].y, location[number]["Position"].z)
					SetBlipRoute(oldblip, 1)
				end
			end
		else
			if DoesBlipExist(oldblip) then
				RemoveBlip(oldblip)
			end
			DeleteEntity(dehveh)
			return
		end

		Wait(sleep)
	end
end
