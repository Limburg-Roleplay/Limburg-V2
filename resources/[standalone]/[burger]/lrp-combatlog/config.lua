Config = {
    -- command configuratie
    commandname = "combatlog",
    enableargs = true, -- sta /combatlog op id toe, zodat je andere spelers hun combatlog kan bekijken

    -- instakill configuratie, aangeraden om beide aan te zetten of beide uit te laten
    headshotinstakill = true, -- zorg ervoor dat als iemand in zijn hoofd geraakt word, dat hij instant dood gaat. Aangeraden om "syncheadshotkill" hiervoor aan te zetten om dit goed te syncen in het combatlog systeem
    syncheadshotkill = true, -- zorg ervoor dat als iemand in zijn hoofd geraakt word, dat het combatlog systeem systeem dit synced met beide spelers. Hiervoor hoeft "headshotinstakill" niet op true te staan (kan dus met eigen systeen verbonden worden)
    
    -- wapen configuratie
    instaHeadshotWapens = { -- wapens die werken voor "headshotinstakill" of "syncheadshotkill"
        [`WEAPON_PISTOL`] = true,
        [`WEAPON_PISTOL_MK2`] = true,
        [`WEAPON_COMBATPISTOL`] = true,
        [`WEAPON_ASSAULTRIFLE`] = true,
        [`WEAPON_ASSAULTRIFLE_MK2`] = true,
        [`WEAPON_CARBINERIFLE`] = true,
        [`WEAPON_CARBINERIFLE_MK2`] = true,
        [`WEAPON_MINISMG`] = true,
        [`WEAPON_COMPACTRIFLE`] = true,
        [`WEAPON_BULLPUPRIFLE`] = true,
        [`WEAPON_BULLPUPRIFLE_MK2`] = true,
        [`WEAPON_HEAVYPISTOL`] = true,
        [`WEAPON_PISTOL50`] = true,
        [`WEAPON_MICROSMG`] = true,
        [`WEAPON_APPISTOL`] = true,
        [`WEAPON_SPECIALCARBINE`] = true,
        [`WEAPON_MACHINEPISTOL`] = true,
        [`WEAPON_SMG`] = true,
        [`WEAPON_ASVAL`] = true,
        [`WEAPON_AKS74U`] = true,
        [`WEAPON_HKUMP`] = true,
        [`WEAPON_FM1_M9A3`] = true,
        [`WEAPON_GLOCK`] = true,
        [`WEAPON_SNIPERRIFLE`] = true,
        [`WEAPON_M32`] = true,
        [`WEAPON_FM1_HK416`] = true,
        [`WEAPON_FM2_HK416`] = true,
        [`WEAPON_MCXSPEAR`] = true,
        [`WEAPON_MCX`] = true,
        [`WEAPON_GLOCKKMAR`] = true,
        [`WEAPON_PPK`] = true,
        [`WEAPON_GLOCK19X`] = true,
        [`WEAPON_SIG`] = true,
        [`WEAPON_38SNUBNOSE`] = true,
        [`WEAPON_38SNUBNOSE2`] = true,
        [`WEAPON_38SNUBNOSE3`] = true,
        [`WEAPON_38SPECIAL`] = true,
        [`WEAPON_44MAGNUM`] = true,
        [`WEAPON_MP5`] = true,
        [`WEAPON_MINIUZI`] = true,
        [`WEAPON_MCXRATTLER`] = true,
        [`WEAPON_NVRIFLE`] = true,
        [`WEAPON_AK74`] = true,
        [`WEAPON_DESERT_EAGLE`] = true
    },
    killBones = { -- botten waardoor je instant dood gaat, hoofd, neck en ruggenwervel. hiervoor moet "headshotinstakill" of "syncheadshotkill" aan staan
        [31086] = { chance = 1.00 }, -- hoofd [bot hash] = {kans op instant dood gaan}
        [39317] = { chance = 0.85 }, -- neck
        [24532] = { chance = 0.85 }, -- neck
        [23553] = { chance = 0.02 }, -- spine
        [24816] = { chance = 0.02 }, -- spine
        [24817] = { chance = 0.1 }, -- spine
        [24818] = { chance = 0.1 }, -- spine
    },

    ragdollmindamage = 12,

    rifleragdollmax = 10500,
    rifleragdollmin = 6500,

    pistolragdollmax = 8500,
    pistolragdollmin = 4500,
}