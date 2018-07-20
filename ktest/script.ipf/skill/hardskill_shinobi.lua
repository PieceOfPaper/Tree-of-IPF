--- hardskill_shinobi.lua


function SCR_BUFF_ENTER_Mokuton_no_jutsu(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_Mokuton_no_jutsu(self, buff, arg1, arg2, over)
	
end


function SCR_BUFF_TAKEDMG_Mokuton_no_jutsu(self, buff, sklID, damage, attacker, ret)

	RemoveBuff(self, "Mokuton_no_jutsu")
	if attacker == nil then
		return 1;
	end

	local woodEffect = "F_warrior_MokutonNoJuts_land_smoke";
	local jumpHeight = 400;
	local jumpAnim = "SFALL";
	local splashRange = 100;
	local attackEffect = "F_ground071_smoke";
	local attackEffectScale = 0.3;
	local disAppearTime = 1;

	local key = nil;
	if ret ~= nil then
		key = GetSkillSyncKey(self, ret);
		StartSyncPacket(self, key);
		
		ret.HitDelay = 0;
		ret.ResultType = HITRESULT_BLOW;
		ret.HitType = HIT_NOMOTION;
	end

	local x, y, z = GetPos(self)	
    local mon = CREATE_MONSTER_EX(self, 'skill_wood_A', x, y, z, 0, GetCurrentFaction(self), self.Lv);
    SetLifeTime(mon, 2)

	PlayEffectToGround(self, woodEffect, x, y, z, 1, 1);
	
	if key ~= nil then
		DelayEnterWorld(mon);
		EnterDelayedActor(mon);
	end

	local wx, wy, wz = GetPos(attacker);
	SetPos(self, wx, wy, wz);
	wy = wy + jumpHeight;

	SetSafe(self, 1);
	ShowModel(self, 0, 0.01);
	DisableControlForTime(self, disAppearTime + 1.5);
	if key ~= nil then
		EndSyncPacket(self, key);
	end

	RunScript("Mokuton_Appear", self, sklID, wx, y, wy, wz, disAppearTime, jumpAnim, jumpHeight, attackEffect, attackEffectScale);

	return 0;
end

function Mokuton_Appear(self, sklID, wx, y, wy, wz, disAppearTime, jumpAnim, jumpHeight, attackEffect, attackEffectScale)

	HoldCameraHeight(self, 1);
	sleep(disAppearTime * 1000);

	SetPos(self, wx, wy, wz);
	SetSpecialFallSpeedRateServ(self, 4.5);
	ShowModel(self, 1, 0.01);
	SetSafe(self, 0);
	PlayAnim(self, jumpAnim, 0);
	ReserveLandAnimation(self, "SKL_MOKATONNOJUTS_LAND", 60);	
	
	local key = GenerateSyncKey(self);
	StartSyncPacket(self, key);
	SPLASH_DAMAGE(self, wx, wy, wz, 300, "Shinobi_Mokuton_no_jutsu");
	PlayEffectToGround(self, attackEffect, wx, y, wz, attackEffectScale);
	SetSpecialFallSpeedRateServ(self, 1.0);
	
	HoldCameraHeight(self, 0);
	EndSyncPacket(self, key, 0);
  SyncPacketByOnGround(self, key);


end

function CLEAR_DUMMY_PC(self, propName)

	local dpcList = GetDummyPCList(self);
	if nil == dpcList then
		return;
	end
	
	for i = 1 , #dpcList do
		local dpc = dpcList[i];
		if GetExProp(dpc, propName) == 1 then
			Kill(dpc);
		end
	end
end

function CREATE_BUNSIN_DUMMYPC(self, skl, x, y, z, animName, normalAtk, buffName, buffTime, cnt)

    CLEAR_DUMMY_PC(self, 'BUNSIN');
    
    cnt = math.floor(cnt);
    for i = 1 , cnt do      
        local rx, ry, rz = GetRandomPos(self, x, y, z, 30);
        local dpc = CREATE_DUMMYPC(self, rx, ry, rz, GetDirectionByAngle(self), 0, 0, 0, 1);
        if dpc ~= nil then      
            SetDummyPCAIType(dpc, DPC_AI_NINJA);
            SetCurrentFaction(dpc, GetCurrentFaction(self));
            
            ChangeNormalAttack(dpc, normalAtk);     
            
            local skills = GET_NINJA_SKILLS();
            for j = 1 , #skills do
                local skl = skills[j];
                local sklLevel = 1;
                local sklObj = GetSkill(self, skl);
                if sklObj ~= nil then
                    sklLevel = sklObj.Level;
                end

				AddInstSkill(dpc, skl, sklLevel);
			end			

            SetOwner(dpc, self, 1);
            BroadcastShape(dpc);
            SendDummyPCInfo(self, dpc);
            SetExProp(dpc, "BUNSIN", 1);
            SetExArgObject(dpc, 'BUNSIN_OWNER', self);
            -- SetSummonDummyPc(self, dpc);
            PlayAnim(dpc, animName);
            InvalidateStates(dpc)
            if buffName ~= 'None' then
                AddBuff(self, dpc, buffName, 1, 0, buffTime, 1);
--                if IsBuffApplied(self, "RamMuay_Buff") == "YES" then
--                    AddBuff(self, dpc, "RamMuay_Buff", 1, 0, buffTime, 1);
--                end
            end
        end
    end

	UpdateDummyPCList(self);

end


-- Ninja_Bunsin
function SCR_BUFF_ENTER_Bunshin_Buff(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255.0, 255.0, 255.0, 150, 1, 1);
end

function SCR_BUFF_LEAVE_Bunshin_Buff(self, buff, arg1, arg2, over)
    SetZombie(self);
end

function SCR_BUFF_ENTER_Bunshin_Debuff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self)
    local abil = GetAbility(self, "Shinobi6")
    if abil ~= nil then
        SetBuffUpdateTime(buff, 1000 + abil.Level * 50)
    end
