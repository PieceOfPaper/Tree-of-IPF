-- item_calculate.lua

function INIT_WEAPON_PROP(item, class)

    item.MINATK = class.MINATK;
    item.MAXATK = class.MAXATK;
    item.ADD_MINATK = class.ADD_MINATK;
    item.ADD_MAXATK = class.ADD_MAXATK;
    item.ADD_MATK = class.ADD_MATK;
    item.ADD_DEF = class.ADD_DEF;
    item.ADD_MDEF = class.ADD_MDEF;
    item.DEF = class.DEF;
    item.MDEF = class.MDEF;

    item.PATK = class.PATK;
    item.MATK = class.MATK;
    item.CRTHR = class.CRTHR;
    item.CRTATK = class.CRTATK;
    item.CRTDR = class.CRTDR;
    item.HR = class.HR;
    item.DR = class.DR;
    item.ADD_HR = class.ADD_HR;
    item.ADD_DR = class.ADD_DR;
    item.STR = class.STR;
    item.DEX = class.DEX;
    item.CON = class.CON;
    item.INT = class.INT;
    item.MNA = class.MNA;
    item.SR = class.SR;
    item.SDR = class.SDR;
    item.MHR = class.MHR;
    item.ADD_MHR = class.ADD_MHR;
    item.MDEF = class.MDEF;
    item.MGP = class.MGP;
    item.AddSkillMaxR = class.AddSkillMaxR;
    item.SkillRange = class.SkillRange;
    item.SkillAngle = class.SkillAngle;
    item.BlockRate = class.BlockRate;
    item.BLK = class.BLK;
    item.BLK_BREAK = class.BLK_BREAK;
    item.MSPD = class.MSPD;
    item.KDPow = class.KDPow;
    item.MHP = class.MHP;
    item.MSP = class.MSP;
    item.MSTA = class.MSTA;
    item.RHP = class.RHP;
    item.RSP = class.RSP;
    item.RSPTIME = class.RSPTIME;
    item.RSTA = class.RSTA;
    item.ADD_CLOTH = class.ADD_CLOTH;
    item.ADD_LEATHER = class.ADD_LEATHER;
    item.ADD_CHAIN = class.ADD_CHAIN;
    item.ADD_IRON = class.ADD_IRON;
    item.ADD_GHOST = class.ADD_GHOST;
    item.ADD_SMALLSIZE = class.ADD_SMALLSIZE;
    item.ADD_MIDDLESIZE = class.ADD_MIDDLESIZE;
    item.ADD_LARGESIZE = class.ADD_LARGESIZE;
    item.ADD_FORESTER = class.ADD_FORESTER;
    item.ADD_WIDLING = class.ADD_WIDLING;
    item.ADD_VELIAS = class.ADD_VELIAS;
    item.ADD_PARAMUNE = class.ADD_PARAMUNE;
    item.ADD_KLAIDA = class.ADD_KLAIDA;
    item.Aries = class.Aries;
    item.Slash = class.Slash;
    item.Strike = class.Strike;
    item.AriesDEF = class.AriesDEF;
    item.SlashDEF = class.SlashDEF;
    item.StrikeDEF = class.StrikeDEF;
    item.ADD_FIRE = class.ADD_FIRE;
    item.ADD_ICE = class.ADD_ICE;
    item.ADD_POISON = class.ADD_POISON;
    item.ADD_LIGHTNING = class.ADD_LIGHTNING;
    item.ADD_SOUL = class.ADD_SOUL;
    item.ADD_EARTH = class.ADD_EARTH;
    item.ADD_HOLY = class.ADD_HOLY;
    item.ADD_DARK = class.ADD_DARK;
    item.RES_FIRE = class.RES_FIRE;
    item.RES_ICE = class.RES_ICE;
    item.RES_POISON = class.RES_POISON;
    item.RES_LIGHTNING = class.RES_LIGHTNING;
    item.RES_SOUL = class.RES_SOUL;
    item.RES_EARTH = class.RES_EARTH;
    item.RES_HOLY = class.RES_HOLY;
    item.RES_DARK = class.RES_DARK;

end

function INIT_ARMOR_PROP(item, class)

    item.DEF = class.DEF;
    item.MDEF = class.MDEF;
    item.ADD_DEF = class.ADD_DEF;
    item.ADD_MDEF = class.ADD_MDEF;
    item.ADD_MINATK = class.ADD_MINATK;
    item.ADD_MAXATK = class.ADD_MAXATK;
    item.ADD_MATK = class.ADD_MATK;
    item.MINATK = class.MINATK;
    item.MAXATK = class.MAXATK;
    
    item.PATK = class.PATK;
    item.MATK = class.MATK;
    item.CRTHR = class.CRTHR;
    item.CRTATK = class.CRTATK;
    item.CRTDR = class.CRTDR;
    item.HR = class.HR;
    item.DR = class.DR;
    item.ADD_HR = class.ADD_HR;
    item.ADD_DR = class.ADD_DR;
    item.STR = class.STR;
    item.DEX = class.DEX;
    item.CON = class.CON;
    item.INT = class.INT;
    item.MNA = class.MNA;
    item.SR = class.SR;
    item.SDR = class.SDR;
    item.MHR = class.MHR;
    item.ADD_MHR = class.ADD_MHR;
    item.MGP = class.MGP;
    item.AddSkillMaxR = class.AddSkillMaxR;
    item.SkillRange = class.SkillRange;
    item.SkillAngle = class.SkillAngle;
    item.BlockRate = class.BlockRate;
    item.BLK = class.BLK;
    item.BLK_BREAK = class.BLK_BREAK;
    item.MSPD = class.MSPD;
    item.KDPow = class.KDPow;
    item.MHP = class.MHP;
    item.MSP = class.MSP;
    item.MSTA = class.MSTA;
    item.RHP = class.RHP;
    item.RSP = class.RSP;
    item.RSPTIME = class.RSPTIME;
    item.RSTA = class.RSTA;
    item.ADD_CLOTH = class.ADD_CLOTH;
    item.ADD_LEATHER = class.ADD_LEATHER;
    item.ADD_CHAIN = class.ADD_CHAIN;
    item.ADD_IRON = class.ADD_IRON;
    item.ADD_GHOST = class.ADD_GHOST;
    item.ADD_SMALLSIZE = class.ADD_SMALLSIZE;
    item.ADD_MIDDLESIZE = class.ADD_MIDDLESIZE;
    item.ADD_LARGESIZE = class.ADD_LARGESIZE;
    item.ADD_FORESTER = class.ADD_FORESTER;
    item.ADD_WIDLING = class.ADD_WIDLING;
    item.ADD_VELIAS = class.ADD_VELIAS;
    item.ADD_PARAMUNE = class.ADD_PARAMUNE;
    item.ADD_KLAIDA = class.ADD_KLAIDA;
    item.Aries = class.Aries;
    item.Slash = class.Slash;
    item.Strike = class.Strike;
    item.AriesDEF = class.AriesDEF;
    item.SlashDEF = class.SlashDEF;
    item.StrikeDEF = class.StrikeDEF;
    item.ADD_FIRE = class.ADD_FIRE;
    item.ADD_ICE = class.ADD_ICE;
    item.ADD_POISON = class.ADD_POISON;
    item.ADD_LIGHTNING = class.ADD_LIGHTNING;
    item.ADD_SOUL = class.ADD_SOUL;
    item.ADD_EARTH = class.ADD_EARTH;
    item.ADD_HOLY = class.ADD_HOLY;
    item.ADD_DARK = class.ADD_DARK;
    item.RES_FIRE = class.RES_FIRE;
    item.RES_ICE = class.RES_ICE;
    item.RES_POISON = class.RES_POISON;
    item.RES_LIGHTNING = class.RES_LIGHTNING;
    item.RES_SOUL = class.RES_SOUL;
    item.RES_EARTH = class.RES_EARTH;
    item.RES_HOLY = class.RES_HOLY;
    item.RES_DARK = class.RES_DARK;
    
