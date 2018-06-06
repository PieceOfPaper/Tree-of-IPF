function SCR_FEDIMIAN_SIGN1_DIALOG (self, pc)
    ShowOkDlg(pc,"FEDIMIAN_SIGN1_BASIC01",1)
end

function SCR_FEDIMIAN_OLDMAN1_DIALOG (self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'PRISON_81_SQ_1')
    if result1 == 'PROGRESS' then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("PRISON_81_SQ_1_MSG1"), 'TALK', 2, 'SSN_HATE_AROUND')
        if result2 == 1 then
            ShowOkDlg(pc,"PRISON_81_SQ_1_dlg1",1)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_PRISON_81_SQ_1', 'QuestInfoValue1', 1)
        end
    else
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
    local rnd = IMCRandom(1, 20)
    if rnd == 1 or _hidden_prop == 258 then
        ShowOkDlg(pc, "HIDDEN_RUNECASTER_npc6_dlg1", 1)
    else
    COMMON_QUEST_HANDLER(self,pc)
        end
    end
end

function SCR_FEDIMIAN_OLDMAN1_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 23, "CHAR120_FEDIMIAN_OLDMAN1_1", "CHAR120_FEDIMIAN_OLDMAN1_2")
end

function SCR_FEDIMIAN_OLDMAN1_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_FEDIMIAN_SIGN2_DIALOG (self, pc)
    ShowOkDlg(pc,"FEDIMIAN_SIGN2_BASIC01",1)
end
function SCR_FEDIMIAN_SIGN3_DIALOG (self, pc)
    ShowOkDlg(pc,"FEDIMIAN_SIGN3_BASIC01",1)
end

function SCR_FEDIMIAN_SIGN4_DIALOG (self, pc)
    ShowOkDlg(pc,"FEDIMIAN_SIGN4_BASIC01",1)
end

function SCR_FEDIMIAN_POTTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
--    ShowOkDlg(pc, "FEDIMIAN_POTTER_DLG", 1)
--    Chat(self, ScpArgMsg("FEDIMIAN_POTTER"))
end


