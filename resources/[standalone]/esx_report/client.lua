
--template for message
local formatOfMessage = '<div class="bubble-message" style="background-color: rgba(%s, %s, %s, %s);%s"><i class="fas fa-commenting"></i> <b><font color=red>[{0}]:</b></font> {1}</div>'
local formatOfMessage2 = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(%s, %s, %s, %s); border-radius: 3px; %s"><i class="fas fa-commenting"></i> <b><font color=red>[Report]:</b></font> Wacht {0} seconden voordat je dit command opnieuw gebruikt!</div>'
local clientReportFormatOfMessage = '<div class="bubble-message" style="background-color: rgba(%s, %s, %s, %s);%s"><i class="fas fa-commenting"></i> <b><font color=red>[{0}]:</b></font> {1} <br> Je report: {2}</div>'
local usergroup = 'user'

local ESX = nil
local reports = true
local delay = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.TriggerServerCallback("esx_report:fetchUserRank", function(group)
        usergroup = group
    end)

    TriggerEvent('chat:addSuggestion', '/reply', _U('description_reply'), {
        { name="id", help= _U('help_text_id') },
        { name="msg", help= _U('help_text_message_reply') }
    })

    if Config.enableRefunds then
        TriggerEvent('chat:addSuggestion', '/menu', ('Open het admin menu.'), {})
    end
end)

function StartCountingDown()
    delay = 30
    Citizen.CreateThread(function()
        Wait(1)
        while delay > 0 do
            delay = delay - 1
            Citizen.Wait(1000)
        end
    end)
end

exports("GetGroup", function()
    return usergroup
end)

exports("GetRank", function()
    return usergroup
end)

RegisterNetEvent("esx_report:textmsg")
AddEventHandler('esx_report:textmsg', function(source, textmsg, names2, names3 )
    local message = names3 .."  "..": " .. textmsg
    local name = "REPLY"
    TriggerEvent('chatMessage', name, 'warning', message)
end)


RegisterNetEvent('esx_report:sendReply')
AddEventHandler('esx_report:sendReply', function(source, textmsg, names2, names3 )
    if usergroup ~= Config.defaultUserGroup then
        local message = ("%s [%s] -> %s: %s"):format(names3, source, names2, textmsg)
        local name = "REPLY"

        TriggerEvent('chat:addMessage', {
            template = formatOfMessage:format(125, 255, 222, 0.6, ""),
            args = { name, message }
        })

    end
end)

RegisterNetEvent('esx_report:showLeaderboard')
AddEventHandler('esx_report:showLeaderboard', function(leaderboardData)
    lib.registerContext({
        id = 'report_leaderboard',
        title = 'Report Leaderboard',
        options = leaderboardData
    })

    lib.showContext('report_leaderboard')
end)

RegisterNetEvent('esx_report:sendReport')
AddEventHandler('esx_report:sendReport', function(id, name, message, extraData)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    extraData = extraData or {}

    if id ~= -1 and pid == myId then
        local name = "SYSTEEM"

        TriggerEvent('chatMessage', 'SYSTEEM', 'success', "Je hebt een report verstuurd!")

    end

    if usergroup ~= 'user' then
        local group = ""
        if extraData.supporter then
            group = "^6[SUPPORTER]^7"
        end
        local message = ("%s: %s"):format(name, message)
        local name = ('REPORT | ID: ' .. id .. '')
        extraData = extraData or {}

        TriggerEvent('chatMessage', 'SYSTEEM', 'staff', "Er is een nieuwe report binnen gekomen!")
    end
end)

RegisterNetEvent('minttozz:hoer')
AddEventHandler('minttozz:hoer', function(source)
        TriggerEvent('chat:addMessage', {
            template = formatOfMessage:format(125, 255, 222, 0.6, ""),
            args = { "REPORT", "Het ingevoerde woord is geblacklist! Voer /newlife uit of maak een ticket voor een refund!. | " .. Config.DiscordMintrozz}
        })

end)


