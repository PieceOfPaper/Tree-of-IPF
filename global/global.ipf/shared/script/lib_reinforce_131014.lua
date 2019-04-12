function GET_REINFORCE_131014_PRICE(fromItem, moruItem, pc)
    if moruItem.ClassName == "Moru_Potential" or moruItem.ClassName == "Moru_Potential14d" then
        return 0;
    end

    local reinforcecount = TryGetProp(fromItem, "Reinforce_2");
    if reinforcecount == nil then
        return 0;
    end
    
    local reinforcecount_diamond = reinforcecount - 1;

    if reinforcecount_diamond < 0 then
        reinforcecount_diamond = 0;
    end
    
    local slot = TryGetProp(fromItem, "DefaultEqpSlot");
    if slot == nil then
        return 0;
    end
    
    local grade = TryGetProp(fromItem, "ItemGrade");
    if grade == nil then
        return 0;
    end
    
    local gradeRatio = SCR_GET_ITEM_GRADE_RATIO(grade, "ReinforceCostRatio");
    
    local lv = TryGetProp(fromItem, "UseLv");
    if lv == nil then
        return 0;
    end
    
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        local kupoleItemLv = SRC_KUPOLE_GROWTH_ITEM(fromItem, 0);
        if kupoleItemLv ==  nil then
            lv = lv;
        elseif kupoleItemLv > 0 then
            lv = kupoleItemLv;
        end
    end
    
    local value, value_diamond = 0, 0;

    local priceRatio = 1;

    if slot == 'RH' or slot == 'RH LH' then
        if fromItem.DBLHand == 'YES' then
            priceRatio = 1.2;
        else
            priceRatio = 1;
        end
    elseif slot == 'LH' then
        if fromItem.ClassType == 'Shield' then
            priceRatio = 0.66;
        else
            priceRatio = 0.8;
        end
    elseif slot == 'SHIRT' or slot == 'PANTS' or slot == 'GLOVES' or slot == 'BOOTS' then
        priceRatio = 0.75;
    elseif slot == 'NECK' or slot == 'RING' then
        priceRatio = 0.5;
    else
        return 0;
    end

    
    value = math.floor((500 + (lv ^ 1.1 * (5 + (reinforcecount * 2.5)))) * (2 + (math.max(0, reinforcecount - 9) * 0.5))) * priceRatio * gradeRatio;
    value_diamond = math.floor((500 + (lv ^ 1.1 * (5 + (reinforcecount_diamond * 2.5)))) * (2 + (math.max(0, reinforcecount - 9) * 0.5))) * priceRatio * gradeRatio;

    if moruItem.ClassName == "Moru_Platinum_Premium" then
        value = value / 2;
    end
    
    if moruItem.ClassName == "Moru_Silver" or moruItem.ClassName == "Moru_Silver_test" or moruItem.ClassName == "Moru_Silver_NoDay" or moruItem.ClassName == "Moru_Silver_TA" or moruItem.ClassName == "Moru_Silver_TA2" or moruItem.ClassName == "Moru_Silver_Event_1704" or moruItem.ClassName == 'Moru_Silver_TA_Recycle' or moruItem.ClassName == 'Moru_Silver_TA_V2' or moruItem.ClassName == 'Moru_Silver_DLC' then 
        value = 0;
    end

    if moruItem.ClassName == "Moru_Gold_TA" or moruItem.ClassName == "Moru_Gold_TA_NR" or moruItem.ClassName == "Moru_Gold_EVENT_1710_NEWCHARACTER" then 
        value = 0;
    end
    
    if moruItem.ClassName == "Moru_Event160609" or moruItem.ClassName == "Moru_Event160929_14d" then
        value = 0;
    end
    if moruItem.ClassName == "Moru_Potential" or moruItem.ClassName == "Moru_Potential14d" then
        value = 0;
    end

    if moruItem.StringArg == 'DIAMOND' and reinforcecount > 1 then
        value = value + (value_diamond * 2.1)
    end
  
    if SCR_EVENT_REINFORCE_DISCOUNT_CHECK(pc) == 'YES' then
        value = value/2
    end
    
    return SyncFloor(value);

end