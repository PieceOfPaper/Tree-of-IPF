function INDUN_ON_INIT(addon, frame)
			addon:RegisterMsg('CHAT_INDUN_UI_OPEN', 'ON_CHAT_INDUN_UI_OPEN');
end

function OPEN_INDUN(frame)
	
	local resetTime = frame:GetChild("notice");
	local time = string.format("%d", INDUN_RESET_TIME);
	resetTime:SetTextByKey("txt", time);

	local gbox = frame:GetChild("gbox");
	gbox:RemoveAllChild();
	local etcObj = GetMyEtcObject();

	local clslist, cnt  = GetClassList("Indun");
	for i = 0 , cnt - 1 do
		local pCls = GetClassByIndexFromList(clslist, i);
		local name = pCls.Name;
		local ctrlSet = gbox:CreateControlSet("indun_ctrlset", "CTRLSET_" .. i, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local name = ctrlSet:GetChild("name");
		local lv = ctrlSet:GetChild("lv");
		local count = ctrlSet:GetChild("count");
		name:SetTextByKey("value", pCls.Name);
		lv:SetTextByKey("value", pCls.Level);

		local maxCount = pCls.PlayPerReset;
		local playCount = etcObj["InDunCountType_" .. pCls.PlayPerResetType];
		local indunCount = pCls.PlayPerReset;
		local countStr = string.format("%d/%d", playCount, maxCount);
		count:SetTextByKey("value", countStr);
	end

	GBOX_AUTO_ALIGN(gbox, 0, 1, 0, true, false);

end


function INDUN_CANNOT_YET(msg)
	ui.SysMsg(ScpArgMsg(msg));
	ui.OpenFrame("indun");
end

function ON_CHAT_INDUN_UI_OPEN(frame, msg, argStr, argNum)
	if nil ~= frame then
		frame:ShowWindow(1);
	else
		ui.OpenFrame("indun");
	end
end


function GID_CANTFIND_MGAME(msg)
	ui.SysMsg(ScpArgMsg(msg));
end