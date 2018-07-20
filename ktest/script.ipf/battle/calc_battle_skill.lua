-- calc_battle_skill.lua

function POST_ATK_Doppelsoeldner_Cyclone(self, from, skill, splash, ret)

    local abil = GetAbility(from, 'beating');
    if abil ~= nil then
        local angle = GetAngleTo(from, self);
            if self.KDArmor >= skill.KDRank then
             return;
            end
        return KnockBack(self, from, 20, angle, 45, 1);
    else
        local angle = GetAngleTo(from, self);
            if self.KDArmor >= skill.KDRank then
              return;
            end
        return KnockBack(self, from, 45, angle, 45, 1);

    end
    
end


function END_ATK_Cryomancer_IceBolt(self, from, skill, splash, ret)

    local FreezeRating = 30;
    
    local abilCryomancer2 = GetAbility(from, 'Cryomancer2');
    if abilCryomancer2 ~= nil and TryGetProp(abilCryomancer2, "ActiveState") == 1 and IsPVPServer(from) == 0 then
        FreezeRating = FreezeRating * (1 + abilCryomancer2.Level * 0.1);
    end
    
    local abilCryomancer9 = GetAbility(from, "Cryomancer9");
    if abilCryomancer9 ~= nil and TryGetProp(abilCryomancer9, "ActiveState") == 1 then
        FreezeRating = math.floor(FreezeRating * (1 + abilCryomancer9.Level * 0.05));
    end
    
    if IMCRandom(0, 100) < FreezeRating and TryGetProp(self, "MonRank") ~= "Boss" then
        local key = GetSkillSyncKey(self, ret);
        local buffTime = 5000

        StartSyncPacket(self, key); 
        AddSkillBuff(from, self, ret, 'Cryomancer_Freeze', 1, 0, buffTime, 1);
        EndSyncPacket(self, key);
    end
end

function END_ATK_Cryomancer_IciclePike(self, from, skill, splash, ret)

    local FreezeRating = 70;
    if IMCRandom(0, 100) < FreezeRating and TryGetProp(self, "MonRank") ~= "Boss" then
        local key = GetSkillSyncKey(self, ret);
        local buffTime = 5000
--        if IsPVPServer(self) == 1 then
--             buffTime = 2500;
--        end
        StartSyncPacket(self, key); 
        AddSkillBuff(from, self, ret, 'Cryomancer_Freeze', 1, 0, buffTime, 1);
        EndSyncPacket(self, key);
    end
    
end 


function END_ATK_Pyromancer_FireBall(self, from, skill, splash, ret)

--    local FireRating = 30;
--    if IMCRandom(0, 100) < FireRating and TryGetProp(self, "MonRank") ~= "Boss" then
--      --AddSkillBuff(from, self, ret, 'Fire', 1, 0, 5000, 1);
--  end

end


function POST_ATK_Scout_FluFlu(self, from, skill, splash, ret)

    local maxCount = 5;
    
    local Scout6_abil =  GetAbility(from, 'Scout6')
    if Scout6_abil ~= nil then 
        maxCount = maxCount + (Scout6_abil.Level * 1)
    end
    
    local objList, objCount = SelectObjectByFaction(self, 200, GetCurrentFaction(self));
    if objCount > maxCount then
        objCount = maxCount
    end
    
    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    for i=0, objCount do
        local obj = objList[i];
        if obj ~= nil and GetRelation(self, obj) ~= "ENEMY" then
            AddBuff(from, obj, 'FluFlu_Debuff', skill.Level, 0, 8000 + skill.Level * 200, 1);
        end
    end
    
    AddBuff(from, self, 'FluFlu_Buff', skill.Level, 0, 8000 + skill.Level * 200, 1);

    EndSyncPacket(self, key);
end

function POST_ATK_Archer_OverDraw(self, from, skill, splash, ret)

      local StunRating = 30
      local random = IMCRandom(0, 100);
      if random < StunRating then
          AddBuff(from, self, 'Stun', 1, 0, skill.Level * 1000, 1);
    end
end

