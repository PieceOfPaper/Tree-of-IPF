function SCR_WARP_C_KLAIPE_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, "EAST_PREPARE")
    local result3 = SCR_QUEST_CHECK(pc,'JOB_DIEVDIRBYS4_5')
    local result4 = SCR_QUEST_CHECK(pc,'LEGEND_CARD_LIFT')
    
    if result4 == 'SUCCESS' then
        COMMON_QUEST_HANDLER(self, pc)
    elseif result == 'PROGRESS' then
        COMMON_QUEST_HANDLER(self, pc)
        AddHelpByName(pc, 'TUTO_CAMPWARP')
        SendAddOnMsg(pc, 'HELP_MSG_CLOSE', "", 10)
    elseif result3 == 'PROGRESS' then
        local quest_ssn_diev = GetSessionObject(pc,'SSN_JOB_DIEVDIRBYS4_5')
        if quest_ssn_diev ~= nil then
            if quest_ssn_diev.QuestInfoValue2 < quest_ssn_diev.QuestInfoMaxCount2 then
                LookAt(pc, self)
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_DIEVDIRBYS4_5')
                local result4 = DOTIMEACTION_R(pc, ScpArgMsg("JOB_DIEVDIRBYS4_5_1"), '#SITGROPESET2', animTime)
                DOTIMEACTION_R_AFTER(pc, result4, animTime, before_time, 'JOB_DIEVDIRBYS4_5')
                
                if result4 == 1 then
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_JOB_DIEVDIRBYS4_5', 'QuestInfoValue2', 1)
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_DIEVDIRBYS4_5_2"), 3);
                    PlayEffect(self, "F_light008", 0.5, 1, 'BOT', 1)
                    RemoveEffect(self, "F_bg_smoke001", 3, 0, MID, 1)
                    RunScript('TAKE_ITEM_TX', pc, "JOB_DIEVDIRBYS4_1_ITEM", 2, "Quest")
                    SaveSessionObject(pc, quest_ssn_diev)
                end
            else
                SCR_CAMP_WARP(self,pc);
            end
        end
    else
        SCR_CAMP_WARP(self,pc);
    end
end