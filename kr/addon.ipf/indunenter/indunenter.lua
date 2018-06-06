function INDUNENTER_ON_INIT(addon, frame)
	addon:RegisterMsg('MOVE_ZONE', 'INDUNENTER_CLOSE');
	addon:RegisterMsg('UPDATE_PC_COUNT', 'INDUNENTER_UPDATE_PC_COUNT');
	addon:RegisterMsg('ESCAPE_PRESSED', 'INDUNENTER_ON_ESCAPE_PRESSED');
	g_indunMultipleItem = "Premium_dungeoncount_01";
end

function INDUNENTER_ON_ESCAPE_PRESSED(frame, msg, argStr, argNum)
	if frame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
		INDUNENTER_CLOSE(frame, msg, argStr, argNum);
	end
end

function INDUNENTER_CLOSE(frame, msg, argStr, argNum)
	INDUNENTER_AUTOMATCH_CANCEL();
	INDUNENTER_PARTYMATCH_CANCEL();
		
	INDUNENTER_MULTI_CANCEL(frame)

	ui.CloseFrame('indunenter');
	CloseIndunEnterDialog();
end

function INDUNENTER_AUTOMATCH_CANCEL()
	local frame = ui.GetFrame('indunenter');
	packet.SendCancelIndunMatching();
	INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
end

function SHOW_INDUNENTER_DIALOG(indunType, isAlreadyPlaying, enableAutoMatch)
	-- get data and check
	local indunCls = GetClassByType('Indun', indunType);
	if indunCls == nil then
		return;
	end

		local frame = ui.GetFrame('indunenter');
	local bigmode = frame:GetChild('bigmode');
	local smallmode = frame:GetChild('smallmode');
	local noPicBox = GET_CHILD_RECURSIVELY(bigmode, 'noPicBox');
	local smallBtn = GET_CHILD_RECURSIVELY(frame, 'smallBtn');
	local reEnterBtn = GET_CHILD_RECURSIVELY(frame, 'reEnterBtn');
	
	-- set user value
	frame:SetUserValue('INDUN_TYPE', indunType);
	frame:SetUserValue('FRAME_MODE', 'BIG');
	frame:SetUserValue('INDUN_NAME', indunCls.Name);
	frame:SetUserValue('AUTOMATCH_MODE', 'NO');
	frame:SetUserValue('WITHMATCH_MODE', 'NO');
	frame:SetUserValue('MON_TOGGLE_OPEN', 'NO');
	frame:SetUserValue('REWARD_TOGGLE_OPEN', 'NO');

	-- make controls
	INDUNENTER_MAKE_HEADER(frame);
	INDUNENTER_MAKE_PICTURE(frame, indunCls);
	INDUNENTER_MAKE_COUNT_BOX(frame, noPicBox, indunCls);
	INDUNENTER_MAKE_LEVEL_BOX(frame, noPicBox, indunCls);
	INDUNENTER_MAKE_MULTI_BOX(frame, indunCls);
	INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
	INDUNENTER_MAKE_MONLIST(frame, indunCls);
	INDUNENTER_MAKE_REWARDLIST(frame, indunCls);

	-- setting
	INDUNENTER_INIT_MEMBERBOX(frame);
	INDUNENTER_AUTOMATCH_TYPE(0);
	INDUNENTER_AUTOMATCH_PARTY(0);
	reEnterBtn:SetEnable(isAlreadyPlaying);
	if enableAutoMatch == 0 then
		INDUNENTER_SET_ENABLE(1, 0, 0, 0);
	end

	-- show
	frame:ShowWindow(1);
	bigmode:ShowWindow(1);
	smallmode:ShowWindow(0);
end

function INDUNENTER_INIT_MEMBERBOX(frame)
	local pc = GetMyPCObject();
	local aid = session.loginInfo.GetAID();
	local jobID = TryGetProp(pc, "Job");
	local lv = TryGetProp(pc, "Lv");

	if pc == nil or jobID == nil or lv ==  nil then
		return;
	end

	frame:SetUserValue('MEMBER_INFO', aid..'/'..tostring(jobID)..'/'..tostring(lv));
	INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
end

function INDUNENTER_MAKE_PICTURE(frame, indunCls)
	local mapImage = TryGetProp(indunCls, 'MapImage');
	if frame == nil or mapImage == nil then
		return;
	end
	
	local indunPic = GET_CHILD_RECURSIVELY(frame, 'indunPic');
	if mapImage ~= 'None' then
		indunPic:SetImage(mapImage);
	end
