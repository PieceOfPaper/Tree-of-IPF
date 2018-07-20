---- hardskill_wugushi.lua

function SCR_ARRIVE_THROWGUPOT(mon)
			local dx, dy = GetDir(mon)
			
	local owner = GetOwner(mon)

			local pcetc = GetETCObject(owner);

			local cal = GetClassByType("Item", pcetc['Wugushi_bosscard'])

			if cal ~= nil then
			local bossCls = GetClassByType("Monster", cal.NumberArg1);
				if bossCls ~= nil then
			local skillName = string.format("Mon_%s_Skill_1", bossCls.ClassName);
					local cls, cnt = GetClassList('Skill');
					local skill = GetClassByNameFromList(cls, skillName)
					if skill ~= nil then 
						UseMonsterSkillToDir(mon, skillName,  dx, dy)
					else
						print("can't find Skill ClassName : "..skillName)
					end
				else
					print("can't find Item Classid : "..pcetc['Wugushi_bosscard'])
				end
			end
end

function SCR_WUGUSHI_JINCANGU(self, sklID, damage, target, x, y, z)
	
    if x == nil and y == nil and z == nil then  
        x, y, z = GetPos(self)
    end
    x, y, z = GetRandomPos(self, x, y, z, 50);
    MslThrow(self, "I_cleric_jincangu_force#Dummy_skl_shot", 0.5, x, y, z, 5.0, 1.2, 0, 100, 2.0, "None", 1);
    sleep(1.2 * 1000);
    local skl = GetSkill(target, 'Wugushi_JincanGu');
    local skill = GET_MON_SKILL(target, 'Wugushi_JincanGu');

    local bomb = MONSKL_CRE_MON(target, skl, "JincanGu_Worm", x, y, z, 0, "", "BT_Wugushi_Jincangu", 0, 0);
	if bomb == nil then
		return;
	end

	if kdAngle == nil then
		kdAngle = 0;
	end
	bombTime = 3;
	SetOwner(bomb, target, 1);
	if bombTime > 0 then
        ChangeModel(bomb, "JincanGu_Worm");
		ChangeScale(bomb, 1, bombTime);
	end
    
	SetExProp_Str(bomb, "DEADEFT", "F_archer_jincangu_ground");
	SetExProp(bomb, "DEADEFT_SCL", 1);
    local damage = GET_SKL_DAMAGE(target, self, 'Wugushi_JincanGu');
    local power = damage;
	local curTime = imcTime.GetAppTime();
	SetExProp(bomb, "_B_DE_SECOND", curTime + bombTime);
	SetExProp(bomb, "_B_POWER", power);
	SetExProp(bomb, "_B_RANGE", 25);
	SetExProp(bomb, "_B_KDPOWER", kdPower);
	SetExProp(self, "SET_TOOL_VANGLE", kdAngle)
    mspd = 40
	bomb.FIXMSPD_BM = mspd;
	if mspd > 0.0 then
		InvalidateMSPD(bomb);
	end
end


