function SCR_CORAL_32_2_BERTA1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_DARUL1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_32_2_SQ_2')
    if result == 'PROGRESS' then
        local select = ShowSelDlg(pc, 0, 'CORAL_32_2_DARUL1_SQ_DLG1', ScpArgMsg('CORAL_32_2_DARUL1_SQ_MSG1'), ScpArgMsg('CORAL_32_2_DARUL1_SQ_MSG2'), ScpArgMsg('CORAL_32_2_DARUL1_SQ_MSG3'), ScpArgMsg('CORAL_32_2_DARUL1_SQ_MSG4'))
        local sObj = GetSessionObject(pc, 'SSN_CORAL_32_2_SQ_2')
        if sObj ~= nil then
            if select == 1 then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                    sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
                end
                ShowOkDlg(pc, 'CORAL_32_2_DARUL1_SQ_DLG2', 1)
            elseif select == 2 then
                if sObj.QuestInfoValue2 < sObj.QuestInfoMaxCount2 then
                    sObj.QuestInfoValue2 = sObj.QuestInfoMaxCount2
                end
                ShowOkDlg(pc, 'CORAL_32_2_DARUL1_SQ_DLG3', 1)
            elseif select == 3 then
                if sObj.QuestInfoValue3 < sObj.QuestInfoMaxCount3 then
                    sObj.QuestInfoValue3 = sObj.QuestInfoMaxCount3
                end
                ShowOkDlg(pc, 'CORAL_32_2_DARUL1_SQ_DLG4', 1)
            elseif select == 4 then
                return 0
            end
        end
    end
end

function SCR_CORAL_32_2_BERTA2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_DARUL2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_BERTA3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_DARUL3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_JURATEALTAR_DIALOG(self, pc)
end

function SCR_CORAL_32_2_SQ_1_NOTICE_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_SQ_1_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_SQ_6_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_32_2_SQ_3_CORAL_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'CORAL_32_2_SQ_3')
    if result1 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_CORAL_32_2_SQ_3')
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'CORAL_32_2_SQ_3')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SuJip_Jung"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'CORAL_32_2_SQ_3')
        if result2  == 1 then
            if sObj ~= nil then
                PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_32_2_SQ_3', 'QuestInfoValue1', 1, nil, 'CORAL_32_2_SQ_3_ITEM/1')
                SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("CORAL_32_2_SQ_3"), 3)
                ObjectColorBlend(self, 50, 50, 50, 0, 1, 1)
                Kill(self)
            end
        end
    end
end

function SCR_CORAL_32_2_SQ_7_CORAL_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'CORAL_32_2_SQ_7')
    if result1 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_CORAL_32_2_SQ_7')
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'CORAL_32_2_SQ_7')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SuJip_Jung"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'CORAL_32_2_SQ_7')
        if result2  == 1 then
            if sObj ~= nil then
                PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_32_2_SQ_7', nil, nil, nil, 'CORAL_32_2_SQ_3_ITEM/1')
                SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("CORAL_32_2_SQ_3"), 3)
                ObjectColorBlend(self, 50, 50, 50, 0, 1, 1)
                Kill(self)
            end
        end
    end
end


function SCR_CORAL_32_2_SQ_12_STONE_DIALOG(self, pc)
    if self.NumArg4 >= 1 then
        local result = SCR_QUEST_CHECK(pc, 'CORAL_32_2_SQ_12')
        if result == 'PROGRESS' then
            local sObj = GetSessionObject(pc, 'SSN_CORAL_32_2_SQ_12')
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'CORAL_32_2_SQ_12')
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SuJip_Jung"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'CORAL_32_2_SQ_12')
            if result1  == 1 then
                if sObj ~= nil then
                    PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_32_2_SQ_12', 'QuestInfoValue1', 1, nil, 'CORAL_32_2_SQ_12_ITEM/1')
                    SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("CORAL_32_2_SQ_12"), 3)
                    ObjectColorBlend(self, 50, 50, 50, 0, 1, 1)
                    Kill(self)
                end
            end
        end
    else
        ShowBalloonText(pc, "CORAL_32_2_SQ_12_STONE", 3)
    end
