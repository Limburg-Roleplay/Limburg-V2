ESX = exports["es_extended"]:getSharedObject()

-- Function to check if a player has permission
function hasPermission(xPlayer)
    local allowed_groups = {
        'owner',
        'hogerop',
        'staff',
        'managementteam',
        'beheerteam'
    }

    local player_group = xPlayer.getGroup()

    for _, group in ipairs(allowed_groups) do
        if player_group == group then
            return true
        end
    end

    return false
end
function spelerinfo(args, source)
    local xPlayer
    if source ~= 0 then
        xPlayer = ESX.GetPlayerFromId(source)
    end

    -- Check if the command is run from the console
    local isConsole = (source == 0)

    if isConsole or hasPermission(xPlayer) then
        if isConsole then
            print('Informatie ('..args..') Informatie over '..args..' aan het ophalen!')
        else
            TriggerClientEvent('chatMessage', source, 'Informatie ('..args..')', 'success', "Informatie over "..args.." aan het ophalen!")
        end

        Wait(1500)

        -- Check if args is a number (server ID) or a license string
        if args:sub(1, 8) == "license:" then
            -- If args is a license ID
            local license = args:gsub("license:", "")
            MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @license', {
                ['@license'] = license
            }, function(result)
                if result and #result > 0 then
                    local infotarget = result[1]
                    local infoMessage = "Naam: " .. infotarget.firstname .. ' ' .. infotarget.lastname ..
                                        " <br><br> Baan: " .. infotarget.job ..
                                        "<br> Baan Rang: " .. infotarget.job_grade ..
                                        "<br><br> Baan2: " .. infotarget.job2 ..
                                        "<br> Baan2 Rang: " .. infotarget.job2_grade ..
                                        "<br> Groep: " .. infotarget.group

                    if isConsole then
                        print('Informatie ('..infotarget.firstname .. ' ' .. infotarget.lastname..')')
                        print(infoMessage:gsub("<br>", "\n"))  -- Replace HTML line breaks with newline for console
                    else
                        TriggerClientEvent('chatMessage', source, 'Informatie ('..infotarget.firstname .. ' ' .. infotarget.lastname..')', 'success', infoMessage)
                    end
                else
                    if isConsole then
                        print('Informatie ('..args..'): Persoon niet gevonden!')
                    else
                        TriggerClientEvent('chatMessage', source, 'Informatie ('..args..')', 'error', "Persoon niet gevonden!")
                    end
                end
            end)
        else
            -- Assume args is a server ID
            local infotarget = ESX.GetPlayerFromId(tonumber(args))
            if infotarget then
                local infoMessage = "Naam: " .. infotarget.getName() ..
                                    " <br><br>Bank: " .. infotarget.getAccount("bank").money ..
                                    " <br> Contant: " .. infotarget.getAccount("money").money ..
                                    " <br> Zwart: " .. infotarget.getAccount("black_money").money ..
                                    " <br><br> Baan: " .. infotarget.getJob().label ..
                                    "<br> Baan Rang: " .. infotarget.getJob().grade_label ..
                                    "<br><br> Baan2: " .. infotarget.getJob2().label ..
                                    "<br> Baan2 Rang: " .. infotarget.getJob2().grade_label ..
                                    "<br> Groep: " .. infotarget.getGroup()

                if isConsole then
                    print('Informatie ('..infotarget.getName()..')')
                    print(infoMessage:gsub("<br>", "\n"))  -- Replace HTML line breaks with newline for console
                else
                    TriggerClientEvent('chatMessage', source, 'Informatie ('..infotarget.getName()..')', 'success', infoMessage)
                end
            else
                if isConsole then
                    print('Informatie ('..args..'): Persoon niet gevonden!')
                else
                    TriggerClientEvent('chatMessage', source, 'Informatie ('..args..')', 'error', "Persoon niet gevonden!")
                end
            end
        end
    else
        if isConsole then
            print('Je hebt hier niet de juiste permissies voor!')
        else
            TriggerClientEvent('chatMessage', source, 'Informatie ('..args..')', 'error', "Je hebt hier niet de juiste permissies voor!")
        end
    end
end

RegisterCommand('spelerinfo', function(source, args)
    spelerinfo(args[1], source)
end)
