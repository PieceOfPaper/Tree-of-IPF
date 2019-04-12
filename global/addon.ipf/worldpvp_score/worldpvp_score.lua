

function WORLDPVP_SCORE_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg("LAYER_PC_LIST_UPDATE", "WORLDPVP_SCORE_LAYER_PC_UPDATE");
	addon:RegisterOpenOnlyMsg("MGAME_VALUE_UPDATE", "WORLDPVP_SCORE_MGAME_VALUE_UPDATE");
	
end

function SET_TARGETINFO_TO_PVP_POS()

	TARGET_INFO_OFFSET_Y = 20;
	TARGET_INFO_OFFSET_X = 1350;

	local targetBuff = ui.GetFrame("targetbuff");
	targetBuff:MoveFrame(1400, targetBuff:GetY());

	local miniMapFrame = ui.GetFrame("minimap");
	miniMapFrame:ShowWindow(0);

	local channel = ui.GetFrame("channel");
	channel:ShowWindow(0);

	local mapAreaText = ui.GetFrame("mapareatext");
	mapAreaText:ShowWindow(0);

	local bugreport = ui.GetFrame("bugreport");
	bugreport:ShowWindow(0);

end

function WORLDPVP_SCORE_LAYER_PC_UPDATE(frame)
	
	local icon_team1 = frame:GetChild("icon_team1");
	WORLDPVP_SCORE_SET_TEAM_ICON(frame, icon_team1, 1, true);
	local icon_team2 = frame:GetChild("icon_team2");
	WORLDPVP_SCORE_SET_TEAM_ICON(frame, icon_team2, 2, false);

end

function WORLDPVP_SCORE_MGAME_VALUE_UPDATE(frame, msg, key, value)
	local scorePos = string.find(key, "_Score");
	if scorePos ~= nil then
		local teamID = string.sub(key, 5, 5);

		if value > 0 then
			for i = 1, value do
				local ctrlName = "scorepic_" .. teamID .. "_" .. i;
				local ctrl = frame:GetChild(ctrlName);
				if ctrl ~= nil then
					ctrl:ShowWindow(1);
				end
			end
		end
	end

end

function WORLDPVP_SCORE_SET_TEAM_ICON(frame, groupBox, teamID, fromRight)
	local teamInfo = session.mission.GetTeam(teamID);
	groupBox:RemoveAllChild();
	if teamInfo ~= nil then
		local teamList = teamInfo:GetPCList();
		local cnt = teamList:size();

		local horAlign;
		if fromRight == true then
			horAlign = ui.RIGHT;
		else
			horAlign = ui.LEFT;
		end

		local picWidth = 30;

		for i = 0 , cnt - 1 do
			local pcInfo = teamList:at(i);

			local leftMargin = 0;
			local rightMargin = 0;
			if fromRight == true then
				rightMargin = i * picWidth;
			else
				leftMargin = i * picWidth;
			end

			local pic = groupBox:CreateControl("picture", "MAN_PICTURE_" .. pcInfo:GetCID(), picWidth, 30, horAlign, ui.CENTER_VERT, leftMargin, 0, rightMargin, 0);
			AUTO_CAST(pic);
			pic:SetImage("house_change_man");

		end

	end
end

function WORLDPVP_SCORE_FIRST_OPEN(frame)
	frame:RunUpdateScript("WORLDPVP_SCORE_UPDATE_GAUGE");

	for i = 1 , 2 do
		for j = 1 , 2 do
			local ctrlName = "scorepic_" .. i .. "_" .. j;
			local ctrl = frame:GetChild(ctrlName);
			if ctrl ~= nil then
				ctrl:ShowWindow(0);
			end
		end
	end
end

function WORLDPVP_SCORE_UPDATE_GAUGE(frame)

	local mgameInfo = session.mission.GetMGameInfo();
	
	local g_team_1 = GET_CHILD(frame, "g_team_1", "ui::CGauge");
	local g_team_2 = GET_CHILD(frame, "g_team_2", "ui::CGauge");
	_T_PVP_UPDATE_GAUGE(g_team_1, 1);
	_T_PVP_UPDATE_GAUGE(g_team_2, 2);

	local icon_team1 = frame:GetChild("icon_team1");
	_WORLDPVP_SCORE_UPDATE_ICON_COLOR(icon_team1, 1);
	local icon_team2 = frame:GetChild("icon_team2");
	_WORLDPVP_SCORE_UPDATE_ICON_COLOR(icon_team2, 2);

		
	return 1;
end

function _WORLDPVP_SCORE_UPDATE_ICON_COLOR(groupBox, teamID)

	local teamInfo = session.mission.GetTeam(teamID);
	if teamInfo ~= nil then
		local teamList = teamInfo:GetPCList();
		local cnt = teamList:size();
		for i = 0 , cnt - 1 do
			local pcInfo = teamList:at(i);
			local percent = pcInfo.hp * 100 / pcInfo.mhp;
			local pic = groupBox:GetChild("MAN_PICTURE_" .. pcInfo:GetCID());
			if pic ~= nil then
				if percent == 0 then
					pic:SetColorTone("FF000000");
				elseif percent <= 40 then
					pic:SetColorTone("FFFF0000");
				else
					pic:SetColorTone("FFFFFFFF");
				end

			end
		end
	end

end

function PVP_BATTLE_START_C(actor)

	local mgameInfo = session.mission.GetMGameInfo();
	local startTime = mgameInfo:GetUserValue("Battle_START");
	local roundMaxTime = mgameInfo:GetUserValue("RoundMaxTime");
	local elapsedTime = GetServerAppTime() - startTime;
	local remainTime = roundMaxTime - elapsedTime;
	
	local frame = ui.GetFrame("worldpvp_score");
	local timer = GET_CHILD(frame, "timer");
	START_TIMER_CTRLSET_BY_SEC(timer, remainTime, roundMaxTime);
	

end


