-- padskill_obj.lua

function PAD_TGT_HEAL(self, skl, pad, target, tgtRelation, atkRate, consumeLife, useCount)
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	
	if IS_APPLY_RELATION(self, target, tgtRelation) then
		local damage = SCR_LIB_ATKCALC_RH(self, skl);
		Heal(target, damage * atkRate, 0);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end


function PAD_TGT_DAMAGE(self, skl, pad, target, tgtRelation, atkRate, consumeLife, useCount)
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return false;
	end
	
	if IS_APPLY_RELATION(self, target, tgtRelation) and IsSafe(target) == 'NO' then
		local damage = SCR_LIB_ATKCALC_RH(self, skl);
		local divineAtkAdd = skl.SkillAtkAdd;
		local addValue = 0;
		
		if CHECK_CONCURRENT_USE_COUNT(pad, "TgtDamageCount") == false then
			return false;
		end
		
		if GetPadArgNumber(pad, 1) ~= nil then
		    addValue = GetPadArgNumber(pad, 1);
		end
		divineAtkAdd = addValue - divineAtkAdd;
		
		if divineAtkAdd < 0 then
		    divineAtkAdd = 0;
		end
		
		TakeDamage(self, target, skl.ClassName, damage * atkRate + divineAtkAdd);
		
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);

		return true;
	end

	return false;
end

function PAD_SKILL_TGT_DAMAGE(self, skl, pad, target, tgtRelation, consumeLife, useCount)
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return false;
	end
	
    local targetList = GetHardSkillTargetList(self)
    for i = 1, #targetList do
        SetExProp(targetList[i], "IS_TARGET", 1)
    end
    
	if 1 ~= GetExProp(target, "IS_TARGET") then
	    return false
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		local damage = GET_SKL_DAMAGE(self, target, skl.ClassName);

		if CHECK_CONCURRENT_USE_COUNT(pad, "TgtDamageCount") == false then
			return false;
		end
		
		if GetPadArgNumber(pad, 1) ~= nil then
		    addValue = GetPadArgNumber(pad, 1);
		end
        
		TakeDamage(self, target, skl.ClassName, damage, skl.Attribute, skl.AttackType, skl.ClassType);
        AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
        SetExProp(target, "IS_TARGET", 0)
		return true;

	end

	return false;
end

function PAD_TGT_DAMAGE_IGNORE_CUSTOM(self, skl, pad, target, tgtRelation, atkRate, consumeLife, useCount, ignoreMonName)

	if target.ClassName == ignoreMonName then
		return;
	end

	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		local damage = SCR_LIB_ATKCALC_RH(self, skl);
		local divineAtkAdd = skl.SkillAtkAdd;
		local addValue = 0;
				
		if GetPadArgNumber(pad, 1) ~= nil then
		    addValue = GetPadArgNumber(pad, 1);
		end
		divineAtkAdd = addValue - divineAtkAdd;
		
		if divineAtkAdd < 0 then
		    divineAtkAdd = 0;
		end
		
		TakeDamage(self, target, skl.ClassName, damage * atkRate + divineAtkAdd);
		
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function PAD_TGT_DAMAGE_CUSTOM_SCP(self, skl, pad, target, tgtRelation, atkRate, consumeLife, useCount, customScp)
	
	local isTakeDamage = PAD_TGT_DAMAGE(self, skl, pad, target, tgtRelation, atkRate, consumeLife, useCount)
	if isTakeDamage == true then
		local scp = _G[customScp];
		if scp ~= nil then
			scp(self, skl, pad);
		end
	end
end

function PAD_TGT_ATTRIBUTE_DAMAGE(self, skl, pad, target, abilname, tgtRelation, attribute, atkRate, consumeLife, useCount)
	local abil = GetAbility(self, abilname);
	if abil == nil then
		return;
	end

	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then

		local damage = SCR_Get_MAXMATK(self);
		TakeDamage(self, target, skl.ClassName, damage * atkRate, attribute, "Magic", "Magic", HIT_MOTION, HITRESULT_BLOW);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end

