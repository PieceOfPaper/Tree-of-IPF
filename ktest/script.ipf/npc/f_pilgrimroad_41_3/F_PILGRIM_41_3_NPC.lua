function SCR_PILGRIM41_3_CURLING_DIALOG(self, pc)
    SCR_DTACURLING(self, pc)
end

function SCR_PILGRIM41_3_PAIR_DIALOG(self, pc)
    SCR_MONSTER_PAIR(self, pc)
end

function PILGRIM41_3_GIMMICK_REWARD_BUFF_HEAL(self, pc)
    AddBuff(self, pc, 'GIMMICK_REWARD_BUFF', 1, 0, 600000, 1)
end

function SCR_PILGRIM413_SQ_01_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM413_SQ_02_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM413_SQ_03_1_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ03')
    local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ03')
    if result ~= nil then
        if result == 'PROGRESS' then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'PILGRIM41_3_SQ03')
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM41_3_SQ03_SEARCH"), 'LOOK_SIT', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'PILGRIM41_3_SQ03')
            if result1 == 1 then
                if quest_ssn ~= nil then
                    if quest_ssn.Step1 == 1 then
                        ShowOkDlg(pc, 'PILGRIM413_SQ_03_tomb', 1)
                        PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_MIRROR"), 5)
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'PILGRIM41_3_SQ03_ITEM/1', nil, nil, nil, nil, nil, nil, 'PILGRIM41_3_SQ03')
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_FAIL"), 5)
                    end
                end
            end
        end
    end
end

function SCR_PILGRIM413_SQ_03_2_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ03')
    local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ03')
    if result ~= nil then
        if result == 'PROGRESS' then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'PILGRIM41_3_SQ03')
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM41_3_SQ03_SEARCH"), 'LOOK_SIT', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'PILGRIM41_3_SQ03')
            if result1 == 1 then
                if quest_ssn ~= nil then
                    if quest_ssn.Step1 == 2 then
                        ShowOkDlg(pc, 'PILGRIM413_SQ_03_tomb', 1)
                        PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_MIRROR"), 5)
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'PILGRIM41_3_SQ03_ITEM/1', nil, nil, nil, nil, nil, nil, 'PILGRIM41_3_SQ03')
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_FAIL"), 5)
                    end
                end
            end
        end
    end
end

function SCR_PILGRIM413_SQ_03_3_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ03')
    local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ03')
    if result ~= nil then
        if result == 'PROGRESS' then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'PILGRIM41_3_SQ03')
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM41_3_SQ03_SEARCH"), 'LOOK_SIT', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'PILGRIM41_3_SQ03')
            if result1 == 1 then
                if quest_ssn ~= nil then
                    if quest_ssn.Step1 == 3 then
                        ShowOkDlg(pc, 'PILGRIM413_SQ_03_tomb', 1)
                        PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_MIRROR"), 5)
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'PILGRIM41_3_SQ03_ITEM/1', nil, nil, nil, nil, nil, nil, 'PILGRIM41_3_SQ03')
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_FAIL"), 5)
                    end
                end
            end
        end
    end
end

function SCR_PILGRIM413_SQ_03_4_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ03')
    local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ03')
    if result ~= nil then
        if result == 'PROGRESS' then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'PILGRIM41_3_SQ03')
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM41_3_SQ03_SEARCH"), 'LOOK_SIT', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'PILGRIM41_3_SQ03')
            if result1 == 1 then
                if quest_ssn ~= nil then
                    if quest_ssn.Step1 == 4 then
                        ShowOkDlg(pc, 'PILGRIM413_SQ_03_tomb', 1)
                        PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_MIRROR"), 5)
                        SCR_PARTY_QUESTPROP_ADD(pc, nil, nil, nil, nil, 'PILGRIM41_3_SQ03_ITEM/1', nil, nil, nil, nil, nil, nil, 'PILGRIM41_3_SQ03')
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PILGRIM41_3_SQ03_FAIL"), 5)
                    end
                end
            end
        end
    end
end

function SCR_PILGRIM413_SQ_05_ENTER(self, pc)
end