function SCR_BTREE_WUGUSHI_JINCANGU(self, state, btree, prop)
	
	if IsDead(self) == 1 then
		return BT_FAILED;
	end

	if self.FIXMSPD_BM > 0 then
		local owner = GetTopOwner(self);
		local tgt = GET_BT_TOPHATE(owner)
		if tgt == nil then
			tgt = GET_NEAR_ENEMY(owner, 200);
		end

		if tgt ~= nil then
			MoveToTarget(self, tgt, 1);
		end
	end

	local curTime = imcTime.GetAppTime();
	local destTime = GetExProp(self, "_B_DE_SECOND");
	local restTime = math.floor(destTime - curTime);
		
	if restTime < 0 then
		local power = GetExProp(self, "_B_POWER");
		local range = GetExProp(self, "_B_RANGE");
		local kdPower = GetExProp(self, "_B_KDPOWER");
		local buckCnt = GetExProp(self, "_BUCK_CNT");

		PLAY_DEAD_EFT(self);
		if buckCnt == 0 then
			SCR_WUGUSHI_JINCANGU_DESTRUCT(self, power, range, kdPower);
		else
			local buckDelay = GetExProp(self, "_BUCK_DELAY");
			local buckSpd = GetExProp(self, "_BUCK_SPD");
			local buckAccel = GetExProp(self, "_BUCK_ACCEL");
			local lifeTime = GetExProp(self, "_BUCK_LIFE");
			local buckEft = GetExProp_Str(self, "_BUCK_EFT");
			local buckEftScale = GetExProp(self, "_BUCK_EFT_SCALE");

			local x, y, z = GetPos(self);
			local angle;
			if tgt == nil then
				angle = GetDirectionByAngle(self);
			else
				angle = GetAngleTo(self, tgt);
			end
			local angleList = {};			
			for i = 1 , buckCnt  do
				angleList[i] = angle + (i - 1) * 360 / buckCnt;
			end

			Dead(self);
			local delayTime = 0;
			for i = 1 , buckCnt do
				ShootServerMsl(self, delayTime, x, y, z, angleList[i], buckSpd, buckAccel, power, range, lifeTime, buckEft, buckEftScale);
				delayTime = delayTime + buckDelay;
			end

		end

		return BT_SUCCESS;
	end

	return BT_SUCCESS;

end

function SCR_WUGUSHI_JINCANGU_DESTRUCT(self, sklPower, range, kdPower)

	local skillName = "Wugushi_JincanGu";
	local objList, objCount = SelectObjectNear(self, self, range, 'ENEMY');
	for i = 1, objCount do
		local target = objList[i];
		local owner = GetOwner(self);
		if owner == nil then
			owner = self;
		end
--		damage = sklPower;
--        TakeDamage(self, target, "Wugushi_JincanGu", damage, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
	    local damage = GET_SKL_DAMAGE(owner, target, 'Wugushi_JincanGu');
	    local skill = GET_MON_SKILL(owner, 'Wugushi_JincanGu');
	    local bug_dmg_ratio = 2;
	    
	    damage = math.floor(damage + skill.SkillAtkAdd)
        TakeDamage(owner, target, "Wugushi_JincanGu", damage, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
	end

	Dead(self);

end

function SCR_WUGUSHI_Crescendo_Bane(self, skl)
    local targetList = GetHardSkillTargetList(self)
    for j = 1, #targetList do
        local target = targetList[j]
        local buff_list, buff_cnt = GetBuffList(target)
        if buff_cnt >= 1 then
            for i = 1, buff_cnt do
                if TryGetProp(buff_list[i], "Group3") == "Detoxify" and TryGetProp(buff_list[i], "RemoveBySkill") == "YES" and TryGetProp(buff_list[i], "Premium") ~= "PC" then
                    if GetExProp(buff_list[i], "Wugushi_CrescendoBane_FLAG") == 0 then
                        local remainTime = GetBuffRemainTime(buff_list[i])
                        local updatetime = TryGetProp(buff_list[i], "UpdateTime")
                        updatetime = updatetime * (1 - (skl.Level / 10))
                        SetBuffRemainTime(target, buff_list[i].ClassName, remainTime * (1 - (skl.Level / 10)))
                        SetBuffUpdateTime(buff_list[i], updatetime)
                        SetExProp(buff_list[i], "Wugushi_CrescendoBane_FLAG", 1)
                    end
                end
            end
        end
        local abil = GetAbility(self, 'Wugushi25')
        if abil ~= nil and abil.ActiveState == 1 and target.Attribute == "Poison" then
        local damage = GET_SKL_DAMAGE(self, target, skl.ClassName)
            TakeDamage(self, target, skl.ClassName, damage, "Poison", "None", "Melee", HIT_POISON, HITRESULT_BLOW, 0, 0)
        end
    end
end