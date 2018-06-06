function SCR_C_ORSHA_HAMONDAIL_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
end

function SCR_C_ORSHA_HAMONDAIL_NORMAL_1_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 20 then
        local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
        if sObj ~= nil then
            if sObj.Goal1 < 1 then
                if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') == 1 then
                    return 'YES'
                end
            end
        end
    end
end

function SCR_C_ORSHA_HAMONDAIL_NORMAL_2_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 40 then
        local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') == 1 then
            if sObj.Goal1 == 1 and sObj.Goal2 == 1 and sObj.Goal3 == 1 then
                return 'YES'
            end
        end
    end
end

function SCR_C_ORSHA_HAMONDAIL_NORMAL_3_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 200 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM7') == 1 then
            return 'YES'
        end
    end
end

function SCR_C_ORSHA_HAMONDAIL_NORMAL_1(self, pc)
    if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') == 1 then
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
        local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
        ShowOkDlg(pc, "CHAR313_MSTEP4_1_DLG1")
        if sObj.Goal2 ~= 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR313_MSTEP4_1_MSG1"), 5);
        end
        sObj.Goal1 = 1
        SaveSessionObject(pc, sObj)
        if sObj.Goal1 == 1 and sObj.Goal2 == 1 and sObj.Goal3 == 1 then
            if hidden_prop < 40 then
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 40)
            end
        end
    end
end

function SCR_C_ORSHA_HAMONDAIL_NORMAL_2(self, pc)
    if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') == 1 then
        local sel = ShowSelDlg(pc, 0, "CHAR313_MSTEP5_1_DLG1", ScpArgMsg("CHAR313_MSTEP5_1_MSG1"), ScpArgMsg("CHAR313_MSTEP5_1_MSG2"))
        if sel == 1 then
            ShowOkDlg(pc, "CHAR313_MSTEP5_1_DLG2")
            local anim = DOTIMEACTION_R(pc, ScpArgMsg("CHAR313_MSTEP5_1_MSG3"), 'SCROLL', 2)
            if anim == 1 then
                ShowOkDlg(pc, "CHAR313_MSTEP5_1_DLG3")
            end
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 50)
            ShowBalloonText(pc, "CHAR313_MSTEP5_1_DLG4", 5)
        end
    end
end

function SCR_C_ORSHA_HAMONDAIL_NORMAL_3(self, pc)
    if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM7') == 1 then
        ShowOkDlg(pc, "CHAR313_MSTEP11_1_DLG2")
        local anim = DOTIMEACTION_R(pc, ScpArgMsg("CHAR313_MSTEP11_1_MSG1"), 'TALK', 1)
        if anim == 1 then
            ShowOkDlg(pc, "CHAR313_MSTEP11_1_DLG3")
            local tx1 = TxBegin(pc);
            TxTakeItem(tx1, "KLAIPE_CHAR313_ITEM7", 1, 'HIDDEN_APPRAISER_MSTEP13_1');
            local ret = TxCommit(tx1);
            if ret == 'SUCCESS' then
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 250)
            end
        end
    end
end

function SCR_C_ORSHA_URBONAS_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_C_ORSHA_PRANAS_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_C_ORSHA_SOLDIER_01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end


function SCR_C_ORSHA_SOLDIER_02_DIALOG(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_12');
    if hidden_prop == nil or hidden_prop == 0 then
        local rnd = IMCRandom(1, 20);
        if rnd == 1 then
            ShowOkDlg(pc, 'C_ORSHA_SOLDIER_02_Chaplain_1', 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_12', 2)
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    elseif hidden_prop == 2 then
        ShowOkDlg(pc, 'C_ORSHA_SOLDIER_02_Chaplain_1', 1)
    elseif hidden_prop == 1 then
        ShowOkDlg(pc, 'C_ORSHA_SOLDIER_02_Chaplain_2', 1)
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_12', 12)
    elseif hidden_prop == 12 then
        ShowOkDlg(pc, 'C_ORSHA_SOLDIER_02_Chaplain_2', 1)
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end


function SCR_C_ORSHA_HAMONDAIL_NORMAL_4_PRE(pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop == 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step5 == 1 then
                return 'YES'
            end
        end
    end
end

function SCR_C_ORSHA_HAMONDAIL_NORMAL_4(self,pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop >= 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            local npc_name = ScpArgMsg("CHAR220_MSETP1_ITEM_TXT3")
            if sObj.Step5 == 1 then
                if sObj.Goal5 == 0 then
                    sObj.Goal5 = 1
                    SaveSessionObject(pc, sObj)
                    ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG1", 1)
                    return
                elseif sObj.Goal5 == 1 or sObj.Goal5 == 2 then
                    ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG2", 1)
                elseif sObj.Goal5 == 5 then
                    sObj.Goal5 = 10
                    SaveSessionObject(pc, sObj)
                    ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG7", 1)
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG8", 1)
                end
            end
        end
    end
end
