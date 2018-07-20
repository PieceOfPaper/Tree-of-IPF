function SCR_DCAPITAL103_SQ_01_1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ01')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_03_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end

function SCR_DCAPITAL103_SQ_04_1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_04_2_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_04_3_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_04_4_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_04_5_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ04')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_07_1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ07')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_09_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end

function SCR_DCAPITAL103_SQ_09_1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ09')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_DCAPITAL103_SQ_11_1_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ11')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_HT2_DCAPITAL_103_DOC_PRE_DIALOG(pc, dialog, handle)
    local result = SCR_QUEST_CHECK(pc, 'DCAPITAL103_SQ06')
    if result == 'COMPLETE' then
        local ht2_sObj = GetSessionObject(pc, 'SSN_DIALOGCOUNT')
        if ht2_sObj ~= nil then
            if ht2_sObj.HT2_DCAPITAL_103_DOC_1 < 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end


function SCR_DCAPITAL_105_SHADOW_DEVICE_PRE_DIALOG(pc, dialog, handle)
    return 'NO'
end