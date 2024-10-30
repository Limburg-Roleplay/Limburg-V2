local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }
local Bones = {
    ['rechtervoet'] = 52301,
    ['linkervoet'] = 14201,
    ['rechterhand'] = 57005,
    ['linkerhand'] = 18905,
    ['rechterknie'] = 36864,
    ['linkerknie'] = 63931,
    ['hoofd'] = 31086,
    ['nek'] = 39317,
    ['rechterarm'] = 28252,
    ['linkerarm'] = 61163,
    ['borst'] = 24818,
    ['bekken'] = 11816,
    ['rechterschouder'] = 40269,
    ['linkerschouder'] = 45509,
    ['rechterpols'] = 28422,
    ['linkerpols'] = 60309,
    ['tong'] = 47495,
    ['bovenlip'] = 20178,
    ['onderlip'] = 17188,
    ['rechterdij'] = 51826,
    ['linkerdij'] = 58217,
}

function checkArray(array, val)
	for name, value in ipairs(array) do
		if value == val then
			return true
		end
	end

	return false
end

function TranslateBoneDamage(ped)
	local FoundLastDamagedBone, LastDamagedBone = GetPedLastDamageBone(ped)
	if FoundLastDamagedBone then
		local DamagedBone = GetKeyOfValue(Bones, LastDamagedBone)
		if DamagedBone then
			return DamagedBone
		end
	end
	return 'borst'
end
exports('TranslateBoneDamage', TranslateBoneDamage)

function TranslateDeathCause(ped)
	local d = GetPedCauseOfDeath(ped)
	local translation = 'Onbekend'
	if checkArray(Melee, d) then
		translation = 'Geraakt door iets hards op het hoofd.'
	elseif checkArray(Bullet, d) then
		translation = 'Kogelgaten in lichaam.'
	elseif checkArray(Knife, d) then
		translation = 'Gesneden door een scherp object.'
	elseif checkArray(Animal, d) then
		translation = 'Gebeten door een dier.'
	elseif checkArray(FallDamage, d) then
		translation = 'Gevallen, 2 gebroken benen.'
	elseif checkArray(Explosion, d) then
		translation = 'Dood gegaan door een explosie.'
	elseif checkArray(Gas, d) then
		translation = 'Dood gegaan door schade aan de longen.'
	elseif checkArray(Burn, d) then
		translation = 'Dood gegaan door brand.'
	elseif checkArray(Drown, d) then
		translation = 'Verdronken'
	elseif checkArray(Car, d) then
		translation = 'Dood gegaan in een auto ongeluk.'
	end
	return translation
end
exports('TranslateDeathCause', TranslateDeathCause)

function GetKeyOfValue(Table, SearchedFor)
    for Key, Value in pairs(Table) do
        if SearchedFor == Value then
            return Key
        end
    end
    return nil
end