-- Server-Side Event Handler for Plate Change
RegisterNetEvent("vehiclePlateChange:detected")
AddEventHandler("vehiclePlateChange:detected", function(oldPlate, newPlate)
    local playerId = source
    print("Player " .. playerId .. " changed vehicle plate from " .. oldPlate .. " to " .. newPlate)

    exports["FIVEGUARD"]:screenshotPlayer(source, function(url)
        print("got url of screenshot: " .. url .. " from player: " .. source)
    end)
    return exports["FIVEGUARD"]:fg_BanPlayer(source, "Suspicious activity detected: Player ID " .. source .. " tried to change vehicle plate without validation.", true)
end)
