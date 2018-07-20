---- lib_reinforce_131014.lua

function REINFORCE_ABLE_131014(item)
    
    if item.ItemType ~= 'Equip' then
        return 0;
    end

    if item.Reinforce_Type ~= "Moru" then
        return 0;
    end
    
    local prop = TryGetProp(item,"BasicTooltipProp");
    if prop == nil then
        return 0;
    end
    
    if prop ~= 'DEF' and prop ~= 'MDEF' and prop ~= 'ADD_FIRE' and prop ~= 'ADD_ICE' and prop ~= 'ADD_LIGHTNING' and prop ~= 'DEF;MDEF' and prop ~= 'ATK;MATK' and prop ~= 'MATK' and prop ~= 'ATK' then
        return 0;
	end

    return 1;
end

function GET_REINFORCE_131014_PRICE(fromItem, moruItem)
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
    local gradeRatio = { 1.0, 1.5, 2.5, 4.0 };
    if grade == nil then
        return 0;
    end
    
    local lv = TryGetProp(fromItem, "UseLv");
    if lv == nil then
        return 0;
    end
    
    local value = 0;

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

    
    value = math.floor((500 + (lv ^ 1.1 * (5 + (reinforcecount * 2.5)))) * (2 + (math.max(0, reinforcecount - 9) * 0.5))) * priceRatio * gradeRatio[grade];
    value_diamond = math.floor((500 + (lv ^ 1.1 * (5 + (reinforcecount_diamond * 2.5)))) * (2 + (math.max(0, reinforcecount - 9) * 0.5))) * priceRatio * gradeRatio[grade];

    if moruItem.ClassName == "Moru_Platinum_Premium" then
        value = value / 2;
    end
    
    if moruItem.ClassName == "Moru_Silver" or moruItem.ClassName == "Moru_Silver_test" or moruItem.ClassName == "Moru_Silver_NoDay" or moruItem.ClassName == "Moru_Silver_TA" or moruItem.ClassName == "Moru_Silver_TA2" then 
        value = 0;
    end

    if moruItem.ClassName == "Moru_Gold_TA" then 
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
  
    return SyncFloor(value);

end


function GET_REINFORCE_131014_HITCOUNT(fromItem, moru)

    local moruRank = string.sub(moru.ClassName, 6, 7);
    moruRank = tonumber(moruRank);
    local ItemStar = fromItem.ItemStar;
    
    local prop = geItemTable.GetProp(fromItem.ClassID);
    return 3;

end
