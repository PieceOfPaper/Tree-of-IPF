function SCR_PILGRIM51_INFO_BOARD_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_MAP_GIVE_DIALOG(self,pc)
    local invent = GetInvItemCount(pc, 'PILGRIM51_ITEM_01')
    if invent ~= 0 then
        local result1 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM51_BOARD_MSG01"), 'MAKING', 0.2, 'SSN_HATE_AROUND')
        if result1 == 1 then 
            local tx = TxBegin(pc);
	        TxTakeItem(tx, "PILGRIM51_ITEM_01", 1, 'Quest');
	        local ret = TxCommit(tx);
            
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_BOARD_MSG02"), 2);
         end
         
    elseif invent == 0 then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM51_BOARD_MSG03"), 'SITGROPE', 2, 'SSN_HATE_AROUND')
        if result2 == 1 then        
            local tx = TxBegin(pc);
            TxGiveItem(tx, 'PILGRIM51_ITEM_01', 1, 'Quest');
            local ret = TxCommit(tx);
               
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIM51_BOARD_MSG04"), 2);
        end

    end
end

function SCR_PILGRIM51_MAP_TAKE_DIALOG(self,pc)
    local invent = GetInvItemCount(pc, 'PILGRIM51_ITEM_01')
    if invent ~= 0 then
        local result1 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM51_BOARD_MSG05"), 'MAKING', 1, 'SSN_HATE_AROUND')
        if result1 == 1 then 
            local tx = TxBegin(pc);
	        TxTakeItem(tx, "PILGRIM51_ITEM_01", 1, 'Quest');
	        local ret = TxCommit(tx);
            
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_BOARD_MSG06"), 2);
         end
         
    elseif invent == 0 then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM51_BOARD_MSG07"), 'SITGROPE', 2.0, 'SSN_HATE_AROUND')
        if result2 == 1 then        
            local tx = TxBegin(pc);
            TxGiveItem(tx, 'PILGRIM51_ITEM_01', 1, 'Quest');
            local ret = TxCommit(tx);
               
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIM51_BOARD_MSG08"), 2);
        end

    end
end



function SCR_PILGRIM51_SR01_DIALOG(self,pc)
    local invent = GetInvItemCount(pc, 'Vis')
    if invent >= 1000 then
        local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_1')
        if result == 'PROGRESS' then 
            --print("BBBBB")
            SCR_PILGRIM51_SR01_OFFERING(self, pc, num, input)
        elseif result == 'COMPLETE' then
            SCR_PILGRIM51_SR01_OFFERING(self, pc, num, input)
            --SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG01"), 2);
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    else
        ShowBalloonText(pc, "PILGRIM51_SQ_1_OFFERING_NOMONEY", 3)
    end
end

function SCR_PILGRIM51_SR01_OFFERING(self, pc, num, input)
    local num = IMCRandom(1, 3)
    --print(num, "FFFFFF")
    local input = ShowSelDlg(pc, 0, 'PILGRIM51_SQ_1_OFFERING', 
        ScpArgMsg('PILGRIM51_SQ_1_MSG02'), ScpArgMsg('PILGRIM51_SQ_1_MSG03'), ScpArgMsg('PILGRIM51_SQ_1_MSG04'), ScpArgMsg('PILGRIM51_SQ_1_MSG51'))
    if input == num then
        if num == 1 then
            local tx1 = TxBegin(pc);
            TxTakeItem(tx1, "Vis", 100, 'Quest');
            local ret = TxCommit(tx1);
            
            SCR_PILGRIM51_SR01_AFTER01(self, pc)
            
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG07"), 5);
            
            local quest_ssn = GetSessionObject(pc,'SSN_PILGRIM51_SQ_1')
            --print(quest_ssn, "CCC")
            if quest_ssn ~= nil then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_PILGRIM51_SQ_1', 'QuestInfoValue1', 1)
                --SaveSessionObject(pc, quest_ssn)
            end
            
        elseif num == 2 then
            local tx2 = TxBegin(pc);
            TxTakeItem(tx2, "Vis", 500, 'Quest');
            local ret = TxCommit(tx2);
            
            SCR_PILGRIM51_SR01_AFTER02(self, pc)
            
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG08"), 5);
            
            local quest_ssn = GetSessionObject(pc,'SSN_PILGRIM51_SQ_1')
            --print(quest_ssn, "CCC")
            if quest_ssn ~= nil then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_PILGRIM51_SQ_1', 'QuestInfoValue1', 1)
                --SaveSessionObject(pc, quest_ssn)
            end
            
        elseif num == 3 then
            local tx3 = TxBegin(pc);
            TxTakeItem(tx3, "Vis", 1000, 'Quest');
            local ret = TxCommit(tx3);
            
            SCR_PILGRIM51_SR01_AFTER03(self, pc)
            
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG09"), 5);
            
            local quest_ssn = GetSessionObject(pc,'SSN_PILGRIM51_SQ_1')
            --print(quest_ssn, "CCC")
            if quest_ssn ~= nil then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_PILGRIM51_SQ_1', 'QuestInfoValue1', 1)
                --SaveSessionObject(pc, quest_ssn)
            end
        end
    else
        ShowBalloonText(pc, "PILGRIM51_SQ_1_OFFERING_NO", 3)
    end
