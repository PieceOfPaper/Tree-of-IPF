function MGAMESCORE_ON_INIT(addon, frame)

	if session.IsMissionMap() == false then
		return;
	end

	addon:RegisterMsg('MGAME_SCORE_TEXT', 'ON_MGAME_SCROE_TEXT');
	addon:RegisterMsg('MGAME_SCORE_RANK', 'ON_MGAME_SCORE_RANK');
	addon:RegisterMsg('MGAME_ZONE_ENTER', 'ON_MGAME_ZONE_ENTER');
end

function ON_MGAME_ZONE_ENTER(frame, msg, argStr, argNum)

	local chanelFrame = ui.GetFrame('channel');
	if msg == 'MGAME_ENTER' then
		frame:ShowWindow(1);
		ON_MGAME_TIME_SETTING(frame, msg, argStr, argNum);
		chanelFrame:ShowWindow(0);
	elseif msg == 'MGAME_LEAVE' then
		ON_MGAME_TIME_SETTING(frame, msg, argStr, argNum);
		frame:ShowWindow(0);
		chanelFrame:ShowWindow(1);
	end
end

function INIT_MGAME_SCORE(frame)

	if session.IsMissionMap() == false then
		frame:ShowWindow(0);
		return;
	end

	frame:SetUserValue('MGAME_SCORE', 0);
	local score_bg = frame:GetChild('score_bg');
	local scoreText = GET_CHILD(score_bg, "scoreText", "ui::CRichText");
	scoreText:SetText("");

	local timeText = GET_CHILD(frame, "timeText", "ui::CRichText");
	timeText:SetText("");

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:Stop();
	frame:ShowWindow(1);
end

function ON_MGAME_SCROE_TEXT(frame, msg, argStr, argNum)
	local value = math.floor(argNum);
	local string = GetCommaedText(value)

	local score_bg = frame:GetChild('score_bg');
	local scoreText = GET_CHILD(score_bg, "scoreText", "ui::CRichText");
	scoreText:SetText("{@st43}{s32}" .. string.. "{/}");

	frame:SetUserValue('MGAME_SCORE', value);
end

function ON_MGAME_TIME_SETTING(frame, msg, argStr, argNum)

	if argStr == 'MGAME_ENTER' then
		INIT_MGAME_SCORE(frame);

		local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_MGAME_START_TIME");
		timer:Start(0.1, 0);
		frame:SetUserValue("MGAME_TIME", argNum)

		local score_bg = frame:GetChild('score_bg');
		local scoreText = GET_CHILD(score_bg, "scoreText", "ui::CRichText");
		scoreText:SetText("{@st43}{s32}{/}");
		frame:ShowWindow(1);		
	elseif argStr == 'MGAME_LEAVE' then
		local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
		timer:Stop();
	end
end

function UPDATE_MGAME_START_TIME(frame, timer, str, num, totalTime)
	
	local sec = totalTime + tonumber( frame:GetUserValue('MGAME_TIME') );
	local time = GET_TIME_TXT(sec);
	
	local timeText = GET_CHILD(frame, "timeText", "ui::CRichText");
	timeText:SetText("{@st41b}" ..time.. "{/}");
end

function ON_MGAME_SCORE_RANK(frame, msg, argStr, argNum)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:Stop();

	local timeText = GET_CHILD(frame, "timeText", "ui::CRichText");
	timeText:SetText("");

	local score = frame:GetUserValue('MGAME_SCORE');
	local score_bg = frame:GetChild('score_bg');
	local scoreText = GET_CHILD(score_bg, "scoreText", "ui::CRichText");

	if argNum > 0 then
		scoreText:SetText("{@st41} Ranking : " .. argNum.. "  Score : " .. score .. "{/}");
	else
		scoreText:SetText("{@st41}" .. ClMsg("MGAME_RANKING_FAIL").. "  Score : " .. score .. "{/}");
	end
end