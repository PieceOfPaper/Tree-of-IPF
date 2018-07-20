-- bossskill_lib.lua

function GET_MON_SKILL(self, skillName)

	if self == nil then
		return nil
	end

	local skill;
	if skillName == nil then
		skill = GetNormalSkill(self);
	else
		skill = GetSkill(self, skillName);
		if skill == nil then
			skill = GetNormalSkill(self);
		end
	end

	return skill;
end

function BEAT_KEYBOARD(self, target, skillName, effectName, eftScale, nodeName, beatCnt, totalTime, damTime, damRate)

	StartKeyboardBeat(target, self, skillName, effectName, eftScale, nodeName, beatCnt, totalTime, damTime, damRate);

end
	
function GET_SKL_DAMAGE(from, target, skillName)
	
	local skill = GET_MON_SKILL(from, skillName);
    
	local damage = SCR_LIB_ATKCALC_RH(from, skill);
	if damage == 0 then
		damage = 1;
	end
    
	return damage, ret;
end

function GET_ACTOR_NEAR_POS(self, searchRange, randomRange)

	local selfX, selfY, selfZ = GetPos(self);
	local x, y, z;
	local list, cnt = SelectObject(self, searchRange, 'ENEMY');
	if cnt > 0 then
		x, y, z = GetPos(list[IMCRandom(1, cnt)]);
		if randomRange == 0 then
			return x, selfY, z;
		end
		
		x, selfY, z = GetRandomPos(self, x, selfY, z, randomRange);
	else
		x, y, z = GetFrontRandomPos(self, searchRange * 0.5, searchRange * 0.5);
	end
	
	return x, y, z;	
end

function SKL_KNOCKDOWN(self, target, power)

	KNOCKDOWN(target, self, power, 45, 1);

end

function GET_NEARLEST_OBJ(self, x, y, z, range)

	local list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY');
	if cnt == 0 then
		return nil;
	end
	
	return list[1];
	
end

function KD_SELFDIR(self, target, kdPower)
	local angle = GetDirectionByAngle(target);
	KnockDown(target, self, kdPower, angle, 60.0, 1);

end

function KB_SELFDIR(self, target, kdPower)

	local angle = GetDirectionByAngle(target);
	KnockBack(target, self, kdPower, angle, 45.0, 1);

end


function KD_TARGET_TO_DIR(self, target, kdPower, skill, notApplyDiminishing)
    if notApplyDiminishing == nil then notApplyDiminishing = 0 end -- 점감 관련

	local hAngle = GetAngleTo(self, target);
	local vAngle = GetExProp(skill, "SET_TOOL_VANGLE")
	
	if vAngle == 0 then
		vAngle = GetExProp(self, "SET_TOOL_VANGLE")
	end

	KnockDown(target, self, kdPower, hAngle, vAngle, 1, 1, 1, notApplyDiminishing);
end

function KB_TARGET_TO_DIR(self, target, kdPower, skill, notApplyDiminishing)
    if notApplyDiminishing == nil then notApplyDiminishing = 0 end -- 점감 관련

	local angle = GetAngleTo(self, target);
	KnockBack(target, self, kdPower, angle, 45.0, 1, notApplyDiminishing);
end