end

function PAD_TGT_BUFF_AFTER_CHECK_ABI(self, skl, pad, target, ability, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)
	local owner = GetOwner(self);
	
	if nil == owner then
		return;
	end

	if nil == GetAbility(owner, ability) then
		return;
	end
	
	PAD_TGT_BUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate);
end

function PAD_TGT_SCRIPT(self, skl, pad, target, funcName)

	local func = _G[funcName];
	func(self, skl, pad, target);

end

function PAD_BUFF_MONRANK_SET_TIME(self, skl, pad, target, buffName, monRank, time)
	local targetMonRank = TryGetProp(target, "MonRank");
	if targetMonRank ~= nil then
		if targetMonRank == monRank then
			SetBuffRemainTime(target, buffName , time);
		end
	end
end

local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

function PAD_TGT_BUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle)
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return
	end
    
	local buff = nil;
	if 1 == GetExProp(skl, "FromBuffSeller") then
		local addtime = 0;
		local spellshopSkl = GetSkill(self, "Pardoner_SpellShop")
		if spellshopSkl ~= nil then
		    addtime = addtime + 420000 * spellshopSkl.Level;
		end
		
		local abil = GetAbility(self, "Pardoner4")
		if abil ~= nil then
		    addtime = addtime + 300000 * abil.Level;
		end

		SetExProp(skl, "FromBuffSeller", 0);
		applyTime = applyTime + addtime;

		buff = ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate, BUFF_FROM_AUTO_SELLER);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	
	elseif IS_APPLY_RELATION(self, target, tgtRelation) then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end
        
		if skl.ClassName == "Sapper_Cover" and target.ClassName == "PC" then
			return;
		end

		if 1 == saveHandle then
			SetExArgObject(self, "SaveOwner", GetOwner(self));
		end

		-- Concurrent Use Count 사용하는 경우에 대한 처리
		if CHECK_CONCURRENT_USE_COUNT(pad, buffName) == false then
			return;
		end
        
        if IS_PC(target) then
            local remainingTime = GetPadLife(pad)        
            if skl.ClassName == "Psychokino_Raise" then                
                local now = toint(imcTime.GetAppTimeMS())
                SetExProp(target, "Psychokino_Raise_remainingTime", remainingTime)
                SetExProp(target, "Psychokino_Raise_startTime", now)
            end
        end
        
		buff = ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
		if tgtRelation == "PARTY" and IS_PC(self) == true and IS_PC(target) == true then
			PartyBuffAdd(target, buffName)
		end	
		AddPadLife(pad, consumeLife);        
		AddPadUseCount(pad, useCount);
	end

	if buff ~= nil  then
		CHECK_SHAREBUFF_BUFF(target, buff, lv, arg2, applyTime, over, rate);
	end
end

function PAD_TGT_BUFF_HEAL(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle)
    if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return
	end
	
	local abilCleric20 = GetAbility(self, "Cleric20");
	local abilCleric21 = GetAbility(self, "Cleric21");
	local isSummon = 0;
	
	if abilCleric20 ~= nil and TryGetProp(abilCleric20, "ActiveState") == 1 then
	    tgtRelation = "FRIEND"
	end
	
	if IS_PC(target) == false and GetRelation(self, target) ~= "ENEMY" then
        local targetOwner = GetOwner(target);
        local relation = GetRelation(self, targetOwner)
        if IS_APPLY_RELATION(self, targetOwner, tgtRelation) then
            isSummon = 1;
        end
    end
    
	if abilCleric21 ~= nil and TryGetProp(abilCleric21, "ActiveState") == 1 then
        isSummon = 0;
	end
	
    if IS_APPLY_RELATION(self, target, tgtRelation) or isSummon == 1 then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end
        
		if 1 == saveHandle then
			SetExArgObject(self, "SaveOwner", GetOwner(self));
		end

		-- Concurrent Use Count 사용하는 경우에 대한 처리
		if CHECK_CONCURRENT_USE_COUNT(pad, buffName) == false then
			return;
		end
        
        if IS_PC(target) then
            local remainingTime = GetPadLife(pad)        
            if skl.ClassName == "Psychokino_Raise" then                
                local now = toint(imcTime.GetAppTimeMS())
                SetExProp(target, "Psychokino_Raise_remainingTime", remainingTime)
                SetExProp(target, "Psychokino_Raise_startTime", now)
            end
        end
        
        AddPadActiveCount(pad, 1);
		buff = ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
		if tgtRelation == "PARTY" and IS_PC(self) == true and IS_PC(target) == true then
			PartyBuffAdd(target, buffName)
		end	
		AddPadLife(pad, consumeLife);        
		AddPadUseCount(pad, useCount);
	end
