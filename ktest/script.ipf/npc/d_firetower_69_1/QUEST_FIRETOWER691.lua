function FIRETOWER691_DIR_LIB_SINGLE(self, quest_classname)
--    quest_classname = 'FIRETOWER691_MQ_1'
    local npc_classname = 'npc_agailla_flurry'
    local _func
    local x, y, z
    local i 
    local angle = GetDirectionByAngle(self)
    if quest_classname == 'FIRETOWER691_PRE_1' then
        ShowBalloonText(self, 'FIRETOWER691_PRE_BALLOON_1', 5)
        local mon1 = CREATE_MONSTER_EX(self, 'npc_village_uncle_11', 463, 1019, -1683, 0, 'Neutral', 1, FIRETOWER691_PRE_1_1);
        local mon2 = CREATE_MONSTER_EX(self, 'npc_village_uncle_12', 508, 1018, -1662, 180, 'Neutral', 1, FIRETOWER691_PRE_1_2);
        AddVisiblePC(mon1, self, 1)
        AddVisiblePC(mon2, self, 1)
        AddScpObjectList(mon1, 'FIRETOWER691_PRE_1', self)
        AddScpObjectList(mon2, 'FIRETOWER691_PRE_1', self)
        AddScpObjectList(mon2, 'FIRETOWER691_PRE_2', mon1)
        return
    elseif quest_classname == 'FIRETOWER691_PRE_2' then
        x = -1649
        y = -872
        z = -261
        angle = 90
        ShowBalloonText(self, 'FIRETOWER691_PRE_BALLOON_2', 5)
        func_cls = 'FIRETOWER691_PRE_2_AI'
        _func = _G[func_cls]
    elseif quest_classname == 'FIRETOWER691_MQ_1' then
        x = -1772
        y = -647
        z = 938
        angle = 135
        ShowBalloonText(self, 'FIRETOWER691_PRE_BALLOON_3', 5)
        func_cls = 'FIRETOWER691_MQ_1_AI'
        _func = _G[func_cls]
    elseif quest_classname == 'FIRETOWER691_MQ_2' then
        x = -754
        y = -873
        z = 558
        angle = 0
        ShowBalloonText(self, 'FIRETOWER691_PRE_BALLOON_3', 5)
        func_cls = 'FIRETOWER691_MQ_2_AI'
        _func = _G[func_cls]
    elseif quest_classname == 'FIRETOWER691_MQ_3' then
        x, y, z = GetPos(self)
        x = x +(IMCRandom(-35, 35))
        z = z +(IMCRandom(-35, 35))
        angle = 0
        local quest_ssn = GetSessionObject(self, 'SSN_FIRETOWER691_MQ_3')
        if quest_ssn ~= nil then
--            quest_ssn.Goal3 = 0
            if quest_ssn.Goal3 == 0 then
                quest_ssn.Goal3 = quest_ssn.Goal3 + 1
            elseif quest_ssn.Goal3 == 1 then
                quest_ssn.Goal3 = quest_ssn.Goal3 + 1
            elseif quest_ssn.Goal3 == 2 then
                quest_ssn.Goal3 = quest_ssn.Goal3 + 1
            elseif quest_ssn.Goal3 == 3 then
                quest_ssn.Goal3 = quest_ssn.Goal3 + 1
            elseif quest_ssn.Goal3 == 4 then
                quest_ssn.Goal3 = quest_ssn.Goal3 + 1
            elseif quest_ssn.Goal3 == 5 then
                quest_ssn.Goal3 = quest_ssn.Goal3 + 1
            elseif quest_ssn.Goal3 == 6 then
                quest_ssn.Goal3 = quest_ssn.Goal3 + 1
            end
        end
        func_cls = 'FIRETOWER691_MQ_3_AI'
        _func = _G[func_cls]
    elseif quest_classname == 'FIRETOWER691_MQ_4' then
        func_cls = 'FIRETOWER691_MQ_4_AI'
        _func = _G[func_cls]
    elseif quest_classname == 'FIRETOWER691_MQ_5' then
        x = 2423
        y = -725
        z = 423
        angle = -90
        func_cls = 'FIRETOWER691_MQ_5_AI'
        _func = _G[func_cls]
    end
    local mon = CREATE_MONSTER_EX(self, npc_classname, x, y, z, angle, 'Neutral', 1, _func);
    AddVisiblePC(mon, self, 1)
    AddScpObjectList(self, func_cls, mon)
    AddScpObjectList(mon, func_cls, self)
