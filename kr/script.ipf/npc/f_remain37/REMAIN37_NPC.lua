




function SCR_REMAIN37_RAYMOND_DIALOG(self, pc)
    local hta_result1 = SCR_QUEST_CHECK(pc, "BRACKEN42_1_SQ10")
    local hta_result2 = SCR_QUEST_CHECK(pc, "REMAIN37_MQ05")
    local hta_result3 = SCR_QUEST_CHECK(pc, "REMAIN37_MQ02")
    local hta_result4 = SCR_QUEST_CHECK(pc, "REMAIN37_SQ08")
    local hta_sObj = GetSessionObject(pc, "SSN_DIALOGCOUNT")
    if hta_sObj ~= nil then
        if hta_sObj.REMAIN37_RAYMOND < 1 then
            if hta_result1 == "COMPLETE" and hta_result2 == "COMPLETE" and hta_result3 == "COMPLETE" and hta_result4 == "COMPLETE" then
                local hta_num = IMCRandom(1, 4)
                if hta_num == 1 then
                    local hta_sel1 = ShowSelDlg(pc, 0, 'REMAIN37_RAYMOND_BASIC02', ScpArgMsg("HTA_REMAIN37_RAYMOND_SEL01"), ScpArgMsg("HTA_REMAIN37_RAYMOND_SEL02"))
                    if hta_sel1 == 1 then
                        local hta_act = DOTIMEACTION_R(pc, ScpArgMsg("HTA_REMAIN37_RAYMOND_MSG01"), 'TALK', 2)
                        if hta_act == 1 then
                            ShowOkDlg(pc, "HTA_REMAIN37_RAYMOND_BASIC03")
                            hta_sObj.REMAIN37_RAYMOND = hta_sObj.REMAIN37_RAYMOND + 1
                            SaveSessionObject(pc, hta_sObj)
                        end
                    end 
                else
                    COMMON_QUEST_HANDLER(self, pc)            
                end
            else
                COMMON_QUEST_HANDLER(self, pc)
            end
        else
            ShowOkDlg(pc, "HTA_REMAIN37_RAYMOND_BASIC0"..IMCRandom(4,6))   
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end

function SCR_REMAIN37_RAYMOND_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 11, "CHAR120_REMAIN37_RAYMOND1", "CHAR120_REMAIN37_RAYMOND2")
end

function SCR_REMAIN37_RAYMOND_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_REMAIN37_SQ6_UNCLE1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_REMAIN37_SQ6_UNCLE1_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 13, "CHAR120_REMAIN37_SQ6_UNCLE1", "CHAR120_REMAIN37_SQ6_UNCLE2")
end

function SCR_REMAIN37_SQ6_UNCLE1_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function REMAIN37_SQ_06_TRIGGER(self)
    if self.ClassName == 'PC' then
        local npcLict, npcCount = SelectObject(self, 200, 'ALL', 1)
        for i = 1, npcCount do
            if npcLict[i].ClassName == 'npc_village_uncle_1' then
                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_REMAIN37_SQ06', 'QuestInfoValue1', 1)
                local val = GetMGameValue(self, 'REMAIN37_SQ06_MINI');
                val = val + 1
                SetMGameValue(self, 'REMAIN37_SQ06_MINI', val);
            end
        end
    end
end
function REMAIN37_SQ_06_NPCMOVESTOP(self)
    local msg ={
                ScpArgMsg('Auto_JeoKi_MonSeuTeoyeyo!'),
                ScpArgMsg('Auto_JoSimHaSeyo.'),
                ScpArgMsg('Auto_MonSeuTeoDeuli_uLil_DeopChyeosseoyo'),
                }
    local monNpc, monNpcCount = SelectObject(self, 70, 'ENEMY')
    if monNpcCount >= 1 then
        for i = 1, monNpcCount do
            if monNpc[i].ClassName == 'InfroBurk' or monNpc[i].ClassName == 'Gravegolem' or monNpc[i].ClassName == 'stub_tree' or monNpc[i].ClassName == 'Long_Arm' or monNpc[i].ClassName == 'Zolem' then
                StopMove(self)
                if IMCRandom(1, 40) >= 38 then
                    Chat(self, msg[IMCRandom(1,3)])
                end
            end
        end
    else
        MoveEx(self, 137, 1426, 2100, 1);
    end
end

function REMAIN37_MQ02_ITEM_CK(self)
    local list, cnt = GetInvItemByName(self, 'REMAIN37_MQ02_ITEM')
    if cnt < 1 then
        RunScript('GIVE_ITEM_TX', self, 'REMAIN37_MQ02_ITEM', 1, "Q_REMAIN37_MQ02_ITEM")
    end
end

