Config = {}

Config.SteamRequired = true
Config.WipeTables = {"users", "billing", "outfits", "owned_vehicles", "appartments", "addon_account_data", "ox_inventory"}

Config.ServerTables = {
    {table = "users", user_column = "identifier"},
    {table = "ox_inventory", user_column = "owner"},
    {table = "owned_vehicles", user_column = "owner"},
    {table = "outfits", user_column = "identifier"},
    {table = "appartments", user_column = "owner"},
}

Config.AppartmentCheckAmount = 2000000
Config.GloveBoxCheckAmount = 1000000

Config.CombatlogBoete = 1000000
Config.CombatlogBoeteWebook = 'https://discord.com/api/webhooks/1213628407502344222/ptRFdglNb6XAEgGj_yFAW45-YyA6TNddPntfXOfscYQWPyFTypmHjk8u-DZ2gYonb9rM'
Config.ClearOffInvWebhook = 'https://discord.com/api/webhooks/1290247468747063347/-aHkjUyEItSTTMhKZ3YLJncXf5vZoRvmGwdCX9tVuedZDMG9CsXTDveODkPLmPUQPa4-'
Config.WipeLogsWebhook = "https://discord.com/api/webhooks/1274002508322443404/FfooCyEl_HmqkFbb7G1HOEN4nZoji8NlB08ueu6kc3bv0Hh3pYKuAdoW07bePkqWFsFp"