end

function PAD_TGT_BUFF_BOSS_CHECK(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle, bossCheck)
    if bossCheck == nil then
        bossCheck = 0;
    end
    
    if bossCheck == 0 or TryGetProp(target, "MonRank") ~= "Boss" then
        PAD_TGT_BUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle)
    else
        return
    end
end

function PAD_TGT_BUFF_AFTER_CHECK_BUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, checkbuff, buffName, lv, arg2, applyTime, over, rate, saveHandle)

    if GetExProp(target, "BUNSIN") == 1 then
        return
    end
    
    if IsBuffApplied(target, checkbuff) == "YES" then
        return;
    elseif GetRelation(self, target) == tgtRelation then
        PAD_TGT_BUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle)
    end
end

function LEAVE_PAD_TGT_BUFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle)
	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end

		if skl.ClassName == "Sapper_Cover" and target.ClassName == "PC" then
			return;
		end

		if 1 == saveHandle then
			SetExArgObject(self, "SaveOwner", GetOwner(self));
		end
		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
		if tgtRelation == "PARTY" and IS_PC(self) == true and IS_PC(target) == true then
			PartyBuffAdd(target, buffName)
		end	
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end


function LEAVE_PAD_TGT_ABIL_BUFF(self, skl, pad, target, abilname, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle)
	local abil = GetAbility(self, abilname);
	if abil == nil then
		return;
	end
	
	local padLifeTime = GetPadLife(pad);
	if padLifeTime == 0 then
    	if IS_APPLY_RELATION(self, target, tgtRelation) then
    		if over == 0 and GetBuffByName(target, buffName) ~= nil then
    			return;
    		end
    		
    		if skl.ClassName == "Sapper_Cover" and target.ClassName == "PC" then
    			return;
    		end
    	
    		if 1 == saveHandle then
    			SetExArgObject(self, "SaveOwner", GetOwner(self));
    		end
    		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
    		if tgtRelation == "PARTY" and IS_PC(self) == true and IS_PC(target) == true then
    			PartyBuffAdd(target, buffName)
    		end	
    		AddPadLife(pad, consumeLife);
    		AddPadUseCount(pad, useCount);
    	end
    end
end

function LEAVE_PAD_ABIL_BUFF(self, skl, pad, target, abilname, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, saveHandle)
	local abil = GetAbility(self, abilname);
	if abil == nil then
		return;
	end
	
	local objList, cnt = GetPadObjectList(pad);
	local padLifeTime = GetPadLife(pad);
	if padLifeTime == 0 then
	    for i = 1, cnt do
	        target = objList[i]
        	if IS_APPLY_RELATION(self, target, tgtRelation) then
        		if over == 0 and GetBuffByName(target, buffName) ~= nil then
        			return;
        		end
        	
        		if 1 == saveHandle then
        			SetExArgObject(self, "SaveOwner", GetOwner(self));
        		end
        		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
        		if tgtRelation == "PARTY" and IS_PC(self) == true and IS_PC(target) == true then
        			PartyBuffAdd(target, buffName)
        		end
        		
        		AddPadLife(pad, consumeLife);
        		AddPadUseCount(pad, useCount);
        	end
    	end
    end
