--- hardskill_cryomancer.lua

-- wiz subzeroshield
function WIZ_SUBZERO_MON(self, parent, skl)

    local owner = GetOwner(self)

    SetExProp(owner, "SUBZEROSHIELD", 1)

    AddHitScript(self, "SUBZEROSHIELD_HIT");
end

function SUBZEROSHIELD_HIT(self, attacker, skl, dmg, ret)

    ret.Damage = 0;
    ret.HitType = HIT_NOHIT;
    ret.ResultType = HITRESULT_INVALID;
    ret.EffectType = HITEFT_NO;
    ret.HitDelay = 0;
    
    local owner = GetOwner(self)
    local damage = GET_SKL_DAMAGE(owner, attacker, 'Cryomancer_SubzeroShield');
    if damage < 1 then
        damage = 1;
    end
    
    local key = GetSkillSyncKey(owner, ret);
    StartSyncPacket(owner, key);
    
    local addDamage = 0;
    local Cryomancer10_abil = GetAbility(owner, "Cryomancer10")
    if Cryomancer10_abil ~= nil then
        local shield = GetEquipItem(owner, 'LH')
        if shield ~= nil and shield.ClassType == "Shield" then
            addDamage = shield.DEF * Cryomancer10_abil.Level * 0.5
        end
    end
    
    TakeDamage(owner, attacker, skl.ClassName, damage + addDamage, "Ice", "Magic", 'Magic', HIT_ICE, HITRESULT_BLOW);
    AttachEffect(self, 'E_subzeroshield_hit', 1, MID, 0)
    
    local subskill = GetSkill(self, "Cryomancer_SubzeroShield")
    local freezeRate = 50 + subskill.Level * 10;
    if freezeRate > 100 then
        freezeRate = 100;
    end

    if 1 == SPCI_COND_ISMONSTER(self, skl, attacker) then
        if attacker.RaceType == 'Paramune' then
            freezeRate = freezeRate * 0.2;  -- ???????? ???? ????? 20?????
        end
    end

    local freezeTime = 5000
    local abil = GetAbility(owner, "Cryomancer7")
    if abil ~= nil then
        freezeTime = freezeTime + abil.Level * 1000
    end
    
    if IMCRandom(1,100) < freezeRate then
        local objList, cnt = SelectObjectNear(owner, attacker, 20, "ENEMY", 0, 0);
        
        if cnt > 5 then
            cnt = 5;
        end
        
        for i=1, cnt do
            local target = objList[i]
            AddBuff(owner, attacker, 'Cryomancer_Freeze', 1, 0, freezeTime, 1)
        end
    end

    EndSyncPacket(owner, key, 0);
end

-- wiz gust

function SCR_SKILL_GUST(self, target, skill, ret)
	AddBuff(self, target, "Gust_Debuff", 1, 0, 5000 + (skill.Level * 1000), 1)
	
    NO_HIT_RESULT(ret);
    
    -- NPC?? ????o??. faction???? u????
    local targetFaction = GetCurrentFaction(target);
    if targetFaction == 'Peaceful' or targetFaction == 'Neutral' then
        return;
    end

    local groupName = TryGetProp(target, 'GroupName');
    local moveType = TryGetProp(target, 'MoveType');

    if nil ~= groupName and nil ~= moveType then
        if "NPC" == groupName and "Holding" == moveType then 
        return;
        end
    end


    local beforeGust = GetExProp(target, 'GUST_TIME');
    if beforeGust + 0.5 > imcTime.GetAppTime() then
        return;
    end
    SetExProp(target, 'GUST_TIME', imcTime.GetAppTime());

    local angle = GetSkillDirByAngle(self); 
    local key = GetSkillSyncKey(self, ret);

    local abil = GetAbility(self, "Cryomancer3");
    
    if 'pcskill_icewall' == target.ClassName or 'attract_pillar' == target.ClassName then
        StartSyncPacket(self, key);
        local x, y = GetDirection(self);
        UseMonsterSkillToDir(target, 'Mon_pcskill_icewall_Skill_1', x, y);
        --local x, y, z = GetPos(target);
        --local pad = RunPad(self, 'Cryomancer_Gust', skill, x, y, z, angle, 1);
        --if pad ~= nil then
        --    local range = 100 + GetDistance(self, target);
        --    x, y, z = GetFrontPos(self, range);
        --    SetPadDestPosByTime(pad, x, y, z, 0.3, 1);
        --end
        EndSyncPacket(self, key, 0);
    elseif GetBuffByProp(target, 'Keyword', 'Freeze') ~= nil then
        StartSyncPacket(self, key);
        local damage = GET_SKL_DAMAGE(self, target, 'Cryomancer_Gust');
        if abil ~= nil then
            RunScript('SCR_GUST_CRYOMANCER3', self, target, skill, damage, 3)
        else
            RunScript('SCR_GUST_CRYOMANCER3', self, target, skill, damage, 1)
        end
