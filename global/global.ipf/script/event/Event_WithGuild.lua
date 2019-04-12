function SCR_GUILD_ATTENDANCE_DIALOG(self, pc)
    local aObj = GetAccountObj(pc);
    local guildObj = GetGuildObj(pc);
    local guildName = GetPartyName(guildObj);
    local now_time = os.date('*t')
    local year = now_time['year']
    local yday = now_time['yday']
    local curday = (year * 365) + yday
    local check_prop = {'Guild_Attendance_1', 'Guild_Attendance_2'}
    local check_reward, reward_num, yesterday = 1, 0, 2

    if GetTeamLevel(pc) < 5 then -- teamlv
        ShowOkDlg(pc, 'EVENT_REWARD_5DAY_FAIL', 1)
        return
    end

    -- reward check property
    -- 0 : Guild_Attendance_1
    -- 1 : Guild_Attendance_2
    if curday - guildObj.Guild_Attendance_Reset >= 2 then
        local tx = TxBegin(pc);
        TxSetPartyProp(tx, PARTY_GUILD, 'Guild_Attendance_Reset', curday);
        TxSetPartyProp(tx, PARTY_GUILD, 'Guild_Attendance_1', 0);
        TxSetPartyProp(tx, PARTY_GUILD, 'Guild_Attendance_2', 0);
        local ret = TxCommit(tx);
    elseif guildObj.Guild_Attendance_Reset ~= curday then -- reset
        local tx = TxBegin(pc);
        TxSetPartyProp(tx, PARTY_GUILD, 'Guild_Attendance_Reset', curday);
        TxSetPartyProp(tx, PARTY_GUILD, check_prop[curday % 2 + 1], 0);
        local ret = TxCommit(tx);
    end
    if curday % 2 == 0 then
        check_reward = 2;
        yesterday = 1;
    end
    if aObj.Guild_Attendance_Reward == curday then
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg("EVENT_WITH_GUILD_DLG1", "GUILD", guildName, "COUNT1", guildObj[check_prop[check_reward]], "COUNT2", guildObj[check_prop[yesterday]]), 5)
        return
    end

    if aObj.Guild_Attendance_Reward ~= curday and guildObj[check_prop[check_reward]] >= 0 then -- reward
        local guild_reward = {
            {1,  'misc_talt_event', 10, 'Ability_Point_Stone_50', 1},
            {10, 'misc_talt_event', 10, 'Ability_Point_Stone_50', 2},
            {20, 'misc_talt_event', 10, 'Ability_Point_Stone_50', 3},
            {30, 'misc_talt_event', 10, 'Ability_Point_Stone_50', 4},
            {40, 'misc_talt_event', 10, 'Ability_Point_Stone_50', 5, 'Premium_indunReset_1add_14d', 1}
        }

        for i = table.getn(guild_reward), 1, -1 do
            if guild_reward[i][1] <= guildObj[check_prop[check_reward]] then
                reward_num = i
                break;
            end
        end

        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'Guild_Attendance_Reward', curday) -- save day
        TxSetPartyProp(tx, PARTY_GUILD, check_prop[curday % 2 + 1], guildObj[check_prop[curday % 2 + 1]] + 1); -- guild attendence
        
        if reward_num >= 1 then
            for j = 2, table.getn(guild_reward[reward_num]), 2 do
                TxGiveItem(tx, guild_reward[reward_num][j], guild_reward[reward_num][j + 1], 'Guild_Attendance_Reward'); -- guild rewrad
            end
        end
        local ret = TxCommit(tx)

        if ret == 'SUCCESS' then
            PlayEffect(pc, "F_buff_basic025_white_line", 1) -- SUCCESS
            SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("EVENT_WITH_GUILD_DLG2"), 5)
        end
    end
end