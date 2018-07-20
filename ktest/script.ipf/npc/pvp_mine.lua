-- enter npc
function SCR_PVP_MINE_TEAM_NPC_DIALOG(self, pc)
    local result = SCR_PVP_MINE_ENTER_TIME_DIALOG(self, pc)

    if result == false then
        ShowOkDlg(pc, 'PVP_MINE_DLG1', 1)
        local now_time = os.date('*t')
        local yday = now_time['yday']
        local aObj = GetAccountObj(pc)

        if aObj.PVP_MINE_TradeCount_Reset ~= yday then -- reset
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'PVP_MINE_TradeCount_Reset', yday);
            TxSetIESProp(tx, aObj, 'PVP_MINE_TradeCount1', 1);
            local ret = TxCommit(tx)
        end
        ExecClientScp(pc, "REQ_PVP_MINE_SHOP_OPEN()")
        return
    end

    local itemCount = GetInvItemCount(pc, "misc_pvp_mine2");
    local select1 = 0
    if itemCount > 25000 then
        select1 = ShowSelDlg(pc, 0, 'PVP_MINE_DLG3', ScpArgMsg("Yes"),ScpArgMsg("No"))
    else
        select1 = ShowSelDlg(pc, 0, 'PVP_MINE_DLG4', ScpArgMsg("Yes"),ScpArgMsg("No"))
    end
    
    if select1 == 1 then
        SCR_PVP_MINE_ENTER_NPC_DIALOG_CHANNEL_INIT(pc)
    end
end

-- enter time and join
function SCR_PVP_MINE_ENTER_TIME_DIALOG(self, pc)
    local now_time = os.date('*t')
    local hour = now_time['hour']
    local min = now_time['min']

    local aObj = GetAccountObj(pc)
    local partyObj = GetPartyObj(pc)

    if (min >= 6 and min <= 15) or (min >= 26 and min <= 35) then
        ShowOkDlg(pc, 'PVP_MINE_DLG5', 1)
        return false;
    elseif pc.Lv < 350 then
        ShowOkDlg(pc, 'EV_PRISON_DESC2', 1)
        return false;
    elseif partyObj ~= nil then
        SendSysMsg(pc, 'CannotUseInParty');
        return false;
    end

    if 21 == hour then
        if (min >= 0 and min <= 5) or (min >= 20 and min <= 25) then
            return true;
        end
    end

    return false;
end

-- dungenon enter and channel search
function SCR_PVP_MINE_ENTER_NPC_DIALOG_CHANNEL_INIT(pc)
    local goChannel = SCR_PVP_MINE_ENTER_NPC_DIALOG_CHANNEL_SEARCH(pc)
    
    if goChannel == nil then
        SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg("EVENT_1710_HALLOWEEN_MSG1"), 10)
        return
    end
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local yday = now_time['yday']
    local hour = now_time['hour']
    local min = now_time['min']
    local current_hour = ((year - 2010) * 365 * 24) + (yday * 24) + hour

    local tx = TxBegin(pc)
    local itemCount = GetInvItemCount(pc, "misc_pvp_mine1");
    TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', 0);
    TxSetIESProp(tx, aObj, 'PVP_MINE_RESET', current_hour);
    TxSetIESProp(tx, aObj, 'PVP_MINE_POINT', 0);
    TxSetIESProp(tx, aObj, 'PVP_MINE_Kill', 0);

    if itemCount > 0 then
        TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_STONE');
    end
    local ret = TxCommit(tx)

    if ret == "SUCCESS" then
        MoveZone(pc, 'pvp_Mine', 0, 0, 0, nil, goChannel)        
    end
end

function SCR_PVP_MINE_ENTER_NPC_DIALOG_CHANNEL_SEARCH(pc)
    local channelIDList, pcCountList =  GetAliveChannelList("pvp_Mine")
    local goChannel
    
    local maxPCCount = 60
    local lessthanList = {}
    
    for i = 1, #channelIDList do
        if pcCountList[i] < maxPCCount then
            lessthanList[#lessthanList + 1] = channelIDList[i]
        end
    end
    
    if #lessthanList == 0 then
        return nil
    end
    
    local rand = IMCRandom(1, #lessthanList)

    return lessthanList[rand]
end

-- pvp_mine_buff
function SCR_PVP_MINE_GETBUFF(pc)
    if IsDummyPC(pc) == 1 then
		return;
	end

    if GetZoneName(pc) ~= 'pvp_Mine' then
        return;
    end

    local aObj = GetAccountObj(pc)
    if aObj.PVP_MINE_POINT == 0 then -- save channel
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'PVP_MINE_POINT', GetChannelID(pc));
        local ret = TxCommit(tx)
    elseif aObj.PVP_MINE_POINT >= 1 then
        if GetChannelID(pc) ~= aObj.PVP_MINE_POINT then
            return;
        end
    end

    local mgame = IsPlayingMGame(pc, "PVP_MINE")
    if mgame == 0 then
        return;
    end

    local cmd = GetMGameCmd(pc)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local teamA, teamB = 0, 0;
    local team_pos = 1
    local team_buff = 'PVP_MINE_BUFF1'
    local start_pos = {
        {-1355.3, 149.2, -1427.3}, -- team A
        { 1485.3, 149.2,  1461.3} -- team B
    }

    if cmd:GetUserValue('ToEndBattle_START_Mine') ~= nil and cmd:GetUserValue('ToEndBattle_START_Mine') ~= 0 then
        ExecClientScp(pc, "MINEPVP_TIMER_START(" .. cmd:GetUserValue('ToEndBattle_START_Mine') .. ")")
    end

    if IsBuffApplied(pc, "PVP_MINE_BUFF1") == 'YES' then
        RemoveBuff(pc, 'PVP_MINE_BUFF1')
    elseif IsBuffApplied(pc, "PVP_MINE_BUFF2") == 'YES' then
        RemoveBuff(pc, 'PVP_MINE_BUFF2')
    end

    local currentStage = GetMGameValue(pc, 'currentStage')

    if currentStage == 1 then
        if imcTime.GetAppTime() - cmd:GetUserValue('ToEndBattle_START_Mine') >= 600 then
            return;
        end
    end

    for i = 2, cnt do
        if IsBuffApplied(list[i], 'PVP_MINE_BUFF1') == 'YES' then
            teamA = teamA + 1
        else
            teamB = teamB + 1
        end
    end

    if teamA + 1 > teamB then
        team_pos = 2
        team_buff = 'PVP_MINE_BUFF2'
    end

    AddBuff(pc, pc, team_buff, 1, 0, 0, 1);
    sleep(1000)
    SetPos(pc, start_pos[team_pos][1], start_pos[team_pos][2], start_pos[team_pos][3])
    
    DO_MINEPVP_SCORE_UPDATE(pc)
    
    ExecClientScp(pc, "SET_TARGETINFO_TO_MINE_POS()")

    ExecClientScp(pc, "SHOW_MINEPVPMYSCOREBOARD()")
    ExecClientScp(pc, "MINEPVPMYSCOREBOARD_SET_MY_SCORE(0, "..aObj.PVP_MINE_MAX..")")
    ExecClientScp(pc, "MINEPVPMYSCOREBOARD_SET_MY_SCORE(1, "..aObj.PVP_MINE_Kill..")")
end

-- buff1
function SCR_BUFF_ENTER_PVP_MINE_BUFF1(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, "Team_1_mine");
    SetDeadScript(self, "SCR_PVP_MINE_DEAD")
    EnableResurrect(self, false);
end

function SCR_BUFF_UPDATE_PVP_MINE_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) ~= 'pvp_Mine' then
        return 0;
    end

    return 1;