end

function GET_REINFORCE_ADD_VALUE_ATK(item, ignoreReinf, reinfBonusValue, basicTooltipProp)
    if basicTooltipProp == nil then
        basicTooltipProp = item.BasicTooltipProp;
    end
    if ignoreReinf == 1 then
        return 0;
    end
    if reinfBonusValue == nil then
        reinfBonusValue = 0;
    end

    local buffValue = TryGetProp(item,"BuffValue");
    if buffValue == nil then
        buffValue = 0;
    end
    
    local lv = TryGetProp(item,"UseLv");
    if lv == nil then
        return 0;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 0);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local value = 0;
    
    local grade = TryGetProp(item,"ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "ReinforceRatio")
    
    local reinforceValue = TryGetProp(item,"Reinforce_2")
    if reinforceValue == nil then
        return 0;
    end
    
    local reinforceRatio = TryGetProp(item,"ReinforceRatio");
    if reinforceRatio == nil then
        return 0;
    end
    
    reinforceValue = reinforceValue + reinfBonusValue
    
    value = math.floor((reinforceValue + (lv * (reinforceValue * (0.08 + (math.floor((math.min(21,reinforceValue)-1)/5) * 0.015 ))))));
    value = value * (reinforceRatio / 100) * gradeRatio + buffValue;
    value = SyncFloor(value);
    return math.floor(value);
end

function GET_SOCKET_ADD_VALUE(item, i)
    local socket = item['Socket_' .. i]
    local gem = item['Socket_Equip_' .. i]
    local gemExp = item['SocketItemExp_' .. i]
    local gemLv = item['Socket_JamLv_' ..i]

    if socket <= 0 then
        return;
    end
    if gem == 0 then
        return;
    end
    
    local props = {};
    local gemclass = GetClassByType("Item", gem);
    local lv = GET_ITEM_LEVEL_EXP(gemclass, gemExp);
    local prop = geItemTable.GetProp(gem);
    local socketProp = prop:GetSocketPropertyByLevel(lv);
    local type = item.ClassID;
    local benefitCnt = socketProp:GetPropCountByType(type);
    for i = 0 , benefitCnt - 1 do
        local benefitProp = socketProp:GetPropAddByType(type, i);
        props[#props + 1] = {benefitProp:GetPropName(), benefitProp.value}
    end
    
    local penaltyCnt = socketProp:GetPropPenaltyCountByType(type);
    local penaltyLv = lv - gemLv;
    if 0 > penaltyLv then
        penaltyLv = 0;
    end
    local socketPenaltyProp = prop:GetSocketPropertyByLevel(penaltyLv);
    for i = 0 , penaltyCnt - 1 do
        local penaltyProp = socketPenaltyProp:GetPropPenaltyAddByType(type, i);
        local value = penaltyProp.value
        penaltyProp:GetPropName()
        props[#props + 1] = {penaltyProp:GetPropName(), penaltyProp.value}
    end
    return props;
end

function GET_ITEM_SOCKET_ADD_VALUE(targetPropName, item)
    local value = 0;
    local sockets = {};
    for i=0, item.MaxSocket-1 do
        sockets[#sockets + 1] = GET_SOCKET_ADD_VALUE(item, i)
    end

    for i = 1, #sockets do
        local props = sockets[i];
        for j = 1, #props do
            local prop = props[j]
            if prop[1] == targetPropName then                
                value = value + prop[2];
            end
        end
    end

    return value;
end

function GET_REINFORCE_ADD_VALUE(prop, item, ignoreReinf, reinfBonusValue)
    if ignoreReinf == 1 then
        return 0;
    end
    if reinfBonusValue == nil then
        reinfBonusValue = 0;
    end
    local value = 0;
    local buffValue =  TryGetProp(item,"BuffValue");
    if buffValue == nil then
        return 0;
    end
    
    local reinforceValue = TryGetProp(item,"Reinforce_2");
    if reinforceValue == nil then
        return 0;
    end
    
    local lv = TryGetProp(item, "UseLv");
    if lv == nil then
        return 0;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end
    
    local grade = TryGetProp(item,"ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "ReinforceRatio")
    
    local typeRatio;
    
    if classType == 'Shirt' or classType == 'Pants' or classType == 'Shield' then
        typeRatio = 3.5;
    elseif classType == 'Gloves' or classType == 'Boots' then
        typeRatio = 4.5;
    elseif classType == 'Neck' then
        typeRatio = 5.5;
    elseif classType == 'Ring' then
        typeRatio = 11;
    else
        return 0;
    end
    
    local value;
    
    reinforceValue = reinforceValue + reinfBonusValue;
    
    value = math.floor((reinforceValue + (lv * (reinforceValue * (0.08 + (math.floor((math.min(21,reinforceValue)-1)/5) * 0.015 )))) / typeRatio)) * gradeRatio;
    value = value * (item.ReinforceRatio / 100) + buffValue;

    return SyncFloor(value);
end

function GET_BASIC_ATK(item)
    local lv = TryGetProp(item,"UseLv");
    if lv == nil then
        return 0;
    end
    
    local hiddenLv = TryGetProp(item,"ItemLv");        
    if hiddenLv > 0 then
        lv = hiddenLv;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item , 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local grade = TryGetProp(item, "ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "BasicRatio");
    local itemATK = (20 + ((lv)*3)) * gradeRatio;
    if lv == 0 then
        itemATK = 0;
    end

    local slot = TryGetProp(item,"DefaultEqpSlot");
    if slot == nil then
        return 0;
    end
    
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end
    
    local damageRange = TryGetProp(item,"DamageRange")/100;
    if damageRange == nil then
        return 0;
    end
    
    if slot == "RH" then
        if classType == 'THSpear' then
            itemATK = itemATK * 1.3;
        elseif classType == 'Spear' then
            itemATK = itemATK * 1.1;
        elseif classType == 'Mace' then
            itemATK = itemATK * 0.9;
        elseif classType == 'Bow' or classType == 'Rapier' then
            itemATK = itemATK * 1.0;
        else
            itemATK = itemATK * 1.2;
        end
   elseif slot == "RH LH" then
       if classType == 'Sword' then
           itemATK = itemATK * 1.0;
       end
   elseif slot == "LH" then
        if classType == 'Cannon' then
            itemATK = itemATK * 1.1;
        elseif classType == 'Pistol' then
            itemATK = itemATK * 1.0;
        else
            itemATK = itemATK * 0.9;
        end
    else
        return 0;
    end

    local maxAtk = SyncFloor(itemATK * damageRange);
    local minAtk = SyncFloor(itemATK * (2 - damageRange));
    return maxAtk, minAtk;
end

function GET_BASIC_MATK(item)
    local grade = TryGetProp(item, "ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local lv = TryGetProp(item,"UseLv");
    if lv == nil then
        return 0;
    end
    
    if lv == 0 then
        itemATK = 0;
    end
    
    local hiddenLv = TryGetProp(item,"ItemLv");        
    if hiddenLv == nil then
        return 0;
    end
    
    if hiddenLv > 0 then
        lv = hiddenLv 
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end

    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "BasicRatio");
    local itemATK = (20 + ((lv)*3)) * gradeRatio;
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end
    
    if classType == 'THStaff' then
        itemATK = itemATK * 1.2;
    elseif classType == 'Staff' then
        itemATK = itemATK * 1.0;
    elseif classType == 'Mace' then
        itemATK = itemATK * 0.9;
    else
        return 0;
    end
    
    return itemATK;
end

function SCR_REFRESH_WEAPON(item, enchantUpdate, ignoreReinfAndTranscend, reinfBonusValue)
    if nil == enchantUpdate then
        enchantUpdate = 0;
    end
    
    if ignoreReinfAndTranscend == nil then
        ignoreReinfAndTranscend = 0;
    end
    
    if reinfBonusValue == nil then
        reinfBonusValue = 0;
    end
    
    local class = GetClassByType('Item', item.ClassID);
    INIT_WEAPON_PROP(item, class);
    item.Level = GET_ITEM_LEVEL(item);
    
    local star = item.ItemStar;
    local basicTooltipPropList = StringSplit(item.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicProp = basicTooltipPropList[i];
        local upgradeRatio = 1 + GET_UPGRADE_ADD_ATK_RATIO(item, ignoreReinfAndTranscend) / 100;
        local zero = 0;
        local buffarg = 0;
        
        if enchantUpdate == 1 then
            buffarg = GetExProp(item, "Rewards_BuffValue");
        end
        
        if basicProp == 'ATK' then
            item.MAXATK, item.MINATK = GET_BASIC_ATK(item);
            
            local reinforceAddValueAtk = GET_REINFORCE_ADD_VALUE_ATK(item, ignoreReinfAndTranscend, reinfBonusValue, basicProp);            
            item.MAXATK = (item.MAXATK * upgradeRatio)  + buffarg + reinforceAddValueAtk;
            item.MINATK = (item.MINATK * upgradeRatio)  + buffarg + reinforceAddValueAtk;
            
            if zero ~= item.MAXATK_AC then
                item.MAXATK = item.MAXATK + item.MAXATK_AC;
            end
            
            if zero ~= item.MINATK_AC then
                item.MINATK = item.MINATK + item.MINATK_AC;
            end
        elseif basicProp == 'MATK' then
            item.MATK = GET_BASIC_MATK(item);
            
            local reinfAddValueAtk = GET_REINFORCE_ADD_VALUE_ATK(item, ignoreReinfAndTranscend, reinfBonusValue, basicProp);
            item.MATK = (item.MATK * upgradeRatio)  + buffarg + reinfAddValueAtk;
            
            if zero ~= item.MAXATK_AC then
                item.MATK = item.MATK + item.MAXATK_AC;
            end
        end
    end
    
    item.MINATK = math.floor(item.MINATK);
    item.MAXATK = math.floor(item.MAXATK);
    item.MATK = math.floor(item.MATK);
    APPLY_OPTION_SOCKET(item);
    APPLY_AWAKEN(item);
    APPLY_ENCHANTCHOP(item);
    if item.MINATK < 0 then
        item.MINATK = 0;
    end
    
    if item.MAXATK < 0 then
        item.MAXATK = 0;
    end
    
    MakeItemOptionByOptionSocket(item);
end

function SCR_REFRESH_ARMOR(item, enchantUpdate, ignoreReinfAndTranscend, reinfBonusValue)
    if enchantUpdate == nil then
        enchantUpdate = 0
    end
    
    if ignoreReinfAndTranscend == nil then
        ignoreReinfAndTranscend = 0;
    end
    
    if reinfBonusValue == nil then
        reinfBonusValue = 0;
    end
    
    local class = GetClassByType('Item', item.ClassID);
    INIT_ARMOR_PROP(item, class);
    item.Level = GET_ITEM_LEVEL(item);
    
    local lv = TryGetProp(item , "UseLv");
    if lv == nil then
        return 0;
    end
    local hiddenLv = TryGetProp(item, "ItemLv");
    if hiddenLv == nil then
        return 0;
    end
    
    if hiddenLv > 0 then
        lv = hiddenLv;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local def=0;
    local hr =0;
    local dr =0;
    local mhr=0;
    local mdef=0;
    local fireAtk = 0;
    local iceAtk = 0;
    local lightningAtk = 0;
    local defRatio = 0;
    local mdefRatio = 0;
    
    local basicTooltipPropList = StringSplit(item.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicProp = basicTooltipPropList[i];
        
        local buffarg = 0;
        
        local grade = TryGetProp(item,"ItemGrade");
        if grade == nil then
            return 0;
        end
          
        local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "BasicRatio");
          
        if enchantUpdate == 1 then
            buffarg = GetExProp(item, "Rewards_BuffValue");
        end
        
        local equipMaterial = TryGetProp(item, "Material");
        if equipMaterial == nil then
            return 0;
        end
        
        local classType = TryGetProp(item,"ClassType");
        if classType == nil then
            return 0;
        end
        local equipRatio;
        
        if classType == 'Shirt' or classType == 'Pants' or classType == 'Shield'then
                equipRatio = 3.5;
        elseif classType == 'Boots' or classType == 'Gloves' then
                equipRatio = 4.5;
        else
            return 0;
        end
        
        local upgradeRatio = 1;        
        if basicProp == 'DEF' then
            def = ((20 + lv*3)/equipRatio) * gradeRatio;
            upgradeRatio = upgradeRatio + GET_UPGRADE_ADD_DEF_RATIO(item, ignoreReinfAndTranscend) / 100;            
            if item.Material == 'Cloth' then
                def = def * 0.6;
            elseif equipMaterial == 'Leather' then
                def = def * 0.6;
            elseif equipMaterial == 'Iron' then
                def = def * 1.0;
            end
           
            if def < 1 then
                def = 1;
            end
            
            def = math.floor(def) * upgradeRatio + GET_REINFORCE_ADD_VALUE(basicProp, item, ignoreReinfAndTranscend, reinfBonusValue) + buffarg
            def = SyncFloor(def);
            
        elseif basicProp == 'MDEF' then
            mdef = ((20 + lv*3)/equipRatio) * gradeRatio;
            upgradeRatio = upgradeRatio + GET_UPGRADE_ADD_MDEF_RATIO(item, ignoreReinfAndTranscend) / 100;
            if equipMaterial == 'Cloth' then
                mdef = mdef * 1.0;
            elseif equipMaterial == 'Leather' then
                mdef = mdef * 0.6;
            elseif equipMaterial == 'Iron' then
                mdef = mdef * 0.6;
            end
            
            if mdef < 1 then
                mdef = 1;
            end
    
           mdef = math.floor(mdef) * upgradeRatio + GET_REINFORCE_ADD_VALUE(basicProp, item, ignoreReinfAndTranscend, reinfBonusValue) + buffarg
           mdef = SyncFloor(mdef);
        end
    end

    item.HR = hr;
    item.DR = dr;
    item.DEF = def;
    item.MHR = mhr;
    item.MDEF = mdef;
    item.DefRatio = defRatio;
    item.MDefRatio = mdefRatio;
    item.ADD_FIRE = fireAtk;
    item.ADD_ICE = iceAtk;
    item.ADD_LIGHTNING = lightningAtk;




    APPLY_AWAKEN(item);
    APPLY_ENCHANTCHOP(item);
    MakeItemOptionByOptionSocket(item);

end

function SCR_REFRESH_ACC(item, enchantUpdate, ignoreReinfAndTranscend)
    if ignoreReinfAndTranscend == nil then
        ignoreReinfAndTranscend = 0;
    end

    local class = GetClassByType('Item', item.ClassID);
    INIT_ARMOR_PROP(item, class);
    item.Level = GET_ITEM_LEVEL(item);

    local lv = TryGetProp(item, "UseLv");
    if lv == nil then
        return 0;
    end
    
    local hiddenLv = TryGetProp(item,"ItemLv");
    if hiddenLv == nil then
        return 0 ;
    end
    
    if hiddenLv > 0 then
        lv = hiddenLv;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(item, 1);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local classType = TryGetProp(item,"ClassType");
    if classType == nil then
        return 0;
    end
    
    local accRatio;
    
    if classType == 'Neck' then
        accRatio = 5.5;
    elseif classType == 'Ring' then
        accRatio = 11;
    elseif classType == 'Hat' then
        accRatio = 0;
    else
        return 0;
    end

    local grade = TryGetProp(item,"ItemGrade");
    if grade == nil then
            return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "BasicRatio");

    local PropName = {"DEF", "MDEF", "HR", "DR",  "MHR", "ADD_FIRE", "ADD_ICE", "ADD_LIGHTNING", "DefRatio", "MDefRatio"};
    local changeProp = {};
    
    local basicTooltipPropList = StringSplit(item.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicProp = basicTooltipPropList[i];
    
        if basicProp == 'DEF' then
            changeProp["DEF"] = ((20 + lv*3)/accRatio) * gradeRatio + GET_REINFORCE_ADD_VALUE(basicProp, item, ignoreReinfAndTranscend)
            changeProp["DEF"] = SyncFloor(changeProp["DEF"]);
            changeProp["DefRatio"] = math.floor(item.Reinforce_2 * 0.1);
        elseif basicProp == 'MDEF' then
            changeProp["MDEF"] = ((20 + lv*3)/accRatio) * gradeRatio + GET_REINFORCE_ADD_VALUE(basicProp, item, ignoreReinfAndTranscend)
            changeProp["MDEF"] = SyncFloor(changeProp["MDEF"]);
        elseif basicProp == 'ADD_FIRE' then
            changeProp["ADD_FIRE"] = math.floor(lv * gradeRatio + GET_REINFORCE_ADD_VALUE(basicProp, item, ignoreReinfAndTranscend));
            changeProp["ADD_FIRE"] = SyncFloor(changeProp["ADD_FIRE"]);
        elseif basicProp == 'ADD_ICE' then
            changeProp["ADD_ICE"] = math.floor(lv * gradeRatio + GET_REINFORCE_ADD_VALUE(basicProp, item, ignoreReinfAndTranscend));
            changeProp["ADD_ICE"] = SyncFloor(changeProp["ADD_ICE"]);
        elseif basicProp == 'ADD_LIGHTNING' then
            changeProp["ADD_LIGHTNING"] = math.floor(lv * gradeRatio + GET_REINFORCE_ADD_VALUE(basicProp, item, ignoreReinfAndTranscend));
            changeProp["ADD_LIGHTNING"] = SyncFloor(changeProp["ADD_LIGHTNING"]);
        end
    end

    for i = 1, #PropName do
        if changeProp[PropName[i]] ~= nil then
            if changeProp[PropName[i]] ~= 0 then
                item[PropName[i]] = changeProp[PropName[i]];
            end
        end
    end

    local propNames, propValues = GET_ITEM_TRANSCENDED_PROPERTY(item, ignoreReinfAndTranscend);
    for i = 1 , #propNames do
        local propName = propNames[i];
        local propValue = propValues[i];
        local upgradeRatio = 1 + propValue / 100;
        item[propName] = math.floor( item[propName] * upgradeRatio );
    end
    
    APPLY_AWAKEN(item);
    APPLY_ENCHANTCHOP(item);
    APPLY_OPTION_SOCKET(item);
    MakeItemOptionByOptionSocket(item);

end

function SCR_REFRESH_GEM(item)
    item.Level = GET_ITEM_LEVEL(item);
end

function SCR_REFRESH_CARD(item)
    item.Level = GET_ITEM_LEVEL(item);
end

function APPLY_OPTION_SOCKET(item)

    local curcnt = GET_SOCKET_CNT(item);
    if curcnt == 0 then
        return;
    end


    
    for i=0, curcnt-1 do
        local runeID = TryGetProp(item, 'Socket_Equip_' .. i);
        if runeID ~= nil and runeID > 0 then
            local runeItem = GetClassByType('Item', runeID);
            if runeItem ~= nil then
                if runeItem.StringArg ~= 'None' and item ~= nil then
                    local func = _G[runeItem.StringArg];
                    if func ~= nil then
                        func(item, runeItem.NumberArg1, runeItem.NumberArg2);
                    end
                end
            end
        end

    end
    
    curcnt = GET_OPTION_CNT(item);
    for i = 0 , curcnt - 1 do
        local optDur = item["OpDur_".. i];
        if optDur > 0 then
            local Opt = TryGetProp(item, 'Option_' .. i);
            local OptType = OPT_TYPE(Opt);
            local OptValue = OPT_VALUE(Opt);
            local cls = GetClassByType('Option', OptType);
            local scpname = cls.Script;
        
            if scpname ~= "None" then
                local optionscp = _G[scpname];
                optionscp(item, OptValue);
            end
        end
    end
end

function APPLY_ENCHANTCHOP(item)
    for i = 1, 3 do
        local propName = "HatPropName_"..i;
        local propValue = "HatPropValue_"..i;
        local getProp = TryGetProp(item, propName);
        if getProp ~= nil and item[propValue] ~= 0 and item[propName] ~= "None" then
            local prop = item[propName];
            local propData = item[prop]
            item[prop] = propData + item[propValue];
        end
    end
end

function APPLY_AWAKEN(item)
    if item.IsAwaken ~= 1 then
        return;
    end

    local hiddenProp = item.HiddenProp;
    item[hiddenProp] = item[hiddenProp] + item.HiddenPropValue;
end

function SCR_ENTER_AQUA(item, arg1, arg2)

    item.STR = item.STR + arg1;
end

function SCR_ENTER_TOPAZ(item, arg1, arg2)

    item.DEX = item.DEX + arg1;
end

function SCR_ENTER_RUBY(item, arg1, arg2)

    item.CON = item.CON + arg1;
end

function SCR_ENTER_PERI(item, arg1, arg2)

    item.INT = item.INT + arg1;
end


function SCR_OPT_ATK(item, optvalue)
    item.MINATK = item.MINATK + optvalue;
    item.MAXATK = item.MAXATK + optvalue;
end

function SCR_OPT_SR(item, optvalue)
    item.SR = item.SR + optvalue;
end

function SCR_OPT_DEF(item, optvalue)
    item.DEF = item.DEF + optvalue;
end

function SCR_OPT_RR(item, optvalue)
    item.RR = item.RR + optvalue;
end


function SCR_OPT_Aries(item, optvalue)
    item.Aries = item.Aries + optvalue;
end

function SCR_OPT_AriesDEF(item, optvalue)
    item.AriesDEF = item.AriesDEF + optvalue;
end

function SCR_OPT_Slash(item, optvalue)
    item.Slash = item.Slash + optvalue;
end

function SCR_OPT_SlashDEF(item, optvalue)
    item.SlashDEF = item.SlashDEF + optvalue;
end

function SCR_OPT_Strike(item, optvalue)
    item.Strike = item.Strike + optvalue;
end

function SCR_OPT_StrikeDEF(item, optvalue)
    item.StrikeDEF = item.StrikeDEF + optvalue;
end

function SCR_OPT_CRTHR(item, optvalue)
    item.CRTHR = item.CRTHR + optvalue;
end

function SCR_OPT_StunRate(item, optvalue)
    item.StunRate = item.StunRate + optvalue;
end

function SCR_OPT_KDBonus(item, optvalue)
    item.KDBonusDamage = item.KDBonusDamage + optvalue;
end

function SCR_OPT_CRTDR(item, optvalue)
    item.CRTDR = item.CRTDR + optvalue;
end

function SCR_OPT_STR(item, optvalue)
    item.STR = item.STR + optvalue;
end

function SCR_OPT_DEX(item, optvalue)
    item.DEX = item.DEX + optvalue;
end

function SCR_OPT_CON(item, optvalue)
    item.CON = item.CON + optvalue;
end

function SCR_OPT_INT(item, optvalue)
    item.INT = item.INT + optvalue;
end

function SCR_OPT_CRTATK(item, optvalue)
    item.CRTATK = item.CRTATK + optvalue;
end

function SCR_OPT_CRTDEF(item, optvalue)
    item.CRTDEF = item.CRTDEF + optvalue;
end

function SCR_OPT_HR(item, optvalue)
    item.HR = item.HR + optvalue;
end

function SCR_OPT_DR(item, optvalue)
    item.DR = item.DR + optvalue;
end

function SCR_OPT_MGP(item, optvalue)
    item.MGP = item.MGP + optvalue;
end

function SCR_OPT_MHP(item, optvalue)
    item.MHP = item.MHP + optvalue;
end

function SCR_OPT_MSP(item, optvalue)
    item.MSP = item.MSP + optvalue;
end

function SCR_OPT_RHP(item, optvalue)
    item.RHP = item.RHP + optvalue;
end

function SCR_OPT_RSP(item, optvalue)
    item.RSP = item.RSP + optvalue;
end

function SCR_OPT_ADDFIRE(item, optvalue)
    item.ADD_FIRE = item.ADD_FIRE + optvalue;
end

function SCR_OPT_RESFIRE(item, optvalue)
    item.RES_FIRE = item.RES_FIRE + optvalue;
end

function SCR_OPT_ADDICE(item, optvalue)
    item.ADD_ICE = item.ADD_ICE + optvalue;
end

function SCR_OPT_RESICE(item, optvalue)
    item.RES_ICE = item.RES_ICE + optvalue;
end

function SCR_OPT_ADDLIGHTNING(item, optvalue)
    item.ADD_LIGHTNING = item.ADD_LIGHTNING + optvalue;
end

function SCR_OPT_RESLIGHTNING(item, optvalue)
    item.RES_LIGHTNING = item.RES_LIGHTNING + optvalue;
end

function SCR_OPT_ADDSOUL(item, optvalue)
    item.ADD_SOUL = item.ADD_SOUL + optvalue;
end

function SCR_OPT_RESSOUL(item, optvalue)
    item.RES_SOUL = item.RES_SOUL + optvalue;
end

function SCR_OPT_ADDEARTH(item, optvalue)
    item.ADD_EARTH = item.ADD_EARTH + optvalue;
end

function SCR_OPT_RESEARTH(item, optvalue)
    item.RES_EARTH = item.RES_EARTH + optvalue;
end


function SCR_OPT_ADDPOISON(item, optvalue)
    item.ADD_POISON = item.ADD_POISON + optvalue;
end

function SCR_OPT_RESPOISON(item, optvalue)
    item.RES_POISON = item.RES_POISON + optvalue;
end

function SCR_OPT_ADDLIGHT(item, optvalue)
    item.ADD_LIGHT = item.ADD_LIGHT + optvalue;
end

function SCR_OPT_RESLIGHT(item, optvalue)
    item.RES_LIGHT = item.RES_LIGHT + optvalue;
end

function SCR_OPT_ADDDARK(item, optvalue)
    item.ADD_DARK = item.ADD_DARK + optvalue;
end

function SCR_OPT_RESDARK(item, optvalue)
    item.RES_DARK = item.RES_DARK + optvalue;
end

function SCR_OPT_VelniasATK(item, optvalue)
    item.VelniasATK = item.ADD_VELNIAS + optvalue;
end

function SCR_OPT_VelniasDEF(item, optvalue)
    item.VelniasDEF = item.RES_VELNIAS + optvalue;
end

function SCR_OPT_ForesterATK(item, optvalue)
    item.ForesterATK = item.ADD_FORESTER + optvalue;
end

function SCR_OPT_ForesterDEF(item, optvalue)
    item.ForesterDEF = item.RES_FORESTER + optvalue;
end

function SCR_OPT_ParamuneATK(item, optvalue)
    item.ParamuneATK = item.ADD_PARAMUNE + optvalue;
end

function SCR_OPT_ParamuneDEF(item, optvalue)
    item.ParamuneDEF = item.RES_PARAMUNE + optvalue;
end

function SCR_OPT_WidlingATK(item, optvalue)
    item.WidlingATK = item.ADD_WIDLING + optvalue;
end

function SCR_OPT_WidlingDEF(item, optvalue)
    item.WidlingDEF = item.RES_WIDLING + optvalue;
end

function OPT_CONSUME(optValue, skillResult)
    return 1;
end

function OPT_CRITICAL(optValue, skillResult)
    local resultType = skillResult:GetResultType();
    if resultType == 3 then
        return 1;
    end
    
    return 0;
end




function GET_REINFORCE_SEC(item, reinforce)
    local itemrank_weight
    local reinforce_sec
    
    local itemrank_num = item.ItemStar
    
    if itemrank_num < 2 then
        itemrank_weight = 2.5
    else
        itemrank_weight = 3.5
    end
    
    reinforce_sec = math.floor(((item.Reinforce + 1) ^ itemrank_weight) * item.UseLv)
    
    if reinforce_sec == 0 then
        reinforce_sec = 1
    end
    
    return reinforce_sec;

end

function GET_ITEM_REINF_REMAIN_TIME(pc, item, startTime, sysTime)

    local reinSec = GET_REINFORCE_SEC(item, item.Reinforce);
    local endTime = imcTime.AddSec(startTime, reinSec);
    local remainSec = imcTime.GetIntDifSec(endTime, sysTime);
    local perc = (reinSec - remainSec) * 100 /  math.abs(reinSec);
    return remainSec, math.max(perc, 0);
    
end

function GET_REINFORCE_PR(obj)

    return obj.PR;
    
end

function GET_APPRAISAL_PRICE(item, SellPrice)
    -- ???????ìº¿ì¶”ì´?Â¸??Î¼???
    local lv = TryGetProp(item,"UseLv");
    local grade = TryGetProp(item,"ItemGrade")
    local priceRatio = 100;
    if lv == nil then
        return 0;
    end

    if SellPrice == nil then
        if grade == 2 then
            SellPrice = lv * priceRatio
        else
            SellPrice = (lv * priceRatio) * 1.5
        end
    end
    return SellPrice;
end

function GET_REPAIR_PRICE(item, fillValue)
    local reinforceCount = TryGetProp(item, "Reinforce_2");
        if reinforceCount == nil then
            return 0;
        end
    local transcendCount = TryGetProp(item, "Transcend");
        if transcendCount == nil then
            return 0;
        end
    local lv = TryGetProp(item,"UseLv");
        if lv == nil then
            return 0;
        end
    local priceRatio = item.RepairPriceRatio / 100;
    local price = GetClassByType("Stat_Weapon", lv);
    local value;
    
    if item.DefaultEqpSlot == 'RH' or item.DefaultEqpSlot == 'RH LH' then
        if item.DBLHand == 'YES' then
            local stat_weapon = GetClassByType("Stat_Weapon", lv)
            value = stat_weapon.RepairPrice_THWeapon;
        else
            local stat_weapon = GetClassByType("Stat_Weapon", lv)
            value = stat_weapon.RepairPrice_Weapon;
        end
    elseif item.DefaultEqpSlot == 'LH' then
        local stat_weapon = GetClassByType("Stat_Weapon", lv)
        value = stat_weapon.RepairPrice_SubWeapon;

    elseif item.DefaultEqpSlot == 'SHIRT' then
        local stat_weapon = GetClassByType("Stat_Weapon", lv)
        value = stat_weapon.RepairPrice_SHIRT;

    elseif item.DefaultEqpSlot == 'PANTS' then
        local stat_weapon = GetClassByType("Stat_Weapon", lv)
        value = stat_weapon.RepairPrice_PANTS;

    elseif item.DefaultEqpSlot == 'GLOVES' then
        local stat_weapon = GetClassByType("Stat_Weapon", lv)
        value = stat_weapon.RepairPrice_GLOVES;

    elseif item.DefaultEqpSlot == 'BOOTS' then
        local stat_weapon = GetClassByType("Stat_Weapon", lv)
        value = stat_weapon.RepairPrice_BOOTS;

    elseif item.DefaultEqpSlot == 'NECK' then
        local stat_weapon = GetClassByType("Stat_Weapon", lv)
        value = stat_weapon.RepairPrice_NECK;

    elseif item.DefaultEqpSlot == 'RING' then
        local stat_weapon = GetClassByType("Stat_Weapon", lv)
        value = stat_weapon.RepairPrice_RING;
    end
    
    local reinforceRatio = (0.01 * reinforceCount);
    local transcendRatio = (0.1 * transcendCount);
    
    value = value * priceRatio * (1 + (item.ItemGrade - 1) * 0.1) * (1 + reinforceRatio + transcendRatio);
    return math.floor(value);
end

function GET_REPAIR_PRICE_BY_RANK(item, fillValue)

    local itemrank_num = item.ItemStar;
    local fee = itemrank_num * item.Price * fillValue / 10000;
    return math.ceil(fee);

end

function GET_ROP1_PRICE(item, fillValue)

    local fee = item.Price * fillValue / 10000;
    return math.ceil(fee);

end

function GET_ROP2_PRICE(item, fillValue)

    local fee = item.Price * fillValue / 10000;
    return math.ceil(fee);
    
end

function GET_OP_REFILL_PRICE(item, fillValue)

    local fee = item.Price * fillValue * 0.1;
    return math.ceil(fee);
end

function IS_NEED_REPAIR(item)

    if math.floor( (item.MaxDur - item.Dur) / DUR_DIV()) > 0 then
        return 1;
    end
    
    if math.floor( (item.MROp1 - item.ROp1) / DUR_DIV()) > 0 then
        return 1;
    end
    
    if math.floor( (item.MROp2 - item.ROp2) / DUR_DIV()) > 0 then
        return 1;
    end
    
    
    local optCnt = GET_OPTION_CNT(item);
    for i = 0 , optCnt - 1 do
        if item["OpDur_" .. i] < item["OpMDur_" .. i] then
            return 1;
        end
    end
    
    return 0;

end

function GET_AUCTION_START_PRICE(item)
    
    return math.max(1, item.SellPrice);

end

function GET_AUCTION_INCR_PRICE(item)
    
    return math.ceil(1, item.SellPrice / 10);

end

function GET_GEM_SOCKET_CNT(invitem, gemtype)

    if invitem.ItemType ~= 'Equip' then
        return 0;
    end


    for i = 0 , SKT_COUNT - 1 do
        local val = TryGetProp(invitem, "Socket_" .. i)     
        local val2 = TryGetPropProp(invitem, "Socket_Equip_" .. i)      
        if val == gemtype then
            return i;
        end
    end

    return -1;
end

function GET_MAGICAMULET_EMPTY_SOCKET_INDEX(invitem)

    if invitem.ItemType ~= 'Equip' then
        return 0;
    end

    for i = 0 , invitem.MaxSocket_MA - 1 do
        local val = GetIESProp(invitem, "MagicAmulet_" .. i)        
        if val == 0 then
            return i;
        end
    end

    return -1;
end

function GET_SOCKET_CNT(invitem)

    if invitem.ItemType ~= 'Equip' then
        return 0;
    end

    for i = 0 , SKT_COUNT - 1 do
        local val = TryGetProp(invitem, "Socket_" .. i)     
        if val == 0 then
            return i;
        end
    end

    return SKT_COUNT;
end

function GET_OPTION_CNT(invitem)

    if invitem.ItemType ~= "Equip" then
        return 0;
    end

    for i = 0 , OPT_COUNT - 1 do        
        local val = GetIESProp(invitem, "Option_" .. i)     
        if val == 0 then
            return i;
        end
    end

    return OPT_COUNT;
end

function GET_OPTION_TARGET_INDEX(invitem, optclass)

    local clsID = optclass.ClassID;
    local maxidx = invitem.MaxOption - 1;

    for i = 0 , maxidx do
        local val = invitem["Option_" .. i];
        if val == 0 then
            return i;
        end
    end

    return -1;
end


SOCKET_MAX = 10000;
OPT_MAX = 10000;

function BASIC_SOCKET(type)
    return type % SOCKET_MAX;
end

function CUR_SOCKET(type)
    return math.floor(type / SOCKET_MAX);
end

function GET_OPT(item, index)

    local optionValue = item["Option_" .. index];
    local opttype = OPT_TYPE(optionValue);
    local optvalue = OPT_VALUE(optionValue);
    local class = GetClassByType("Option", opttype);
    return opttype, optvalue, class;
    
end

function OPT_TYPE(type)
    return type % OPT_MAX;
end

function OPT_VALUE(type)
    return math.floor(type / OPT_MAX);
end

function IS_EQUIPITEM(ItemClassName)

    local itemObj = GetClass("Item", ItemClassName);
    if itemObj ~= nil and itemObj.ItemType == 'Equip' then
        return 1;
    end

    return 0;
end


function IS_PERSONAL_SHOP_TRADABLE(itemCls)
    if itemCls.GroupName == "Premium" then
        return 0;
    end

    local itemProp = geItemTable.GetPropByName(itemCls.ClassName);
    if itemProp:IsEnableUserTrade() == false or itemCls.ItemType == "Equip" then
        return 0;
    end

    if itemCls.ClassName == 'Default_Recipe' or itemCls.ClassName == 'Scroll_SkillItem' then
        return 0;
    end

    return 1;
end


function SCR_GET_ITEM_COOLDOWN(item)
  return item.ItemCoolDown;
end

function SCR_GET_HP_COOLDOWN(item)
    local name = item.ClassName
  return item.ItemCoolDown;
end

function SCR_GET_HPSP_COOLDOWN(item)  
  return item.ItemCoolDown;
end

function SCR_GET_SP_COOLDOWN(item)  
  return item.ItemCoolDown;
end


function SCR_GET_AWAKENING_PROP_LEVEL(star, grade)

    local value = 0;
    
    if star == 1 then
        value = 15;
    elseif star == 2 then
        value = 40;
    elseif star == 3 then
        value = 75;
    elseif star == 4 then
        value = 120;
    else
        value = (star - 4 ) * 50 + 120;
    end
    
    value = value * (1 + (grade - 1) / 10);
    
    return value;
end

function SCR_GET_MAXPROP_DEF(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.1 * 0.4;
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end 

function SCR_GET_MAXPROP_DEFATTRIBUTE(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.1 * 0.5;
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ATK(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.12;
    
    if item.DBLHand == 'YES' then
        value = value * 1.4;
    end
    
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_STAT(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.1 * 0.5;
    
    if item.DBLHand == 'YES' then
        value = value * 1.4;
    end
    
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_MHP(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.08 * 34;
    
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_MSP(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.08 * 6.7;
    
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_RHP(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.2;
    
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_RSP(item)
    
    local star = item.ItemStar;
    local grade = item.ItemGrade;
    local value = SCR_GET_AWAKENING_PROP_LEVEL(star, grade);
    
    value = value * 0.2;
    
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function GET_KEYWORD_PROP_NAME(idx)

    if idx == 1 then
        return "KeyWord";
    end

    return "KeyWord_" .. idx;
end


function SCR_GET_MAXPROP_ENCHANT_DEF(item)
    
    local result = IMCRandom(41, 110)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end 

function SCR_GET_MAXPROP_ENCHANT_DEFATTRIBUTE(item)
    
    local result = IMCRandom(40, 84)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_ATK(item)
    
    local result = IMCRandom(61, 126)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_CRTATK(item)
    
    local result = IMCRandom(91, 189)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_ATTRIBUTEATK(item)

    local result = IMCRandom(46, 99)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_STAT(item)
    
    local value = 280;
    
    value = math.floor(value * 0.1 * 0.5);
    
    local result = IMCRandom(value * 0.5, value)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_MHP(item)
    
    
    local result = IMCRandom(1138, 2283)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_MSP(item)
    
    
    local result = IMCRandom(223, 450)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_RHP(item)
    
    local result = IMCRandom(28, 56)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_RSP(item)
    
    local result = IMCRandom(21, 42)
    
    if result < 1 then
        result = 1;
    end
    
    return math.floor(result);
end

function SCR_GET_MAXPROP_ENCHANT_MSPD(item)
    return 1;
end

function SCR_GET_MAXPROP_ENCHANT_SR(item)
    return 1;
end
function SCR_GET_MAXPROP_ENCHANT_SDR(item)
    return 4;
end

function IS_SAME_TYPE_GEM_IN_ITEM(invItem, gemType, sckCnt)

    if TryGetProp(invItem, "ItemType") ~= 'Equip' then
        return false
    end

    for i = 0 , sckCnt - 1 do
        if TryGetProp(invItem, "Socket_Equip_"..i) == gemType then
            return true
        end
    end

    return false

end

function GET_EMPTY_SOCKET_CNT(socketCnt, invItem)
    local emptyCnt = 0
    for i = 0, socketCnt - 1 do
        if TryGetProp(invItem, "Socket_Equip_"..i) == 0 then
            emptyCnt = emptyCnt + 1
        end
    end
    return emptyCnt
end

function SCR_GET_MAX_SOKET(item)
    return item.MaxSocket_COUNT + item.AppraisalSoket;
end

function SRC_KUPOLE_GROWTH_ITEM(item, Reinforce)
    -- ?í´ ?œë²„ ?„ì´?œì„ ?±ìž¥?•ìœ¼ë¡??œìž‘?˜ê¸° ?„í•œ ?¤í¬ë¦½íŠ¸ --
    local itemName = TryGetProp(item,"ClassName");
    if itemName == nil then
        return 0;
    end
    
    local lv  = TryGetProp(item,"ItemLv");
  
    if lv == nil then
        return 0;
    end
    
    local checkKupole = {'T_SWD01_137', 'T_TSW01_129',  'T_STF01_137',  'T_TBW01_137',  'T_BOW01_130',  'T_MAC01_136',  'T_SPR01_119',  'T_TSP01_111',  'T_TSF01_129',  'T_RAP01_103',  'T_TOP01_139',  'T_LEG01_139',  'T_FOOT01_139', 'T_HAND01_139', 'T_TOP01_140',  'T_LEG01_140',  'T_FOOT01_140', 'T_HAND01_140', 'T_TOP01_141',  'T_LEG01_141',  'T_FOOT01_141', 'T_HAND01_141', 'T_NECK100_101',    'T_BRC100_101', 'T_SHD100_101', 'T_DAG100_101', 'T_CAN100_101', 'T_PST100_101', 'T_MUS100_101'}
    
    for i = 1, #checkKupole do
        if checkKupole[i] == itemName then
            local pc = GetItemOwner(item);
            
            if pc == nil then
                return 0;
            end
            
            local pcLv = pc.Lv;
            
            if Reinforce == 1 then
                if pcLv < 220 then
                    lv = 220;
                elseif pcLv < 270 then
                    lv = 270;
                else 
                    lv = 315;
                end
            elseif Reinforce == 0 then
                lv = lv
            end
        end
    end
    return lv;
end



function SCR_GET_ITEM_GRADE_RATIO(grade, prop)
    local class = GetClassByNumProp("item_grade", "Grade", grade)
    if class == nil then
        return 0;
    end
    
    local value = TryGetProp(class, prop);
    if value == nil then
        return 0;
    end
    
    value = value / 100;
    
    return value;
end