end

function SCR_CORAL_32_2_SQ_12_STONE2_DIALOG(self, pc)
    if self.NumArg4 >= 1 then
        ShowBalloonText(pc, "CORAL_32_2_SQ_12_STONE2", 3)
    else
    ShowBalloonText(pc, "CORAL_32_2_SQ_12_STONE", 3)
end
end

function SCR_CORAL_32_2_SQ_5_RUN(self, num)
    if num == 1 then
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CORAL_32_2_SQ_5', 'QuestInfoValue'..num, 1)
        local mon1 = CREATE_MONSTER_EX(self, 'dirt_heal_2', -698, 50, 785, 0, 'Neutral', nil, SET_CORAL_32_2_SQ_5)
        AddVisiblePC(mon1, self, 1)
        AddScpObjectList(mon1, 'CORAL_32_2_SQ_5_CNT', self)
        AddScpObjectList(self, 'CORAL_32_2_SQ_5_CNT', mon1)
    elseif num == 2 then
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CORAL_32_2_SQ_5', 'QuestInfoValue'..num, 1)
        local mon2 = CREATE_MONSTER_EX(self, 'dirt_heal_2', 4, 50, 39, 0, 'Neutral', nil, SET_CORAL_32_2_SQ_5)
        AddVisiblePC(mon2, self, 1)
        AddScpObjectList(mon2, 'CORAL_32_2_SQ_5_CNT', self)
        AddScpObjectList(self, 'CORAL_32_2_SQ_5_CNT', mon2)
    end
end

function SCR_CORAL_32_2_SQ_5_FAIL(self, tx)
    local _follower = GetScpObjectList(self, 'CORAL_32_2_SQ_5_CNT')
    if #_follower >= 1 then
        local i;
        for i = 1, #_follower do
            Kill(_follower[i])
        end
    end
end

function SET_CORAL_32_2_SQ_5(mon)
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.Name = 'UnvisibleName'
	mon.SimpleAI = 'CORAL_32_2_SQ_5_AI'
end

function CORAL_32_2_SQ_5_HATE(self)
    local _pc = GetScpObjectList(self, 'CORAL_32_2_SQ_5_CNT')
    if #_pc >= 1 then
        local i;
        for i = 1, #_pc do
            local dist = GetDistance(self, _pc[i])
            local result = SCR_QUEST_CHECK(_pc[i], 'CORAL_32_2_SQ_5')
            if result == 'COMPLETE' then
                Kill(self)
            elseif result == 'PROGRESS' then
                if dist <= 80 then
                    local list2, cnt2 = SelectObject(self, 100, 'ALL')
                    local j
                    local moncount = 0
                    if cnt2 ~= 0 then
                        for j = 1, cnt2 do
                            if list2[j].ClassName ~= 'PC' then
                                if list2[j].Faction == 'Monster' then
                                    moncount = moncount + 1
                                    InsertHate(list2[j], _pc[i], 100)
                                end
                            end
                        end
                        if moncount >= 1 then
                            SendAddOnMsg(_pc[i], 'NOTICE_Dm_scroll', ScpArgMsg("CORAL_32_2_SQ_5"), 3)
                        end
                    end
                end
            end
        end
    else
        Kill(self)
    end
end

function SCR_CORAL_32_2_SQ_13_FAIL(self, tx)
    local i
    for i = 1, 4 do
        if isHideNPC(self, 'CORAL_32_2_SQ_13_H'..i) == 'NO' then
            HideNPC(self, 'CORAL_32_2_SQ_13_H'..i)
        end
    end
end