function SCR_FEDIMIAN_NPC_POTTER1_DIALOG (self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_FEDIMIAN_NPC_POTTER2_DIALOG (self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_FEDIMIAN_NPC_POTTER3_DIALOG (self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_FEDIMIAN_NPC_POTTER4_DIALOG (self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_FEDIMIAN_NPC_CART_DIALOG (self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end



function SCR_FEDIMIAN_NPC_TEMPLE04_DIALOG (self, pc)
    local ht_sel1 = ShowSelDlg(pc, 0, "HT_FEDIMIAN_NPC_TEMPLE04_BASIC05", ScpArgMsg("HT_FEDIMIAN_NPC_TEMPLE04_SEL01"), ScpArgMsg("HT_FEDIMIAN_NPC_TEMPLE04_SEL02"))
    if ht_sel1 == 1 then
    COMMON_QUEST_HANDLER(self,pc)
    else
        local ht_sel2 = ShowSelDlg(pc, 0, 'HT_FEDIMIAN_NPC_TEMPLE04_BASIC06', ScpArgMsg("HT_FEDIMIAN_NPC_TEMPLE09_SEL04"))
        if ht_sel2 == 1 then

	        local ht_chat = {'HT_FEDIMIAN_NPC_TEMPLE09_CHAT01','HT_FEDIMIAN_NPC_TEMPLE09_CHAT02', 'HT_FEDIMIAN_NPC_TEMPLE09_CHAT03'}
	        Chat(self, ScpArgMsg(ht_chat[IMCRandom(1,3)]), 2)
	        sleep(1000)
	        SCR_SETPOS_FADEOUT(pc, 'c_fedimian', 556, 752, 1047)
        end
    end

end


function SCR_FEDIMIAN_NPC_TEMPLE09_DIALOG (self, pc)
    local sObj = GetSessionObject(pc, 'SSN_DIALOGCOUNT')
    if sObj ~= nil then
        --print(sObj.HT_FEDIMIAN_SOL)
        if sObj.HT_FEDIMIAN_SOL < 100 then
            local ht_num = IMCRandom(1, 10)
            --print (ht_num)
            sObj.HT_FEDIMIAN_SOL = sObj.HT_FEDIMIAN_SOL + ht_num
            COMMON_QUEST_HANDLER(self,pc)
        else
            local ht_sel1 = ShowSelDlg(pc, 0, 'HT_FEDIMIAN_NPC_TEMPLE09_BASIC05', ScpArgMsg("HT_FEDIMIAN_NPC_TEMPLE09_SEL01"), ScpArgMsg("HT_FEDIMIAN_NPC_TEMPLE09_SEL02"), ScpArgMsg("HT_FEDIMIAN_NPC_TEMPLE09_SEL03"))
            if ht_sel1 == 1 then
                COMMON_QUEST_HANDLER(self,pc)
            elseif ht_sel1 == 2 then
                ShowOkDlg(pc, 'HT_FEDIMIAN_NPC_TEMPLE09_BASIC06', 1)
            else
                
                local ht_sel2 = ShowSelDlg(pc, 0, 'HT_FEDIMIAN_NPC_TEMPLE09_BASIC07', ScpArgMsg("HT_FEDIMIAN_NPC_TEMPLE09_SEL04"))
                if ht_sel2 == 1 then

        	        local ht_chat = {'HT_FEDIMIAN_NPC_TEMPLE09_CHAT01','HT_FEDIMIAN_NPC_TEMPLE09_CHAT02', 'HT_FEDIMIAN_NPC_TEMPLE09_CHAT03'}
        	        Chat(self, ScpArgMsg(ht_chat[IMCRandom(1,3)]), 2)
        	        sleep(1000)
        	        SCR_SETPOS_FADEOUT(pc, 'c_fedimian', -123, 819, 772)
                end
                
            end
        end
    else
    COMMON_QUEST_HANDLER(self,pc)
    end    
end



function SCR_FEDIMIAN_NPC_11_DIALOG (self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FEDIMIAN_NPC_11_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 25, "CHAR120_FEDIMIAN_NPC_11_1", "CHAR120_FEDIMIAN_NPC_11_2")
end

function SCR_FEDIMIAN_NPC_11_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_FEDIMIAN_NPC_12_DIALOG (self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_FEDIMIAN_NPC_12_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 24, "CHAR120_FEDIMIAN_NPC_12_1", "CHAR120_FEDIMIAN_NPC_12_2")
end

function SCR_FEDIMIAN_NPC_12_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_PILGRIM_PRE_BOARD_DIALOG (self, pc)
    local select = ShowSelDlg(pc, 0, 'PILGRIM_PRE_BOARD_BASIC', ScpArgMsg("PILGRIM_PRE_BOARD_BASIC01"),ScpArgMsg("PILGRIM_PRE_BOARD_BASIC02"),
                                ScpArgMsg("PILGRIM_PRE_BOARD_BASIC03"),ScpArgMsg("PILGRIM_PRE_BOARD_BASIC04"), ScpArgMsg("PILGRIM_PRE_BOARD_BASIC05"))
    if select == 1 then
        ShowOkDlg(pc, 'PILGRIM_PRE_BOARD_BASIC01', 1)
    elseif select == 2 then
        ShowOkDlg(pc, 'PILGRIM_PRE_BOARD_BASIC02', 1)
    elseif select == 3 then
        ShowOkDlg(pc, 'PILGRIM_PRE_BOARD_BASIC03', 1)
    elseif select == 4 then
        ShowOkDlg(pc, 'PILGRIM_PRE_BOARD_BASIC04', 1)
    else 
        ShowOkDlg(pc, 'PILGRIM_PRE_BOARD_BASIC05', 1)
    end
end

function SCR_FEDIMIAN_OFFICIAL_BOARD_DIALOG (self, pc)
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_20');
    if IS_KOR_TEST_SERVER() then
        return
    elseif is_unlock == 'NO' then
        ShowOkDlg(pc,"HIDDEN_CHAR120_MSTEP1_1",1)
        local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
        local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
        if sObj == nil then
            CreateSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
        end
        --print(hidden_prop)
        if hidden_prop <= 0 then
            SCR_SET_HIDDEN_JOB_PROP(pc, "Char1_20", 20)
            ShowBalloonText(pc, "HIDDEN_CHAR120_MSTEP1_2",5)
        elseif hidden_prop <= 20 then
            ShowBalloonText(pc, "HIDDEN_CHAR120_MSTEP1_2",5)
        end
    elseif is_unlock == 'YES' then
        ShowOkDlg(pc,"HIDDEN_CHAR120_MSTEP1_2",1)
    end
end