
function SCR_HIT_TELEK(self, from, skill, splash, ret)
	
	NO_HIT_RESULT(ret);
	ret.Damage = 0;	
	ret.ResultType = HITRESULT_BLOW;
	ret.HitType = HIT_NOHIT;
	ret.EffectType = HITEFT_NO;
	

	-- SR������ ���������� ����� ù��°�� �����ϰ� �����ϵ�����.
	local teleCastTime = GetExProp(from, "TELE_TIME");
	if teleCastTime ~= nil then		
		if teleCastTime + 1 > imcTime.GetAppTime() then
			return;
		end
	end
	SetExProp(from, "TELE_TIME", imcTime.GetAppTime());

			
	local throwCount = SCR_GET_Telekinesis_ThrowCount(skill);	
	local throwDist = SCR_GET_Telekinesis_ThrowDist(skill);
	local holdTime = SCR_GET_Telekinesis_Holdtime(skill) * 1000;
	
	local key = GetSkillSyncKey(from, ret);
	SendSyncPacket(from, key);
	local ret = Telekinesis(from, self, skill, ret, throwDist, throwCount, holdTime);	
	if ret == 1 then
		ActorVibrate(self, 7, 1, 25, 0.1);
	end
	SendEndSyncPacket(from, key);
		
end

function TELEK_HIT_GROUND(self, attacker, buff, throwDist, remainCount, angle)

	local skillName = GetExProp_Str(buff, "SKILLNAME");
	local skill = GetSkill(attacker, skillName);

	local damage = SCR_LIB_ATKCALC_RH(attacker, skill);
	
	local distBonus = 0.15 * math.pow(math.max(0.0001, throwDist - 50), 0.5) ;
	damage = damage * (1 + (0.5 * distBonus));
	
	local sklAtkAdd = skill.SkillAtkAdd;
	if self.ClassName == 'skill_bakarine_E' then
		sklAtkAdd = sklAtkAdd * 1.5;
	end

	local syncKey = GenerateSyncKey(self);
	StartSyncPacket(self, syncKey);

	TakeDamage(attacker, self, skill.ClassName, damage, "Melee", "Magic", "Magic", HIT_BASIC, HITRESULT_BLOW);

	local splCount = SCR_GET_Telekinesis_ThrowCount(skill);
	local splRange = 20;
	SPL_DAMAGE_TO_NEAR_ENEMY(attacker, self, skill, splRange, splCount);
	EndSyncPacket(self, syncKey);
	
	if remainCount == 1 then
		RunScript("SELF_KD", self, angle, syncKey);
		if attacker.Gender == 2 then
		 PlaySound(attacker, "voice_wiz_telekinesis_shot")
		else
		PlaySound(attacker, "voice_wiz_m_telekinesis_shot")
		end
	end
	
	return syncKey;
end

function SELF_KD(self, angle, syncKey)
	sleep(100);
	StartSyncPacket(self, syncKey);
	KnockDown(self, self, 350.0, angle, 89.0, 2, 1, 1);
	PlayEffect(self, 'F_burstup008_smoke1', 1, 'BOT');
	EndSyncPacket(self, syncKey);
end

function SPL_DAMAGE_TO_NEAR_ENEMY(attacker, target, skill, range, splCount)

	local faction = GetCurrentFaction(target);
	local objList, objCount = SelectObjectNear(attacker,  target, range, "ENEMY");
	local applyCount = 0;

	for i = 1, objCount do	
		if applyCount >= splCount then
			break;
		end
		
		local obj = objList[i];
		if IsSameActor(obj, target) == "NO" then
			
			local damage = SCR_LIB_ATKCALC_RH(attacker, skill);			
			
			damage = damage * 0.5;
			TakeDamage(attacker, obj, skill.ClassName, damage, "None", "None", "Magic", HIT_BASIC, HITRESULT_BLOW);			
			
			applyCount = applyCount + 1;
		end		
	end
	
end

function SCR_GET_SLOW_MAXSPL(skill)

	return 1 + skill.Level;

end

function SCR_GET_SLOW_SR(skill)

	return 1 + skill.Level;

end

DEF_WALL_WIDTH = 20;
DEF_WALL_ADD_WIDTH = 5;

function SELF_KB(self, angle, knockBackPower, sleepTime)
	sleep(sleepTime);
	KnockBack(self, self, knockBackPower, angle, 45.0, 2);
end

-- ��ں�
function CREATE_WIZ_BONFIRE(self, skill)

	local skillRange = 40;	
	local itemList = SELECT_PICKABLE_ITEM(self, skillRange);
	if #itemList == 0 then
		return 1;
	end
	
	local item = itemList[1];
	local x, y, z = GetPos(item);
	if 0 == KillFieldItem(item) then
		return 0;
	end
	
	PlayEffect(item, "None", 2);
	 -- ������ ����, - ���ӽð�
	 -- ���� - ȸ���ӵ�, �ݰ�, ���ӽð� ����
	local lifeTime =  skill.Level * 5;
	
	local expelRange = 60;
	local mon1 = CREATE_NPC(self, "bonfire_1", x, y, z, 0, GetCurrentFaction(self), GetLayer(self), nil, nil, "WIZ_BONFIRE", 50, self.Lv, "WIZ_BONFIRE", "WIZ_BONFIRE");
	if mon1 == nil then
		return 0;
	end

	SetHittable(mon1, 0);
	SetLifeTime(mon1, lifeTime);
	SetOwner(mon1, self, 1);
	SetExProp(mon1, "EXPELRANGE", expelRange);
	return 1;
	
end

function SCR_WIZ_BONFIRE_TS_DEAD_ENTER(self)

	SetZombie(self);

end

function SCR_WIZ_BONFIRE_ENTER(self, target)

	local buffLevel = self.Lv;
	AddBuff(self, target, "SPAndStaUP", buffLevel, 0, 0, 1);

end

function SCR_WIZ_BONFIRE_LEAVE(self, target)

	local buffLevel = self.Lv;
	AddBuff(self, target, "SPAndStaUP", buffLevel, 0, 0, -1);

end

function SCR_WIZ_BONFIRE_TS_BORN_ENTER(self)

	

