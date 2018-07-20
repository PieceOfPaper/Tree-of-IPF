function MINEPVP_SCOREBOARD_ON_INIT(addon, frame)

end

function SHOW_MINEPVP_SCOREBOARD()
	ui.OpenFrame("minepvpscoreboard")
	local frame = ui.GetFrame("minepvpscoreboard")
	frame:ShowWindow(1)
end


function MINEPVP_SCORE_UPDATE(LeftTeamMember, RightTeamMember, LeftTeamPoint, RightTeamPoint)
	local frame = ui.GetFrame("minepvpscoreboard")
	if frame == nil then
		return
	end

	frame:ShowWindow(1)

	local leftTeamMember = GET_CHILD_RECURSIVELY(frame, "leftTeamMember")
	local rightTeamMember = GET_CHILD_RECURSIVELY(frame, "rightTeamMember")
	if leftTeamMember == nil or rightTeamMember == nil then
		return
	end

	if LeftTeamMember == nil then
		LeftTeamMember = 0
	end
	if RightTeamMember == nil then
		RightTeamMember = 0
	end
	leftTeamMember:SetTextByKey("curCount", LeftTeamMember)
	rightTeamMember:SetTextByKey("curCount", RightTeamMember)

	local totalPoint = LeftTeamPoint + RightTeamPoint
	if totalPoint == 0 then
		totalPoint = -1
	end
	local leftTeamPercent = LeftTeamPoint/totalPoint * 100
	local rightTeamPercent = RightTeamPoint/totalPoint * 100

	local score_left_point = GET_CHILD_RECURSIVELY(frame, "score_left_point")
	local score_right_point = GET_CHILD_RECURSIVELY(frame, "score_right_point")
	if score_left_point == nil or score_right_point == nil then
		return
	end
	score_left_point:SetTextByKey("per", LeftTeamPoint)
	score_right_point:SetTextByKey("per", RightTeamPoint)

	local score = GET_CHILD_RECURSIVELY(frame, "score")
	if score == nil then
		return
	end

	if totalPoint == -1 then
		score:SetPoint(1, 2)	
	else
		score:SetPoint(LeftTeamPoint, totalPoint)
	end

	local score_diff_point = GET_CHILD_RECURSIVELY(frame, "score_diff_point")
	if score_diff_point == nil then
		return
	end
	if LeftTeamPoint >= RightTeamPoint then
		score_diff_point:SetTextByKey("score", LeftTeamPoint - RightTeamPoint)
	else
		score_diff_point:SetTextByKey("score", RightTeamPoint - LeftTeamPoint)
	end

	local effectGbox = GET_CHILD_RECURSIVELY(frame, 'effectGbox');
	effectGbox:Move(LeftTeamPoint/totalPoint * score:GetWidth() - effectGbox:GetX() - effectGbox:GetWidth()/2, 0)

end

function MINEPVP_LBTN_UP(frame, msg, argStr, argNum)
 --   SET_CONFIG_HUD_OFFSET(frame);
end

function MINEPVP_TIMER_START(time)
	local mgameInfo = session.mission.GetMGameInfo();
--	local startTime = mgameInfo:GetUserValue("ToEndBattle_START");
	local startTime = 0
	if time ~= nil then
		startTime = time
	end
	
	local maxTime = mgameInfo:GetUserValue("ToEndBattle_Mine");
	local elapsedTime = GetServerAppTime() - startTime;
	local remainTime = maxTime - elapsedTime;
	
	local frame = ui.GetFrame("minepvpscoreboard");
	local timer = GET_CHILD_RECURSIVELY(frame, "timer");
	START_TIMER_CTRLSET_BY_SEC(timer, remainTime, maxTime);

	local effectGbox = GET_CHILD_RECURSIVELY(frame, 'effectGbox');
	effectGbox:PlayActiveUIEffect();

end

