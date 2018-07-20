---- hardskill_sapper.lua

function  INIT_SAPPER_TRAP(self, parent, skl)
--    local argName = "SAPPER_TRAP_" .. skl.ClassName;
--    local itmeName = "misc_claymore"

    local argName = "SAPPER_TRAP_" .. skl.ClassName;
    local itmeName = skl.SpendItem;
    
    local item, itemCnt  = GetInvItemByName(parent, itmeName);
    local abil = GetAbility(parent, 'Sapper33')
    local item_need_cnt = skl.SpendItemBaseCount;
    local Sapper33_ratio = 0;
    if abil ~= nil then
        item_need_cnt = item_need_cnt * 2;
        Sapper33_ratio = 2.5;
    end
    
    local fixedItem = IsFixedItem(item)
    if fixedItem == nil then
        fixedItem = 100
    end
    
    if itemCnt < item_need_cnt or 1 == fixedItem then
        SendAddOnMsg(parent, "NOTICE_Dm_!", ScpArgMsg("Auto__aiTemi_PilyoLyange_MoJaLapNiDa."), 3);
		SkillCancel(parent);
        Kill(self)
    else
        RunScript("SAPPER_TRAP_TX", parent, itmeName, item_need_cnt);
        
        SetBroadcastOwner(self);
	    SetOwner(self, parent, 1);
	    RunScript("SAPPER_CHECK_PARENT", self, parent);
	    SetZombieScript(self, "SAPPER_TRAP_UNLOCK");
	    SetExProp_Str(self, "ARGNAME", argName);
	    
	    SetExProp(self, 'ABIL_SAPPER33', Sapper33_ratio)
	    SetExArgObject(parent, argName, self);
	    SendExArgObject(parent, argName, self);
	    ChangeSkillAniName(parent, skl.ClassName, 'SKL_CLAYMORE_SHOT');
	end
end

function SAPPER_TRAP_TX(self, itemName, count)
    local tx = TxBegin(self);
	TxEnableInIntegrateIndun(tx);
    TxTakeItem(tx, itemName, count,"Sapper");
	local ret = TxCommit(tx);
end

function SAPPER_CHECK_PARENT(self, parent)

	while 1 do
		local range = GetDist2D(self, parent);
		if range >= 400 then
			Dead(self);
			break;
		end

		sleep(500);
	end

end

function SAPPER_TRAP_UNLOCK(self)
	local argName = GetExProp_Str(self, "ARGNAME");
	local parent = GetOwner(self);
	if nil == parent then
		return;
	end

	SetExArgObject(parent, argName, nil);
	SendExArgObject(parent, argName, nil);

end

function INIT_SAPPER_JUMPROPE(self)
	
	local owner = GetOwner(self);
	local x, y, z = GetPos(owner);
	RunJumpRope(self, "I_laser005_blue", 1.0, 100, 10, 5, 2, 2, 3, x, y, z);
	
end

function PAD_DESTRUCTION(self, skl, x, y, z, padCount, range, padStyle, eft, eftScale, hitRange, damRate, kdPower, relationBit)

	local list = SelectPad(self, 'ALL', x, y, z, range, padStyle, relationBit);
	if #list == 0 then
		return;
	end

	local loopCnt = math.min(#list, padCount);	
	local padPosX = {};
	local padPosY = {};
	local padPosZ = {};
	for i = 1 , loopCnt do
		local pad = list[i];

		local px, py, pz = GetPadPos(pad);
		padPosX[i] = px;
		padPosY[i] = py;
		padPosZ[i] = pz;
		KillPad(pad);
	end
	
	for i = 1 , loopCnt do
		local px = padPosX[i];
		local py = padPosY[i];
		local pz = padPosZ[i];
		PlayEffectToGround(self, eft, px, py, pz, eftScale, 0.0);  
		OP_DOT_DAMAGE(self, skl.ClassName, px, py, pz, 0, hitRange, 0, 1, "None", 1.0, kdPower);
	end

end

function SAPPERPILLAR_PAD(self, skill, pad, obj)

    local px, py, pz = GetPadPos(pad);
    
    RunPad(self, "sapperPillar_pad", nil, px, py, pz, 0, 1);
    
    KillPad(pad);

end

-- CollarBomb_Debuff
function SCR_BUFF_ENTER_CollarBomb_Debuff(self, buff, arg1, arg2, over)
  SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil); 
	local skillLv = arg1;
	SetExProp(buff, 'COLLARBOMB_COUNT', skillLv);

	local caster = GetBuffCaster(buff);
	local skl = GetSkill(caster, 'Sapper_CollarBomb');
	local simpleAi = 'hoverbomb';

	for i=1, arg1 do
		local x, y, z = GetFrontRandomPos(self, 10, 5);
		local mon = MONSKL_CRE_MON(caster, skl, 'hidden_monster3', x, y, z, 0, '', 'None', 1, 0, simpleAi, nil);
		SetExProp(buff, 'COLLARBOMB_' .. i, GetHandle(mon));
	end
