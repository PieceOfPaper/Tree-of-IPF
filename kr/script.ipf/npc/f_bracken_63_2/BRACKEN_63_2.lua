function SCR_BRACKEN632_ROZE01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_BRACKEN632_ROZE01_1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function BRACKEN632_ROZE_AI_CREATE(self)
    local follower = GetScpObjectList(self, 'BRACKEN632_ROZE01_OBJ')
    if #follower == 0 then
    local x, y, z = GetPos(self)
        sleep(1000)
        local mon = CREATE_MONSTER_EX(self, 'npc_roze', 394.41586, 284.3078, 1213.3424, GetDirectionByAngle(self), 'Neutral', 10, BRACKEN632_ROZE01_AIFUNC);
        SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'BRACKEN632_ROZE01_OBJ', 2);
        SetOwner(mon, self, 0)
        EnableAIOutOfPC(mon)
    end
end

function BRACKEN632_ROZE01_AI_CREATE(self)
    local result = SCR_QUEST_CHECK(self, "BRACKEN_63_2_MQ020")
    if result == 'PROGRESS' then
    local follower = GetScpObjectList(self, 'BRACKEN632_ROZE01_OBJ')
    if #follower == 0 then
    local x, y, z = GetPos(self)
        sleep(1000)
        local mon = CREATE_MONSTER_EX(self, 'npc_roze', x+30, y+15, z, GetDirectionByAngle(self), 'Neutral', 10, BRACKEN632_ROZE01_AIFUNC);
        SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'BRACKEN632_ROZE01_OBJ', 2);
            SetOwner(mon, self, 0)
        EnableAIOutOfPC(mon)
    end
end
end

