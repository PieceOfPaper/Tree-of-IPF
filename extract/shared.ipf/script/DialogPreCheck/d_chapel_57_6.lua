
function SCR_CHAPLE576_MQ_06_MON_PRE_DIALOG(pc, dialog, handle)

    local result = SCR_QUEST_CHECK(pc, 'CHAPLE576_MQ_06')
    if result == 'PROGRESS' then
        if IsBuffApplied(pc, 'CHAPLE576_MQ_06_1') == "YES" then
            return 'YES'
        end
    end
    return 'NO'
end




function SCR_CHAPEL576_NORTH_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'CHAPLE576_MQ_08')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end