Config 				  = {}
Config.HLcooldown		  = 100

-- Add/remove weapon hashes here to be added for holster checks.
Config.HLWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_FLAREGUN",
	"WEAPON_STUNGUN",
	"WEAPON_REVOLVER",
}


Config.Animations = {
    ['Agressor'] = {
        ['animDict'] = 'anim@gangops@hostage@',
        ['anim'] = 'perp_idle',
        ['flag'] = 49
    },
    ['Hostage'] = {
        ['animDict'] = 'anim@gangops@hostage@',
        ['anim'] = 'victim_idle',
        ['attachX'] = -0.24,
        ['attachY'] = 0.11,
        ['attachZ'] = 0.0,
        ['flag'] = 49
    }
}

Config.AllowedWeapons = {
    [`WEAPON_BAYONET`] = 'WEAPON_BAYONET',
    [`WEAPON_SWITCHBLADE`] = 'WEAPON_SWITCHBLADE',
    [`WEAPON_GLOCK17`] = 'WEAPON_GLOCK17',
    [`WEAPON_M1911`] = 'WEAPON_M1911',
    [`WEAPON_REMINGTON680`] = 'WEAPON_REMINGTON680',
    [`WEAPON_AKS74U`] = 'WEAPON_AKS74U',
    [`WEAPON_WIREBAT`] = 'WEAPON_WIREBAT',
    [`WEAPON_FIREAXE`] = 'WEAPON_FIREAXE',
    [`WEAPON_MAC11`] = 'WEAPON_MAC11',
    [`WEAPON_MEOS45`] = 'WEAPON_MEOS45',
    [`WEAPON_UMP45`] = 'WEAPON_UMP45',
    [`WEAPON_TRI-DAGGER`] = 'WEAPON_TRI-DAGGER',
    [`WEAPON_SPAS12`] = 'WEAPON_SPAS12',
    [`WEAPON_SMITHWESSON`] = 'WEAPON_SMITHWESSON',
    [`WEAPON_AK47`] = 'WEAPON_AK47',
}