function BRACKEN632_ROZE01_AIFUNC(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.Dialog = "BRACKEN632_ROZE01_1" 
    mon.SimpleAI = 'BRACKEN632_ROZE01_AI'
    mon.Name = ScpArgMsg("BRACKEN632_ROZE_AI_NAME")
    mon.WlkMSPD = 70
end

function BRACKEN632_MQ020_COMPELET_FUNC(pc)
    UIOpenToPC(pc,'fullblack',1)
    UnHideNPC(pc, "BRACKEN632_ROZE02")
    sleep(1000)
    UIOpenToPC(pc,'fullblack',0)
end

function SCR_BRACKEN632_ROZE02_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_BRACKEN632_ROZE03_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function BRACKEN632_MQ_COMPLETE(self)
    local mon = CREATE_MONSTER_EX(self, 'npc_roze', 856.34979, 284.15521, -314.25977, -161, 'Neutral', 10, BRACKEN632_MQ_COMPLETE_FUNC);
    AddVisiblePC(mon, self, 1)
    EnableAIOutOfPC(mon)
end

function BRACKEN632_MQ_COMPLETE_FUNC(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'BRACKEN632_MQ_COMPLETE_AI'
    mon.Name = ScpArgMsg("BRACKEN632_ROZE_AI_NAME")
    mon.WlkMSPD = 65
end

function SCR_BRACKEN632_TOWN_PEAPLE_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_BRACKEN632_TOWN_PEAPLE_1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_BRACKEN632_PEAPLE01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_BRACKEN632_TRACES01_DIALOG(self, pc)
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ010")
    if Q_result == "PROGRESS" then
        local Anim_result = DOTIMEACTION_R(pc, ScpArgMsg("BRACKEN632_SEARCH"), 'LOOK', 1.5)
        if Anim_result == 1 then
            ShowBalloonText(pc, "BRACKEN632_TRACES01_TXT01", 5)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_BRACKEN_63_2_MQ010', 'QuestInfoValue1', 1)
        end
    end
end

function SCR_BRACKEN632_TRACES02_DIALOG(self, pc)
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ010")
    if Q_result == "PROGRESS" then
        local Anim_result = DOTIMEACTION_R(pc, ScpArgMsg("BRACKEN632_SEARCH"), 'LOOK', 1.5)
        if Anim_result == 1 then
            ShowBalloonText(pc, "BRACKEN632_TRACES01_TXT02", 5)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_BRACKEN_63_2_MQ010', 'QuestInfoValue2', 1)
        end
    end
end

function SCR_BRACKEN632_TRACES03_DIALOG(self, pc)
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ010")
    if Q_result == "PROGRESS" then
        local Anim_result = DOTIMEACTION_R(pc, ScpArgMsg("BRACKEN632_SEARCH"), 'LOOK', 1.5)
        if Anim_result == 1 then
            ShowBalloonText(pc, "BRACKEN632_TRACES01_TXT03", 5)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_BRACKEN_63_2_MQ010', 'QuestInfoValue3', 1)
        end
    end
end

function SCR_BRACKEN632_TRACES_OBJECT_ENTER(self, pc)
end

function SCR_BRACKEN632_TRACES_OBJECT01_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_BRACKEN_63_2_MQ020")
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ020")
    if Q_result == "PROGRESS" then
        if sObj.Step1 <= 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_ROZE_SENDMSG"), 3);
            sObj.Step1 = 1
        end
    end
end

function SCR_BRACKEN632_TRACES_OBJECT02_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_BRACKEN_63_2_MQ020")
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ020")
    if Q_result == "PROGRESS" then
        if sObj.Step2 <= 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_ROZE_SENDMSG"), 3);
            sObj.Step2 = 1
        end
    end
end

function SCR_BRACKEN632_TRACES_OBJECT03_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_BRACKEN_63_2_MQ020")
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ020")
    if Q_result == "PROGRESS" then
        if sObj.Step3 <= 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_ROZE_SENDMSG"), 3);
            sObj.Step3 = 1
        end
    end
end

function SCR_BRACKEN632_TRACES_OBJECT04_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_BRACKEN_63_2_MQ020")
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ020")
    if Q_result == "PROGRESS" then
        if sObj.Step4 <= 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_ROZE_SENDMSG"), 3);
            sObj.Step4 = 1
        end
    end
end

function SCR_BRACKEN632_TRACES_OBJECT05_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_BRACKEN_63_2_MQ020")
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ020")
    if Q_result == "PROGRESS" then
        if sObj.Step5 <= 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_ROZE_SENDMSG"), 3);
            sObj.Step5 = 1
            local list, cnt = GetFollowerList(pc)
            for i = 1, cnt do
                if list[i].ClassName == "npc_roze" then
                    list[i].StrArg2 = "ON"
                    ClearSimpleAI(list[i], "BRACKEN632_ROZE01_AI")
                    RunSimpleAIOnly(list[i], "BRACKEN632_ROZE02_AI")
                    RunZombieScript("BRACKEN_63_2_MQ020_COMPLETE", list[i], pc)
                end
            end
        end
    end
end

--function SCR_BRACKEN632_TRACES_OBJECT06_ENTER(self, pc)
--    local sObj = GetSessionObject(pc, "SSN_BRACKEN_63_2_MQ020")
--    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ020")
--    if Q_result == "PROGRESS" then
--        if sObj.Step6 <= 0 then
--            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("BRACKEN632_ROZE_SENDMSG"), 3);
--            sObj.Step6 = 1
--        end
--    end
--end

function SCR_BRACKEN632_TRACES_OBJECT06_1_ENTER(self, pc)
--    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ020")
--    if Q_result == "PROGRESS" then
--        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_BRACKEN_63_2_MQ020', 'QuestInfoValue1', 1)
--        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("BRACKEN632_TRACES_FAIL"), 4);
--    end
end

function BRACKEN_63_2_MQ020_ABANDON(self)
    HideNPC(self, "BRACKEN632_ROZE02")
end

function SCR_BRACKEN632_TRACES_SEARCH01_DIALOG(self, pc)
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ030")
    local Anim_result = DOTIMEACTION_R(pc, ScpArgMsg("BRACKEN632_SEARCH"), 'LOOK', 1.5)
    if Anim_result == 1 then
        if Q_result == "PROGRESS" then
            local ran = IMCRandom(1, 10)
            local x, y, z = GetPos(self)
            if self.NumArg2 >= 1 then
            if ran < 5 then
                    local mon = CREATE_MONSTER(pc, "Ponpon", x, y, z, 0, "Monster", 0)
                CreateSessionObject(mon, 'SSN_QUESTNPC_AUTOKILL')
                SetTendency(mon, "Attack")
                InsertHate(mon, pc, 9999)
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("BRACKEN632_TRACES_MONSTER"), 4);
                    self.NumArg2 = 0
            elseif ran >= 5 then
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("BRACKEN632_TRACES_NOTHING"), 4);
            end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("BRACKEN632_TRACES_NOTHING"), 4);
            end
        end
    end
end