end

function PAD_TGT_BUFF_MON(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)

	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION_MON(self, target, tgtRelation) then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end

		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);				
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function PAD_TGT_BUFF_REMOVE(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, delOwerBuff)
	if delOwerBuff == nil then
		delOwerBuff = 0;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		
		if delOwerBuff == 0 then
		    RemoveBuff(target, buffName);
		else
			RemoveBuffByCaster(target, self, buffName);
		end
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end

    RemoveBuff(target, 'SadhuPossessionTemporaryImmune')
end


function PAD_TGT_BUFF_REMOVE_MON(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName)
	
	if IS_APPLY_RELATION_MON(self, target, tgtRelation) then
		RemoveBuff(target, buffName);

		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end


function PAD_TGT_BUFF_G_REMOVE_PC(self, skl, pad, target, tgtRelation, consumeLife, useCount, group1, group2, lv)

	if IS_APPLY_RELATION(self, target, tgtRelation) then
			RemoveBuffGroup(target, group1, group2, lv);

			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
		end
end


function PAD_TGT_BUFF_G_REMOVE_MON(self, skl, pad, target, tgtRelation, consumeLife, useCount, group1, group2, lv)

	if IS_APPLY_RELATION_MON(self, target, tgtRelation) then
			RemoveBuffGroup(target, group1, group2, lv);

			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
		end
end


function PAD_TGT_BUFF_ABIL(self, skl, pad, target, tgtRelation, abilName, consumeLife, useCount, buffName, arg2, applyTime, over, rate)

	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	local abil = GetAbility(self, abilName);
	if abil ~= nil then
		if IS_APPLY_RELATION(self, target, tgtRelation) then
			if over == 0 and GetBuffByName(target, buffName) ~= nil then
				return;
			end

			ADDPADBUFF(self, target, pad, buffName, skl.Level, arg2, applyTime, over, rate);					
			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
		end
	end
end

function PAD_TGT_BUFF_ABIL_OFF(self, skl, pad, target, tgtRelation, abilName, consumeLife, useCount, buffName, arg2, applyTime, over, rate)

	local abil = GetAbility(self, abilName);
	if abil == nil then
		if IS_APPLY_RELATION(self, target, tgtRelation) then
			if over == 0 and GetBuffByName(target, buffName) ~= nil then
				return;
			end

			ADDPADBUFF(self, target, pad, buffName, skl.Level, arg2, applyTime, over, rate);					
			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
		end
	end
end

function PAD_TGT_DAMAGE_ABIL(self, skl, pad, target, tgtRelation, abilName, damageRate, consumeLife, useCount)
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	local abil = GetAbility(self, abilName);
	if abil ~= nil then
		if IS_APPLY_RELATION(self, target, tgtRelation) then
			local atk = GET_SKL_DAMAGE(self, target, skl.ClassName);
			
			TakeDamage(self, target, skl.ClassName, atk * damageRate);
			
			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
		end
	end
end

function PAD_TGT_DAMAGE_ABIL_OFF(self, skl, pad, target, tgtRelation, abilName, damageRate, consumeLife, useCount)
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	local abil = GetAbility(self, abilName);
	if abil == nil then
		if IS_APPLY_RELATION(self, target, tgtRelation) then
			local atk = GET_SKL_DAMAGE(self, target, skl.ClassName);
			
			TakeDamage(self, target, skl.ClassName, atk * damageRate);
			
			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
		end
	end
end

