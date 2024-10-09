function Webhook(webHookUrl, webHookImage)
    local self = {}

    self.webHookUrl = webHookUrl
    self.webHookImage = webHookImage

    if not self.webHookUrl then 
        error('discordWebHookUrl was expected but got nil')
        return
    end

    self.send = function(playerId, rawCommand)
        local user = self.getPlayerServerInfo()
        local messageObj = self.messageBuilder(user, rawCommand)
        PerformHttpRequest(self.webHookUrl, function(err, text, header)  end, 'POST', json.encode(messageObj), {
            ['Content-Type'] = 'application/json'
        })
    end
	self.sendLog = function(playerId, title, desc, color)
        local color2 = color or 0x0000ff
        local messageObj = self.messageBuilderLogs(playerId, title, desc, color2)
        PerformHttpRequest(self.webHookUrl, function(err, text, header)  end, 'POST', json.encode(messageObj), {
            ['Content-Type'] = 'application/json'
        })
    end
    self.sendLogNoFields = function(title, desc, color)
        local color2 = color or 0x0000ff
        local messageObj = self.messageBuilderLogsNoFields(title, desc, color2)
        PerformHttpRequest(self.webHookUrl, function(err, text, header)  end, 'POST', json.encode(messageObj), {
            ['Content-Type'] = 'application/json'
        })
    end
    self.messageBuilderLogs = function(user, title, desc, color)
        local identifiers = {}
        if user ~= 0 and  json.encode(GetPlayerIdentifiers(user)) ~= "[]" then
        for k,v in pairs(GetPlayerIdentifiers(user)) do              
            if string.sub(v, 1, string.len("steam:")) == "steam:" then -- Steam Hex
                identifiers.steamhex = string.sub(v, 7) or "unknown"
            elseif string.sub(v, 1, string.len("license:")) == "license:" then -- Rockstar License
                identifiers.license = string.sub(v, 9) or "unknown"
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then -- Discord ID
                identifiers.discord = string.sub(v, 9) or "unknown"
            end
        end
        return {
            
            embeds = {
                {
                    title = title,
                    description = desc,
                    url = 'https://discord.gg/fxwXbNjD',
                    color = color,
                    thumbnail = {
                        url = self.webHookImage
                    },
					fields = {
                    {
                    	name = 'Steam Hex:',
                        value = identifiers.steamhex,
                        inline = true
                    },
                	{
                            name = 'Rockstar License:',
                            value = identifiers.license,
                            inline = true
                        },
                        {
                            name = 'Discord ID:',
                            value = identifiers.discord,
                            inline = true
                        }
                }
                    
                },
            }
        }
            else
            return { embeds = {{
                    title = title,
                    description = desc,
                    url = 'https://discord.gg/fxwXbNjD',
                    color =  color,
					thumbnail = {
                        url = self.webHookImage
                    },
                    fields = {},
                    }}
                }
            end
    end
    self.messageBuilderLogsNoFields = function(title, desc, color)
        return {
            
            embeds = {
                {
                    title = title,
                    description = desc,
                    url = 'https://discord.gg/fxwXbNjD',
                    color = color,
                    thumbnail = {
                        url = self.webHookImage
                    },
                    fields = {},
                },
            }
        }
            
    end
    self.messageBuilder = function(user, rawCommand)

        return {
            embeds = {
                {
                    title = user.name ..' was execute a command',
                    description = '```'.. rawCommand ..'```\n',
                    url = 'https://github.com/lucianfialhobp',
                    color = 3666853,

                    fields = {
                        {
                            name = 'Steam Hex:',
                            value = user.steamhex,
                            inline = true
                        },
                        {
                            name = 'Rockstar License:',
                            value = user.license,
                            inline = true
                        },
                        {
                            name = 'Xbox:',
                            value = user.xbox,
                            inline = true
                        },
                        {
                            name = 'Discord ID:',
                            value = user.discord,
                            inline = true
                        },
                        {
                            name = 'Microsoft:',
                            value = user.microsoft,
                            inline = true
                        }
                    },

                    thumbnail = {
                        url = self.webHookImage
                    },

                    author = {
                        name = user.name,
                    },
                },
            }
        }
    end

    self.getPlayerServerInfo = function ()
        local user = {
            steamhex = "None",
            license = "None",
            xbox = "None",
            ip = "None",
            discord = "None",
            microsoft = "None"
        }
        user.name = GetPlayerName(source)

        for k,v in pairs(GetPlayerIdentifiers(source)) do              
            if string.sub(v, 1, string.len("steam:")) == "steam:" then -- Steam Hex
                user.steamhex = string.sub(v, 7)
            elseif string.sub(v, 1, string.len("license:")) == "license:" then -- Rockstar License
                user.license = string.sub(v, 9)
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then -- Xbox
                user.xbox = string.sub(v, 5)
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then -- Discord ID
                user.discord = string.sub(v, 9)
            elseif string.sub(v, 1, string.len("live:")) == "live:" then -- Microsoft
                user.microsoft = string.sub(v, 6)
            end
        end

        return user
    end

    self.createDescription = function(user)
        return string.format("Steam: %s |\n License: %s |\n Xbox: %s |\n Ip: %s |\n Discord: %s |\n Microsoft: %s |", user.steamhex, user.license, user.xbox, user.ip, user.discord, user.microsoft)
    end

    return self
end
