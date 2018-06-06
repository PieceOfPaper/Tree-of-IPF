function SCR_ORCHARD342_SQ_02_MON_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_342_SQ_02')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc, 'ORCHARD342_TRANSFORM_BUFF') == 'YES' then
            return 'YES'
        end
    end
    return 'NO'
end
function SCR_ORCHARD342_HOLY_TALK_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ORCHARD_342_MQ_08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end