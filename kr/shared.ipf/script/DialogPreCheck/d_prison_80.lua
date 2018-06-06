
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
