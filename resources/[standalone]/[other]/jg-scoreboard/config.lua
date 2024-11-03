Config = {}

Config.Framework = "ESX"  -- or "ESX"
Config.KeyBind = "F10"
Config.ServerName = "Limburg Roleplay"
Config.EnableCursor = false
Config.ShowIdsAboveHeads = false -- staff only

Config.ShowHighlightedJobs = true
Config.HighlightedJobs = {
  [1] = {
    jobs = {"police"}, -- the name of one or more jobs in ESX that you want to be counted
    label = "Politie", -- this can be any label you choose!
    icon = "shield", -- https://icons.getbootstrap.com/ - paste the name of the icon without the bi- prefix
    color = "#2596be",
    countOnDutyOnly = false -- this must be a hex code
  },
  [2] = {
    jobs = {"kmar"},
    label = "KMar",
    icon = "shield-shaded",
    color = "#1C7ED6",
    countOnDutyOnly = false
  },
  [3] = {
    jobs = {"ambulance"},
    label = "Ambulance",
    icon = "heart-pulse",
    color = "#cfc200",
    countOnDutyOnly = false
  },
  [4] = {
    jobs = {"mechanic"},
    label = "ANWB",
    icon = "tools",
    color = "#Ff9800",
    countOnDutyOnly = false
  }
}

Config.ShowPlayers = false
Config.UseCharacterNames = false -- if true uses QB character name, if false uses FiveM username
Config.ShowAdminBadges = false
Config.AdminBadgeIcon = "star-fill" -- https://icons.getbootstrap.com/ - paste the name of the icon without the bi- prefix
Config.ShowPlayerIds = false
Config.ShowPlayerJob = false
Config.ShowPlayerJobDutyStatus = false