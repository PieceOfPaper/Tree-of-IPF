function SCR__DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_LEOPOLDAS_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_JURATE_DIALOG(self, pc)
--    COMMON_QUEST_HANDLER(self, pc)
    -- HIDDEN MIKO --
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_48_SQ_060')
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_18')
    if result == 'COMPLETE' and _hidden_prop < 1 then
        local sel = ShowSelDlg(pc, 0, 'HIDDEN_MIKO_JURATE_dlg1', ScpArgMsg('HIDDEN_MIKO_JURATE_MSG1'),ScpArgMsg('Close'))
        if sel == 1 then
            local tx1 = TxBegin(pc);
            TxGiveItem(tx1, "HIDDEN_MIKO_ITEM_1", 1, "Quest_HIDDEN_MIKO");
            local ret = TxCommit(tx1);
            if ret == 'SUCCESS' then
                local _hide_list = { 'HIDDEN_MIKO_EBISU',
                                    'HIDDEN_MIKO_DAIKOKUTEN',
--                                    'HIDDEN_MIKO_BISHAMONTEN',
--                                    'HIDDEN_MIKO_BENZAITEN',
                                    'HIDDEN_MIKO_FUKUROKUSHU',
                                    'HIDDEN_MIKO_JUROTA',
--                                    'HIDDEN_MIKO_HOTEI'
                                    'HIDDEN_MIKO_CMINE_6_1',
                                    'HIDDEN_MIKO_CMINE_6_2',
                                    'HIDDEN_MIKO_CMINE_6_3',
                                    'HIDDEN_MIKO_CMINE_6_4',
                                    'HIDDEN_MIKO_CMINE_6_5',
                                    'HIDDEN_MIKO_CMINE_6_6',
                                    'HIDDEN_MIKO_CMINE_6_7'
                                    }
                for i = 1, #_hide_list do
                    UnHideNPC(pc, _hide_list[i])
                end
                
                local sObj = GetSessionObject(pc, 'SSN_HIDDEN_MIKO')
                if sObj == nil then
                    CreateSessionObject(pc, 'SSN_HIDDEN_MIKO')
                end
                
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_18', 1)
            end
        else
            return;
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end

function SCR_PILGRIM_48_MARCELIJUS_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_GERDA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_SERAPINAS_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_NPC02_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_NPC01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_NPC03_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_BOARDPLACE_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_EXCAVATION01_DIALOG(self, pc)
    local quest_ssn = GetSessionObject(pc, 'SSN_PILGRIM_48_SQ_040')
    if quest_ssn ~= nil then
        if quest_ssn.QuestInfoValue1 < 1 then
    
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 4, 'PILGRIM_48_SQ_040')
            local result2 = DOTIMEACTION_R_DUMMY_ITEM(pc, ScpArgMsg("PILGRIM_48_SQ_040_MSG01"), 'skl_assistattack_shovel', animTime, 'SSN_HATE_AROUND', nil, 630012, "RH")
            DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'PILGRIM_48_SQ_040')
            if result2 == 1 then    
                AttachEffect(self, 'F_pc_making_finish_white', 1, 'TOP')
                SCR_PARTY_QUESTPROP_ADD(pc, "SSN_PILGRIM_48_SQ_040", "QuestInfoValue1", 1, nil, "PILGRIM_48_SQ_040_ITEM_1/1")
                SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('PILGRIM_48_SQ_040_MSG02'), 5)
            end
        end
    end
end

function SCR_PILGRIM_48_SQ_050_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_EXCAVATION03_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_PILGRIM_48_SQ_090_TRAP_MON_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_48_SQ_090')
    if result == 'PROGRESS' then
    
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'PILGRIM_48_SQ_090')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM_48_SQ_090_MSG05"), 'SITGROPE', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'PILGRIM_48_SQ_090')
        if result2 == 1 then    
            
            AttachEffect(self, 'F_pc_making_finish_white', 1, 'TOP')
            SCR_PARTY_QUESTPROP_ADD(pc, "SSN_PILGRIM_48_SQ_090", "QuestInfoValue1", 1, nil, "PILGRIM_48_SQ_090_ITEM_2/1")
            SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('PILGRIM_48_SQ_090_MSG06'), 5)
            PlayEffect(self, 'F_burstup020_smoke', 0.5, nil, 'BOT')
            
            local trap_list, trap_cnt = SelectObject(self, 30, "ALL", 1)
            local i 
            for i = 1, trap_cnt do
                if  trap_list[i].ClassName == "pilgrim_trap_01" then
                    Dead(trap_list[i])
                end
            end
            Kill(self)
        end
    end
end


function SCR_PILGRIM_48_BOARD_DIALOG(self, pc)
    ShowOkDlg(pc, "PILGRIM_48_BOARD_BASIC01", 1)