end

function INDUNENTER_MAKE_MONLIST(frame, indunCls)
	if frame == nil then
		return;
	end

	local monSlotSet = GET_CHILD_RECURSIVELY(frame, 'monSlotSet');
	local monSlotSet_extra = GET_CHILD_RECURSIVELY(frame, 'monSlotSet_extra');
	
	-- init
	monSlotSet_extra:SetPos(monSlotSet_extra:GetOriginalX(), monSlotSet_extra:GetOriginalY());
	monSlotSet:ClearIconAll();
	monSlotSet_extra:ClearIconAll();

	-- data set
	local bossList = TryGetProp(indunCls, 'BossList');
	if bossList == nil or bossList == 'None' then
		return;
	end
	local bossTable = StringSplit(bossList, '/');
	frame:SetUserValue('MON_SLOT_CNT', #bossTable);

	for i = 1, #bossTable do
		local monIcon = nil;
		local monCls = nil;
		if bossTable[i] == "Random" then
			monIcon = frame:GetUserConfig('RANDOM_ICON');
		else
			monCls = GetClass('Monster', bossTable[i]);
			monIcon = TryGetProp(monCls, 'Icon');
		end

		if monIcon ~= nil then
			local slot = nil;
			if i > 5 then
				slot = monSlotSet_extra:GetSlotByIndex(10 - i);
			else -- 5개까지는 기본적으로 보여지는 슬롯셋에 아이콘 추가
				slot = monSlotSet:GetSlotByIndex(i - 1);
			end
			if slot ~= nil then
				local slotIcon = CreateIcon(slot);
				slotIcon:SetImage(monIcon);
				if monCls ~= nil then -- set tooltip
					slotIcon:SetImage(GET_MON_ILLUST(monCls));
					slotIcon:SetTooltipType("mon_simple");
					slotIcon:SetTooltipArg(bossTable[i]);
					slotIcon:SetTooltipOverlap(1);
				end
			end
		end
	end
end

function INDUNENTER_MAKE_REWARDLIST(frame, indunCls)
	if frame == nil then
		return;
	end

	local rewardSlotSet = GET_CHILD_RECURSIVELY(frame, 'rewardSlotSet');
	local rewardSlotSet_extra = GET_CHILD_RECURSIVELY(frame, 'rewardSlotSet_extra');

	-- init
	rewardSlotSet_extra:SetPos(rewardSlotSet_extra:GetOriginalX(), rewardSlotSet_extra:GetOriginalY());
	rewardSlotSet:ClearIconAll();
	rewardSlotSet_extra:ClearIconAll();

	-- data set	
	local itemList = TryGetProp(indunCls, 'ItemList');
	if itemList == nil or itemList == 'None' then
		return;
	end
	local itemTable = StringSplit(itemList, '/');
	frame:SetUserValue('REWARD_SLOT_CNT', #itemTable);

	for i = 1, #itemTable do
		local itemIcon = nil;
		if itemTable[i] == "Random" then
			itemIcon = frame:GetUserConfig('RANDOM_ICON');
		else
			local itemCls = GetClass('Item', itemTable[i]);
			itemIcon = TryGetProp(itemCls, 'Icon');
		end

		if itemIcon ~= nil then
			if i > 5 then
				local slot = rewardSlotSet_extra:GetSlotByIndex(10 - i);
				local slotIcon = CreateIcon(slot);
				slotIcon:SetImage(itemIcon);
				SET_ITEM_TOOLTIP_BY_NAME(slot:GetIcon(), itemTable[i]);
				slotIcon:SetTooltipOverlap(1);
			else -- 5개까지는 기본적으로 보여지는 슬롯셋에 아이콘 추가
				local slot = rewardSlotSet:GetSlotByIndex(i - 1);
				local slotIcon = CreateIcon(slot);
				slotIcon:SetImage(itemIcon);
				SET_ITEM_TOOLTIP_BY_NAME(slot:GetIcon(), itemTable[i]);
				slotIcon:SetTooltipOverlap(1);
			end
		end
	end
end

function INDUNENTER_MAKE_MULTI_BOX(frame, indunCls)
	if frame == nil then
		return;
	end
	local multiBox = GET_CHILD_RECURSIVELY(frame, 'multiBox');
	local arrow = GET_CHILD_RECURSIVELY(frame, 'arrow');
	local invItem = session.GetInvItemByName(g_indunMultipleItem);
	if nil == invItem then -- 인던 배수권 아이템이 있을 때만 보여야 한당		
		multiBox:ShowWindow(0);
		arrow:ShowWindow(0);
		return;
	end

	local indunType = TryGetProp(indunCls, "PlayPerResetType");

	local viewBOX = false;
	if indunType == 100 or indunType == 200 then
		viewBOX = true;
	end

	if viewBOX == false then
		multiBox:ShowWindow(0);
		arrow:ShowWindow(0);
		return;
	end

	local multiEdit = GET_CHILD_RECURSIVELY(frame, 'multiEdit');
	local maxMultiCnt = INDUN_MULTIPLE_USE_MAX_COUNT - 1; --frame:GetUserIValue('MAX_MULTI_CNT');
	local multiDefault = frame:GetUserConfig('MULTI_DEFAULT');
	
	multiEdit:SetText(multiDefault);
	multiEdit:SetMaxNumber(maxMultiCnt);
	multiBox:ShowWindow(1);
	arrow:ShowWindow(1);
	
	local multiCancelBtn = GET_CHILD_RECURSIVELY(frame, "multiCancelBtn");
	multiCancelBtn:ShowWindow(0);
end

function INDUNENTER_MAKE_HEADER(frame)
	if frame == nil then
		return;
	end
	local header = frame:GetChild('header');
	local bigModeWidth = header:GetOriginalWidth();
	local smallModeWidth = tonumber(frame:GetUserConfig('SMALLMODE_WIDTH'));
	local indunName = header:GetChild('indunName');
	local indunNameTxt = frame:GetUserValue('INDUN_NAME');

	if frame:GetUserValue('FRAME_MODE') == "BIG" then
		header:Resize(bigModeWidth, header:GetHeight());
		indunName:SetText(indunNameTxt);
	else
		header:Resize(smallModeWidth, header:GetHeight());
		indunName:SetText(ClMsg("AutoMatchIng"));
	end

end

function INDUNENTER_MAKE_COUNT_BOX(frame, noPicBox, indunCls)
	local etc = GetMyEtcObject();
	if frame == nil or noPicBox == nil or indunCls == nil or etc == nil then
		return;
	end
	local countData = GET_CHILD_RECURSIVELY(frame, 'countData');

	-- now play count
	local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
	countData:SetTextByKey("now", nowCount);

	-- max play count
	local maxCount = TryGetProp(indunCls, 'PlayPerReset');
	if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
		maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token');
	end
	countData:SetTextByKey("max", maxCount);

	-- set min/max multi count
	local minCount = frame:GetUserConfig('MULTI_MIN');
	frame:SetUserValue("MIN_MULTI_CNT", minCount);
	frame:SetUserValue("MAX_MULTI_CNT", maxCount - nowCount);
end

function INDUNENTER_MAKE_LEVEL_BOX(frame, noPicBox, indunCls)
	if frame == nil or frame == noPicBox or indunCls == nil then
		return;
	end
	local lvData = GET_CHILD_RECURSIVELY(noPicBox, 'lvData');
	lvData:SetText(TryGetProp(indunCls, 'Level'));
end

function INDUNENTER_MAKE_PARTY_CONTROLSET(pcCount, memberTable)
	local frame = ui.GetFrame('indunenter');
	local partyLine = GET_CHILD_RECURSIVELY(frame, 'partyLine');
	local memberBox = GET_CHILD_RECURSIVELY(frame, 'memberBox');
	local memberCnt = #memberTable / 3;

	if memberCnt > 1 then 
		partyLine:Resize(58 * (memberCnt - 1), 15);
		partyLine:ShowWindow(1);
	else
		partyLine:ShowWindow(0);
	end
	DESTROY_CHILD_BYNAME(memberBox, 'MEMBER_');

	for i = 1, INDUN_AUTOMATCHING_PCCOUNT do
		local memberCtrlSet = memberBox:CreateOrGetControlSet('indunMember', 'MEMBER_'..tostring(i), 10 * i + 58 * (i - 1), 0);
		memberCtrlSet:ShowWindow(1);

		-- default setting
		local leaderImg = memberCtrlSet:GetChild('leader_img');
		local levelText = memberCtrlSet:GetChild('level_text');
		local jobIcon = GET_CHILD_RECURSIVELY(memberCtrlSet, 'jobportrait');
		local matchedIcon = GET_CHILD_RECURSIVELY(memberCtrlSet, 'matchedIcon');
		local NO_MATCH_SKIN = frame:GetUserConfig('NO_MATCH_SKIN');

		levelText:ShowWindow(0);
		leaderImg:ShowWindow(0);
		jobIcon:SetImage(NO_MATCH_SKIN);
		matchedIcon:ShowWindow(0);

		if i <= pcCount then -- 참여한 인원만큼 보여주는 부분
			if i * 3 <= #memberTable then -- 파티원인 경우		
				-- show leader
				local aid = memberTable[i * 3 - 2];
				local pcparty = session.party.GetPartyInfo(PARTY_NORMAL);
				if pcparty ~= nil and pcparty.info:GetLeaderAID() == aid then
					leaderImg:ShowWindow(1);
				end

				-- show job icon
				local jobCls = GetClassByType("Job", tonumber(memberTable[i * 3 - 1]));
				local jobIconData = TryGetProp(jobCls, 'Icon');
				if jobIconData ~= nil then
					jobIcon:SetImage(jobIconData);
				end

				-- show level
				local lv = memberTable[i * 3];
				levelText:SetText(lv);
				levelText:ShowWindow(1);
			else -- 파티원은 아닌데 매칭된 사람
				jobIcon:ShowWindow(0);
				matchedIcon:ShowWindow(1);
			end		
		end
	end
end

function INDUNENTER_MULTI_UP(frame, ctrl)
	if frame == nil or ctrl == nil then
		return;
	end
	local multiEdit = GET_CHILD(frame, 'multiEdit');
	local nowCnt = multiEdit:GetNumber();
	local topFrame = frame:GetTopParentFrame();
	--local maxCnt = topFrame:GetUserIValue('MAX_MULTI_CNT');
	local maxCnt = INDUN_MULTIPLE_USE_MAX_COUNT;
	local invItem = session.GetInvItemByName(g_indunMultipleItem);

	nowCnt = nowCnt + 1;

	local etc = GetMyEtcObject();
	local indunType = topFrame:GetUserValue('INDUN_TYPE');
	local indunCls = GetClassByType('Indun', indunType);
	if indunCls == nil then
		return;
	end

	local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));

	local maxCount = TryGetProp(indunCls, 'PlayPerReset');
	if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
		maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token');
	end

	local remainCount = maxCount - nowCount;

	if nowCnt >= remainCount then
		nowCnt = remainCount - 1;
		ui.SysMsg(ScpArgMsg('NotEnoughIndunEnterCount'));
	elseif nowCnt == maxCnt then
		ui.SysMsg(ScpArgMsg('IndunMultipleMAX'));
		return
	end

	if nowCnt - 1 >= invItem.count then
		ui.SysMsg(ScpArgMsg('NotEnoughIndunMultipleItem'));
		return;
	end

	if nowCnt < 0 then
		return;
	end

	local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
	local imgName = string.format("indun_x%d", nowCnt + 1);
	rateValue:SetImage(imgName);
	multiEdit:SetText(tostring(nowCnt));
