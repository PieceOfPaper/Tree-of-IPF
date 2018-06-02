function SCR_CASTLE652_MQ_02_AREA_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE652_MQ_02_PILLAR_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE652_MQ_03_AREA_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE652_MQ_04_AREA_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE652_MQ_04_PILLAR_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE652_MQ_PILLAR_EX_PRE_DIALOG(pc, dialog)
    return 'NO'
end

function SCR_CASTLE652_SQ_01_BOX_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE65_2_SQ01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_CASTLE652_SQ_03_MUSHROOM_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'CASTLE65_2_SQ03')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end