end

function SCR_BUFF_LEAVE_PVP_MINE_BUFF1(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, "Law");
end

-- buff2
function SCR_BUFF_ENTER_PVP_MINE_BUFF2(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, "Team_2_mine");
    SetDeadScript(self, "SCR_PVP_MINE_DEAD")
    EnableResurrect(self, false);
end

function SCR_BUFF_UPDATE_PVP_MINE_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) ~= 'pvp_Mine' then
        return 0;
    end

    return 1;
end

function SCR_BUFF_LEAVE_PVP_MINE_BUFF2(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, "Law");
end

-- atk buff
function SCR_BUFF_ENTER_PVP_MINE_BUFF_ATK(self, buff, arg1, arg2, over)
    local value = 20 * over
    self.PATK_BM = self.PATK_BM + value
    self.MATK_BM = self.MATK_BM + value

    SetExProp(buff, "ADD_ATK_VALUE", value)
end

function SCR_BUFF_UPDATE_PVP_MINE_BUFF_ATK(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) ~= 'pvp_Mine' then
        return 0;
    end

    return 1;
end

function SCR_BUFF_LEAVE_PVP_MINE_BUFF_ATK(self, buff, arg1, arg2, over)
    local value = GetExProp(buff, "ADD_ATK_VALUE")
    self.PATK_BM = self.PATK_BM - value
    self.MATK_BM = self.MATK_BM - value
end

-- ë°œë¦¬?¤í? ì¶œí˜ˆ ?€ë¯¸ì? --
function SCR_BUFF_ENTER_PvP_Mine_Crossbow_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local dmg = math.floor(self.MHP * 0.09)
    SetExProp(self, 'PvP_Mine_Crossbow_Debuff', dmg)
end

function SCR_BUFF_UPDATE_PvP_Mine_Crossbow_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    local dmg = GetExProp(self, 'PvP_Mine_Crossbow_Debuff')
    TakeDamage(caster, self, "None", dmg, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);   
    return 1;

end

function SCR_BUFF_LEAVE_PvP_Mine_Crossbow_Debuff(self, buff, arg1, arg2, over)

end

