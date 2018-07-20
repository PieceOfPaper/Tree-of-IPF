function SCR_FANTASYLIB483_MQ_6_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FANTASYLIB483_MQ_6')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_D_FANTASYLIB_48_3_COLLECTION_OBJ_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, 'SSN_COLLECT_310')
    if sObj ~= nil then
        if sObj.Goal2 == 0 or sObj.Goal3 == 0 then
            return 'YES'
        end
    end
    return 'NO'
end