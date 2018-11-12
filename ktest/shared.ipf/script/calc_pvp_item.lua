function SCR_PVP_ITEM_LV_GRADE_REINFORCE_SET(item, lv, grade, reinforceValue, reinforceRatio)
    if _G["GetItemOwner"] == nil then
        return lv, grade, reinforceValue, reinforceRatio;
    end

    local owner = GetItemOwner(item);
    if owner == nil then
        return lv, grade, reinforceValue, reinforceRatio;
    end
    
    if IsPVPServer(owner) == 1 then
        local pvpLv = PVP_TEAMBATTLE_ITEM_LV;
        local pvpGrade = PVP_TEAMBATTLE_ITEM_GRADE;
        local pvpReinforceValue = PVP_TEAMBATTLE_ITEM_REINFORCE;
        local pvpReinforceRatio = PVP_TEAMBATTLE_ITEM_REINFORCERATIO;
        
        if pvpLv ~= nil then
            lv = pvpLv
        end
        
        if pvpGrade ~= nil then
            grade = pvpGrade
        end
        
        if pvpReinforceValue ~= nil then
            reinforceValue = pvpReinforceValue
        end
        
        if pvpReinforceRatio ~= nil then
            reinforceRatio = pvpReinforceRatio
        end
    end
    
    return lv, grade, reinforceValue, reinforceRatio;
end

function SCR_PVP_ITEM_TRANSCEND_SET(item, transcend)
    local owner = GetItemOwner(item);
    if owner == nil then
        return transcend;
    end
    
    if IsPVPServer(owner) == 1 then
        local pvpTranscend = PVP_TEAMBATTLE_ITEM_TRANSCEND;
        
        if pvpTranscend ~= nil then
            transcend = pvpTranscend;
        end
    end
    
    return transcend;
end