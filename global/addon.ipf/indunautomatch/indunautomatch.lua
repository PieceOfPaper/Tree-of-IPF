-- indunautomatch.lua


function INDUNAUTOMATCH_ON_INIT(addon, frame)

	addon:RegisterMsg('UPDATE_PC_COUNT', 'INDUNAUTOMATCH_UPDATE_PC_COUNT');

end

function INDUNAUTOMATCH_UPDATE_PC_COUNT(frame, msg, argStr, argNum)
--	print(frame, msg, argStr, argNum);
end

function INDUN_AUTOMATCH_TYPE(indunType)

	local frame = ui.GetFrame("indunautomatch");
	if indunType == 0 then
		frame:ShowWindow(0);
	else
		frame:ShowWindow(1);
		local indunCls = GetClassByType("Indun", indunType)
		local indunName = indunCls.Name

		local txt = frame:GetChild("txt");
		txt:SetTextByKey("value", ScpArgMsg("FindingParty_IfPartyFinded_AutoMaticallyStartGame"));
		INDUN_AUTOMATCH_TIMER_START(frame);
		--INDUN_AUTOMATCH_SET_READY_COUNT(frame, 0);
	end

end

function INDUN_AUTOMATCH_FINDED()

	local frame = ui.GetFrame("indunautomatch");
	local txt = frame:GetChild("txt");
	txt:SetTextByKey("value", ScpArgMsg("PartyFinded_GameWillBeStartedSoonAfter"));
	--INDUN_AUTOMATCH_SET_READY_COUNT(frame, 5);

end

function INDUN_AUTOMATCH_TIMER_START(frame)

	frame:SetUserValue("START_TIME", os.time());
	frame:RunUpdateScript("_INDUN_AUTOMATCH_UPDATE_TIME", 0.2);
	_INDUN_AUTOMATCH_UPDATE_TIME(frame);

end

function _INDUN_AUTOMATCH_UPDATE_TIME(frame)

	local elaspedSec = os.time() - frame:GetUserIValue("START_TIME");
	local minute = math.floor(elaspedSec / 60);
	local second = elaspedSec % 60;
	local txt = string.format("%02d:%02d", minute, second);
	local txt_findtime = frame:GetChild("txt_findtime");
	txt_findtime:SetTextByKey("time", txt);
	
	return 1;

end

function INDUN_AUTOMATCH_SET_READY_COUNT(frame, readyCount)

	local gbox = frame:GetChild("gbox");
	gbox:RemoveAllChild();
	-- gbox:Resize(frame:GetWidth(), gbox:GetHeight());
	local notReadyCount = INDUN_AUTOMATCHING_PCCOUNT - readyCount;

	local pictureIndex = 0;
	for i = 0 , readyCount - 1 do
		local pic = gbox:CreateControl("picture", "MAN_PICTURE_" .. pictureIndex, 30, 30, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		AUTO_CAST(pic);
		pic:SetEnableStretch(1);
		pic:SetImage("house_change_man");
		pictureIndex = pictureIndex + 1;
	end

	for i = 0 , notReadyCount - 1 do
		local pic = gbox:CreateControl("picture", "MAN_PICTURE_" .. pictureIndex, 30, 30, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		AUTO_CAST(pic);
		pic:SetEnableStretch(1);
		pic:SetColorTone("FF222222");
		pic:SetImage("house_change_man");
		pictureIndex = pictureIndex + 1;
	end
	
	GBOX_AUTO_ALIGN_HORZ(gbox, 0, 0, 0, true, true);

end

function INDUN_AUTO_CANCEL()

	packet.SendCancelIndunMatching();

end

function INDUN_SET_WAIT_PC_COUNT(pcCount)
	local frame = ui.GetFrame("indunautomatch");
	local txt = frame:GetChild("txt_waitPcCount");
	txt:SetTextByKey("value2", pcCount);
end

function INDUN_SET_WAIT_TOO_MUCH()
	ui.SysMsg(ScpArgMsg("FailLevelMatching"))
end