function PAD_TGT_SET_BUFFUPDATETIME_BY_ABIL(self, skl, pad, target, tgtRelation, buffName, updateTime, abilName, consumeLife, useCount)
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	local abil = GetAbility(self, abilName);
	if abil ~= nil and TryGetProp(abil, "ActiveState") == 1 then
		if IS_APPLY_RELATION(self, target, tgtRelation) then
			local buffList = GetBuffList(target);
			for i = 1, #buffList do
			    local buff = buffList[i]
			    if buff ~= nil then
			        if buff.ClassName == buffName then
			            SetBuffUpdateTime(buff, updateTime);
                		AddPadLife(pad, consumeLife);
                		AddPadUseCount(pad, useCount);
			        end
			    end
			end
		end
	end
end

function PAD_TGT_BUFF_ONLYPC(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)

	if target.ClassName ~= "PC" then
		return;
	end
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end

		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);				
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end

end


function PAD_TGT_BUFF_AND_CHANGE_EFF(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, effName, scale)

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end

		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);				
		ChangePadEffect(pad, effName,scale);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end


function PAD_TGT_ABIL_BUFF(self, skl, pad, target, abilName, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)
	local abil = GetAbility(self, abilName);
	if abil == nil then
		return;
	end

	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end

		-- Concurrent Use Count 사용하는 경우에 대한 처리
		if CHECK_CONCURRENT_USE_COUNT(pad, buffName) == false then
			return;
		end

		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);				
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function PAD_TGT_BUFF_BASED_ON_REMAIN_PAD_COUNT(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, padCount, padOperator)

	local padList = GetSameSkillPadList(self, pad);
	local flag = #padList;

	if padOperator == 'EQ' then
        if flag ~= padCount then
            return;
        end
    elseif padOperator == 'OVER' then
        if flag < padCount then
            return;
        end
    elseif padOperator == 'UNDER' then
        if flag > padCount then
            return;
        end
    end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if over == 0 and GetBuffByName(target, buffName) ~= nil then
			return;
		end

		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);				
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end


function PAD_TGT_KNOCKDOWN(self, skl, pad, target, tgtRelation, kdType, kdPower, height, bounce, consumeLife, useCount)	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		
		if IS_PC(target) == true and skl.ClassName ~= "Paladin_Barrier" then
			--PC가 밀릴 때, 너무 많이 날려버리기 때문에 2로 나누자고 협의됨
			kdPower = kdPower / 2;
			--return;
		end
		
		if target.KDArmor ~= nil and target.KDArmor > 900 then
		    return ;
		end
		
		if skl.ClassName == "Rodelero_ShieldCharge" then
			if IS_PC(target) == false and target.MonRank == "Boss" then
				return ;
			end
		end
		
		if CHECK_CONCURRENT_USE_COUNT(pad, "TgtKDCount") == false then
			return;
		end
        
		local angle = GetAngleTo(self, target);
		if kdType == 'KB' then
            if skl.ClassName == 'Paladin_Barrier' then
                KnockBack(target, self, kdPower, angle, height, 1, 1);
            else
                KnockBack(target, self, kdPower, angle, height, 1);
            end		    
		elseif kdType == 'KD' then
		    KnockDown(target, self, kdPower, angle, height, 1);
		end

		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function PAD_KB_TO_RANGE(self, skl, pad, target, tgtRelation, range, atkRate, kdType, kdPower, height, bounce, consumeLife, useCount)
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	
	local px, py, pz = GetPadPos(pad);
	
	local list, cnt = SelectObjectPos(self, px, py, pz, range, 'ENEMY')
	for i = 1 , cnt do
		local tgt = list[i];
		PAD_TGT_KNOCKDOWN(self, skl, pad, tgt, tgtRelation, kdType, kdPower, height, bounce, 0, 0);
		PAD_TGT_DAMAGE(self, skl, pad, tgt, tgtRelation, atkRate, 0, 0)
	end

	AddPadLife(pad, consumeLife);
	AddPadUseCount(pad, useCount);
end

