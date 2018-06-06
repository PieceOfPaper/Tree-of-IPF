-- monskl_result_cond.lua   (UseSleep?? ???? ????)
-- ?????? 1 ????. ???д? -1 ????.

-- ????u??? or?????? ???? S_R_COND_OR_START ~ S_R_COND_OR_END ???????? ?????????
--  ?? ???? ???? ????? ??????? ???????????? ???.  ???????????? 9999, 9998 ????????? ????.
function S_R_COND_OR_START(self, target, skill, ret)
	return 9999;
end

function S_R_COND_OR_END(self, target, skill, ret)
	return 9998;
end

function S_R_COND_TGTBUFF(self, target, skill, ret, buffName)

	local buff = GetBuffByName(target, buffName)
	if buff == nil then
		return -1;
	end

	return 1;
end

function S_R_COND_TGTNOBUFF(self, target, skill, ret, buffName)

	local buff = GetBuffByName(target, buffName)
	if buff ~= nil then
		return -1;
	end

	return 1;
end

function S_R_COND_RACETYPE(self, target, skill, ret, raceType, bossCheck)

	if bossCheck == nil then
		bossCheck = "YES"
	end

	if target.RaceType == raceType then
		if target.MonRank == "Boss" and bossCheck == "YES" then
			return 1;
		elseif target.MonRank == "Boss" and bossCheck == "NO" then
			return -1;
		end

		return 1;
	end

	return -1;
end

function S_R_COND_OWNER(self, target, skill, ret, raceType)

	local owner = GetOwner(self)

	if owner ~= nil then
		return 1;
	end

	return -1;
end

function S_R_COND_SCRIPT(self, target, skill, ret, funcName)
	local fun = _G[funcName];
	return fun(self, target, skill, ret);
end

function S_R_COND_RANDOM(self, target, skill, ret, ratio)

		if IMCRandom(1, 100) <= ratio then
		return 1;
	end

	return -1;
end

function S_R_COND_ABILITY(self, target, skill, ret, abilityName)
	
	if GetAbility(self, abilityName) ~= nil then
		return 1;
	end

	return -1;
end

function S_R_COND_NO_ABILITY(self, target, skill, ret, abilityName)
	
	if GetAbility(self, abilityName) ~= nil then
		return -1;
	end

	return 1;
end

function S_R_COND_OWNER_ABILITY(self, target, skill, ret, abilityName)

	local owner = GetOwner(self)

	if GetAbility(owner, abilityName) ~= nil then
		return 1;
	end

	return -1;
end

function S_R_COND_BUFF(self, target, skill, ret, buffName)
	if IsBuffApplied(self, buffName) == 'YES' then
		return 1;
	end
    
	return -1;
end

function S_R_COND_NO_BUFF(self, target, skill, ret, buffName)
	if IsBuffApplied(self, buffName) == 'NO' then
		return 1;
	end
    
	return -1;
end

function S_R_COND_FIRST_INDEX(self, target, skill, ret)

	if ret.HitIndex ~= 1 then
		return -1;
	end
	
	return 1;
end

function S_R_COND_UNAPPLIED_RANK(self, target, skill, ret, unappliedMonRank)
	local monRank = TryGetProp(target, "MonRank")
	if monRank == unappliedMonRank then
	    return -1;
	end
	
	return 1;
	
end