function TAKE_SCP_DAMAGE(self, target, damage, hitType, resultType, kdPower, skillName, isKdSafe, KdType, takeDmgSetFunc, realAttacker, isNotDiminishing)
    if(isNotDiminishing == nil) then -- 점감 관련 , 적용하지 않을려면 1, 기본적으로 적용이 되도록 한다(0).
        isNotDiminishing = 0
    end

	if isKdSafe == nil then
		isKdSafe = 1;
	end
	
	if KdType == nil then
		KdType = 4;
	end
    
	if IS_PC(self) ~= true then
	    if skillName ~= "Mon_Forge_Skill_1" then
    		if isKdSafe == 1 and IsKDSafeState(target) == 1  and self.MonRank ~= "Boss" then
    			return;
    		end
	    end
	end
	
	local skill = GET_MON_SKILL(self, skillName);	
	if damage == 0 then
		damage = SCR_LIB_ATKCALC_RH(self, skill);
	end

	if target.MaxDefenced_BM > 0 then
		TakeDamage(self, target, skillName, 0, skill.Attribute, skill.AttackType, skill.ClassType, HIT_SAFETY, HITRESULT_NONE);
		return;
	end
	
	if skillName == "ENCHANTBOMB" then
	    local damage = IMCRandom(self.MINPATK + self.MINMATK, self.MAXPATK + self.MAXMATK)
	    TakeDamage(self, target, 'None', damage, 'Melee', 'Magic', 'Magic');
	    return;
	end
	
	local resultType;
	if realAttacker ~= nil then
		SetExProp(self, "REAL_ATTACKER_HANDLE", GetHandle(realAttacker));
	else
		DelExProp(self, "REAL_ATTACKER_HANDLE");
	end

	if takeDmgSetFunc ~= nil then
		local arg = DeclTakeDamageArg();
		takeDmgSetFunc(arg);	
		resultType = TakeDamageExSuspend(self, target, skillName, damage, ToPointer(arg));
	else
		resultType = TakeDamageSuspend(self, target, skillName, damage);
	end
	
	local isCheckSklKdProp = GetExProp(self, "CHECK_SKL_KD_PROP");			

	if isCheckSklKdProp == 1 then
		kdPower = 0;
	end

	if kdPower == nil then
		return;
	end

	if kdPower < 0 then
		return;
	end
--
	--세이프티관련 처리
	if (target.MaxDefenced_BM == 0 or GetExProp(self, "SUBZEROSHIELD") == 0) and IsBuffApplied(target, "PainBarrier_Buff") == "NO" and IsBuffApplied(target, "Lycanthropy_Buff") == "NO" and IsBuffApplied(target, "GT_STAGE_10_ROOT") == "NO" then
		DelExProp(self, "SUBZEROSHIELD")
		if resultType == 3 or resultType == 4 then
			if KdType == 3 then                
				KB_TARGET_TO_DIR(self, target, kdPower, skill, isNotDiminishing);
			elseif KdType == 4 then                
				KD_TARGET_TO_DIR(self, target, kdPower, skill, isNotDiminishing);
			end
		end
	end
end