end

function SCR_WIZ_BONFIRE_TS_BORN_UPDATE(self)
	
	local x, y, z = GetPos(self);
	local expelRange = GetExProp(self, "EXPELRANGE");
	local list, cnt = SelectObject(self, expelRange + 10, 'ENEMY');
	for i = 1, cnt do
		local tgt = list[i]; 
			-- if Is������or����� (tgt ) == 1 then
		ExpelMonster(tgt, x, y, z, expelRange);
	end	
end

function SELECT_PICKABLE_ITEM(pc, range)

	local itemList = {};
	local pcName = GetName(pc);
	local objList, objCount = SelectObject(pc, range, 'ALL', 1);
	for index = 1, objCount do
		local obj = objList[index];
		if 1 == IsMyItem(obj) and 1 == IsPickable(obj) then
			itemList[#itemList + 1] = obj;
		end
	end
	
	return itemList;
end

-- �Ұ�
function SKILL_CAST_INCINERATION(self, skill)

	local range = GET_INCINERATION_RANGE(skill);
	local itemList = SELECT_PICKABLE_ITEM(self, range);
	
		-- ������ �����ֵ� ������ ��������
	for i = 1, #itemList do
		for j = 1, #itemList do
			local dist_i = GetDistance(self, itemList[i]);
			local dist_j = GetDistance(self, itemList[j]);
			if dist_i < dist_j then
				local item = itemList[i];
				itemList[i] = itemList[j];
				itemList[j] = item;
			end
		end
	end

	local propName = "TGTED_" .. GetHandle(self);
	for i = 1 , #itemList do
	local item = itemList[i];
		SetExProp(item, propName, 1);
		AttachEffect(item, "#S#ItemDest_Cast", 12);
	end

end

function SKILL_INCINERATION(self, from, skill, splash, ret)

	local range = GET_INCINERATION_RANGE(skill);
	local itemList = SELECT_PICKABLE_ITEM(self, range);
	local splRange = 40;
	local splCount = 2;
	
	local propName = "TGTED_" .. GetHandle(self);
		
	local itemCount = SCR_GET_Dislooting_Ratio(skill);			-- �Ұ��� ������ ��
	if itemCount > #itemList then
		itemCount = #itemList;
	end

	for i = 1 , itemCount do
	local item = itemList[i];
		if GetExProp(item, propName) == 1 then
			if 1 == KillFieldItem(item) then
				PlayEffect(item, "#S#ItemDestruct", 2);
				SPL_DAMAGE_TO_NEAR_ITEM(self, item, skill, splRange, splCount);
			end
		end
	end
	
	NO_HIT_RESULT(ret);
	
end

function SPL_DAMAGE_TO_NEAR_ITEM(self, item, skill, range, splCount)

	local sellPrice = GetSellPrice(item);
	local objList, objCount = SelectObject(item, range, 'ALL');
	local applyCount = 0;
	for i = 1, objCount do
		if applyCount >= splCount then
			break;
		end
	
		local obj = objList[i];
		if GetRelation(self, obj) == "ENEMY" and 1 == IsHittable(obj) then
			local damage = SCR_LIB_ATKCALC_RH(attacker, skill);			
			
			damage = damage * (skill.Level + 5) / 6;
			damage = damage * sellPrice / 10;
			TakeDamage(self, obj, skill.ClassName, damage, "None", "None", "Magic", HIT_BASIC, HITRESULT_BLOW);
			applyCount = applyCount + 1;
		end
	end

end


function WIZ_SUMMON_SALAMENDER(self, skill)

	SCR_KILL_FOLLOWER_BY_NAME(self, "Salamander_03");
	
	local skillLevel = skill.Level;
	local skillProp = GetClass("Skill", skillName);
	local skillRange = 50;
	if skillProp ~= nill then
		skillRange = skillProp.MaxR;
	end
	local lifeTime = SCR_GET_SummonSalamander_LifeTime(skill);
		
	local x, y, z = GetFrontPos(self, skillRange);
	local mon1 = CREATE_SUMMON(self, "Salamander_03", x, y, z, 0, self.Lv);
	if mon1 == nil then
		return 0;
	end
	
	SetLifeTime(mon1, 9999);

	local searchRangeFix = skillLevel * 0.1;
	AddSearchRangeFix(mon1, searchRangeFix);
	mon1.MHP_BM = mon1.MHP_BM + self.MHP * SCR_GET_SummonSalamander_HPBonus(skill) * 0.01;
	mon1.ATK_BM = mon1.ATK_BM + self.INT * SCR_GET_SummonSalamander_ATKBonus(skill) * 0.01;
	InvalidateStates(mon1);
	AddHP(mon1, mon1.MHP);
	SetOwner(mon1, self, 1);
	return 1;

end

function ADD_ENTERED_TARGET(self, target)

	local handle = GetHandle(target);
	local propName = "_ADDED_" .. handle;
	if GetExProp(self, propName) == 1 then
		return 0;
	end
	
	SetExProp(self, propName, 1);
	return 1;
	
end

function GET_SHAPE_KDPOWER(self, kdPower)

	local kbResist = GetKBResist(self);
	if kbResist >= kdPower then
		return 0;
	end
	
	local kbRate = GetKBRate(self);
	return (kdPower - kbResist) * kbRate;
end

function SET_BUFF_TIME(caster, obj, buffName, buffTime)
	if "YES" == IsBuffApplied(obj, buffName) then
		SetBuffRemainTime(obj, buffName, buffTime);
	else
		AddBuff(caster, obj, buffName, 1, 0, buffTime);
	end			
end

function MOVE_TO(self, target, speed, accel)

	local x, y, z = GetPos(target);
	Move3D(self, x, y, z, speed, accel);
	
end

-- �������� ���̺�
function SCR_HIT_REFRIGERWAVE(self, from, skill, splash, ret)

	local damage = 1;
	local atk = SCR_LIB_ATKCALC_RH(from, skill);
	damage, ret  = FINAL_DAMAGECALC(self, from, skill, atk, ret, 0);
	
	local dist = GetDistance(self, from);
	ret.AniTime = dist * 5;
		local angle = GetSkillDirByAngle(from);	
		KnockBack(self, from, 70, angle, 15, 1);
	
	local buffFreq = 50;
	
	if IMCRandom(1, 100) <= buffFreq then
		AddSkillBuff(from, self, ret, "Freeze", 1, 0, 5000, 1);
	end
end

--�ĺ�
function SCR_ARC_PAVISE(self, skill, target)

	local angle = GetDirectionByAngle(self);
	local x, y, z = GetSkillTargetPos(self);
	local lifeTime = 8 + skill.Level * 2
	
	local paviseCount = GetExProp(self, "PAVISE_COUNT");
	if paviseCount == nil then
	  paviseCount = 0;
	end
	
  paviseCount = paviseCount +1;
  if paviseCount <=	skill.Level then
  
  	local mon1 = CREATE_SUMMON(self, "pavise", x, y, z, angle, self.Lv, "PAVISE_MON");
    if mon1 == nil then
    	return;
    end
    
  	InvalidateStates(mon1);
  	AddHP(mon1, mon1.MHP);
  	SetLifeTime(mon1, lifeTime);
    SetExProp(self, "PAVISE_COUNT", paviseCount);
	end
	
	return 1;
end

function SCR_PAVISE_MON_TS_BORN_LEAVE(self)
  local owner = GetOwner(self);
  local count = GetExProp(owner, "PAVISE_COUNT");
  SetExProp(owner, "PAVISE_COUNT", count - 1);
  
end

function ICEWALL_BUFFEFFECT(self, mon1, coldLevel)
	
	local randVal = 20 + 10 * coldLevel;
	local objList, objCount = SelectObjectNear(self, mon1, 45, "ENEMY");
	for i = 1, objCount do
		local obj = objList[i];
		if IMCRandom(1, 100) <= randVal then
			AddBuff(self, obj, "Freeze", 1, 0, 5000, 1);
		end
	end
			
end

function SCR_MON_ICEWALL_TS_BORN_ENTER(self)
end

function SCR_MON_ICEWALL_TS_BORN_UPDATE(self)

	local val = 0.055 - 0.005 * self.Level;
	hpReduce = math.max(0.03, val);

	if 1 == FOR_EACH_TIME(self, "DAMTIME", 1) then		
		local damHP = self.MHP * hpReduce;
		if damHP >= self.HP then
			Dead(self);
		else
			AddHP(self, -damHP);
		end

	end	
end

function SCR_MON_ICEWALL_TS_BORN_END(self)
end
function SCR_MON_ICEWALL_TS_DEAD_ENTER(self)
end
function SCR_MON_ICEWALL_TS_DEAD_UPDATE(self)
end
function SCR_MON_ICEWALL_TS_DEAD_END(self)
end



-- ice shattering
function SCR_PREHIT_ICESHATTERING(self, skill, target)

	if IsBuffApplied(target, "Freeze") == "NO" then
		return 0;
	end
	
	return 1;

end

-- �ڷ�Ű�׽ý� �鿪
function SCR_PREHIT_TELEK(self, skill, target)
    if IsBuffApplied(target, 'Event_Transform_GM') == 'YES' then
        return 0;
    end
    
	if target.MonRank == "Boss" or target.MonRank == "NPC" then
		return 0;
	end

	local targetBuff = GetBuffByName(target, "TeleHold");
	if targetBuff ~= nil then
		SendSysMsg(self, "AlreadyOtherPCHoldingTarget");
		return 0;
	end

	return 1;

end

-- �Ž�Ʈ �鿪
function SCR_PREHIT_GUST(self, skill, target)
	if target.MonRank == "Boss" or target.MonRank == "NPC" then
		return 0;
	end
	
	return 1;

end

-- ������ �鿪
function SCR_PREHIT_FREEZE(self, skill, target)
	if target.MonRank == "Boss" or target.MonRank == "NPC" then
		return 0;
	end
	
	return 1;

end


-- ��ȹ �鿪
function SCR_PREHIT_PULL(self, skill, target)
	if target.MonRank == "Boss" or target.MonRank == "NPC" then
		return 0;
	end
	
	return 1;

end
-- ����������
function SCR_PREHIT_CHAINTHROW(self, skill, target)
	if target.MonRank == "Boss" or target.MonRank == "NPC" then
		return 0;
	end
	
	return 1;

end

-- ��ü��ų2
function SKILL_WIZ_HEALZONE2(self, skill, target)

	local time = 30
	local checkRange = 500000;
	
	local x, y, z = GetPos(self);
	local mon1 = CREATE_NPC(self, "HiddenTrigger5", x, y, z, 0, GetCurrentFaction(self), GetLayer(self), nil, nil, "WIZ_FLAMEGROUND2", checkRange, self.Lv, "WIZ_FLAMEGROUND2");
	if mon1 == nil then
		return;
	end
	
	SetLifeTime(mon1, time);
	SetOwner(mon1, self, 1);
	BroadcastRelation(mon1);
	
	AttachEffect(mon1, 'F_level_up_white', 10, 1, "BOT", 1);
		
	AttachEffect(mon1, 'F_levitation024_yellow', 3, 1, "BOT", 10);
	AttachEffect(mon1, 'F_circle_loop_white', 70, 1, "BOT", 1);
	
	
		
	return 1;	
end

function SCR_WIZ_FLAMEGROUND2_ENTER(self, target)

  local txt = GetName(GetOwner(self)) .. ' ' .. ScpArgMsg('Auto_yuJeoKa_SayongHan_aiTemui_yeongHyangeul_Bata_MonSeuTeoKa_MuLyeogHaeJipNiDa.');
    SendAddOnMsg(target, "NOTICE_Dm_Clear", txt, 30);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
	if GetRelation(self, target) ~= "ENEMY" then
		return;
	end
	
	AddBuff(self, target, 'Stun_1', 1, 0, 0, 1);

end

function SCR_WIZ_FLAMEGROUND2_LEAVE(self, target)

	if GetRelation(self, target) ~= "ENEMY" then
		return;
	end
	
	RemoveBuff(target, 'Stun_1');
end



-- marble ����, ��-ȭ�̾
function SCR_WIZ_MARBLE(self, skill)

	local checkRange = 10;
	local i=1;

	-- ��ų 3�������� marble ��������
	if skill.Level <= 3 then
		
		for i=1, skill.Level do	
			local x, y, z;
				-- marble ������ �ڸ� ����
			if i == 1 then
				x, y, z = GetFrontPos(self, 30);
			else
				x, y, z = GetFrontRandomPos(self, 30, 30);
			end

			-- ȭ�̾ ���� ����
			local mon1 = CREATE_NPC(self, "SkillDummy", x, y, z, 0, "Monster", GetLayer(self), nil, nil, "MARBLE_ZONE", 15, 1, nil, "WIZ_MARBLE");
			if mon1 == nil then
				return;
			end	

			AttachEffect(mon1, "F_skl_HoveringFire", 6);
			SetLifeTime(mon1, 10);
			BroadcastRelation(mon1);

			-- ���� ��ų�� ���� ���� ����
			SetExArgObject(mon1, "MARBLE_OWNER", self);		-- ���̶� ĳ���͸� ���� ����ؾ���
			SetExProp(mon1, "MARBLE_LEVEL", skill.Level);	-- ��ų��
			SetExProp(self, "MARBLE_USED", 0);
			mon1.HP = 9999;
		end

	-- ��ų 4�����ʹ� ū marble�� ����
	elseif skill.Level >= 4 then
		local x, y, z;		
		x, y, z = GetFrontPos(self, 30);
		
	-- ȭ�̾ ���� ����
		local mon1 = CREATE_NPC(self, "SkillDummy", x, y, z, 0, "Monster", GetLayer(self), nil, nil, "MARBLE_ZONE", 30, 1, nil, "WIZ_MARBLE");
		if mon1 == nil then
			return;
		end	

		-- ����Ʈ. ������ ����
		AttachEffect(mon1, "F_skl_HoveringFire", 10);
		SetLifeTime(mon1, 10);
		BroadcastRelation(mon1);

		-- ���� ��ų�� ���� ��	�� ����
		SetExArgObject(mon1, "MARBLE_OWNER", self);		-- ���̶� ĳ���͸� ���� ����ؾ���
		SetExProp(mon1, "MARBLE_LEVEL", skill.Level);	-- ��ų��
		SetExProp(self, "MARBLE_USED", 0);
		mon1.HP = 9999;
	end
	return 1;	

end

-- ���� ��ü MON
function SCR_MARBLE_ZONE_ENTER(self, target)	
	if IS_PC(target) or target.ClassName == 'SkillDummy' then
		return;
	end
	local used = GetExProp(self, "MARBLE_USED");
	if used == 1 then
		return;
	end

	local owner = GetExArgObject(self, "MARBLE_OWNER");
	local level = GetExProp(self, "MARBLE_LEVEL")
	
	-- 3������ ���� �ĺ� ���� : �������ְ� �Ҹ�
	if level > 0 and level <= 3 then
		local damage = 10;	-- �׽�Ʈ�� 10������
		TakeDamage(owner, target, "None", damage, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);
		SetExProp(self, "MARBLE_USED", 1);
		-- ����Ʈ

	elseif level > 3 then
	-- 4���̻� ū �ĺ� ���� : ������ְ� �Ҹ���ϰ� ����	-- ���� �ٸ��ŷ� �ٲټ���~
		AddBuff(owner, target, 'Weaken', 1, 0, 5000, 1);
		-- ����Ʈ
	
	end	
end

function SCR_WIZ_MARBLE_TS_BORN_ENTER(self)
end
function SCR_WIZ_MARBLE_TS_BORN_UPDATE(self)
	
	-- ���ݴ��� 1�̶��������� ��ų�ߵ�.
	local used = GetExProp(self, "MARBLE_USED");
	if self.HP < 9999 and used == 0 then
		SetExProp(self, "MARBLE_USED", 1);

		-- �ĺ� �������� owner�� ����
		local caster = GetLastAttacker(self);
		SetExArgObject(self, "MARBLE_OWNER", caster);
		PlayMarbleSkill(self, caster);
	end
	
	if used == 1 then
	  local targetObj = GetExArgObject(self, "TARGET");
	  if targetObj ~= nil then
      local dist = GetDistance(targetObj, self);
      if dist < 10 then
     		local caster = GetLastAttacker(self);
   			local angle = GetAngleTo(caster, targetObj);
  			KnockBack(targetObj, caster, 80, angle, 30, 4);
 			  PlayEffect(self, "explosion_burst");
  			Dead(self);
      end
    end
	end
	return 1;
end
function SCR_WIZ_MARBLE_TS_BORN_LEAVE(self)
end
function SCR_WIZ_MARBLE_TS_DEAD_ENTER(self)
end
function SCR_WIZ_MARBLE_TS_DEAD_UPDATE(self)
end
function SCR_WIZ_MARBLE_TS_DEAD_LEAVE(self)
end

-- marble ��ų �ߵ� �κ�
function PlayMarbleSkill(marble, owner)

	local x, y, z = GetFrontPos(owner, 250);
	SetDirectionToPos(marble, x, z);
	local sx, sy, sz = GetPos(marble);
	local ex, ey, ez = GetFrontPos(marble, 150);
	
	local width = 15;
	local objList, objCount = SelectObjectBySquareCoor(owner, "ENEMY", sx, sy, sz, ex, ey, ez, width, 50);

		-- ���� �տ��ִ¸� ã��
	local minDist = 99999;
	local nearTarget = objList[1];
	local cnt = 0;
	local i = 0;
	for i = 1, objCount do
		if objList[i].ClassName ~= 'SkillDummy' then
			local dist = GetDistance(marble, objList[i]);
			if minDist > dist then
				minDist = dist;
				nearTarget = objList[i];
			end
			cnt = cnt + 1;
		end
	end
	
	-- �տ� �������� �׳� ������
	if cnt == 0 then
		SetExProp(marble, "MARBLE_USED", 1);
		local angle = GetAngleTo(owner, marble);
		KnockBack(marble, caster, 320, angle, 10, 1);
		SetLifeTime(marble, 0.25);
	else
			-- ������ ������ �����ϼ���
		local level = GetExProp(marble, "MARBLE_LEVEL");
		local damage = 10;	-- �׽�Ʈ�� ������ 10


		if nearTarget ~= nil then		
			TakeDamage(owner, nearTarget, "None", damage, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);			
			MoveToTarget(marble, nearTarget, 1);
      SetExArgObject(marble, "TARGET", nearTarget);
		end
	end
	

	--[[
	-- ??��??
	local ex, ey, ez;
	for i=1, 10 do
		ex, ey, ez = GetFrontPos(marble, i*10);
		PlayEffectToGround(marble, "F_bg_fire_q", ex, ey, ez, 1, 1);
	end
	]]
end


-- blackhole ���Ȧ
function SCR_WIZ_BLACKHOLE(self, skill)
	
	local x, y, z = GetPos(self);
	local mon1 = CREATE_NPC(self, "statue_raima_mon", x, y+15, z, 0, "Monster", GetLayer(self), nil, nil, "MON_BLACKHOLE", 50, 1, nil, "MON_BLACKHOLE");
	if mon1 ~= nil then
		x, y, z = GetPos(mon1);
		SetPos(mon1, x, y, z);
	end
	local mon2 = CREATE_NPC(self, "HiddenTrigger5", x, y, z, 0, "Summon", GetLayer(self), nil, nil, nil, 60, 1, nil, "WIZ_BLACKHOLE");
	if mon1 == nil or mon2 == nil then
		return 1;
	end

	SetLifeTime(mon1, 15);
	SetLifeTime(mon2, 5);
	SetOwner(mon2, self, 0);
	
	-- ���³�� ������� ���
	SetExProp(mon1, "EnterCount", 0);
	-- ���Ȧ ������ ���
	SetExArgObject(mon1, "BLACKHOLE_OWNER" , self);

	-- ���Ȧ �ð� ����
	SetExProp(mon1, "ATTACK_TIME", imcTime.GetAppTime()+5);
	SetExProp(mon1, "END_TIME", imcTime.GetAppTime()+5);
	SetExProp(mon2, "UPDATE_TIME", imcTime.GetAppTime());

	-- ���Ȧ �ʱⰪ
	mon1.HP = 9999;
	--���Ȧ ��ü ����Ʈ
	AttachEffect(mon1, "F_COMMON_SKILL_HEAL", 6);

	return 1;
end

function SCR_WIZ_BLACKHOLE_TS_BORN_ENTER(self)
end
function SCR_WIZ_BLACKHOLE_TS_BORN_UPDATE(self)

	local curtime = imcTime.GetAppTime();
	local oldtime = GetExProp(self, "UPDATE_TIME");
		-- 0.5���� ���Ȧ �߽����� �������
	if oldtime + 0.5 < curtime then
		SetExProp(self, "UPDATE_TIME", curtime);
		
		local objList, objCount = SelectObjectNear(GetOwner(self), self, 300, "ENEMY");
		for i = 1, objCount do
			local obj = objList[i];
			-- ���Ȧ���� �ƴ� ���鸸 ������.(�ٸ� ���Ȧ ���ܿ��ų� �ڽ��� �˹��ϴ°� ����)
			if obj.ClassName ~= 'statue_raima_mon' then
				local angle = GetAngleTo(obj, self);
				KnockBack(obj, self, 100, angle, 25, 1);
			end
		end
	end
	return 1;
end
function SCR_WIZ_BLACKHOLE_TS_BORN_LEAVE(self)
end
function SCR_WIZ_BLACKHOLE_TS_DEAD_ENTER(self)
end
function SCR_WIZ_BLACKHOLE_TS_DEAD_UPDATE(self)
end
function SCR_WIZ_BLACKHOLE_TS_DEAD_LEAVE(self)
end

-- ���Ȧ ��ü MON
function SCR_MON_BLACKHOLE_ENTER(self, target)	

	if IS_PC(target) or imcTime.GetAppTime() > GetExProp(self, "ATTACK_TIME") then
		return;
	end
	-- ���³� ī��Ʈ ����
	local cnt = GetExProp(self, "EnterCount");
	cnt = cnt + 1;
	SetExProp(self, "EnterCount", cnt);
	-- ���³� ������Ʈ ���
	SetExArgObject(self, "BLACKHOLE_"..cnt , target);	
	-- ����� �ٶ��� ���� ����صα�
	local angle = GetAngleTo(self, target);
	SetExProp(target, "BLACKHOLE_ANGLE", angle);

	-- ���Ȧ ���� ����Ʈ
	PlayEffect(target, "I_ground002", 1);
end

function SCR_MON_BLACKHOLE_TS_BORN_ENTER(self)
end
function SCR_MON_BLACKHOLE_TS_BORN_UPDATE(self)
	-- �ȵ�θ޴ٿ� ���� ����
	local x, y, z = GetPos(self);
	local cnt = GetExProp(self, "EnterCount");
	local i;
	for i=1, cnt do
		local obj = GetExArgObject(self, "BLACKHOLE_"..i);
		SetPos(obj, x, y+1500, z);
	end

	if imcTime.GetAppTime() > GetExProp(self, "END_TIME") then
		-- 1���� �����ϱ����� Ÿ�� ���� ����
		SetExProp(self, "END_TIME", imcTime.GetAppTime()+99);
		-- ���ݱ��� ���� �� ����ŭ HP ����
		self.HP = cnt;
	end

	return 1;
end
function SCR_MON_BLACKHOLE_TS_BORN_LEAVE(self)
	local ox, oy, oz = GetPos(self);
	if self.HP > 0 then
		-- ���� ������Ų������ �˹�. ������������ ���� ����
		local x, y, z = GetRandomPos(self, ox, oy, oz, 30);
		local cnt = GetExProp(self, "EnterCount");
		local i;
		for i=1, cnt do
			local obj = GetExArgObject(self, "BLACKHOLE_"..i);
			SetPos(obj, x, y, z);
			local angle = GetExProp(obj, "BLACKHOLE_ANGLE");
			KnockBack(obj, self, 200, angle, 45, 1);
		end
	
	else
		-- ���� ������Ų������ ���̱�.
		local owner = GetExArgObject(self, "BLACKHOLE_OWNER");
		local cnt = GetExProp(self, "EnterCount");

		local i;
		for i=1, cnt do
			local obj = GetExArgObject(self, "BLACKHOLE_"..i);
			local x, y, z = GetRandomPos(self, ox, oy, oz, 30);
			SetPos(obj, x, y, z);
			TakeDamage(owner, nearTarget, "None", 9999999);			
		end

		-- ų ����Ʈ
		PlayEffect(self, "F_pc_warp_light", 1);
	end
end
function SCR_MON_BLACKHOLE_TS_DEAD_ENTER(self)
end
function SCR_MON_BLACKHOLE_TS_DEAD_UPDATE(self)
end
function SCR_MON_BLACKHOLE_TS_DEAD_LEAVE(self)
end

function SKILL_TOY(self, skill)
	
	local x, y, z = GetFrontPos(self, 30);
	local mon1 = CREATE_NPC(self, "HiddenTrigger3", x, y, z, 0, "Summon", GetLayer(self), nil, nil, nil, 50, 1, nil, "TOY_ZONE");
	if mon1 == nil then
		return 1;
	end

	SetLifeTime(mon1, 10);
	SetExProp(mon1, "TIME", imcTime.GetAppTime());
end

function SCR_TOY_ZONE_TS_BORN_ENTER(self)
	local objList, objCount = SelectObject(self, 50, 'ALL');
	for i=2, objCount do
		Chat(objList[i], ScpArgMsg("Auto_ChamKa"));
	end
end
function SCR_TOY_ZONE_TS_BORN_UPDATE(self)
	
	local curTime = imcTime.GetAppTime();
	local oldTime = GetExProp(self, "TIME");

	if oldTime +8 < curTime then
		Chat(self, ScpArgMsg("Auto_...NaLeul_TtaLawa!!?!?"))
	elseif oldTime +6 < curTime then
		Chat(self, ScpArgMsg("Auto_JongMogeun_NaLang_KaKkaunNom!"))
	elseif oldTime +4 < curTime then
		Chat(self, ScpArgMsg("Auto_NuKaNuKaiKilKka~"))
	elseif oldTime +2 < curTime then
		Chat(self, ScpArgMsg("Auto_NaeKaJohaHaNeun_LaenDeomKeim+_+"))
	end
	return 1;
end
function SCR_TOY_ZONE_TS_BORN_LEAVE(self)
	local objList, objCount = SelectObject(self, 50, 'ALL');
	local winer = objList[1];
	local minDist = GetDistance(self, winer);
	
	for i=2, objCount do
		local dist = GetDistance(self, objList[i]);
		if minDist >= dist then
			winer = objList[i];
		end
	end

	for i=1, objCount do
		if objList[i] ~= winer then
			local angle = GetAngleTo(winer, objList[i]);
			local x, y, z = GetPos(objList[i]);
			SetPos(objList[i], x, y+30, z);
			KnockBack(objList[i], winer, 200, angle, 60, 1);
			Chat(objList[i], ScpArgMsg("Auto_aag~~"));
		end
	end
	Chat(winer, ScpArgMsg("Auto_NaiSseu!_KkeutNasseo"));
	PlayEffect(winer, 'F_ground095_circle');

end
function SCR_TOY_ZONE_TS_DEAD_ENTER(self)
end
function SCR_TOY_ZONE_TS_DEAD_UPDATE(self)
end
function SCR_TOY_ZONE_TS_DEAD_LEAVE(self)
end

-- ��Ũ : ������ ������� �߾����� �����
function SCR_WIZ_VACUUM(self, skill)
	
	local x, y, z = GetSkillTargetPos(self);
	--local x, y, z = GetFrontPos(self, 50)
	local mon1 = CREATE_NPC(self, "HiddenTrigger5", x, y, z, 0, GetCurrentFaction(self), GetLayer(self), nil, nil, "WIZ_VACUUM", 50, self.Lv);
	if mon1 == nil then
		return;
	end
	
	SetLifeTime(mon1, 2);
	SetOwner(mon1, self, 1);
	BroadcastRelation(mon1);
	AttachEffect(mon1, "F_wiz_skl_safetyzone", 7 * checkRange / 25);
end

function SCR_WIZ_VACUUM_ENTER(self, target)
	
	if GetRelation(self, target) == "ENEMY" then
		local power = GetDistance(self, target);
		local angle = GetAngleTo(target, self);
		KnockBack(target, self, power*2.6, angle, 25, 1);
		Chat(target, "pwer "..power)
	end
end

-- �̿� �� : Ÿ���� �������� �ѷ���. Ÿ�������� Ÿ���ֺ��� �ʴ� ������
function SCR_WIZ_ION_SHELL(self, from, skill, splash, ret)
	
	-- SR������ ���������� ����� ù��°�� �����ϰ� �����ϵ�����.
	local castTime = GetExProp(from, "ION_SHELL_TIME");
	if castTime ~= nil then		
		if castTime + 1 > imcTime.GetAppTime() then
			return;
		end
	end
	SetExProp(from, "ION_SHELL_TIME", imcTime.GetAppTime());
	
	local damage = 22;				-- �׽�Ʈ�� ������
	SetExProp(self, "IonDamage", damage);
	AddSkillBuff(from, self, ret, 'Ion', skill.Level, 0, 8000, 1);
	--AttachEffect(self, "F_circle014_dark", 8, 'MIDDLE');	 -- ����Ʈ ���߿�

	ret.Damage = 0;
	ret.HitType = HIT_NOHIT;
end

-- ����Ż ���� : �������� ���� �Ѹ��� ������ ���γ� �ۼ�Ʈ�� ������
function SCR_FATAL_BOND(self, from, skill, splash, ret)
	
	-- SR������ ���������� ����� ù��°�� �����ϰ� �����ϵ�����.
	local castTime = GetExProp(from, "FATAL_TIME");
	if castTime ~= nil then		
		if castTime + 1 > imcTime.GetAppTime() then
			return;
		end
	end
	SetExProp(from, "FATAL_TIME", imcTime.GetAppTime());

	-- ����������Ʈ ���� �����ϰ� �ٽ� �����ϰ���

end

function SCR_recallpc(self)

    RecallPC(self);
    
end


function SCR_BUFF_MARIO(self)

  AttachEffect(self, 'F_levitation024_yellow', 1, 1, "BOT", 5);
	AddBuff(self, self, 'mario', 1, 0, 30000, 1);

end

-- Freeze ������
function SKILL_WIZ_FREEZE(self)

	local x, y, z = GetSkillTargetPos(self);
	--local x, y, z = GetFrontPos(self, 30);
	local checkRange = 30;
	
	local mon1 = CREATE_NPC(self, "HiddenTrigger5", x, y, z, 0, GetCurrentFaction(self), GetLayer(self), nil, nil, "FREEZE_ZONE", checkRange, self.Lv, "FREEZE_ZONE");
	if mon1 == nil then
		return;
	end	
	
	local buffCount = 5;		-- ���ο������ ī��Ʈ
	SetExProp(mon1, "BUFFCOUNT", buffCount);
	local lifeTime = 2;
	SetLifeTime(mon1, lifeTime);	
	SetOwner(mon1, self, 1);	
	BroadcastRelation(mon1);
	
	AttachEffect(mon1, "F_war_skl_slow", 5 * checkRange / 30);
	return 1;
end

function SCR_FREEZE_ZONE_ENTER(self, target)

	if GetRelation(self, target) ~= "ENEMY" then
		return;
	end
	
	local buffCount = GetExProp(self, "BUFFCOUNT");
	local Freezerating = IMCRandom(1, 10)
	if buffCount > 0 and Freezerating > 5 then
		AddBuff(GetOwner(self), target, 'Freeze', 1, 0, 5000, 0);
		buffCount = buffCount-1;
		SetExProp(self, "BUFFCOUNT", buffCount);
	end	
end

function SCR_FREEZE_ZONE_LEAVE(self, target)

end

-- Shout ��ȿ
function SKILL_WAR_Shout(self)
	local targetList, cnt = SelectObject(self, 30, 'ALL', 0)
	
	for i = 1, cnt do
	    if GetCurrentFaction(targetList[i]) == 'Monster' then
    	    AddBuff(self, targetList[i], 'Stun', 1, 0, 6000, 0);
    	end
	end

	return 1;
end

function SCR_RULERBUFF_CASTING(self, skl)

	
	local objList, cnt = SelectObject(self, 100, "ALL", 1);
	cnt = math.min(cnt, skl.Level);

	local index = 1;
	for i=1, cnt do
		local target = objList[i];
		if target ~= nil then

			if GetRelation(target, self) ~= "ENEMY" then
				AddBuff(self, target, 'TimeRuler', 0, 0, 5000, 1);
				SetExArgObject(self, 'RULERBUFF_TARGET'..index, target);
				index = index + 1;
			end
		end
	end

	SetExProp(self, 'RULERBUFF_TARGET_COUNT', index);
	
end

function SCR_RULERBUFF_END(self)
	
	local cnt = GetExProp(self, 'RULERBUFF_TARGET_COUNT')
	
	for i=1, cnt do
		local target = GetExArgObject(self, 'RULERBUFF_TARGET'..i)
		if target ~= nil then
			RemoveBuff(target, 'TimeRuler');
		end
	end	
end

function SCR_DIBSKILL_ZONEMOVE_DIALOG(statue, pc)
	
	SetExProp(pc, "VAKARINE_WARP", 1);
	SetExArgObject(pc, "VAKARINE_WARP_OBJ", statue);
	local isFirstWarp = GetExProp(statue, "IS_FIRST_WARP");
	if isFirstWarp == 0 then
		SetExProp(statue, "IS_FIRST_WARP", 1);
	end
	
	local remainCount = GetExProp(statue, "REMAIN_WARP_COUNT");
	if remainCount > 0 then
		--local iswarped = SCR_CAMP_WARP_BY_SKILL(pc);
		
		-- ??���� ??��??��????ī��??ó��????��?? ??��????�� UI ??��??��??ī��??����(????��� ??��)
		--local remainCount = remainCount - 1;
		--SetExProp(statue, "REMAIN_WARP_COUNT", remainCount);
	    
			-- ���������� ��������� ui�� ����ϴ°ɷ� ���ߵȴٸ� �Ʒ��ּ�Ǯ�� ������ �ּ�ó���ϸ��

		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"worldmap")

		SetExProp(pc, "WarpFree", 1);

		ExecClientScp(pc, "INTE_WARP_OPEN_DIB()");
	end

	
	