function SCR_PILGRIM413_SQ_06_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM413_SQ_06_1_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ06')
    if result == "PROGRESS" then
        local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ06')
        if quest_ssn.Step1 ~= 1 then
            ShowOkDlg(pc, 'PILGRIM413_SQ_06_info1', 1)
            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
            quest_ssn.Step1 = 1
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM413_SQ_06_2_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ06')
    local genID = GetGenTypeID(self)
    if result == "PROGRESS" then
        local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ06')
        if quest_ssn.Step2 ~= 1 then
            ShowOkDlg(pc, 'PILGRIM413_SQ_06_info2', 1)
            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
            quest_ssn.Step2 = 1
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM413_SQ_06_3_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ06')
    local genID = GetGenTypeID(self)
    if result == "PROGRESS" then
        local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ06')
        if quest_ssn.Step3 ~= 1 then
            ShowOkDlg(pc, 'PILGRIM413_SQ_06_info3', 1)
            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
            quest_ssn.Step3 = 1
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM413_SQ_06_4_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM41_3_SQ06')
    local genID = GetGenTypeID(self)
    if result == "PROGRESS" then
        local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM41_3_SQ06')
        if quest_ssn.Step4 ~= 1 then
            ShowOkDlg(pc, 'PILGRIM413_SQ_06_info4', 1)
            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
            quest_ssn.Step4 = 1
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM413_SQ_07_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end
              
function SCR_PILGRIM413_SQ_07_TRACKSTART(pc, questname, npc)
    local P_list , P_cnt = GET_PARTY_ACTOR(pc, 0)
    local p
    if P_cnt >= 1 then
        for p = 1, P_cnt do
            local result1 = SCR_QUEST_CHECK(P_list[p], 'PILGRIM41_3_SQ07')
            if result1 == 'PROGRESS' then
                if isHideNPC(P_list[p], 'PILGRIM413_SQ_06') == 'NO' then
                    HideNPC(P_list[p], "PILGRIM413_SQ_06")
                end
                if isHideNPC(P_list[p], 'PILGRIM413_SQ_07') == 'NO' then
                    HideNPC(P_list[p], "PILGRIM413_SQ_07")
                end
                if isHideNPC(P_list[p], 'PILGRIM413_SQ_08') == 'YES' then
                    UnHideNPC(P_list[p], "PILGRIM413_SQ_08")
                end
            end
        end
    end
end

function SCR_PILGRIM413_SQ_08_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM413_SQ_08_1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM413_SQ_09_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM413_SQ_05_P(self)
    local x, y, z = -723.01, 62.02, 545.33
    SCR_HIDE_AND_FOLLOWNPC(self, 'PILGRIM413_SQ_02', 'PILGRIM41_3_SQ05', 'f_pilgrimroad_41_3', x, y, z, 'PILGRIM41_3_SQ05_FOLLOWER', 'npc_frair_f_03', 'Our_Forces', PILGRIM413_SQ_05_P_RUN, 1, 0, "SSN_PILGRIM41_3_P")
end