end

function INDUNENTER_MULTI_DOWN(frame, ctrl)
	if frame == nil or ctrl == nil then
		return;
	end
	local multiEdit = GET_CHILD(frame, 'multiEdit');
	local nowCnt = multiEdit:GetNumber();
	local topFrame = frame:GetTopParentFrame();
	local minCnt = topFrame:GetUserIValue('MIN_MULTI_CNT');

	nowCnt = nowCnt - 1;
	if nowCnt < minCnt then
		nowCnt = minCnt;
	end

	local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
	local imgName = string.format("indun_x%d", nowCnt + 1);
	rateValue:SetImage(imgName);
	multiEdit:SetText(tostring(nowCnt));
end

function INDUNENTER_SMALL(frame, ctrl)
	if frame == nil then
		return;
	end
	local topFrame = frame:GetTopParentFrame();
	local bigmode = topFrame:GetChild('bigmode');
	local smallmode = topFrame:GetChild('smallmode');
	local header = topFrame:GetChild('header');
	
	if topFrame:GetUserValue('FRAME_MODE') == "BIG" then	-- to small mode
		if topFrame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
			ui.SysMsg(ScpArgMsg('EnableWhenAutoMatching'));
			return;
		end
		bigmode:ShowWindow(0);
		smallmode:ShowWindow(1);
		topFrame:SetUserValue('FRAME_MODE', 'SMALL');
		topFrame:Resize(smallmode:GetWidth(), smallmode:GetHeight());
	else											-- to big mode
		bigmode:ShowWindow(1);
		smallmode:ShowWindow(0);
		topFrame:SetUserValue('FRAME_MODE', 'BIG');
		topFrame:Resize(bigmode:GetWidth(), bigmode:GetHeight());
	end
	INDUNENTER_MAKE_HEADER(topFrame);

	frame:ShowWindow(1);