end

--�ϵ��� �ϵ��ڵ�
function BD_LIST_UPDATE(self, objList)

	local nowmaxatk = 0;
	local nowminatk = 0;
	local nowdef = 0;
	
	for i = 1 , #objList do
		nowmaxatk = math.max(nowmaxatk, objList[i].MAXATK);	
		nowminatk = math.max(nowminatk, objList[i].MINATK);
		nowdef = math.max(nowdef, objList[i].DEF);
	end
	
	SetExProp(self, "MAX_ATK", nowmaxatk);
	SetExProp(self, "MIN_ATK", nowminatk);
	SetExProp(self, "MAX_DEF", nowdef);
	
end

function BD_ENTER_TGT_ADD_TO_PARENTSKILL(self, skl, pad, target, tgtRelation, consumeLife, actorCount, buffName, lv, arg2, buffTime, over, preBuffFunc)

	if GetBuffByName(target, buffName) ~= nil then
		return;
	end

	local padList = GetSameSkillPadList(self, pad);
	if #padList < actorCount then
		return;
	end

	local objList = {};
	for j = 1 , #padList do
		local samepad = padList[j];
		local padFirstObj = GetPadFirstObj(samepad);
		if padFirstObj == nil and samepad == pad then
			 padFirstObj = target;
		end
					
		if padFirstObj ~= nil then
			objList[#objList + 1] = padFirstObj;
		end
	end

	if #objList < actorCount then
		return;
	end

	if preBuffFunc ~= "None" then
		local _func = _G[preBuffFunc];
		_func(self, objList);
	end

	for i = 1 , #objList do
		local obj = objList[i];
		AddBuff(self, obj, buffName, lv, arg2, buffTime, over);
	end
end


function BD_LEAVE_PAD_TGT_REMOVE_AT_PARENTSKILL(self, skl, pad, target, tgtRelation, consumeLife, actorCount, buffName, lv, arg2, buffTime, over, preBuffFunc)

	if GetBuffByName(target, buffName) == nil then
		return;
	end

	local padList = GetSameSkillPadList(self, pad);
	if #padList < actorCount then
		return;
	end

	local objList = {};
	for j = 1 , #padList do
		local pad = padList[j];
		local padFirstObj = GetPadFirstObj(pad);
		if padFirstObj ~= nil then
			objList[#objList + 1] = padFirstObj;
		end
	end

	local removeAll = false;
	if #objList < actorCount then
		removeAll = true;
	end
	
	RemoveBuff(target, buffName);
	if removeAll == true then
		for i = 1 , #objList do
			RemoveBuff(objList[i], buffName);
		end
	else

		if preBuffFunc ~= "None" then
		local _func = _G[preBuffFunc];
			_func(self, objList);	
		end

		for i = 1 , #objList do
			AddBuff(self, objList[i], buffName, lv, arg2, buffTime, over);
		end
	end

end

function S_AI_TETMAMAKLA(self, arg1)

	local objList, objCount = SelectObject(self, 10, 'ALL');
	
	for i = 1, objCount do
	    local obj = objList[i];
		if obj.ClassName == "summons_zombie" or obj.ClassName == "Zombie_hoplite" or obj.ClassName == "Zombie_Overwatcherthen" then
	        Dead(self)
		end
	end
end

function SCR_SYNC_RESIZE(self, scale)
	sleep(500)

	if IS_PC(self) then
		return;
	end
	
	AddHP(self, GetExProp(self, "ADD_HP"));
	if GetExProp(self, "Kill") == 1 then
		ChangeScale(self, scale, 0.2)
		Dead(self)
		PlayEffect(self, 'F_buff_explosion_burst');
	else
		ChangeScale(self, scale, 0.2)
	
	end

end

function SCR_SUMMON_ICEWALL(mon, self, skl)

    mon.Lv = self.Lv
    mon.HPCount = 2 + skl.Level * 2;
	mon.Faction = 'IceWall'
	mon.StatType = 1
end


function SCR_SUMMON_JINCANGU(self, caster, x, y, z)

	local MonList, cnt = GetClassList("Monster");

	local makeCount = GetExProp(self, 'JINCAN_COUNT');
	if makeCount > 5 then
		makeCount = 5;
	end

	for i = 1, makeCount do

		local iesObj = CreateGCIES('Monster', 'JincanGu_Worm');
		
		if iesObj ~= nil then
			local x, y, z = GetExProp_Pos(self, "JINCANGU")
			x, y, z = GetRandomPos(self, x, y, z, 30)	
			local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);

			SetBroadcastOwner(mon); -- broadcast owner for excepting targeting
			SetOwner(mon, caster, 1)
			SetHookMsgOwner(mon, caster)
			iesObj.Faction = 'Summon';

			mon.Lv = caster.Lv;
			mon.StatType = 1;
			InvalidateStates(mon);
			AddHP(mon, mon.MHP);

			RunSimpleAI(mon, 'Archer_JincanGu');
			AddBuff(caster, mon, 'JincanGu_Mon_Debuff', 0, 0, 20000, 1);
			PlayEffect(self, "F_archer_jincangu_ground", 0.6, 0, 0)
		end
	end
end


function SCR_PRECHECK_SHOVEL(self, skill, target)

	if IsVillage(self) == "YES" then
		return 0;
	end
	
	return 1;

end

function SCR_SELECT_LIMIT_PAD(self, x, y, z, relation, range, cnt)
	local list = SelectPad(self, 'ALL', x, y, z, range);
	if #list == 0 then
		return list;
	end

	local selectPadList = {};
	local selectPadCnt = 0;
	for i = 1 , #list do
		local pad = list[i];
		local padOwner = GetPadOwner(pad);
		if padOwner~= nil and GetRelation(self, padOwner) == relation then
			selectPadCnt = selectPadCnt + 1;
			if selectPadCnt <= cnt then
				selectPadList[selectPadCnt] = pad;
			else
				break;
			end
		end
	end

	return selectPadList;
end

function SCR_PAD_DESTORY(self, skl, x, y, z, relation, range, cnt, eftName, destroyTime, groundEft, groundScl)
	local padList = SCR_SELECT_LIMIT_PAD(self, x, y, z, relation, range, cnt);
	if #padList == 0 then
		return;
	end

	for i = 1, #padList do
		local pad = padList[i];
		DestoryPadAfterTime(pad, eftName, destroyTime, groundEft, groundScl);
	end
end

function SCR_PAD_RANGE_CHANGE(self, skl, x, y, z, relation, range, cnt, changeRange, soundName)
	local sx, sy, sz = Get3DPos(self);
	local padList = SCR_SELECT_LIMIT_PAD(self, sx, sy, sz, relation, range, cnt);
	if #padList == 0 then
		return;
	end
	
	for i = 1, #padList do
		local pad = padList[i];
		ChangePadRange(pad, changeRange);
	end
	
	PlaySound(self, soundName);
end

function PAD_SEARCH_AND_CHANGE(self, skl, padName, changePad, x, y, z, padCount, range, padStyle)

	local list = SelectPad(self, 'ALL', x, y, z, range, padStyle);
	if #list == 0 then
		return;
	end

	local count;

	if padCount == 0 then
		count = #list
	else
		count = padCount
	end

	for i = 1 , #list do
		local pad = list[i];

		if GetPadName(pad) == padName then
			local px, py, pz = GetPadPos(pad);
			KillPad(pad);
			
			local skill = nil;
			if changePad == "Chaplain_MagnusExorcismus" then
			    skill = GetSkill(self,"Chaplain_MagnusExorcismus");
			end
			RunPad(self, changePad, skill, px, py, pz, 0, 1);
		end
	
	end
end