end

function SCR_BUFF_UPDATE_CollarBomb_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

	local count = GetExProp(buff, 'COLLARBOMB_COUNT');
	local zoneInst = GetZoneInstID(self);
	for i=1, count do 
		local monHandle = GetExProp(buff, 'COLLARBOMB_' .. i);
		local mon = GetByHandle(zoneInst, monHandle);
		if mon ~= nil then
			return 1;
		end
	end
	SetExProp(buff, 'COLLARBOMB_COUNT', 0);
	RemoveBuff(self, buff.ClassName);
	return 0;

end

function SCR_BUFF_LEAVE_CollarBomb_Debuff(self, buff, arg1, arg2, over)
	local skillLv = GetExProp(buff, 'COLLARBOMB_COUNT');	
	local zoneInst = GetZoneInstID(self);
	for i=1, skillLv do
		local monHandle = GetExProp(buff, 'COLLARBOMB_' .. i);
		local mon = GetByHandle(zoneInst, monHandle);
		if mon ~= nil then
			Dead(mon);
		end
	end
end

function SHOOT_SPIKE_SHOOTER(self, skill, pad, obj)

	local bx, by, bz = GetCustomSquareCheckerBeginPos(pad);
	local ex, ey, ez = GetCustomSquareCheckerEndPos(pad);
	local angle = DirToAngle(ex - bx, ez - bz);
	local objAngle = GetAngleToPos(obj, bx, bz);
	local sklLevel = GetPadArgNumber(pad, 1);
	
	if angle < 0 then
		angle = angle + 360;
	end
	if objAngle < 0 then
		objAngle = objAngle + 360;
	end
	
	if angle > objAngle then
		angle = angle + 90;
	else
		angle = angle - 90;
	end

	local forceDist = 150;
	local speed  = 500;
	local divideCount = (sklLevel * 2) + 1;

	local ax, az = GetXZFromDistAngle(forceDist, angle);

	local width = 5;
	for i = 1 , divideCount - 1 do
		local blendRate = i / divideCount;
		local sx = imc.GetBlend(bx, ex, blendRate);
		local sy = imc.GetBlend(by, ey, blendRate);
		local sz = imc.GetBlend(bz, ez, blendRate);
		
		local ex = sx + ax;	
		local ez = sz + az;	
		local objList, objCount = SelectObjectBySquareCoor(self, "ENEMY", sx, sy, sz, ex, sy, ez, width, 50);
		local tgt = nil;
		local damage = 0;
		if objCount > 0 then
			tgt = objList[1];
			damage = SCR_LIB_ATKCALC_RH(self, skill);
		end
        
        --Power Abil
--		local abil_35_AtkAdd = 0;
--        if pad ~= nil then
--            local pad_ratio = GetExProp(pad, 'PAD_SAPPER35_RATIO')
--            if pad_ratio ~= nil and pad_ratio ~= 0 then
--                abil_35_AtkAdd = skill.SkillAtkAdd * pad_ratio;
--            end
--        end
--        
	    ShootForceFromGround(self, skill, tgt, damage, "I_arrow009", 1.0, sx, sy, sz, angle, forceDist, speed);
    end

	-- SAPPERPILLAR_PAD

end