end

function SCR_PILGRIM_48_SQ_060_RELIC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM_48_SQ_060')
    if result == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 3, 'PILGRIM_48_SQ_060')
        local result2 = DOTIMEACTION_R_DUMMY_ITEM(pc, ScpArgMsg("PILGRIM_48_SQ_060_MSG06"), 'skl_assistattack_shovel', animTime, 'SSN_HATE_AROUND', nil, 630012, "RH")
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'PILGRIM_48_SQ_060')
        if result2 == 1 then           
            AttachEffect(self, 'F_pc_making_finish_white', 1, 'TOP')
            SCR_PARTY_QUESTPROP_ADD(pc, "SSN_PILGRIM_48_SQ_060", "QuestInfoValue1", 1, nil, "PILGRIM_48_SQ_070_ITEM_1/1")
            SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('PILGRIM_48_SQ_060_MSG07'), 5) 
            Dead(self)
        end
    end
end
function SCR_PILGRIM_48_SQ_060_E_ENTER(self, pc)
end
function SCR_PILGRIM_48_SQ_090_E_ENTER(self, pc)
end

function SCR_INQUISITOR_MASTER_DIALOG(self, pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_19')
    print(_hidden_prop)
    if _hidden_prop == 1 then
        local select = ShowSelDlg(pc, 0, 'JOB_INQUSITOR_ZEALOT_UNLOCK3', ScpArgMsg('JOB_ZEALOT_SELECT1'), ScpArgMsg('JOB_ZEALOT_SELECT2'))
        if select == 1 then
            ShowOkDlg(pc, 'JOB_INQUSITOR_ZEALOT_UNLOCK1', 1)
            ShowBalloonText(pc, "JOB_INQUSITOR_ZEALOT_UNLOCK2", 5)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 2)
        else
            COMMON_QUEST_HANDLER(self, pc)
        end
    elseif _hidden_prop >= 2 and _hidden_prop <= 5 then
        local select = ShowSelDlg(pc, 0, 'JOB_INQUSITOR_ZEALOT_UNLOCK3', ScpArgMsg('JOB_ZEALOT_SELECT1'), ScpArgMsg('JOB_ZEALOT_SELECT2'))
        if select == 1 then
            ShowOkDlg(pc, 'JOB_INQUSITOR_ZEALOT_UNLOCK1', 1)
            ShowBalloonText(pc, "JOB_INQUSITOR_ZEALOT_UNLOCK2", 5)
        else
            COMMON_QUEST_HANDLER(self, pc)
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end


function SCR_PILGRIM_48_LEOPOLDAS_NORMAL_1_PRE(pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop == 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step8 == 1 then
                return 'YES'
            end
        end
    end
end


function SCR_PILGRIM_48_LEOPOLDAS_NORMAL_1(self,pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop >= 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            local npc_name = ScpArgMsg("CHAR220_MSETP1_ITEM_TXT6")
            if sObj.Step8 == 1 then
                if sObj.Goal8 == 0 then
                    local select = ShowSelDlg(pc, 1, "CHAR220_MSETP2_6_DLG1", ScpArgMsg("CHAR220_MSETP2_QUEST_OK_MSG"), ScpArgMsg("CHAR220_MSETP2_QUEST_NO_MSG"))
                    if select == 1 then
                        local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_6_ITEM1")
                        if cnt < 1 then
                            RunScript('GIVE_ITEM_TX', pc, "CHAR220_MSTEP2_6_ITEM1", 1, "CHAR220_MSTEP2_6");
                        end
                        sObj.Goal8 = 1
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_6_DLG1_1", 1)
                        sleep(500)
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_EFFECT_SET_MSG"), 10)
                        return
                    end
                elseif sObj.Goal8 == 1 then
                    local max_cnt = 20
                    local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_6_ITEM2")
                    if cnt >= max_cnt then
                        sObj.Goal8 = 10
                        SaveSessionObject(pc, sObj)
                        RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_6_ITEM2", cnt, "CHAR220_MSTEP2_6");
                        local cnt_else = GetInvItemCount(pc, "CHAR220_MSTEP2_6_ITEM1")
                        if cnt_else > 0 then
                            RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_6_ITEM1", cnt_else, "CHAR220_MSTEP2_6");
                        end
                        ShowOkDlg(pc, "CHAR220_MSETP2_6_DLG3", 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    else
                        ShowOkDlg(pc, "CHAR220_MSETP2_6_DLG2", 1)
                        sleep(500)
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHAR220_MSETP2_EFFECT_SET_MSG"), 10)
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("CHAR220_MSETP2_CLEAR{NPC_NAME}", "NPC_NAME", npc_name), 7)
                    ShowOkDlg(pc, "CHAR220_MSETP2_6_DLG4", 1)
                end
            end
        end
    end
end