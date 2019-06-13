function SCR_PVP_ITEM_LV_GRADE_REINFORCE_SET(item, lv, grade, reinforceValue, reinforceRatio)
    local owner = GetItemOwner(item);
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
    
    local itemstring = TryGetProp(item, 'StringArg','None')
    if itemstring == 'pvp_Mine' then
        local useLv = TryGetProp(item,"ItemLv", 0);
        if useLv ~= nil and useLv ~= 0 then
            lv = useLv;
        end
    end
    
    if IsBuffApplied(owner, "PVP_MINE_Authority") == "YES" then
        local pvpLv = 400;
        local pvpGrade = 5;
        local pvpReinforceValue = 21;
        local pvpReinforceRatio = reinforceRatio;
        
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
    elseif IsBuffApplied(owner, "PVP_MINE_Divine_Protection") == "YES" then
        local pvpLv = 400;
        local pvpGrade = 4;
        local pvpReinforceValue = 11;
        local pvpReinforceRatio = reinforceRatio;
        
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
    
    if _G["GetItemOwner"] == nil then
        return transcend;
    end
    
    if owner == nil then
        return transcend;
    end
    
    if IsPVPServer(owner) == 1 then
        local pvpTranscend = PVP_TEAMBATTLE_ITEM_TRANSCEND;
        
        if pvpTranscend ~= nil then
            transcend = pvpTranscend;
        end
    end
    
    local itemstring = TryGetProp(item, 'StringArg','None')
    if itemstring == 'pvp_Mine' then
        transcend = 100;
    end
    
    if IsBuffApplied(owner, "PVP_MINE_Authority") == "YES" then
        transcend = 100;
    elseif IsBuffApplied(owner, "PVP_MINE_Divine_Protection") == "YES" then
        transcend = 100;
    end
    
    return transcend;
end