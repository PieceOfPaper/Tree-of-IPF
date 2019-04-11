function SCR_ROKAS27_QB_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS27_QB_2')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS27_QB_14_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS27_QB_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS27_QB_14_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS27_QB_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS27_QB_14_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS27_QB_5')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ROKAS27_CABLE_RIGHT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS27_QB_11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ROKAS27_CABLE_LEFT_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'ROKAS27_QB_11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