function SCR_BRACKEN632_TRACES_SEARCH02_ENTER(self, pc)
    local Q_result = SCR_QUEST_CHECK(pc, "BRACKEN_63_2_MQ030")
    if Q_result == "PROGRESS" then
        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_BRACKEN_63_2_MQ030', 'QuestInfoValue1', 1, nil, nil, nil, "BRACKEN632_TOWN_PEAPLE", 0)
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("BRACKEN632_TRACES_NPC"), 4);
--        UnHideNPC(pc, "BRACKEN632_TOWN_PEAPLE")
--        local obj, cnt = SelectObjectByClassName(self, 100, "npc_village_uncle_6")
--        local i
--        for i = 1, cnt do
--            if obj[i].Dialog == "BRACKEN632_TOWN_PEAPLE" then
--                PlayAnimLocal(obj[i], pc, "event_idle2", 1)
--            end
--        end
    end
end

function BRACKEN_63_2_MQ030_ABANDON(self)
    HideNPC(self, "BRACKEN632_TOWN_PEAPLE")
end

function SCR_BRACKEN632_MEDICAL_PLANT_DIALOG(self, pc)
    COMMON_QUEST_PROGRESSNPC(self, pc, npcfuncname)
end

function SCR_BRACKEN632_TOWN_PEAPLE1_DIALOG(self, pc)
    local rnd = IMCRandom(1, 20);
    local sObj = GetSessionObject(pc, "SSN_BRACKEN632_HQ1_UNLOCK")
    local quest_result = SCR_QUEST_CHECK(pc, "ABBAY64_3_HQ1")
    if rnd > 10 then
        ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE1_basic1', 1)
        --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
        BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result, "IMPOSSIBLE", "Step1", nil, "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
    else
        ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE1_basic2', 1)
        --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
        BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result, "IMPOSSIBLE", nil, "Goal1", "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
    end
    if quest_result == "IMPOSSIBLE" or quest_result == "POSSIBLE" then
        if sObj ~= nil then
            if sObj.Step1 == 1 and sObj.Goal1 == 1 and
                sObj.Step2 == 1 and sObj.Goal2 == 1 and
                sObj.Step3 == 1 and sObj.Goal3 == 1 and
                sObj.Step4 == 1 and sObj.Goal4 == 1 then
                Chat(self, ScpArgMsg("BRACKEN632_TOWN_PEAPLE1_CHAT1"), 5)
            end
        end
    end
end