function SCR_CORAL_32_2_SQ_13(self, pc, num)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_32_2_SQ_13')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_CORAL_32_2_SQ_13')
        if sObj['QuestInfoValue'..num] < sObj['QuestInfoMaxCount'..num] then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 3, 'CORAL_32_2_SQ_13')
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("CORAL_32_2_SQ_13_DTA"), 'BURY', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'CORAL_32_2_SQ_13')
            if result1 == 1 then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_32_2_SQ_13', 'QuestInfoValue'..num, 1, nil, nil, 'CORAL_32_2_SQ_12_ITEM/1')
                SCR_SCRIPT_PARTY('SCR_CORAL_32_2_SQ_13_RUN', 2, self, pc, num)
            end
        end
    end    
end

function SCR_CORAL_32_2_SQ_13_RUN(self, pc, num)
    if isHideNPC(pc, 'CORAL_32_2_SQ_13_H'..num) == 'YES' then
        UnHideNPC(pc, 'CORAL_32_2_SQ_13_H'..num)
    end
end

function SCR_CORAL_32_2_SQ_13_1_DIALOG(self, pc)
    SCR_CORAL_32_2_SQ_13(self, pc, 1)
end

function SCR_CORAL_32_2_SQ_13_2_DIALOG(self, pc)
    SCR_CORAL_32_2_SQ_13(self, pc, 2)
end

function SCR_CORAL_32_2_SQ_13_3_DIALOG(self, pc)
    SCR_CORAL_32_2_SQ_13(self, pc, 3)
end

function SCR_CORAL_32_2_SQ_13_4_DIALOG(self, pc)
    SCR_CORAL_32_2_SQ_13(self, pc, 4)
end

function SCR_CORAL_32_2_SQ_13_H1_ENTER(self, pc)
    PlayEffect(self, 'F_light035_blue', 2, 0, 'BOT')
end

function SCR_CORAL_32_2_SQ_13_H2_ENTER(self, pc)
    PlayEffect(self, 'F_light035_blue', 2, 0, 'BOT')
end

function SCR_CORAL_32_2_SQ_13_H3_ENTER(self, pc)
    PlayEffect(self, 'F_light035_blue', 2, 0, 'BOT')
end

function SCR_CORAL_32_2_SQ_13_H4_ENTER(self, pc)
    PlayEffect(self, 'F_light035_blue', 2, 0, 'BOT')
end

function CORAL_32_2_SQ_6_AI1(self)
    if self.NumArg4 % 10 == 0 then
        local list, cnt = SelectObject(self, 300, 'ALL')
        if cnt ~= 0 then
            for i = 1, cnt do
                if GetCurrentFaction(list[i]) == 'Monster' then
                    if self.NumArg4 == 120 then
                        RemoveBuff(list[i], 'CORAL_32_2_SQ_6_BUFF')
                    end
                    local hate = IMCRandom(100, 500)
                    InsertHate(list[i], self, hate)
                end
            end
        end
    end
    if self.NumArg4 == 120 then
        Chat(self, ScpArgMsg("CORAL_32_2_SQ_6_AI_CHAT1"), 5)
    elseif self.NumArg4 == 65 then
        Chat(self, ScpArgMsg("CORAL_32_2_SQ_6_AI_CHAT3"), 5)
    end
    self.NumArg4 = self.NumArg4 + 1
    if self.NumArg3 > 0 then
        self.NumArg3 = self.NumArg3 - 1
        if self.NumArg3 == 0 then
            PlayAnim(self, 'event_loop', 1)
        end
    end
end

function CORAL_32_2_SQ_6_AI2(self)
    if self.NumArg4 % 10 == 0 then
        local list, cnt = SelectObject(self, 300, 'ALL')
        if cnt ~= 0 then
            for i = 1, cnt do
                if GetCurrentFaction(list[i]) == 'Monster' then
                    if self.NumArg4 == 120 then
                        RemoveBuff(list[i], 'CORAL_32_2_SQ_6_BUFF')
                    end
                    local hate = IMCRandom(100, 500)
                    InsertHate(list[i], self, hate)
                end
            end
        end
    end
    if self.NumArg4 == 125 then
        Chat(self, ScpArgMsg("CORAL_32_2_SQ_6_AI_CHAT2"), 5)
    elseif self.NumArg4 == 60 then
        Chat(self, ScpArgMsg("CORAL_32_2_SQ_6_AI_CHAT4"), 5)
    end
    self.NumArg4 = self.NumArg4 + 1
    if self.NumArg3 > 0 then
        self.NumArg3 = self.NumArg3 - 1
        if self.NumArg3 == 0 then
            PlayAnim(self, 'event', 1)
        end
    end
