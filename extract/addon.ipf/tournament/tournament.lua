
function TOURNAMENT_ON_INIT(addon, frame)

	addon:RegisterMsg("RAID_STATE", "ON_TOURNAMENT_RAID_STATE");


end

function ON_TOURNAMENT_RAID_STATE(frame, msg, mGameName)
	TOURNAMEANT_UPDATE_BTN(frame);
end

function TOURNAMENT_UI_OPEN(frame)
	frame:SetValue(1);
	TOURNAMEANT_UPDATE_BTN(frame);
	TOURNAMEANT_UPDATE_REMAINTIME(frame);
	TOURNAMENT_UPDATE_PROP(frame);
	TOURNAMENT_SCHEDULE(frame);
end

function SCHEDULE_TXT(sche)
	return string.format("%02d:%02d", sche.wHour, sche.wMinute);
end

function TOURNAMENT_SCHEDULE(frame)

	local mGameName = frame:GetUserValue("MGAMENAME");
	if mGameName == "None" then
		mGameName = "tournament";
		frame:SetUserValue("MGAMENAME", mGameName);
	end
	
	local mgame = geMGame.Get(mGameName);
	local cnt = mgame:GetScheduleCount();

	local queue = GET_CHILD(frame, "q_schedule", "ui::CQueue");
	queue:RemoveAllChild();
	local curTime = session.GetDBSysTime();

	for i = 0 , cnt - 1 do
		local sche = mgame:GetScheduleByIndex(i);
		if sche.wDayOfWeek == 255 or curTime.wDayOfWeek == sche.wDayOfWeek then
			local text = queue:CreateOrGetControl('richtext', "SCHEDULE_" .. i, 200, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0);
			text = tolua.cast(text, "ui::CRichText");

			local endSche = mgame:GetEndScheduleByIndex(i);
			local dateTxt = SCHEDULE_TXT(sche) .. " ~ " .. SCHEDULE_TXT(endSche);
			text:EnableResizeByText(1);
			text:SetText("{@st45}" .. dateTxt);
			text:ShowWindow(1);
		end
	end

	queue:AutoResize(true);
	
end

function TOURNAMENT_UPDATE_PROP(frame)
	local etcObj = GetMyEtcObject();
	local obj = GetMyPCObject();
	local icon = GETMYICON();

	TOURNAMENT_UPDATE_PROP_BY_INFO(frame, obj, etcObj, icon);
end

function TOURNAMENT_UPDATE_PROP_BY_INFO(frame, obj, etcObj, icon)
	local name = frame:GetChild("name");
	name:SetTextByKey("name", obj.Name);
	local myPic = GET_CHILD(frame, "myPic", "ui::CPicture");
	myPic:SetImage(icon);

	frame:GetChild("rp"):SetTextByKey("value", etcObj.MG_Pts_tournament);
	frame:GetChild("winlose"):SetTextByKey("win", etcObj.MG_Win_tournament);
	frame:GetChild("winlose"):SetTextByKey("lose", etcObj.MG_Lose_tournament);
	frame:GetChild("gift"):SetTextByKey("count", etcObj.MG_Gift_tournament);
end

function OPEN_TOURNAMENT(mgameName, isOpened)
	
	local sysFrame = ui.GetFrame("sysmenu");
	if isOpened == 0 then
		if ui.IsFrameVisible("tournament") == 1 then
			local frame = ui.GetFrame("tournament");
			frame:SetValue(0);
			frame:ShowWindow(0);
			TOURNAMEANT_UPDATE_REMAINTIME(frame);
			local balName = frame:GetUserValue("BALLOON");
			ui.CloseFrame(balName);
		end

		SYSMENU_DELETE_QUEUE_BTN(sysFrame, "TOURNAMENT");
	else
		local btn = SYSMENU_CREATE_QUEUE_BTN(sysFrame, "TOURNAMENT", "button_collection", 1);
		local toggleScp = "ui.ToggleFrame('tournament')";
		btn:SetEventScript(ui.LBUTTONUP, toggleScp);

		local frame = ui.GetFrame("tournament");
		frame:SetValue(1);
		frame:SetUserValue("MGAMENAME", mgameName);
		TOURNAMEANT_UPDATE_BTN(frame);
		TOURNAMEANT_UPDATE_REMAINTIME(frame);

		local sx, sy = GET_GLOBAL_XY(btn);
		local balloonFrame = MAKE_BALLOON_FRAME("{s20}{b}" .. ClMsg("TournamentPVPOpened"), sx, sy, "CLICK_TOURNAMENT_BAL");
		frame:SetUserValue("BALLOON", balloonFrame:GetName());
	end

end

function CLICK_TOURNAMENT_BAL()
	local frame = ui.GetFrame("tournament");
	local balName = frame:GetUserValue("BALLOON");
	local f = ui.GetFrame(balName);
	f:ShowWindow(0);
	frame:ShowWindow(1);
end

function TOURNAMENT_JOIN(frame)
	local mGameName = frame:GetUserValue("MGAMENAME");
	geMGame.ReqMGameCmd(mGameName, 2);
	TOURNAMEANT_UPDATE_BTN(frame);
end

function TOURNAMENT_JOIN_CANCEL(frame)
	local mGameName = frame:GetUserValue("MGAMENAME");
	geMGame.ReqMGameCmd(mGameName, 3);
end

function TOURNAMEANT_UPDATE_BTN(frame)

	local curMGameName = session.GetJoinMGame();
	local btn = frame:GetChild("btn");
	local mGameName = frame:GetUserValue("MGAMENAME");
	if curMGameName ~= "None" and curMGameName == mGameName then
		btn:SetTextByKey("value", ClMsg("CancelJoin"));
		btn:SetEventScript(ui.LBUTTONUP, 'TOURNAMENT_JOIN_CANCEL');
		btn:SetEnable(1);
		curMGameName:ShowWindow(1);
	else
		if frame:GetValue() == 0 then
			btn:SetEventScript(ui.LBUTTONUP, 'None');
			btn:SetTextByKey("value", ClMsg("Closed"));	
			btn:SetEnable(0);
		else
			btn:SetEventScript(ui.LBUTTONUP, 'TOURNAMENT_JOIN');
			btn:SetTextByKey("value", ClMsg("Join"));
			btn:SetEnable(1);
		end
	end

end

function TOURNAMEANT_UPDATE_REMAINTIME(frame)
	local remaintime = frame:GetChild("remaintime");
	if frame:GetValue() == 0 then
		remaintime:ShowWindow(0);
	else
		remaintime:ShowWindow(1);
		remaintime:RunUpdateScript("_TOURNAMENT_UPDATE_TIME");
	end	
end

function _TOURNAMENT_UPDATE_TIME(remainTime, totalTime)

	local frame = remainTime:GetTopParentFrame();

	local mGameName = frame:GetUserValue("MGAMENAME");
	local mgame = geMGame.Get(mGameName);
	local curTime = session.GetDBSysTime();
	local remainSec = mgame:GetRemainSec(curTime);
	local remainStr = GET_MS_TXT(remainSec);
	remainTime:SetTextByKey("value", remainStr);
	
	return 1;
end