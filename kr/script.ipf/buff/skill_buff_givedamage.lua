-- skill_buff_givedamage.lua
-- attacker->GetBuffList()->OnEvent(BET_GIVE_DAMAGE, skill->GetClassID(), ret->GetDamage(), defender, ret->GetIESObject());
-- return 0 is removebuff.  (self is attacker)

-- buff_hardskill
function SCR_BUFF_GIVEDMG_sorcerer_bat(self, buff, sklID, damage, target, ret)
    if IsDead(target) == 0 and IsSameObject(self, target) == 0 then
        ATTACK_SORCERER_BAT(self, buff, target)
    end

    return 1;
end


-- buff
function SCR_BUFF_GIVEDMG_Restrain_Buff(self, buff, sklID, damage, target, ret)
    local arg1, arg2 = GetBuffArg(buff);
    local rating = arg1 * 600;
    local duration = 1000;
    local Random = IMCRandom(1, 9999)
    if rating >= Random and GetRelation(self, target) == "ENEMY" then 
        AddBuff(self, target, 'Restrain_Debuff', 1, 0, duration, 1);
    end
    return 1;
end

function SCR_BUFF_GIVEDMG_Concentrate_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
	
	local skill = GetClassByType("Skill", sklID);
	
    if GetRelation(self, target) == "ENEMY" and skill.ClassName ~= "Default" and (skill.ClassType == "Melee" or skill.ClassType == "Missile") then
    	local atkCount = GetExProp(buff, "ConcentrateCount");
    	
	    SetExProp(buff, "ConcentrateCount", atkCount - 1);
        
	    if atkCount <= 0 then
	        return 0;
	    end
    end
    
    return 1;
end

function SCR_BUFF_GIVEDMG_DivineMight_Buff(self, buff, sklID, damage, target, ret)
    
    if 1 == 1 then
        return 1;
    end

    if damage <= 0 then
        return 1;
    end

    if skillid < 10000 then
        return 1;
    end
    
    DelExProp(self, "BuffSkillLv");
    DelExProp(self, "isDivineMight_Debuff")
    return 0;
end


function SCR_BUFF_GIVEDMG_DivineMight_Debuff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

    DelExProp(self, "isDivineMight_Debuff")
    return 0;
end

function SCR_BUFF_GIVEDMG_Cloaking_Buff(self, buff, sklID, damage, target, ret)
    if damage > 0 then
        return 0;
    end

    return 1;
end

function SCR_BUFF_GIVEDMG_ShinobiCloaking_Buff(self, buff, sklID, damage, target, ret)
    if damage > 0 then
        return 0;
    end

    return 1;
end

function SCR_BUFF_GIVEDMG_Double_pay_earn_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

    local atkCount = GetExProp(self, "DoublePayEarn");

    if atkCount == 1 then
        if 0 >= tonumber(target.HP) - tonumber(damage)  then
        SetExProp(self, "DoubbleExp", 2)
        SetExProp(self, "DobbbleItem", 1)
        end
        return 0;
    end
    
    SetExProp(self, "DoublePayEarn", atkCount - 1)
    return 1;
end


function SCR_BUFF_GIVEDMG_Warrior_Once_Critical_Buff(self, buff, sklID, damage, target, ret)
    return 0;
end

function SCR_BUFF_GIVEDMG_SpiralArrow_Buff(self, buff, sklID, damage, target, ret)
    
    if skillid < 100 then
        return 0;
    end
      
    return 1;
end

function SCR_BUFF_GIVEDMG_Fade_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    return 0;
end

function SCR_BUFF_GIVEDMG_DarkSight_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    return 0;
end

function SCR_BUFF_GIVEDMG_Zhendu_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

    local ZhenduskillLv = GetBuffArgs(buff);
    if ZhenduskillLv > 0 and GetRelation(self, target) == "ENEMY" then
        AddBuff(self, target, 'Zhendu_Debuff', ZhenduskillLv, 0, 5000 + ZhenduskillLv * 2000, 1);
        return 0;
    end
    
    return 1;
end


function SCR_BUFF_GIVEDMG_Looting_Buff(self, buff, sklID, damage, target, ret)

    if GetLayer(self) ~= 0 then
        return 1;
    end

    if target == nil then
        return 1;
    end
    
    if IS_PC(target) == false and target.DebuffRank == "Field" or target.DebuffRank == "Hero" then
            return;
        end

    local dropItemList = TryGetProp(target, "DropItemList");

    if dropItemList == nil or dropItemList == "None" then
        return 1;
    end

    if GetLayer(self) == 0 or IsMissionInst(self) == 1 then
            local enable = GetExProp(target, 'LOOTING_ENABLE');
            if enable == nil or enable < 1 then

