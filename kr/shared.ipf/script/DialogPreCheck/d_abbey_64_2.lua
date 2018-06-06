function SCR_ABBEY642_DEVICE01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_DEVICE02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_DEVICE03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_DEVICE04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_MQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_DEVICE05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_MQ040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_ORB_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ040')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_BRACKEN01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_BRACKEN02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_BRACKEN03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_BRACKEN04_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_BRACKEN05_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ020')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_ORB_SETUP01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_ORB_SETUP02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_ORB_SETUP03_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ050')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_LOSTBAG01_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end


function SCR_ABBEY642_LOSTBAG02_PRE_DIALOG(pc, dialog)
    local result = SCR_QUEST_CHECK(pc,'ABBAY_64_2_SQ010')
    if result == 'PROGRESS' then
        return 'YES'
    end
    return 'NO'
end

function SCR_ABBEY642_EDMONDAS_PRE_DIALOG(pc, dialog)
    return 'YES'
end