end

function INDUNENTER_ENTER(frame, ctrl)
	local yesScript = "ReqMoveToIndun(1)";
	ui.MsgBox(ScpArgMsg("EnterRightNow"), yesScript, "None");
end

function INDUNENTER_AUTOMATCH(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	if topFrame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
		ReqMoveToIndun(2);
	else
		INDUNENTER_AUTOMATCH_CANCEL();
	end
end

function INDUNENTER_PARTYMATCH(frame, ctrl)
	-- 참가중인 파티 없으면 return
	if session.party.GetPartyInfo(PARTY_NORMAL) == nil then	
		ui.SysMsg(ClMsg('HadNotMyParty'));
		return;
	end

	local topFrame = frame:GetTopParentFrame();
	if topFrame:GetUserValue('WITHMATCH_MODE') == 'NO' then
		ReqMoveToIndun(3);
		INDUNENTER_SET_ENABLE(0, 0, 1, 0);
	else
		INDUNENTER_PARTYMATCH_CANCEL();
		INDUNENTER_SET_ENABLE(1, 1, 1, 1);
	end
end

function INDUNENTER_PARTYMATCH_CANCEL()
	local frame = ui.GetFrame('indunenter');
	local indunType = frame:GetUserIValue("INDUN_TYPE");
	local indunCls = GetClassByType('Indun', indunType);
	if frame ~= nil and indunCls ~= nil then
		packet.SendCancelIndunPartyMatching(indunCls.Name);
	end
	local withTime = GET_CHILD_RECURSIVELY(frame, 'withTime');
	withTime:SetText(ClMsg('MatchWithParty'));
	INDUNENTER_INIT_MEMBERBOX(frame);
end

function INDUNENTER_SET_WAIT_PC_COUNT(pcCount)
	local frame = ui.GetFrame('indunenter');
	if frame == nil or frame:IsVisible() ~= 1 then
		return;
	end
	local memberCntText = GET_CHILD_RECURSIVELY(frame, 'memberCntText');
	memberCntText:SetTextByKey('cnt', pcCount);
end

function INDUNENTER_AUTOMATCH_TYPE(indunType)
	local frame = ui.GetFrame("indunenter");
	local memberCntBox = GET_CHILD_RECURSIVELY(frame, 'memberCntBox');
	local autoMatchText = GET_CHILD_RECURSIVELY(frame, 'autoMatchText');
	local autoMatchTime = GET_CHILD_RECURSIVELY(frame, 'autoMatchTime');
	local withBtn = GET_CHILD_RECURSIVELY(frame, 'withBtn');
	local smallBtn = GET_CHILD_RECURSIVELY(frame, 'smallBtn');
	local smallmode = GET_CHILD_RECURSIVELY(frame, 'smallmode');
	local cancelAutoMatch = GET_CHILD_RECURSIVELY(frame, 'cancelAutoMatch');

	if indunType == 0 then
		frame:SetUserValue('AUTOMATCH_MODE', 'NO');
		autoMatchText:ShowWindow(1);
		autoMatchTime:ShowWindow(0);
		memberCntBox:ShowWindow(0);
		INDUNENTER_SET_ENABLE(1, 1, 1, 1);
		INDUNENTER_INIT_MEMBERBOX(frame);

		if frame:GetUserValue('FRAME_MODE') == "SMALL" then
			INDUNENTER_SMALL(frame, smallBtn);
		end
	else
		frame:SetUserValue('AUTOMATCH_MODE', 'YES');
		autoMatchText:ShowWindow(0);
		memberCntBox:ShowWindow(1);
		cancelAutoMatch:SetEnable(1);

		INDUNENTER_AUTOMATCH_TIMER_START(frame);
		INDUNENTER_SET_ENABLE(0, 1, 0, 0);
		INDUNENTER_MAKE_SMALLMODE(frame, false);
		INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 1);
	end
