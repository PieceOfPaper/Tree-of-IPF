function SCR_KATYN_45_1_SQ_6_HERB_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_45_1_SQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_45_1_SQ_9_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_45_1_SQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_45_2_SQ_5_DARK_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_45_2_SQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_45_2_SQ_5_DARK_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_45_2_SQ_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_45_2_SQ_9_HERB_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_45_2_SQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_45_3_SQ_14_SOUL_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_45_3_SQ_14')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_45_3_GRASS_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'KATYN_45_3_SQ_3')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_KATYN_45_2_SQ_10_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_KATYN_45_1_OWL2_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_KATYN_45_1_OWL1_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_KATYN_45_2_OWL3_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_KATYN_45_3_OWL4_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_KATYN_45_3_OWL5_1_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_KATYN_45_3_OWL5_2_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_KATYN_45_3_OWL5_3_PRE_DIALOG(pc, dialog)
    return 'YES'
end

function SCR_HIDDEN_STONE_KATYN451_1_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal1 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_2_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal2 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_3_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal3 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_4_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal4 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_5_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal5 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_6_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal6 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_7_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal7 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_8_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal8 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_9_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal9 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_10_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal10 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_11_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal11 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_12_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal12 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_13_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal13 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_14_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal14 >= 1 then
                print("3333333")
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_15_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal15 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_16_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal16 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_17_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal17 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_18_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal18 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_19_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal19 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_HIDDEN_STONE_KATYN451_20_PRE_DIALOG(pc, dialog)
    local quest_ssn = GetSessionObject(pc, 'SSN_BULLETMARKER_UNLOCK')
    if quest_ssn ~= nil then
        if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
            if quest_ssn.Goal20 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end