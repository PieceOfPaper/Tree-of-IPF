-- inun.lua

function INDUN_ON_INIT(addon, frame)
	addon:RegisterMsg('CHAT_INDUN_UI_OPEN', 'ON_CHAT_INDUN_UI_OPEN');
	addon:RegisterMsg('INDUN_COUNT_RESET', 'ON_INDUN_COUNT_RESET');
end

function INDUN_TAB_CHANGE(frame, ctrl, argStr, argNum)
	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	INDUN_VIEW(frame, curtabIndex);
end

function INDUN_VIEW(frame, curtabIndex)
	if curtabIndex == 0 then
		OPEN_DUNGEON(frame);
	elseif curtabIndex == 1 then
		OPEN_REQUEST(frame);
	elseif curtabIndex == 2 then
		OPEN_ABBEY(frame);
	elseif curtabIndex == 3 then
		OPEN_EARTH(frame);
	elseif curtabIndex == 4 then
		OPEN_UPHILL(frame);
	end

end

function ON_INDUN_COUNT_RESET(frame)
	DRAW_INDUN_UI(frame, 200);
	DRAW_INDUN_UI(frame, 100);
end

function SHOW_INDUN_DAY_COUNT(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;
	
	if 0 >= startSec then		
		ctrl:SetTextByKey("value", "");
		ctrl:StopUpdateScript("SHOW_INDUN_DAY_COUNT");
		return 0;
	end
	local timeTxt = GET_TIME_TXT(startSec);
	ctrl:SetTextByKey("value", "{@st42}(" .. timeTxt..")");
	return 1;
end

function DRAW_INDUN_UI(frame, type)
	local textGbox = frame:GetChild("textGbox");
	local etcObj = GetMyEtcObject();
	if nil == etcObj then
		return;
	end

	local pCls = nil;
	if 100 == type then
		pCls = GetClass("Indun", "Indun_startower"); -- �δ�
	elseif 200 == type then
		pCls = GetClass("Indun", "Request_Mission1"); -- �Ƿڼ�
	elseif 300 == type then
		pCls = GetClass("Indun", "Request_Mission7"); -- ��� ������
	elseif 400 == type then
		pCls = GetClass("Indun", "M_GTOWER_1"); -- ������ ž
	elseif 500 == type then
		pCls = GetClass("Indun", "Request_Mission10"); -- ���� ���潺 �̼�
	end

	if nil == pCls then
		return;
	end

	local text = "";
	local countStr ="";
	local etcType = "InDunCountType_"..type;
	local count = frame:GetChild("count");
	if etcObj.IndunFreeTime ~= 'None' then
		text = ScpArgMsg("NextEnterNeed");
		local sysTime = geTime.GetServerSystemTime();
		local endTime = imcTime.GetSysTimeByStr(etcObj.IndunFreeTime);
		local difSec = imcTime.GetDifSec(endTime, sysTime);
		count:SetUserValue("REMAINSEC", difSec);
		count:SetUserValue("STARTSEC", imcTime.GetAppTime());
		SHOW_INDUN_DAY_COUNT(count);
		count:RunUpdateScript("SHOW_INDUN_DAY_COUNT", 0.1);
	else
		local maxPlayCnt = pCls.PlayPerReset;
		if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then 
			maxPlayCnt = maxPlayCnt + pCls.PlayPerReset_Token;
		end
		
		text = ScpArgMsg("MaxCountExplain{COUNT}", "HOUR", INDUN_RESET_TIME, "COUNT", maxPlayCnt);
		countStr = string.format("%d / %d", etcObj[etcType], maxPlayCnt);
		count:StopUpdateScript("SHOW_INDUN_DAY_COUNT");
	end

	local indunText = textGbox:GetChild("indunText");
	indunText:SetTextByKey("value", text);

	if 0 < pCls.PlayPerReset_Token and true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		text = text .."{nl}" .. "{#003300}"..ScpArgMsg("IndunMore{COUNT}ForTOKEN", "COUNT", pCls.PlayPerReset_Token);
		indunText:SetTextByKey("value", text);
		textGbox:Resize(textGbox:GetWidth(), 60);
	else
		textGbox:Resize(textGbox:GetWidth(), 35);
	end

	count:SetTextByKey("value", countStr);
	local gbox = frame:GetChild("gbox");
	gbox = gbox:GetChild("groupbox_2");
	gbox:RemoveAllChild();
	local etcObj = GetMyEtcObject();
	local clslist, cnt  = GetClassList("Indun");
	local mylevel = info.GetLevel(session.GetMyHandle());
	for i = 0 , cnt - 1 do
		local pCls = GetClassByIndexFromList(clslist, i);
		if tonumber(pCls.PlayPerResetType) == type then
			local name = pCls.Name;
			local ctrlSet = gbox:CreateControlSet("indun_ctrlset", "CTRLSET_" .. i, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			local button = ctrlSet:GetChild("button");
			local name = ctrlSet:GetChild("name");
			local lv = ctrlSet:GetChild("lv");
			name:SetTextByKey("value", pCls.Name);
			lv:SetTextByKey("value", pCls.Level);
			
			if tonumber(pCls.Level) < mylevel then -- ���ζ���
				button:SetColorTone("FFC4DFB8");	
			elseif tonumber(pCls.Level) > mylevel then -- ��������
				button:SetColorTone("FFFFCA91");
			else
				button:SetColorTone("FFFFFFFF");	
			end
		end
	end

	GBOX_AUTO_ALIGN(gbox, 0, -6, 0, true, false);
end

function OPEN_DUNGEON(frame, ctrl)
	DRAW_INDUN_UI(frame, 100);
end

function OPEN_REQUEST(frame, ctrl)
	DRAW_INDUN_UI(frame, 200);
end

function OPEN_ABBEY(frame, ctrl)
	DRAW_INDUN_UI(frame, 300);
end

function OPEN_EARTH(frame, ctrl)
	DRAW_INDUN_UI(frame, 400);
end
function OPEN_UPHILL(frame, ctrl)
	DRAW_INDUN_UI(frame, 500);
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