end

function SCR_PILGRIM51_SR01_AFTER01(self, pc)
    PlayEffect(self, "I_explosion007_light")
    sleep(500)
    PlayEffect(pc, "F_lineup001", 1, 1, "TOP")
    AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 30000, 1)
--    sleep(500)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG01"), 3);
end

function SCR_PILGRIM51_SR01_AFTER02(self, pc)
    PlayEffect(self, "I_explosion007_light")
    sleep(500)
    PlayEffect(pc, "F_lineup001", 1, 1, "TOP")
    AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 67000, 1)
--    sleep(500)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG05"), 3);
end

function SCR_PILGRIM51_SR01_AFTER03(self, pc)
    PlayEffect(self, "I_explosion007_light")
    sleep(500)
    PlayEffect(pc, "F_lineup001", 1, 1, "TOP")
    AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 127000, 1)
--    sleep(500)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG06"), 3);
end
    
--function SCR_PILGRIM51_SR01_AFTER(self, npc)
--    print(self.Name, npc.Name)
--    PlayEffect(npc, "I_explosion007_light")
--    sleep(500)
--    PlayEffect(self, "F_light012_slate", 1, 1, "BOT")
--    AddBuff(self, npc, "MoveSpeed", 1, 0, 30000, 1)
--    sleep(500)
--    SendAddOnMsg(npc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG01"), 2);
--end


function SCR_PILGRIM51_SR02_DIALOG(self,pc)
--    local result1 = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_2')
--    local result2 = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_2_1')
    local result3 = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_2_2')
    if result3 == 'COMPLETE' then
        PlayEffect(self, "I_explosion007_light")
        sleep(500)
        PlayEffect(pc, "F_lineup001")
        AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 128000, 1)
        sleep(500)
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_2_2_MSG01"), 2);   
    else
--    if result2 == 'COMPLETE' or result2 == 'SUCCESS' or result2 == 'PROGRESS' or result2 == 'POSSIBLE' then
--        COMMON_QUEST_HANDLER(self,pc)
--    end
--    
--    if result1 == 'SUCCESS' or result == 'COMPLETE' then
--        PlayEffect(self, "I_bomb004_dark")
--        sleep(500)
--        PlayEffect(pc, "I_burst_up_dark")
--        SCR_PILGRIM51_SR02_RANDOM_DEBUFF(self, pc)
--        sleep(500)
--        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_2_2_MSG01"), 2);   
--    end 
        COMMON_QUEST_HANDLER(self,pc)     
    end
end

function SCR_PILGRIM51_SR02_BUFF(self)
    PlayEffect(self, "I_explosion007_light")
    sleep(500)
    PlayEffect(pc, "F_light012_slate")
    AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 128000, 1)
    sleep(500)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_2_2_MSG01"), 3);
end

function SCR_PILGRIM51_SR02_RANDOM_DEBUFF(self)
    local sr_list, sr_cnt = SelectObject(self, 200, "ALL", 1)
    local i 
    for i = 1 , sr_cnt do
        if sr_list[i].ClassName == "npc_pilgrim_shrine" then
    
            PlayEffect(sr_list[i], "I_bomb004_dark", 1, 1, "MID")
            sleep(500)
            PlayEffect(self, "I_burst_up_dark", 1, 1, "MID")
            
            local imc_int = IMCRandom(1, 3)
            if imc_int == 1 then
                AddBuff(sr_list[i], self, "UC_sleep", 1, 0, 10000, 1)
            elseif imc_int == 1 then
                AddBuff(sr_list[i], self, "UC_silence", 1, 0, 10000, 1)
            elseif imc_int == 1 then
                AddBuff(sr_list[i], self, "UC_curse", 1, 0, 10000, 1)
            else
                AddBuff(sr_list[i], self, "UC_slowdown", 1, 0, 10000, 1)
            end
            
            sleep(500)
            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_2_2_MSG01"), 2);
        end
    end
