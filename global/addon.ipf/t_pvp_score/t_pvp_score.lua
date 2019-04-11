

function T_PVP_SCORE_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg("LAYER_PC_LIST_UPDATE", "T_PVP_LAYER_PC_LIST");

end

function T_PVP_SET_TEAM_ICON(frame, textCtrl, teamID)
	local teamInfo = session.mission.GetTeam(teamID);
	if teamInfo ~= nil then
		local teamList = teamInfo:GetPCList();
		local cnt = teamList:size();
		local ret = "";
		for i = 0 , cnt - 1 do
			local pcInfo = teamList:at(i);
			local iconName = ui.CaptureModelHeadImage_IconInfo(pcInfo:GetIcon());
			ret = ret .. string.format("{a @#TNMT_VIEW %d %d}{img %s 52 52}{/}", pcInfo:GetHandle(), 0,iconName);
		end

		textCtrl:SetText(ret);
	end
end

function T_PVP_LAYER_PC_LIST(frame)
	
	local icon_team_1 = frame:GetChild("icon_team_1");
	T_PVP_SET_TEAM_ICON(frame, icon_team_1, 1);
	local icon_team_2 = frame:GetChild("icon_team_2");
	T_PVP_SET_TEAM_ICON(frame, icon_team_2, 2);	

end

function T_PVP_SCORE_FIRST_OPEN(frame)
	frame:RunUpdateScript("T_PVP_UPDATE_GAUGE");
end

function T_PVP_UPDATE_GAUGE(frame)

	local mgameInfo = session.mission.GetMGameInfo();
	local startAppTime  = mgameInfo:GetUserValue("Battle_START");
	local t_time = frame:GetChild("t_time");
	if startAppTime > 0 then
		local battle = mgameInfo:GetUserValue("Battle");
		local curTime = GetServerAppTime();
		local elapsed = curTime - startAppTime;
		local remain = battle - elapsed;
		if remain > battle then
			t_time:ShowWindow(0);
		else
			local remainStr = GET_MS_TXT(remain);
			t_time:SetTextByKey("value", remainStr);
			t_time:ShowWindow(1);
		end

	else
		t_time:ShowWindow(0);
	end

	local g_team_1 = GET_CHILD(frame, "g_team_1", "ui::CGauge");
	local g_team_2 = GET_CHILD(frame, "g_team_2", "ui::CGauge");
	_T_PVP_UPDATE_GAUGE(g_team_1, 1);
	_T_PVP_UPDATE_GAUGE(g_team_2, 2);

	
	return 1;
end

function _T_PVP_UPDATE_GAUGE(gauge, teamID)
	
	local teamInfo = session.mission.GetTeam(teamID);
	if teamInfo == nil then
		gauge:SetPoint(1, 1);
		return;
	end

	local maxPoint = 0;
	local totalPoint = 0;
	if teamInfo ~= nil then
		local teamList = teamInfo:GetPCList();
		local cnt = teamList:size();
		for i = 0 , cnt - 1 do
			local pcInfo = teamList:at(i);
			local percent = pcInfo.hp * 100 / pcInfo.mhp;
			totalPoint = totalPoint + percent;
			maxPoint = maxPoint + 100;
		end
	end

	if maxPoint == 0 then
		gauge:SetPoint(1, 1);
		return;
	end

	gauge:SetMaxPoint(maxPoint);
	local cur = gauge:GetDestPoint();
	if cur ~= totalPoint then
		gauge:SetPointWithTime(totalPoint, 0.25, 0.5);
		if cur > totalPoint then
			UI_PLAYFORCE(gauge, "gauge_damage");
		end
	end
	
end