end

function FIRETOWER691_MQ_5_AI(mon)
    mon.Name = ScpArgMsg('FIRETOWER691_NPC_1')
    mon.Dialog = 'None'
    mon.SimpleAI = 'FIRETOWER691_MQ_5_AI'
end

function FIRETOWER691_MQ_5_AI_1(self)
    local list = GetScpObjectList(self, 'FIRETOWER691_MQ_5')
    local _pc = list[1]
    if #list == nil then
        Kill(self)
    end
    
    if self.NumArg4 == 0 then
        self.NumArg4 = 1
    elseif self.NumArg4 == 1 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_5_DLG_1'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 2 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_5_DLG_2'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 3 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_5_DLG_3'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 4 then
        MoveEx(self, -1885, 1061, 1)
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_5_DLG_4'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 5 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 6 then
        SendAddOnMsg(_pc, "NOTICE_Dm_scroll", ScpArgMsg("FIRETOWER691_MQ_5_AFTER"), 3);
        PlayEffect(self, 'F_smoke142_yellow', 0.5)
        Kill(self)
    end
end


function FIRETOWER691_MQ_4_MON_AI(self)
    
end

function FIRETOWER691_MQ_3_AI_RUN(self)

    local list = GetScpObjectList(self, 'FIRETOWER691_MQ_3_AI')
    local _pc = list[1]
    if #list == nil then
        Kill(self)
    end

    local quest_ssn = GetSessionObject(_pc, 'SSN_FIRETOWER691_MQ_3')

    if quest_ssn ~= nil then
        
        if quest_ssn.Goal3 == 1 then
            
            if self.NumArg3 == 0 then
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 1 and self.NumArg3 < 3 then
                ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_3_DLG_1'), 5)
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 3 then
                PlayEffect(self, 'F_smoke142_yellow', 0.5)
                Kill(self)
            end
        elseif quest_ssn.Goal3 == 2 then
            if self.NumArg3 == 0 then
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 1 and self.NumArg3 < 3 then
                ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_3_DLG_2'), 5)
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 3 then
                PlayEffect(self, 'F_smoke142_yellow', 0.5)
                Kill(self)
            end
        elseif quest_ssn.Goal3 == 3 then
            if self.NumArg3 == 0 then
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 1 and self.NumArg3 < 3 then
                ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_3_DLG_3'), 5)
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 3 then
                PlayEffect(self, 'F_smoke142_yellow', 0.5)
                Kill(self)
            end
        elseif quest_ssn.Goal3 == 4 then
            if self.NumArg3 == 0 then
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 1 and self.NumArg3 < 3 then
                ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_3_DLG_4'), 5)
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 3 then
                PlayEffect(self, 'F_smoke142_yellow', 0.5)
                Kill(self)
            end
        elseif quest_ssn.Goal3 == 5 then
            if self.NumArg3 == 0 then
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 1 and self.NumArg3 < 3 then
                ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_3_DLG_5'), 5)
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 3 then
                PlayEffect(self, 'F_smoke142_yellow', 0.5)
                Kill(self)
            end
        elseif quest_ssn.Goal3 == 6 then
            if self.NumArg3 == 0 then
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 1 and self.NumArg3 < 5 then
                ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_3_DLG_6'), 5)
                self.NumArg3 = self.NumArg3 + 1
            elseif self.NumArg3 >= 5 then
                PlayEffect(self, 'F_smoke142_yellow', 0.5)
                Kill(self)
            end
        else
            Kill(self)
        end
    else
        if self.NumArg3 == 0 then
            self.NumArg3 = self.NumArg3 + 1
        elseif self.NumArg3 >= 1 and self.NumArg3 < 5 then
            ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_3_DLG_6'), 5)
            self.NumArg3 = self.NumArg3 + 1
        elseif self.NumArg3 >= 5 then
            PlayEffect(self, 'F_smoke142_yellow', 0.5)
            Kill(self)
        end
