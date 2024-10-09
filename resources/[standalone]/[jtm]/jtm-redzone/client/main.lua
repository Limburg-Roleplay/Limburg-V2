local greenZone = nil
local zone = lib.points.new(vec3(0, 0, 0), 0)
local pedCoords = nil
local radiusBlip = nil
local sprite = nil

for k, v in pairs(Config.GreenZones) do
    local greenZone = lib.points.new(v.coords, v.radius)
    
    function greenZone:onEnter()
        if v.displayTextUI then
            lib.showTextUI(v.textToDisplay, {
                position = v.displayTextPosition,
                icon = v.displayTextIcon,
                style = {
                    borderRadius = 4,
                    backgroundColor = v.backgroundColorTextUI,
                    color = '#FFFFFF' -- Set text color to white
                }
            })
        end
        if Config.EnableNotifications then
            lib.notify({
                title = Notifications.greenzoneTitle, 
                description = Notifications.greenzoneEnter,
                type = 'success',
                position = Notifications.position,
                duration = 6000,
                style = {
                    backgroundColor = '#ff5a47',
                    color = '#FFFFFF', -- Set main text color to white
                    ['.description'] = {
                        color = '#FFFFFF', -- Set description text color to white
                    }
                },
                icon = Notifications.greenzoneIcon,
                iconColor = '#FFFFFF' -- Set icon color to white
            })
        end
    end

    function greenZone:onExit()
        if v.displayTextUI then
            lib.hideTextUI()
        end
        if Config.EnableNotifications then
            lib.notify({
                title = Notifications.greenzoneTitle, 
                description = Notifications.greenzoneExit,
                type = 'error',
                position = Notifications.position,
                style = {
                    backgroundColor = '#72E68F',
                    color = '#FFFFFF', -- Set main text color to white
                    ['.description'] = {
                        color = '#FFFFFF', -- Set description text color to white
                    }
                },
                icon = Notifications.greenzoneIcon,
                iconColor = '#FFFFFF' -- Set icon color to white
            })
        end
    end
end

-- Blip creation for the default persistent greenzones configured beforehand
for k, v in pairs(Config.GreenZones) do
    if v.blip then
        if v.blipType == 'radius' then
            local blip = AddBlipForRadius(v.coords.x, v.coords.y, v.coords.z, v.radius)
            SetBlipColour(blip, v.blipColor)
            SetBlipAlpha(blip, v.blipAlpha)
            if v.enableSprite then
                local blip2 = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
                SetBlipSprite(blip2, v.blipSprite)
                SetBlipColour(blip2, v.blipColor)
                SetBlipScale(blip2, v.blipScale)
                SetBlipAsShortRange(blip2, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.blipName)
                EndTextCommandSetBlipName(blip2)
            end
        else
            local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(blip, v.blipSprite)
            SetBlipColour(blip, v.blipColor)
            SetBlipScale(blip, v.blipScale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blipName)
            EndTextCommandSetBlipName(blip)
        end
    end
end