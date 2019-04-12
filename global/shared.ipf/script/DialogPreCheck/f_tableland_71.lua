function SCR_TABLE71_POINT1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND_71_SQ4')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc,'TABLE71_SUBQ4_BUFF1')  == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_TABLE71_POINT2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND_71_SQ4')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc,'TABLE71_SUBQ4_BUFF2')  == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_TABLE71_POINT3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND_71_SQ4')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc,'TABLE71_SUBQ4_BUFF3')  == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_TABLE71_STONE_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'TABLELAND_71_SQ6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end