end

function SCR_PILGRIM51_SR03_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_5_1')
    if result == 'COMPLETE' then
        PlayEffect(self, "F_cleric_monstrance_shot_light")
        sleep(500)
        PlayEffect(pc, "F_light012_slate")
        AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 10000, 1)
        sleep(500)
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_5_1_MSG04"), 2);  
    else 
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM51_SQ_4_2_TRACK_PLAY(self)
    PlayDirection(self, "PILGRIM51_SQ_4_2_TRACK")
end


function SCR_PILGRIM51_MAGIC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM51_SQ_4_2')
    if result == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM51_SQ_4_2_MSG02"), '#SITGROPESET', 3, 'SSN_HATE_AROUND')
        if result2 == 1 then
            local list, cnt = SelectObjectByFaction(self, 100, 'Monster')
            local i
            local x, y, z = GetPos(self)
            for i = 1 , cnt do
                if list[i].ClassName == 'Prisonfighter' or list[i].ClassName == 'kowak' then
            --        SpinObject(list[i], 0, -1, 0.4, 1)
                    SetCurrentFaction(list[i])
                    SetLifeTime(list[i], 5)
                    Move3DByTime(list[i], x, y+5, z, 0.2, 1, 1)
                    SkillCancel(list[i]);
                    ClearBTree(list[i])
                    ActorVibrate(list[i], 999, 2, 50, -10);
                    if i == 3 then
                        break
                    end
                end
            end
            PlayEffect(self, 'F_wizard_shoggoth_cast_lineup', 2)
            SetLifeTime(self, 4)
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_4_2_MSG01"), 3);
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_PILGRIM51_SQ_4_2', 'QuestInfoValue1', 1)
        end
    end
end

function PILGRIM51_VINE_AI_ACT_01(self) -- damage to goddess statue
    local layer = GetLayer(self)
    if layer ~= 0 then
        local statue_list, statue_cnt = SelectObjectByClassName(self, 200, "statue_vakarine")
        if statue_cnt > 0 then
            local i
            for i = 1, statue_cnt do
                InsertHate(self, statue_list[i], 999)
                TakeDamage(self, statue_list[i], "None", 1, "Fire", "Magic", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
                
                if self.NumArg1 == 0 then
                    local statue_hp = GetHpPercent(statue_list[i])
                    if statue_hp < 0.6 then
                        PlayAnim(self, "LV2", 1)
                        self.NumArg1 = 1
                    end
                elseif self.NumArg1 == 1 then
                    local statue_hp = GetHpPercent(statue_list[i])
                    if statue_hp < 0.3 then
                        PlayAnim(self, "LV3", 1)
                        self.NumArg1 = 2
                    end
                end
--                        local statue_hp = GetHpPercent(statue_list[i])
--                        if statue_hp < 0.3 then
--                            PlayAnim(self, "LV3", 1)
--                            print("Goddess Statue Hp 0.3 - need to animation")
--                        elseif statue_hp < 0.6 then
--                            PlayAnim(self, "LV2", 1)
--                            print("Goddess Statue Hp 0.6 - need to animation")
--                        end
            
                
            end
        end
    end
end

function PILGRIM51_STATUE_AI_ACT_01(self)
    local statue_hp = GetHpPercent(self)
    if statue_hp < 0.2 then
        Chat(self, ScpArgMsg("PILGRIM51_SQ_7_MSG04"), 3)
--        print("dddddd")
--    elseif statue_hp < 0.2 then
--        Chat(self, ScpArgMsg("PILGRIM51_SQ_7_MSG05"), 3)
--    elseif statue_hp < 0.1 then
--        Chat(self, ScpArgMsg("PILGRIM51_SQ_7_MSG06"), 3)
    end
end

--function PILGRIM51_VINE_AI_ACT_01(self)
--    local layer = GetLayer(self)
--    if layer ~= 0 then
--        
--    end
--end

function SCR_PILGRIM51_SR04_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_6')
    if result == 'COMPLETE' then
        PlayEffect(self, "I_explosion007_light")
        sleep(500)
        PlayEffect(pc, "F_light012_slate")
        AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 10000, 1)
        sleep(500)
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_6_MSG01"), 2);
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM51_SR04_AFTER(self,pc)
    PlayEffect(self, "I_explosion007_light")
    sleep(500)
    PlayEffect(self, "F_light012_slate")
    AddBuff(self, self, "PILGRIM51_SQ_ATK_UP", 1, 0, 10000, 1)
    sleep(500)
    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_6_MSG01"), 2);
end

