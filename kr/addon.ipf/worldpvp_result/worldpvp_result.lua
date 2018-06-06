--  worldpvp_result.lua


function GET_SKILL_DEAL_TOOLTIP(skillDeals)
	local strList = StringSplit(skillDeals, "#");
	if #strList <= 1 then
		return "";
	end

	local retStr = "";
	local skillCnt = #strList / 2;
	for i = 0 , skillCnt - 1 do
		local clsName = strList[2 * i + 1];
		local skillDeal = strList[2 * i + 2];
		local skillName;
		local sklCls = geSkillTable.Get(clsName);
		if sklCls == nil or true == sklCls.IsNormalAttack then
			skillName = ClMsg("NormalAttack");
		else
			skillName = GetClass("Skill", clsName).Name;
		end

		if i > 0 then
			retStr = retStr .. "{nl}";
		end

		retStr = retStr .. string.format("[%s] : %d", skillName, skillDeal);
	end
	
	return retStr;
end


function WORLDPVP_RESULT_UPDATE_EXITTIME(ctrl)

	local endTime = ctrl:GetUserValue("END_TIME");
	local curTime = imcTime.GetAppTime();
	local remainTime = math.floor(endTime - curTime);
	if remainTime < 0 then
		remainTime = 0;
	end

	local curValue = ctrl:GetTextByKey("value");
	if tonumber(curValue) ~= remainTime then
		ctrl:SetTextByKey("value", remainTime);
	end

	return 1;
end

