-- enter npc
function SCR_PVP_MINE_TEAM_NPC_DIALOG(self, pc)
    local result = SCR_PVP_MINE_ENTER_TIME_DIALOG(self, pc)

    if result == false then
        ShowOkDlg(pc, 'PVP_MINE_DLG1', 1)
        --ExecClientScp(pc, "MINE_OPEN_POINT_SHOP()");
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

    local select1 = ShowSelDlg(pc, 0, 'PVP_MINE_DLG4', ScpArgMsg("Yes"),ScpArgMsg("No"))
    if select1 == 1 then
        SCR_PVP_MINE_ENTER_NPC_DIALOG_CHANNEL_INIT(pc)
    end
end

-- enter time and join
function SCR_PVP_MINE_ENTER_TIME_DIALOG(self, pc)
    local now_time = os.date('*t')
    local hour = now_time['hour']
    local min = now_time['min']
    local dunTime = {
        10, 14, 18, 22
    }
    local aObj = GetAccountObj(pc)
    local partyObj = GetPartyObj(pc)

    if min > 10 then
        ShowOkDlg(pc, 'PVP_MINE_DLG5', 1)
        return false;
    elseif pc.Lv < 350 then
        ShowOkDlg(pc, 'EV_PRISON_DESC2', 1)
        return false;
    elseif partyObj ~= nil then
        SendSysMsg(pc, 'CannotUseInParty');
        return false;
    end

    for i = 1, #dunTime do
        if dunTime[i] == hour and min <= 10 then
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
    if aObj.PVP_MINE_RESET + 2 <= current_hour then -- reset
        local itemCount = GetInvItemCount(pc, "misc_pvp_mine1");
        TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', 0);
        TxSetIESProp(tx, aObj, 'PVP_MINE_RESET', current_hour);
        
        if itemCount > 0 then
            TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_STONE');
        end
    end
    local ret = TxCommit(tx)

    if ret == "SUCCESS" then
        MoveZone(pc, 'pvp_Mine', 0, 0, 0, nil, 1)
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

    ExecClientScp(pc, "SHOW_MINEPVP_SCOREBOARD()")
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
    --ExecClientScp(pc, "SHOW_MINEPVP_SCOREBOARD()")
    DO_MINEPVP_SCORE_UPDATE(pc)
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

