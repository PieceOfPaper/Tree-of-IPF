--- skill_lib.lua

function IS_SCP_APPLY(self)
	if TryGetProp(self, "MonRank") == "Boss" then
		return 0;
	end
	
	return 1;
end

-- IsNormalSkillBySkillID에서 노말로 처리해주려는 용도. 노말로 처리하실 거면 1 반환 부탁해요
function IS_NORMAL_SKILL_BY_CLASSNAME(skillClassName)	
	if skillClassName == 'Lycan_Half_Attack' then
		return 1;
	end

	return 0;
end