--          --[[ Ï°∏Î¶¨Î°úÏ?Î°??ΩÌÉà ?ïÎ•† Í≥ÑÏÇ∞?òÎäî Î∂ÄÎ∂??ºÎã® Ï£ºÏÑù Ï≤òÎ¶¨?¥Ïó¨
--            local sklCls = GetSkill(caster, "Corsair_JollyRoger");
--
--          if sklCls == nil then
--              return;
--          end
--
--            local lootingRatio = sklCls.Level * 250;
--          ]]--
            
            local caster = GetBuffCaster(buff)
            if caster == nil then
                return 0;
                end
            
            local corsair_rank = GetJobGradeByName(caster, 'Char1_8')
            if corsair_rank == nil or corsair_rank == 0 then
                return 0;
            end
            
--            if corsair_rank > 3 then
--                corsair_rank = 3;
--            end
            
            local lootingRatio = corsair_rank * 1250; -- ÎßåÎ†ô Í∏∞Ï??ºÎ°ú ?ºÎã® ?¥ÎÜ®?îÎç∞, ?ïÎ•† Í≥µÏãù ?ïÌï¥ÏßÄÎ©??¥Í≥≥??Î∞îÍøîÏ£ºÏÑ∏?

                if target.MonRank == 'Boss' then
                    lootingRatio = lootingRatio / 300;
                end

                local lootingResult = IMCRandom(1, 100000);

                if lootingResult < lootingRatio then

                    local clsList, cnt  = GetClassList("MonsterDropItemList_" .. target.DropItemList);
                    
                    if clsList == nil then
                        return;
                    end
                    
                    local list = {};
                    local totalDropRatio = 0;
                    local money = 0;
                    local moneyCnt = 5;

                    for i = 0, cnt - 1 do
                        local drop = GetClassByIndexFromList(clsList, i);
                        list[i] = {};

                        if drop ~= nil then
                            list[i][1] = drop.ItemClassName;

                            local dpkAvg = 1;
                            local dropRatio = 1;
                            
                            if drop.DPK_Max > 0 then
                                dpkAvg = (drop.DPK_Min + drop.DPK_Max) / 2;
                                dropRatio = (10000 / dpkAvg) * (drop.DropRatio / 10000);
                            else
                                dropRatio = drop.DropRatio * (1 / dpkAvg);
                            end
                            
                            if drop.GroupName == 'Money' then
                                money = IMCRandom(drop.Money_Min, drop.Money_Max);
                                money = math.floor(money / 15);
                            
                                if money < 1 then
                                    money = 1;
                                end

                                if money < 2 then
                                    moneyCnt = 1;
                                end
                            else
                                if dropRatio > 1000 then
                                    dropRatio = dropRatio * 5;
                                elseif dropRatio > 300 then
                                    dropRatio = dropRatio * 2;
                                end
                            end
                            
                            list[i][2] = math.floor(dropRatio);
                            totalDropRatio = totalDropRatio + list[i][2];
                            
                        end
                    end
                    
                    local resultRatio = IMCRandom(1, totalDropRatio);
                    local ratioRange = 0;
                    
                    for j = 0, #list do
                        if list[j][2] ~= nil then
                            ratioRange = ratioRange + list[j][2];
                        end
                        
                        if list[j][2] > 0 and resultRatio <= ratioRange then
                            if list[j][1] == 'Moneybag1' then
                                
                                GIVE_REWARD_MONEY(self, self, money, moneyCnt);
                                
                                SetExProp(target, 'LOOTING_ENABLE', 1);
                                LootingDropItemMongoLog(self, target, list[j][1]);
                                
                                SkillTextEffect(nil, self, target, 'SHOW_SKILL_EFFECT', 0, nil, 'skl_looting');
                                PlaySound(self, 'item_drop_skl_looting');
                                
                                break;
                            else
                                local itemObj = CreateGCIES('Monster', list[j][1]);
                                if itemObj == nil then
                                    return 1;
                                end
                                local x, y, z = GetPos(target);
                                CreateItem(self, itemObj, x, y, z, 0, 5);
                                
                                SetExProp(target, 'LOOTING_ENABLE', 1);
                                LootingDropItemMongoLog(self, target, list[j][1]);
                                
                                SkillTextEffect(nil, self, target, 'SHOW_SKILL_EFFECT', 0, nil, 'skl_looting');
                                PlaySound(self, 'item_drop_skl_looting');
                                
                                break;
                            end
                        end
                    end
                    
                end
            end
        end
    return 1;
