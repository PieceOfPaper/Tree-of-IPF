
function SCR_PRISON_80_MON_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_80_MQ_2')
    if result == 'PROGRESS' then
        local x, y, z = GetPos(pc)
        if SCR_POINT_DISTANCE(x, z, 223, -234) <= 330 then
            return 'YES'
        end
    end
    return 'NO'
end

function SCR__PRISON_80_OBJ_6_1_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_80_MQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR__PRISON_80_OBJ_6_2_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_80_MQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR__PRISON_80_OBJ_6_3_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_80_MQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR__PRISON_80_OBJ_6_4_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_80_MQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR__PRISON_80_OBJ_6_5_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_80_MQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR__PRISON_80_OBJ_6_6_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc, 'PRISON_80_MQ_9')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end