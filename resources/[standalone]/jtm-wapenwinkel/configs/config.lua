config = {}

config.Legacy = true

config.currency = '€'

config.blip = true

config.NPCs = {
    {
        model = "cs_bankman",
        coords = vector3(-645.7764, -249.6146, 38.2099 - 1),
        heading = 303.3716
    },
}

config.weapons = {
    {name = 'Lady Killer', class = 'Pistols', weapon = 'weapon_snspistol', price = 950000},
    {name = 'Barreta M9A3', class = 'Pistols', weapon = 'WEAPON_FM1_M9A3', price = 1375000}
}

config.attachments = {
    {name = 'M9A3 Extended Magazine', class = 'Magazines', attachment = 'at_m9a3_clip_02', price = 125000},
    {name = 'M9A3 Suppressor', class = 'Suppressors', attachment = 'at_fm_sup_10', price = 300000},
    {name = 'M9A3 Scope', class = 'Scopes', attachment = 'at_fm_scope_30', price = 450000}
}

config.bullets = {
    {name = 'Pistol Ammo', class = 'Ammo', bullet = 'ammo-pistol', amount = 50, price = 70000}
}

config.overig = {
}

config.weapon_shops = {
    {name = 'Wapenwinkel', coords = vector3(-645.1273, -249.2809, 38.2332), heading = 306.3549}
}