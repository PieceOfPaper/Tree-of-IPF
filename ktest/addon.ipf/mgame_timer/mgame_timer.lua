

function MGAME_TIMER_ON_INIT(addon, frame)

	
end

function OPEN_MGAME_TIMER(msgAndKey)

	local sList = StringSplit(msgAndKey, "#");
	local uiKeyName = sList[1];
	local key = sList[2];
	local mgameInfo = session.mission.GetMGameInfo();
	local startTime = mgameInfo:GetUserValue(key .. "_START");
	local roundMaxTime = mgameInfo:GetUserValue(key);
	local elapsedTime = GetServerAppTime() - startTime;
	local remainTime = roundMaxTime - elapsedTime;
	
	local frame = ui.GetFrame("mgame_timer");
	if remainTime <= 0 then
		frame:ShowWindow(0);
		return;
	end

	frame:ShowWindow(1);
	local timer = GET_CHILD(frame, "timer");
	local txt_round = GET_CHILD(frame, "txt_round");
	txt_round:SetTextByKey("value", ScpArgMsg(uiKeyName));
	START_TIMER_CTRLSET_BY_SEC(timer, remainTime, roundMaxTime);
	frame:SetDuration(remainTime);

end

