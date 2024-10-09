exports("createlog", function(webhook, title, color)

    local color = color or 1752220
    local self = {}

    if not webhook or not title then 
        return {}
    end

    self.webhook = webhook
    self.data = {
        username = Config.Username,
        avatar_url = Config.Foto,
        embeds = {
            {
                color = color,
                author = {
                    name = title
                }, 
                description = "",
                footer = {
                    text = ("%s - %s/%s/%s"):format(os.date("%X"), os.date("%d"), os.date("%m"), os.date("%Y")),
                    icon_url = Config.Foto
                }
            }
        }
    }

    self.addcolumn = function(key, value)
        local bericht = self.data.embeds[1].description

        if type(key) == "table" then 
            return 
        else
            bericht = ("%s\n**%s**: %s"):format(bericht, key, value)
        end

        self.data.embeds[1].description = bericht
    end

    self.addcolumns = function(columns)
        local bericht = self.data.embeds[1].description

        for k, v in pairs(columns) do 
            k = k or ""
            v = v or ""

            if k == "" and v == "" then 
                bericht = ("%s\n"):format(bericht)
            else
                bericht = ("%s\n**%s**: %s"):format(bericht, k, v)
            end
        end
        
        self.data.embeds[1].description = bericht
    end

    self.nextline = function()
        local bericht = self.data.embeds[1].description

        bericht = bericht .. "\n"

        self.data.embeds[1].description = bericht
    end

    self.update = function(key, value)
        
        if key == "webhook" then
            self.webhook = value 
        elseif key == "title" then 
            self.data.embeds[1].author.name = value 
        elseif key == "color" then 
            self.data.embeds[1].color = value
        end

    end

    self.send = function()
        PerformHttpRequest(self.webhook, function(errorCode, resultData, resultHeaders)
            if errorCode ~= 204 then 
                -- error("Kon webhook niet versturen: " .. resultData)
                print("Webhook: ".. self.webhook .. " doesn't exist anymore.")
            end
        end, "POST", json.encode(self.data), {['Content-Type'] = 'application/json'})
    end


    return self

end)