function SPLASH_DAMAGE(self, x, y, z, range, skillName, kdPower, ignorePC, knockType, innerRange, takeDmgSetFunc, realAttacker)
	if "NO" == IsValidPos(self, x, y, z) then
		return;
	end

	local isCheckSklKdProp = GetExProp(self, "CHECK_SKL_KD_PROP");
	
	local sklClass = GetClass("Skill", skillName);
	local mySkl = GetSkill(self, skillName);
	local mySR = 1;
	if mySkl ~= nil then
	    InvalidateObjectProp(mySkl, "SkillSR");
        mySR = mySkl.SkillSR;
    else
        if sklClass ~= nil then
            mySR = sklClass.SklSR
        else
            mySR = self.SR
        end
    end

	
	local checkHide = 1;
	local list, cnt = nil, 0;
	if innerRange ~= nil and innerRange > 0 then
		list, cnt = SelectObjectByDonut(self, x, y, z, innerRange, range, "ENEMY", 0, checkHide);
	else
		if IS_PC(self) == true then
			list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY', 0, 1, checkHide);	
		else
			list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY', 0, 0, checkHide);
		end
	end

	local Elementalist4_abil = nil;
	if skillName == 'Elementalist_Hail' then
		Elementalist4_abil = GetAbility(self, 'Elementalist4');
	end
	
	local Hoplite25_abil = nil;
	if skillName == 'Hoplite_ThrouwingSpear' then
		Hoplite25_abil = GetAbility(self, 'Hoplite25');
	end
	
	local Shinobi7_abil = nil;
	if skillName == 'Shinobi_Mokuton_no_jutsu' then
		Shinobi7_abil = GetAbility(self, 'Shinobi7');
	end
	
	local ignoreFlyBuffList = {
	                        "Raise_Debuff"
                            }
    
	for j = 1, cnt do
		local tgt = list[j];
		local isIgnoreFlyBuff = 0;
		if IS_PC(tgt) == true then
            for i = 1, #ignoreFlyBuffList do
                if IsBuffApplied(tgt, ignoreFlyBuffList[i]) == "YES" then
                    isIgnoreFlyBuff = 1;
                end
            end
        end
        
		if (0 == IsJumping(tgt) or isIgnoreFlyBuff == 1) and (ignorePC ~= true or false == IS_PC(tgt)) then
			local damage = GET_SKL_DAMAGE(self, tgt, skillName);
			if self.GroupName == "Monster" then
				TAKE_SCP_DAMAGE(self, tgt, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName, 1, knockType, takeDmgSetFunc, realAttacker);
			else
			    if sklClass ~= nil then
				    TAKE_SCP_DAMAGE(self, tgt, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName, 1, sklClass.KnockDownHitType, takeDmgSetFunc, realAttacker);
				else
				    TAKE_SCP_DAMAGE(self, tgt, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName, 1, knockType, takeDmgSetFunc, realAttacker);
				end
			end					
			isCheckSklKdProp = GetExProp(self, "CHECK_SKL_KD_PROP");
			if isCheckSklKdProp == 0 and sklClass ~= nil and IsBuffApplied(tgt, "PainBarrier_Buff") == "NO" and IsBuffApplied(tgt, "Lycanthropy_Buff") == "NO" and IsBuffApplied(tgt, "GT_STAGE_10_ROOT") == "NO" then			
				local angle = GetAngleToPos(tgt, x, z);
				if sklClass.KnockDownHitType == 3 then					
					KnockBack(tgt, self, sklClass.KDownValue, angle, sklClass.KDownVAngle, sklClass.kdBound);
				elseif sklClass.KnockDownHitType == 4 then
					KnockDown(tgt, self, sklClass.KDownValue, angle, sklClass.KDownVAngle, sklClass.kdBound);
				end				
			end

			if Elementalist4_abil ~= nil then
				if IMCRandom(1, 100) < Elementalist4_abil.Level * 5 then
					AddBuff(self, tgt, 'Freeze', 1, 0, 5000, 1)
				end
			end
			
		    if Hoplite25_abil ~= nil then
				if IMCRandom(1, 100) < Hoplite25_abil.Level * 15 then
					AddBuff(self, tgt, 'UC_bound', 1, 0, 7000, 1)
				end
			end
			
		    if Shinobi7_abil ~= nil then
		        AddBuff(self, tgt, 'UC_bound', 1, 0, 3000 + Shinobi7_abil.Level * 1000, 1)
			end
			
		    if skillName == "Falconer_BlisteringThrash" and IMCRandom(1, 100) < 30 then
		        AddBuff(self, tgt, 'Blistering_Debuff', 1, 0, 10000, 1)
			end
		end
	
		if IS_PC(self) == true then
			mySR = mySR - tgt.SDR;

			if mySR <= 0 then
				break;
			end 
		end
	end
		
end

