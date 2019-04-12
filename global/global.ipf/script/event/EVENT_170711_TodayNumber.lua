function SCR_EVENT_TODAY_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum)  
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local year, month, day, hour, min = GetAccountCreateTime(self)
    if ((month >= 7 and day >= 11) or (month >= 8)) and year >= 2017 then
        return
    end
    if (argObj.ClassID >= 45132 and argObj.ClassID <= 45136) or (argObj.ClassID >= 45110 and argObj.ClassID <= 45111) then
        local rand = IMCRandom(1, 5)        
        if rand >= 3 then
            local tx = TxBegin(self);
			TxGiveItem(tx, 'Event_Number_Ticket', 1, "EV170711_TODAY_NUMBER");
			local ret = TxCommit(tx);
        end
    end
end

function SCR_EVENT_TODAY_NUMBER_DIALOG(self, pc)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    local now_time = os.date('*t')
    local year, month, day, hour, min = GetAccountCreateTime(pc)
    local yday = now_time['yday']
    local aObj = GetAccountObj(pc)
    local qCount = GetInvItemCount(pc, 'Event_Number_Ticket')
    local reward = {
    {1, 'Event_Sol_BOX_2', 1},{2, 'Event_Sol_BOX_6', 1},
    {3, 'Event_Sol_BOX_3', 1},{4, 'Event_Sol_BOX_6', 1},
    {5, 'Event_Sol_BOX_4', 1},{6, 'Event_Sol_BOX_6', 1},
    {7, 'Event_Sol_BOX_5', 1},{8, 'Event_drug_steam_1h', 2, 'misc_gemExpStone_randomQuest4_14d', 1},
    {9, 'Event_drug_steam_1h', 2 , 'Event_Goddess_Statue', 2},{10, 'PremiumToken_7d_Steam', 1},
    {11, 'Event_drug_steam_1h', 2, 'CS_IndunReset_GTower_14d', 1},{12, 'Event_drug_steam_1h', 2, 'Drug_Fortunecookie', 5},
    {13, 'Event_drug_steam_1h', 2, 'GIMMICK_Drug_HPSP2', 20},{14, 'Event_drug_steam_1h', 2, 'misc_gemExpStone_randomQuest4_14d', 1},
    {15, 'costume_simple_festival_m', 1, 'costume_simple_festival_f', 1},{16, 'Event_drug_steam_1h', 2, 'Event_Goddess_Statue', 2},
    {17, 'Event_drug_steam_1h', 2, 'CS_IndunReset_GTower_14d', 1},{18, 'Event_drug_steam_1h', 2, 'Drug_Fortunecookie', 5},
    {19, 'Event_drug_steam_1h', 2, 'GIMMICK_Drug_HPSP2', 20},{20, 'Premium_SkillReset_14d', 1},
    {21, 'Event_drug_steam_1h', 2, 'misc_gemExpStone_randomQuest4_14d', 1},{22, 'Event_drug_steam_1h', 2, 'Event_Goddess_Statue', 2},
    {23, 'Event_drug_steam_1h',2 , 'CS_IndunReset_GTower_14d', 1},{24, 'Event_drug_steam_1h', 2, 'Drug_Fortunecookie', 5},
    {25, 'Moru_Silver', 1, 'Moru_Gold_14d', 1, 'Moru_Diamond_14d', 1},{26, 'Event_drug_steam_1h', 2, 'GIMMICK_Drug_HPSP2', 20},
    {27, 'Event_drug_steam_1h', 2, 'CS_IndunReset_GTower_14d', 1},{28, 'Event_drug_steam_1h', 2, 'Event_Goddess_Statue', 2},
    {29, 'Event_drug_steam_1h', 2, 'CS_IndunReset_GTower_14d', 1},{30, 'Premium_StatReset14', 1},
    }
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_TODAY_NUMBER_8', ScpArgMsg("Event_Today_Number_2"), ScpArgMsg("Event_Today_Number_3"), ScpArgMsg("Cancel")) 
    if select == 1 then 
        if ((month >= 7 and day >= 11) or (month >= 8)) and year >= 2017 then
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_7', 1)
            return 
        elseif aObj.EV170711_TODAY_NUMBER_3 >= 30 then
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_6', 1)
            return     
        elseif aObj.EV170711_TODAY_NUMBER_2 == yday then
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_5', 1)
            return         
        elseif qCount < 1 then
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_4', 1)
            return
        elseif qCount >= 1 then
    --print(aObj.EV170711_TODAY_NUMBER_1) 
            if aObj.EV170711_TODAY_NUMBER_1 == 0 then
                local rand = IMCRandom(1, 10)
                local tx = TxBegin(pc)
                TxSetIESProp(tx, aObj, 'EV170711_TODAY_NUMBER_1', rand)
            	local ret = TxCommit(tx)
    --print(aObj.EV170711_TODAY_NUMBER_1)
            end
        end
        local inputSelect = ShowTextInputDlg(pc, 0, 'EV_NUMBER_SEL1')
        local input = tonumber(inputSelect)
        if input ~= nil and tonumber(input) > 0 and tonumber(input) < 11 then
            local tx = TxBegin(pc)
            TxTakeItem(tx, 'Event_Number_Ticket', 1, 'EV170711_TODAY_NUMBER');
            local ret = TxCommit(tx)
            if ret == "SUCCESS" and tonumber(input) == aObj.EV170711_TODAY_NUMBER_1 then
                for i = 1, table.getn(reward) do
                    if reward[i][1] == aObj.EV170711_TODAY_NUMBER_3 + 1 then
                        local result = i
                        local tx = TxBegin(pc)
                        TxSetIESProp(tx, aObj, 'EV170711_TODAY_NUMBER_1', 0)
                        TxSetIESProp(tx, aObj, 'EV170711_TODAY_NUMBER_2', yday)
                        TxSetIESProp(tx, aObj, 'EV170711_TODAY_NUMBER_3', aObj.EV170711_TODAY_NUMBER_3 + 1)
                            for j = 2, #reward[result], 2 do
                                TxGiveItem(tx, reward[result][j], reward[result][j+1], 'EV170711_TODAY_NUMBER');
                            end
                        local ret = TxCommit(tx)
                        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_2', 1)
                        break
                    end
                end
            elseif ret == "SUCCESS" and tonumber(input) ~= aObj.EV170711_TODAY_NUMBER_1 then
                ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_1', 1)
            end
        else--if input == nil or input < 1 or input > 10 then
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_3', 1)
        end
    elseif select == 2 then
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("Event_Today_Number_4", "NUMCOUNT", aObj.EV170711_TODAY_NUMBER_3), 5)
    end
end