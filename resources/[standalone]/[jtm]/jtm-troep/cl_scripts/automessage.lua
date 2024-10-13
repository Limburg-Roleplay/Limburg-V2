local automesseg = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        for i in pairs(Text) do
            if  automesseg then
                TriggerEvent('chatMessage', 'Limburg Roleplay', 'automessage', Text[i] )
                Citizen.Wait(6 * 60000)
            end
        end
    end
end)


Text = {
    'Bekijk onze donatie pakketen op onze discord!',
    'Er word nog steeds overheidsleden gezocht, solliciteer nu in de Overheids discord!',
    'Wil je een gang? Bekijk dan onze pakketen op onze main discord!',
    'Geen zin om een gang te joinen en te grinden voor levels. Kijk naar het VIP: Blackmarket Pakket in onze discord!',
    'Opzoek naar fivem scripts join deze discord! https://discord.gg/jtmdevelopment',
    'Join onze discord! discord.gg/limburgroleplay',
    'Wist je dat je kan fouilleren met /rs en niet met het oogje!'
}