-- safe buff
function SCR_BUFF_ENTER_PVP_MINE_Safe(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 5
end

function SCR_BUFF_LEAVE_PVP_MINE_Safe(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 5
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
        local dunTime = {
            10, 14, 18, 22
        }

        for i = 1, #dunTime do -- mgame start
            if dunTime[i] == hour and (min >= 0 and min <= 10 ) then
                RunMGame(self, 'PVP_MINE')
                break;
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
        print(list[i].Name, cnt)
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

    for i = 1, cnt do
        RunScript('SCR_PVP_MINE_REWARD_RUN', list[i])
    end
end

function SCR_PVP_MINE_REWARD_RUN(pc)
    local aObj = GetAccountObj(pc)
    local zoneObj = GetLayerObject(pc);
    local TEAM_A_COUNT = GetMGameValue(pc, "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(pc, "TEAM_B_COUNT")
    local result = 'None'
    local reward_win = 500 + aObj.PVP_MINE_MAX
    local reward_lose = 100 + aObj.PVP_MINE_MAX
    local itemCount = GetInvItemCount(pc, "misc_pvp_mine1"); 

    local tx = TxBegin(pc)
    TxEnableInIntegrate(tx);
    TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', 0);
    
    if itemCount > 0 then
        TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_END');
    end

    if TEAM_A_COUNT > TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
            TxGiveItem(tx, 'misc_pvp_mine2', reward_win, "PVP_MINE_POINT");
            result = 'Win'
        else
            TxGiveItem(tx, 'misc_pvp_mine2', reward_lose, "PVP_MINE_POINT");
            result = 'Lose'
        end
    elseif TEAM_A_COUNT < TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
            TxGiveItem(tx, 'misc_pvp_mine2', reward_win, "PVP_MINE_POINT");
            result = 'Win'
        else
            TxGiveItem(tx, 'misc_pvp_mine2', reward_lose, "PVP_MINE_POINT");
            result = 'Lose'
        end
    else
        TxGiveItem(tx, 'misc_pvp_mine2', reward_lose, "PVP_MINE_POINT");
        result = 'Draw'
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
        SCR_SETPOS_FADEOUT(pc, 'pvp_Mine', start_pos[team][1], start_pos[team][2], start_pos[team][3])

        RemoveBuff(pc, 'PVP_MINE_BUFF1')
        RemoveBuff(pc, 'PVP_MINE_BUFF2')
        PlayEffect(pc, "F_fireworks001", 1)

        local teamName = GetTeamName(pc)
        IMCLOG_CONTENT_SPACING("PVP_MINE_REWARD", teamName, pc.Name, result, team)
    end
end

-- boss born
function PVP_MINE_MINIMAP(self)
    EnableMonMinimap(self, 1);
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
    ShowBalloonText(pc, boss_kill_msg, 10)
end

function SCR_PVP_MINE_BOSSKILL_RUN(pc)

    local aObj = GetAccountObj(pc)

    if aObj.PVP_MINE_MAX < 500 then
        local tx = TxBegin(pc);
        if aObj.PVP_MINE_MAX + 50 > 500 then
            TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', 500);
        else
            TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', aObj.PVP_MINE_MAX + 50);
        end
        local ret = TxCommit(tx);

        if ret == "SUCCESS" then
            if IS_PC(pc) == true then
                PlayEffect(pc, "F_fireworks001", 1)
            end
        end
    end
end

function SCR_PVP_MINE_DEAD(self)
    local killer = GetKiller(self);

    -- if killer == nil then
    --     return;
    -- end

    RunScript("SCR_PVP_MINE_DEAD_DROP", self, killer)
    RunScript("SCR_PVP_MINE_DEAD_TIMER", self, timer)

    if IS_PC(killer) == true then
        local killerIcon = GetPCIconStr(killer);
        local selfIcon = GetPCIconStr(self);
        local argString = string.format("%s#%s#%s#%s#%d", killerIcon, selfIcon, killer.Name, self.Name, GetTeamID(killer));
        RunClientScriptToWorld(killer, "WORLDPVP_UI_MSG_KILL", argString);
    end
end

function SCR_PVP_MINE_DEAD_TIMER(self, timer)
    local start_pos = {
        {-1355.3, 149.2, -1427.3}, -- team A
        { 1485.3, 149.2,  1461.3} -- team B
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
end

function SCR_PVP_MINE_DEAD_DROP(self, killer)
    sleep(500)
    local now_time = os.date('*t')
    local min = now_time['min']

    if min >= 31 then
        return;
    end
    
    local itemCount = GetInvItemCount(self, "misc_pvp_mine1"); 
    if itemCount > 2 then
        itemCount = math.floor(itemCount / 2)

        local tx = TxBegin(self);
    	TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_DEAD');
    	local ret = TxCommit(tx);
        if ret == "SUCCESS" then
            if killer ~= nil then
                if IS_PC(killer) == true then
                    local killer_item = GetInvItemCount(killer, "misc_pvp_mine1");

                    if killer_item + itemCount > 100 then
                        itemCount = 100 - killer_item
                    end

                    if itemCount <= 0 then
                        local tx = TxBegin(killer);
                        TxGiveItem(tx, 'misc_pvp_mine1', itemCount, "PVP_MINE_DEAD");
                        local ret = TxCommit(tx);
                        PlayEffect(killer, "F_fireworks001", 1)

                        Chat(killer, ScpArgMsg("pvp_mine_get_crystal", "COUNT", itemCount))
                    end
                end
            end
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
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'misc_pvp_mine1', give_crystal_count, "PVP_MINE_PLUNDER");
    local ret = TxCommit(tx);
    if ret == "SUCCESS" then
        PlayEffect(pc, "F_buff_basic025_white_line", 1)
    end
end

function SCR_PVP_MINE_PLUNDER_ALARAM_RUN(pc, take_crystal_count, team)
    if take_crystal_count == 0 then
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

    if GetRidingCompanion(pc) == nil then
        result = DOTIMEACTION_R(pc, ScpArgMsg("pvp_mine_exchange"), 'TALK', 1)
    else
        result = RIDING_ANIM_DOTIME_TEST(pc, ScpArgMsg("pvp_mine_exchange"), 'TALK_RIDE', 1)
    end

    if result ~= 1 then
        return;
    end

    local zoneObj = GetLayerObject(pc);
    local TEAM_A_COUNT = GetMGameValue(pc, "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(pc, "TEAM_B_COUNT")
    local tx = TxBegin(pc)
    if aObj.PVP_MINE_MAX < 500 then
        --TxAddIESProp(tx, aobj, "PVP_MINE_POINT", point, "PVP_MINE_POINT");
        if aObj.PVP_MINE_MAX  + point > 500 then
            TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', 500);
            point = 500 - aObj.PVP_MINE_MAX
        else
            TxSetIESProp(tx, aObj, 'PVP_MINE_MAX', aObj.PVP_MINE_MAX + point); 
        end
    end
    TxTakeItem(tx, 'misc_pvp_mine1', itemCount, 'PVP_MINE_STONE');
    local ret = TxCommit(tx)

    if ret == 'SUCCESS' then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
            --SetExProp(zoneObj, "PVP_MINE_TEAM_A_COUNT", TEAM_A_COUNT + point);
            SetMGameValue(pc, "TEAM_A_COUNT", TEAM_A_COUNT + point)
        elseif IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
            --SetExProp(zoneObj, "PVP_MINE_TEAM_B_COUNT", TEAM_B_COUNT + point);
            SetMGameValue(pc, "TEAM_B_COUNT", TEAM_B_COUNT + point)
        end

        Chat(pc, ScpArgMsg("pvp_mine_getitem_dlg", "POINT", point));
        PlayEffect(pc, "F_buff_basic025_white_line", 1)

        DO_MINEPVP_SCORE_UPDATE(pc)

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
            if IsBuffApplied(list[i], 'SoldierDead') == 'YES' then
                RemoveBuff(list[i], 'SoldierDead')
            end
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
    local _normal_A = GetScpObjectList(self, 'PVP_MINE_EXCHANGE_A')

    if #_normal_A <= 0 and self.NumArg1 >= 70 then
        local iesObj = CreateGCIES('Monster', 'PVP_mine_Schwarzereiter');
        iesObj.Lv = 360;
        local x, y, z = GetPos(self)
        local mon = CreateMonster( self, iesObj, x, y, z, 0, 0);

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
    local _normal_B = GetScpObjectList(self, 'PVP_MINE_EXCHANGE_B')

    if #_normal_B <= 0 and self.NumArg1 >= 70 then
        local iesObj = CreateGCIES('Monster', 'PVP_mine_Doppelsoldner');
        iesObj.Lv = 360;
        local x, y, z = GetPos(self)
        local mon = CreateMonster( self, iesObj, x, y, z, 0, 0);

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

        PlayBGM(list[i], 'm_teambattle')
    end
end

function SCR_PVP_MINE_SOUND_BOSS(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());

    for i = 1, cnt do
        if GetServerNation() == 'KOR' then --보스몬스터 등장 사운드 출력
            PlaySoundLocal(list[i], "battle_bossmonster_appear")
        else
            PlaySoundLocal(list[i], "S1_battle_bossmonster_appear")
        end
    end
end

-- result UI
function SCR_PVP_MINE_END_UI_OPEN(pc)
    local aObj = GetAccountObj(pc)
    local zoneObj = GetLayerObject(pc);
    local TEAM_A_COUNT = GetMGameValue(pc, "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(pc, "TEAM_B_COUNT")

    if TEAM_A_COUNT > TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(1)') -- win
        else
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0)') -- lose
        end
    elseif TEAM_A_COUNT < TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(1)')
        else
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0)')
        end
    else
        ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0)')
    end
end

function PVP_MINE_RESULT_OPEN(isWin)
    local frame = ui.GetFrame('pvp_mine_result');
    PVP_MINE_RESULT_INIT(frame, isWin, argStr);
    frame:ShowWindow(1);
end

function PVP_MINE_RESULT_INIT(frame, isWin)
    local WIN_EFFECT_NAME = frame:GetUserConfig('WIN_EFFECT_NAME');
    local LOSE_EFFECT_NAME = frame:GetUserConfig('LOSE_EFFECT_NAME');
    local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

    local winBox = GET_CHILD_RECURSIVELY(frame, 'winBox');
    local loseBox = GET_CHILD_RECURSIVELY(frame, 'loseBox');
    local drawBox = GET_CHILD_RECURSIVELY(frame, 'drawBox');

    local aObj = GetMyAccountObj();
    local getpoint = aObj.PVP_MINE_MAX;

    if isWin == 1 then
        getpoint = getpoint + 500
    else
        getpoint = getpoint + 100
    end

    local GetPoint_Desc = GET_CHILD_RECURSIVELY(frame, 'GetPoint_Desc');
    GetPoint_Desc:SetTextByKey("point", getpoint);

    if isWin == 1 then
        winBox:ShowWindow(1);
        loseBox:ShowWindow(0);
        drawBox:ShowWindow(0);

        if config.GetServiceNation() == 'GLOBAL' then
            imcSound.PlayMusicQueueLocal('colonywar_win')
        elseif config.GetServiceNation() == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_win_k')
        end
        winBox:PlayUIEffect(WIN_EFFECT_NAME, EFFECT_SCALE, 'COLONY_WIN');
    else
        winBox:ShowWindow(0);
        loseBox:ShowWindow(1);
        drawBox:ShowWindow(0);

        if config.GetServiceNation() == 'GLOBAL' then
            imcSound.PlayMusicQueueLocal('colonywar_lose')
        elseif config.GetServiceNation() == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_lose_k')
        end
        loseBox:PlayUIEffect(LOSE_EFFECT_NAME, EFFECT_SCALE, 'COLONY_LOSE');
    end
end

-- target UI
function SET_TARGETINFO_TO_MINE_POS()

	TARGET_INFO_OFFSET_Y = 20;
	TARGET_INFO_OFFSET_X = 1050;

	local targetBuff = ui.GetFrame("targetbuff");
	targetBuff:MoveFrame(1350, targetBuff:GetY());
    
	local channel = ui.GetFrame("channel");
	channel:ShowWindow(0);

	local mapAreaText = ui.GetFrame("mapareatext");
	mapAreaText:ShowWindow(0);

	local bugreport = ui.GetFrame("bugreport");
	bugreport:ShowWindow(0);

	local mapAreaText = ui.GetFrame("minimizedalarm");
	mapAreaText:ShowWindow(0);
end