-- safe buff
function SCR_BUFF_ENTER_PVP_MINE_Safe(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 5
end

function SCR_BUFF_LEAVE_PVP_MINE_Safe(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 5
end

-- start alarm
function SCR_PVP_MINE_START_ALARAM_TS_BORN_ENTER(self)
    self.NumArg1 = 0;
end

function SCR_PVP_MINE_START_ALARAM_TS_BORN_UPDATE(self)
    local channel = GetChannelID(self)

    if channel == 1 then
        local now_time = os.date('*t')
        local hour = now_time['hour']
        local min = now_time['min']
        local sec = now_time['sec']

        if hour == 20 then
            if min == 30 and self.NumArg1 == 0 then
                BroadcastToAllServerPC(1, ScpArgMsg("pvp_mine_before_30m"), "");
                self.NumArg1 = 1
            elseif min == 50 and self.NumArg1 == 1 then
                BroadcastToAllServerPC(1, ScpArgMsg("pvp_mine_before_10m"), "");
                self.NumArg1 = 2
            elseif min == 55 and self.NumArg1 == 2 then
                BroadcastToAllServerPC(1, ScpArgMsg("pvp_mine_before_5m"), "");
                self.NumArg1 = 3
            elseif min == 59 and self.NumArg1 == 3 and sec == 58 then
                BroadcastToAllServerPC(1, ScpArgMsg("pvp_mine_before_start"), "");
                self.NumArg1 = 0
            end
        end
    end
end

function SCR_PVP_MINE_START_ALARAM_TS_BORN_LEAVE(self)
end

function SCR_PVP_MINE_START_ALARAM_TS_DEAD_ENTER(self)
end

function SCR_PVP_MINE_START_ALARAM_TS_DEAD_UPDATE(self)
end

function SCR_PVP_MINE_START_ALARAM_TS_DEAD_LEAVE(self)
end

-- mgame start
function SCR_PVP_MINE_CREATEOBJECT_TS_BORN_ENTER(self)
    self.NumArg1 = 0;
end

function SCR_PVP_MINE_CREATEOBJECT_TS_BORN_UPDATE(self)
    local mgame = IsPlayingMGame(self, "PVP_MINE")
    local zoneInst = GetZoneInstID(self);
    local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneInst, layer);

    if mgame == 1 then
        local cmd = GetMGameCmd(self)
        local list, cnt = GetCmdPCList(cmd:GetThisPointer());
        local teamA, teamB = 0, 0;
        local myTeam = 'A'
        local team_pos = 1

        for i = 1, cnt do
            if IsBuffApplied(list[i], 'PVP_MINE_BUFF1') == 'YES' then
                teamA = teamA + 1
            else
                teamB = teamB + 1
            end
        end

        if teamA > teamB then
            myTeam = 'B'
            team_pos = 2
        end

    elseif mgame == 0 then
        local now_time = os.date('*t')
        local hour = now_time['hour']
        local min = now_time['min']
        local sec = now_time['sec']

        if 21 == hour then
            if (min >= 0 and min <= 5) or (min >= 20 and min <= 25) then
                RunMGame(self, 'PVP_MINE')
                return
            end
        end

        if cnt > 0 then -- player zonemove
            for a = 1, cnt do
                RunScript('SCR_PVP_MINE_TIMEOUT_RUN', list[a])
            end
        end
    end
end

function SCR_PVP_MINE_CREATEOBJECT_TS_BORN_LEAVE(self)
end

function SCR_PVP_MINE_CREATEOBJECT_TS_DEAD_ENTER(self)
end

function SCR_PVP_MINE_CREATEOBJECT_TS_DEAD_UPDATE(self)
end

function SCR_PVP_MINE_CREATEOBJECT_TS_DEAD_LEAVE(self)
end

-- move zone
function SCR_PVP_MINE_TIMEOUT(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    for i = 1, cnt do
        RunScript('SCR_PVP_MINE_TIMEOUT_RUN', list[i])
    end
end

function SCR_PVP_MINE_TIMEOUT_RUN(pc)
    local mine_city_pos = {
        {100.6, 35.9, -1354.8},
        {323.8, 35.9, -1274},
        {-16.14, 94.8, -1034}
    }
    local rand = IMCRandom(1, #mine_city_pos)
    MoveZone(pc, 'f_siauliai_out', mine_city_pos[rand][1], mine_city_pos[rand][2], mine_city_pos[rand][3], nil, 1)
end

-- result
function SCR_PVP_MINE_REWARD(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local TOP_KILL_COUNT_A, TOP_KILL_COUNT_B = 0, 0;
    local TOP_KILL_NAME_A, TOP_KILL_NAME_B
    local TOP_POINT_COUNT_A, TOP_POINT_COUNT_B = 0, 0;
    local TOP_POINT_NAME_A, TOP_POINT_NAME_B

    cmd:SetUserValue("currentStage", 2);

    -- MVP --
    for j = 1, cnt do
        if list[j] ~= nil then
            local aObj = GetAccountObj(list[j])
            if IsBuffApplied(list[j], 'PVP_MINE_BUFF1') == 'YES' then
                if aObj.PVP_MINE_Kill > TOP_KILL_COUNT_A then -- top kill
                    TOP_KILL_COUNT_A = aObj.PVP_MINE_Kill
                    TOP_KILL_NAME_A = GetTeamName(list[j])
                end

                if aObj.PVP_MINE_MAX > TOP_POINT_COUNT_A then -- top point
                    TOP_POINT_COUNT_A = aObj.PVP_MINE_MAX
                    TOP_POINT_NAME_A = GetTeamName(list[j])
                end
            elseif IsBuffApplied(list[j], 'PVP_MINE_BUFF2') == 'YES' then
                if aObj.PVP_MINE_Kill > TOP_KILL_COUNT_B then -- top kill
                    TOP_KILL_COUNT_B = aObj.PVP_MINE_Kill
                    TOP_KILL_NAME_B = GetTeamName(list[j])
                end

                if aObj.PVP_MINE_MAX > TOP_POINT_COUNT_B then -- top point
                    TOP_POINT_COUNT_B = aObj.PVP_MINE_MAX
                    TOP_POINT_NAME_B = GetTeamName(list[j])
                end
            end

            if j == cnt then
                SetMGameValue_Str(list[cnt], "MVP_NAME_KILL_A", TOP_KILL_NAME_A);
                SetMGameValue_Str(list[cnt], "MVP_NAME_KILL_B", TOP_KILL_NAME_B);
                SetMGameValue_Str(list[cnt], "MVP_NAME_MINE_A", TOP_POINT_NAME_A);
                SetMGameValue_Str(list[cnt], "MVP_NAME_MINE_B", TOP_POINT_NAME_B);

                
                SetMGameValue(list[cnt], "MVP_COUNT_KILL_A", TOP_KILL_COUNT_A);
                SetMGameValue(list[cnt], "MVP_COUNT_KILL_B", TOP_KILL_COUNT_B);
                SetMGameValue(list[cnt], "MVP_COUNT_MINE_A", TOP_POINT_COUNT_A);
                SetMGameValue(list[cnt], "MVP_COUNT_MINE_B", TOP_POINT_COUNT_B);
            end
        end
    end

    for i = 1, cnt do
        local bouns = 0;
        if GetTeamName(list[i]) == TOP_KILL_NAME_A or GetTeamName(list[i]) == TOP_KILL_NAME_B then
            bouns = 450
        end

        if GetTeamName(list[i]) == TOP_POINT_NAME_A or GetTeamName(list[i]) == TOP_POINT_NAME_B then
            bouns = bouns + 900
        end
        
        RunScript('SCR_PVP_MINE_REWARD_RUN', list[i], bouns)
    end

    --CLOSE_MINEPVPMYSCOREBOARD()
end

function SCR_PVP_MINE_REWARD_RUN(pc, bouns)
    local aObj = GetAccountObj(pc)
    local zoneObj = GetLayerObject(pc);
    local TEAM_A_COUNT = GetMGameValue(pc, "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(pc, "TEAM_B_COUNT")
    local result = 'None'
    local mine_max = aObj.PVP_MINE_MAX

    if mine_max > 500 then
        mine_max = 500
    end

    local reward_win = 1500 + (mine_max * 3)
    local reward_lose = 300 + (mine_max * 3)
    local itemCount = GetInvItemCount(pc, "misc_pvp_mine1"); 

    if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' or IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
    local myTeamPoint = TEAM_A_COUNT;
    local rewardItemCnt = reward_win;
    local beforePoint = mine_max;
    local tx = TxBegin(pc)
    TxEnableInIntegrate(tx);
    TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', 0);
    TxSetIESProp(tx, aObj, 'PVP_MINE_POINT', 0);
    
    if itemCount > 0 then
        TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_END');
    end

    if TEAM_A_COUNT > TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
                TxGiveItem(tx, 'misc_pvp_mine2', reward_win, "PVP_MINE_TEAM_REWARD_WIN");
            result = 'Win'
        else
            TxGiveItem(tx, 'misc_pvp_mine2', reward_lose, "PVP_MINE_TEAM_REWARD_LOSE");
            result = 'Lose'
            myTeamPoint = TEAM_B_COUNT;
            rewardItemCnt = reward_lose;
        end
    elseif TEAM_A_COUNT < TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
                TxGiveItem(tx, 'misc_pvp_mine2', reward_win, "PVP_MINE_TEAM_REWARD_WIN");
            result = 'Win'
            myTeamPoint = TEAM_B_COUNT;
        else
                TxGiveItem(tx, 'misc_pvp_mine2', reward_lose, "PVP_MINE_TEAM_REWARD_LOSE");
            result = 'Lose'
            rewardItemCnt = reward_lose;
        end
    else
            TxGiveItem(tx, 'misc_pvp_mine2', reward_lose, "PVP_MINE_TEAM_REWARD_DRAW");
        result = 'Draw'
        rewardItemCnt = reward_lose;
    end

    if bouns > 0 then
        if bouns == 450 then
            TxGiveItem(tx, 'misc_pvp_mine2', 450, "PVP_MINE_MVP_REWARD_TopKiller");
        elseif bouns == 900 then
            TxGiveItem(tx, 'misc_pvp_mine2', 900, "PVP_MINE_MVP_REWARD_TopPoint");
        elseif bouns == 1350 then
            TxGiveItem(tx, 'misc_pvp_mine2', 1350, "PVP_MINE_MVP_REWARD_TopAll");
        end
    end

    local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            local start_pos = {
                {-1355.3, 149.2, -1427.3}, -- team A
                { 1485.3, 149.2,  1461.3} -- team B
            }

            local team = 1;
            local teamB = IsBuffApplied(pc, 'PVP_MINE_BUFF2')

            if teamB == 'YES' then
                team = 2;
            end

            if IsDead(pc) == 1 then
                ResurrectPc(pc, "AGARIO", 0, 100);
            end
                ExecClientScp(pc, "DISAPPEAR_MINEPVP_TIMER()")
            SCR_SETPOS_FADEOUT(pc, 'pvp_Mine', start_pos[team][1], start_pos[team][2], start_pos[team][3])

            PlayEffect(pc, "F_fireworks001", 1)

            local teamName = GetTeamName(pc)
            local channel = GetChannelID(pc)

            if reset == 'Win' then -- graylog
                IMCLOG_CONTENT_SPACING("PVP_MINE_REWARD", teamName, pc.Name, result, team, reward_win, channel)
            else
                IMCLOG_CONTENT_SPACING("PVP_MINE_REWARD", teamName, pc.Name, result, team, reward_lose, channel)
            end

            PVPMineResultLog(pc, GET_PVP_MINE_TEAM_NAME(pc), result, myTeamPoint, 'misc_pvp_mine2', rewardItemCnt, beforePoint);
            PVPMinePointLog(pc, GET_PVP_MINE_TEAM_NAME(pc), 'Delete', 'None', beforePoint, 0, 0, 'misc_pvp_mine2', rewardItemCnt)

			--KILL MVP
			if GetTeamName(pc) == TOP_KILL_NAME_A or GetTeamName(pc) == TOP_KILL_NAME_B then
				local itemCount = 0;
				if result == "Win" then
					itemCount = reward_win;
				else
					itemCount = reward_lose;
				end
				PVPMineMVPLog(pc, teamName, "TopKiller", "misc_pvp_mine2", itemCount)
			end

			--POINT MVP
			if GetTeamName(pc) == TOP_POINT_NAME_A or GetTeamName(pc) == TOP_POINT_NAME_B then
				local itemCount = 0;
				if result == "Win" then
					itemCount = reward_win;
				else
					itemCount = reward_lose;
				end
				PVPMineMVPLog(pc, teamName, "TopPoint", "misc_pvp_mine2", itemCount)		
			end

            RemoveBuff(pc, 'PVP_MINE_BUFF1')
            RemoveBuff(pc, 'PVP_MINE_BUFF2')
        end
    end
end

-- boss born
function PVP_MINE_MINIMAP(self)
    EnableMonMinimap(self, 1);
end

function PVP_MINE_MINIMAP_BOSS(self)
    SetColonyWarBoss(self, 2000105)
end

function PVP_MINE_RANDOM_MON(self)
    local list = {'PVP_mine_weaver','PVP_mine_Miners','PVP_mine_shtayim','PVP_mine_Gravegolem'}
    local rand = IMCRandom(1, #list)

    return list[rand]
end

function PVP_MINE_CREATE_TEAM1(self)
    SetMGameValue(self, "TEAM_A_DEAD", 0)
end

function PVP_MINE_CREATE_TEAM2(self)
    SetMGameValue(self, "TEAM_B_DEAD", 0)
end

function MON_BORN_PVP_MINE_BUFF3(self)
    AddBuff(self, self, 'PvP_Mine_Crossbow');
end

function SCR_BUFF_ENTER_PvP_Mine_Crossbow(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_PvP_Mine_Crossbow(self, buff, arg1, arg2, over)
end

-- dead script
function SCR_PVP_MINE_CRYSTAL(mon, killer)
    local pc = ''
    local count = 10

    local x, y, z = GetPos(mon);
    if mon.ClassID == 2000108 then
        count = 30
    end

    if IS_PC(killer) == false then
        if GetOwner(killer) ~= nil then
            pc = GetOwner(killer)
        end
    else
        pc = GetKiller(mon);
    end

    if pc ~= '' then
        CreateOwnerlessItem(pc, "misc_pvp_mine1", count)
    end
end

function SCR_PVP_MINE_NONKILL(mon, killer)  
    local count = 1
    local pc = ''

    if IS_PC(killer) == true then
        if IsBuffApplied(killer, 'PVP_MINE_BUFF_ATK') == 'YES' then
            AddBuff(killer, killer, 'PVP_MINE_BUFF_ATK');
        else
            AddBuff(killer, killer, 'PVP_MINE_BUFF_ATK');
        end
        pc = killer
    else
        if GetOwner(killer) ~= nil then
            pc = GetOwner(killer)
        end
    end
    CreateOwnerlessItem(pc, "misc_pvp_mine1", count)
end

function SCR_PVP_MINE_BOSSKILL(mon, killer)  
    local killer = GetKiller(mon);
    local pc = ''
    
    if IS_PC(killer) == true then
        pc = killer
    else
        if GetOwner(killer) ~= nil then
            pc = GetOwner(killer)
        end
    end

    local zoneInst = GetZoneInstID(pc);
    local layer = GetLayer(pc);
    local list, cnt = GetLayerPCList(zoneInst, layer);
    local teamA = IsBuffApplied(pc, 'PVP_MINE_BUFF1')
    local teamB = IsBuffApplied(pc, 'PVP_MINE_BUFF2')
    local team_buff, team_point = 'None', 'None'

    if teamA == 'YES' then
        team_buff = 'PVP_MINE_BUFF1'
        boss_kill_msg = 'pvp_mine_result_1'
        team_point = 'TEAM_A_COUNT'
    else
        team_buff = 'PVP_MINE_BUFF2'
        boss_kill_msg = 'pvp_mine_result_2'
        team_point = 'TEAM_B_COUNT'
    end

    for i = 1, cnt do
        if list[i] ~= nil then
            local pclist = list[i];
            if IsBuffApplied(pclist, team_buff) == 'YES' then
                RunScript("SCR_PVP_MINE_BOSSKILL_RUN", pclist)
                local cur_point = GetMGameValue(pclist, team_point)
                SetMGameValue(pclist, team_point, cur_point + 50)
            end
        end
    end

    DO_MINEPVP_SCORE_UPDATE(pc)
    ShowBalloonText(pc, boss_kill_msg, 10);
end

function SCR_PVP_MINE_BOSSKILL_RUN(pc)
    local aObj = GetAccountObj(pc)
    local beforePoint = aObj.PVP_MINE_MAX;
    local afterPoint = aObj.PVP_MINE_MAX + 50;

    local tx = TxBegin(pc);
    TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', afterPoint);
    local ret = TxCommit(tx);

    if ret == "SUCCESS" then
        if IS_PC(pc) == true then
            PlayEffect(pc, "F_fireworks001", 1)
            PVPMinePointLog(pc, GET_PVP_MINE_TEAM_NAME(pc), 'Get', 'BossKill', afterPoint - beforePoint, afterPoint);

            ExecClientScp(pc, "MINEPVPMYSCOREBOARD_SET_MY_SCORE(0, "..aObj.PVP_MINE_MAX..")")
        end
    end

end

function SCR_PVP_MINE_DEAD(self)
    local killer = GetKiller(self);

    -- if killer == nil then
    --     return;
    -- end

    if IsBuffApplied(self, 'PVP_MINE_BUFF_NoDrop') == 'NO' then
        RunScript("SCR_PVP_MINE_DEAD_DROP", self, killer)
    end
    RunScript("SCR_PVP_MINE_DEAD_TIMER", self, timer)
    RunScript("SCR_PVP_MINE_KILL_COUNT", self, killer)

    if IS_PC(killer) == true then
        local killerIcon = GetPCIconStr(killer);
        local selfIcon = GetPCIconStr(self);
        local teamID = GetTeamID(killer);
        local killer_teamName = GetTeamName(killer)
        local dead_teamName = GetTeamName(self)
        local argString = string.format("%s#%s#%s#%s#%d", killerIcon, selfIcon, killer_teamName, dead_teamName, teamID);
        RunClientScriptToWorld(killer, "WORLDPVP_UI_MSG_KILL", argString);
        PVPMineKillLog(killer, self, GET_PVP_MINE_TEAM_NAME(killer));
    end

    if IS_PC(self) == true then
        PVPMineDeathLog(self, killer, GET_PVP_MINE_TEAM_NAME(self));
    end
end

function SCR_PVP_MINE_DEAD_TIMER(self, timer)
    local start_pos = {
        { -958, 1, -1003}, -- team A
        { 1100, 1,  1044} -- team B
    }

    local team = 1;
    local dead_sec = 5;
    local teamB = IsBuffApplied(self, 'PVP_MINE_BUFF2')

    if teamB == 'YES' then
        team = 2;
    end

    for i = 1, dead_sec do
        SetTitle(self, "{@st43_red}{s18}"..dead_sec)
        --SendSysMsg(self, "{@st43_red}{s18}"..dead_sec);
        dead_sec = dead_sec - 1
        sleep(1000)
    end

    SetTitle(self, "")
    SCR_SETPOS_FADEOUT(self, 'pvp_Mine', start_pos[team][1], start_pos[team][2], start_pos[team][3])
    sleep(1000)
    ResetCoolDown(self, 1);
    RemoveAllDeBuffList(self);
    sleep(1000)
    ResurrectPc(self, "AGARIO", 0, 100);

    AddBuff(self, self, 'PVP_MINE_BUFF_NoDrop', 1, 0, 60000, 1);
end

function SCR_PVP_MINE_DEAD_DROP(self, killer)
    sleep(500)
        
    local itemCount = GetInvItemCount(self, "misc_pvp_mine1"); 
    if itemCount > 2 then
        itemCount = math.floor(itemCount / 2)

        local tx = TxBegin(self);
        if IS_PC(killer) == true then
    	    TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_DEATH_PC');
        else
            TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_DEATH_MON');
        end
    	local ret = TxCommit(tx);
        if ret == "SUCCESS" then
            if killer ~= nil then
                if IS_PC(killer) == true then
                    local killer_item = GetInvItemCount(killer, "misc_pvp_mine1");

                    if killer_item + itemCount > 100 then
                        itemCount = 100 - killer_item
                    end

                    local msg_getItem = 0;

                    if IsBuffApplied(killer, 'PVP_MINE_BUFF_NoDrop') == 'YES' then
                        RemoveBuff(killer, 'PVP_MINE_BUFF_NoDrop');
                    end
                    
                    local tx = TxBegin(killer);
                    if itemCount > 0 then
                        TxGiveItem(tx, 'misc_pvp_mine1', itemCount, "PVP_MINE_KILL_PC");
                        msg_getItem = 1
                    end
                    local ret = TxCommit(tx);

                    if msg_getItem == 1 then
                        PlayEffect(killer, "F_fireworks001", 1)
                        Chat(killer, ScpArgMsg("pvp_mine_get_crystal", "COUNT", itemCount))
                    end
                end
            end
        end
    end
end

function SCR_PVP_MINE_KILL_COUNT(self, killer)
    if IS_PC(killer) == true then
        local aObj = GetAccountObj(killer)
        local tx = TxBegin(killer);
        TxSetIESProp(tx, aObj, 'PVP_MINE_Kill', aObj.PVP_MINE_Kill + 1);
        local ret = TxCommit(tx);

        if ret == 'SUCCESS' then
            ExecClientScp(killer, "MINEPVPMYSCOREBOARD_SET_MY_SCORE(1, "..aObj.PVP_MINE_Kill..")")
        end
    end
end

function SCR_PVP_MINE_TEAM1(self, killer)
    local zoneObj = GetLayerObject(killer);
    local TEAM_A_COUNT = GetMGameValue(killer, "TEAM_A_COUNT")
    local take_crystal_count = math.floor(TEAM_A_COUNT * 0.2)
    local give_crystal_count = 0;
    local killer_team = 'PVP_MINE_BUFF2'
    local killer_team_count = 0;
    local cmd = GetMGameCmd(killer)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    if take_crystal_count <= 0 then
        take_crystal_count = 1
    end

    SetExProp(zoneObj, "PVP_MINE_TEAM_A_COUNT", TEAM_A_COUNT - take_crystal_count);

    if TEAM_A_COUNT <= 0 then
        SetMGameValue(killer, "TEAM_A_COUNT", 0)
    else
        SetMGameValue(killer, "TEAM_A_COUNT", TEAM_A_COUNT - take_crystal_count)
    end
    
    for i = 1, cnt do
        if IsBuffApplied(list[i], killer_team) == 'YES' then
            killer_team_count = killer_team_count + 1
        end
    end

    give_crystal_count = math.floor(take_crystal_count / killer_team_count)

    if give_crystal_count <= 0 then
       give_crystal_count = 1 
    end

    for j = 1, cnt do
        if list[j] ~= nil then
            if IsBuffApplied(list[j], killer_team) == 'YES' then
                RunScript('SCR_PVP_MINE_PLUNDER_RUN', list[j], give_crystal_count)
            end
        end
    end

    RunScript('SCR_PVP_MINE_PLUNDER_ALARAM_RUN', killer, take_crystal_count, 1)
    SetMGameValue(killer, "TEAM_A_DEAD", 1)
end

function SCR_PVP_MINE_TEAM2(self, killer)
    local zoneObj = GetLayerObject(killer);
    local TEAM_B_COUNT = GetMGameValue(killer, "TEAM_B_COUNT")
    local take_crystal_count = math.floor(TEAM_B_COUNT * 0.2)
    local give_crystal_count = 0;
    local killer_team = 'PVP_MINE_BUFF1'
    local killer_team_count = 0;
    local cmd = GetMGameCmd(killer)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    SetMGameValue(killer, "TEAM_B_COUNT", TEAM_B_COUNT - take_crystal_count)

    for i = 1, cnt do
        if IsBuffApplied(list[i], killer_team) == 'YES' then
            killer_team_count = killer_team_count + 1
        end
    end

    give_crystal_count = math.floor(take_crystal_count / killer_team_count)

    if give_crystal_count <= 0 then
       give_crystal_count = 1 
    end

    for j = 1, cnt do
        if list[j] ~= nil then
            if IsBuffApplied(list[j], killer_team) == 'YES' then
                if IsBuffApplied(list[j], killer_team) == 'YES' then
                    RunScript('SCR_PVP_MINE_PLUNDER_RUN', list[j], give_crystal_count)
                end
            end
        end
    end

    RunScript('SCR_PVP_MINE_PLUNDER_ALARAM_RUN', killer, take_crystal_count, 2)
    SetMGameValue(killer, "TEAM_B_DEAD", 1)
end

function SCR_PVP_MINE_PLUNDER_RUN(pc, give_crystal_count)
    local pc_item = GetInvItemCount(pc, "misc_pvp_mine1");

    if pc_item + give_crystal_count > 100 then
        give_crystal_count = 100 - pc_item
    end
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'misc_pvp_mine1', give_crystal_count, "PVP_MINE_KILL_NPC");
    local ret = TxCommit(tx);
    if ret == "SUCCESS" then
        PlayEffect(pc, "F_buff_basic025_white_line", 1)
    end
end

function SCR_PVP_MINE_PLUNDER_ALARAM_RUN(pc, take_crystal_count, team)
    if take_crystal_count <= 1 then
        return;
    end

    if team == 1 then
        AddoOnMsgToZone(pc, "NOTICE_Dm_!", ScpArgMsg("pvp_mine_plunder_1", "POINT", take_crystal_count), 5)
    elseif team == 2 then
        AddoOnMsgToZone(pc, "NOTICE_Dm_!", ScpArgMsg("pvp_mine_plunder_2", "POINT", take_crystal_count), 5)
    end

    DO_MINEPVP_SCORE_UPDATE(pc)
end

-- exchange npc
function SCR_EXCHANGE_PVP_MINE_DIALOG(self,pc)
    local itemCount = GetInvItemCount(pc, 'misc_pvp_mine1')
    local point_list = {
        {100, 1.5},
        { 50, 1.2},
        {  1,   1}
    }
    local point, result = 0, 0
    local aObj = GetAccountObj(pc)
    local _team = {
        {'PVP_MINE_BUFF1', 'PVP_mine_Schwarzereiter'},
        {'PVP_MINE_BUFF2', 'PVP_mine_Doppelsoldner'}
    }
    local team_result = 0;

    for j = 1, #_team do
        if IsBuffApplied(pc, _team[j][1]) == 'YES' and self.ClassName == _team[j][2] then
            team_result = 1
            break;
        end
    end
    
    if team_result == 0 then
        Chat(self, ScpArgMsg('pvp_mine_team2_exchange_team'))
        return;
    elseif itemCount <= 0 then
        return;
    end

    for i = 1, #point_list do
        if itemCount >= point_list[i][1] then
            point = itemCount * point_list[i][2]
            point = math.floor(point)
            break;
        end
    end

    if point <= 0 then
        point = 1;
    end
    
    result = DOTIMEACTION_R(pc, ScpArgMsg("pvp_mine_exchange"), 'TALK', 1)

    if result ~= 1 then
        return;
    end

    local zoneObj = GetLayerObject(pc);
    local TEAM_A_COUNT = GetMGameValue(pc, "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(pc, "TEAM_B_COUNT")
    local beforePoint = aObj.PVP_MINE_MAX;
    local afterPoint = aObj.PVP_MINE_MAX + point;
    local tx = TxBegin(pc)
    TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', afterPoint); 
    TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_STONE');
    local ret = TxCommit(tx)

    if ret == 'SUCCESS' then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
            SetMGameValue(pc, "TEAM_A_COUNT", TEAM_A_COUNT + point)
        elseif IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
            SetMGameValue(pc, "TEAM_B_COUNT", TEAM_B_COUNT + point)
        end

        Chat(pc, ScpArgMsg("pvp_mine_getitem_dlg", "POINT", point));
        PlayEffect(pc, "F_buff_basic025_white_line", 1)

        DO_MINEPVP_SCORE_UPDATE(pc)
        ExecClientScp(pc, "MINEPVPMYSCOREBOARD_SET_MY_SCORE(0, "..aObj.PVP_MINE_MAX..")")
        PVPMinePointLog(pc, GET_PVP_MINE_TEAM_NAME(pc), 'Get', 'TradeCrystal', afterPoint - beforePoint, afterPoint, itemCount);
        return
    end


end

function DO_MINEPVP_SCORE_UPDATE(pc)
    local cmd = GetMGameCmd(pc)
    local teamA_member, teamB_member = COUNT_EACH_TEAM_MEMBER(cmd)
    local teamA_point = GetMGameValue(pc, "TEAM_A_COUNT")
    local teamB_point = GetMGameValue(pc, "TEAM_B_COUNT")
    local param = teamA_member .. "," .. teamB_member .. ", " .. teamA_point .. ", " .. teamB_point

    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    for i = 1 , cnt do
        local pc = list[i];
        ExecClientScp(pc, "MINEPVP_SCORE_UPDATE(" .. param .. ")")
    end
end


function COUNT_EACH_TEAM_MEMBER(cmd)
 --   local cmd = GetMGameCmd(pc)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local teamA, teamB = 0, 0;
    local team_buff = 'PVP_MINE_BUFF1'
    for i = 1, cnt do
        if IsBuffApplied(list[i], 'PVP_MINE_BUFF1') == 'YES' then
            teamA = teamA + 1
        elseif IsBuffApplied(list[i], 'PVP_MINE_BUFF2') == 'YES' then
            teamB = teamB + 1
        end
    end

    return teamA, teamB
end

-- safe zone A
function SCR_PVP_MINE_SAFEZONE_A_TS_BORN_ENTER(self)
    local range = 600;
    local height = 2;
    AttachEffect(self, 'F_pattern017_green', (range*0.065), 'BOT', 0, height, 0, 1)
end

function SCR_PVP_MINE_SAFEZONE_A_TS_BORN_UPDATE(self)
    local list, cnt = SelectObject(self, 150, "PC");

    for i = 1, cnt do
        if IS_PC(list[i]) == true then
            if IsBuffApplied(list[i], 'PVP_MINE_BUFF1') == 'YES' and IsBuffApplied(list[i], 'Safe') == 'NO' then
                AddBuff(list[i], list[i], 'Safe', 1, 0, 10000, 1);
            end
        elseif list[i].Faction == 'Pet' then
            RemoveBuff(list[i], 'Pet_Dead')
        end
    end
end

function SCR_PVP_MINE_SAFEZONE_A_TS_BORN_LEAVE(self)
end

function SCR_PVP_MINE_SAFEZONE_A_TS_DEAD_ENTER(self)
end

function SCR_PVP_MINE_SAFEZONE_A_TS_DEAD_UPDATE(self)
end

function SCR_PVP_MINE_SAFEZONE_A_TS_DEAD_LEAVE(self)
end

-- safe zone B
function SCR_PVP_MINE_SAFEZONE_B_TS_BORN_ENTER(self)
    local range = 600;
    local height = 2;
    AttachEffect(self, 'F_pattern017_green', (range*0.065), 'BOT', 0, height, 0, 1)
end

function SCR_PVP_MINE_SAFEZONE_B_TS_BORN_UPDATE(self)
    local list, cnt = SelectObject(self, 150, "PC");

    for i = 1, cnt do
        if IS_PC(list[i]) == true then
            if IsBuffApplied(list[i], 'PVP_MINE_BUFF2') == 'YES' and IsBuffApplied(list[i], 'Safe') == 'NO' then
                AddBuff(list[i], list[i], 'Safe', 1, 0, 10000, 1);
            end
        elseif list[i].Faction == 'Pet' then
            RemoveBuff(list[i], 'Pet_Dead')
        end
    end
end

function SCR_PVP_MINE_SAFEZONE_B_TS_BORN_LEAVE(self)
end

function SCR_PVP_MINE_SAFEZONE_B_TS_DEAD_ENTER(self)
end

function SCR_PVP_MINE_SAFEZONE_B_TS_DEAD_UPDATE(self)
end

function SCR_PVP_MINE_SAFEZONE_B_TS_DEAD_LEAVE(self)
end

-- PVP_MINE_EXCHANGE_A
function SCR_PVP_MINE_EXCHANGE_A_TS_BORN_ENTER(self)
    self.NumArg1 = 70
end

function SCR_PVP_MINE_EXCHANGE_A_TS_BORN_UPDATE(self)
    local mgame = IsPlayingMGame(self, "PVP_MINE")
    local _normal_A = GetScpObjectList(self, 'PVP_MINE_EXCHANGE_A')
    local currentStage = GetMGameValue(self, 'currentStage')

    if mgame == 1 and currentStage == 1 then
    if #_normal_A <= 0 and self.NumArg1 >= 70 then
        local iesObj = CreateGCIES('Monster', 'PVP_mine_Schwarzereiter');
        iesObj.Lv = 360;
        local x, y, z = GetPos(self)
            local mon = CreateMonster( self, iesObj, -941, 0, -954, 0, 0);

        if mon ~= nil then
            self.NumArg1 = 0
            AddScpObjectList(self, 'PVP_MINE_EXCHANGE_A', mon)
        end
    elseif #_normal_A <= 0 then
        self.NumArg1 = self.NumArg1 + 1
    elseif #_normal_A >= 2 then
        for i = 2, #_normal_A do
            Kill(_normal_A[i])
        end
    end
    else
        if #_normal_A >= 1 then
        for i = 1, #_normal_A do
            Kill(_normal_A[i])
        end
        self.NumArg1 = 70
        end
    end
end

function SCR_PVP_MINE_EXCHANGE_A_TS_BORN_LEAVE(self)
end

function SCR_PVP_MINE_EXCHANGE_A_TS_DEAD_ENTER(self)
end

function SCR_PVP_MINE_EXCHANGE_A_TS_DEAD_UPDATE(self)
end

function SCR_PVP_MINE_EXCHANGE_A_TS_DEAD_LEAVE(self)
end

-- PVP_MINE_EXCHANGE_B
function SCR_PVP_MINE_EXCHANGE_B_TS_BORN_ENTER(self)
    self.NumArg1 = 70
end

function SCR_PVP_MINE_EXCHANGE_B_TS_BORN_UPDATE(self)
    local mgame = IsPlayingMGame(self, "PVP_MINE")
    local _normal_B = GetScpObjectList(self, 'PVP_MINE_EXCHANGE_B')
    local currentStage = GetMGameValue(self, 'currentStage')

    if mgame == 1 and currentStage == 1 then
    if #_normal_B <= 0 and self.NumArg1 >= 70 then
        local iesObj = CreateGCIES('Monster', 'PVP_mine_Doppelsoldner');
        iesObj.Lv = 360;
        local x, y, z = GetPos(self)
            local mon = CreateMonster( self, iesObj, 1052, 0, 1025, 0, 0);

        if mon ~= nil then
            self.NumArg1 = 0
            AddScpObjectList(self, 'PVP_MINE_EXCHANGE_B', mon)
        end
    elseif #_normal_B <= 0 then
        self.NumArg1 = self.NumArg1 + 1
    elseif #_normal_B >= 2 then
        for i = 2, #_normal_B do
            Kill(_normal_B[i])
        end
    end
    else
        if #_normal_B >= 1 then
        for i = 1, #_normal_B do
            Kill(_normal_B[i])
        end
        self.NumArg1 = 70
        end
    end
end

function SCR_PVP_MINE_EXCHANGE_B_TS_BORN_LEAVE(self)
end

function SCR_PVP_MINE_EXCHANGE_B_TS_DEAD_ENTER(self)
end

function SCR_PVP_MINE_EXCHANGE_B_TS_DEAD_UPDATE(self)
end

function SCR_PVP_MINE_EXCHANGE_B_TS_DEAD_LEAVE(self)
end

-- alaram
function SCR_PVP_MINE_TIMER(cmd, curStage, eventInst, obj)
    -- score
    local worldInstID = cmd:GetZoneInstID();
    local zoneObj = GetLayerObject(worldInstID, cmd:GetLayer());

    -- max
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local TEAM_A_COUNT = GetMGameValue(list[1], "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(list[1], "TEAM_B_COUNT")

  --  cmd:SetUserValue(key, sec);
    cmd:SetUserValue("ToEndBattle_START_Mine", imcTime.GetAppTime());
    cmd:SetUserValue("currentStage", 1);

    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    for i = 1 , cnt do
        local pc = list[i];
        ExecClientScp(pc, "MINEPVP_TIMER_START(" .. imcTime.GetAppTime() .. ")")
    end
end

-- team check
function SCR_PVP_MINE_TEAM_CHECK(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    if cnt > 0 then
        for i = 1, cnt do
            if IsBuffApplied(list[i], 'PVP_MINE_BUFF1') == 'NO' and IsBuffApplied(list[i], 'PVP_MINE_BUFF2') == 'NO' then
                SCR_PVP_MINE_TIMEOUT_RUN(list[i])
            end
        end
    end
end

-- sound
function SCR_PVP_MINE_SOUND_10S(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    for i = 1, cnt do
        RunScript('SCR_PVP_MINE_SOUND_10S_RUN', list[i], cnt)
    end
end

function SCR_PVP_MINE_SOUND_10S_RUN(pc, cnt)
    for countdownSec = 10, 1, -1 do
        for i = 1, cnt do
            if GetServerNation() == 'KOR' then
                PlaySoundLocal(pc, 'countdown_'..countdownSec)
            else
                PlaySoundLocal(pc, 'S1_countdown_'..countdownSec)
            end
        end
        sleep(1000)
    end
end

function SCR_PVP_MINE_SOUND_START(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    for i = 1, cnt do
        if GetServerNation()  == 'KOR' then
            PlaySoundLocal(list[i], 'battle_start')
        else
            PlaySoundLocal(list[i], 'S1_battle_start')
        end
    end
end

function SCR_PVP_MINE_SOUND_BOSS(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    for i = 1, cnt do
        if GetServerNation() == 'KOR' then
            PlaySoundLocal(list[i], "battle_bossmonster_appear")
        else
            PlaySoundLocal(list[i], "S1_battle_bossmonster_appear")
        end
    end
end

-- result UI
function SCR_PVP_MINE_END_UI_OPEN(pc)
    local aObj = GetAccountObj(pc)
    local TEAM_A_COUNT = GetMGameValue(pc, "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(pc, "TEAM_B_COUNT")

    local MVP_COUNT_KILL_A = GetMGameValue(pc, "MVP_COUNT_KILL_A")
    local MVP_NAME_KILL_A = GetMGameValue_Str(pc, "MVP_NAME_KILL_A")
    local MVP_COUNT_KILL_B = GetMGameValue(pc, "MVP_COUNT_KILL_B")
    local MVP_NAME_KILL_B = GetMGameValue_Str(pc, "MVP_NAME_KILL_B")
    local MVP_COUNT_MINE_A = GetMGameValue(pc, "MVP_COUNT_MINE_A")
    local MVP_NAME_MINE_A = GetMGameValue_Str(pc, "MVP_NAME_MINE_A")
    local MVP_COUNT_MINE_B = GetMGameValue(pc, "MVP_COUNT_MINE_B")
    local MVP_NAME_MINE_B = GetMGameValue_Str(pc, "MVP_NAME_MINE_B")

    if TEAM_A_COUNT > TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(1, 1, "'..MVP_COUNT_KILL_A..'", "'..MVP_NAME_KILL_A..'", "'..MVP_COUNT_MINE_A..'", "'..MVP_NAME_MINE_A..'")') -- win
        else
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0, 2, "'..MVP_COUNT_KILL_B..'", "'..MVP_NAME_KILL_B..'", "'..MVP_COUNT_MINE_B..'", "'..MVP_NAME_MINE_B..'")') -- lose
        end
    elseif TEAM_A_COUNT < TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
           ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(1, 2, "'..MVP_COUNT_KILL_B..'", "'..MVP_NAME_KILL_B..'", "'..MVP_COUNT_MINE_B..'", "'..MVP_NAME_MINE_B..'")')
        else
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0, 1, "'..MVP_COUNT_KILL_A..'", "'..MVP_NAME_KILL_A..'", "'..MVP_COUNT_MINE_A..'", "'..MVP_NAME_MINE_A..'")')
        end
    else
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0, 1, "'..MVP_COUNT_KILL_A..'", "'..MVP_NAME_KILL_A..'", "'..MVP_COUNT_MINE_A..'", "'..MVP_NAME_MINE_A..'")')
        else
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0, 2, "'..MVP_COUNT_KILL_B..'", "'..MVP_NAME_KILL_B..'", "'..MVP_COUNT_MINE_B..'", "'..MVP_NAME_MINE_B..'")')
        end
    end
end

function GET_PVP_MINE_TEAM_NAME(pc)
    if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
        return 'A';
    elseif IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
        return 'B';
    end
    return 'Error';
end

-- Move
function SCR_PVP_MINE_CITY_DIALOG(self,pc)
    local sel = ShowSelDlg(pc,0, 'PVP_MINE_DLG8', ScpArgMsg("Yes"), ScpArgMsg("No"))
    if sel == 1 then
        SCR_PVP_MINE_TIMEOUT_RUN(pc)
    end
end