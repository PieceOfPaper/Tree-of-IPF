function SCR_CORAL_44_3_OLDMAN1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_OLDMAN2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_OLDMAN3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_OLDMAN4_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_MAN1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_SQ_10_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_SQ_40_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_KRUVINA1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_KRUVINA2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_KRUVINA3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_KRUVINA4_DIALOG(self, pc)
end

function SCR_CORAL_44_3_SQ_90_DARK_DIALOG(self, pc)
end

function SCR_CORAL_44_3_C_KRUVINA_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'CORAL_44_3_SQ_60')
    if result1 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_CORAL_44_3_SQ_60')
        if sObj.QuestInfoValue2 >= 1 then
            if IsDead(self) == 0 then
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("CORAL_44_3_SQ_60_DTA"), 'ABSORB', 3)
                if result2 == 1 then
                    PlayEffect(self, 'F_ground079_light', 3)
        		    PlayEffect(self, 'F_explosion011_blue', 3)
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_44_3_SQ_60', 'QuestInfoValue1', 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_Clear/'..ScpArgMsg("CORAL_44_3_SQ_60_MSG3")..'/5')
                    Dead(self)
                end
            end
        else
            ShowBalloonText(pc, "CORAL_44_3_SQ_60_BALLOON", 5)
        end
    end
end

function SCR_CORAL_44_3_SQ_60_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CORAL_44_3_SQ_80_RUINS_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'CORAL_44_3_SQ_80')
    if result1 == 'PROGRESS' then
        if IsDead(self) == 0 then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'CORAL_44_3_SQ_80')
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SuJip_Jung"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'CORAL_44_3_SQ_80')
            if result2 == 1 then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_44_3_SQ_80', nil, nil, nil, 'CORAL_44_3_SQ_80_ITEM/1', nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_GetItem/'..ScpArgMsg("CORAL_44_3_SQ_80_ITEM_MSG")..'/5')
                PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
                Kill(self)
            end
        end
    end
end

function SCR_CORAL_44_3_SQ_100_PORTAL_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'CORAL_44_3_SQ_100')
    if result1 == 'PROGRESS' then
        if IsDead(self) == 0 then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'CORAL_44_3_SQ_100')
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("CORAL_44_3_SQ_100_DTA"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
            DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'CORAL_44_3_SQ_100')
            if result2 == 1 then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_CORAL_44_3_SQ_100', 'QuestInfValue1', 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("CORAL_44_3_SQ_100_MSG")..'/5')
                PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
                Kill(self)
            end
        end
    end
end

function CORAL_44_3_SQ_30_PORTAL(self)
    AttachEffect(self, 'E_HUEVILLAGE_58_4_MQ11_potal_red', 7)
end

function SCR_CORAL_44_3_SQ_50_MON_ENTER(self, pc)
    local sObj = GetSessionObject(pc, 'SSN_CORAL_44_3_SQ_50')
    UIOpenToPC(pc,'fullblack',1)
    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("CORAL_44_3_SQ_50_FAIL"), 5)
    local q_name = sObj.QuestName
    sleep(1500)
    UIOpenToPC(pc,'fullblack',0)
    RunScript('ABANDON_TRACK_QUEST', pc, q_name, 'FAIL', 'PROGRESS')
    SetPos(pc, -618, -71, -402)
end

function SCR_CORAL_44_3_SQ_50_START(pc)
    UIOpenToPC(pc,'fullblack',1)
    sleep(3000)
    UIOpenToPC(pc,'fullblack',0)
end

function SCR_CORAL_44_3_SQ_50_CHECK_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'CORAL_44_3_SQ_50')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_CORAL_44_3_SQ_50')
        if sObj.QuestInfoValue1 < 1 then
            local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'CORAL_44_3_SQ_50')
            local result2 = DOTIMEACTION_R(pc, ScpArgMsg("CORAL_44_3_SQ_50_MSG2"), 'ABSORB', animTime)
            DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'CORAL_44_3_SQ_50')
            if result2 == 1 then
                sObj.QuestInfoValue1 = 1
                SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("CORAL_44_3_SQ_50_MSG3"), 5)
                PlayEffect(self, 'F_explosion004_green', 1, 1, 'BOT')
                Kill(self)
            end
        else
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("CORAL_44_3_SQ_50_MSG4"), 5)
        end
    end
end

function SCR_CORAL_44_3_SQ_60_FADEOUT(self)
    local _zoneID = GetZoneInstID(self)
    local list, cnt = GetLayerPCList(_zoneID, GetLayer(self))
    if cnt >= 1 then
        local i
        for i = 1, cnt do
            if list[i].ClassName == 'PC' then
                RunScript('SCR_CORAL_44_3_FADEOUT', list[i])
            end
        end
    end
end

function SCR_CORAL_44_3_SQ_60_FADEOUT2(self)
    local _zoneID = GetZoneInstID(self)
    local list, cnt = GetLayerPCList(_zoneID, GetLayer(self))
    if cnt >= 1 then
        local i
        for i = 1, cnt do
            if list[i].ClassName == 'PC' then
                RunScript('SCR_CORAL_44_3_FADEOUT', list[i])
            end
        end
    end
end

function SCR_CORAL_44_3_FADEOUT(self)
    UIOpenToPC(self,'fullblack',1)
    sleep(2000) 
    UIOpenToPC(self,'fullblack',0)
end