function SCR_BRACKEN632_TOWN_PEAPLE2_DIALOG(self, pc)
    local rnd = IMCRandom(1, 20);
    local sObj = GetSessionObject(pc, "SSN_BRACKEN632_HQ1_UNLOCK")
    local quest_result1 = SCR_QUEST_CHECK(pc, "ABBEY64_2_HQ1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "ABBEY64_2_HQ2")
    local quest_result3 = SCR_QUEST_CHECK(pc, "ABBAY64_3_HQ1")
    --print(quest_result3)
    if quest_result1 == "POSSIBLE" or quest_result2 == "SUCCESS" then
        COMMON_QUEST_HANDLER(self,pc)
        return
    end
    if quest_result3 == "IMPOSSIBLE" then
        if rnd > 10 then
            ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE2_basic1', 1)
            --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
            BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result3, "IMPOSSIBLE", "Step2", nil, "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
            --Chat(self, "HIDDEN SOLVING... STEP2 VALUE "..sObj.Step2)
        else
            ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE2_basic2', 1)
            --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
            BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result3, "IMPOSSIBLE", nil, "Goal2", "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
            --Chat(self, "HIDDEN SOLVING... GOAL2 VALUE "..sObj.Goal2)
        end
    else
    COMMON_QUEST_HANDLER(self,pc)
    end
    if quest_result3 == "IMPOSSIBLE" or quest_result3 == "POSSIBLE" then
        if sObj ~= nil then
            if sObj.Step1 == 1 and sObj.Goal1 == 1 and
                sObj.Step2 == 1 and sObj.Goal2 == 1 and
                sObj.Step3 == 1 and sObj.Goal3 == 1 and
                sObj.Step4 == 1 and sObj.Goal4 == 1 then
                Chat(self, ScpArgMsg("BRACKEN632_TOWN_PEAPLE2_CHAT1"), 5)
            end
        end
    end
end

function SCR_BRACKEN632_TOWN_PEAPLE3_DIALOG(self, pc)
    local rnd = IMCRandom(1, 20);
    local sObj = GetSessionObject(pc, "SSN_BRACKEN632_HQ1_UNLOCK")
    local quest_result = SCR_QUEST_CHECK(pc, "ABBAY64_3_HQ1")
    if quest_result == "IMPOSSIBLE" then
        if rnd > 10 then
            ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE3_basic1', 1)
            --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
            BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result, "IMPOSSIBLE", "Step3", nil, "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
        else
            ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE3_basic2', 1)
            --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
            BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result, "IMPOSSIBLE", nil, "Goal3", "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
        end
    else
    COMMON_QUEST_HANDLER(self,pc)
    end
    if quest_result == "IMPOSSIBLE" or quest_result == "POSSIBLE" then
        if sObj ~= nil then
            if sObj.Step1 == 1 and sObj.Goal1 == 1 and
                sObj.Step2 == 1 and sObj.Goal2 == 1 and
                sObj.Step3 == 1 and sObj.Goal3 == 1 and
                sObj.Step4 == 1 and sObj.Goal4 == 1 then
                Chat(self, ScpArgMsg("BRACKEN632_TOWN_PEAPLE3_CHAT1"), 5)
            end
        end
    end
end

function SCR_ABBEY64_2_HIDDENQ1_CHECK_ENTER(self, pc)
    local Hquest = SCR_QUEST_CHECK(pc, "ABBEY64_2_HQ1")
    if Hquest == "IMPOSSIBLE" or Hquest == "POSSIBLE" then
    local map_Search1 = GetMapFogSearchRate(pc, "d_abbey_64_1")
    local map_Search2 = GetMapFogSearchRate(pc, "d_abbey_64_2")
    local map_Search3 = GetMapFogSearchRate(pc, "d_abbey_64_3")
    
    local quest1 = SCR_QUEST_CHECK(pc, "ABBAY_64_1_SQ020")
    local quest2 = SCR_QUEST_CHECK(pc, "ABBAY_64_1_SQ030")
    local quest3 = SCR_QUEST_CHECK(pc, "ABBAY_64_2_SQ030")
    local quest4 = SCR_QUEST_CHECK(pc, "ABBAY_64_2_SQ050")
    
    if map_Search1 ~= nil and map_Search2 ~= nil and map_Search3 ~= nil then
        if (map_Search1 >= 100 and map_Search2 >= 100 and map_Search3 >= 100) and
        (quest1 == "COMPLETE" and quest2 == "COMPLETE" and quest3 == "COMPLETE" and quest4 == "COMPLETE") then
            ChatLocal(self, pc, ScpArgMsg("ABBEY64_2_HIDDENQ1_MSG1"), 5)
        elseif (map_Search1 >= 100 and map_Search2 >= 100 and map_Search3 >= 100) or 
        (quest1 ~= "COMPLETE" or quest2 ~= "COMPLETE" or quest3 ~= "COMPLETE" or quest4 ~= "COMPLETE") then
            ChatLocal(self, pc, ScpArgMsg("ABBEY64_2_HIDDENQ1_MSG2"), 5)
        elseif (map_Search1 < 100 or map_Search2 < 100 or map_Search3 < 100) and 
        (quest1 == "COMPLETE" and quest2 == "COMPLETE" and quest3 == "COMPLETE" and quest4 == "COMPLETE") then
            ChatLocal(self, pc, ScpArgMsg("ABBEY64_2_HIDDENQ1_MSG3"), 5)
        elseif (map_Search1 < 100 or map_Search2 < 100 or map_Search3 < 100) or 
        (quest1 ~= "COMPLETE" and quest2 ~= "COMPLETE" and quest3 ~= "COMPLETE" and quest4 ~= "COMPLETE") then
            ChatLocal(self, pc, ScpArgMsg("ABBEY64_2_HIDDENQ1_MSG4"), 5)
        end
    end
    end
end

function SCR_BRACKEN632_TOWN_PEAPLE4_DIALOG(self, pc)
    local rnd = IMCRandom(1, 20);
    local sObj = GetSessionObject(pc, "SSN_BRACKEN632_HQ1_UNLOCK")
    local quest_result = SCR_QUEST_CHECK(pc, "ABBAY64_3_HQ1")
    if rnd > 10 then
        ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE4_basic1', 1)
        --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
        BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result, "IMPOSSIBLE", "Step4", nil, "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
    else
        ShowOkDlg(pc, 'BRACKEN632_TOWN_PEAPLE4_basic2', 1)
        --HIDDEN QUEST : ABBAY64_3_HQ1 UNLOCK WAY CHECK
        BRACKEN632_HQ1_UNLOCK_COUNT(pc, quest_result, "IMPOSSIBLE", nil, "Goal4", "SSN_BRACKEN632_HQ1_UNLOCK", sObj)
    end
    if quest_result == "IMPOSSIBLE" or quest_result == "POSSIBLE" then
        if sObj ~= nil then
            if sObj.Step1 == 1 and sObj.Goal1 == 1 and
                sObj.Step2 == 1 and sObj.Goal2 == 1 and
                sObj.Step3 == 1 and sObj.Goal3 == 1 and
                sObj.Step4 == 1 and sObj.Goal4 == 1 then
                Chat(self, ScpArgMsg("BRACKEN632_TOWN_PEAPLE4_CHAT1"), 5)
            end
        end
    end
end

function BRACKEN632_TRACES_OBJECT_HIDE(self)
    HideNPC(self, "BRACKEN632_TRACES_OBJECT")
    HideNPC(self, "BRACKEN632_TRACES_OBJECT01")
    HideNPC(self, "BRACKEN632_TRACES_OBJECT02")
    HideNPC(self, "BRACKEN632_TRACES_OBJECT03")
    HideNPC(self, "BRACKEN632_TRACES_OBJECT04")
    HideNPC(self, "BRACKEN632_TRACES_OBJECT05")
end

function SCR_SAGE_MASTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function JOB_SAGE_8_1_AGREE_FUNC(self, questName, npc)
--    local sObj = GetSessionObject(self, "SSN_JOB_SAGE_8_1")
--    local i = IMCRandom(1, 4)
--    local Ftower_Book = {
--                            "SAGE_JOBQ_IN_FTOWER1",
--                            "SAGE_JOBQ_IN_FTOWER2",
--                            "SAGE_JOBQ_IN_FTOWER3",
--                            "SAGE_JOBQ_IN_FTOWER4"
--                        }
--    sObj.String1 = Ftower_Book[i]
--    
--    local j = IMCRandom(1, 4)
--    local Abbey354_Book = {
--                            "SAGE_JOBQ_IN_ABBEY354_1",
--                            "SAGE_JOBQ_IN_ABBEY354_2",
--                            "SAGE_JOBQ_IN_ABBEY354_3",
--                            "SAGE_JOBQ_IN_ABBEY354_4"
--                          }
--    sObj.String2 = Abbey354_Book[j]
end


function SCR_SAGE_JOBQ_IN_FTOWER1_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_FTOWER2_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        SetDirectionByAngle(pc, 84)
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        SetDirectionByAngle(pc, 84)
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_FTOWER3_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_FTOWER4_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String1 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM1")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM1', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book1")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_ABBEY354_1_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_ABBEY354_2_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_ABBEY354_3_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_ABBEY354_4_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String2 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM2")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM2', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book2")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_CASTLE202_1_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_CASTLE202_2_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_CASTLE202_3_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4);
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end


function SCR_SAGE_JOBQ_IN_CASTLE202_4_DIALOG(self, pc)
    local quest_result = SCR_QUEST_CHECK(pc, "JOB_SAGE_8_1")
    local quest_result2 = SCR_QUEST_CHECK(pc, "MASTER_SAGE1")
    if quest_result == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_SAGE_8_1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "Quest_JOB_SAGE_8_1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4)
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    elseif quest_result2 == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_MASTER_SAGE1")
        local anim_result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SAGE_8_1_MSG1"), 'SITREAD', 1)
        if anim_result == 1 then
            if sObj.String3 == self.Dialog then
                local item_cnt = GetInvItemCount(pc, "JOB_1_SAGE_ITEM3")
                if item_cnt < 1 then
                    RunScript('GIVE_ITEM_TX', pc, 'JOB_1_SAGE_ITEM3', 1, "MASTER_SAGE1")
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SAGE_8_1_MSG2"), 4)
                    sObj.QuestInfoValue3 = sObj.QuestInfoValue3 + 1;
                    SaveSessionObject(pc, sObj)
                    ShowBookItem(pc, "JOB_SAGE_book3")
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG3"), 4);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SAGE_8_1_MSG4"), 4);
            end
        end
    end
end