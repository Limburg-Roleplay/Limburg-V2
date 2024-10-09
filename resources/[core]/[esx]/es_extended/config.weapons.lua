Config.DefaultWeaponTints = {
	[0] = _U('tint_default'),
	[1] = _U('tint_green'),
	[2] = _U('tint_gold'),
	[3] = _U('tint_pink'),
	[4] = _U('tint_army'),
	[5] = _U('tint_lspd'),
	[6] = _U('tint_orange'),
	[7] = _U('tint_platinum')
}

Config.Weapons = {
	-- Melee
	{
		name = 'WEAPON_GLOCK17',
		label = 'Glock 17',
		ammo = {label = _U('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _U('component_clip_default'), hash = GetHashKey("COMPONENT_COMBATPISTOL_CLIP_01")},
			{name = 'clip_extended', label = _U('component_clip_extended'), hash = GetHashKey("COMPONENT_COMBATPISTOL_CLIP_02")},
			{name = 'flashlight', label = _U('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _U('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
			{name = 'luxary_finish', label = _U('component_luxary_finish'), hash = GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_M1911',
		label = 'M1911',
		ammo = {label = _U('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _U('component_clip_default'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_01")},
			{name = 'clip_extended', label = _U('component_clip_extended'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_02")},
			{name = 'flashlight', label = _U('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _U('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
			{name = 'luxary_finish', label = _U('component_luxary_finish'), hash = GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_P99QNL',
		label = 'Walther P99QNL',
		ammo = {label = _U('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _U('component_clip_default'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_01")},
			{name = 'clip_extended', label = _U('component_clip_extended'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_02")},
			{name = 'flashlight', label = _U('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _U('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
			{name = 'luxary_finish', label = _U('component_luxary_finish'), hash = GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_MP5',
		label = 'MP5',
		ammo = {label = _U('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _U('component_clip_default'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_01")},
			{name = 'clip_extended', label = _U('component_clip_extended'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_02")},
			{name = 'flashlight', label = _U('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _U('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
			{name = 'luxary_finish', label = _U('component_luxary_finish'), hash = GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER")}
		}
	},
	{name = 'WEAPON_SWITCHBLADE', label = _U('weapon_switchblade'), tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_AK47', label = 'AK47', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_AK47U', label = 'AK-47U', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_MAC11', label = 'MAC-11', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_UZI', label = 'UZI', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_UMP45', label = 'UMP45', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_SMITHWESSON', label = 'Smith & Wesson', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_MEOS45', label = 'MEOS-45', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_REMINGTON680', label = 'Remington 680', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_SPAS12', label = 'SPAS-12', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_HK416', label = 'HK416', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_MCX', label = 'MCX', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_SKORP', label = 'Skorpion vz. 61', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_BAYONET', label = 'Bayonet', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_FIREAXE', label = 'Fire Axe', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_WIREBAT', label = 'Barbed Wire Bat', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_TRI-DAGGER', label = 'Tri-Dagger', tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_STUNGUN', label = _U('weapon_stungun'), tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_NIGHTSTICK', label = _U('weapon_nightstick'), tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_FLASHLIGHT', label = _U('weapon_flashlight'), tints = Config.DefaultWeaponTints, components = {}},
	-- Special
	{name = 'WEAPON_BARRET50', label = 'Barrett .50 Cal', tints = Config.DefaultWeaponTints, components = {}},
	-- Tools
	{name = 'WEAPON_FIREEXTINGUISHER', label = _U('weapon_fireextinguisher'), components = {}, ammo = {label = _U('ammo_charge'), hash = GetHashKey("AMMO_FIREEXTINGUISHER")}},
	{name = 'WEAPON_DIGISCANNER', label = _U('weapon_digiscanner'), components = {}},
	{name = 'GADGET_PARACHUTE', label = _U('gadget_parachute'), components = {}},
}

exports('getWeaponConfig', function()
	return Config.Weapons
end)