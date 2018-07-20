function SCR_JOB_BULLETMARKER1_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FARM491_MQ_01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FARM491_MQ_02_1_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc,'FARM49_1_MQ02')
	local item, itemCnt  = GetInvItemByName(pc, 'FARM49_1_MQ02_ITEM1')
    if result ~= nil then
        if result == 'PROGRESS' then
        	if itemCnt == 0 then
                if self.NumArg1 ~= 1 then
                    local result1 = DOTIMEACTION_R(pc, ScpArgMsg("FARM49_1_MQ02_GET"), 'SITGROPE', 1)
                    if result1 == 1 then
                        self.NumArg1 = 1
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'FARM49_1_MQ02_ITEM1/1', nil, nil, nil, nil, nil, nil, 'FARM49_1_MQ02')
                    	PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                        sleep(1000)
                        KILL_BLEND(self, 1, 1)
                    end
                end
            end
        end
    end
end

function SCR_FARM491_MQ_02_2_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc,'FARM49_1_MQ02')
	local item, itemCnt  = GetInvItemByName(pc, 'FARM49_1_MQ02_ITEM2')
    if result ~= nil then
        if result == 'PROGRESS' then
        	if itemCnt == 0 then
                if self.NumArg1 ~= 1 then
                    local result1 = DOTIMEACTION_R(pc, ScpArgMsg("FARM49_1_MQ02_GET"), 'SITGROPE', 1)
                    if result1 == 1 then
                        self.NumArg1 = 1
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'FARM49_1_MQ02_ITEM2/1', nil, nil, nil, nil, nil, nil, 'FARM49_1_MQ02')
                    	PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                        sleep(1000)
                        KILL_BLEND(self, 1, 1)
                    end
                end
            end
        end
    end
end

function SCR_FARM491_SQ_01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FARM491_SQ_03_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FARM491_SQ_05_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FARM491_SQ_06_DIALOG(self, pc)
--    COMMON_QUEST_HANDLER(self,pc)

    local result = SCR_QUEST_CHECK(pc,'FARM49_1_SQ06')
    if result ~= nil then
        if result == 'PROGRESS' then
            if self.NumArg1 ~= 1 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'FARM49_1_SQ06')
                local result1 = DOTIMEACTION_R(pc, ScpArgMsg("FARM49_1_SQ06_GET"), 'SITGROPE', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'FARM49_1_SQ06')
                if result1 == 1 then
                    self.NumArg1 = 1
                    local i = IMCRandom(1, 100)
                    if i <= 40 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FARM49_1_SQ06_SUCCESS"), 5)
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'FARM49_1_SQ06_ITEM/1', nil, nil, nil, nil, nil, nil, 'FARM49_1_SQ06')
                    	PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                        sleep(1000)
                    elseif i > 40 and i <=70 then
                        local x, y, z = GetPos(self)
                        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("FARM49_1_SQ06_POISON"), 5)
                    	PlayEffect(self, 'F_ground004_violet', 0.75, 'BOT')
                        TakeDamage(self, pc, "None", (IMCRandom(20, 30) * 10), "Poison", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW)
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'FARM49_1_SQ06_ITEM/1', nil, nil, nil, nil, nil, nil, 'FARM49_1_SQ06')
--                        AddBuff(self, pc, 'Archer_VerminPot_Debuff', 200, 0, 10000, 1)
                    	sleep(1000)
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("FARM49_1_SQ06_MONSTER"), 5)
                        local iesObj = CreateGCIES('Monster', 'Tama_orange')
                        iesObj.Lv = 150
                        local x, y, z = GetPos(self)
                        local x1 = x + IMCRandom(-20, 20)
                        local y1 = y + IMCRandom(-20, 20)
                        local z1 = z + IMCRandom(-20, 20)
                        local mon = CreateMonster(self, iesObj, x1, y1, z1, angle, range)
                        InsertHate(mon, pc, 10000)
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'FARM49_1_SQ06_ITEM/1', nil, nil, nil, nil, nil, nil, 'FARM49_1_SQ06')
                    end
                    KILL_BLEND(self, 1, 1)
                end
            end
        end
    end
end

function SCR_FARM491_DANDELION_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc,'FARM49_1_SQ02')
    local quest_ssn = GetSessionObject(pc, 'SSN_FARM49_1_SQ02')
    if result ~= nil then
        if result == 'PROGRESS' then
            if self.NumArg1 ~= 1 then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 1.2, 'FARM49_1_SQ02')
                    local result1 = DOTIMEACTION_R(pc, ScpArgMsg("FARM49_1_SQ02_WEED"), 'WEEDING', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'FARM49_1_SQ02')
                    if result1 == 1 then
                        self.NumArg1 = 1
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FARM49_1_SQ02', 'QuestInfoValue1', 1)
                        KILL_BLEND(self, 1, 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FARM49_1_SQ02_MSG1"), 3)
                    end
                    if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                        SCR_SEND_ADDON_MSG_PARTY(pc, ScpArgMsg("FARM49_1_SQ02_MSG2"), 'NOTICE_Dm_Clear', 5, 'FARM49_1_SQ02/SUCCESS')
                    end
                end
            end
        end
    end
end

function SCR_FARM491_SQ_04_BUNDLE_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc,'FARM49_1_SQ04')
    if result ~= nil then
        if result == 'PROGRESS' then
            if self.NumArg1 ~= 1 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'FARM49_1_SQ04')
                local result1 = DOTIMEACTION_R(pc, ScpArgMsg("FARM49_1_SQ04_OPEN"), 'SITGROPE', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'FARM49_1_SQ04')
                if result1 == 1 then
                    self.NumArg1 = 1
                    PlayAnim(self, 'OPENED', 1)
                    SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'FARM49_1_SQ04_ITEM/1', nil, nil, nil, nil, nil, nil, 'FARM49_1_SQ04')
                	PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                    sleep(1000)
                    KILL_BLEND(self, 1, 1)
                end
            end
        end
    end
end

function SCR_FARM491_MQ_01_NORMAL_1_PRE(pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop == 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step9 == 1 then
                return 'YES'
            end
        end
    end
end

function SCR_FARM491_MQ_01_NORMAL_1(self,pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop >= 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            local npc_name = ScpArgMsg("CHAR220_MSETP1_ITEM_TXT7")
            if sObj.Step9 == 1 then
                if sObj.Goal9 == 0 then
                    local sel = ShowSelDlg(pc, 1, "CHAR220_MSETP2_7_DLG1", ScpArgMsg("CHAR220_MSETP2_QUEST_OK_MSG"), ScpArgMsg("CHAR220_MSETP2_QUEST_NO_MSG"))
                    if sel == 1 then
                        local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_7_ITEM1")
                        if cnt < 1 then
                            RunScript('GIVE_ITEM_TX', pc, "CHAR220_MSTEP2_7_ITEM1", 1, "CHAR220_MSTEP2_7");
                        end
                        sObj.Goal9 = 1
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_7_DLG1_1", 1)
                        return
                    end
                elseif sObj.Goal9 >= 1 and sObj.Goal9 < 100 then
                    local max_cnt = 11
                    if sObj.Goal9 >= max_cnt then
                        sObj.Goal9 = 100
                        SaveSessionObject(pc, sObj)
                        local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_7_ITEM1")
                        if cnt >= 1 then
                            RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_7_ITEM1", cnt, "CHAR220_MSTEP2_7");
                        end
                        ShowOkDlg(pc, "CHAR220_MSETP2_7_DLG3", 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    else
                        ShowOkDlg(pc, "CHAR220_MSETP2_7_DLG2", 1)
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_7_DLG4", 1)
                end
            end
        end
    end
end