end

function CORAL_32_2_SQ_6_AI_HIT(self)
    self.NumArg3 = 3
end

function SCR_CORAL_32_2_SQ_8_MON_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_32_2_SQ_8')
    if result == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 3, 'CORAL_32_2_SQ_8')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SuJip_Jung"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'CORAL_32_2_SQ_8')
        if result2 == 1 then
            PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_32_2_SQ_8', nil, nil, nil, 'CORAL_32_2_SQ_8_ITEM/1')
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("CORAL_32_2_SQ_8"), 3)
            PlayEffect(self, 'I_smoke014', 0.5)
            ObjectColorBlend(self, 50, 50, 50, 0, 1, 1)
            Kill(self)
        end
    end
end

function SET_CORAL_32_2_SQ_8(mon)
    mon.Dialog = "CORAL_32_2_SQ_8_MON"
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.SimpleAI = 'CORAL_32_2_SQ_8_AI2'
	mon.MaxDialog = 1;
end

function CORAL_32_2_SQ_8_MON_HPLCOK(self)
    local hp_lock = self.MHP*0.05
    AddBuff(self, self, 'HPLock', hp_lock, 0, 0, 1)
end

function CORAL_32_2_SQ_8_MON(self, from)
    if from.ClassName == 'PC' then
        local result = SCR_QUEST_CHECK(from, "CORAL_32_2_SQ_8")
        if result == "PROGRESS" then
            if IsBuffApplied(self, 'CORAL_32_2_SQ_8_BUFF') == 'NO' then
                if GetHpPercent(self) < 0.1 then
                    CancelMonsterSkill(self)
                    AddBuff(self, self, 'CORAL_32_2_SQ_8_BUFF', 1, 0, 0, 1)
                    RunScript('CORAL_32_2_SQ_8_MON2', self)
                end
            end
        else
            if IsBuffApplied(self, 'HPLock') == 'YES' then
                RemoveBuff(self, 'HPLock')
            else
                return 0
            end
        end
    else
    local owner = GetOwner(from)
        local result = SCR_QUEST_CHECK(owner, "CORAL_32_2_SQ_8")
        if result == "PROGRESS" then
            if IsBuffApplied(self, 'CORAL_32_2_SQ_8_BUFF') == 'NO' then
                if GetHpPercent(self) < 0.1 then
                    CancelMonsterSkill(self)
                    AddBuff(self, self, 'CORAL_32_2_SQ_8_BUFF', 1, 0, 0, 1)
                    RunScript('CORAL_32_2_SQ_8_MON2', self)
                end
            end
        else
            if IsBuffApplied(self, 'HPLock') == 'YES' then
                RemoveBuff(self, 'HPLock')
            else
                return 0
            end
        end
    end
end

function CORAL_32_2_SQ_8_MON2(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Greentoshell', x, y, z, GetDirectionByAngle(self), 'Neutral', nil, SET_CORAL_32_2_SQ_8)
    AddBuff(self, mon, 'Stun', 1, 0, 12000, 1);
    SetDialogRotate(mon, 0)
    SetLifeTime(mon, 12, 1)
    Kill(self)
end

function SCR_CORAL_32_2_SQ_6_FAIL(self, tx)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CORAL_32_2_SQ_6_FAIL"), 5)
end

function SCR_CORAL_32_2_SQ_6_FAIL2(self, tx)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CORAL_32_2_SQ_6_FAIL2"), 5)
end