end

function SCR_BUFF_UPDATE_Bunshin_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

	---- per 1 second
	------ modify here ------
--	local bunsinCount = GET_BUNSIN_COUNT(self);
    local bunsinCount = GetBuffArg(buff);
    AddStamina(self, -250 * bunsinCount)
	 -- AddSP(self, -bunsinCount);
	-------------------------

	if GetStamina(self) <= 0 then
		CLEAR_DUMMY_PC(self, "BUNSIN");
		return 0;
	end

	return 1;

end

function GET_BUNSIN_COUNT(self)

	local bunsinCount = 0;
	local dpcList = GetDummyPCList(self);
	if dpcList ~= nil then
		for i = 1 , #dpcList do
			local dpc = dpcList[i];
			if GetExProp(dpc, "BUNSIN") == 1 and IsDead(dpc) == 0 then
				bunsinCount = bunsinCount + 1;
			end
		end
	end

	return bunsinCount;
		
end

function SCR_BUFF_LEAVE_Bunshin_Debuff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self)
end

function SCR_BUFF_AFTERCALC_HIT_Bunshin_Debuff(self, from, skill, atk, ret, rateTable, buff)

end

function SCR_BUFF_AFTERCALC_HIT_Bunshin_Buff(self, from, skill, atk, ret, rateTable, buff)
    
    ------ modify here ------
    local owner = GetOwner(self);
    local bunsinCount = GET_BUNSIN_COUNT(owner);
    ret.Damage = ret.Damage * bunsinCount;
    
--    local abil = GetAbility(owner, "Shinobi8")
--    if abil ~= nil and bunsinCount >= 2 then
--        ret.Damage = ret.Damage * (1 - abil.Level * 0.04)
--    end
    -------------------------

end

function REMOVE_BUNSHIN_BY_MijinNoJutsu(self, skill)
    if IsBuffApplied(self, "Bunshin_Debuff") == "YES" then
        RemoveBuff(self, "Bunshin_Debuff");
    end
    
    if IS_REAL_PC(self) == "NO" then
        if GetExProp(self, "BUNSIN") == 1 then
            RemoveBuff(self, "Bunshin_Buff");
        end
    end
end
