function SCR_EVENT_TODAY_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum)  
    local aObj = GetAccountObj(self)
    local TeamLevel = GetTeamLevel(self);

    if TeamLevel < 2 or aObj.EV171212_STEAM_BEGINNER_JOIN_CHECK ~= 0 then
        return
    end
    if (argObj.ClassID >= 45132 and argObj.ClassID <= 45136) or (argObj.ClassID >= 45110 and argObj.ClassID <= 45111) then
        local rand = IMCRandom(1, 5)        
        if rand >= 4 then
            local tx = TxBegin(self);
			TxGiveItem(tx, 'Event_Number_Ticket', 1, "EV171212_SETTLE_TICKET_GIVE");
			local ret = TxCommit(tx);
        end
    end
end

function SCR_STEAM_SETTLE_EVENT_DIALOG(self,pc)
    local aObj = GetAccountObj(pc)
    local TeamLevel = GetTeamLevel(pc);
    local qCount = GetInvItemCount(pc, 'Event_Number_Ticket')
    local now_time = os.date('*t')
    local yday = now_time['yday']

    if TeamLevel < 2 or aObj.EV171212_STEAM_BEGINNER_JOIN_CHECK ~= 0 then
        ShowOkDlg(pc,'EVENT_STEAM_SETTLE_DLG_1', 1)
        return
    end
    
    local reward = {
    {1, 'Event_Sol_BOX_2', 1, 'Event_drug_steam_1h', 2},{2, 'Event_Sol_BOX_6', 1, 'Event_drug_steam_1h', 2},
    {3, 'Event_Sol_BOX_3', 1, 'Event_drug_steam_1h', 2},{4, 'Event_Sol_BOX_6', 1, 'Event_drug_steam_1h', 2},
    {5, 'Event_Sol_BOX_4', 1, 'Event_drug_steam_1h', 2},{6, 'Event_Sol_BOX_6', 1, 'Event_drug_steam_1h', 2},
    {7, 'Event_Sol_BOX_5', 1, 'Event_drug_steam_1h', 2},{8, 'Event_drug_steam_1h', 2, 'PremiumToken_24h', 1},
    {9, 'Event_drug_steam_1h', 2 , 'Event_Goddess_Statue', 2},{10, 'Event_drug_steam_1h', 2, 'Premium_indunReset_1add_14d', 1},
    {11, 'Event_drug_steam_1h', 2, 'Premium_WarpScroll_14d', 2},{12, 'Event_drug_steam_1h', 2, 'Premium_dungeoncount_Event', 1},
    {13, 'Event_drug_steam_1h', 2, 'Drug_Fortunecookie', 5},{14, 'Event_drug_steam_1h', 2, 'GIMMICK_Drug_HPSP2', 20},
    {15, 'Event_drug_steam_1h', 2, 'card_Xpupkit01_500_14d', 1},{16, 'Event_drug_steam_1h', 2, 'PremiumToken_24h', 1},
    {17, 'Event_drug_steam_1h', 2 , 'Event_Goddess_Statue', 2},{18, 'Event_drug_steam_1h', 2, 'Premium_indunReset_1add_14d', 1},
    {19, 'Event_drug_steam_1h', 2, 'Premium_WarpScroll_14d', 2},{20, 'Event_drug_steam_1h', 2, 'Ability_Point_Stone_500', 1, 'Moru_Silver', 1},
    {21, 'Event_drug_steam_1h', 2, 'Premium_dungeoncount_Event', 1},{22, 'Event_drug_steam_1h', 1, 'Drug_Fortunecookie', 5},
    {23, 'Event_drug_steam_1h', 2, 'GIMMICK_Drug_HPSP2', 20},{24, 'Event_drug_steam_1h', 2, 'PremiumToken_24h', 1},
    {25, 'Event_drug_steam_1h', 2 , 'Event_Goddess_Statue', 2},{26, 'Event_drug_steam_1h', 2, 'Premium_indunReset_1add_14d', 1},
    {27, 'Event_drug_steam_1h', 2, 'Premium_WarpScroll_14d', 2},{28, 'Event_drug_steam_1h', 2, 'Ability_Point_Stone', 1, 'Moru_Gold_14d', 1}
    }

    if aObj.EV171212_SETTLE_COUNT >= 28 then -- EV170711_TODAY_NUMBER_3
        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_6', 1)
        return     
    elseif aObj.EV171212_SETTLE_DAY_CHECK == yday then -- EV170711_TODAY_NUMBER_2
        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_5', 1)
        return         
    elseif qCount < 1 then
        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_4', 1)
        return
    elseif qCount >= 1 then
--print(aObj.EV171212_SETTLE_RAND_REWARD) 
        if aObj.EV171212_SETTLE_RAND_REWARD == 0 then -- EV170711_TODAY_NUMBER_1
            local rand = IMCRandom(1, 10)
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EV171212_SETTLE_RAND_REWARD', rand)
            local ret = TxCommit(tx)
--print(aObj.EV171212_SETTLE_RAND_REWARD)
        end
    end
        local inputSelect = ShowTextInputDlg(pc, 0, 'EV_NUMBER_SEL1')
        local input = tonumber(inputSelect)
        if input ~= nil and tonumber(input) > 0 and tonumber(input) < 11 then
            local tx = TxBegin(pc)
            TxTakeItem(tx, 'Event_Number_Ticket', 1, 'EV171212_SETTLE_TICKET_TAKE');
            local ret = TxCommit(tx)
            if ret == "SUCCESS" and tonumber(input) == aObj.EV171212_SETTLE_RAND_REWARD then
                for i = 1, table.getn(reward) do
                    if reward[i][1] == aObj.EV171212_SETTLE_COUNT + 1 then
                        local result = i
                        local tx = TxBegin(pc)
                        TxSetIESProp(tx, aObj, 'EV171212_SETTLE_RAND_REWARD', 0)
                        TxSetIESProp(tx, aObj, 'EV171212_SETTLE_DAY_CHECK', yday)
                        TxSetIESProp(tx, aObj, 'EV171212_SETTLE_COUNT', aObj.EV171212_SETTLE_COUNT + 1)
                            for j = 2, #reward[result], 2 do
                                TxGiveItem(tx, reward[result][j], reward[result][j+1], 'EV171212_SETTLE_REWARD');
                            end
                        local ret = TxCommit(tx)
                        ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_2', 1)
                        break
                    end
                end
            elseif ret == "SUCCESS" and tonumber(input) ~= aObj.EV171212_SETTLE_RAND_REWARD then
                ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_1', 1)
            end
        else
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_3', 1)
        end
end

function SCR_STEAM_EVENT_TODAY_TICKET(self,argObj,BuffName,arg1,arg2)

    local select = ShowSelDlg(self, 0, 'EVENT_STEAM_TODAY_TICKET_DLG_1', ScpArgMsg("Event_Steam_YC_2"), ScpArgMsg("Event_Steam_YC_3"), ScpArgMsg("Event_Steam_YC_4"), ScpArgMsg("Cancel"))

    if select == 1 then
        MoveZone(self, 'c_Klaipe', -179, 150, 72);
        AddBuff(self, self, 'Drug_Haste', arg1, 0, arg2, 1);
    elseif select == 2 then
        MoveZone(self, 'c_orsha', 145, 177, 278);
        AddBuff(self, self, 'Drug_Haste', arg1, 0, arg2, 1);
    elseif select == 3 then
        MoveZone(self, 'c_fedimian', -243, 161, -303);
        AddBuff(self, self, 'Drug_Haste', arg1, 0, arg2, 1);
    end
end