--        Kill(self)
    end
end

function FIRETOWER691_MQ_3_AI(mon)
    mon.Name = ScpArgMsg('FIRETOWER691_NPC_1')
    mon.Dialog = 'None'
    mon.SimpleAI = 'FIRETOWER691_MQ_3_AI_1'
end


function FIRETOWER691_PRE_1_1(mon)
    mon.Dialog = 'None'
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'FIRETOWER691_PRE_1_1_AI'
    mon.Name = ScpArgMsg('FIRETOWER691_PRE_1_1_NAME')
end

function FIRETOWER691_PRE_1_2(mon)
    mon.Dialog = 'None'
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'FIRETOWER691_PRE_1_2_AI'
    mon.Name = ScpArgMsg('FIRETOWER691_PRE_1_2_NAME')
end

function FIRETOWER691_PRE_1_1_AI_1(self)
    local list = GetScpObjectList(self, 'FIRETOWER691_PRE_1')
    if #list == 0 then
        Kill(self)
    end
end

function FIRETOWER691_PRE_1_2_AI_1(self)
    local list = GetScpObjectList(self, 'FIRETOWER691_PRE_1')
    local list2 = GetScpObjectList(self, 'FIRETOWER691_PRE_2')
    local npc1 = list2[1]
    local npc2 = self
    local _pc = list[1]
    if self.NumArg4 == 0 then

        if #list == 0 then
            Kill(self)
        end
        

        if #list2 == 0 then
            Kill(self)
        end
        
        self.NumArg4 = 1
    elseif self.NumArg4 == 1 then
        ChatLocal(npc1, _pc, ScpArgMsg('FIRETOWER691_PRE_NPC_DLG_1'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 2 then
        ChatLocal(npc2, _pc, ScpArgMsg('FIRETOWER691_PRE_NPC_DLG_2'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 3 then
        ChatLocal(npc1, _pc, ScpArgMsg('FIRETOWER691_PRE_NPC_DLG_3'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 4 then
        ChatLocal(npc2, _pc, ScpArgMsg('FIRETOWER691_PRE_NPC_DLG_4'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 5 then
        ChatLocal(npc1, _pc, ScpArgMsg('FIRETOWER691_PRE_NPC_DLG_5'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 6 then
        PlayEffect(npc1, 'F_smoke142_yellow', 0.5)
        PlayEffect(npc2, 'F_smoke142_yellow', 0.5)
        Kill(npc1)
        Kill(npc2)
    end
    
    
end

function FIRETOWER691_PRE_2_AI(mon)
    mon.Name = ScpArgMsg('FIRETOWER691_NPC_1')
    mon.Dialog = 'None'
    mon.SimpleAI = 'FIRETOWER691_PRE_2_AI_1'
end

function FIRETOWER691_PRE_2_AI_RUN(self)
    local list = GetScpObjectList(self, 'FIRETOWER691_PRE_2_AI')
    local _pc = list[1]
    if #list == nil then
        Kill(self)
    end
    
    if self.NumArg4 == 0 then
        self.NumArg4 = 1
    elseif self.NumArg4 == 1 then
        MoveEx(self, -1942, 198, 1)
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_PRE_2_DLG_1'), 3)
        self.NumArg4 = self.NumArg4 + 1
        
    elseif self.NumArg4 == 2 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_PRE_2_DLG_2'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 3 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 4 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 5 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 6 then
        PlayEffect(self, 'F_smoke142_yellow', 0.5)
        Kill(self)
    end
    
end





--FIRETOWER691_MQ_1

function SCR_FIRETOWER691_MQ_1_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FIRETOWER691_MQ_1')
    if result == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("FIRETOWER691_MQ_1_MSG_00"), '#SITGROPESET', 2);
        if result2 == 1 then
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FIRETOWER691_MQ_1', 'QuestInfoValue2', 1)
            PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
            Kill(self)
        end
    end
end



function FIRETOWER691_MQ_1_AI(mon)
    mon.Name = ScpArgMsg('FIRETOWER691_NPC_1')
    mon.Dialog = 'None'
    mon.SimpleAI = 'FIRETOWER691_MQ_1_AI'
end


function FIRETOWER691_MQ_1_AI_RUN(self)
    local list = GetScpObjectList(self, 'FIRETOWER691_MQ_1_AI')
    local _pc = list[1]
    if #list == nil then
        Kill(self)
    end
    
    if self.NumArg4 == 0 then
        self.NumArg4 = 1
    elseif self.NumArg4 == 1 then
        MoveEx(self, -1825, 988, 1)
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_1_DLG_1'), 3)
        self.NumArg4 = self.NumArg4 + 1
        
    elseif self.NumArg4 == 2 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_1_DLG_2'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 3 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_1_DLG_3'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 4 then
        MoveEx(self, -1885, 1061, 1)
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_1_DLG_4'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 5 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 6 then
        SendAddOnMsg(_pc, "NOTICE_Dm_scroll", ScpArgMsg("FIRETOWER691_MQ_1_AFTER"), 3);
        PlayEffect(self, 'F_smoke142_yellow', 0.5)
        Kill(self)
    end
end





--FIRETOWER691_MQ_2

function FIRETOWER691_MQ_2_AI(mon)
    mon.Name = ScpArgMsg('FIRETOWER691_NPC_1')
    mon.Dialog = 'None'
    mon.SimpleAI = 'FIRETOWER691_MQ_2_AI'
end


function FIRETOWER691_MQ_2_AI_RUN(self)
    local list = GetScpObjectList(self, 'FIRETOWER691_MQ_2_AI')
    local _pc = list[1]
    if #list == nil then
        Kill(self)
    end
    
    if self.NumArg4 == 0 then
        self.NumArg4 = 1
    elseif self.NumArg4 == 1 then
        MoveEx(self, -558, 543, 1)
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_2_DLG_1'), 3)
        self.NumArg4 = self.NumArg4 + 1
        
    elseif self.NumArg4 == 2 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_2_DLG_2'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 3 then
        ChatLocal(self, _pc, ScpArgMsg('FIRETOWER691_MQ_2_DLG_3'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 4 then
        MoveEx(self, -1885, 1061, 1)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 5 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 6 then
        SendAddOnMsg(_pc, "NOTICE_Dm_scroll", ScpArgMsg("FIRETOWER691_MQ_2_AFTER"), 3);
        PlayEffect(self, 'F_smoke142_yellow', 0.5)
        Kill(self)
    end
end





function SCR_FIRETOWER691_MQ_2_NPC_OBJ_ENTER(self, pc)
    return
end

function FIRETOWER691_MQ_2_NPC_OBJ_AI(self)
    self.HPCount = 10
end


function FIRETOWER691_MQ_2_NPC_OBJ_AI_DEAD(self, killer)
    if GetCurrentFaction(killer) == 'Law' then
        local list, cnt = CREATE_MONSTER_CELL(self, 'Hiddennpc_Q4', pc, 'Siege1', IMCRandom(3,6), 20, 'Neutral', FIRETOWER691_MQ_2_NPC_OBJ_AI_MON)
        local i
        if cnt > 0 then
            for i = 1, cnt do
                
            end
        end
    end
end


function FIRETOWER691_MQ_2_NPC_OBJ_AI_MON(mon)
    mon.SimpleAI = 'FIRETOWER691_MQ_2_NPC_OBJ_AI_MON_RUN'
    mon.Enter = 'FIRETOWER691_MQ_2_NPC_OBJ_1'
    mon.Range = 25
    mon.Name = ScpArgMsg('FIRETOWER691_MQ_2_NPC_OBJ_NAME')
end


function SCR_FIRETOWER691_MQ_2_NPC_OBJ_1_ENTER(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FIRETOWER691_MQ_2')
    if result == 'PROGRESS' then
        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FIRETOWER691_MQ_2', 'QuestInfoValue2', 1)
                PlayEffect(pc, 'F_pc_making_finish_white', 2, 1, 'MID')
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FIRETOWER691_MQ_2_NPC_OBJ_1"), 3);
                Kill(self)
            end
        end




function SCR_FIRETOWER691_SQ_1_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_FIRETOWER691_SQ_2_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_FIRETOWER691_SQ_3_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_FIRETOWER691_MQ_5_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FIRETOWER691_MQ_5')
    if result ~= 'COMPLETE' then
        COMMON_QUEST_HANDLER(self, pc)
    else
        INDUN_ENTER_DIALOG_AND_UI(pc, "INSTANCE_M_PAST_FANTASYLIBRARY_1", "M_Past_FantasyLibrary_1", 1, 0);
		return;
    end
end

function SCR_FIRETOWER691_SQ_2_OBJ_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FIRETOWER691_SQ_2')
    if result == 'PROGRESS' then
        if self.NumArg4 == 0 then
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("FIRETOWER691_SQ_2_DO"), '#SITGROPESET', 2, 'SSN_HATE_AROUND')
            if result2 == 1 then
                self.NumArg4 = 1
                PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FIRETOWER691_SQ_2', 'QuestInfoValue1', 1, nil, 'FIRETOWER691_SQ_2_ITEM/1')
                SCR_SENDMSG_CNT(pc, 'SSN_FIRETOWER691_SQ_2', 'GetItem', 'FIRETOWER691_SQ_2_GETITEM', 1, 5)
                Kill(self)
            end
        end
    end
end

function SCR_FIRETOWER691_SQ_3_OBJ_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FIRETOWER691_SQ_3')
    if result == 'PROGRESS' then
        local Timmer, sObj = SCR_DOCHARGE_ACTION(self, pc, IMCRandom(5, 10))
        AttachEffect(self, 'F_magic_prison_line_blue', 3)
        AttachEffect(self, 'F_sys_trigger_point_blue', 3)
        AttachEffect(pc, 'F_sys_trigger_point_blue', 2)
        local result  = DOTIMEACTION_CHARGE(pc, self, ScpArgMsg("FIRETOWER691_SQ_3_DO"), 'ABSORB', Timmer, 'SSN_FIRETOWER691_SQ_3', 1, 'SSN_HATE_AROUND')
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FIRETOWER691_SQ_3_1"), 5);
            DetachEffect(pc, 'F_sys_trigger_point_blue')
            Kill(self)
        elseif result == 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("FIRETOWER691_SQ_3_2"), 5);
            DetachEffect(self, 'F_magic_prison_line_blue')
            DetachEffect(self, 'F_sys_trigger_point_blue')
            DetachEffect(pc, 'F_sys_trigger_point_blue')
            PlayEffect(self, 'I_light013_spark_blue', 1, 'MID')
        else
            DetachEffect(self, 'F_magic_prison_line_blue')
            DetachEffect(self, 'F_sys_trigger_point_blue')
            PlayEffect(self, 'I_light013_spark_blue', 1, 'MID')
        end
    end
end