end

function SCR_BUFF_GIVEDMG_EnchantFire_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
	
	local skill = GetClassByType("Skill", sklID);
	
    if sklID < DEFAULT_SKILL_CLASSID or skill.ClassName == "Wizard_EnergyBolt" and target.RaceType ~= 'Item' then     
        local enchantFireLv, casterMATK = GetBuffArgs(buff);
        if enchantFireLv > 0 then
            local stat = casterMATK * 0.1;
            
            local key = GetSkillSyncKey(self, ret);
            StartSyncPacket(self, key);
            TakeDadak(self, target, "None", math.floor(stat), 0.1, "Fire", "Magic", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
            EndSyncPacket(self, key, 0);
        end
    end
    
    return 1;
end


function SCR_BUFF_GIVEDMG_KaguraDance_Buff(self, buff, sklID, damage, target, ret)
    local sklCls = GetClassByType("Skill", sklID);
    local selfSkl = nil;
    if nil ~= sklCls then
        selfSkl = GetSkill(self, sklCls.ClassName)
    end
    if selfSkl ~= nil and selfSkl.ClassType == 'Melee' then
        if IsBuffApplied(target, 'Kagura_Debuff') == 'YES' then
            if sklID ~= DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
            local key = GetSkillSyncKey(self, ret);
            local sklLv = GetBuffArg(buff);
            local damage = damage * (sklLv * 0.1)
            StartSyncPacket(self, key);
            TakeDadak(self, target, "None", damage, 0.15 , "Holy", "Magic", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
            EndSyncPacket(self, key, 0);
            end
        end
    end
    return 1;
end

function SCR_BUFF_GIVEDMG_Sacrament_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
	
	local skill = GetClassByType("Skill", sklID);
	
    if sklID < DEFAULT_SKILL_CLASSID or skill.ClassName == "Wizard_EnergyBolt" and target.RaceType ~= 'Item' then
        
        local holyAddAttack = GetBuffArgs(buff);
		
	    if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then	-- ?ÅÏ†ê Î≤ÑÌîÑ???®Í≥º 70% --
	    	holyAddAttack = math.floor(holyAddAttack * 0.7);
	    end
        
        holyAddAttack = IMCRandom(holyAddAttack * 0.95, holyAddAttack * 1.05)
        
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        TakeDadak(self, target, "None", math.floor(holyAddAttack), 0.15 , "Holy", "Magic", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
        EndSyncPacket(self, key, 0);
    end

    return 1;
end


function SCR_BUFF_GIVEDMG_FireFoxShikigami_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
	
	local skill = GetClassByType("Skill", sklID);
	
    if skill.ClassName == "Psychokino_GravityPole" then
        local key = GetSkillSyncKey(self, ret);
        local skillGravityPole = GetSkill(self, "Psychokino_GravityPole")
        StartSyncPacket(self, key);
        TakeDadak(self, target, "None", damage, 0.15, "Fire", "Magic", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
        EndSyncPacket(self, key, 0);
    end
	
    return 1;
end


function SCR_BUFF_GIVEDMG_LastRites_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        local holyAddAttack = GetBuffArgs(buff);
        
		local myPercentHP = GetHpPercent(self);
		local checkPercentHP = 0.4;
		
		local caster = GetBuffCaster(buff);
		if caster ~= nil then
	        local abilChaplain1 = GetAbility(caster, "Chaplain1")
	        if abilChaplain1 ~= nil then
	            checkPercentHP = 0.4 + (0.02 * abilChaplain1.Level);
	        end
	    end
        
        if myPercentHP <= checkPercentHP then
        	holyAddAttack = holyAddAttack * 1.2;
        end
		
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        TakeDadak(self, target, "None", math.floor(holyAddAttack), 0.05 , "Holy", "Magic", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
        EndSyncPacket(self, key, 0);
    end
    
    return 1;
end

--function SCR_BUFF_GIVEDMG_LastRites_ActiveBuff(self, buff, sklID, damage, target, ret)
--    if damage <= 0 then
--        return 1;
--    end
--    
--    if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
--        local sklLv = 1;
--        local caster = GetBuffCaster(buff);
--        if caster ~= nil then
--            local sacramentSkl = GetSkill(caster, "Priest_Sacrament");
--            if sacramentSkl ~= nil then
--                sklLv = sacramentSkl.Level;
--            end
--        end
--        
--        local value = (12.2 + 3.1 * (sklLv - 1)) * 1.5;
--        
--        local key = GetSkillSyncKey(self, ret);
--        StartSyncPacket(self, key);
--        TakeDadak(self, target, "None", math.floor(value), 0.05 , "Holy", "Magic", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
--        EndSyncPacket(self, key, 0);
--    end
--    
--    return 1;
--end

function SCR_BUFF_GIVEDMG_Aspergillum_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        local damage = GET_SKL_DAMAGE(self, target, 'Priest_Aspersion');
        local key = GetSkillSyncKey(self, ret);
        local skill =  GetSkill(self, 'Priest_Aspersion') 
        if skill ~= nil then
            StartSyncPacket(self, key);
            TakeDadak(self, target, 'Priest_Aspersion', damage, 0.05)
            EndSyncPacket(self, key, 0);
        end
    end
    return 1;
end

function SCR_BUFF_GIVEDMG_LightningHands_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        local damage = GET_SKL_DAMAGE(self, target, 'Enchanter_LightningHands');
        local key = GetSkillSyncKey(self, ret);
        local skill =  GetSkill(self, 'Enchanter_LightningHands')
        if skill ~= nil then
            StartSyncPacket(self, key);
            TakeDadak(self, target, 'Enchanter_LightningHands', damage, 0.15)
            EndSyncPacket(self, key, 0);
        end
        
        local abil_Enchanter3 = GetAbility(self, "Enchanter3");
        if abil_Enchanter3 ~= nil and 1 == abil_Enchanter3.ActiveState then
        local abil_Enchanter3_Lv = abil_Enchanter3.Level;
            if IMCRandom(1, 100) <= abil_Enchanter3_Lv then
                AddBuff(self, target, "LightningHands_Debuff", 1, 0, 10000, 1)
            end
        end
    end
    
    return 1;
end

function SCR_BUFF_GIVEDMG_Merkabah_Buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    if sklID ~= 100 and target.RaceType ~= 'Item' then
        local abilLv = GetBuffArg(buff);
        if abilLv > 0 then
            local value = math.floor(damage * 0.1 * abilLv);
            local key = GetSkillSyncKey(self, ret);
            StartSyncPacket(self, key);
            TakeDadak(self, target, "None", value, 0.1, "Holy", "Magic", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
            EndSyncPacket(self, key, 0);
        end
    end
    
    return 1;
end


function SCR_BUFF_GIVEDMG_item_set_007_buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

     if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        TakeDadak(self, target, "None", 12, 0.15, "Earth", "Magic", "TrueDamage", HIT_EARTH, HITRESULT_BLOW);
        EndSyncPacket(self, key, 0);
    end

    return 1;
end

function SCR_BUFF_GIVEDMG_item_set_035_buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

     if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        TakeDadak(self, target, "None", 110, 0.15, "Ice", "Magic", "TrueDamage", HIT_ICE, HITRESULT_BLOW);
        EndSyncPacket(self, key, 0);
    end

    return 1;
end

function SCR_BUFF_GIVEDMG_item_set_011pre_buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

    if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        local result = IMCRandom(1, 100);
        if result == 1 then
            AddBuff(self, self, 'item_set_011_buff');
        end
    end

    return 1;
end


function SCR_BUFF_GIVEDMG_item_set_013_buff(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

    if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        local dmg = GetExProp(buff, "set_013_buff_over");
        if dmg > 0 then
            local key = GetSkillSyncKey(self, ret);
            StartSyncPacket(self, key);
            TakeDadak(self, target, "None", dmg, 0.15, "Earth", "Magic", "TrueDamage", HIT_EARTH, HITRESULT_BLOW);
            EndSyncPacket(self, key, 0);
        end
        
    end

    return 1;
end

function SCR_BUFF_GIVEDMG_EliteMonsterBuff(self, buff, sklID, damage, target, ret)
    local eliteMonBuffSkillCount = GetExProp(self, "EliteMonBuffSkillCount");
    local eliteMonDebuffSkillCount = GetExProp(self, "EliteMonDebuffSkillCount");

    local type = 0;
    if eliteMonBuffSkillCount > 0 or eliteMonDebuffSkillCount > 0 then
        local rnd = IMCRandom(0, 99);
        if rnd < 25 then
            if eliteMonBuffSkillCount > 0 and eliteMonDebuffSkillCount > 0 then
                local selectType = IMCRandom(1, 2);
                type = selectType;
            elseif eliteMonBuffSkillCount > 0 then
                type = 1;
            elseif eliteMonDebuffSkillCount > 0 then
                type = 2;
            end
        end
    end

    if type == 1 then
        local objList, objCount = SelectObject(self, 100, "FRIEND");
        local buffTarget = nil;
        for i = 1, #objList do
            local obj = objList[i];
            if obj.MonRank ~= "NPC" and (obj.MonRank == "Normal" or obj.MonRank == "Elite") then
                if obj.Faction == "Monster" then
                    if obj.Size == "S" or obj.Size == "M" then
                        buffTarget = obj;
                    end
                end
            end
        end
        
        if buffTarget ~= nil then
            local x, y, z = GetPos(buffTarget);
            RunPad(self, "Mon_Elite_Buff", nil, x, y, z, 0, 1);
        end
    elseif type == 2 then
        local x, y, z = GetPos(target);
        RunPad(self, "Mon_Elite_Debuff", nil, x, y, z, 0, 1);
    end

    return 1;
end



function SCR_BUFF_GIVEDMG_Sorcerer_Obey_Status_Buff(self, buff, sklID, damage, target, ret)
--    if damage <= 0 then
--        return 1;
--    end
--    
--    if sklID ~= 100 and target.RaceType ~= 'Item' then
--        local itemMATK = GetBuffArgs(buff);
--        if itemMATK > 0 then
--            local key = GetSkillSyncKey(self, ret);
--            StartSyncPacket(self, key);
--            
--            TakeDadak(self, target, "None", math.floor(itemMATK), 0.1, "Melee", "Melee", "TrueDamage", HIT_MELEE, HITRESULT_BLOW);
--            EndSyncPacket(self, key, 0);
--        end
--    end
    
    return 1;
end

function SCR_BUFF_GIVEDMG_ID_WHITETREES1_GIMMICK2_BUFF2(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    if sklID < DEFAULT_SKILL_CLASSID and target.RaceType ~= 'Item' then
        local buffDamage = GetBuffArgs(buff);
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        TakeDadak(self, target, "None", math.floor(buffDamage), 0.15 , "Melee", "Magic", "TrueDamage", HIT_MAGIC, HITRESULT_BLOW);
        EndSyncPacket(self, key, 0);
    end

    return 1;
end


function SCR_BUFF_GIVEDMG_UC_Cloaking_Buff(self, buff, sklID, damage, target, ret)
    if damage > 0 then
        return 0;
    end

    return 1;
end

function SCR_BUFF_GIVEDMG_Daino_Buff(self, buff, sklID, damage, target, ret)
    if IsBuffApplied(self, 'Daino_Buff') == 'YES' then
    	if IsNormalSKillBySkillID(self, sklID) == 1 and sklID ~= 100 then
	    	if damage == 0 then
	    		return 1;
	    	end
	    	
	    	local abil_Kriwi21 = GetAbility(self, "Kriwi21");
	    	if abil_Kriwi21 ~= nil and abil_Kriwi21.ActiveState == 1 then
		        local skill = GetClassByType("Skill", sklID);
		        if skill == nil then
		            return 1;
		        end
		        
		        local dainoSkill = GetSkill(self, "Kriwi_Daino")
		        if dainoSkill == nil then
		        	return 1
		        end
		        
		        if skill.ClassName == dainoSkill.ClassName then
		            return 1;
		        end
				
		        TakeDadak(self, target, dainoSkill.ClassName, damage, 0.25, "Melee", "Magic", "TrueDamage")
		    end
	    end
    end
    
	return 1
end

function SCR_BUFF_TAKEDMG_Raid_Velcofer_Curse_Debuff(self, buff, sklID, damage, attacker, ret)
    if damage <= 0 then
        return 1;
    end
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 1;
    end
    
    if IsBuffApplied(self, 'Raid_Velcofer_Curse_Debuff') == 'NO' then
        return 1;
    end 
       
    local buffOver = GetBuffOver(self, 'Raid_Velcofer_Curse_Debuff')
    if buffOver < 3 then
        return 1;
    end
        
    local attackerSkill = GetClassByType("Skill", sklID)
    if attackerSkill.ClassName ~= 'Default' then
        local key = GetSkillSyncKey(self, ret);
        StartSyncPacket(self, key);
        TakeDadak(caster, self, 'None', 999, 0.15 , 'Dark', 'None', 'TrueDamage', HIT_DARK, HITRESULT_NO_HITSCP);
        EndSyncPacket(self, key, 0);
        return 1;
    end
    return 1;
end

function SCR_BUFF_GIVEDMG_Kraujas_Buff(self, buff, sklID, damage, target, ret)
    if IsBuffApplied(self, "Kraujas_Buff") == "YES" then
        local buffRemainTime = GetBuffRemainTime(buff);
        if buffRemainTime > 1000 then
            AddBuff(self, self, "Kraujas_Buff", 1, 0, buffRemainTime, 1);
        end
    end
    return 1;
end