function SPLASH_DAMAGE_FOR_THROW_EQUIP_OBJECT(self, damage, x, y, z, range, skillName, kdPower, ignorePC, knockType, innerRange, takeDmgSetFunc, realAttacker)
	if "NO" == IsValidPos(self, x, y, z) then
		return;
	end

	local isCheckSklKdProp = GetExProp(self, "CHECK_SKL_KD_PROP");
	
	local sklClass = GetClass("Skill", skillName);
	local mySkl = GetSkill(self, skillName);
	local mySR = 1;
	if mySkl ~= nil then
	    InvalidateObjectProp(mySkl, "SkillSR");
        mySR = mySkl.SkillSR;
    else
        if sklClass ~= nil then
            mySR = sklClass.SklSR
        else
            mySR = self.SR
        end
    end

	
	local checkHide = 1;
	local list, cnt = nil, 0;
	if innerRange ~= nil and innerRange > 0 then
		list, cnt = SelectObjectByDonut(self, x, y, z, innerRange, range, "ENEMY", 0, checkHide);
	else
		if IS_PC(self) == true then
			list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY', 0, 1, checkHide);	
		else
			list, cnt = SelectObjectPos(self, x, y, z, range, 'ENEMY', 0, 0, checkHide);
		end
	end

	local Elementalist4_abil = nil;
	if skillName == 'Elementalist_Hail' then
		Elementalist4_abil = GetAbility(self, 'Elementalist4');
	end
	
	local Hoplite25_abil = nil;
	if skillName == 'Hoplite_ThrouwingSpear' then
		Hoplite25_abil = GetAbility(self, 'Hoplite25');
	end
	
	local Shinobi7_abil = nil;
	if skillName == 'Shinobi_Mokuton_no_jutsu' then
		Shinobi7_abil = GetAbility(self, 'Shinobi7');
	end
	
	local ignoreFlyBuffList = {
	                        "Raise_Debuff"
                            }
    
	for j = 1, cnt do
		local tgt = list[j];
		local isIgnoreFlyBuff = 0;
		if IS_PC(tgt) == true then
            for i = 1, #ignoreFlyBuffList do
                if IsBuffApplied(tgt, ignoreFlyBuffList[i]) == "YES" then
                    isIgnoreFlyBuff = 1;
                end
            end
        end
        
		if (0 == IsJumping(tgt) or isIgnoreFlyBuff == 1) and (ignorePC ~= true or false == IS_PC(tgt)) then
		    if damage == nil then
			    damage = GET_SKL_DAMAGE(self, tgt, skillName);
			end
			
			if self.GroupName == "Monster" then
				TAKE_SCP_DAMAGE(self, tgt, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName, 1, knockType, takeDmgSetFunc, realAttacker);
			else
			    if sklClass ~= nil then
				    TAKE_SCP_DAMAGE(self, tgt, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName, 1, sklClass.KnockDownHitType, takeDmgSetFunc, realAttacker);
				else
				    TAKE_SCP_DAMAGE(self, tgt, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName, 1, knockType, takeDmgSetFunc, realAttacker);
				end
			end					
			isCheckSklKdProp = GetExProp(self, "CHECK_SKL_KD_PROP");
			if isCheckSklKdProp == 0 and sklClass ~= nil and IsBuffApplied(tgt, "PainBarrier_Buff") == "NO" and IsBuffApplied(tgt, "Lycanthropy_Buff") == "NO" and IsBuffApplied(tgt, "GT_STAGE_10_ROOT") == "NO" then			
				local angle = GetAngleToPos(tgt, x, z);
				if sklClass.KnockDownHitType == 3 then					
					KnockBack(tgt, self, sklClass.KDownValue, angle, sklClass.KDownVAngle, sklClass.kdBound);
				elseif sklClass.KnockDownHitType == 4 then
					KnockDown(tgt, self, sklClass.KDownValue, angle, sklClass.KDownVAngle, sklClass.kdBound);
				end				
			end

			if Elementalist4_abil ~= nil then
				if IMCRandom(1, 100) < Elementalist4_abil.Level * 5 then
					AddBuff(self, tgt, 'Freeze', 1, 0, 5000, 1)
				end
			end
			
		    if Hoplite25_abil ~= nil then
				if IMCRandom(1, 100) < Hoplite25_abil.Level * 15 then
					AddBuff(self, tgt, 'UC_bound', 1, 0, 7000, 1)
				end
			end
			
		    if Shinobi7_abil ~= nil then
		        AddBuff(self, tgt, 'UC_bound', 1, 0, 3000 + Shinobi7_abil.Level * 1000, 1)
			end
			
		    if skillName == "Falconer_BlisteringThrash" and IMCRandom(1, 100) < 30 then
		        AddBuff(self, tgt, 'Blistering_Debuff', 1, 0, 10000, 1)
			end
		end
	
		if IS_PC(self) == true then
			mySR = mySR - tgt.SDR;

			if mySR <= 0 then
				break;
			end 
		end
	end
		
end

function TAKE_SKILL_SCP_DAMAGE(self, target, skill, dmgRate, isKdSafe)
	
	local kdPower = skill.KDownPower;
	local KdType = skill.KnockDownHitType;
	
	if skill.ClassName == 'Cataphract_Rush' and OT_MONSTERNPC == GetObjType(target) 
		and target.MoveType == "Holding" then		
		KdType = 1;
	end
	local atk = SCR_LIB_ATKCALC_RH(self, skill);
	local damage = 0;
	damage = atk * dmgRate;

	TAKE_SCP_DAMAGE(self, target, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skill.ClassName, isKdSafe, KdType);

end

function CREATE_PART_MON(self, x, y, z, className, objFunc, lifeTime)

	local mon1obj = CreateGCIES('Monster', className);
	if mon1obj == nil then
		return nil;
	end

	local ofunc = _G[objFunc];
	ofunc(mon1obj, self);
		
	local mon = CreateMonster(self, mon1obj, x, y, z, GetDirectionByAngle(self), 1);
	SetLifeTime(mon, lifeTime);
	SetPartOwner(mon, self);
	return mon;

end