function POST_ATK_Rancer_HeadStrike(self, from, skill, splash, ret)
    local abil = GetAbility(from, "Lancer5");
    if abil ~= nil then
        local stunRate = abil.Level * 10;
        local rand = IMCRandom(0, 100);
        if rand < stunRate then
            AddBuff(from, self, 'Stun', 1, 0, 2500, 1);
        end
    end
end

--attacker는 때린 애, 현재 쌓아줄 HATE 수치
function SCR_CALC_HATE_POINT(attacker, AddHatePoint, skill)
    local skillHateRate = 0;
    
    local Swordman28_abil = GetAbility(attacker, "Swordman28");
    local Peltasta30_abil = GetAbility(attacker, "Peltasta30");
    local Swordman28_lv = TryGetProp(Swordman28_abil, "Level");
    local Peltasta30_lv = TryGetProp(Peltasta30_abil, "Level");
    
    if Swordman28_abil ~= nil then
        skillHateRate = skillHateRate + Swordman28_abil.Level * 0.5;
        if IsBuffApplied(attacker, "SwashBuckling_Buff") == "YES" and Peltasta30_abil ~= nil then
            skillHateRate = skillHateRate * (1 + Peltasta30_lv * 0.1);
        end
    end
    
    if TryGetProp(skill, "Job") == "Peltasta" then
        local addHateRateByPeltastaSkill = 50;
        if TryGetProp(skill, "ClassName") == "Peltasta_UmboThrust" then
            addHateRateByPeltastaSkill = addHateRateByPeltastaSkill * 2;
        end
        
        skillHateRate = skillHateRate + addHateRateByPeltastaSkill;
    end
    
    local cardHateRate = GetExProp(attacker, "CARD_HATE_RATE");
    if cardHateRate == nil then
        cardHateRate = 0;
    end
    local buffHateRate = GetExProp(attacker, "BUFF_HATE_RATE");
    if buffHateRate == nil then
        buffHateRate = 0;
    end
    
    skillHateRate = 1 * skillHateRate;
    
    local addHateRate = 1 + ((cardHateRate + buffHateRate)/100);
    if skillHateRate <= 0 then
        skillHateRate = 1;
    end
    
    AddHatePoint = AddHatePoint * addHateRate * skillHateRate;
    
    --여기서 리턴하는 HATE 수치가 최종적으로 적용되는 값은
    --C++ 코드에서 AddHatePoint + returnValue
    --returnValue는 hatePoint 값을 뜻함.
    
    AddHatePoint = math.floor(AddHatePoint);
	
	if AddHatePoint < 1 then
		AddHatePoint = 1;
	end
	
    return AddHatePoint;
end

function SCR_ADD_ATK_BY_SHIELD(self, from, skill, atk, ret, rateTable, addRate)
    local equipLH = GetEquipItem(from, "LH");
    if TryGetProp(equipLH, "AttachType") == "Shield" then
        local shieldDef = TryGetProp(equipLH, "DEF");
        if addRate ~= nil then
            local addShiledRate = shieldDef * addRate;
            rateTable.AddAtkDamage = rateTable.AddAtkDamage + addShiledRate;
        end
    end
end

function SCR_ADD_ATK_BY_SUBWEAPON(self, from, skill, atk, ret, rateTable, addLhRate, addRhRate)
    local equipLH = GetEquipItem(from, "LH");
    local equipRH = GetEquipItem(from, "RH");
    
    if TryGetProp(equipLH, "GroupName") == "SubWeapon" and TryGetProp(equipLH, "ClassType") ~= "Artefact" then
        local maxAtkLH = TryGetProp(from, "MAXPATK_SUB");
        local minAtkLH = TryGetProp(from, "MINPATK_SUB");
        local addRateAtkLH = (maxAtkLH + minAtkLH)/2;
        if addLhRate ~= nil then
            rateTable.AddAtkDamage = rateTable.AddAtkDamage + (addRateAtkLH * addLhRate)
        end
        
    end
    if addRhRate ~= nil then
        local maxAtkRH = TryGetProp(from, "MAXPATK");
        local minAtkRH = TryGetProp(from, "MINPATK");
        local addRateAtkRH = (maxAtkRH + minAtkRH)/2;
        rateTable.AddAtkDamage =rateTable.AddAtkDamage + (addRateAtkRH * addRhRate)
    end
end