function SCR_PILGRIM51_SR05_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_8')
    if result == 'COMPLETE' then
    
        local input = ShowSelDlg(pc, 0, 'PILGRIM51_SQ_8_OFFERING', ScpArgMsg('PILGRIM51_SQ_8_MSG11'), ScpArgMsg('PILGRIM51_SQ_8_MSG12'))
        if input == 1 then
            local invent = GetInvItemCount(pc, 'misc_Stoulet')
            if invent >= 1 then
        
                local tx = TxBegin(pc);
                TxTakeItem(tx, "misc_Stoulet", 1, 'Quest');
                local ret = TxCommit(tx);
        
        
                PlayEffect(self, "I_explosion007_light")
                sleep(500)
                PlayEffect(pc, "F_light012_slate")
                AddBuff(self, pc, "MoveSpeed", 1, 0, 30000, 1)
                sleep(500)
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG01"), 5);
            else
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_8_MSG13"), 5);
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_8_MSG14"), 5);
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM51_SR05_AFTER(self)
    PlayEffect(self, "I_explosion007_light")
    sleep(500)
    PlayEffect(self, "F_light012_slate")
    AddBuff(self, self, "MoveSpeed", 1, 0, 30000, 1)
    sleep(500)
    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_1_MSG01"), 2);
end



function SCR_PILGRIM51_SR06_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_9')
    if result == 'PROGRESS' then
        local input = ShowSelDlg(pc, 0, 'PILGRIM51_SQ_9_MONEY', ScpArgMsg('PILGRIM51_SQ_9_MSG03'), ScpArgMsg('PILGRIM51_SQ_9_MSG04'))
        if input == num then
            if num == 1 then
--                local tx1 = TxBegin(pc);
--                TxTakeItem(tx1, "Vis", 10);
--                local ret = TxCommit(tx1);
--                ;
                SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_9_MSG05"), 3);
            end
        end
    elseif result == 'COMPLETE' then
        PlayEffect(self, "F_cleric_monstrance_shot_light")
        sleep(500)
        PlayEffect(pc, "F_light012_slate")
        AddBuff(self, pc, "PILGRIM51_SQ_ATK_UP", 1, 0, 10000, 1)
        sleep(500)
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_6_MSG01"), 2);
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM51_SR07_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_10')
    if result == 'COMPLETE' then
        PlayEffect(self, "F_cleric_monstrance_shot_light")
        sleep(500)
        PlayEffect(pc, "F_light012_slate")
        AddBuff(self, pc, "Heal_Buff", 10, 0, 1000, 1)
        sleep(500)
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_10_MSG01"), 2);
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function PILGRIM51_SQ_10_AFTER(self, pc)
    PlayEffect(self, "F_cleric_monstrance_shot_light")
    sleep(500)
    PlayEffect(pc, "F_light012_slate")
    AddBuff(self, pc, "Heal_Buff", 10, 0, 1000, 1)
    sleep(500)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PILGRIM51_SQ_10_MSG01"), 2);
end

function SCR_PILGRIM51_FGOD01_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_3')
    if result == 'IMPOSSIBLE' then
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_3_MSG11"), 5);
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM51_FGOD02_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_4')
    if result == 'IMPOSSIBLE' then
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_3_MSG11"), 5);
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_PILGRIM51_BRG_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_BOARD01_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_BOARD02_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_BOARD03_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_BOARD04_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_BOARD05_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_BOARD06_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_BOARD07_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PILGRIM51_REED_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_4_1')
    if result == 'PROGRESS' then
        LookAt(pc, self)
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'PILGRIM51_SQ_4_1')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM51_SQ_4_1_MSG01"), 'SITGROPE', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'PILGRIM51_SQ_4_1')
        
        if result2 == 1 then
            local quest_ssn = GetSessionObject(pc,'SSN_PILGRIM51_SQ_4_1')

            if quest_ssn ~= nil then

                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
--                    local fndList, fndCount = SelectObject(self, 200, 'ALL');
--                	local i
--                	
--                	for i = 1, fndCount do
--                	    if GetCurrentFaction(fndList[i]) == 'Monster' then
--                        	InsertHate(fndList[i],pc, 1)
--                        end
--                	end
                	
--                	local imc_int = IMCRandom(1, 5)
--
--                	if imc_int >= 4 then
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_PILGRIM51_SQ_4_1', 'QuestInfoValue1', 1)
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIM51_SQ_4_1_MSG02"), 5);
                        SaveSessionObject(pc, quest_ssn)
