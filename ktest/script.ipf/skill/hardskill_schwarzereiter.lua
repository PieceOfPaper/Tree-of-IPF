-- hardskill_schwarzereiter.lua


function SCR_BUFF_ENTER_RetreatShot(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_RetreatShot(self, buff, arg1, arg2, RemainTime, ret, over)

    local ridingCompanion = GetRidingCompanion(self);
    if ridingCompanion == nil then
        return 0;
    end
    
	if IsMoving(self) ~= 1 or IsUsingNormalSkill(self) == 1 then
		return 1;
	end
	
	local angle = GetDirectionByAngle(self) + 180;
	local skill = GetSkill(self, "Schwarzereiter_RetreatShot")
	local forceDist = 200;
	local speed = 500;
	local target = nil;
	local damage = 0;
	local sx, sy, sz = GetPos(self);
	local ax, az = GetXZFromDistAngle(forceDist, angle);
	local ex = sx + ax;	
	local ez = sz + az;	
	local width = 40;
	local objList, objCount = SelectObjectBySquareCoor(self, "ENEMY", sx, sy, sz, ex, sy, ez, width, 50);
	if objCount > 0 then
		target = objList[1];
		damage = SCR_LIB_ATKCALC_RH(self, skill);
	end
	
	local loopCount = math.min(objCount, 15);	-- 최대 15마리 제한 --
	
	for i = 1, loopCount do
		local target = objList[i];
		ShootForceByAngle(self, skill, target, damage, "None", 1.0, angle, forceDist, speed, HIT_BASIC, HITRESULT_BLOW);
	end
	return 1;
end


function SCR_BUFF_LEAVE_RetreatShot(self, buff, arg1, arg2, over)

	local skill = GetSkill(self, "Schwarzereiter_RetreatShot")
	SKL_TOGGLE_ON(self, skill, 0);
end

function SCR_BUFF_ENTER_AssaultFire_Buff(self, buff, arg1, arg2, over)
    AddLimitationSkillList(self, "CrossBow_Attack");
    AddLimitationSkillList(self, "Pistol_Attack");
    AddLimitationSkillList(self, "Schwarzereiter_RetreatShot");
    AddLimitationSkillList(self, "Schwarzereiter_AssaultFire");
end

function SCR_BUFF_UPDATE_AssaultFire_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local ridingCompanion = GetRidingCompanion(self);
    if ridingCompanion == nil then
        return 0;
    end
    
	if IsUsingNormalSkill(self) == 1 then
		return 1;
	end
	
	local angle = GetDirectionByAngle(self);
	local skill = GetSkill(self, "Schwarzereiter_AssaultFire")
	local forceDist = 200;
	local speed = 500;
	local target = nil;
	local damage = 0;
--	local sx, sy, sz = GetPos(self);
--	local ax, az = GetXZFromDistAngle(forceDist, angle);
--	local ex = sx + ax;	
--	local ez = sz + az;	
--	local width = 30;
--	local objList, objCount = SelectObjectBySquareCoor(self, "ENEMY", sx, sy, sz, ex, sy, ez, width, 50);
	local x, y, z = GetPos(self);
	local selectRange = 170;
	local selectAngle = 30;
	local objList, objCount = SelectObjectByFan(self, 'ENEMY', x, y, z, selectRange, selectAngle);
	if objCount > 0 then
		target = objList[1];
		damage = SCR_LIB_ATKCALC_RH(self, skill);
	end
	
	local loopCount = math.min(objCount, 15);	-- 최대 15마리 제한 --
	
	for i = 1, loopCount do
		local target = objList[i];
		ShootForceByAngle(self, skill, target, damage, "None", 1.0, angle, forceDist, speed, HIT_BASIC, HITRESULT_BLOW);
	end
	return 1;
end


function SCR_BUFF_LEAVE_AssaultFire_Buff(self, buff, arg1, arg2, over)

	local skill = GetSkill(self, "Schwarzereiter_AssaultFire")
	SKL_TOGGLE_ON(self, skill, 0);
	ClearLimitationSkillList(self);
end



function SCR_LIMACON_SPEND_SP(self, target, skl, ret, spendSP, abilName)
	RemoveBuff(self, 'Limacon_Buff');
end