end

function INDUNENTER_AUTOMATCH_TIMER_START(frame)
	local autoMatchTime = GET_CHILD_RECURSIVELY(frame, 'autoMatchTime');
	autoMatchTime:ShowWindow(1);

	frame:SetUserValue("START_TIME", os.time());
	frame:RunUpdateScript("_INDUNENTER_AUTOMATCH_UPDATE_TIME", 0.5);
	_INDUNENTER_AUTOMATCH_UPDATE_TIME(frame);
end

function _INDUNENTER_AUTOMATCH_UPDATE_TIME(frame)
	local elaspedSec = os.time() - frame:GetUserIValue("START_TIME");
	local minute = math.floor(elaspedSec / 60);
	local second = elaspedSec % 60;
	local txt = string.format("%02d:%02d", minute, second);

	local autoMatchTime = GET_CHILD_RECURSIVELY(frame, 'autoMatchTime');
	local smallMatchTime = GET_CHILD_RECURSIVELY(frame, 'matchTime');
	autoMatchTime:SetText(txt);
	smallMatchTime:SetText(txt);

	if frame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
		autoMatchTime:ShowWindow(0);
		return 0;
	end
	return 1;
end

function INDUNENTER_SMALLMODE_CANCEL(frame, ctrl)
	INDUNENTER_AUTOMATCH_CANCEL();