function S_AI_HOVER_BOMB(self, destructRange)
    local owner = GetOwner(self)
	local hoverTarget = GetHoverTarget(self);
	local list, cnt = SelectObject(self, destructRange, 'ENEMY')
	for i = 1 , cnt do
		local obj = list[i];
		if IsSameObject(obj, hoverTarget) == 0  then
			local x, y, z = GetPos(self, x, y, z);
			local range = 20;
			local skill = GetSkill(owner, "Sapper_CollarBomb");
			local kdPower = 100;
			local knockType = 1;
			SPLASH_DAMAGE(owner, x, y, z, range, skill.ClassName, kdPower, false, knockType, 0);
			Dead(self, 0.0);			
			HoldMonScp(self);
			return 1;
		end
    end

	return 0;

end



function SCR_PAD_ENTER_BroomTrap(pc, skill, pad)
    if pc ~= nil then
        if pad ~= nil then
            local abil = GetAbility(pc, "Sapper34")
            if abil ~= nil then
                SetExProp(pad, 'PAD_SAPPER34_RATIO', 1.0)
                return;
            end
            SetExProp(pad, 'PAD_SAPPER34_RATIO', 0)
        end
    end
end

function SCR_PAD_ENTER_SpikeShooter(pc, skill, pad)
    if pc ~= nil then
        if pad ~= nil then
            local abil = GetAbility(pc, "Sapper35")
            if abil ~= nil then
                SetExProp(pad, 'PAD_SAPPER35_RATIO', 1.5)
                return;
            end
            SetExProp(pad, 'PAD_SAPPER35_RATIO', 0)
        end
    end
end



function SCR_PAD_TGT_DAMAGE_BroomTrap(self, skill, pad, target)
	local atkRate = 1;
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return false;
	end
	
	if IS_APPLY_RELATION(self, target, 'ENEMY') then
		local MINPATK = self.MINPATK
		local MAXPATK = self.MAXPATK
		local damage = IMCRandom(MINPATK, MAXPATK);

--		local damage = SCR_LIB_ATKCALC_RH(self, skill);
		local divineAtkAdd = skill.SkillAtkAdd;
		local addValue = 0;

		local concurrentCount = GetConcurrentPadUseCount(pad);
		if concurrentCount > 0 then
			local curCount = GetPadUserValue(pad, "TgtDamageCount" .. GetPadID(pad));
			if curCount >= concurrentCount then
				return false;
			end
			SetPadUserValue(pad, "TgtDamageCount" .. GetPadID(pad), curCount+1);
		end
		
		if GetPadArgNumber(pad, 1) ~= nil then
		    addValue = GetPadArgNumber(pad, 1);
		end
		divineAtkAdd = addValue - divineAtkAdd;
		
		if divineAtkAdd < 0 then
		    divineAtkAdd = 0;
		end
		
		local abilSapper37 = GetAbility(self, "Sapper37")
		if abilSapper37 ~= nil and abilSapper37.ActiveState == 1 then
			MINPATK = self.MINPATK_SUB
			MAXPATK = self.MAXPATK_SUB
			damage = IMCRandom(MINPATK, MAXPATK);
		end
		
		TakeDamage(self, target, skill.ClassName, damage);

		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);

		return true;
	end

	return false;
end



function SCR_SKL_TGT_DMG_Claymore(self, skill)
    --Power Abil
--    local abil_33_AtkAdd = 0;
    local claymore = GetExArgObject(self, "SAPPER_TRAP_" .. skill.ClassName)
--    if claymore ~= nil then
--        local abil_ratio = GetExProp(claymore, 'ABIL_SAPPER33')
--        
--        if abil_ratio ~= nil and abil_ratio ~= 0 then
--            abil_33_AtkAdd = skill.SkillAtkAdd * abil_ratio;
--        end
--    end
    
--    local dmgRate = 1;
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local target = tgtList[i];
        local damage = SCR_LIB_ATKCALC_RH(self, skill);				
        
--        damage = damage + abil_33_AtkAdd;
        RunScript('PROCESS_CLAYMORE_DAMAGE', self, target, skill.ClassName, damage);
    end
    
    DelExProp(claymore, 'ABIL_SAPPER33')
    ClearExArgObject(self, "SAPPER_TRAP_" .. skill.ClassName)
end

function PROCESS_CLAYMORE_DAMAGE(self, target, skillClassName, damage)
    local result = TakeDamageSuspend(self, target, skillClassName, damage);
    if result == 1 then
        SetExProp(target, "NO_HIT", 1);
    end
end