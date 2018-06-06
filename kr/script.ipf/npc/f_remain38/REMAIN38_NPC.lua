function SCR_REMAIN38_MQ_MONUMENT1_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_QUARREL4_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
        if quest_ssn.QuestInfoValue1 == 0 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_tack_bon_01"), 'MAKING', 2);
            if result2 == 1 then
                local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
                if (quest_ssn.QuestInfoValue1 + quest_ssn.QuestInfoValue2 + quest_ssn.QuestInfoValue3 + quest_ssn.QuestInfoValue4 + quest_ssn.QuestInfoValue5) == 4 then
                    if  quest_ssn.Goal2 == 0 then
                        PlayDirection(pc, 'JOB_QUARREL4_1_TRACK')
                        SetArgObj4(quest_ssn, self)
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue1', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                else
                    if  quest_ssn.Goal1 == 0 then
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue1', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue1', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                end
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_tack_bon_02"), 3);
        end
    end
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_REMAIN38_MQ_MONUMENT2_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_QUARREL4_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
        if quest_ssn.QuestInfoValue2 == 0 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_tack_bon_01"), 'MAKING', 2);
            if result2 == 1 then
                local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
                if (quest_ssn.QuestInfoValue1 + quest_ssn.QuestInfoValue2 + quest_ssn.QuestInfoValue3 + quest_ssn.QuestInfoValue4 + quest_ssn.QuestInfoValue5) == 4 then
                    if  quest_ssn.Goal2 == 0 then
                        PlayDirection(pc, 'JOB_QUARREL4_1_TRACK')
                        SetArgObj4(quest_ssn, self)
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue1', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                else
                    if  quest_ssn.Goal1 == 0 then
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue2', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue2', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                end
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_tack_bon_02"), 3);
        end
    end
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_REMAIN38_MQ_MONUMENT3_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_QUARREL4_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
        if quest_ssn.QuestInfoValue3 == 0 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_tack_bon_01"), 'MAKING', 2);
            if result2 == 1 then
                local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
                if (quest_ssn.QuestInfoValue1 + quest_ssn.QuestInfoValue2 + quest_ssn.QuestInfoValue3 + quest_ssn.QuestInfoValue4 + quest_ssn.QuestInfoValue5) == 4 then
                    if  quest_ssn.Goal2 == 0 then
                        PlayDirection(pc, 'JOB_QUARREL4_1_TRACK')
                        SetArgObj4(quest_ssn, self)

                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue1', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                else
                    if  quest_ssn.Goal1 == 0 then
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue3', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue3', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                end
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_tack_bon_02"), 3);
        end
    end
    local result = SCR_QUEST_CHECK(pc, 'REMAIN38_MQ03')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_REMAIN38_MQ03')
        if quest_ssn ~= nil then
            local list, cnt = GetInvItemByName(pc, 'REMAIN38_MQ03_1_ITEM')
            if cnt >= 10 then
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_tack_bon_01"), 'MAKING', 2);
                if result2 == 1 then
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("SSN_REMAIN38_MQ03_1"), 3);
                    PlayEffect(self, 'F_lineup001', 1)
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAIN38_MQ03', 'QuestInfoValue2', nil, 1, 'REMAIN38_MQ03_ITEM/1','REMAIN38_MQ03_1_ITEM/'..cnt)
                    ShowOkDlg(pc, 'REMAIN38_MQ03_02_2', 1)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("SSN_REMAIN38_MQ03"), 3);
            end
        end
    elseif result == 'SUCCESS' then
        ShowOkDlg(pc, 'REMAIN38_MQ03_02_2', 1)
    end
    COMMON_QUEST_HANDLER(self,pc)    
end

