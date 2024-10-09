Weapons = {}

Weapons.WeaponNames = {
	[tostring(GetHashKey('WEAPON_KNUCKLEDUSTER'))] = 'Boksbeugel',
	[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Vuisten',
	[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
	[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
	[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
	[tostring(GetHashKey('WEAPON_Machete'))] = 'Machete',
	[tostring(GetHashKey('WEAPON_BAT'))] = 'Bat',
	[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
	[tostring(GetHashKey('WEAPON_STUNGUN'))] = 'Taser X2',
	[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Walther P99Q',
	[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Desert Eagle',
	[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Politie Pistol',
	[tostring(GetHashKey('WEAPON_SIG'))] = 'Sig Sauer Pistol',
	[tostring(GetHashKey('WEAPON_HKUMP'))] = 'XP-45',
	[tostring(GetHashKey('WEAPON_FM1_M9A3'))] = 'Baretta M9A3',
	[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'Lady Killer',
	[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
	[tostring(GetHashKey('WEAPON_MINIUZI'))] = 'Mini Uzi', 
	[tostring(GetHashKey('WEAPON_SMG'))] = 'MP5',
	[tostring(GetHashKey('WEAPON_MP5'))] = 'X-P5',
	[tostring(GetHashKey('WEAPON_AK74_1'))] = 'AKM',
	[tostring(GetHashKey('WEAPON_MB47'))] = 'MB-47',
	[tostring(GetHashKey('WEAPON_AKS74U'))] = 'AKS-47U',
	[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed Off Shotgun',
	[tostring(GetHashKey('WEAPON_BENELLIM4'))] = 'Benelli M4',
	[tostring(GetHashKey('WEAPON_FM1_HK416'))] = 'HK416',
	[tostring(GetHashKey('WEAPON_FM2_HK416'))] = 'HK416',
	[tostring(GetHashKey('WEAPON_AGC'))] = 'X-AGC',
	[tostring(GetHashKey('WEAPON_DOUBLEBARRELFM'))] = 'MR43 Double Barrel',
	[tostring(GetHashKey('WEAPON_GLOCK17'))] = 'GLOCK17',
	[tostring(GetHashKey('WEAPON_NVRIFLE'))] = 'NV Rifle',
	[tostring(GetHashKey('WEAPON_REMINGTON'))] = 'Remington 870',
	[tostring(GetHashKey('WEAPON_MCXRATTLER'))] = 'XP-54',
    [tostring(GetHashKey('WEAPON_GLOCK19X'))] = 'AP-19',   
	[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'weapon_revolver',   
	[tostring(GetHashKey('WEAPON_DOUBLEACTION'))] = 'weapon_doubleaction',   
	
	

}

exports('getWeapons', function()
	return Weapons.WeaponNames
end)