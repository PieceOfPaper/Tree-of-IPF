function SCR_USE_EVENT_STEAM_2YEARS_GUIDE(self, argstring, arg1, arg2)
    local aObj = GetAccountObj(self);
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local count = aObj.STEAM_2YEARS_MASTER_COUNT

    if aObj.STEAM_2YEARS_MASTER_YDAY == yday then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_2YEARS_MASTER_CHECK_3", "COUNT", count), 7);
        return
    end

    local rewardMaster = {
        {1, 1010},{2, 2011},{3, 3008},{4, 4009},{5, 1008},{6, 2006},{7, 3009},{8, 4010},{9, 1011},{10, 2008},{11, 3011},
        {12, 4005},{13, 1009},{14, 2005},{15, 3010},{16, 4014},{17, 1014},{18, 2009},{19, 3014},{20, 4015},{21, 1015},{22, 2015},
        {23, 3015},{24, 4016},{25, 1004},{26, 2004},{27, 3002},{28, 4011},{29, 1006},{30, 2007},{31, 3005},{32, 4007},{33, 1007},
        {34, 2010},{35, 3006},{36, 4006},{37, 1012},{38, 2016},{39, 3016},{40, 4017},{41, 1017},{42, 2014},{43, 3007},{44, 4019},
        {45, 1018},{46, 2018},{47, 3017},{48, 4012},{49, 1013},{50, 2019},{51, 3018},{52, 4018},{53, 1019},{54, 2017},{55, 3013}
    }
    for i = 1, table.getn(rewardMaster) do
        if aObj.STEAM_2YEARS_MASTER_COUNT + 1 == rewardMaster[i][1] then
            local todayMaster = rewardMaster[i][2]
            local job = GetClassString('Job', todayMaster, 'Name')
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_2YEARS_MASTER_CHECK_2", "COUNT", count, "JOB", job), 7);
        elseif aObj.STEAM_2YEARS_MASTER_COUNT >= 55 then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1707_COMPASS_MSG11"), 7);
        end
    end
end

function SCR_STEAM_EVENT_2YEARS_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local sObj = GetSessionObject(pc, 'ssn_klapeda')

    if aObj.STEAM_2YEARS_MASTER_DLC_CHECK == 1 then
        if aObj.STEAM_2YEARS_MASTER_COSTUME_CHECK == 0 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'costume_1709_NewField_m', 1, "EVENT_STEAM_2YEARS");
            TxGiveItem(tx, 'costume_1709_NewField_f', 1, "EVENT_STEAM_2YEARS");
            TxSetIESProp(tx, aObj, 'STEAM_2YEARS_MASTER_COSTUME_CHECK', 1);
            local ret = TxCommit(tx)
        end
        if sObj.STEAM_2YEARS_MASTER_LIST_CHECK == 0 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Event_Steam_2Years_Master_List', 1, "EVENT_STEAM_2YEARS");
            TxSetIESProp(tx, sObj, 'STEAM_2YEARS_MASTER_LIST_CHECK', 1);
            local ret = TxCommit(tx)
            if ret == "SUCCESS" then
                ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG5', 1)
            end 
        else
            ShowOkDlg(pc, 'NPC_EVENT_OneYear_2', 1) 
        end
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG4', 1)     
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local master = aObj.STEAM_2YEARS_MASTER_COUNT
    local yday = now_time['yday']
    local rewardItem = {
        {5, 'Premium_boostToken02_event01', 1},
        {10, 'Premium_Enchantchip14', 2},
        {15, 'Premium_dungeoncount_Event', 2},
        {20, 'Premium_boostToken03_event01', 1},
        {25, 'Premium_Enchantchip14', 4},
        {30, 'Premium_dungeoncount_Event', 4},
        {35, 'Premium_boostToken03_event01', 2},
        {40, 'Moru_Gold_14d', 1},
        {45, 'Event_Steam_Night_Market_RecipeBox1', 1},
        {50, 'Premium_SkillReset_14d', 1},
        {55, 'Premium_StatReset14', 1}
    }

    if aObj.STEAM_2YEARS_MASTER_YDAY == yday then
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG1', 1) 
        return
    else
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'STEAM_2YEARS_MASTER_COUNT', aObj.STEAM_2YEARS_MASTER_COUNT + 1); 
        TxSetIESProp(tx, aObj, 'STEAM_2YEARS_MASTER_YDAY', yday); 
        TxGiveItem(tx, 'Point_Stone_100', 1, 'STEAM_EVENT_2YEARS');
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            local teamlv = GetTeamLevel(pc)
            local teamName = GetTeamName(pc);
            local rewardcount = aObj.STEAM_2YEARS_MASTER_COUNT
            IMCLOG_CONTENT("180327_2YEARS_EVENT", "2Year_Join  ", "RewardCount:    ", rewardcount, "PClv:  ", pc.Lv, "TeamLv:  ", teamlv, "TeamName:   ", teamName)
        end
        for i = 1, table.getn(rewardItem) do
            if aObj.STEAM_2YEARS_MASTER_COUNT == rewardItem[i][1] then
                local result = i
                local tx = TxBegin(pc)
                for j = 2, #rewardItem[result], 2 do
                    TxGiveItem(tx, rewardItem[result][j], rewardItem[result][j+1], 'STEAM_EVENT_2YEARS');
                end
                local ret = TxCommit(tx)
                break
            end
        end
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG3', 1) 
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER1_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 0
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER2_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 1
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER3_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 2
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER4_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 3
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER5_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 4
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER6_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 5
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER7_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 6
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER8_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 7
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER9_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 8
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER10_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 9
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER11_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 10
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER12_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 11
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER13_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 12
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER14_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 13
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER15_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 14
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER16_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 15
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER17_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 16
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER18_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 17
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER19_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 18
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER20_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 19
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER21_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 20
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER22_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 21
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER23_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 22
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER24_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 23
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER25_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 24
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER26_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 25
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER27_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 26
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER28_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 27
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER29_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 28
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER30_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 29
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER31_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 30
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER32_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 31
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER33_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 32
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER34_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 33
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER35_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 34
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER36_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 35
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER37_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 36
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER38_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 37
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER39_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 38
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER40_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 39
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER41_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 40
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER42_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 41
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER43_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 42
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER44_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 43
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER45_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 44
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER46_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 45
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER47_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 46
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER48_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 47
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER49_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 48
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER50_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 49
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER51_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 50
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER52_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 51
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER53_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 52
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER54_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 53
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end

function SCR_STEAM_EVENT_2YEARS_MASTER55_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local master = 54
    if aObj.STEAM_2YEARS_MASTER_COUNT == master then
        SCR_STEAM_EVENT_2YEARS_MASTER_ALL(self, pc)
    else
        ShowOkDlg(pc, 'NPC_EVENT_2YEARS_DLG2', 1)
    end
end
