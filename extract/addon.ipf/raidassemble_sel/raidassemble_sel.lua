

function RAIDASSEMBLE_SEL_ON_INIT(addon, frame)

	addon:RegisterMsg("RAID_ASSEMBLE", "RA_ON_RAID_ASSEMBLE");	

end

function RA_ON_RAID_ASSEMBLE(frame, msg, mGameName, argNum)

	local mgame = geMGame.Get(mGameName);
	if mgame == nil then
		return;
	end

	local hideTime = 15;
	frame:SetUserValue("MGAMENAME", mGameName);
	frame:SetUserValue("STARTTIME", imcTime.GetAppTime());
	frame:RunUpdateScript("RA_UPDATE_AUTO_HIDE", 0.05);

	frame:ShowWindow(1);
	local upperFrame = ui.GetFrame("raidassemble");
	upperFrame:ShowWindow(1);
	local scheduleInfo = mgame:GetSchedule();
	local titleTxt = scheduleInfo:GetMsgText();
	upperFrame:GetChild("msgtext"):SetText(titleTxt);

	local gauge = GET_CHILD(upperFrame, "gauge", "ui::CGauge");
	gauge:SetPoint(0, 100);
	gauge:SetPointWithTime(100, hideTime);

	local port = scheduleInfo:GetPortrait();
	local pic = GET_CHILD(frame, "port", "ui::CPicture");
	pic:SetImage(port);

end

function RA_HIDE(frame)
	frame:ShowWindow(0);
	local upperFrame = ui.GetFrame("raidassemble");
	upperFrame:ShowWindow(0);
end

function RA_UPDATE_AUTO_HIDE(frame)

	local startTime = frame:GetUserIValue("STARTTIME");
	local elapsedTime = imcTime.GetAppTime() - startTime;
	if elapsedTime >= 15 then
		RA_HIDE(frame);
		return 0;
	end

	return 1;
end

function RA_ASSEM_OK(frame)
	frame = frame:GetTopParentFrame();
	RA_HIDE(frame);

	local mGameName = frame:GetUserValue("MGAMENAME");
	geMGame.ReqMGameCmd(mGameName, 2);

end

function RA_ASSEM_NO(frame)
	frame = frame:GetTopParentFrame();
	RA_HIDE(frame);

	local mGameName = frame:GetUserValue("MGAMENAME");
	geMGame.ReqMGameCmd(mGameName, 3);

end

function RA_ASSEM_NO_MORE(frame)
	frame = frame:GetTopParentFrame();
	RA_HIDE(frame);
	local curDate = GetCurDateNumber();
	config.SetConfig("RaidRejectDate", curDate);

end

