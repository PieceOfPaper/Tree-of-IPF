function SCR_THORN391_MQ_04_T_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_1_MQ04')
    if result == 'PROGRESS' then
--        local itemCnt = GetInvItemCount(pc, 'THORN39_1_MQ04_ITEM_2')
--        if itemCnt <= 4 then
            return 'YES'
--        end
    end
    return 'NO'
end

function SCR_THORN391_SQ_01_H_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_1_SQ01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_THORN391_SQ_02_H_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'THORN39_1_SQ02')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
