function SCR_FLIBRARY484_VIVORA_NPC_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'FANTASYLIB484_MQ_1')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_D_FANTASYLIB_48_4_COLLECTION_OBJ_PRE_DIALOG(pc, dialog)
    local sObj = GetSessionObject(pc, 'SSN_COLLECT_310')
    if sObj ~= nil then
        if sObj.Goal4 == 0 then
            return 'YES'
        end
    end
    return 'NO'
end