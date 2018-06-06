function SCR_LOWLV_MASTER_ENCY_SQ_30_BOOK_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'LOWLV_MASTER_ENCY_SQ_30')
    local result2 = SCR_QUEST_CHECK(pc, 'LOWLV_MASTER_ENCY_SQ_40')
    if result1 == 'PROGRESS' and result2 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end

function SCR_LOWLV_MASTER_ENCY_SQ_50_DOLL_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_LOWLV_MASTER_ENCY_SQ_50_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'LOWLV_MASTER_ENCY_SQ_50')
    print(result)
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end