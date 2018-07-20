-- sObj.Goal1 : mon kill check value if this property 1 mon_arrary move
-- sObj.Goal2 : combo check value
-- sObj.Goal3 : fail count
-- sObj.Goal4 : time check value

function SCR_SSN_JOB_EXORCIST1_BASIC_HOOK(self, sObj)
end
function SCR_CREATE_SSN_JOB_EXORCIST1(self, sObj)
	SCR_SSN_JOB_EXORCIST1_BASIC_HOOK(self, sObj)
    local sObj_main = GetSessionObject(self, 'ssn_klapeda')
    local questName = sObj.QuestName
    local failCount = sObj_main[questName..'_FC']
    if sObj ~= nil then
        sObj.Goal3 = 20
        if failCount >= 14 then
            sObj.Goal3 = 12
        elseif failCount >= 11 then
            sObj.Goal3 = 14
        elseif failCount >= 8 then
            sObj.Goal3 = 16
        elseif failCount >= 5 then
            sObj.Goal3 = 18
        end
    end
    sObj.Goal4 = 0
end

function SCR_REENTER_SSN_JOB_EXORCIST1(self, sObj)
	SCR_SSN_JOB_EXORCIST1_BASIC_HOOK(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_JOB_EXORCIST1(self, sObj)
end

function SCR_TIMEOUT_SSN_JOB_EXORCIST1(self, sObj)
    local maxRewardIndex = SCR_QUEST_CHECK_MODULE_STEPREWARD_FUNC(self, sObj.QuestName)
    print(sObj.QuestInfoValue1)
    if maxRewardIndex ~= nil and maxRewardIndex > 0 then
        SCR_SSN_TIMEOUT_PARTY_SUCCESS(self, sObj.QuestName, nil, nil)
	else
	    if sObj.QuestInfoValue1 < 400 then
    	    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EXORCIST_JOB_QUEST_FAIL1"), 4)
	    elseif sObj.QuestInfoValue1 < 450 then
    	    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EXORCIST_JOB_QUEST_FAIL2"), 4)
    	elseif sObj.QuestInfoValue1 < 500 then
    	    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EXORCIST_JOB_QUEST_FAIL3"), 4)
	    end
	    RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
	end
end

function SCR_SSN_JOB_EXORCIST1_COUNTTIME(self, sObj, remainTime)
end

function SCR_EXORCIST_JOB_QUEST_OBJ_START_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_TIMEOUT_SSN_JOB_EXORCIST1(self, sObj)
	SCR_SSN_TIMEOUT_PARTY_SUCCESS(self, sObj.QuestName, nil, nil)
end

function SCR_SSN_JOB_EXORCIST1_COUNTTIME(self, sObj, remainTime)
	SCR_PARTY_SOBJ_TIME_SHARE(self, sObj, remainTime)
end

function EXORCIST_JOB_QUEST_OBJ_SETTING(pc)
    local obj_arr1 = {
                        "Velwriggler_blue", "Spector_gh_red", "Sec_Spector_Gh", "Hallowventor", 
                     }
    
    local sObj = GetSessionObject(pc, "SSN_JOB_EXORCIST1")
    
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list < 1 then 
        local obj_arr2 = {}
        if #obj_arr2 < 1 then
            for i = 1, 8 do
                local ran = IMCRandom(1, 4)
                local pos_x = -20 * i
                local pos_z = -4 * i
                local mon = CREATE_MONSTER_EX(pc, obj_arr1[ran], -91+pos_x, 935, -2376+pos_z, 0, 'Neutral', 0, EXORCIST_JOB_QUEST_OBJ_SET1)
                AddScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ", mon);
                StopAnim(mon)
            end
        end
    end
end

function EXORCIST_QUEST_MON_KILL_CHECK(pc, mon, sObj)
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list >= 1 then
        mon.StrArg1 = "Kill" --kill check value
        PlayEffect(mon, "F_explosion050_fire_blue", 0.4, "TOP")
        PlayEffect(mon, "F_explosion050_fire_blue", 0.6, "TOP")
        PlayEffect(mon, "F_explosion033_orange", 0.4, "BOT")
        Kill(mon)
        sObj.Goal1 = sObj.Goal1 + 1
        if IsBuffApplied(pc, "EXORCIST_QUEST_ADVENTAGE_BUFF2") == "NO" then
            if IsBuffApplied(pc, "EXORCIST_QUEST_ADVENTAGE_BUFF1") == "NO" then
                sObj.Goal2 = sObj.Goal2 + 1
                if sObj.Goal2 == 10 then
                    AddBuff(pc, pc, "EXORCIST_QUEST_ADVENTAGE_BUFF1", 1, 0, 16000)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EXORCIST_QUEST_ADVENTAGE_BUFF1_GET"), 5)
                    sObj.Goal2 = 0
                end
            elseif IsBuffApplied(pc, "EXORCIST_QUEST_ADVENTAGE_BUFF1") == "YES" then
                sObj.Goal2 = sObj.Goal2 + 1
                if sObj.Goal2 == 10 then
                    RemoveBuff(pc, "EXORCIST_QUEST_ADVENTAGE_BUFF1")
                    AddBuff(pc, pc, "EXORCIST_QUEST_ADVENTAGE_BUFF2", 1, 0, 8000)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EXORCIST_QUEST_ADVEN_BUFF2_GET1"), 5)
                    sObj.Goal2 = 0 
                end
            end
        end
        EXORCIST_JOB_QUEST_POINT(pc)
        return "YES"
    end
end

function EXORCIST_JOB_QUEST_OBJ_MOVE(pc)
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list >= 1 then
        for i = 1, #mon_list do
            local pos_x = -20 * i
            local pos_z = -4 * i
            Move3DByTime(mon_list[i], -91+pos_x, 935, -2376+pos_z, 0.4, 1, "true", "true")
        end
    end
end

function EXORCIST_JOB_QUEST_OBJ_CRE(pc, sObj)
    local obj_arr1 = {
                        "Velwriggler_blue", "Spector_gh_red", "Sec_Spector_Gh", "Hallowventor"
                     }
                     
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list < 8 then
        local ran = IMCRandom(1, 4)
        local pos_x = -20 * 8
        local pos_z = -4 * 8
        if sObj.Goal1 == sObj.Goal3 then
            obj_arr1[ran] = "Altarcrystal_N1"
            sObj.Goal1 = 0
        end
        local mon = CREATE_MONSTER_EX(pc, obj_arr1[ran], -91+pos_x, 935, -2376+pos_z, 0, 'Neutral', 0, EXORCIST_JOB_QUEST_OBJ_SET1)
        AddScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ", mon);
    end
end

function EXORCIST_JOB_QUEST_OBJ_SET1(mon)
    if mon.ClassName == "Altarcrystal_N1" then
        mon.Name = ScpArgMsg("EXORCIST_JOBQ_CRYSTAL")
    end
    mon.BTree = "BT_DUMMY"
end

function EXORCIST_QUEST_BOBM_KILL_CHECK(pc)
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list >= 1 then
        if mon_list[1].StrArg1 == nil or mon_list[1].StrArg1 == "None" or mon_list[1].StrArg1 ~= "Kill" then
            mon_list[1].StrArg1 = "Kill" --kill check value
            PlayEffect(mon_list[1], "F_burstup001_yellow", 0.2, "BOT")
            PlayEffect(mon_list[1], "I_explosion004_yellow", 0.4, "BOT")
            PlayEffect(mon_list[1], "F_explosion033_orange", 0.4, "BOT")
            Kill(mon_list[1])
            EXORCIST_JOB_QUEST_POINT(pc)
            return "YES"
        end
    end
end

function EXORCIST_JOB_QUEST_BOBM_MOVE(pc, num)
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list >= 1 then
        local x, y, z = GetPos(mon_list[1])
        if SCR_POINT_DISTANCE(x, z, -111, -2380) > 1 then
            for i = 1, #mon_list do
                local pos_x = -20 * i
                local pos_z = -4 * i
                SetPos(mon_list[i],-91+pos_x, 935, -2376+pos_z)
                --Move3DByTime(mon_list[i], -91+pos_x, 935, -2376+pos_z, 0.4, "true", "true")
            end
        end
    end
end

function EXORCIST_JOB_QUEST_BOBM_OBJ_CRE(pc, sObj, num)
    local obj_arr1 = {
                        "Velwriggler_blue", "Spector_gh_red", "Sec_Spector_Gh", "Hallowventor", 
                     }
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list < 8 then
        local ran = IMCRandom(1, 4)
        local pos_x = -20 * 8
        local pos_z = -4 * 8
        local mon = CREATE_MONSTER_EX(pc, obj_arr1[ran], -91+pos_x, 935, -2376+pos_z, 0, 'Neutral', 0, EXORCIST_JOB_QUEST_OBJ_SET1)
        AddScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ", mon);
    end
end

function EXORCIST_JOB_QUEST_POINT(self)
    local sObj = GetSessionObject(self, "SSN_JOB_EXORCIST1")
    if IsBuffApplied(self, "EXORCIST_QUEST_ADVENTAGE_BUFF1") == "YES" then
        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 2
    elseif IsBuffApplied(self, "EXORCIST_QUEST_ADVENTAGE_BUFF2") == "YES" then
        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 5
    else
        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
    end
    if SCR_JOB_EXORCIST1_REWARD3(self) == 'YES' and sObj.Step13 == 0 then
        CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 3)
        sObj.Step13 = 1
    elseif SCR_JOB_EXORCIST1_REWARD2(self) == 'YES' and sObj.Step12 == 0 then
        CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 2)
        sObj.Step12 = 1
    elseif SCR_JOB_EXORCIST1_REWARD1(self) == 'YES' and sObj.Step11 == 0 then
        CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 1)
        sObj.Step11 = 1
    end
end

function EXORCIST_JOB_QUEST_OBJ_MOVE11(pc)
    local mon_list = GetScpObjectList(pc, "EXORCIST_JOB_QUEST_OBJ")
    if #mon_list >= 1 then
        for i = 1, #mon_list do
            local pos_x = -20 * i
            local pos_z = -4 * i
            Move3DByTime(mon_list[i], -91+pos_x, 935, -2376+pos_z, 0.4, "true", "true")
        end
    end
end

function SCR_EXORCIST_PLACE_IN_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_EXORCIST1")
    local tiem_check = sObj.Goal4
    if tiem_check <= 0 then
        SetSessionObjectTime(pc, sObj, 120)
        sObj.Goal4 = 1
        SaveSessionObject(pc, sObj)
    end
    AttachEffect(self, "F_cast001", 0.5, 1, "BOT", 1)
end

function SCR_EXORCIST_PLACE_OUT_LEAVE(self, pc)
    DetachEffect(self, "F_cast001")
end