end

function INDUNENTER_AUTOMATCH_PARTY(numWaiting, level, limit, indunLv, indunName, elapsedTime)
	local frame = ui.GetFrame("indunenter");
	local withText = GET_CHILD_RECURSIVELY(frame, 'withText');
	local withTime = GET_CHILD_RECURSIVELY(frame, 'withTime');

	if numWaiting == 0 then
		frame:SetUserValue('WITHMATCH_MODE', 'NO');
		withText:ShowWindow(1);
		withTime:ShowWindow(0);
		INDUNENTER_SET_ENABLE(1, 1, 1, 1);
		INDUNENTER_INIT_MEMBERBOX(frame);
	else
		frame:SetUserValue('WITHMATCH_MODE', 'YES');
		frame:SetUserValue("ELAPSED_TIME", elapsedTime);
		withText:ShowWindow(0);
		INDUNENTER_AUTOMATCH_PARTY_TIMER_START(frame);
		INDUNENTER_SET_ENABLE(0, 0, 1, 0);
		INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 1);
	end
end

function INDUNENTER_AUTOMATCH_PARTY_TIMER_START(frame)
	local withTime = GET_CHILD_RECURSIVELY(frame, 'withTime');
	withTime:ShowWindow(1);

	frame:SetUserValue("START_TIME", os.time());
	frame:SetUserValue("WAITING_TIME", frame:GetUserIValue("ELAPSED_TIME"));
	frame:RunUpdateScript("_INDUNENTER_AUTOMATCH_PARTY_UPDATE_TIME", 0.5);
	_INDUNENTER_AUTOMATCH_PARTY_UPDATE_TIME(frame);
end

function _INDUNENTER_AUTOMATCH_PARTY_UPDATE_TIME(frame)
	local elapsedSec = os.time() - frame:GetUserIValue("START_TIME");
	local remainSec = frame:GetUserIValue("WAITING_TIME") - elapsedSec;
	local minute = math.floor(remainSec / 60);
	local second = remainSec % 60;
	local txt = string.format("%02d:%02d", minute, second);
	local withTime = GET_CHILD_RECURSIVELY(frame, 'withTime');
	withTime:SetText(txt);	

	if frame:GetUserValue('WITHMATCH_MODE') == 'NO' then
		withTime:ShowWindow(0);
		return 0;
	end
	return 1;	
end

function INDUNENTER_SET_ENABLE(enter, autoMatch, withParty, multi)
	local frame = ui.GetFrame('indunenter');
	local enterBtn = GET_CHILD_RECURSIVELY(frame, 'enterBtn');
	local autoMatchBtn = GET_CHILD_RECURSIVELY(frame, 'autoMatchBtn');
	local withPartyBtn = GET_CHILD_RECURSIVELY(frame, 'withBtn');
	local multiBtn = GET_CHILD_RECURSIVELY(frame, 'multiBtn');
	local reEnterBtn = GET_CHILD_RECURSIVELY(frame, 'reEnterBtn');

	enterBtn:SetEnable(enter);
	autoMatchBtn:SetEnable(autoMatch);
	withPartyBtn:SetEnable(withParty);
	multiBtn:SetEnable(multi);
end

function INDUNENTER_UPDATE_PC_COUNT(frame, msg, argStr, argNum) -- argNum: pcCount, argStr: aid/jobID/lv
	if frame == nil then
		return;
	end
	if argStr == nil then
		argStr = "None";
	end

	local memberInfo = frame:GetUserValue('MEMBER_INFO');
	if argStr ~= "None" then -- update party member info
		memberInfo = argStr;
		frame:SetUserValue('MEMBER_INFO', memberInfo);
	end

	local memberTable = StringSplit(memberInfo, '/');
	INDUNENTER_MAKE_PARTY_CONTROLSET(argNum, memberTable);
	INDUNENTER_UPDATE_SMALLMODE_PC(argNum);