--      TakeDamage(self, target, "None", damage + skill.SkillAtkAdd, "Ice", "Magic", 'Magic', HIT_ICE, HITRESULT_BLOW);
        EndSyncPacket(self, key, 0);
    else
        StartSyncPacket(self, key);
        local damage = GET_SKL_DAMAGE(self, target, 'Cryomancer_Gust'); 
        if abil ~= nil then
            RunScript('SCR_GUST_CRYOMANCER3', self, target, skill, damage, 2)
        end
        if IS_PC(target) == true or (IS_PC(target) == false and target.KDArmor < 900 and target.MoveType ~= "Holding") then
            local kdDEF = target.KDArmorType;
            if kdDEF <= 10000 then
                KnockBack(target, self, 200, angle, 30, 0.9);
            end
        end
        EndSyncPacket(self, key, 0);
    end
end

function SCR_GUST_CRYOMANCER3(self, target, skill, damage, count)
    --sleep(250)
    if count ~= nil and count >= 1 then
        for i = 1, count do
          TakeDamage(self, target, "Cryomancer_Gust", damage, "Ice", "Magic", 'Magic', HIT_ICE, HITRESULT_NO_HITSCP);
          sleep(50)
        end
    end
end

function INIT_ICEWALL_MONSTER(self)
    EnableIgnoreOBB(self, 1);
    SetHideFromMon(self, 1);
end 


function SCR_ICEWALL_HIT(self, from, skill, damage, ret)
    local instSkillName = "Mon_pcskill_icewall_Skill_1";
    
    if IS_PC(from) == false then
        return;
    end
    
    if skill.ClassName == "Psychokino_PsychicPressure" or skill.ClassType == "Melee" then
    	RunScript('_SCR_ICEWALL_HIT', self, from, skill, damage, ret, instSkillName)
    end
end

function _SCR_ICEWALL_HIT(self, from, skill, damage, ret, instSkillName)
    local x, y = GetDirection(from);
    local skillCheck = GetSkill(from, instSkillName);
    if skillCheck == nil then
        AddInstSkill(from, instSkillName);
    end
    
    local skillOwner = GetExArgObject(self, "SUMMONER");
    if skillOwner == nil then
    	return;
    end
	
    local ownerSkillCheck = GetSkill(skillOwner, instSkillName);
    if skillCheck == nil then
        AddInstSkill(skillOwner, instSkillName);
    end
    
    UseMonsterSkillToDir(self, instSkillName, x, y);
end

--function DROP_CRYORITE(self)
--
--  local ownerHandle = GetExProp(self, 'OWNER_HANDLE');
--  local instID = GetZoneInstID(self);
--  local owner = GetByHandle(instID, ownerHandle);
--
--  if owner ~= nil then
--      local abil = GetAbility(owner, "Cryomancer6")
--      if abil ~= nil then
--          if IMCRandom(1,9999) < abil.Level * 100 then
--              local x, y, z = GetPos(self);
--              local itemObj = CreateGCIES('Monster', 'misc_jore11');
--              local item = CreateItem(owner, itemObj, x, y, z, 0, 10);
--          end
--      end
--  end    
--end

function SCR_ICEWALL_ICEBLAST_SKL_HIT(self, skill, x, y, z, range)
    local tgtList = GetHardSkillTargetList(self);
    if tgtList == nil then
        return;
    end
    
    if #tgtList >= 1 then
        local iceWallCount = 0;
        for i = 1 , #tgtList do
            local target = tgtList[i];
            if target.ClassName == 'pcskill_icewall' then
                iceWallCount = iceWallCount + 1;
                
                local list, cnt = SelectObjectNear(self, target, range, "ENEMY");
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'pcskill_icewall' then
                            AddScpObjectList(self, "ICEWALL_ICEBLAST_ENEMY", list[i]);
                        end
                    end
                end
                
            end
        end
        
        local enemyList = GetScpObjectList(self, "ICEWALL_ICEBLAST_ENEMY");
        if iceWallCount > 0 and #enemyList > 0 then
            local damage = GET_SKL_DAMAGE(self, target, 'Cryomancer_IceBlast');
            local skill = GET_MON_SKILL(self, 'Cryomancer_IceBlast');
            
            local enemyCount = math.min(iceWallCount, #enemyList);
            
            for j = 1, enemyCount do
                local enemy = enemyList[j];
                if IS_PC(enemy) == false then
                    local Cryomancer8_abil = GetAbility(self, "Cryomancer8")
                    if Cryomancer8_abil ~= nil then
                        SetExProp(enemy, "ADD_ICEBLAST_DAMAGE", Cryomancer8_abil.Level * 10)
                    else
                        DelExProp(enemy, "ADD_ICEBLAST_DAMAGE")
                    end
                end
                
                TakeDamage(self, enemy, skill.ClassName, damage, "Ice", "Magic", "Magic", HIT_ICE, HITRESULT_BLOW);
            end
        end
        
        ClearScpObjectList(self, "ICEWALL_ICEBLAST_ENEMY")
    end
end

function SCR_FROSTPILAR_BUFFTIME(self, skill, pad)
    local startTime = imcTime.GetAppTime();
    SetExProp(self, "Cryomancer_FrostPillar_startTime", startTime);
end