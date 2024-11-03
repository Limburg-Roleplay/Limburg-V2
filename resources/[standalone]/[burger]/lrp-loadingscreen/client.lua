-- Variable to check if native has already been run
local shutdownLoadingscreen = false

-- Wait until client is loaded into the map
RegisterNetEvent('lrp-loadingscreen:client:done')
AddEventHandler('lrp-loadingscreen:client:done', function()
	-- If not already ran
	if not shutdownLoadingscreen then
		-- Close loading screen resource
		ShutdownLoadingScreenNui()

		-- Set as ran
		shutdownLoadingscreen = true
	end
end)

exports('isLoadingScreenShuttedDown', function()
	return shutdownLoadingscreen
end)