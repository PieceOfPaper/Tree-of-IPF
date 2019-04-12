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

    local globalTiem = {
       {1001, 21},
       {1003, 15},
       {1004, 9},
       {1005, 20}
    }
   
    for i = 1, #globalTiem do
        if GetServerGroupID() == globalTiem[i][1] and hour == globalTiem[i][2] then
            if (min >= 0 and min <= 5) or (min >= 20 and min <= 25) then
                if pc.Lv < 350 then
                ShowOkDlg(pc, 'EV_PRISON_DESC2', 1)
                return false;
            elseif partyObj ~= nil then
                SendSysMsg(pc, 'CannotUseInParty');
                return false;
            else
                return true;
            end
        elseif (min >= 6 and min <= 15) or (min >= 26 and min <= 35) then
            ShowOkDlg(pc, 'PVP_MINE_DLG5', 1)
            return false;
            end
        end
    end

   return false;
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

        local globalTiem = {
            {1001, 21},
            {1003, 15},
            {1004, 9},
            {1005, 20}
        }

        for i = 1, #globalTiem do
            if GetServerGroupID() == globalTiem[i][1] and hour == globalTiem[i][2] then
                if (min >= 0 and min <= 5) or (min >= 20 and min <= 25) then
                    RunMGame(self, 'PVP_MINE')
                    return
                end
            end
        end

        if cnt > 0 then -- player zonemove
            for a = 1, cnt do
                RunScript('SCR_PVP_MINE_TIMEOUT_RUN', list[a])
            end
        end
   end
end

function SCR_PVP_MINE_START_ALARAM_TS_BORN_UPDATE(self)
    local channel = GetChannelID(self)

    if channel == 1 then
        local now_time = os.date('*t')
        local hour = now_time['hour']
        local min = now_time['min']
        local sec = now_time['sec']

        local globalTiem = {
            {1001, 20},
            {1003, 14},
            {1004, 8},
            {1005, 19}
        }

        for i = 1, #globalTiem do
            if GetServerGroupID() == globalTiem[i][1] and hour == globalTiem[i][2] then
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

                if min == 17 and self.NumArg1 == 0 then
                    BroadcastToAllServerPC(1, ScpArgMsg("pvp_mine_2nd_before_3m"), "");
                    self.NumArg1 = 1
                elseif min == 19 and self.NumArg1 == 1 and sec == 58 then
                    BroadcastToAllServerPC(1, ScpArgMsg("pvp_mine_2nd_before_start"), "");
                    self.NumArg1 = 0
                end
            end
        end
    end
end