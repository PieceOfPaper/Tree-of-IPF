---- skill_select_by_cond.lua

function SKL_SELECT_LEVEL(self, skill, level)
	
	if skill.Level >= level then
		return 1;
	end

	return 0;
end

function SKL_SELECT_SCP_TGT_EXIST(self, skill)

	local scpTarget = GetExArgObject(self, "SCP_TARGET");
	if scpTarget == nil then
		return 0;
	end

	return 1;

end

function SKL_SELECT_TOGGLED(self, skill)
	return GetExProp(skill, "TOGGLED");
end

function SKL_SELECT_EXIST_OOBE(self, skill)
	local dpc = GetOOBEObject(self);
	if dpc == nil then
		return 0;
	end

	return 1;
end


function SKL_SELECT_EQUIP_DH_WEAPON(self, skill)

	local rightHand = GetEquipItem(self, 'RH');
		
	if rightHand == nil then
		return 0;
	end

	if rightHand.EqpType ~= nil and rightHand.EqpType == 'DH' then
		return 1;
	else
		return 0;
	end
end

function SKL_SELECT_EQUIP_SH_WEAPON(self, skill)

	local rightHand = GetEquipItem(self, 'RH');
	
	if rightHand == nil then
		return 0;
	end

	if rightHand.EqpType ~= nil and rightHand.EqpType == 'SH' then
		return 1;
	else
		return 0;
	end
end

function SKL_SELECT_JUMPING(self, skill)

	return IsJumping(self);
end

function SKL_SELECT_BUFF(self, skill, buffName)

	local buff = GetBuffByName(self, buffName);
	if buff ~= nil then
		return 1;
	else
		return 0;
	end
end

function SKL_SELECT_ABIL(self, skill, abilName)

	local abil = GetAbility(self, abilName);
	if abil ~= nil then
		return 1;
	else
		return 0;
	end
end

function SKL_VELCOFFER_SET_COUNT(self, skill, setItemName, stack)
	local itemStack = GetPrefixSetItemStack(self, setItemName)
	if itemStack >= stack then
		return 1;
	else
		return 0;
	end

	return 0;
end
