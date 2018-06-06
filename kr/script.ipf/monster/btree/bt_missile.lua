

function SCR_INIT_MISSILE(self, target, eft, eftScale, finishEft, finishScl)

	AttachEffect(self, eft, eftScale, "MID");
	if target ~= nil then
		SetExArgObject(self, "MSL_TGT", target);
	end

	SetClientDeadScript(self, "MSL_DEAD_C", finishEft, finishScl);
end

function MSL_DEAD(self)

	local eftName = GetExProp_Str(self, "MSL_EFT");
	AttachEffect(self, eftName, 0);

	local finishEft = GetExProp_Str(self, "MSL_FIN_EFT");
	local finishScl = GetExProp(self, "MSL_FIN_EFT_S");
	PlayEffect(self, finishEft, finishScl, 0, "MID");

end

function SCR_BTREE_MISSILE(self, state, btree, prop)
	
	if IsDead(self) == 1 then
		return BT_FAILED;
	end

	local tgt = GetExArgObject(self, "MSL_TGT");
	if tgt == nil then
		return BT_FAILED;
	end

	MoveToTarget(self, tgt, 1);
	local objList, objCount = SelectObject(self, 10, 'ENEMY');
	for i = 1 , objCount do
		local target = objList[i]; 
		if IsKDSafeState(target) == 0 and IsDead(target) == 0 then
			
			MSL_DEAD(self);
			SetDeadScript(self, "None");

			local shooter = GetOwner(self);
			local skill;
			if shooter == nil then
				shooter = self;
				skill = GetNormalSkill(self);
			else
				local sklName = GetExProp(gol, "MSL_SKL");
				skill = GET_MON_SKILL(shooter, sklName);
			end

			local damage = SCR_LIB_ATKCALC_RH(shooter, skill);			
			TAKE_SCP_DAMAGE(shooter, target, damage, HIT_BASIC, ret.ResultType, 80, skill.ClassName);
			Dead(self);

			return BT_SUCCESS;
		end
	end

	return BT_SUCCESS;
	
end

function PLAY_DEAD_EFT(self)

	local finEft = GetExProp_Str(self, "DEADEFT");
	local finEftScale = GetExProp(self, "DEADEFT_SCL");
	PlayEffect(self, finEft, finEftScale);

end

function SCR_BTREE_TIMEBOMB(self, state, btree, prop)
	
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
			SELF_DESTRUCT(self, power, range, kdPower);
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

function SCR_BTREE_TIMEMON(self, state, btree, prop)
	
	if IsDead(self) == 1 then
		return BT_FAILED;
	end

	local curTime = imcTime.GetAppTime();
	local destTime = GetExProp(self, "_B_DE_SECOND");
	local restTime = math.floor(destTime - curTime);
		
	if restTime < 0 then
		local owner = GetOwner(self);
		local attacker = GET_BT_ATTACKER(owner);
		local monName = GetExProp_Str(self, "MonName");
		local lv = GetExProp(self, "MonLv");
		local range = 1;
		local layer = GetLayer(self);
		local x, y, z = GetPos(self);
		local mon1 = CREATE_MONSTER(self, monName, x, y, z, GetDirectionByAngle(self), GetCurrentFaction(self), GetLayer(self), lv);
		SetOwner(mon1, owner);
		if attacker ~= nil then
			InsertHate(mon1, attacker, 10);
		end
		
		Dead(self);
		PLAY_DEAD_EFT(self)
		return BT_SUCCESS;
	end

	Chat(self, tostring(restTime));
	return BT_SUCCESS;

end

function MINE_KILL_SELF(self)

	local bombEft = GetExProp_Str(self, "_EFT");
	local bombEftScl = GetExProp(self, "_EFT_SCALE");
	PlayEffect(self, bombEft, bombEftScl);
	
	ShowModel(self, 0);
	Dead(self);

end

function SCR_BTREE_MINE(self, state, btree, prop)

	if IsDead(self) == 1 then
		return BT_FAILED;
	end

	local range = GetExProp(self, "_RANGE");
	local objList, objCount = SelectObject(self, range, 'ENEMY');
	if objCount == 0 then
		return BT_SUCCESS;
	end

	--PlayEffect(self, "I_sys_caution_UI", 1.0, 1, "TOP");
	local resTime = GetExProp(self, "_RESTIME");
	if resTime > 0 then
		sleep(resTime * 1000);
	end
		
	
	objList, objCount = SelectObject(self, range, 'ENEMY');
	if objCount == 0 then
		MINE_KILL_SELF(self);
		return BT_SUCCESS;
	end

	local power = GetExProp(self, "_POWER");
	local kdPower = GetExProp(self, "_KDPOWER");

	local targetBuff = 	GetExProp_Str(self, "_TARGET_BUFF");
	
	local owner = GetOwner(self);
	local skill = GetNormalSkill(owner);
	local skillName = TryGetProp(skill,"ClassName")
	if skillName == nil then
	    return BT_FAILED;
	end
	
	
	local caltropskill = GetSkill(GetOwner(self), "QuarrelShooter_ScatterCaltrop")
	if caltropskill ~= nil then
	    skill = caltropskill;
	    skillName = caltropskill.ClassName;
	end
	
	local damage = SCR_LIB_ATKCALC_RH(owner, skill);	
	damage = damage * power;

	local created_skillName = GetExProp_Str(self, "CREATED_SKILL");

	for i = 1 , objCount do
		local target = objList[i]; 
		
        if TryGetProp(target, "MoveType") == 'Flying' then
            return BT_SUCCESS
        end
		
		if created_skillName == "Inquisitor_PearofAnguish" then
			local ownerSkill = GetSkill(owner, created_skillName);
			if ownerSkill ~= nil then
				RunScript('SUMMON_PEAROFANGUISH_DEAD_DELAT', self, target, ownerSkill, 0);
				return BT_SUCCESS;
			end
		end

		TAKE_SCP_DAMAGE(owner, target, damage, HIT_BASIC, HITRESULT_BLOW, kdPower, skillName);
		    
		if targetBuff ~= 'None' then			
		    AddBuff(owner, target, targetBuff);
		end
	end
	
	MINE_KILL_SELF(self);
	return BT_SUCCESS;

end