--                    else
--
--                        RunScript('PILGRIM51_SQ_4_1_EVENT', self, pc)
--
--                    end
                    Kill(self)
                	PlayEffect(self, 'I_light013_spark_blue', 1)
                end
            end 
        end       
    end
end

function PILGRIM51_SQ_4_1_EVENT(self, pc)
    local imc_int = IMCRandom(1, 4)
    if imc_int == 1 then
        --AttachEffect(pc, 'F_burstup001_dark', 0.5, 'BOT');
        AddBuff(self, pc, "Stun", 1 , 0, 3000, 1)
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_4_1_MSG03"), 3);
    elseif imc_int == 2 then
        --AttachEffect(pc, 'F_burstup001_dark', 0.5, 'MID');
        AddBuff(self, pc, "UC_slowdown", 1 , 0, 3000, 1)
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_4_1_MSG04"), 3);    
    elseif imc_int == 3 then
        --AttachEffect(pc, 'F_burstup001_dark', 0.5, 'MID');
        AddBuff(self, pc, "UC_sleep", 1 , 0, 3000, 1)
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_4_1_MSG05"), 3);    
    else
        --AttachEffect(pc, 'F_burstup001_dark', 0.5, 'MID');
        AddStamina(pc, -100)
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_4_1_MSG06"), 3);
    end
end



function SCR_PILGRIM51_FLOWER_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_8')
    if result == 'PROGRESS' then
        LookAt(pc, self)
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 1.5, 'PILGRIM51_SQ_8')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM51_SQ_8_MSG01"), 'SITGROPE', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'PILGRIM51_SQ_8')
        
        if result2 == 1 then
            local quest_ssn = GetSessionObject(pc,'SSN_PILGRIM51_SQ_8')
            if quest_ssn ~= nil then

                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
    
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_PILGRIM51_SQ_8', 'QuestInfoValue1', 1)
                    AttachEffect(self, "F_pc_making_finish_white", 2, "TOP")
                end
                
            	local party_list, party_cnt = GetPartyMemberList(pc, PARTY_NORMAL, 1000);
            	if party_cnt ~= 0 then
                    for j = 1, party_cnt do
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIM51_SQ_8_MSG02"), 5);
                        SendAddOnMsg(party_list[j], "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIM51_SQ_8_MSG02"), 5);
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIM51_SQ_8_MSG02"), 5);
                end
                Kill(self)
            end
        end
    end

end

function PILGRIM51_SQ_8_POISON_EVENT(self, pc)
    local imc_int = IMCRandom(1,2)
    if imc_int == 1 then
        AttachEffect(self, 'F_explosion052_green', 1, 'BOT');
        AddBuff(self, pc, "UC_sleep", 1 , 0, 3000, 1)
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_8_MSG03"), 3);
    else
        ObjectColorBlend(self, 255.0, 255.0, 255.0, 105.0, 1, 1)  
        PlayEffect(self, 'I_smoke010_dark', 2)      
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_8_MSG04"), 3);
    end  
end

function SCR_PILGRIM51_CALL_KILL(self)
    local PC_Owner = GetOwner(self)
    local quest_ssn = GetSessionObject(PC_Owner,'SSN_PILGRIM51_SQ_5_1')
    if quest_ssn ~= nil then
        if quest_ssn.QuestInfoValue1 >= quest_ssn.QuestInfoMaxCount1 then
            Kill(self)
        end
    end
end




function SCR_BUFF(pc)
    AddBuff(pc, pc, "MoveSpeed", 1, 0, 10000, 1)
end

-----------------------


function PILGRIM51_SQ_9_PREFUNC(pc)
    local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_9')
    if result == 'PROGRESS' then
        return "YES"
    end
end

function SCR_PILGRIM51_INSIGNIA_ENTER(self, pc)
    local invent = GetInvItemCount(pc, 'PILGRIM51_ITEM_11')
    if invent ~= 0 then
        local result = SCR_QUEST_CHECK(pc,'PILGRIM51_SQ_5_1')
        if result == 'PROGRESS' then
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("PILGRIM51_SQ_5_1_MSG01"), 2);
        end
    end
end

function SCR_PILGRIM51_SHOP_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'PILGRIM51_SQ_9')
    if result == 'PROGRESS' then
        ShowTradeDlg(pc, 'TO_PARDONER_MASTER', 5);
    end
end

function SCR_PILGRIM51_LOSTPAPER_DIALOG(self, pc)
    SCR_BOOK_GET(self, pc, 'PILGRIM51_LOSTPAPER_BOOK', 1)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("read01"), 5);
--    ShowOkDlg(pc, "PILGRIM51_LOSTPAPER_BASIC01")
end
