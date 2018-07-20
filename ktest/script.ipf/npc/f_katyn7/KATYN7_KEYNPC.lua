
function SCR_KATYN7_KEYNPC_1_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_KATYN7_KEYNPC_1_TRIGGER_ENTER(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_KATYN7_KEYNPC_3_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_KATYN7_KEYNPC_1_NORMAL_1_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 20 then
        local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
        if sObj ~= nil then
            if sObj.Goal2 < 1 then
                if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') == 1 then
                    return 'YES'
        	    end
        	end
    	end
    end
end

function SCR_KATYN7_KEYNPC_1_NORMAL_1(self, pc)
    local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if sObj ~= nil then
        ShowOkDlg(pc, "CHAR313_MSTEP4_1_DLG2")
        if sObj.Goal1 ~= 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR313_MSTEP4_1_MSG1"), 5);
        end
        sObj.Goal2 = 1
        SaveSessionObject(pc, sObj)
        if sObj.Goal1 == 1 and sObj.Goal2 == 1 and sObj.Goal3 == 1 then
            if hidden_prop < 40 then
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 40)
            end
        end
    end
end

function SCR_KATYN7_KEYNPC_4_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_KATYN7_KEYNPC_5_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_CREATE_SSN_KATYN_KEY_01(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
    SetTimeSessionObject(self, sObj, 1, 1000, "KATYN7_KEYNPC_3_UNHIDE")
end

function SCR_REENTER_SSN_KATYN_KEY_01(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'NO')
    SetTimeSessionObject(self, sObj, 1, 1000, "KATYN7_KEYNPC_3_UNHIDE")
end

function SCR_DESTROY_SSN_KATYN_KEY_01(self, sObj)
end

function KATYN7_KEYNPC_3_UNHIDE(self, sObj)
    local quest_Result = SCR_QUEST_CHECK(self, "KATYN_KEY_01")
    if quest_Result == "SUCCESS" then
        UnHideNPC(self, "KATYN7_KEYNPC_3")
    end
end

function SUCH_POINT_05_ABANDON(self)
    RunZombieScript('GIVE_ITEM_TX', self, 'katyn_7_Messenger', 1, "Quest")
end

function SCR_KATYN7_KEYNPC_1_NORMAL_2_PRE(pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 20 then
        return 'YES'
    end
end

function SCR_KATYN7_KEYNPC_1_NORMAL_2(self, pc)
    --PIED_PIPER_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_12')
    if prop >= 20 then
        if prop < 30 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR312_PRE_MSTEP2_VACENIN_TXT1"), 'TALK', 3)
            if result == 1 then
                local select = ShowSelDlg(pc, 0, 'CHAR312_PRE_MSTEP2_VACENIN_DLG1', ScpArgMsg('CHAR312_PRE_MSTEP2_VACENIN_TXT2'), ScpArgMsg('CHAR312_PRE_MSTEP2_VACENIN_TXT3'))
                if select == 1 then
                    local tx = TxBegin(pc)
                    if isHideNPC(pc, "CHAR312_PRE_MSTEP1_SOLDIER1") == "NO" then
                        TxHideNPC(tx, 'CHAR312_PRE_MSTEP1_SOLDIER1')
                    end
                    local ret = TxCommit(tx)
                    if ret == "SUCCESS" then
                        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_12', 30)
                        ShowOkDlg(pc, 'CHAR312_PRE_MSTEP2_VACENIN_DLG2', 1)
                        sleep(500)
                        ShowBalloonText(pc, 'CHAR312_PRE_MSTEP2_VACENIN_DLG5', 7)
                    end
                else
                    ShowOkDlg(pc, 'CHAR312_PRE_MSTEP2_VACENIN_DLG3', 1)
                end
            end
        else
            ShowOkDlg(pc, 'CHAR312_PRE_MSTEP2_VACENIN_DLG4', 1)
            sleep(500)
            ShowBalloonText(pc, 'CHAR312_PRE_MSTEP2_VACENIN_DLG5', 7)
        end
    end
end