function PAD_TGT_ACTOR_VIBRATE(self, skl, pad, target, tgtRelation, time, power, freq, verticalSpd, consumeLife, useCount)
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		-- pad OnEnd에서 실행되는 leaveEvent는 Life와 useCount에 상관없이 실행시킬때 IsPadOnEnd로 체크하면된다.
		if IsPadOnEnd(pad) == 0 then
			return;
		end
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		ActorVibrate(target, time, power, freq, verticalSpd);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function PAD_TGT_ACTOR_VIBRATE_CONCORRENT_COUNT(self, skl, pad, target, tgtRelation, time, power, freq, verticalSpd, consumeLife, useCount)
	
	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if CHECK_CONCURRENT_USE_COUNT(pad, "ActorVibrateCount") == false then
			return;
		end

		ActorVibrate(target, time, power, freq, verticalSpd);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function PAD_TGT_FLY_MATH(self, skl, pad, target, tgtRelation, height, time, easing, consumeLife, useCount)
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then		
		FlyMath(target, height, time, easing);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function PAD_TGT_RAISE(self, skl, pad, target, tgtRelation, height, time, easing, consumeLife, useCount)
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		if IsPadOnEnd(pad) == 0 then
			return;
		end
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then		
		
		if CHECK_CONCURRENT_USE_COUNT(pad, "FlyMathCount") == false then
			return;
		end

		FlyMath(target, height, time, easing);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);

		if IS_PC(target) == false then
			if height > 0 then
				HoldMonScp(target);
				local moveType = target.MoveType;
				SetExProp_Str(target, "RAISE_MOVETYPE", moveType);
				target.MoveType = "Flying"
				SetExProp(target, 'PadFly'..GetPadID(pad), 1);
			else
				local flyAi = GetExProp(target, 'PadFly'..GetPadID(pad));
				if flyAi == 1 then
					RunScript('RAISE_DELAY', target, time)
				end
			end
		end
	end
end

function RAISE_DELAY(target, time)
	sleep(time*1000)
	target.MoveType = GetExProp_Str(target, "RAISE_MOVETYPE");
	UnHoldMonScp(target);
end

function PAD_TGT_PUSH_ANGLE(self, skl, pad, target, tgtRelation, angle, speed, keyName)

	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	if IS_APPLY_RELATION(self, target, tgtRelation) then	
		PushActorByAngle(target, angle, speed, keyName);
	end
end

function PAD_TGT_PUSH_POS(self, skl, pad, target, tgtRelation, x, y, z, inoutdir, speed, keyName)

	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	if IS_APPLY_RELATION(self, target, tgtRelation) then	
		PushActorByPos(target, x, y, z, inoutdir, speed, keyName);
	end
end


function PAD_TGT_PUSH_END(self, skl, pad, target, keyName)
	
	PushActorEnd(target, keyName);	
end

function PAD_CHECK_ACTIVATE(self, skl, pad, target, tgtRelation, needCount, padName)

	if false == IS_APPLY_RELATION(self, target, tgtRelation) then
		return;
	end

	local padList = GetSameSkillPadList(self, pad);
	if #padList < needCount then
		return;
	end

	local activeCnt = 0;
	local objList = {};
	for j = 1 , #padList do
		local pad = padList[j];
		local ac = GetPadActiveCount(pad);
		if ac > 0 then
			activeCnt = activeCnt + 1;
		end
	end

	if activeCnt >= needCount then
		EnableSameSkillPad(self, pad, padName);
	end
	
end


function PAD_ACTIVATE(self, skl, pad, target, tgtRelation)
	if IS_APPLY_RELATION(self, target, tgtRelation) then
	    AddPadActiveCount(pad, 1);
	end
end

function PAD_DEACTIVATE(self, skl, pad, target, tgtRelation)

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		AddPadActiveCount(pad, 1);
	end
end


