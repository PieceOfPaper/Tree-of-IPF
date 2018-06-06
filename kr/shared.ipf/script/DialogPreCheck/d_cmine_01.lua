

--function SCR_MINE_1_PURIFY_1_PRE_DIALOG_ANGLE(pc, dialog, handle)
--    local angle = info.GetAngle(session.GetMyHandle());
--    print(angle)
--    if angle > 310 and angle < 320 then
--        return "YES"
--    end
--end


function SCR_MINE_1_PURIFY_1_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_1')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_2')
    if result1 == 'POSSIBLE' or result1 == 'SUCCESS' or result2 == 'POSSIBLE' or result2 == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_1_CRYSTAL_4_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_1')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_1_PURIFY_5_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_8')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_9')
    if result1 == 'POSSIBLE' or result2 == 'SUCCESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_1_CRYSTAL_9_DEVICE_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_9')
    if result1 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_1_PURIFY_7_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_13')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_19')
    if result1 == 'POSSIBLE' or result2 == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_MINE_1_CRYSTAL_10_PRE_DIALOG(pc, dialog)
    local result1 = SCR_QUEST_CHECK(pc, 'MINE_1_CRYSTAL_10')
    if result1 == 'POSSIBLE' then
        return 'YES'
    end
    return 'NO'
end
