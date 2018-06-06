--F library48_2
function SCR_FLIBRARY482_NERINGA_NPC_1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_FLIBRARY482_NERINGA_NPC_2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_FLIBRARY482_NERINGA_NPC_3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_FLIBRARY482_VIDA_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_FLIBRARY482_SVAJA_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end


function SCR_FLIBRARY482_BLACKMAN_NPC_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end



function SCR_FANTASYLIB482_MQ_1_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FANTASYLIB482_MQ_1')
    if result == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("FANTASYLIB482_MQ_1_MSG_0"), 'MAKING', 2);
        if result2 == 1 then
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FANTASYLIB482_MQ_1', 'QuestInfoValue1', 1)
            SCR_SENDMSG_CNT(pc, 'SSN_FANTASYLIB482_MQ_1', 'scroll', 'FANTASYLIB482_MQ_1_MSG_1', 1, 8)
        	PlayEffect(self, 'F_ground012_light', 0.1)
        	Kill(self)
        end
    end
end



function SCR_FANTASYLIB482_MQ_6_NPC_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end


function SCR_FANTASYLIB482_MQ_3_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FANTASYLIB482_MQ_3')
    if result == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("FANTASYLIB482_MQ_3_MSG_0"), 'MAKING', 2);
        if result2 == 1 then
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FANTASYLIB482_MQ_3', nil, nil, nil,'FANTASYLIB482_MQ_3_ITEM/1' )
        	PlayEffect(self, 'F_ground012_light', 0.1)
        	Kill(self)
        end
    end
end




function SCR_FANTASYLIB482_MQ_5_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'FANTASYLIB482_MQ_5')
    if result == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("FANTASYLIB482_MQ_5_MSG_0"), 'MAKING', 2);
        if result2 == 1 then
            local quest_ssn = GetSessionObject(pc, 'SSN_FANTASYLIB482_MQ_5')
            if quest_ssn ~= nil then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 -1 then
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FANTASYLIB482_MQ_5', 'QuestInfoValue1', 1)
                    PlayEffect(self, 'F_explosion005_violet', 0.3, 1)
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('FANTASYLIB482_MQ_5_FIND'), 8);
                    Kill(self)
                else
                    local x, y, z = GetPos(self)
                    local mon = CREATE_MONSTER_EX(pc, 'npc_kupole_3', x, y, z, -45, 'Neutral', pc.Lv, FANTASYLIB482_MQ_5_NPC_RUN);
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_FANTASYLIB482_MQ_5', 'QuestInfoValue1', 1)
                    AddVisiblePC(mon, pc, 1);
                    Kill(self)
                    SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('FANTASYLIB482_MQ_5_NPC_DONE'), 8);
                    AddScpObjectList(pc, "FANTASYLIB482_MQ_5_NPC", mon)
                    AddScpObjectList(mon, "FANTASYLIB482_MQ_5_NPC", pc)
                end
            end
        end
    end
end


function FANTASYLIB482_MQ_5_NPC_RUN(mon)
    mon.Name = ScpArgMsg('FANTASYLIB482_MQ_5_FIND_NAME')
    mon.SimpleAI = 'FANTASYLIB482_MQ_5_AI_MON'
end

function FANTASYLIB482_MQ_5_AI_MON_RUN(self)

    local list = GetScpObjectList(self, "FANTASYLIB482_MQ_5_NPC")
    if #list == 0 then
        Kill(self)
    end
    
    local _pc = list[1]
    LookAt(self, _pc)
    if self.NumArg4 == 0 then
        ChatLocal(self, _pc, ScpArgMsg('FANTASYLIB482_MQ_5_FIND_CHAT_1'), 3)
        self.NumArg4 = 1
    elseif self.NumArg4 < 3 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 == 3 then
        ChatLocal(self, _pc, ScpArgMsg('FANTASYLIB482_MQ_5_FIND_CHAT_2'), 3)
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 >= 4 and self.NumArg4 < 7 then
        self.NumArg4 = self.NumArg4 + 1
    elseif self.NumArg4 >= 7 then
        RunScript('FANTASYLIB482_MQ_5_AI_MON_1', self, _pc)
        self.NumArg4 = self.NumArg4 +1
    else
        return 1
    end
end


function FANTASYLIB482_MQ_5_AI_MON_1(self, pc)
    HideNPC(pc,"FANTASYLIB482_MQ_5_NPC")
    UIOpenToPC(pc,'fullblack',1)
    sleep(1000)
    Kill(self)
    UIOpenToPC(pc,'fullblack',0)
end



function SCR_FANTASYLIB482_WARP_A1_DIALOG(self, pc)
    SetPos(pc, 830, 278, -263)
end



function SCR_FANTASYLIB482_WARP_A2_DIALOG(self, pc)
    SetPos(pc, 40, 78, -169)
end


function SCR_FANTASYLIB482_MQ_5_ABANDON(self)
    local Hide1 = isHideNPC(self, "FANTASYLIB482_MQ_5_NPC")
    if Hide1 == "YES" then
        UnHideNPC(self,"FANTASYLIB482_MQ_5_NPC")
    end
    local Hide2 = isHideNPC(self, "FLIBRARY482_NERINGA_NPC_2")
    if Hide2 == "NO" then
        HideNPC(self,"FLIBRARY482_NERINGA_NPC_2")
    end
    local Hide3 = isHideNPC(self, "FLIBRARY482_VIDA_NPC")
    if Hide3 == "NO" then
        HideNPC(self,"FLIBRARY482_VIDA_NPC")
    end
end