function PAD_TGT_ZOMBIE_BUFF(self, skl, pad, target, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	if IsMyZombieSummon(self, target) == 1 then
		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
		return;
	end
end


function PAD_TGT_ZOMBIE_REMOVE_BUFF(self, skl, pad, target, buffName)

	if IsMyZombieSummon(self, target) == 1 then
		RemoveBuff(target, buffName);
	end
end


function PAD_TGT_SUMMON_BUFF(self, skl, pad, target, abilName, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)
	local abil = GetAbility(self, abilName);
	if abil == nil then
		return;
	end
	
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
    local list, cnt = GetAliveFolloweList(self);
    for i = 1, cnt do
        local from = list[i];
		
		ADDPADBUFF(self, from, pad, buffName, lv, arg2, applyTime, over, rate);
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end


function PAD_ADD_MONSTER_WALL(self, skl, pad, obj, monName)

	local objList, cnt = GetPadObjectList(pad);
	if GetPadLife(pad) <= 0 then
		return;
	end

	for i = 1 , cnt do
		local target = objList[i];
		local owner = GetOwner(target);
		if target.ClassName == monName and IsSameActor(owner, self) == "YES" then
			AddMonsterWall(self, target);			
		end
	end
end

function PAD_TGT_HOLD_MONAI(self, skl, pad, target, tgtRelation, onoff)

	if IS_APPLY_RELATION(self, target, tgtRelation) then

		if onoff == 'HOLD' then
			HoldMonScp(target);
		elseif onoff == 'UNHOLD' then
			UnHoldMonScp(target);
			StopMove(target)
		end
	end
end

function PAD_TGT_BUFF_AND_LINK(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, selfNode, targetNode, linkTexture, speed, easing)

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if GetBuffByName(target, buffName) ~= nil then
			return;
		end

		ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, 1, 100);				
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
		MakeLinkEftToTarget(self, target, linkTexture, selfNode, targetNode, speed, easing)
	end
end

function PAD_TGT_BUFF_AND_LINK_MON(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, selfNode, targetNode, linkTexture, speed, easing)

	if IS_APPLY_RELATION_MON(self, target, tgtRelation) then
		
		local buff = ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, 1, 100);		
		
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
		MakeLinkEftToTarget(self, target, linkTexture, selfNode, targetNode, speed, easing)
	end
end

function PAD_TGT_REMOVE_BUFF_AND_LINK(self, skl, pad, target, tgtRelation, buffName)

	RemoveBuff(target, buffName);
	RemoveLinkEftToTarget(self, target);

end

function PAD_TGT_SETEXPROP(self, skl, pad, target, tgtRelation, propStr, propNum)

	if IS_APPLY_RELATION(self, target, tgtRelation) and propStr ~= 'None' then
		
		SetExProp(target, propStr, propNum);
	end
end

function PAD_TGT_ADD_LIFE(self, skl, pad, target, lifeValue, useCount)
	AddPadLife(pad, lifeValue);	
	AddPadUseCount(pad, useCount);	
end

function PAD_CONTROL_ON(self, skl, pad, obj, tgtRelation)

	--if IsSameObject(self, obj) == 1 then
		--return;
	---end
	
	if GetPadLife(pad) <= 0 then
		return;
	end

	local padList = GetSameSkillPadList(self, pad);
	for j = 1 , #padList do
		local samepad = padList[j];
		if IsSameObject(GetPadAttachedObj(samepad), obj) == 1 then
			return;
		end
	end

	if GetPadAttachedObj(pad) ~= nil then
		return;
	end

	AttachToPad(pad, obj);

end

function PAD_MON_SET_AI(self, skl, pad, target, holdAi)	
	if nil == target then
		return;
	end

	if GetObjType(target) ~= OT_MONSTERNPC then
		return;
	end

	if GetRelation(self, target) ~= "ENEMY" then			
		return;
	end

	-- 컴패니언, 소서러로 소환된 몬스터등도 이 함수 같이 안돌도록 얘기했음
	-- 수정하고 있으면 전투기획과 얘기하고..
	local owner = GetOwner(target);
	if owner ~= nil and GetObjType(owner) == OT_PC then
		return;
	end

	if target.MonRank == 'Boss' then
		return;
	end

	if holdAi == 0 then				
		HoldMonScp(target);
	elseif holdAi == 1 then
		UnHoldMonScp(target);
	end