function SCR_REMAIN38_MQ_MONUMENT4_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_QUARREL4_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
        if quest_ssn.QuestInfoValue4 == 0 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_tack_bon_01"), 'MAKING', 2);
            if result2 == 1 then
                local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
                if (quest_ssn.QuestInfoValue1 + quest_ssn.QuestInfoValue2 + quest_ssn.QuestInfoValue3 + quest_ssn.QuestInfoValue4 + quest_ssn.QuestInfoValue5) == 4 then
                    if  quest_ssn.Goal2 == 0 then
                        PlayDirection(pc, 'JOB_QUARREL4_1_TRACK')
                        SetArgObj4(quest_ssn, self)
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue1', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                else
                    if  quest_ssn.Goal1 == 0 then
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue4', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue4', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                end
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_tack_bon_02"), 3);
        end
    end
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_REMAIN38_MQ_MONUMENT5_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_QUARREL4_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
        if quest_ssn.QuestInfoValue5 == 0 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_tack_bon_01"), 'MAKING', 2);
            if result2 == 1 then
                local quest_ssn = GetSessionObject(pc, 'SSN_JOB_QUARREL4_1')
                if (quest_ssn.QuestInfoValue1 + quest_ssn.QuestInfoValue2 + quest_ssn.QuestInfoValue3 + quest_ssn.QuestInfoValue4 + quest_ssn.QuestInfoValue5) == 4 then
                    if  quest_ssn.Goal2 == 0 then
                        PlayDirection(pc, 'JOB_QUARREL4_1_TRACK')
                        SetArgObj4(quest_ssn, self)
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue1', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                else
                    if  quest_ssn.Goal1 == 0 then
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue5', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'Goal1', 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    else
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_QUARREL4_1', 'QuestInfoValue5', 1, nil,'JOB_QUARREL4_1_ITEM/1')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_tack_bon_03"), 3);
                        return
                    end
                end
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_tack_bon_02"), 3);
        end
    end
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_REMAIN38_HUNTER_DIALOG(self, pc)
    local hta_result1 = SCR_QUEST_CHECK(pc, 'BRACKEN42_1_SQ10')
    local hta_result2 = SCR_QUEST_CHECK(pc, 'REMAIN38_MQ06')
    local hta_result3 = SCR_QUEST_CHECK(pc, 'REMAIN38_MQ07')
    if hta_result1 == "COMPLETE" and hta_result2 == "COMPLETE" and hta_result3 == "COMPLETE" then
    
        local hta_sObj = GetSessionObject(pc, "SSN_DIALOGCOUNT")
        if hta_sObj ~= nil then
            if hta_sObj.REMAIN38_HUNTER < 1 then
            
                local hta_num = IMCRandom(1,4)
                --Chat(pc, hta_num)
                if hta_num == 1 then
            
                    local hta_sel1 = ShowSelDlg(pc, 0, 'HTA_REMAIN38_HUNTER_BASIC01', ScpArgMsg("HTA_REMAIN38_HUNTER_SEL01"), ScpArgMsg("HTA_REMAIN38_HUNTER_SEL02"))
                    if hta_sel1 == 1 then
                        ShowOkDlg(pc, "HTA_REMAIN38_HUNTER_BASIC02")
                        hta_sObj.REMAIN38_HUNTER = 1
                        SaveSessionObject(pc, hta_sObj)
                    else
                        COMMON_QUEST_HANDLER(self,pc)
                    end
                else
                    COMMON_QUEST_HANDLER(self,pc)
                end
            else
                ShowOkDlg(pc, "HTA_REMAIN38_HUNTER_BASIC0"..IMCRandom(3, 4))
            end
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_REMAIN38_HUNTER_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 15, "CHAR120_REMAIN38_HUNTER1", "CHAR120_REMAIN38_HUNTER2")
end

function SCR_REMAIN38_HUNTER_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_REMAIN38_SQ_DRASIUS_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_REMAIN38_SQ_DRASIUS_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 14, "CHAR120_REMAIN38_SQ_DRASIUS1", "CHAR120_REMAIN38_SQ_DRASIUS2")
end

function SCR_REMAIN38_SQ_DRASIUS_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_REMAIN38_SQ01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_REMAIN38_SQ06_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end



function SCR_REMAIN38_MQ07_AFTER_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'REMAIN38_MQ07')
    if result1 == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("SSN_REMAIN38_MQ07_MON"), '#SITGROPESET', 2);
        if result2 == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("SSN_REMAIN38_MQ07_MON_2"), 3);
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAIN38_MQ07', 'QuestInfoValue1', 1, nil, 'REMAIN38_MQ07_1_ITEM/1')
            Kill(self)
        end
    end
end



function SCR_SSN_REMAIN38_MQ07_MON_DIALOG(self, pc)
    local result2 = SCR_QUEST_CHECK(pc, 'REMAIN38_SQ04')
    if result2 == 'PROGRESS' then
        if GetCurrentFaction(self) == 'Monster' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("SSN_REMAIN38_SQ03_MON"), 'MAKING', 0.2);
            if result2 == 1 then
                if IsBuffApplied(self, 'REMAIN38_SQ04') == 'NO' then
                    AddBuff(pc, self, 'REMAIN38_SQ04', 1, 0, 60000, 1)
                end
            end
        end
    end
end



function SCR_SSN_REMAIN38_SQ03_MON_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'REMAIN38_SQ03')
    if result == 'PROGRESS' then
        if GetCurrentFaction(self) == 'Monster' then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("SSN_REMAIN38_SQ03_MON"), 'MAKING', 0.2);
            if result2 == 1 then
                if IsBuffApplied(self, 'REMAIN38_SQ03') == 'NO' then

                    AddBuff(pc, self, 'REMAIN38_SQ03', 1, 0, 60000, 1)
                end
            end
        end
    end
end


function SCR_REMAIN38_SQ02_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'REMAIN38_SQ02')
    if result == 'PROGRESS' then
        if self.NumArg2 == 0 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("SSN_REMAIN38_MQ07_MON"), '#SITGROPESET', 2);
            if result2 == 1 then
                self.NumArg2 = 1
                local list, cnt = SelectObjectByFaction(self, 150, 'Monster')
                local i
                for i = 1, cnt do
                    InsertHate(list[i], pc, 1)
                end
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("REMAIN38_SQ02_ITEM"), 3);
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAIN38_SQ02', 'QuestInfoValue1', 1, nil, 'REMAIN38_SQ02_ITEM/1')
                self.NumArg2 = 1
                KILL_BLEND(self, 2.5)
            end
        end
    end
end


function REMAIN38_SQ01_BALLOON(self)
    ShowBalloonText(self, "REMAIN38_SQ01_BALLOON", 3)
end


function REMAIN38_MQ03_FAILED(self)
    local list, cnt = GetInvItemByName(self, 'REMAIN38_MQ03_1_ITEM')
    if cnt > 0 then
        RunScript('TAKE_ITEM_TX', self, 'REMAIN38_MQ03_1_ITEM', cnt, "Quest")
    end
end