end

function INDUNENTER_UPDATE_SMALLMODE_PC(pcCount)
	local frame = ui.GetFrame("indunenter");
	local YES_MATCH_SKIN = frame:GetUserConfig('YES_MATCH_SKIN');

	local matchPCBox = GET_CHILD_RECURSIVELY(frame, 'matchPCBox');
	matchPCBox:RemoveAllChild();
	local notWaitingCount = INDUN_AUTOMATCHING_PCCOUNT - pcCount;

	local pictureIndex = 0;
	for i = 0 , pcCount - 1 do
		local pic = matchPCBox:CreateControl("picture", "MAN_PICTURE_" .. pictureIndex, 25, 40, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		AUTO_CAST(pic);
		pic:SetEnableStretch(1);
		pic:SetImage(YES_MATCH_SKIN);
		pictureIndex = pictureIndex + 1;
	end

	for i = 0 , notWaitingCount - 1 do
		local pic = matchPCBox:CreateControl("picture", "MAN_PICTURE_" .. pictureIndex, 25, 40, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		AUTO_CAST(pic);
		pic:SetEnableStretch(1);
		pic:SetColorTone("FF222222");
		pic:SetImage(YES_MATCH_SKIN);
		pictureIndex = pictureIndex + 1;
	end
	
	GBOX_AUTO_ALIGN_HORZ(matchPCBox, 0, 0, 0, true, true);
end

function INDUNENTER_MAKE_SMALLMODE(frame, isSuccess)
	local matchSuccBox = GET_CHILD_RECURSIVELY(frame, 'matchSuccBox');
	local autoMatchBox = GET_CHILD_RECURSIVELY(frame, 'autoMatchBox');

	if isSuccess == false then
		matchSuccBox:ShowWindow(0);
		autoMatchBox:ShowWindow(1);
	else
		matchSuccBox:ShowWindow(1);
		autoMatchBox:ShowWindow(0);
	end		
end

function INDUNENTER_AUTOMATCH_FINDED()
	local frame = ui.GetFrame('indunenter');
	local cancelAutoMatch = GET_CHILD_RECURSIVELY(frame, 'cancelAutoMatch');
	local indunName = GET_CHILD_RECURSIVELY(frame, 'indunName');

	cancelAutoMatch:SetEnable(0);
	indunName:SetText(ClMsg('AutoMatchComplete'));

	INDUNENTER_MAKE_SMALLMODE(frame, true);
	INDUNENTER_AUTOMATCH_FIND_TIMER_START(frame);
end

function INDUNENTER_AUTOMATCH_FIND_TIMER_START(frame)
	local gaugeBar = GET_CHILD_RECURSIVELY(frame, 'gaugeBar');
	gaugeBar:SetPoint(5, 5);

	frame:SetUserValue("START_TIME", os.time());
	frame:RunUpdateScript("_INDUNENTER_AUTOMATCH_FIND_UPDATE_TIME", 0.1);
	_INDUNENTER_AUTOMATCH_FIND_UPDATE_TIME(frame);
end

function _INDUNENTER_AUTOMATCH_FIND_UPDATE_TIME(frame)
	local elapsedSec = os.time() - frame:GetUserIValue("START_TIME");
	local gaugeBar = GET_CHILD_RECURSIVELY(frame, 'gaugeBar');
	gaugeBar:SetPointWithTime(0, 5 - elapsedSec);

	return 1;	
end

function INDUNENTER_AUTOMATCH_PARTY_SET_COUNT(memberCnt, memberInfo)
	local frame = ui.GetFrame('indunenter');
	INDUNENTER_UPDATE_PC_COUNT(frame, nil, memberInfo, memberCnt);
end

function INDUNENTER_REENTER(frame, ctrl)
	ReqMoveToIndun(4);
end

function INDUNENTER_MON_TOGGLE(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local monSlotSet_extra = GET_CHILD_RECURSIVELY(frame, 'monSlotSet_extra');
	local monSlotCnt = topFrame:GetUserIValue('MON_SLOT_CNT');

	if monSlotCnt < 6 then
		return;
	end

	monSlotCnt = monSlotCnt - 5; -- 더 보여줄 슬롯의 개수
	if topFrame:GetUserValue('MON_TOGGLE_OPEN') == 'NO' then
		topFrame:SetUserValue('MON_TOGGLE_OPEN', 'YES');
		ctrl:SetImage(topFrame:GetUserConfig('MINUS_BTN_IMAGE'));
		UI_PLAYFORCE(monSlotSet_extra, "slotsetRightMove_"..tostring(monSlotCnt));
	else
		topFrame:SetUserValue('MON_TOGGLE_OPEN', 'NO');
		ctrl:SetImage(topFrame:GetUserConfig('PLUS_BTN_IMAGE'));
		UI_PLAYFORCE(monSlotSet_extra, "slotsetLeftMove_"..tostring(monSlotCnt));		
	end
end

function INDUNENTER_REWARD_TOGGLE(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local rewardSlotSet_extra = GET_CHILD_RECURSIVELY(frame, 'rewardSlotSet_extra');
	local rewardSlotCnt = topFrame:GetUserIValue('REWARD_SLOT_CNT');

	if rewardSlotCnt < 6 then
		return;
	end

	rewardSlotCnt = rewardSlotCnt - 5; -- 더 보여줄 슬롯의 개수
	if topFrame:GetUserValue('ITEM_TOGGLE_OPEN') == 'NO' then
		topFrame:SetUserValue('ITEM_TOGGLE_OPEN', 'YES');
		ctrl:SetImage(topFrame:GetUserConfig('MINUS_BTN_IMAGE'));
		UI_PLAYFORCE(rewardSlotSet_extra, "slotsetRightMove_"..tostring(rewardSlotCnt));
	else
		topFrame:SetUserValue('ITEM_TOGGLE_OPEN', 'NO');
		ctrl:SetImage(topFrame:GetUserConfig('PLUS_BTN_IMAGE'));
		UI_PLAYFORCE(rewardSlotSet_extra, "slotsetLeftMove_"..tostring(rewardSlotCnt));		
	end
end

function INDUNENTER_MULTI_EXEC(frame, ctrl)

	local indunenterFrame = ui.GetFrame('indunenter');
	local indunType = indunenterFrame:GetUserValue('INDUN_TYPE');

	local multiEdit = GET_CHILD_RECURSIVELY(frame, 'multiEdit');
	local textCount = multiEdit:GetNumber();

	if textCount == 0 then
		return;
	end

	if textCount >= INDUN_MULTIPLE_USE_MAX_COUNT then
		multiEdit:SetText(tostring(0));
		return;
	end

	local indunCls = GetClassByType('Indun', indunType);
	if indunCls == nil then
		return;
	end

	local etc = GetMyEtcObject();

	local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
	--
	local maxCount = TryGetProp(indunCls, 'PlayPerReset');
	if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
		maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token');
	end

	local remainCount = maxCount - nowCount;

	if textCount >= remainCount then
		ui.SysMsg(ScpArgMsg('NotEnoughIndunEnterCount'));
		return;
	end

	local invItem = session.GetInvItemByName(g_indunMultipleItem);

	if invItem.count < textCount then
		ui.SysMsg(ScpArgMsg('NotEnoughIndunMultipleItem'));
		return;
	end

	packet.SetIndunMultiple(indunType, textCount);

	local multiCancelBtn = GET_CHILD_RECURSIVELY(frame, "multiCancelBtn");
	multiCancelBtn:ShowWindow(1);
	local multiBtn = GET_CHILD_RECURSIVELY(frame, "multiBtn");
	multiBtn:ShowWindow(0);
end

function INDUN_MULTIPLE_CHECK_NUMBER(frame)
	local multiEdit = GET_CHILD_RECURSIVELY(frame, 'multiEdit');
	local textCount = multiEdit:GetNumber();
	if textCount >= INDUN_MULTIPLE_USE_MAX_COUNT then
		multiEdit:SetText(tostring(0));
		return;
	end
	local topFrame = frame:GetTopParentFrame();	

	local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
	local imgName = string.format("indun_x%d", textCount + 1);
	rateValue:SetImage(imgName);
end

function INDUNENTER_MULTI_CANCEL(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();	
	local multiEdit = GET_CHILD_RECURSIVELY(topFrame, 'multiEdit');
	multiEdit:SetText(tostring(0));

	local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
	rateValue:SetImage("indun_x1");

	packet.SetIndunMultiple(0, 0);

	local multiCancelBtn = GET_CHILD_RECURSIVELY(topFrame, "multiCancelBtn");
	multiCancelBtn:ShowWindow(0);
	local multiBtn = GET_CHILD_RECURSIVELY(topFrame, "multiBtn");
	multiBtn:ShowWindow(1);
end