function WORLDPVP_RESULT_UI(argStr)

	local frame = ui.GetFrame("worldpvp_result");

	local stringList = StringSplit(argStr, "\\");
	local guildBttle = tonumber(stringList[1]);
	local winTeam = tonumber(stringList[2]);
	local autoExitTime = tonumber(stringList[3]);
	local autoexittext = frame:GetChild("autoexittext");
	autoexittext:SetTextByKey("value", math.floor(autoExitTime));
	autoexittext:SetUserValue("END_TIME", imcTime.GetAppTime() + math.floor(autoExitTime));
	autoexittext:RunUpdateScript("WORLDPVP_RESULT_UPDATE_EXITTIME", 0, 0, 0, 1);

	for i = 1 , 2 do
		local gbox = frame:GetChild("gbox_" .. i);
		local gbox_char = gbox:GetChild("gbox_char");
		gbox_char:RemoveAllChild();
		local result = GET_CHILD(frame, "result_" ..i);

		if winTeam > 0 then
		if winTeam == i then
			result:SetImage("test_pvp_win");
				gbox:SetSkinName('test_com_winbg');
		else
			result:SetImage("test_pvp_lose");
				gbox:SetSkinName('test_com_losebg');
			end
		else
			gbox:SetSkinName('test_com_winbg');
			result:SetImage("test_pvp_draw");
		end
	end

	local mvpChar = nil;
	local mvpTeam = nil;
	local maxScore = -1;
	local tokenPerChar = 11;
	local startIndex = 3;
	local charCount = (#stringList - startIndex) / tokenPerChar;
	local lastTeam = -1;
	for i = 0 , charCount - 1 do
		local indexBase = i * tokenPerChar + startIndex;
		local aid = stringList[indexBase + 1];
		local teamID = stringList[indexBase + 2];
		local remainPoint = tonumber(stringList[indexBase + 3]);
		local isConnected = stringList[indexBase + 4];
		local iconStr = stringList[indexBase + 5];
		local famName = stringList[indexBase + 6];
		local charName = stringList[indexBase + 7];
		local killCnt = stringList[indexBase + 8];
		local deathCnt = stringList[indexBase + 9];
		local dealAmount = tonumber(stringList[indexBase + 10]);
		local skillDeals = stringList[indexBase + 11];
		
		local iconInfo = ui.GetPCIconInfoByString(iconStr);
		local iconName = ui.CaptureModelHeadImage_IconInfo(iconInfo);

		local gbox = frame:GetChild("gbox_" .. teamID);
		local gbox_char = gbox:GetChild("gbox_char");
		local ctrlSet = gbox_char:CreateControlSet("pvp_result_set", "RESULT_" .. aid, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		local pic = GET_CHILD(ctrlSet, "pic");
		pic:SetImage(iconName);
		local achieve = ctrlSet:GetChild("achieve");
		achieve:ShowWindow(0);

		local txt_name = GET_CHILD(ctrlSet, "txt_name");
		txt_name:SetTextByKey("value", famName);
		local txt_kill = GET_CHILD(ctrlSet, "txt_kill");
		txt_kill:SetTextByKey("value", killCnt);
		local txt_death = GET_CHILD(ctrlSet, "txt_death");
		txt_death:SetTextByKey("value", deathCnt);
		local txt_getpoint = GET_CHILD(ctrlSet, "txt_getpoint");
		if isConnected == "0" or guildBttle == 1 then
			txt_getpoint:SetTextByKey("value", 0);
		else
			if winTeam == tonumber(teamID) then
				txt_getpoint:SetTextByKey("value", math.min(WORLDPVP_WIN_GET_POINT));
			else
				txt_getpoint:SetTextByKey("value", math.min(WORLDPVP_LOSE_GET_POINT));
			end
		end

		local txt_dealmount = GET_CHILD(ctrlSet, "txt_dealmount");
		txt_dealmount:SetTextByKey("value", "{#FF1111}" .. dealAmount);

		local tooltipStr = GET_SKILL_DEAL_TOOLTIP(skillDeals);
		if tooltipStr ~= "" then
			txt_dealmount:SetTextTooltip(tooltipStr);
		end

		if dealAmount > maxScore then
			mvpChar = aid;
			maxScore = dealAmount;
			mvpTeam = teamID;
		end
	end

	if mvpChar ~= nil then
		local gbox = frame:GetChild("gbox_" .. mvpTeam);
		local gbox_char = gbox:GetChild("gbox_char");
		local ctrlSet = gbox_char:GetChild("RESULT_" .. mvpChar);
		local achieve = ctrlSet:GetChild("achieve");
		achieve:ShowWindow(1);
		local txt_achieve = ctrlSet:GetChild("txt_achieve");
		txt_achieve:SetTextByKey("value", "MVP");
	end

	for i = 1 , 2 do
		local gbox = frame:GetChild("gbox_" .. i);
		local gbox_char = gbox:GetChild("gbox_char");
		GBOX_AUTO_ALIGN(gbox_char, 0, 0, 0, true, false);
		gbox_char:UpdateData();
	end

	frame:ShowWindow(1);
end

function WORLDPVP_RESULT_ENTER_CHAT(parent, ctrl)

	local text = ctrl:GetText();
	if text ~= "" then
		worldPVP.RequestChat(text, false);
		ctrl:SetText("");
	end
	
end

function ON_RECV_PVP_CHAT(from, chatText)

	local frame = ui.GetFrame("worldpvp_result");
	local gbox_chat = GET_CHILD(frame, "gbox_chat");
	local idx  = frame:GetUserIValue("TEXT_IDX");

	local title = gbox_chat:CreateControl('richtext', "TXT_" .. idx, 10, 0, gbox_chat:GetWidth() - 30, 10);
	title:EnableHitTest(0);
	AUTO_CAST(title);
	local resultStr = string.format("{@st41}[%s] : %s", from, chatText);
	title:SetText(resultStr);

	idx = idx + 1;
	frame:SetUserValue("TEXT_IDX", idx);
	GBOX_AUTO_ALIGN(gbox_chat, 0, 10, 0, true, false);
	gbox_chat:UpdateData();
	gbox_chat:SetScrollPos(gbox_chat:GetLineCount() + gbox_chat:GetVisibleLineCount());

end

function WORLDPVP_RETURN_TO_ZONE()

	worldPVP.ReturnToOriginalServer();

end

