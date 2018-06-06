function SCR_JOB_2_PELTASTA2_WOOD_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PELTASTA2')
    if result == 'PROGRESS' then
        local Item_Cnt = GetInvItemCount(pc, "JOB_2_PELTASTA2_ITEM1")
        if Item_Cnt <= 2 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_SIAU11RE_MQ_02_NPC_01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU11RE_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAU11RE_MQ_02_NPC_02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU11RE_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAU11RE_MQ_02_NPC_03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU11RE_MQ_02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAU11RE_SQ_08_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU11RE_SQ_08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_SIAU15RE_SQ_03_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'SIAU15RE_SQ_03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


--function SCR_SIAU11RE_SQ_04_NPC_PRE_DIALOG(pc, dialog)
--    local result = SCR_QUEST_CHECK(pc, 'SIAU11RE_SQ_04')
--    if result == 'PROGRESS' then
--        return 'YES'
--    end
--    return 'NO'
--end