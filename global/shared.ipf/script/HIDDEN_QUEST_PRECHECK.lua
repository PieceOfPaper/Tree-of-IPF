--HIDDEN QUEST PRE CHECK FUNCTION
--UNDERFORTRESS67_HQ1 condition check
function UNDERFORTRESS67_HIDDENQ1_STEP1(pc, questname, scriptInfo)
    local map_Search1 = GetMapFogSearchRate(pc, "d_underfortress_65")
    local map_Search2 = GetMapFogSearchRate(pc, "d_underfortress_66")
    local map_Search3 = GetMapFogSearchRate(pc, "d_underfortress_67")
    local map_Search4 = GetMapFogSearchRate(pc, "d_underfortress_68")
    local map_Search5 = GetMapFogSearchRate(pc, "d_underfortress_69")
    
    if map_Search1 ~= nil and map_Search2 ~= nil and map_Search3 ~= nil and map_Search4 ~= nil and map_Search5 ~= nil then
        if map_Search1 >= 100 and map_Search2 >= 100 and map_Search3 >= 100 and map_Search4 >= 100 and map_Search5 >= 100 then
            return "YES"
        else 
            return "NO"
        end
    end
end

--FLASH63_HQ1 condition check
function FLASH63_HQ1_PRE_CHECK_FUNC(pc, questname, scriptInfo)
    local sObj = GetSessionObject(pc, "SSN_FLASH63_CONDI_CHECK") 
    if sObj ~= nil then
        if sObj.Goal1 == 1 then
            return 'YES'
        end
    end
end

--BRACKEN632_HQ1 condition check
function SCR_BRACKEN632_HQ1_PREFUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_BRACKEN632_HQ1_UNLOCK")
    if sObj ~= nil then
    --print(sObj.Step2, sObj.Goal2)
        if sObj.Step1 == 1 and sObj.Goal1 == 1 and
           sObj.Step2 == 1 and sObj.Goal2 == 1 and
           sObj.Step3 == 1 and sObj.Goal3 == 1 and
           sObj.Step4 == 1 and sObj.Goal4 == 1 then
           --print("22222")
           return 'YES'
        end
    end
end

--SIAULIAI16_HQ1 condition check
function SIAULIAI16_HQ1_STEP1(pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI16_HQ1_UNLOCK1")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--ORSHA_HQ2 condition check
function ORSHA_HIDDENQ2_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_ORSHA_HQ2_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--TABLELAND28_1_HQ1 condition check
function TABLELAND28_1_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_TABLELAND28_1_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--FLASH64_HQ1 condition check
function FLASH64_HQ1_STEP1(pc)
    local sObj = GetSessionObject(pc, "SSN_FLASH64_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 >= 1 then
            return "YES"
        end
    end
end

--CASTLE65_3_HQ1 condition check
function CASTLE65_3_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_CASTLE65_3_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Step1 == 1 then
            return "YES"
        end
    end
end

--UNDERFORTRESS69_HQ1 condition check
function UNDER69_HIDDENQ1_PRECHECK(pc, questname, scriptInfo)
    local sObj = GetSessionObject(pc, "SSN_UNDER69_HQ1_UNLOCK")
    if sObj == nil then
        return 'NO'
    elseif sObj ~= nil then
        if sObj.Step1 >= 1 then
            return 'YES'
        end
    end
end

--SIAULIAI15_HQ1 condition check
function SIAULIAI15_HIDDENTQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI15_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end

--KATYN12_HQ1 condition check
function KATYN12_HIDDENQ1_PRECHECK(pc)
    if isHideNPC(pc, "KATYN12_HQ1_NPC") == "NO" then
        return "YES"
    end
end

--PRISON62_2_HQ1 condition check
function SCR_PRISON622_HIDDENQ1_PRECHEKC(pc)
    local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK")
    if sObj~= nil then
        if sObj.Goal5 == 1 then
            return "YES"
        end
    end
end

--ORCHARD32_3_HQ1 condition check
function ORCHARD323_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_ORCHARD323_HQ1_UNLOCK") 
    if sObj ~= nil then
        if sObj.Step1  >= 1 then
            return 'YES'
        end
    end
end


--ABBEY64_2_HQ1 condition check
function ABBEY64_2_HIDDENQ1_PRECHECK(pc)
    local map_Search1 = GetMapFogSearchRate(pc, "d_abbey_64_1")
    local map_Search2 = GetMapFogSearchRate(pc, "d_abbey_64_2")
    local map_Search3 = GetMapFogSearchRate(pc, "d_abbey_64_3")

    if map_Search1 ~= nil and map_Search2 ~= nil and map_Search3 ~= nil then
        if map_Search1 >= 100 and map_Search2 >= 100 and map_Search3 >= 100 then
            return "YES"
        end
    end
end

--PILGRIM31_3_HQ1 condition check
function PILGRIM31_3_HIDDENQ1_PRECHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM313_HQ1_UNLOCK")
    if sObj ~= nil then
        if sObj.Goal1 >= 1 then
            return "YES"
        end
    end
end