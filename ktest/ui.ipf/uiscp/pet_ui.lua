--- pet_ui.lua --

function PET_ABILITY_DESC_ATK(obj)
	local value = obj.Stat_ATK;
	return ScpArgMsg("IncreaseAtkOfPetBy{Value}", "Value", PET_ATK_BY_ABIL(value));
end

function PET_ABILITY_DESC_DEF(obj)
	local value = obj.Stat_DEF;
	return ScpArgMsg("IncreaseDefenceOfPetBy{Value}", "Value", PET_DEF_BY_ABIL(value));
end

function PET_ABILITY_DESC_MDEF(obj)
	local value = obj.Stat_MDEF;
	return ScpArgMsg("IncreaseMagicDefenceOfPetBy{Value}", "Value", PET_MDEF_BY_ABIL(value));
end

function PET_ABILITY_DESC_MHP(obj)
	local value = obj.Stat_MHP;
	return ScpArgMsg("IncreaseMHPOfPetBy{Value}", "Value", PET_MHP_BY_ABIL(value));
end

function PET_ABILITY_DESC_HR(obj)
	local value = obj.Stat_MHP;
	return ScpArgMsg("IncreaseHROfPetBy{Value}", "Value", PET_HR_BY_ABIL(value));
end

function PET_ABILITY_DESC_CRTHR(obj)
	local value = obj.Stat_MHP;
	return ScpArgMsg("IncreaseCRTHROfPetBy{Value}", "Value", PET_CRTHR_BY_ABIL(value));
end

function PET_ABILITY_DESC_DR(obj)
	local value = obj.Stat_MHP;
	return ScpArgMsg("IncreaseDROfPetBy{Value}", "Value", PET_DR_BY_ABIL(value));
end