function PILGRIM413_SQ_05_P_RUN(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'PILGRIM41_1_SQ05_P'
    mon.Dialog = 'None'
    mon.Name = ScpArgMsg("PILGRIM41_3_SQ05_P")
    mon.MHP_BM = 15000
    mon.RunMSPD = 72
end

function SCR_SSN_PILGRIM41_3_P_BASIC_HOOK(self, sObj)
end

function SCR_CREATE_SSN_PILGRIM41_3_P(self, sObj)
    SetTimeSessionObject(self, sObj, 1, 1000, 'SCR_SSN_PILGRIM41_3_P_CHECK')
end

function SCR_REENTER_SSN_PILGRIM41_3_P(self)
    SetTimeSessionObject(self, sObj, 1, 1000, 'SCR_SSN_PILGRIM41_3_P_CHECK')
end

function SCR_DESTROY_SSN_PILGRIM41_3_P(self)
end

function SCR_SSN_PILGRIM41_3_P_CHECK(self, sObj, remainTime)
    SCR_SSN_AROUND_HATE_TIMER(self, sObj, remainTime)
    local owner = GetOwner(self)
    if owner ~= nil then
        local result = SCR_QUEST_CHECK(owner,'PILGRIM41_3_SQ05')
        if result ~= nil then
            if result == 'PROGRESS' then
                if GetLayer(owner) == 0 then
                    local quest_ssn = GetSessionObject(owner, 'SSN_PILGRIM41_3_SQ05')
                    if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                        local x, y, z = 780.22, 52.28, 426.5
                        local list, cnt = SelectObjectByClassName(self, 80, 'HiddenTrigger6')
                        local i
                    	if cnt ~= 0 then
                    	    for i = 1, cnt do
                    	        if list[i].Enter == 'PILGRIM413_SQ_05' then
                                    ClearSimpleAI(self, 'ALL')
                                    if self.NumArg1 == 0 then
                                        self.NumArg1 = 1
                                    end
                                    MoveEx(self, x, y, z, 0)
                                    if self.NumArg1 == 1 then
                                        self.NumArg1 = 2
                                        Chat(self, ScpArgMsg("PILGRIM41_3_SQ05_SUCCESS"), 3)
                                    end
                                end
                            end
                        end
                        if GetDistFromPos(self, x, y, z) <= 2 then
                            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                            SaveSessionObject(owner, quest_ssn)
                            if quest_ssn.QuestInfoValue1 == quest_ssn.QuestInfoMaxCount1 then
                                Kill(self)
                                if isHideNPC(owner, 'PILGRIM413_SQ_06') == 'YES' then
                                    UnHideNPC(owner, 'PILGRIM413_SQ_06')
                                end
                            end
                        end
                    end
                    if IsDead(owner) == 1 or IsDead(self) == 1 then
                        if quest_ssn.QuestInfoValue1 ~= quest_ssn.QuestInfoMaxCount1 then
                            RunScript('ABANDON_Q_BY_NAME', owner, "PILGRIM41_3_SQ05", 'FAIL')
                            SendAddOnMsg(owner, "NOTICE_Dm_!", ScpArgMsg("PILGRIM41_3_SQ05_FAIL"), 5)
                        end
                    end
                end
            end
        end
    end
end

function SCR_PILGRIM413_SQ_07_EFFECT1(self)
    PlayEffect(self, 'F_circle011_dark', 2, 'BOT')
    PlayEffect(self, 'F_circle011_dark', 1, 'BOT')
    AttachEffect(self, 'I_smoke013_dark3', 2, "BOT")
end

function SCR_PILGRIM413_SQ_07_EFFECT2(self)
    PlayEffect(self, 'F_circle011_dark', 2, 'BOT')
    PlayEffect(self, 'F_circle011_dark', 1, 'BOT')
    AttachEffect(self, 'F_levitation028_smoke', 2, "BOT")
    local pc_list, pc_cnt = GetLayerPCList(self);
    for i = 1, pc_cnt do
        CameraShockWave(pc_list[i], 2, 99999, 2, 0.8, 20, 0)
    end
end

function SCR_PILGRIM413_SQ_07_EFFECT3(self)
    PlayEffect(self, 'F_circle011_dark', 2, 'BOT')
    PlayEffect(self, 'F_circle011_dark', 1, 'BOT')
    AttachEffect(self, 'F_smoke019_dark_loop', 1.5, "BOT")
    local pc_list, pc_cnt = GetLayerPCList(self);
    for i = 1, pc_cnt do
        CameraShockWave(pc_list[i], 2, 99999, 5, 0.8, 30, 0)
    end
end

function SCR_PILGRIM413_SQ_07_NPCMOVE(self)
    local owner = GetOwner(self)
    if owner ~= nil then
        local x, y, z = 988.65, 45.04, 1036.45
        MoveEx(self, x, y, z, 0)
        if GetDistFromPos(self, x, y, z) <= 2 then
            if GetZoneName(owner) == 'f_pilgrimroad_41_3' then
                SCR_PARTY_QUESTPROP_ADD(owner, 'SSN_PILGRIM41_3_SQ07', 'QuestInfoValue1', 1)
                Kill(self)
            end
        end
    end
end

function SCR_PILGRIM413_SQ_08_RECOVERY(self)
    AddHP(self, self.MHP/10)
	AddSP(self, self.MSP/10)
end

function SCR_PILGRIM413_SQ_08_NPCMOVE(self)
    local owner = GetOwner(self)
    if owner ~= nil then
        if GetLayer(owner) ~= 0 then
            local result = SCR_QUEST_CHECK(owner, 'PILGRIM41_3_SQ08')
            if result == 'SUCCESS' then
                if self.NumArg1 == 0 then
                    self.NumArg1 = 1
                end
                local x, y, z = 1001.34, 52.28, 1197.20
                MoveEx(self, x, y, z, 0)
                if GetDistFromPos(self, x, y, z) <= 2 then
                    if GetZoneName(owner) == 'f_pilgrimroad_41_3' then
                        SetLayer(owner, 0)
                        Kill(self)
                    end
                end
            end
            if self.NumArg1 == 1 then
                self.NumArg1 = 2
                Chat(self, ScpArgMsg("PILGRIM41_3_SQ08_SUCCESS"), 3)
            end
        else
            Kill(self)
        end
    end
end

function SCR_PILGRIM413_FOLLOWER_RE(self)
    local result = SCR_QUEST_CHECK(self, 'PILGRIM41_3_SQ05')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_pilgrimroad_41_3' and GetLayer(self) == 0 then
            local list = GetScpObjectList(self, 'PILGRIM41_3_SQ05_FOLLOWER')
            if #list == 0 then
                if isHideNPC(self, 'PILGRIM413_SQ_02') == 'YES' then
                    local x, y, z = GetPos(self)
                    SCR_HIDE_AND_FOLLOWNPC(self, 'PILGRIM413_SQ_02', 'PILGRIM41_3_SQ05', 'f_pilgrimroad_41_3', x, y, z, 'PILGRIM41_3_SQ05_FOLLOWER', 'npc_frair_f_03', 'Our_Forces', PILGRIM413_SQ_05_P_RUN, 1, 0, "SSN_PILGRIM41_3_P")
                end
            end
        end
    end
end

function SCR_PILGRIM413_SQ_01_ABANDON(self, tx)
    if GetZoneName(self) == 'f_pilgrimroad_41_3' then
        SCR_SETPOS_FADEOUT(self, 'f_pilgrimroad_41_3', -1380, 62, 707)
    end
end

function SCR_PILGRIM413_SQ_05_ABANDON(self, tx)
    if isHideNPC(self, 'PILGRIM413_SQ_02') == 'YES' then
        UnHideNPC(self, "PILGRIM413_SQ_02")
    end
    if isHideNPC(self, 'PILGRIM413_SQ_06') == 'NO' then
        HideNPC(self, "PILGRIM413_SQ_06")
    end
    local follower = GetScpObjectList(self, 'PILGRIM41_3_SQ05_FOLLOWER')
    if #follower ~= 0 then
        local i
        for i = 1, #follower do
            Kill(follower[i])
        end
    end
end

function SCR_PILGRIM413_SQ_07_ABANDON(self, tx)
    if isHideNPC(self, 'PILGRIM413_SQ_07') == 'YES' then
        UnHideNPC(self, "PILGRIM413_SQ_07")
    end
    if isHideNPC(self, 'PILGRIM413_SQ_06') == 'YES' then
        UnHideNPC(self, "PILGRIM413_SQ_06")
    end
    if isHideNPC(self, 'PILGRIM413_SQ_08') == 'NO' then
        HideNPC(self, "PILGRIM413_SQ_08")
    end
end


--Shadowmancer Master


function SCR_JOB_SHADOWMANCER_MASTER_DIALOG(self,pc)
    local jobCircle = GetJobGradeByName(pc, 'Char2_19') -- checking your shadowmancer grade
    if jobCircle > 0 then
        COMMON_QUEST_HANDLER(self,pc)
    elseif IS_KOR_TEST_SERVER() then -- if you not enter test server
        COMMON_QUEST_HANDLER(self,pc)
    else -- if you not enter test server
        SCR_JOB_SHADOWMANCER_MASTER_UNLOCK_DOING(self, pc)
    end
end


function SCR_JOB_SHADOWMANCER_MASTER_UNLOCK_DOING(self, pc)
    local hiddenProp = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19') -- checking your hidden job property of shadowmancer
    if hiddenProp == 3 then -- if you check shadowmancer's existent
        local sel = ShowSelDlg(pc, 0, 'JOB_SHADOWMANCER_START_DLG', ScpArgMsg('JOB_SHADOWMANCER1_YES'), ScpArgMsg('JOB_SHADOWMANCER1_NO'))
        if sel == 1 then -- if you accept shadowmancer's request
            ShowOkDlg(pc, "JOB_SHADOWMANCER_AGREE_DLG", 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char2_19', 4)
            CreateSessionObject(pc, 'SSN_JOB_SHADOWMANCER_UNLOCK')
        end
    elseif hiddenProp == 4 then -- if you accept shadowmancer's request
        local inv1 = GetInvItemCount(pc, "JOB_SHADOWMANCER_OBJECT")
        local inv2 = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_43_3_TRACE")
        local inv3 = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_42_1_TRACE")
        local inv4 = GetInvItemCount(pc, "JOB_SHADOWMANCER_MAPLE_25_3_TRACE")
        local inv5 = GetInvItemCount(pc, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
        if inv1 >= 4 and inv2 >= 1 and inv3 >= 1 and inv4 >= 1 and inv5 >= 1 then -- if you collect all shadowmancer's unlock item
            ShowOkDlg(pc, "JOB_SHADOWMANCER_COMPLETE_DLG", 1)
            local tx = TxBegin(pc)
            TxTakeItem(tx, 'JOB_SHADOWMANCER_OBJECT', inv1, "JOB_SHADOWMANCER_OBJECT")
            TxTakeItem(tx, 'JOB_SHADOWMANCER_BRACKEN_43_3_TRACE', inv2, "JOB_SHADOWMANCER_BRACKEN_43_3_TRACE")
            TxTakeItem(tx, 'JOB_SHADOWMANCER_BRACKEN_42_1_TRACE', inv3, "JOB_SHADOWMANCER_BRACKEN_42_1_TRACE")
            TxTakeItem(tx, 'JOB_SHADOWMANCER_MAPLE_25_3_TRACE', inv4, "JOB_SHADOWMANCER_MAPLE_25_3_TRACE")
            TxTakeItem(tx, 'JOB_SHADOWMANCER_REMAINS_37_2_TRACE', inv5, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
            local ret = TxCommit(tx)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char2_19', 100)
            local ret1 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char2_19')
        else -- if you not collect shadowmancer's unlock item
            local sel = ShowSelDlg(pc, 0, 'JOB_SHADOWMANCER_PROGRESS', ScpArgMsg('JOB_SHADOWMANCER_BRACKEN_42'), ScpArgMsg('JOB_SHADOWMANCER_MAPLE_25'), ScpArgMsg('JOB_SHADOWMANCER_BRACKEN_43'), ScpArgMsg('JOB_SHADOWMANCER_REMAINS_37'), ScpArgMsg('JOB_SHADOWMANCER_EXIT'))
            if sel == 1 then -- if you know f_bracken_42's gimmick
                ShowOkDlg(pc, 'JOB_SHADOWMANCER_BRACKEN_42', 1)
            elseif sel == 2 then -- if you know f_maple's gimmick
                ShowOkDlg(pc, 'JOB_SHADOWMANCER_MAPLE_25', 1)
            elseif sel == 3 then -- if you know f_bracken_43's gimmick
                ShowOkDlg(pc, 'JOB_SHADOWMANCER_BRACKEN_43', 1)
            elseif sel == 4 then -- if you know f_remains_37's gimmick
                ShowOkDlg(pc, 'JOB_SHADOWMANCER_REMAINS_37', 1)
            end
        end
    elseif hiddenProp == 2 then -- if you meet CHRONOMANCER MASTER
        ShowOkDlg(pc, 'JOB_SHADOWMANCER_UNLOCK_DLG', 1)
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char2_19', 3)
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end