function SCR_REMAIN37_MQ02_ITEM_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'REMAIN37_MQ02')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(pc, ScpArgMsg("REMAIN37_MQ02_ITEM_01"), 'LOOK', 1);
        if result1 == 1 then
            local RND = IMCRandom(1, 20)
            local quest_ssn = GetSessionObject(pc, 'SSN_REMAIN37_MQ02')
            if quest_ssn ~= nil then
                if quest_ssn.Goal1 < 5 then
                    if RND < 18 then
                        local list, cnt = SelectObjectByFaction(self, 200, 'Monster')
                        local i
                        if cnt > 0 then
                            for i = 1 , cnt do
                                InsertHate(list[i], pc, 2)
                            end
                        end
                        quest_ssn.Goal1 = quest_ssn.Goal1 + 1
                        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('REMAIN37_MQ02_ITEM_03'), 3);
                        Kill(self)
                    else
                        quest_ssn.Goal1 = 5
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAIN37_MQ02', 'QuestInfoValue1', nil, 1, "REMAINS37_MSTONE_01/1")
                        SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('REMAIN37_MQ02_ITEM_04'), 3);
                        Kill(self)
                    end
                else
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAIN37_MQ02', 'QuestInfoValue1', nil, 1, "REMAINS37_MSTONE_01/1")
                    SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('REMAIN37_MQ02_ITEM_04'), 3);
                    Kill(self)
                end
            end
        end
    end
end


function SCR_REMAIN37_MQ03_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end



function SCR_REMAIN37_MQ04_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'REMAIN37_MQ04')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(pc, ScpArgMsg("REMAIN37_MQ04"), 'SITGROPE2_LOOP', 1);
        if result1 == 1 then
            PlayEffect(self, 'F_smoke070', 1)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAIN37_MQ04', 'QuestInfoValue1', 1, nil, "REMAIN37_MQ04_ITEM/1")
            Kill(self)
        end
    end
end


function SCR_REMAIN37_MQ05_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'REMAIN37_MQ05')
    if result == 'PROGRESS' then
        local mon_ssn = GetSessionObject(self, 'SSN_REMAIN37_MQ05_MON')
        if mon_ssn == nil then
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("REMAIN37_MQ05"), 'FIRE', 1);
            if result1 == 1 then
                local mon_ssn = GetSessionObject(self, 'SSN_REMAIN37_MQ05_MON')
                if mon_ssn == nil then
                    AttachEffect(self, 'F_fire027', 1, 1, "BOT", 1)
                    CreateSessionObject(self, 'SSN_REMAIN37_MQ05_MON', 1)
                end
            end
        end
    end
end

function SCR_CREATE_SSN_REMAIN37_MQ05_MON(self, sObj)
    SetTimeSessionObject(self, sObj, 1, 1000, 'SSN_REMAIN37_MQ05_MON_RUN')
end

function SCR_REENTER_SSN_REMAIN37_MQ05_MON(self, sObj)
    SetTimeSessionObject(self, sObj, 1, 1000, 'SSN_REMAIN37_MQ05_MON_RUN')
end

function SCR_DESTROY_SSN_REMAIN37_MQ05_MON(self, sObj)
end


function SSN_REMAIN37_MQ05_MON_RUN(self, sObj)
    local list, cnt = SelectObjectByClassName(self, 50, 'TreeAmbulo')
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if IsBuffApplied(list[i], 'REMAIN37_MQ05') == 'NO' then
                AddBuff(self, list[i], 'REMAIN37_MQ05', 1, 0, 30000, 1)
            end
        end
    end

    if self.NumArg1 <= 60 then
        self.NumArg1 = self.NumArg1 + 1
    else
        Kill(self)
    end
end


function SCR_REMAIN37_MQ05_MON_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'REMAIN37_MQ05')
    if result == 'PROGRESS' then
        LookAt(pc, self)
        PlayAnim(pc, 'KICKBOX', 1)
        sleep(200)
        local dic_angle = GetAngleToPos(self, 577, -1130)
        KnockDown(self, pc, 300, dic_angle, 45, 1)
        InsertHate(self, pc, 2)
    end
end



function SCR_REMAIN37_SQ04_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'REMAIN37_SQ04')
    if result == 'PROGRESS' then
        local result1 = DOTIMEACTION_R(pc, ScpArgMsg("REMAIN37_MQ04"), 'SITGROPE2_LOOP', 1);
        if result1 == 1 then
            local list, cnt = SelectObjectByFaction(self, 200, 'Monster')
            local i
            for i = 1, cnt do
                InsertHate(list[i], pc, 1)
            end
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_REMAIN37_SQ04', 'QuestInfoValue1', 1, nil, "REMAINS37_MSTONE_05/1")
            PlayEffect(self, 'F_light019', 0.3, 1, 'BOT')
            Kill(self)
        end
    end
end