end

function PAD_FUNC_DIRECT(self, skil, pad, obj, script)
    local _func = _G[script]
    return _func(self, skil, pad, obj)
end

function PAD_TGT_BUFF_GRASS_AREA(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)

	local objList, cnt = GetPadObjectList(pad);
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		local x, y, z = GetPos(target)
		local isGrassArea = IsGrassSurface(target, x, y, z)
		if isGrassArea == 1 then
			ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);				
			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
			if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
				return;
			end
		end
	end
end

-- ConCurrentUseCount를 체크하여 현재 타겟에 패드가 작용해도 되는지 bool을 반환
function CHECK_CONCURRENT_USE_COUNT(pad, userValue) -- userValue: 패드에 현재 카운트 저장할 용도의 구분자 이름(스트링)
	local concurrentCount = GetConcurrentPadUseCount(pad);
	if concurrentCount > 0 then
		local curCount = GetPadUserValue(pad, userValue .. GetPadID(pad));
		if curCount >= concurrentCount then
			return false;
		end
		SetPadUserValue(pad, userValue .. GetPadID(pad), curCount+1);
	end

	return true; -- ConCurrentUseCount 안쓰는 경우에도 return true;
end

function PAD_TGT_INVINCIBILITY_BREAK(self, skl, pad, target)
    local buffList = GetBuffList(target);
    for j = 1 , #buffList do
        local buff = buffList[j];
        local buffKeyword = TryGetProp(buff, "Keyword");
        if buffKeyword == "Invincibility" then
            local buffClassName = TryGetProp(buff, "ClassName");
            RemoveBuff(target, buffClassName);
        end
    end
end

function PAD_TGT_ABIL_BUFF_ALONE_OR_WITH(self, skl, pad, target, abilName, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate, withPartyMember)
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end
	
	local abil = GetAbility(self, abilName);
    if abil ~= nil then
        if withPartyMember == 1 and GetObjType(self) == OT_PC then
            local list, cnt = GET_PARTY_ACTOR_BY_SKILL(self, 0);
            
            if cnt > 0 then
                for i=0, cnt do
                    local partyActor = list[i];
                    if partyActor ~= nil then

                        -- 파티원버프는 거리 200. 모이기 귀찮으니 걍 멀리서 받으셈
                        local dist = GetDistance(self, partyActor);
                        if dist <= 200 then
                            ADDBUFF(self, partyActor, buffName, lv, arg2, applyTime, over, rate);
                        end
                    end
                end
                return;
            end
        end

        -- 내자신 버프.... 이걸 다른사람들에게는?
        local buff = ADDBUFF(self, self, buffName, lv, arg2, applyTime, over, rate, skl.ClassID);

        -- 버프공유 링크 걸려있으면 전달
        if buff ~= nil and withPartyMember ~= 1 and buff.LinkBuff == 'YES' then
            local linkBuff = GetBuffByName(self, 'Link_Party');
            if linkBuff ~= nil then
                local linkCaster =  GetBuffCaster(linkBuff);
                if linkCaster ~= nil then
                    local objList = GetLinkObjects(linkCaster, self, 'Link_Party');      
                    if objList ~= nil then
                        for i = 1, #objList do
                            local partyMember = objList[i];
                            ADDBUFF(self, partyMember, buffName, lv, arg2, applyTime, over, rate);
                        end
                    end
                end
            end
        end
        
        -- Concurrent Use Count 사용하는 경우에 대한 처리
		if CHECK_CONCURRENT_USE_COUNT(pad, buffName) == false then
			return;
		end

		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
    end
end