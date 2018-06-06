function SCR_BUFF_ENTER_EVENT_1805_CHILDREN(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM + 4;
	self.SR_BM = self.SR_BM + 1;
end

function SCR_BUFF_UPDATE_EVENT_1805_CHILDREN(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1805_CHILDREN(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM - 4;
    self.SR_BM = self.SR_BM - 1;
end

function SCR_BUFF_UPDATE_REMAINTIME_IES_APPLYTIME_SET(self, buff, RemainTime)
    local buffIES = GetClass('Buff', buff.ClassName)
    if RemainTime > buffIES.ApplyTime then
        SetBuffRemainTime(self, buff.ClassName, buffIES.ApplyTime)
    end
end

-- Safe
function SCR_BUFF_ENTER_Safe(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Safe(self, buff, arg1, arg2, over)

end

-- ItemDEFUP
function SCR_BUFF_ENTER_ItemDEFUP(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + arg1;

end

function SCR_BUFF_LEAVE_ItemDEFUP(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM - arg1;

end

-- ItemSTRUP
function SCR_BUFF_ENTER_ItemSTRUP(self, buff, arg1, arg2, over)

    self.STR_BM = self.STR_BM + arg1;

end

function SCR_BUFF_LEAVE_ItemSTRUP(self, buff, arg1, arg2, over)

    self.STR_BM = self.STR_BM - arg1;

end

-- ItemCONUP
function SCR_BUFF_ENTER_ItemCONUP(self, buff, arg1, arg2, over)

    self.CON_BM = self.CON_BM + arg1;

end

function SCR_BUFF_LEAVE_ItemCONUP(self, buff, arg1, arg2, over)

    self.CON_BM = self.CON_BM - arg1;

end

-- ItemAGIUP
function SCR_BUFF_ENTER_ItemAGIUP(self, buff, arg1, arg2, over)

    self.DEX_BM = self.DEX_BM + arg1;

end

function SCR_BUFF_LEAVE_ItemAGIUP(self, buff, arg1, arg2, over)

    self.DEX_BM = self.DEX_BM - arg1;

end

-- ItemINTUP
function SCR_BUFF_ENTER_ItemINTUP(self, buff, arg1, arg2, over)

    self.INT_BM = self.INT_BM + arg1;

end

function SCR_BUFF_LEAVE_ItemINTUP(self, buff, arg1, arg2, over)

    self.INT_BM = self.INT_BM - arg1;

end


function SCR_BUFF_ENTER_HealSP1(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_HealSP1(self, buff, arg1, arg2, RemainTime, ret, over)

    local heal = 10
    HealSP(self, heal, 0);

    return 1;

end

function SCR_BUFF_LEAVE_HealSP1(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Drug_Haste(self, buff, arg1, arg2, over)
    
    self.MSPD_BM = self.MSPD_BM + arg1;

end

function SCR_BUFF_LEAVE_Drug_Haste(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM - arg1;

end


-- Buff RedOx
function SCR_BUFF_ENTER_Drug_RedOx(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Drug_RedOx(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_RedOx(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Drug_HealHP_Dot(self, buff, arg1, arg2, over)
    local healHp = arg1 * 7;
    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end
    
    if self.HPPotion_BM > 0 then 
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    Heal(self, healHp, 0);
end

function SCR_BUFF_UPDATE_Drug_HealHP_Dot(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end

    if self.HPPotion_BM > 0 then
        arg1 = math.floor(arg1 * (1 + self.HPPotion_BM/100));
    end

    Heal(self, arg1, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_HealHP_Dot(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Drug_HealSP_Dot(self, buff, arg1, arg2, over)
    local healSp = arg1 * 7;
    
    if self.SPPotion_BM > 0 then
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end
    HealSP(self, healSp, 0);
end

function SCR_BUFF_UPDATE_Drug_HealSP_Dot(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.SPPotion_BM > 0 then
        arg1 = math.floor(arg1 * (1 + self.SPPotion_BM/100));
    end
    HealSP(self, arg1, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_HealSP_Dot(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Drug_HealSP(self, buff, arg1, arg2, over)
    local healSp = arg1 * 7;
    
    if self.SPPotion_BM > 0 then
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end
    HealSP(self, healSp, 0);
end

function SCR_BUFF_UPDATE_Drug_HealSP(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.SPPotion_BM > 0 then
        arg1 = math.floor(arg1 * (1 + self.SPPotion_BM/100));
    end
    HealSP(self, arg1, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_HealSP(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Drug_HealHP(self, buff, arg1, arg2, over)
    local healHp = arg1 * 7;
    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end
    
    if self.HPPotion_BM > 0 then 
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    Heal(self, healHp, 0);
end

function SCR_BUFF_UPDATE_Drug_HealHP(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end

    if self.HPPotion_BM > 0 then
        arg1 = math.floor(arg1 * (1 + self.HPPotion_BM/100));
    end

    Heal(self, arg1, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_HealHP(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Drug_HealHPSP_Dot(self, buff, arg1, arg2, over)
    local healHp = arg1;
    local healSp = arg1;

    if self.HPPotion_BM > 0 then
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    if self.SPPotion_BM > 0 then 
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end

    Heal(self, healHp, 0);
    HealSP(self, healSp, 0);
end

function SCR_BUFF_UPDATE_Drug_HealHPSP_Dot(self, buff, arg1, arg2, RemainTime, ret, over)
    local healHp = arg1;
    local healSp = arg1;

    if self.HPPotion_BM > 0 then
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    if self.SPPotion_BM > 0 then 
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end

    Heal(self, healHp, 0);
    HealSP(self, healSp, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_HealHPSP_Dot(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_item_set_007_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_007_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_item_set_035_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_035_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_item_set_011pre_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_011pre_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_item_set_011_buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_set_011_buff');
    self.Velnias_Atk_BM = self.Velnias_Atk_BM + 157;
end

function SCR_BUFF_LEAVE_item_set_011_buff(self, buff, arg1, arg2, over)
    self.Velnias_Atk_BM = self.Velnias_Atk_BM - 157;
end


function SCR_BUFF_ENTER_campfire_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_campfire_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

----old script, not use----
--    local list, cnt = SelectObjectByClassName(self, 30, 'bonfire_1')
--    if cnt < 1 then
--        RemoveBuff(self, buff.ClassName)
--    end
--    
--    local addRhp = self.RHP * 0.5;
--    Heal(self, addRhp, 0);
--    local addRsp = self.RSP * 0.5;
--    HealSP(self, addRsp, 0);
--    local addRsta = self.Sta_Recover;
--    AddStamina(self, addRsta);
--
--  return 1;
    
    local list, cnt = SelectObject(self, 45, 'ALL', 1)
    if cnt >= 1 then
        local i
        for i = 1, cnt do
--            if IS_PC(list[i]) == false then
            if list[i].ClassName ~= 'PC' then
                if list[i].ClassName == 'bonfire_1' then
                    local addRhp = self.RHP * 0.5;
                    Heal(self, addRhp, 0);
                    local addRsp = self.RSP * 0.5;
                    HealSP(self, addRsp, 0);
                    local addRsta = self.Sta_Recover;
                    AddStamina(self, addRsta);
                    return 1;
                end
            end
        end
    end
    return 0;
end


function SCR_BUFF_LEAVE_campfire_Buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_SHD03_104_Buff(self, buff, arg1, arg2, over)
    Heal(self, 40, 0);
end

function SCR_BUFF_UPDATE_SHD03_104_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    Heal(self, 40, 0);
    return 1;

end

function SCR_BUFF_LEAVE_SHD03_104_Buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_Drug_CooltimeDown(self, buff, arg1, arg2, over)
    local clsList, cnt = GetClassList('CoolDown');
    if nil == clsList then
        return;
    end

    for i = 0, cnt - 1 do
        local pCls = GetClassByIndexFromList(clsList, i)
        local cooldown = GetCoolDown(self, pCls.ClassName);
        if 0 < cooldown then
            if TryGetProp(pCls, "ForceReset") ~= "NO" then
                AddCoolDown(self, pCls.ClassName, -cooldown);
            end
        end
    end
end

function SCR_BUFF_LEAVE_Drug_CooltimeDown(self, buff, arg1, arg2, over)

end


-- salad buff
function SCR_BUFF_ENTER_squire_food1_buff(self, buff, arg1, arg2, over)
	local selfMHP = TryGetProp(self, "MHP") - TryGetProp(self, "MHP_BM")
    local addMhp = self.MHP * (0.075 + arg1 * 0.025);
    addMhp = math.floor(addMhp);
    SetExProp(buff, "SQUIRE_FOOD_ADD_MHP", addMhp);
    self.MHP_BM = self.MHP_BM + addMhp;
end

function SCR_BUFF_LEAVE_squire_food1_buff(self, buff, arg1, arg2, over)
    local addMhp = GetExProp(buff, "SQUIRE_FOOD_ADD_MHP");
    self.MHP_BM = self.MHP_BM - addMhp;
end


-- sandwich buff
function SCR_BUFF_ENTER_squire_food2_buff(self, buff, arg1, arg2, over)
	local selfMSP = TryGetProp(self, "MSP") - TryGetProp(self, "MSP_BM")
    local addMsp = selfMSP * (0.075 + arg1 * 0.025);
    addMsp = math.floor(addMsp);
    SetExProp(buff, "SQUIRE_FOOD_ADD_MSP", addMsp);
    self.MSP_BM = self.MSP_BM + addMsp;
end

function SCR_BUFF_LEAVE_squire_food2_buff(self, buff, arg1, arg2, over)
    local addMsp = GetExProp(buff, "SQUIRE_FOOD_ADD_MSP");
    self.MSP_BM = self.MSP_BM - addMsp;
end


-- soup buff
function SCR_BUFF_ENTER_squire_food3_buff(self, buff, arg1, arg2, over)
    local addRhptime = arg1 * 1000;
    SetExProp(buff, "SQUIRE_FOOD_ADD_RHPTIME", addRhptime);
    self.RHPTIME_BM = self.RHPTIME_BM + addRhptime;
end

function SCR_BUFF_LEAVE_squire_food3_buff(self, buff, arg1, arg2, over)
    local addRhptime = GetExProp(buff, "SQUIRE_FOOD_ADD_RHPTIME");
    self.RHPTIME_BM = self.RHPTIME_BM - addRhptime;
end


-- yogurt buff
function SCR_BUFF_ENTER_squire_food4_buff(self, buff, arg1, arg2, over)
    local addRsptime = arg1 * 1000;
    SetExProp(buff, "SQUIRE_FOOD_ADD_RSPTIME", addRsptime);
    self.RSPTIME_BM = self.RSPTIME_BM + addRsptime;
end

function SCR_BUFF_LEAVE_squire_food4_buff(self, buff, arg1, arg2, over)
    local addRsptime = GetExProp(buff, "SQUIRE_FOOD_ADD_RSPTIME");
    self.RSPTIME_BM = self.RSPTIME_BM - addRsptime;
end

-- BBQ buff
function SCR_BUFF_ENTER_squire_food5_buff(self, buff, arg1, arg2, over)
    local addSr = 0.5 + (arg1 - 5) * 0.5;
    addSr = math.floor(addSr);
    SetExProp(buff, "SQUIRE_FOOD_ADD_SR", addSr);
    self.SR_BM = self.SR_BM + addSr;
end

function SCR_BUFF_LEAVE_squire_food5_buff(self, buff, arg1, arg2, over)
    local addSr = GetExProp(buff, "SQUIRE_FOOD_ADD_SR");
    self.SR_BM = self.SR_BM - addSr;
end

-- champagne buff
function SCR_BUFF_ENTER_squire_food6_buff(self, buff, arg1, arg2, over)
    local addSdr = 0.5 + (arg1 - 5) * 0.5;
    addSdr = math.floor(addSdr);
    SetExProp(buff, "SQUIRE_FOOD_ADD_SDR", addSdr);
    self.SDR_BM = self.SDR_BM + addSdr;
end

function SCR_BUFF_LEAVE_squire_food6_buff(self, buff, arg1, arg2, over)
    local addSdr = GetExProp(buff, "SQUIRE_FOOD_ADD_SDR");
    self.SDR_BM = self.SDR_BM - addSdr;
end

function SCR_BUFF_ENTER_cosair_scanable_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_cosair_scanable_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_subweapon_metaldetector(self, buff, arg1, arg2, over)
    local x, y, z = GetPos(self);
    local fndList, fndCount = SelectObjectPos(self, x, y, z, 60, 'ALL');
    for i = 1, fndCount do
        local obj = fndList[i];
        if obj.ClassName == "Skl_ScanTrigger" then
            local genID = GetGenTypeID(obj)
            local npcState = GetMapNPCState(self, genID)
            if npcState >= 0 then
                RunScript('SCR_SCOUT_SCAN_TX', self, obj, genID)
            end
        end
    end
end

function SCR_BUFF_LEAVE_subweapon_metaldetector(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_subweapon_dumbbell(self, buff, arg1, arg2, over)
    local addStr = 3 * over;
    local addSta = 2 * over;
    
    if IsBuffApplied(self, 'SwellRightArm_Buff') == 'YES' then
        addSta = addSta * 0.5;
    end
    
    SetExProp(buff, "DUMBBELL_ADDSTR", addStr);
    SetExProp(buff, "DUMBBELL_ADDSTA", addSta);
    
    self.STR_BM = self.STR_BM + addStr;
    self.MaxSta_BM = self.MaxSta_BM - addSta; 
end

function SCR_BUFF_LEAVE_subweapon_dumbbell(self, buff, arg1, arg2, over)
    local addStr = GetExProp(buff, "DUMBBELL_ADDSTR");
    local addSta = GetExProp(buff, "DUMBBELL_ADDSTA");
    
    self.STR_BM = self.STR_BM - addStr;
    self.MaxSta_BM = self.MaxSta_BM + addSta;
end


function SCR_BUFF_ENTER_item_cmine_red_buff(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 20;
    self.MATK_BM = self.MATK_BM + 20;
end

function SCR_BUFF_LEAVE_item_cmine_red_buff(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 20;
    self.MATK_BM = self.MATK_BM - 20;
end


function SCR_BUFF_ENTER_item_cmine_blue_buff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 8;
    self.MDEF_BM = self.MDEF_BM + 8;
end

function SCR_BUFF_LEAVE_item_cmine_blue_buff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 8;
    self.MDEF_BM = self.MDEF_BM - 8;
end


function SCR_BUFF_ENTER_item_cmine_yellow_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_item_cmine_yellow_buff(self, buff, arg1, arg2, over)
    AddStamina(self, 99999);
    return 1;
end

function SCR_BUFF_LEAVE_item_cmine_yellow_buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_item_toyhammer_debuff(self, buff, arg1, arg2, over)

    if self.ClassName == 'PC' then
        return 0;
    end
 
end

function SCR_BUFF_UPDATE_item_toyhammer_debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.ClassName == 'PC' then
        return 0;
    end
    if over == 10 then
        return 0;
    end
    return 1;
end

function SCR_BUFF_LEAVE_item_toyhammer_debuff(self, buff, arg1, arg2, over)
    if over > 9 then
        PlayEffect(self, "F_archer_explosiontrap_hit_explosion", 1, 1, 'BOT')
        
        local caster = GetBuffCaster(buff);
        local bombDamage = math.floor((caster.MINPATK + caster.MAXPATK) / IMCRandomFloat(2, 2.5)) * 5;
        local bombRange = 30;
        
        local objList, objCount = SelectObjectNear(caster, self, bombRange, 'ENEMY');
        for i = 1, objCount do
            local obj = objList[i];
            TakeDamage(caster, obj, "None", bombDamage, "Melee", "None", "Melee", HIT_BASIC, HITRESULT_BLOW);
            RemoveBuff(obj, "item_toyhammer_debuff");
            break;
        end
    end 
end


function SCR_BUFF_ENTER_item_set_013pre_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_013pre_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_item_set_013_buff(self, buff, arg1, arg2, over)
    SetExProp(buff, "set_013_buff_over", over);
end

function SCR_BUFF_LEAVE_item_set_013_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_item_shovel_buff(self, buff, arg1, arg2, over)
    local item = GetMaterialItem(self);
    CREATE_DROP_ITEM(self, item, self);
    AddAchievePoint(self, "Shovel", 1);
end

function SCR_BUFF_LEAVE_item_shovel_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_item_set_016pre_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_016pre_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_item_set_016_buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_set_016_buff');
    HealSP(self, 40, 0);
end

function SCR_BUFF_UPDATE_item_set_016_buff(self, buff, arg1, arg2, over)
    HealSP(self, 40, 0);
    return 1;
end

function SCR_BUFF_LEAVE_item_set_016_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_Drug_BLK(self, buff, arg1, arg2, over)
    self.BLK_BM = self.BLK_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_BLK(self, buff, arg1, arg2, over)
    self.BLK_BM = self.BLK_BM - arg1
end


function SCR_BUFF_ENTER_Drug_CRTATK(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_CRTATK(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM - arg1
end


function SCR_BUFF_ENTER_Drug_MHR(self, buff, arg1, arg2, over)
    self.MHR_BM = self.MHR_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_MHR(self, buff, arg1, arg2, over)
    self.MHR_BM = self.MHR_BM - arg1
end


function SCR_BUFF_ENTER_item_armorBreak(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - arg1
end

function SCR_BUFF_LEAVE_item_armorBreak(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + arg1
end


function SCR_BUFF_ENTER_drop_inceaseMoney(self, buff, arg1, arg2, over)
    SetExProp(buff, "MoneyCount", arg1);
    SetExProp(buff, "MoneyRatio", arg2);
end

function SCR_BUFF_LEAVE_drop_inceaseMoney(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_item_wizardSlayer(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_wizardSlayer');
    local addMdef = math.floor(self.Lv);
    self.MDEF_BM = self.MDEF_BM + addMdef;
    SetExProp(buff, "wizardSlayer", addMdef);
end

function SCR_BUFF_LEAVE_item_wizardSlayer(self, buff, arg1, arg2, over)
    local addMdef = GetExProp(buff, "wizardSlayer");
    self.MDEF_BM = self.MDEF_BM - addMdef;
end


function SCR_BUFF_ENTER_item_temere(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_temere');
    local value = math.floor(self.MDEF / 2);
    self.MDEF_BM = self.MDEF_BM - value;
    self.DEF_BM = self.DEF_BM + value;
    
    SetExProp(buff, "item_temere", value);
end

function SCR_BUFF_LEAVE_item_temere(self, buff, arg1, arg2, over)
    local value = GetExProp(buff, "item_temere");
    self.MDEF_BM = self.MDEF_BM + value;
    self.DEF_BM = self.DEF_BM - value;
end


function SCR_BUFF_ENTER_item_poison(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_poison');
end

function SCR_BUFF_UPDATE_item_poison(self, buff, arg1, arg2, over)
    TakeDamage(self, self, "None", arg1, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW, 0, 0);
    return 1;
end

function SCR_BUFF_LEAVE_item_poison(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_item_poison_fast(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_poison');
end

function SCR_BUFF_UPDATE_item_poison_fast(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
    caster = self;
    end
    TakeDamage(self, self, "None", arg1, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW, 0, 0);
    return 1;
end

function SCR_BUFF_LEAVE_item_poison_fast(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_item_laideka(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 15;
end

function SCR_BUFF_LEAVE_item_laideka(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 15;
end


function SCR_BUFF_ENTER_item_electricShock(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_electricShock');
end

function SCR_BUFF_UPDATE_item_electricShock(self, buff, arg1, arg2, over)
    TakeDamage(self, self, "None", arg1, "Lightning", "Magic", "Magic", HIT_LIGHTNING, HITRESULT_BLOW, 0, 0);
    return 1;
end

function SCR_BUFF_LEAVE_item_electricShock(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_item_magicAmulet_1(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_magicAmulet_1');
    local addDef = math.floor(self.DEF / 2);
    local addMdef = math.floor(self.MDEF / 2);
    self.DEF_BM = self.DEF_BM - addDef;
    self.MDEF_BM = self.MDEF_BM - addMdef;
    SetExProp(buff, "magicAmulet_1_DEF", addDef);
    SetExProp(buff, "magicAmulet_1_MDEF", addMdef);
end

function SCR_BUFF_LEAVE_item_magicAmulet_1(self, buff, arg1, arg2, over)
    local addDef = GetExProp(buff, "magicAmulet_1_DEF");
    local addMdef = GetExProp(buff, "magicAmulet_1_MDEF");
    self.DEF_BM = self.DEF_BM + addDef;
    self.MDEF_BM = self.MDEF_BM + addMdef;
end


function SCR_BUFF_ENTER_item_magicAmulet_4(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_magicAmulet_4');
    Heal(self, arg1, 0);
end

function SCR_BUFF_UPDATE_item_magicAmulet_4(self, buff, arg1, arg2, over)
    Heal(self, arg1, 0);
    return 1;
end

function SCR_BUFF_LEAVE_item_magicAmulet_4(self, buff, arg1, arg2, over)
    
end


function SCR_BUFF_ENTER_item_magicAmulet_3(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_magicAmulet_3');
    
    local sp = self.SP - arg1;
    
    if sp < 0 then
        self.SP = 0;
    else
        self.SP = sp;
    end
end

function SCR_BUFF_LEAVE_item_magicAmulet_3(self, buff, arg1, arg2, over)
    
end


function SCR_BUFF_ENTER_item_magicAmulet_2(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_magicAmulet_2');
end

function SCR_BUFF_LEAVE_item_magicAmulet_2(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_item_linne(self, buff, arg1, arg2, over)
    if over >= 15 then
        SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_linne');
        GIVE_REWARD(self, "ITEM_LINNE", "Drop");
        RemoveBuff(self, 'item_linne');
    end
end

function SCR_BUFF_LEAVE_item_linne(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_item_cicel(self, buff, arg1, arg2, over)
    if over >= 8 then
        SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_cicel2');
        AddBuff(self, self, 'item_cicel2', 1, 0, 30000, 1);
        RemoveBuff(self, 'item_cicel');
    end
end

function SCR_BUFF_LEAVE_item_cicel(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_item_cicel2(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 235;
    self.MSPD_BM = self.MSPD_BM + 10;
    self.DEF_BM = self.DEF_BM - 88;
end

function SCR_BUFF_UPDATE_item_cicel2(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'item_cicel');
    return 1;
end

function SCR_BUFF_LEAVE_item_cicel2(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 235;
    self.MSPD_BM = self.MSPD_BM - 10;
    self.DEF_BM = self.DEF_BM + 88;
end


function SCR_BUFF_ENTER_item_effigyCount(self, buff, arg1, arg2, over)
    SetExProp(self, 'effigyCount_Bonus', arg1);
end

function SCR_BUFF_LEAVE_item_effigyCount(self, buff, arg1, arg2, over)
    DelExProp(self, 'effigyCount_Bonus');
end


function SCR_BUFF_ENTER_item_set_019_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_item_set_019_buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Drug_SR(self, buff, arg1, arg2, over)
    self.SR_BM = self.SR_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_SR(self, buff, arg1, arg2, over)
    self.SR_BM = self.SR_BM - arg1
end

function SCR_BUFF_ENTER_SummonOrb_debuff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_SummonOrb_debuff(self, buff, arg1, arg2, over)
    Dead(self)
end


function SCR_BUFF_ENTER_item_GMboots(self, buff, arg1, arg2, over)
    self.MSPD_Bonus = self.MSPD_Bonus + 100;
end

function SCR_BUFF_LEAVE_item_GMboots(self, buff, arg1, arg2, over)
    self.MSPD_Bonus = self.MSPD_Bonus - 100;
end


function SCR_BUFF_ENTER_item_NECK04_103(self, buff, arg1, arg2, over)
    local curRhp = self.RHP - self.RHP_BM;
    SetExProp(self, "RHP_NECK04_103", curRhp);
    
    local addMhr = math.floor(curRhp * 0.4);
    SetExProp(self, "MHR_NECK04_103", addMhr);

    self.RHP_BM = self.RHP_BM - curRhp;
    self.MHR_BM = self.MHR_BM + addMhr;
end

function SCR_BUFF_LEAVE_item_NECK04_103(self, buff, arg1, arg2, over)
    local addRhp = GetExProp(self, "RHP_NECK04_103");
    local addMhr = GetExProp(self, "MHR_NECK04_103");
    self.RHP_BM = self.RHP_BM + addRhp;
    self.MHR_BM = self.MHR_BM - addMhr;
end

function SCR_BUFF_ENTER_Premium_speedUp(self, buff, arg1, arg2, over)
    local addMspd = GetCashValue(self, "speedUp");
    self.MSPD_Bonus = self.MSPD_Bonus + addMspd;
end

function SCR_BUFF_LEAVE_Premium_speedUp(self, buff, arg1, arg2, over)
    local addMspd = GetCashValue(self, "speedUp");
    self.MSPD_Bonus = self.MSPD_Bonus - addMspd;
end

function SCR_BUFF_ENTER_Premium_Nexon(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM + 500;
end

function SCR_BUFF_LEAVE_Premium_Nexon(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM - 500;
end

function SCR_BUFF_ENTER_Premium_boostToken(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM + 500;
end

function SCR_BUFF_LEAVE_Premium_boostToken(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM - 500;
    
    if GetBuffRemainTime(buff) <= 0 then
        SendSysMsg(self, "Premium_boostToken_EndMsg"); -- ?????? ?? ???? ?????
        PremiumItemMongoLog(self, "BoostToken", "End", 0);
    end
end

--made up
function SCR_BUFF_ENTER_Premium_boostToken02(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM + 2000;
end

function SCR_BUFF_LEAVE_Premium_boostToken02(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM - 2000;
    
    if GetBuffRemainTime(buff) <= 0 then
        SendSysMsg(self, "Premium_boostToken_EndMsg"); -- ?????? ?? ???? ?????
        PremiumItemMongoLog(self, "BoostToken", "End", 0);
    end
end

function SCR_BUFF_ENTER_Premium_boostToken03(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM + 4000;
end

function SCR_BUFF_LEAVE_Premium_boostToken03(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM - 4000;

    if GetBuffRemainTime(buff) <= 0 then    
        SendSysMsg(self, "Premium_boostToken_EndMsg"); -- ?????? ?? ???? ?????
        PremiumItemMongoLog(self, "BoostToken", "End", 0);
    end
end

function SCR_BUFF_LEAVE_Premium_boostToken04(self, buff, arg1, arg2, over)
    self.RSta_BM = self.RSta_BM - 500;
    
    if GetBuffRemainTime(buff) <= 0 then
        SendSysMsg(self, "Premium_boostToken_EndMsg"); -- ?????? ?? ???? ?????
        PremiumItemMongoLog(self, "BoostToken", "End", 0);
    end
end

--made out

function SCR_BUFF_ENTER_Guild_Academy_buff(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM + 30;
end

function SCR_BUFF_LEAVE_Guild_Academy_buff(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM - 30;
end


function SCR_BUFF_ENTER_Guild_Forge_buff(self, buff, arg1, arg2, over)
    local addValue = over * 110;
    SetExProp(buff, "ADD_PATK_BM", addValue)
    self.PATK_BM = self.PATK_BM + addValue;
end

function SCR_BUFF_LEAVE_Guild_Forge_buff(self, buff, arg1, arg2, over)
    local addValue = GetExProp(buff, "ADD_PATK_BM");
    self.PATK_BM = self.PATK_BM - addValue;
end


function SCR_BUFF_TAKEDMG_Guild_ShieldCharger_buff(self, buff, sklID, damage, attacker)
    
    local shieldValue = GetShield(self);
    if shieldValue <= 0 then
        return 0;
    end
    
    SetBuffArg(self, buff, shieldValue, 0, 0);
    return 1;
end

function SCR_BUFF_ENTER_Drug_CRTHR(self, buff, arg1, arg2, over)
    self.CRTHR_BM = self.CRTHR_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_CRTHR(self, buff, arg1, arg2, over)
    self.CRTHR_BM = self.CRTHR_BM - arg1
end


function SCR_BUFF_ENTER_Drug_PATK(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_PATK(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - arg1
end


function SCR_BUFF_ENTER_Drug_ResFire(self, buff, arg1, arg2, over)
    self.ResFire_BM = self.ResFire_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_ResFire(self, buff, arg1, arg2, over)
    self.ResFire_BM = self.ResFire_BM - arg1
end


function SCR_BUFF_ENTER_Drug_ResIce(self, buff, arg1, arg2, over)
    self.ResIce_BM = self.ResIce_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_ResIce(self, buff, arg1, arg2, over)
    self.ResIce_BM = self.ResIce_BM - arg1
end


function SCR_BUFF_ENTER_Drug_ResPoison(self, buff, arg1, arg2, over)
    self.ResPoison_BM = self.ResPoison_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_ResPoison(self, buff, arg1, arg2, over)
    self.ResPoison_BM = self.ResPoison_BM - arg1
end


function SCR_BUFF_ENTER_Drug_ResEarth(self, buff, arg1, arg2, over)
    self.ResEarth_BM = self.ResEarth_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_ResEarth(self, buff, arg1, arg2, over)
    self.ResEarth_BM = self.ResEarth_BM - arg1
end

function SCR_BUFF_ENTER_Drug_ResLightning(self, buff, arg1, arg2, over)
    self.ResLightning_BM = self.ResLightning_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_ResLightning(self, buff, arg1, arg2, over)
    self.ResLightning_BM = self.ResLightning_BM - arg1
end


function SCR_BUFF_ENTER_Drug_MDEF(self, buff, arg1, arg2, over)
    self.MDEF_BM = self.MDEF_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_MDEF(self, buff, arg1, arg2, over)
    self.MDEF_BM = self.MDEF_BM - arg1
end


function SCR_BUFF_ENTER_Drug_MATK(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_MATK(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM - arg1
end


function SCR_BUFF_ENTER_item_set_024(self, buff, arg1, arg2, over)
    if over > 99 then
        AddBuff(self, self, 'item_set_024_active', 1, 0, 10000);
        RemoveBuff(self, 'item_set_024');
    end
end

function SCR_BUFF_LEAVE_item_set_024(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_item_set_024_active(self, buff, arg1, arg2, over)
    local addAtk = math.floor(self.MDEF * 0.08);
    SetExProp(buff, "ITEM_SET_024_ADDATK", addAtk);
    self.Holy_Atk_BM = self.Holy_Atk_BM + addAtk;
    self.Dark_Atk_BM = self.Dark_Atk_BM + addAtk;
end

function SCR_BUFF_UPDATE_item_set_024_active(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'item_set_024');
    return 1;
end

function SCR_BUFF_LEAVE_item_set_024_active(self, buff, arg1, arg2, over)
    local addAtk = GetExProp(buff, "ITEM_SET_024_ADDATK");
    self.Holy_Atk_BM = self.Holy_Atk_BM - addAtk;
    self.Dark_Atk_BM = self.Dark_Atk_BM - addAtk;
    AddBuff(self, self, 'item_set_024');
end


function SCR_BUFF_ENTER_item_NECK03_106(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 6 * over;
    self.MDEF_BM = self.MDEF_BM + 6 * over;
end

function SCR_BUFF_LEAVE_item_NECK03_106(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 6 * over;
    self.MDEF_BM = self.MDEF_BM - 6 * over;
end

function SCR_BUFF_ENTER_TSW03_111_Buff(self, buff, arg1, arg2, over)
    GIVE_BUFF_SHIELD(self, buff, 2380)
end

function SCR_BUFF_LEAVE_TSW03_111_Buff(self, buff, arg1, arg2, over)
   TAKE_BUFF_SHIELD(self, buff)
end


function SCR_BUFF_ENTER_SWD03_110_Buff(self, buff, arg1, arg2, over)

    if over > 4 then
        AddBuff(self, self, 'SWD03_110_active_Buff', 1, 0, 30000);
    end

end

function SCR_BUFF_LEAVE_SWD03_110_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_SWD03_110_active_Buff(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'SWD03_110_Buff')
end

function SCR_BUFF_LEAVE_SWD03_110_active_Buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_TSP03_106_Debuff(self, buff, arg1, arg2, over)

    if over > 9 then
        AddBuff(self, self, 'TSP03_106_Active_Debuff', 1, 0, 10000);
        RemoveBuff(self, 'TSP03_106_Debuff')
    end

    if GetObjType(self) == OT_PC then
        AddStamina(self, -1000);
    end
end

function SCR_BUFF_LEAVE_TSP03_106_Debuff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_TSP03_106_Active_Debuff(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 20;
end

function SCR_BUFF_LEAVE_TSP03_106_Active_Debuff(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 20;
end


function SCR_BUFF_ENTER_MAC03_110_Debuff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 84;
end

function SCR_BUFF_LEAVE_MAC03_110_Debuff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 84;
end


function SCR_BUFF_ENTER_item_EffigyBonus1_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_EffigyBonus1_buff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_TBW03_109_Debuff(self, buff, arg1, arg2, over)
    self.CRTDR_BM = self.CRTDR_BM - 8 * over;
end

function SCR_BUFF_LEAVE_TBW03_109_Debuff(self, buff, arg1, arg2, over)
    self.CRTDR_BM = self.CRTDR_BM + 8 * over;
end

function SCR_BUFF_ENTER_Premium_indunFreeEnter(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Premium_indunFreeEnter(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_MAC04_102_buff(self, buff, arg1, arg2, over)
    local jobObj = GetJobObject(self);
    if jobObj.CtrlType == 'Cleric' then
        self.Holy_Atk_BM = self.Holy_Atk_BM + 50;
    end

end

function SCR_BUFF_LEAVE_MAC04_102_buff(self, buff, arg1, arg2, over)
    local jobObj = GetJobObject(self);
    if jobObj.CtrlType == 'Cleric' then
        self.Holy_Atk_BM = self.Holy_Atk_BM - 50;
    end
end


function SCR_BUFF_ENTER_Drug_AriesAtk_PC(self, buff, arg1, arg2, over)
    self.AriesAtkFactor_PC_BM = self.AriesAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_AriesAtk_PC(self, buff, arg1, arg2, over)
    self.AriesAtkFactor_PC_BM = self.AriesAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_SlashAtk_PC(self, buff, arg1, arg2, over)
    self.SlashAtkFactor_PC_BM = self.SlashAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_SlashAtk_PC(self, buff, arg1, arg2, over)
    self.SlashAtkFactor_PC_BM = self.SlashAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_StrikeAtk_PC(self, buff, arg1, arg2, over)
    self.StrikeAtkFactor_PC_BM = self.StrikeAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_StrikeAtk_PC(self, buff, arg1, arg2, over)
    self.StrikeAtkFactor_PC_BM = self.StrikeAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_MissileAtk_PC(self, buff, arg1, arg2, over)
    self.MissileAtkFactor_PC_BM = self.MissileAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_MissileAtk_PC(self, buff, arg1, arg2, over)
    self.MissileAtkFactor_PC_BM = self.MissileAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_FireAtk_PC(self, buff, arg1, arg2, over)
    self.FireAtkFactor_PC_BM = self.FireAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_FireAtk_PC(self, buff, arg1, arg2, over)
    self.FireAtkFactor_PC_BM = self.FireAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_IceAtk_PC(self, buff, arg1, arg2, over)
    self.IceAtkFactor_PC_BM = self.IceAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_IceAtk_PC(self, buff, arg1, arg2, over)
    self.IceAtkFactor_PC_BM = self.IceAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_PoisonAtk_PC(self, buff, arg1, arg2, over)
    self.PoisonAtkFactor_PC_BM = self.PoisonAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_PoisonAtk_PC(self, buff, arg1, arg2, over)
    self.PoisonAtkFactor_PC_BM = self.PoisonAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_LightningAtk_PC(self, buff, arg1, arg2, over)
    self.LightningAtkFactor_PC_BM = self.LightningAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_LightningAtk_PC(self, buff, arg1, arg2, over)
    self.LightningAtkFactor_PC_BM = self.LightningAtkFactor_PC_BM - over * (arg1 / 100);
end

function SCR_BUFF_ENTER_Drug_EarthAtk_PC(self, buff, arg1, arg2, over)
    self.EarthAtkFactor_PC_BM = self.EarthAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_EarthAtk_PC(self, buff, arg1, arg2, over)
    self.EarthAtkFactor_PC_BM = self.EarthAtkFactor_PC_BM - over * (arg1 / 100);
end

function SCR_BUFF_ENTER_Drug_HolyAtk_PC(self, buff, arg1, arg2, over)
    self.HolyAtkFactor_PC_BM = self.HolyAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_HolyAtk_PC(self, buff, arg1, arg2, over)
    self.HolyAtkFactor_PC_BM = self.HolyAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_DarkAtk_PC(self, buff, arg1, arg2, over)
    self.DarkAtkFactor_PC_BM = self.DarkAtkFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_DarkAtk_PC(self, buff, arg1, arg2, over)
    self.DarkAtkFactor_PC_BM = self.DarkAtkFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_AriesDef_PC(self, buff, arg1, arg2, over)
    self.AriesDefFactor_PC_BM = self.AriesDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_AriesDef_PC(self, buff, arg1, arg2, over)
    self.AriesDefFactor_PC_BM = self.AriesDefFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_SlashDef_PC(self, buff, arg1, arg2, over)
    self.SlashDefFactor_PC_BM = self.SlashDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_SlashDef_PC(self, buff, arg1, arg2, over)
    self.SlashDefFactor_PC_BM = self.SlashDefFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_StrikeDef_PC(self, buff, arg1, arg2, over)
    self.StrikeDefFactor_PC_BM = self.StrikeDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_StrikeDef_PC(self, buff, arg1, arg2, over)
    self.StrikeDefFactor_PC_BM = self.StrikeDefFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_MissileDef_PC(self, buff, arg1, arg2, over)
    self.MissileDefFactor_PC_BM = self.MissileDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_MissileDef_PC(self, buff, arg1, arg2, over)
    self.MissileDefFactor_PC_BM = self.MissileDefFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_FireDef_PC(self, buff, arg1, arg2, over)
    self.FireDefFactor_PC_BM = self.FireDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_FireDef_PC(self, buff, arg1, arg2, over)
    self.FireDefFactor_PC_BM = self.FireDefFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_IceDef_PC(self, buff, arg1, arg2, over)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_IceDef_PC(self, buff, arg1, arg2, over)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_PoisonDef_PC(self, buff, arg1, arg2, over)
    self.PoisonDefFactor_PC_BM = self.PoisonDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_PoisonDef_PC(self, buff, arg1, arg2, over)
    self.PoisonDefFactor_PC_BM = self.PoisonDefFactor_PC_BM - over * (arg1 / 100);
end


function SCR_BUFF_ENTER_Drug_LightningDef_PC(self, buff, arg1, arg2, over)
    self.LightningDefFactor_PC_BM = self.LightningDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_LightningDef_PC(self, buff, arg1, arg2, over)
    self.LightningDefFactor_PC_BM = self.LightningDefFactor_PC_BM - over * (arg1 / 100);
end

function SCR_BUFF_ENTER_Drug_EarthDef_PC(self, buff, arg1, arg2, over)
    self.EarthDefFactor_PC_BM = self.EarthDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_EarthDef_PC(self, buff, arg1, arg2, over)
    self.EarthDefFactor_PC_BM = self.EarthDefFactor_PC_BM - over * (arg1 / 100);
end

function SCR_BUFF_ENTER_Drug_HolyDef_PC(self, buff, arg1, arg2, over)
    self.HolyDefFactor_PC_BM = self.HolyDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_HolyDef_PC(self, buff, arg1, arg2, over)
    self.HolyDefFactor_PC_BM = self.HolyDefFactor_PC_BM - over * (arg1 / 100);
end

function SCR_BUFF_ENTER_Drug_DarkDef_PC(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM + over * (arg1 / 100);
end

function SCR_BUFF_LEAVE_Drug_DarkDef_PC(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM - over * (arg1 / 100);
end

function SCR_BUFF_ENTER_Drug_Event160218_Buff(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
    self.PATK_BM = self.PATK_BM + 50;
    self.MATK_BM = self.MATK_BM + 50;
end

function SCR_BUFF_LEAVE_Drug_Event160218_Buff(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
    self.PATK_BM = self.PATK_BM - 50;
    self.MATK_BM = self.MATK_BM - 50;
end


function SCR_BUFF_ENTER_Event_1709_NewField_Coupon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
    self.PATK_BM = self.PATK_BM + 50;
    self.MATK_BM = self.MATK_BM + 50;
end

function SCR_BUFF_UPDATE_Event_1709_NewField_Coupon(self, buff, arg1, arg2, RemainTime, ret, over)
    SCR_BUFF_UPDATE_REMAINTIME_IES_APPLYTIME_SET(self, buff, RemainTime)
    return 1
end

function SCR_BUFF_LEAVE_Event_1709_NewField_Coupon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
    self.PATK_BM = self.PATK_BM - 50;
    self.MATK_BM = self.MATK_BM - 50;
end


-- Event_1709_NewField_Potion_Buff
function SCR_BUFF_ENTER_Event_1709_NewField_Potion_Buff(self, buff, arg1, arg2, over)
    local mspdadd = 3
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    SetExProp(buff, "ADD_MSPD_Event_1709_NewField_Potion_Buff", mspdadd);
end

function SCR_BUFF_UPDATE_Event_1709_NewField_Potion_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    SCR_BUFF_UPDATE_REMAINTIME_IES_APPLYTIME_SET(self, buff, RemainTime)
    return 1
end

function SCR_BUFF_LEAVE_Event_1709_NewField_Potion_Buff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD_Event_1709_NewField_Potion_Buff");
    self.MSPD_BM = self.MSPD_BM - mspdadd;
end

-- EVENT_1712_XMAS_FIRE
function SCR_BUFF_ENTER_EVENT_1712_XMAS_FIRE(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_EVENT_1712_XMAS_FIRE(self, buff, arg1, arg2, RemainTime, ret, over)
    SCR_BUFF_UPDATE_REMAINTIME_IES_APPLYTIME_SET(self, buff, RemainTime)
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1712_XMAS_FIRE(self, buff, arg1, arg2, over)
end

-- magicAmulet_22 buff
function SCR_BUFF_ENTER_Item_magicAmulet_22_Buff(self, buff, arg1, arg2, over)
    self.MHR_BM = self.MHR_BM + 152
end

function SCR_BUFF_LEAVE_Item_magicAmulet_22_Buff(self, buff, arg1, arg2, over)
    self.MHR_BM = self.MHR_BM - 152
end

-- magicAmulet_23 Debuf
function SCR_BUFF_ENTER_Item_magicAmulet_23_Buff(self, buff, arg1, arg2, over)

    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
   
    local defadd = self.DEF * 0.5
    self.DEF_BM = self.DEF_BM - defadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    
end

function SCR_BUFF_LEAVE_Item_magicAmulet_23_Buff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    self.DEF_BM = self.DEF_BM + defadd;
    Invalidate(self, "DEF");
end

-- gimmick def potion
function SCR_BUFF_ENTER_Drug_Whole_DEF(self, buff, arg1, arg2, over)
    self.MDEF_BM = self.MDEF_BM + arg1;
    self.DEF_BM = self.DEF_BM + arg1;
end

function SCR_BUFF_LEAVE_Drug_Whole_DEF(self, buff, arg1, arg2, over)
    self.MDEF_BM = self.MDEF_BM - arg1;
    self.DEF_BM = self.DEF_BM - arg1;
end

-- gimmick atk potion
function SCR_BUFF_ENTER_Drug_Whole_ATK(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM + arg1;
    self.PATK_BM = self.PATK_BM + arg1;
end

function SCR_BUFF_LEAVE_Drug_Whole_ATK(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM - arg1;
    self.PATK_BM = self.PATK_BM - arg1;
end

function SCR_BUFF_ENTER_pet_penguin_buff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 30;
    self.MDEF_BM = self.MDEF_BM + 30;
end

function SCR_BUFF_LEAVE_pet_penguin_buff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 30;
    self.MDEF_BM = self.MDEF_BM - 30;
end

function SCR_BUFF_ENTER_pet_parrotbill_buff(self, buff, arg1, arg2, over)
    self.RSP_BM = self.RSP_BM + 114;
    self.RHP_BM = self.RHP_BM + 85;
end

function SCR_BUFF_LEAVE_pet_parrotbill_buff(self, buff, arg1, arg2, over)
    self.RSP_BM = self.RSP_BM - 114;
    self.RHP_BM = self.RHP_BM - 85;
end

function SCR_BUFF_ENTER_pet_Lesserpanda_buff(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM + 25
    self.CRTHR_BM = self.CRTHR_BM + 5
end

function SCR_BUFF_LEAVE_pet_Lesserpanda_buff(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM - 25
    self.CRTHR_BM = self.CRTHR_BM - 5
end

function SCR_BUFF_ENTER_pet_rocksodon_buff(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM + 600;
    self.MSP_BM = self.MSP_BM + 400;
end

function SCR_BUFF_LEAVE_pet_rocksodon_buff(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM - 600;
    self.MSP_BM = self.MSP_BM - 400;
end

function SCR_BUFF_ENTER_pet_PetHanaming_buff(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
    self.Forester_Atk_BM = self.Forester_Atk_BM + 50;
end

function SCR_BUFF_LEAVE_pet_PetHanaming_buff(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
    self.Forester_Atk_BM = self.Forester_Atk_BM - 50;
end

function SCR_BUFF_ENTER_NECK01_145_buff(self, buff, arg1, arg2)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM + 0.25;
end

function SCR_BUFF_LEAVE_NECK01_145_buff(self, buff, arg1, arg2)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM - 0.25;
end

function SCR_BUFF_ENTER_NECK01_146_buff(self, buff, arg1, arg2)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM + 0.05;
end

function SCR_BUFF_LEAVE_NECK01_146_buff(self, buff, arg1, arg2)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM - 0.05;
end

function SCR_BUFF_ENTER_NECK01_147_buff(self, buff, arg1, arg2)
    self.MissileDefFactor_PC_BM = self.MissileDefFactor_PC_BM + 0.25;
end

function SCR_BUFF_LEAVE_NECK01_147_buff(self, buff, arg1, arg2)
    self.MissileDefFactor_PC_BM = self.MissileDefFactor_PC_BM - 0.25;
end

function SCR_BUFF_ENTER_BRC01_140_buff(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM + over * 0.05;
end

function SCR_BUFF_LEAVE_BRC01_140_buff(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM - over * 0.05;
end

function SCR_BUFF_ENTER_BRC01_141_buff(self, buff, arg1, arg2, over)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM + over * 0.025;
end

function SCR_BUFF_LEAVE_BRC01_141_buff(self, buff, arg1, arg2, over)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM - over * 0.025;
end

function SCR_BUFF_ENTER_BRC01_142_buff(self, buff, arg1, arg2, over)
    self.MissileDefFactor_PC_BM = self.MissileDefFactor_PC_BM + over * 0.1;
end

function SCR_BUFF_LEAVE_BRC01_142_buff(self, buff, arg1, arg2, over)
    self.MissileDefFactor_PC_BM = self.MissileDefFactor_PC_BM - over * 0.1;
end

function SCR_BUFF_ENTER_BRC02_120_buff(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM + over * 0.05
end

function SCR_BUFF_LEAVE_BRC02_120_buff(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM - over * 0.05;
end

function SCR_BUFF_ENTER_NECK02_123_buff(self, buff, arg1, arg2)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM + 0.1;
end

function SCR_BUFF_LEAVE_NECK02_123_buff(self, buff, arg1, arg2)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM - 0.1;
end

function SCR_BUFF_ENTER_BRC02_121_buff(self, buff, arg1, arg2, over)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM + over * 0.05;
end

function SCR_BUFF_LEAVE_BRC02_121_buff(self, buff, arg1, arg2, over)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM - over * 0.05;
end

function SCR_BUFF_ENTER_NECK02_124_buff(self, buff, arg1, arg2)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM + 0.1;
end

function SCR_BUFF_LEAVE_NECK02_124_buff(self, buff, arg1, arg2)
    self.IceDefFactor_PC_BM = self.IceDefFactor_PC_BM - 0.1;
end

function SCR_BUFF_ENTER_BRC03_109_buff(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM + over * 0.075;
end

function SCR_BUFF_LEAVE_BRC03_109_buff(self, buff, arg1, arg2, over)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM - over * 0.075;
end

function SCR_BUFF_ENTER_NECK03_107_buff(self, buff, arg1, arg2)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM + 0.15;
end

function SCR_BUFF_LEAVE_NECK03_107_buff(self, buff, arg1, arg2)
    self.DarkDefFactor_PC_BM = self.DarkDefFactor_PC_BM - 0.15;
end

function SCR_BUFF_ENTER_Drug_WDEF(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + arg1
    self.MDEF_BM = self.MDEF_BM + arg1
end

function SCR_BUFF_LEAVE_Drug_WDEF(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - arg1
    self.MDEF_BM = self.MDEF_BM - arg1
end

function SCR_BUFF_ENTER_Drug_WholeATK_Gimmick01(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 125;
    self.MATK_BM = self.MATK_BM + 125;
end

function SCR_BUFF_LEAVE_Drug_WDEF(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 125;
    self.MATK_BM = self.MATK_BM - 125;
end

function SCR_BUFF_ENTER_Drug_ATK_Gimmick01(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + arg1;
    self.MATK_BM = self.MATK_BM + (arg1 - 6);
end

function SCR_BUFF_LEAVE_Drug_ATK_Gimmick01(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - arg1;
    self.MATK_BM = self.MATK_BM - (arg1 - 6);
end

function SCR_BUFF_ENTER_Drug_SPUP_Gimmick01(self, buff, arg1, arg2, over)
    self.MSP_BM = self.MSP_BM + arg1;
    self.RSP_BM = self.RSP_BM + 415;
end

function SCR_BUFF_LEAVE_Drug_SPUP_Gimmick01(self, buff, arg1, arg2, over)
    self.MSP_BM = self.MSP_BM - arg1;
    self.RSP_BM = self.RSP_BM - 415;
end

function SCR_BUFF_ENTER_Drug_WholeDEF_gimmick01(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM + arg1;
    self.DEF_BM = self.DEF_BM + (arg1 * 0.02);
    self.MDEF_BM = self.MDEF_BM + (arg1 * 0.02);
end

function SCR_BUFF_LEAVE_Drug_WholeDEF_gimmick01(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM - arg1;
    self.DEF_BM = self.DEF_BM - (arg1 * 0.02);
    self.MDEF_BM = self.MDEF_BM - (arg1 * 0.02);
end

function SCR_BUFF_ENTER_Drug_Alche_Restore(self, buff, arg1, arg2, over)
    self.MSP_BM = self.MSP_BM + arg1;
    self.RSP_BM = self.RSP_BM + arg1 * 0.25;
end

function SCR_BUFF_LEAVE_Drug_Alche_Restore(self, buff, arg1, arg2, over)
    self.MSP_BM = self.MSP_BM - arg1;
    self.RSP_BM = self.RSP_BM - arg1 * 0.25;
end

-- made up

function SCR_BUFF_ENTER_Event_SongPyeon(self, buff, arg1, arg2, over)
    self.MSP_BM = self.MSP_BM + 5000;
    self.MHP_BM = self.MHP_BM + 5000;
    self.MSPD_BM = self.MSPD_BM + 2;
end

function SCR_BUFF_LEAVE_Event_SongPyeon(self, buff, arg1, arg2, over)
    self.MSP_BM = self.MSP_BM - 5000;
    self.MHP_BM = self.MHP_BM - 5000;
    self.MSPD_BM = self.MSPD_BM - 2;
end

function SCR_BUFF_ENTER_Event_LargeSongPyeon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 4;
    self.SR_BM = self.SR_BM + 1;
end

function SCR_BUFF_LEAVE_Event_LargeSongPyeon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 4;
    self.SR_BM = self.SR_BM - 1;
end

function SCR_BUFF_ENTER_Event_Largehoney_Songpyeon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 4;
    self.SR_BM = self.SR_BM + 1;
end

function SCR_BUFF_LEAVE_Event_Largehoney_Songpyeon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 4;
    self.SR_BM = self.SR_BM - 1;
end
-- Event pumpkincandy
function SCR_BUFF_ENTER_Event_Pumkincandy(self, buff, arg1, arg2, over)
    self.STR_BM = self.STR_BM + arg1;
    self.CON_BM = self.CON_BM + arg1;
    self.DEX_BM = self.DEX_BM + arg1;
    self.INT_BM = self.INT_BM + arg1;
    self.MNA_BM = self.MNA_BM + arg1;
end

function SCR_BUFF_UPDATE_Event_Pumkincandy(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        if RemainTime > 5300000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 600000, 0, 1);
        elseif RemainTime > 5030000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 642800, 0, 1);
        elseif RemainTime > 4670000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 692300, 0, 1);
        elseif RemainTime > 4310000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 750000, 0, 1);
        elseif RemainTime > 3950000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 818100, 0, 1);
        elseif RemainTime > 3590000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 900000, 0, 1);
        elseif RemainTime > 3230000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 999000, 0, 1);
        elseif RemainTime > 2870000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 1124000, 0, 1);
        elseif RemainTime > 2510000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 1284000, 0, 1);
        elseif RemainTime > 2150000 then
        AddBuff(self, self, 'Event_Pumkincandy', 5, 0, 1490000, 0, 1);
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_Event_Pumkincandy(self, buff, arg1, arg2, over)
    self.STR_BM = self.STR_BM - arg1;
    self.CON_BM = self.CON_BM - arg1;
    self.DEX_BM = self.DEX_BM - arg1;
    self.INT_BM = self.INT_BM - arg1;
    self.MNA_BM = self.MNA_BM - arg1;
end

--Event su-nung 161110
function SCR_BUFF_ENTER_Event_161110_candy(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Event_161110_candy(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Event_161110_vitamin(self, buff, arg1, arg2, over)
    local healHp = arg1;
    local healSp = arg1 / 3;

    if self.HPPotion_BM > 0 then
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    if self.SPPotion_BM > 0 then 
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end

    Heal(self, healHp, 0);
    HealSP(self, healSp, 0);
end

function SCR_BUFF_UPDATE_Event_161110_vitamin(self, buff, arg1, arg2, RemainTime, ret, over)
    local healHp = arg1;
    local healSp = arg1 / 3;

    if self.HPPotion_BM > 0 then
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    if self.SPPotion_BM > 0 then 
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end

    Heal(self, healHp, 0);
    HealSP(self, healSp, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Event_161110_vitamin(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Event_161110_chocolate(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
end

function SCR_BUFF_LEAVE_Event_161110_chocolate(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
end



function SCR_BUFF_UPDATE_Event_161215(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_ENTER_Event_161215_1(self, buff, arg1, arg2, over)
end
function SCR_BUFF_UPDATE_Event_161215_1(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_BUFF_UPDATE_Event_161215(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end
function SCR_BUFF_LEAVE_Event_161215_1(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Event_161215_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 1;
end
function SCR_BUFF_UPDATE_Event_161215_2(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_BUFF_UPDATE_Event_161215(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end
function SCR_BUFF_LEAVE_Event_161215_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 1;
end


function SCR_BUFF_ENTER_Event_161215_3(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 1;
    self.MHP_BM = self.MHP_BM + 500;
end
function SCR_BUFF_UPDATE_Event_161215_3(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_BUFF_UPDATE_Event_161215(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end
function SCR_BUFF_LEAVE_Event_161215_3(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 1;
    self.MHP_BM = self.MHP_BM - 500;
end


function SCR_BUFF_ENTER_Event_161215_4(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
    self.MHP_BM = self.MHP_BM + 1000;
end
function SCR_BUFF_UPDATE_Event_161215_4(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_BUFF_UPDATE_Event_161215(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end
function SCR_BUFF_LEAVE_Event_161215_4(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
    self.MHP_BM = self.MHP_BM - 1000;
end


function SCR_BUFF_ENTER_Event_161215_5(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 3;
    self.MHP_BM = self.MHP_BM + 2000;
end
function SCR_BUFF_UPDATE_Event_161215_5(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_BUFF_UPDATE_Event_161215(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end
function SCR_BUFF_LEAVE_Event_161215_5(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 3;
    self.MHP_BM = self.MHP_BM - 2000;
end


    
    
-- Red Apple
function SCR_BUFF_ENTER_Drug_Heal100HP_Dot(self, buff, arg1, arg2, over)
    local healHp = self.MHP * (arg1 / 100);
    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end
    
    if self.HPPotion_BM > 0 then 
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    Heal(self, healHp, 0);
end

function SCR_BUFF_UPDATE_Drug_Heal100HP_Dot(self, buff, arg1, arg2, RemainTime, ret, over)
   local healHp = self.MHP * (arg1 / 100);
    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end
    
    if self.HPPotion_BM > 0 then 
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    healHp = healHp / 5
    Heal(self, healHp, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_Heal100HP_Dot(self, buff, arg1, arg2, over)

end

-- Blue Apple
function SCR_BUFF_ENTER_Drug_Heal100SP_Dot(self, buff, arg1, arg2, over)
    local healSp = self.MSP * (arg1 / 100);
    
    if self.SPPotion_BM > 0 then
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end
    HealSP(self, healSp, 0);
end

function SCR_BUFF_UPDATE_Drug_Heal100SP_Dot(self, buff, arg1, arg2, RemainTime, ret, over)

    local healSp = self.MSP * (arg1 / 100);
    
    if self.SPPotion_BM > 0 then
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end
    
    healSp = math.floor(healSp / 5);
    HealSP(self, healSp, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_Heal100SP_Dot(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Event_ThanksgivingDay(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
end

function SCR_BUFF_LEAVE_Event_ThanksgivingDay(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
end

function SCR_BUFF_ENTER_item_set_038_buff(self, buff, arg1, arg2, over)
    
    local Maxhp = self.MHP;
    local healcount = 5;
    Heal(self, Maxhp * 0.02, 0);
    healcount = healcount - 1;
    SetBuffArgs(buff, Maxhp, healcount, 0);
end

function SCR_BUFF_UPDATE_item_set_038_buff(self, buff, arg1, arg2, RemainTime, ret, over)

     local Maxhp, healcount = GetBuffArgs(buff);
     
     if healcount >= 1 then
         Heal(self, Maxhp * 0.02, 0);
         healcount = healcount - 1;
         SetBuffArgs(buff, Maxhp, healcount, 0);
     end
    return 1;
end

function SCR_BUFF_LEAVE_item_set_038_buff(self, buff, arg1, arg2, over)

end

-- _Fortunecookie
-- 1
function SCR_BUFF_ENTER_Premium_Fortunecookie_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 1;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_1(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 1;
end

-- 2
function SCR_BUFF_ENTER_Premium_Fortunecookie_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_2(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
end

-- 3
function SCR_BUFF_ENTER_Premium_Fortunecookie_3(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 3;
    self.MHP_BM = self.MHP_BM + 500;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_3(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_3(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 3;
    self.MHP_BM = self.MHP_BM - 500;
end

-- 4
function SCR_BUFF_ENTER_Premium_Fortunecookie_4(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 4;
    self.MHP_BM = self.MHP_BM + 1000;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_4(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_4(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 4;
    self.MHP_BM = self.MHP_BM - 1000;
end

-- 5
function SCR_BUFF_ENTER_Premium_Fortunecookie_5(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 5;
    self.MHP_BM = self.MHP_BM + 2000;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_5(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_5(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 5;
    self.MHP_BM = self.MHP_BM - 2000;
end

function SCR_BUFF_ENTER_item_set_039pre_buff(self, buff, arg1, arg2, over)
    SetBuffArg(self, buff, arg1, 0);
end

function SCR_BUFF_GIVEDMG_item_set_039pre_buff(self, buff, sklID, damage, target, ret)

    local arg1, arg2 = GetBuffArg(buff);
    
    if arg2 == 5 then
        SetBuffArg(self, buff, arg1, 0);
       PlayEffect(target, "F_explosion065_violet", 1, 1, 'BOT')
        local bombDamage = math.floor( 1000 * IMCRandomFloat(1, 3));
        TakeDadak(self, target, "None", bombDamage, 0.1, "Melee", "Magic", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
    end
    return 1;
end

function SCR_BUFF_RATETABLE_item_set_039pre_buff(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(from, 'item_set_039pre_buff') == 'YES' then
        if ret.Damage <= 0 then
            return;
        end
        if skill ~= nil and buff ~= nil then
            if "Default" ~= TryGetProp(skill, "ClassName") then
                local arg1, arg2 = GetBuffArg(buff);
                arg2 = arg2 + 1;
                SetBuffArg(self, buff, arg1, arg2);
            end
        end
    end
end


function SCR_BUFF_LEAVE_item_set_039pre_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_item_set_039_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_item_set_039_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Event_Penalty(self, buff, arg1, arg2, over)
   local defadd = self.DEF
   local mdefadd = self.MDEF
   local mhp = self.MHP
   
   self.DEF_BM = self.DEF_BM - defadd + 1
   self.MDEF_BM = self.MDEF_BM - mdefadd + 1;
   self.MHP_BM = self.MHP_BM - mhp + 1;
   
   SetExProp(buff, "ADD_DEF", defadd);
   SetExProp(buff, "ADD_MDEF", mdefadd);
   SetExProp(buff, "ADD_MHP", mhp);
end

function SCR_BUFF_LEAVE_Event_Penalty(self, buff, arg1, arg2, over)
   local defadd = GetExProp(buff, "ADD_DEF");
   local mdefadd = GetExProp(buff, "ADD_DEF");
   local mhp = GetExProp(buff, "ADD_MHP");
   
   self.DEF_BM = self.DEF_BM + defadd - 1;
   self.MDEF_BM = self.MDEF_BM + mdefadd - 1;
   self.MHP_BM = self.MHP_BM + mhp - 1;
end


function SCR_BUFF_ENTER_Event_Rice_Soup(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Event_Rice_Soup(self, buff, arg1, arg2, RemainTime, ret, over)

    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1

end

function SCR_BUFF_LEAVE_Event_Rice_Soup(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Event_LargeRice_Soup(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 4;
    self.SR_BM = self.SR_BM + 1;

end

function SCR_BUFF_UPDATE_Event_LargeRice_Soup(self, buff, arg1, arg2, RemainTime, ret, over)

    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1

end

function SCR_BUFF_LEAVE_Event_LargeRice_Soup(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 4;
        self.SR_BM = self.SR_BM - 1;
end

-- guild battle amband
function SCR_BUFF_ENTER_item_set_041_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_041_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_item_set_042_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_042_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_item_set_043_buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_item_set_043_buff(self, buff, arg1, arg2, over)
end

-- redorb buff
function SCR_BUFF_ENTER_Event_RedOrb_GM(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 20;
    self.MATK_BM = self.MATK_BM + 20;
    SET_NORMAL_ATK_SPEED(self, -50)
    self.SR_BM = self.SR_BM + 1
    
    SetExProp(buff, "ADD_SR", 1)
end

function SCR_BUFF_LEAVE_Event_RedOrb_GM(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 20;
    self.MATK_BM = self.MATK_BM - 20;
    SET_NORMAL_ATK_SPEED(self, 50)
    local addsr = GetExProp(buff, "ADD_SR")

    self.SR_BM = self.SR_BM - addsr
end

function SCR_BUFF_ENTER_Drug_DotHealHP(self, buff, arg1, arg2, over)
    local healHp = arg1 * 7;
    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end
    
    if self.HPPotion_BM > 0 then 
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    Heal(self, arg1 , 0);
    
end

function SCR_BUFF_UPDATE_Drug_DotHealHP(self, buff, arg1, arg2, RemainTime, ret, over)

    if IsBuffApplied(self, "Restoration_Buff") == 'YES' then
        arg1 = math.floor(arg1 * 1.3);
    end

    if self.HPPotion_BM > 0 then
        arg1 = math.floor(arg1 * (1 + self.HPPotion_BM/100));
    end

    Heal(self, arg1, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Drug_DotHealHP(self, buff, arg1, arg2, over)

end

--Event_Transform_GM
function SCR_BUFF_ENTER_Event_Transform_GM(self, buff, arg1, arg2, over)
    if arg1 == 1 then
        montype = 'Peaceful'
    elseif arg1 == 2 then
        montype = 'Monster'
    end

    SetCurrentFaction(self, montype)
end

function SCR_BUFF_UPDATE_Event_Transform_GM(self, buff, arg1, arg2, RemainTime, ret, over)
    REMOVE_BUFF_BY_LEVEL(self, "Debuff", 3);
    return 1
end

function SCR_BUFF_LEAVE_Event_Transform_GM(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'GM_BUFF_DEF');
    RemoveBuff(self, 'GM_BUFF_MHP');
    REMOVE_BUFF_BY_LEVEL(self, "Debuff", 3);
    PlayAnim(self, 'ASTD', 1)
    SetCurrentFaction(self, 'Law')
    TransformToMonster(self, "None", "None");
    ClearScpObjectList(self, 'Event_Transform_GM')
end

function SCR_BUFF_ENTER_Event_WeddingCake(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 3;
    self.CON_BM = self.CON_BM + 10;

end

function SCR_BUFF_UPDATE_Event_WeddingCake(self, buff, arg1, arg2, RemainTime, ret, over)

    if RemainTime > 3600000 then
        SetBuffRemainTime(self, buff.ClassName, 3600000)
    end
    return 1

end

function SCR_BUFF_LEAVE_Event_WeddingCake(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 3;
    self.CON_BM = self.CON_BM - 10;
end

-- Event_Donnes_Buff
function SCR_BUFF_ENTER_Event_Donnes_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Event_Donnes_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 7200000 then
        SetBuffRemainTime(self, buff.ClassName, 7200000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Event_Donnes_Buff(self, buff, arg1, arg2, over)
end

-- GM BUFF
function SCR_BUFF_ENTER_GM_BUFF_ATK(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM + arg1;
    self.PATK_BM = self.PATK_BM + arg1;
end

function SCR_BUFF_LEAVE_GM_BUFF_ATK(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM - arg1;
    self.PATK_BM = self.PATK_BM - arg1;
end

function SCR_BUFF_ENTER_GM_BUFF_DEF(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + arg1;
    self.MDEF_BM = self.MDEF_BM + arg1;
end

function SCR_BUFF_LEAVE_GM_BUFF_DEF(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - arg1;
    self.MDEF_BM = self.MDEF_BM - arg1;
end

function SCR_BUFF_ENTER_GM_BUFF_MHP(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM + arg1
end

function SCR_BUFF_LEAVE_GM_BUFF_MHP(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM - arg1
end

function SCR_BUFF_GIVEDMG_STACK_MATK_PRE(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    if IsBuffApplied(self, 'STACK_MATK') == "NO" then
        AddBuff(self, self, 'STACK_MATK', 1, 0, 10000, 1);
        return 1;
    end
    
    local buffOver = GetBuffOver(self, 'STACK_MATK')
    
    if buffOver >= 50 then
        return 1;
    end
    
    AddBuff(self, self, 'STACK_MATK', 1, 0, 10000, 1);
     
    return 1;
end

function SCR_BUFF_ENTER_STACK_MATK(self, buff, arg1, arg2, over)
    local addMATK = 0;
    local bonusMATK = 0;
    
    if over >= 50 then
        over = 50;
        bonusMATK = 250;
        
        SetBuffRemainTime(self, buff.ClassName, 10000); --���� ????-
    end
    
    local addMATK = (2 * over) + bonusMATK;
    
    addMATK = math.floor(addMATK);
    
    self.MATK_BM = self.MATK_BM + addMATK;
    
    SetExProp(buff, "ADD_MATK", addMATK);
    
  -- 5?????���� 10 ??? / 50 ?????????���� 250 ??? ???
  -- ????????10?
  
  -- �ڸ�??--
  -- ���� ???? local buffOver = GetBuffOver(self, 'STACK_MATK'); ??50????????????���� ??? ?????????ó???????????--
end

function SCR_BUFF_LEAVE_STACK_MATK(self, buff, arg1, arg2, over)
    local addMATK = GetExProp(buff, "ADD_MATK");
    
    self.MATK_BM = self.MATK_BM - addMATK;
end



function SCR_BUFF_ENTER_SHOCK_BOOM(self, buff, arg1, arg2, over)
end

function SCR_BUFF_GIVEDMG_SHOCK_BOOM(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    local list, cnt = SelectObject(self, 60, "ENEMY");
    if cnt < 1 then
        return 1;
    end
    
    if cnt > 10 then
        cnt = 10;
    end
    
    local ratio = cnt * 200;
    
    local skill = GetClassByType("Skill", sklID);
    if skill == nil then
        return 1;
    end
    
    if ratio >= IMCRandom(1, 10000) and skill.ClassName ~= 'Default' then        
        local damage = IMCRandom(2000, 3000);
        for i = 1, cnt do
            local target = list[i];
            PlayEffect(target, "F_explosion065_violet", 1, 1, 'BOT')
            TakeDamage(self, target, "None", damage, "Melee", "Magic", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_SHOCK_BOOM(self, buff, arg1, arg2, over)
    
end



function SCR_BUFF_ENTER_Res_TS_ATK(self, buff, arg1, arg2, over)
    --????????????����?????????
end

function SCR_BUFF_RATETABLE_Res_TS_ATK(self, from, skill, atk, ret, rateTable, buff)
    local attrList = {'Fire', 'Ice', 'Lightning', 'Poison', 'Dark', 'Holy', 'Earth', 'Soul'}
    
    for i = 1, #attrList do
        local resValue = TryGetProp(from , "Res"..attrList[i]);
        if resValue == nil then
            resValue = 0
        end
        
        if resValue > 0 then
            local addLimit = 300;
            if resValue > addLimit then
                resValue = addLimit;
            end
            
            rateTable["AddAttributeDamage"..attrList[i]] = rateTable["AddAttributeDamage"..attrList[i]] + resValue;
        end
    end
end

function SCR_BUFF_LEAVE_Res_TS_ATK(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_DFFENCE_SHIELD(self, buff, arg1, arg2, over)
    local addDEF = 0;
    local bonusDEF = 0;
    
    if over >= 50 then
        over = 50;
        bonusDEF = 500;
        
        SetBuffRemainTime(self, buff.ClassName, 10000); --���� ????-
    end
    
    local addDEF = (10 * over) + bonusDEF;
    
    addDEF = math.floor(addDEF);
    
    self.DEF_BM = self.DEF_BM + addDEF;
    self.MDEF_BM = self.MDEF_BM + addDEF;
    
    SetExProp(buff, "ADD_DEF", addDEF);
    
  -- 1???????���� 10 ??? / 50 ???????????���� 500 ??? ???
  -- ????????10?
  
  -- �ڸ�??--
  -- ���� ???? local buffOver = GetBuffOver(self, 'DFFENCE_SHIELD'); ??50????????????���� ??? ?????????ó???????????--
end

function SCR_BUFF_LEAVE_DFFENCE_SHIELD(self, buff, arg1, arg2, over)
    local addDEF = GetExProp(buff, "ADD_DEF");
    
    self.DEF_BM = self.DEF_BM - addDEF;
    self.MDEF_BM = self.MDEF_BM - addDEF;
end


function SCR_BUFF_TAKEDMG_DFFENCE_SHIELD_PRE(self, buff, arg1, arg2, over)

    local buffOver = GetBuffOver(self, 'DFFENCE_SHIELD')
    
    if buffOver >= 50 then
        return 1;
    end
    
    AddBuff(self, self, 'DFFENCE_SHIELD', 1, 0, 10000, 1);
     
    return 1;
end



--fish eat buff
function SCR_BUFF_ENTER_FISH_RHP_RSP(self, buff, arg1, arg2, over)
    local lv = TryGetProp(self, "Lv");
    if lv == nil then
        lv = 1;
    end
    
    local addRHP = 1 + math.floor(lv * 1);
    local addRSP = 1 + math.floor(lv * 0.25);
    
    self.RHP_BM = self.RHP_BM + addRHP;
    self.RSP_BM = self.RSP_BM + addRSP;
    
    SetExProp(buff, "ADD_RHP", addRHP);
    SetExProp(buff, "ADD_RSP", addRSP);
end

function SCR_BUFF_LEAVE_FISH_RHP_RSP(self, buff, arg1, arg2, over)
    local addRHP = GetExProp(buff, "ADD_RHP");
    local addRSP = GetExProp(buff, "ADD_RSP");
    
    self.RHP_BM = self.RHP_BM - addRHP;
    self.RSP_BM = self.RSP_BM - addRSP;
end

-- Event_Steam_Wedding
function SCR_BUFF_ENTER_Event_Steam_Wedding(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Event_Steam_Wedding(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_BATTLE_BUFF_01_DRUG(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM + arg1;
    self.PATK_BM = self.PATK_BM + arg1;
    self.CRTHR_BM = self.CRTHR_BM + math.floor(arg1 / 2);
    SET_NORMAL_ATK_SPEED(self, -80)
    self.MSPD_BM = self.MSPD_BM + math.floor(arg1 / 30);
end

function SCR_BUFF_LEAVE_BATTLE_BUFF_01_DRUG(self, buff, arg1, arg2, over)
    self.MATK_BM = self.MATK_BM - arg1;
    self.PATK_BM = self.PATK_BM - arg1;
    self.CRTHR_BM = self.CRTHR_BM - math.floor(arg1 / 2);
    SET_NORMAL_ATK_SPEED(self, 80)
    self.MSPD_BM = self.MSPD_BM - math.floor(arg1 / 30);
end

function SCR_BUFF_RATETABLE_BATTLE_BUFF_01_DRUG(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "BATTLE_BUFF_01_DRUG") == "YES" then
--    	rateTable.DamageRate = rateTable.DamageRate - 0.05
        AddDamageReductionRate(rateTable, 0.05)
    end
end

function SCR_BUFF_ENTER_Cotume_DMG_Rate_Down_3(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Cotume_DMG_Rate_Down_3(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_Cotume_DMG_Rate_Down_5(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Cotume_DMG_Rate_Down_5(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_RATETABLE_Cotume_DMG_Rate_Down_3(self, from, skill, atk, ret, rateTable, buff)
    if IsPVPServer(self) == 1 then
        if IsBuffApplied(self, "Cotume_DMG_Rate_Down_3") == "YES" then
--            rateTable.DamageRate = rateTable.DamageRate - 0.03
            AddDamageReductionRate(rateTable, 0.03)
        end
    end
end 

function SCR_BUFF_RATETABLE_Cotume_DMG_Rate_Down_5(self, from, skill, atk, ret, rateTable, buff)
    if IsPVPServer(self) == 1 then
        if IsBuffApplied(self, "Cotume_DMG_Rate_Down_5") == "YES" then
--            rateTable.DamageRate = rateTable.DamageRate - 0.05
			AddDamageReductionRate(rateTable, 0.05)
        end
    end
end

function SCR_BUFF_ENTER_CARD_DMG_Rate_Down_10(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_CARD_DMG_Rate_Down_10(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_RATETABLE_CARD_DMG_Rate_Down_10(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, "CARD_DMG_Rate_Down_10") == "YES" then
--        rateTable.DamageRate = rateTable.DamageRate - 0.1
		AddDamageReductionRate(rateTable, 0.1)
    end
end

function SCR_BUFF_ENTER_ITEM_Solmiki_armorbreak(self, buff, arg1, arg2, over)
 
    local defadd = 0.2;
    local mdefadd = 0.2
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
end

function SCR_BUFF_LEAVE_ITEM_Solmiki_armorbreak(self, buff, arg1, arg2, over)
    
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd;
    
end
function SCR_BUFF_ENTER_CARD_Haste(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 4
end

function SCR_BUFF_LEAVE_CARD_Haste(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 4
end

function SCR_BUFF_ENTER_CARD_ElectricShock(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_EFFECT', 0, nil, 'item_electricShock');
end

function SCR_BUFF_UPDATE_CARD_ElectricShock(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 0;
    end
    
    TakeDamage(caster, self, "None", arg1, "Lightning", "Magic", "AbsoluteDamage", HIT_LIGHTNING, HITRESULT_BLOW, 0, 0);
    return 1;
end

function SCR_BUFF_LEAVE_CARD_ElectricShock(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_GIMMICK_Drug_Elements(self, buff, arg1, arg2, over)

   local list = { 'Fire',
                   'Ice',
                   'Lightning',
                   'Earth'
                   }

   local ran = list[IMCRandom(1,4)]
if ran == 'Fire' then
       PlayEffect(self, 'F_lineup022_red', 1, 'BOT');
   	AddBuff(self, self, "GIMMICK_Drug_Elements_Fire_Atk", arg1, 0, 120000, 1)
elseif ran == 'Ice' then
       PlayEffect(self, 'F_lineup022_dark_blue2', 1, 'BOT');
   	AddBuff(self, self, "GIMMICK_Drug_Elements_Ice_Atk", arg1, 0, 120000, 1)
elseif ran == 'Lightning' then
       PlayEffect(self, 'F_lineup022_violet', 1, 'BOT');
   	AddBuff(self, self, "GIMMICK_Drug_Elements_Lightning_Atk", arg1, 0, 120000, 1)
elseif ran == 'Earth' then
       PlayEffect(self, 'F_lineup022_yellow', 1, 'BOT');
   	AddBuff(self, self, "GIMMICK_Drug_Elements_Earth_Atk", arg1, 0, 120000, 1)
end	   	   	   	   	

end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Elements(self, buff, arg1, arg2, over)

   if IsBuffApplied(self, "GIMMICK_Drug_Elements_Fire_Atk") == "YES" then
       RemoveBuff(self, "GIMMICK_Drug_Elements_Fire_Atk")
   end
   if IsBuffApplied(self, "GIMMICK_Drug_Elements_Ice_Atk") == "YES" then
       RemoveBuff(self, "GIMMICK_Drug_Elements_Ice_Atk")
   end
   if IsBuffApplied(self, "GIMMICK_Drug_Elements_Lightning_Atk") == "YES" then
       RemoveBuff(self, "GIMMICK_Drug_Elements_Lightning_Atk")
   end
   if IsBuffApplied(self, "GIMMICK_Drug_Elements_Earth_Atk") == "YES" then
       RemoveBuff(self, "GIMMICK_Drug_Elements_Earth_Atk")
   end        

end

--GIMMICK_Drug_Elements_Fire_Atk
function SCR_BUFF_ENTER_GIMMICK_Drug_Elements_Fire_Atk(self, buff, arg1, arg2, over)
   self.Fire_Atk_BM = self.Fire_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Elements_Fire_Atk(self, buff, arg1, arg2, over)
   self.Fire_Atk_BM = self.Fire_Atk_BM - arg1;
end

--GIMMICK_Drug_Elements_Ice_Atk
function SCR_BUFF_ENTER_GIMMICK_Drug_Elements_Ice_Atk(self, buff, arg1, arg2, over)
   self.Ice_Atk_BM = self.Ice_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Elements_Ice_Atk(self, buff, arg1, arg2, over)
   self.Ice_Atk_BM = self.Ice_Atk_BM - arg1;
end
--기�? 보상--
function SCR_BUFF_ENTER_GIMMICK_Drug_Elements_Lightning_Atk(self, buff, arg1, arg2, over)
   self.Lightning_Atk_BM = self.Lightning_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Elements_Lightning_Atk(self, buff, arg1, arg2, over)
   self.Lightning_Atk_BM = self.Lightning_Atk_BM - arg1;
end

--GIMMICK_Drug_Elements_Earth_Atk
function SCR_BUFF_ENTER_GIMMICK_Drug_Elements_Earth_Atk(self, buff, arg1, arg2, over)
   self.Earth_Atk_BM = self.Earth_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Elements_Earth_Atk(self, buff, arg1, arg2, over)
   self.Earth_Atk_BM = self.Earth_Atk_BM - arg1;
end

--GIMMICK_Drug_Curse(Consume)
function SCR_BUFF_ENTER_GIMMICK_Drug_Curse(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Curse(self, buff, arg1, arg2, over)

end

function SCR_BUFF_GIVEDMG_GIMMICK_Drug_Curse(self, buff, sklID, damage, target, ret)
   if sklID ~= DEFAULT_SKILL_CLASSID  and target.RaceType ~= 'Item' then
       if IsBuffApplied(target, "GIMMICK_Drug_Curse_Fire_buff") == "NO" and
           IsBuffApplied(target, "GIMMICK_Drug_Curse_Ice_buff") == "NO" and
           IsBuffApplied(target, "GIMMICK_Drug_Curse_Poison_buff") == "NO" and
           IsBuffApplied(target, "GIMMICK_Drug_Curse_Lightning_buff") == "NO" then
           local result = IMCRandom(1, 100);
           if result <= 10 then
               local list = { 'Fire',
                               'Ice',
                               'Poison',
                               'Lightning'
                               }
               local ran = list[IMCRandom(1,4)]
               if ran == 'Fire' then
                   AddBuff(self, target, 'GIMMICK_Drug_Curse_Fire_buff', 7500, 0, 6000, 1);
               elseif ran == 'Ice' then
                   AddBuff(self, target, 'GIMMICK_Drug_Curse_Ice_buff', 7500, 0, 6000, 1);
               elseif ran == 'Poison' then
                   AddBuff(self, target, 'GIMMICK_Drug_Curse_Poison_buff', 7500, 0, 6000, 1);
               elseif ran == 'Lightning' then
                   AddBuff(self, target, 'GIMMICK_Drug_Curse_Lightning_buff', 7500, 0, 6000, 1);                
               end
           end
       end
   end        

   return 1;
end

--GIMMICK_Drug_Curse_Fire_buff
function SCR_BUFF_ENTER_GIMMICK_Drug_Curse_Fire_buff(self, buff, arg1, arg2, over)
   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end
   
   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Fire", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
   PlayEffect(self, "F_fire036", 0.4);
end

function SCR_BUFF_UPDATE_GIMMICK_Drug_Curse_Fire_buff(self, buff, arg1, arg2, RemainTime, ret, over)

   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end
   
   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Fire", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
   PlayEffect(self, "F_fire036", 0.4);
   return 1;

end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Curse_Fire_buff(self, buff, arg1, arg2, over)

end

--GIMMICK_Drug_Curse_Ice_buff
function SCR_BUFF_ENTER_GIMMICK_Drug_Curse_Ice_buff(self, buff, arg1, arg2, over)
   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end
   
   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Ice", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
   PlayEffect(self, "F_spread_out037_violet_ice_leaf", 0.6);
end

function SCR_BUFF_UPDATE_GIMMICK_Drug_Curse_Ice_buff(self, buff, arg1, arg2, RemainTime, ret, over)

   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end

   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Ice", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
   PlayEffect(self, "F_spread_out037_violet_ice_leaf", 0.6);
   return 1;

end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Curse_Ice_buff(self, buff, arg1, arg2, over)

end

--GIMMICK_Drug_Curse_Poison_buff
function SCR_BUFF_ENTER_GIMMICK_Drug_Curse_Poison_buff(self, buff, arg1, arg2, over)
   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end
   
   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Poison", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
   PlayEffect(self, "F_explosion054_green", 1.5);
end

function SCR_BUFF_UPDATE_GIMMICK_Drug_Curse_Poison_buff(self, buff, arg1, arg2, RemainTime, ret, over)

   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end

   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Poison", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
   PlayEffect(self, "F_explosion054_green", 1.5);
   return 1;

end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Curse_Poison_buff(self, buff, arg1, arg2, over)

end

--GIMMICK_Drug_Curse_Lightning_buff
function SCR_BUFF_ENTER_GIMMICK_Drug_Curse_Lightning_buff(self, buff, arg1, arg2, over)
   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end
   
   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Lightning", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
   PlayEffect(self, "F_burstup048_rize", 0.7);
end

function SCR_BUFF_UPDATE_GIMMICK_Drug_Curse_Lightning_buff(self, buff, arg1, arg2, RemainTime, ret, over)

   local caster = GetBuffCaster(buff);
   if caster == nil then
       caster = buff;
   end

   TakeDamage(caster, self, "None", IMCRandom(arg1/5, arg1/3), "Lightning", "None", "AbsoluteDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    PlayEffect(self, "F_burstup048_rize", 0.7);
   return 1;

end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Curse_Lightning(self, buff, arg1, arg2, over)

end


--GIMMICK_Drug_Regeneration
function SCR_BUFF_ENTER_GIMMICK_Drug_Regeneration(self, buff, arg1, arg2, over)
   self.RHP_BM = self.RHP_BM + arg1
end


function SCR_BUFF_LEAVE_GIMMICK_Drug_Regeneration(self, buff, arg1, arg2, over)
   self.RHP_BM = self.RHP_BM - arg1
end

-- 350 unique item buff -- 

function SCR_BUFF_ENTER_Item_BLOCK_Debuff(self, buff, arg1, arg2, over)
    self.BLK_BM = self.BLK_BM - arg2;
end

function SCR_BUFF_LEAVE_Item_BLOCK_Debuff(self, buff, arg1, arg2, over)
    self.BLK_BM = self.BLK_BM + arg2;
end

function SCR_BUFF_ENTER_CRIDR_Debuff(self, buff, arg1, arg2, over)
    self.CRTDR_BM = self.CRTDR_BM - arg2 * over;
end

function SCR_BUFF_LEAVE_CRIDR_Debuff(self, buff, arg1, arg2, over)
    self.CRTDR_BM = self.CRTDR_BM + arg2 * over;
end

-- 350 unique item rapier -- 
function SCR_BUFF_GIVEDMG_MASINIOSRAPIER_PRE(self, buff, sklID, damage, target, ret)
    local buffRatio = IMCRandom(1, 100)
    local skill = GetClassByType('Skill',sklID)
    local buffOver

    if skill.ClassName == 'Normal_Attack' or skill.ClassName == 'Common_DaggerAries' or damage <= 0 or buffRatio > 15  then
        return 1;
    end
    
    if IsBuffApplied(self, 'MASINIOSRAPIER_STACK_CRIATK') == 'NO' and IsBuffApplied(self, 'MASINIOSRAPIER_5ATTACK') == 'NO' then
        AddBuff(self, self, 'MASINIOSRAPIER_STACK_CRIATK', 1, 60, 10000, 1);
        return 1;
    end
    
    if IsBuffApplied(self, 'MASINIOSRAPIER_5ATTACK') == 'NO' then
        buffOver = GetBuffOver(self, 'MASINIOSRAPIER_STACK_CRIATK')
    elseif IsBuffApplied(self, 'MASINIOSRAPIER_5ATTACK') == 'YES' then
        return 1;
    end
    
    if buffOver >= 4 and IsBuffApplied(self, 'MASINIOSRAPIER_5ATTACK') == 'NO' then
        AddBuff(self, self, 'MASINIOSRAPIER_5ATTACK', 1, 0, 0, 1);
        RemoveBuff(self, 'MASINIOSRAPIER_STACK_CRIATK');
        return 1;
    elseif IsBuffApplied(self, 'MASINIOSRAPIER_5ATTACK') == 'YES' then
        return 1;
    end
    
    AddBuff(self, self, 'MASINIOSRAPIER_STACK_CRIATK', 1, 60, 10000, 1);
    
    return 1;
    
end

function SCR_BUFF_ENTER_MASINIOSRAPIER_STACK_CRIATK(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM + arg2 * over;
end

function SCR_BUFF_LEAVE_MASINIOSRAPIER_STACK_CRIATK(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM - arg2 * over;
end

function SCR_BUFF_ENTER_MASINIOSRAPIER_5ATTACK(self, buff, arg1, arg2, over)
end
function SCR_BUFF_RATETABLE_MASINIOSRAPIER_5ATTACK(self, from, skill, atk, ret, rateTable, buff)
    if skill.ClassName == 'Normal_Attack' and IsBuffApplied(self, 'MASINIOSRAPIER_5ATTACK') then
        rateTable.DamageRate = rateTable.DamageRate + 4.0;
        SetMultipleHitCount(ret, 5);     
    end
end
function SCR_BUFF_LEAVE_MASINIOSRAPIER_5ATTACK(self, buff, arg1, arg2, over)
end

-- 350 unique item Spear -- 
function SCR_BUFF_GIVEDMG_MASINIOSTHSPEAR_PRE(self, buff, sklID, damage, target, ret)
    local buffRatio = IMCRandom(1, 10000)
    if damage <= 0 or buffRatio > 1000 or IsBuffApplied(target, 'Penetrate_DEF_Debuff') == 'YES' then
        return 1;
    end
    
    if IsBuffApplied(target, 'Penetrate_Debuff') == 'NO' then
        AddBuff(self, target, 'Penetrate_Debuff', 1, 0, 20000, 1);
        return 1;
    end
    
    local buffOver = GetBuffOver(target, 'Penetrate_Debuff')
    if buffOver >= 10 and IsBuffApplied(target, 'Penetrate_DEF_Debuff') == 'NO' then
        AddBuff(self, target, 'Penetrate_DEF_Debuff', 1, 0, 10000, 1);
        AddBuff(self, target, 'Slow_Debuff', 1, 0, 10000, 1);
        RemoveBuff(target, 'Penetrate_Debuff');
        return 1;
    end
    
    AddBuff(self, target, 'Penetrate_Debuff', 1, 0, 20000, 1);
    return 1;
    
end

function SCR_BUFF_ENTER_Penetrate_Debuff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        AddStamina(self, -1500)
    end
end

function SCR_BUFF_LEAVE_Penetrate_Debuff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_Penetrate_DEF_Debuff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 800
end

function SCR_BUFF_LEAVE_Penetrate_DEF_Debuff(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 800
end

-- 350 unique item Rod -- 

function SCR_BUFF_GIVEDMG_MASINIOS_ROD_PRE(self, buff, sklID, damage, target, ret)
    
    local buffRatio = IMCRandom(1, 100)
    
    if sklID < 1000 or damage <= 0 or buffRatio > 10  then
        return 1;
    end
    
    if IsBuffApplied(self, 'MASINIOS_ROD_Buff') == 'NO' then
        AddBuff(self, self, 'MASINIOS_ROD_Buff', 1, 0, 10000, 1);
        return 1;
    end
    
    local buffOver = GetBuffOver(self, 'MASINIOS_ROD_Buff')

    if  buffOver >= 10 then
        return 1;
    end
    
    AddBuff(self, self, 'MASINIOS_ROD_Buff', 1, 0, 10000, 1);
    return 1;
    
end

function SCR_BUFF_ENTER_MASINIOS_ROD_Buff(self, buff, arg1, arg2, over)
    self.MNA_ITEM_BM = self.MNA_ITEM_BM + (5 * over)
end

function SCR_BUFF_LEAVE_MASINIOS_ROD_Buff(self, buff, arg1, arg2, over)
    self.MNA_ITEM_BM = self.MNA_ITEM_BM - (5 * over)
end

-- 350 unique item THSword --
function SCR_BUFF_GIVEDMG_MASINIOS_THSWORD_PRE(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end

    local list, cnt = SelectObject(self, 60, "ENEMY");
    if cnt < 1 then
        return 1;
    end
    
    if cnt > 10 then
        cnt = 10;
    end
    
    local ratio = cnt * 100;

    if ratio < IMCRandom(1, 10000)  then
        return 1; 
    end
    
    if IsBuffApplied(self, 'MASINIOS_THSWORD_OVER') == 'NO' then        
        AddBuff(self, self, 'MASINIOS_THSWORD_BUFF', 1, 0, 5000, 1);
        if IsBuffApplied(self, 'MASINIOS_THSWORD_BUFF') == 'YES' then
            local buffOver = GetBuffOver(self, 'MASINIOS_THSWORD_BUFF')            
            if buffOver >= 5 and IsBuffApplied(self, 'MASINIOS_THSWORD_OVER') == 'NO' then
                RemoveBuff(self, 'MASINIOS_THSWORD_BUFF');
                AddBuff(self, self, 'MASINIOS_THSWORD_OVER', 1, 0, 10000, 1);
            end
        end
    end

    return 1;
end
function SCR_BUFF_ENTER_MASINIOS_THSWORD_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_MASINIOS_THSWORD_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_MASINIOS_THSWORD_OVER(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 120
    self.SR_BM = self.SR_BM + 2
    
    self.MHP_BM = self.MHP_BM - 2000
    self.DEF_BM = self.DEF_BM - 400
end

function SCR_BUFF_LEAVE_MASINIOS_THSWORD_OVER(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 120
    self.SR_BM = self.SR_BM - 2

    self.MHP_BM = self.MHP_BM + 2000
    self.DEF_BM = self.DEF_BM + 400
end

function SCR_BUFF_GIVEDMG_MASINIOS_MACE(self, buff, sklID, damage, target, ret)
    if damage <= 0 then
        return 1;
    end
    
    
    local skill = GetClassByType("Skill", sklID);
    if skill == nil then
        return 1;
    end
    
    local ratio = IMCRandom(1, 10000)
    if target.RaceType ~= 'Item' and ratio <= 3000 and skill.ClassName ~= 'Default'then
        TakeDadak(self, target, "None", 2000, 0.25, "Lightning", "Magic", "TrueDamage", HIT_LIGHTNING, HITRESULT_NO_HITSCP);
    end

    return 1;
end

function SCR_BUFF_ENTER_CARD_Shield(self, buff, arg1, arg2, over)
    AddShield(self, arg2)
end

function SCR_BUFF_TAKEDMG_CARD_Shield(self, buff, sklID, damage, attacker)
   local shieldValue = GetShield(self);
   if shieldValue <= 0 then
       return 0;
   end
   
   SetBuffArg(self, buff, shieldValue, 0, 0);
   return 1;
end

function SCR_BUFF_LEAVE_CARD_Shield(self, buff, arg1, arg2, over)
    local currentShield = GetShield(self)
    AddShield(self, -currentShield)
    RemoveBuff(self, "CARD_Shield")
end

function SCR_BUFF_ENTER_DRUG_LOOTINGCHANCE(self, buff, arg1, arg2, over)

    self.LootingChance_BM = self.LootingChance_BM + arg1;

end

function SCR_BUFF_LEAVE_DRUG_LOOTINGCHANCE(self, buff, arg1, arg2, over)

    self.LootingChance_BM = self.LootingChance_BM - arg1;

end
function SCR_BUFF_ENTER_STATUE_LOOTINGCHANCE(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM + 100;
end

function SCR_BUFF_LEAVE_STATUE_LOOTINGCHANCE(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM - 100;
end

function SCR_BUFF_ENTER_SNOW_FLOWER_EFFECT(self, buff, arg1, arg2, over)
    OverrideSurfaceType(self, 'snow_flower')
end

function SCR_BUFF_LEAVE_SNOW_FLOWER_EFFECT(self, buff, arg1, arg2, over)
    OverrideSurfaceType(self, 'None')
end

function SCR_BUFF_ENTER_PET_GOLD_DOG_BUFF(self, buff, arg1, arg2, over)
    self.Holy_Atk_BM = self.Holy_Atk_BM + 120;
end

function SCR_BUFF_LEAVE_PET_GOLD_DOG_BUFF(self, buff, arg1, arg2, over)
    self.Holy_Atk_BM = self.Holy_Atk_BM - 120;
end

function SCR_BUFF_ENETER_Potion_Demon_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Potion_Demon_DMG_DOWN_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 30000 then
        SetBuffRemainTime(self, buff.ClassName, 30000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Demon_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_MIX_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Potion_MIX_DMG_DOWN_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 30000 then
        SetBuffRemainTime(self, buff.ClassName, 30000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_MIX_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_Bug_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Potion_Bug_DMG_DOWN_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 30000 then
        SetBuffRemainTime(self, buff.ClassName, 30000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Bug_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_Plant_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Potion_Plant_DMG_DOWN_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 30000 then
        SetBuffRemainTime(self, buff.ClassName, 30000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Plant_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_Wild_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Potion_Wild_DMG_DOWN_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 30000 then
        SetBuffRemainTime(self, buff.ClassName, 30000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Wild_DMG_DOWN_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_Demon_DMG_UP_Buff(self, buff, target, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Potion_Demon_DMG_UP_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 10000 then
        SetBuffRemainTime(self, buff.ClassName, 10000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Demon_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_MIX_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Potion_MIX_DMG_UP_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 10000 then
        SetBuffRemainTime(self, buff.ClassName, 10000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_MIX_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_Bug_DMG_UP_Buff(self, buff, target, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Potion_Bug_DMG_UP_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 10000 then
        SetBuffRemainTime(self, buff.ClassName, 10000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Bug_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_Plant_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Potion_Plant_DMG_UP_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 10000 then
        SetBuffRemainTime(self, buff.ClassName, 10000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Plant_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENETER_Potion_Wild_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Potion_Wild_DMG_UP_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 10000 then
        SetBuffRemainTime(self, buff.ClassName, 10000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Potion_Wild_DMG_UP_Buff(self, buff, target, arg1, arg2, over)
end

function SCR_BUFF_ENTER_GOOD_STAMP_EFFECT(self, buff, arg1, arg2, over)
    OverrideSurfaceType(self, 'good_stamp')
    PlayEffect(self, "F_pc_welldone_ground", 1.5, 1.5, 'BOT')
end

function SCR_BUFF_LEAVE_GOOD_STAMP_EFFECT(self, buff, arg1, arg2, over)
    OverrideSurfaceType(self, 'None')
end

function SCR_BUFF_ENTER_COSTUME_VELCOFFER_SET(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_COSTUME_VELCOFFER_SET(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_STATUE_LOOTINGCHANCE_1(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM + 100;
end

function SCR_BUFF_LEAVE_STATUE_LOOTINGCHANCE_1(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM - 100;
end

function SCR_BUFF_ENTER_STATUE_LOOTINGCHANCE_2(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM + 300;
end

function SCR_BUFF_LEAVE_STATUE_LOOTINGCHANCE_2(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM - 300;
end

function SCR_BUFF_ENTER_STATUE_LOOTINGCHANCE_3(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM + 500;
end

function SCR_BUFF_LEAVE_STATUE_LOOTINGCHANCE_3(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM - 500;
end

function SCR_BUFF_ENTER_BEAUTY_HAIR_BUFF(self, buff, arg1, arg2, over)
        AddLimitationSkillList(self, "Normal_Attack");
    EnableItemUse(self, 0)
end

function SCR_BUFF_UPDATE_BEAUTY_HAIR_BUFF(self, buff, arg1, arg2, over)
    local zoneCheck = GetZoneName(self)
    if zoneCheck == "c_barber_dress" then
        return 1;
    else
        RemoveBuff(self, "BEAUTY_HAIR_BUFF")
    end
end

function SCR_BUFF_LEAVE_BEAUTY_HAIR_BUFF(self, buff, arg1, arg2, over)
    ClearLimitationSkillList(self)
    EnableItemUse(self, 1)
end

function SCR_BUFF_ENTER_BEAUTY_HAIR_BUY_BUFF(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 1;
    self.LootingChance_BM = self.LootingChance_BM + 50;
end

function SCR_BUFF_UPDATE_BEAUTY_HAIR_BUY_BUFF(self, buff, arg1, arg2, RemainTime, over)
    return 1;
end

function SCR_BUFF_LEAVE_BEAUTY_HAIR_BUY_BUFF(self, buff, arg1, arg2, over)
    ClearLimitationSkillList(self)
    self.MSPD_BM = self.MSPD_BM - 1;
    self.LootingChance_BM = self.LootingChance_BM - 50;
end


function SCR_BUFF_ENTER_PET_WEDDING_BIRD_BUFF(self, buff, arg1, arg2, over)
    self.Fire_Atk_BM = self.Fire_Atk_BM + 120;
end

function SCR_BUFF_LEAVE_PET_WEDDING_BIRD_BUFF(self, buff, arg1, arg2, over)
    self.Fire_Atk_BM = self.Fire_Atk_BM - 120;
end