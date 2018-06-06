-- history.lua

function HISTORY_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_PLAY_HISTORY', 'PLAY_HISTORY_ON_MSG');
end

function UI_TOGGLE_HISTORY()
	if app.IsBarrackMode() == true then
		return;
	end
	
	--session.playHistory.ReqPlayHistory(HISTORY_STAT, 1);
end

--[[
function PLAY_HISTORY_ON_MSG(frame, msg, strArg, numArg)
	if "UPDATE_PLAY_HISTORY" == msg then
		UPDATE_PLAY_HISTORY(frame, numArg);
	end
end

function UPDATE_PLAY_HISTORY(frame, numArg)
	if 0 == frame:IsVisible() then
		frame:ShowWindow(1);
	end

	local seeStory = frame:GetUserIValue("historyType");
	if seeStory ~= numArg then
		frame:SetUserValue("historyType", numArg)
	end

	local gBox = nil;
	local respect = nil;
	local menu = frame:GetChild("menu")
		local rect4 = menu:GetChild("richtext_4");
	if numArg == HISTORY_STAT then
		gBox = frame:GetChild("skill");
		gBox:RemoveAllChild();
		gBox:ShowWindow(0);
		gBox = frame:GetChild("tp");
		gBox:RemoveAllChild();
		gBox:ShowWindow(0);
		gBox = frame:GetChild("stat");

		respect = frame:GetChild("skill_respect");
		respect:RemoveAllChild();
		respect = frame:GetChild("stat_respect");
		rect4:ShowWindow(1);
	elseif numArg == HISTORY_SKILL then
		gBox = frame:GetChild("stat");
		gBox:RemoveAllChild();
		gBox:ShowWindow(0);
		gBox = frame:GetChild("tp");
		gBox:ShowWindow(0);
		gBox:RemoveAllChild();
		gBox = frame:GetChild("skill");

		respect = frame:GetChild("stat_respect");
		respect:RemoveAllChild();
		respect = frame:GetChild("skill_respect");
		rect4:ShowWindow(1);
	elseif numArg == HISTORY_TP then
		gBox = frame:GetChild("skill");
		gBox:RemoveAllChild();
		gBox:ShowWindow(0);
		gBox = frame:GetChild("stat");
		gBox:RemoveAllChild();
		gBox:ShowWindow(0);
		gBox = frame:GetChild("tp");

		respect = frame:GetChild("skill_respect");
		respect:RemoveAllChild();
		respect = frame:GetChild("stat_respect");
		respect:RemoveAllChild();
		rect4:ShowWindow(0);
	end

	if nil == gBox or nil == respect then
		return;
	end

	local TPbox = frame:GetChild("TPBox");
	local medalText = TPbox:GetChild("MyTp");
	medalText:SetTextByKey("value", GET_CASH_POINT_C());

	gBox:ShowWindow(1);
	gBox:RemoveAllChild();
	respect:RemoveAllChild();
	local info = session.playHistory.GetHistoryRespec(numArg);
	local ctrlSet = respect:CreateControlSet("skill_stat_resCnt", "repect",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	ctrlSet:SetSkinName("test_weight_skin");
	local resCnt = ctrlSet:GetChild("resCnt");
	local rollbackCnt = 0;
	if nil ~= info then
		rollbackCnt = info.count;
	end
	resCnt:SetTextByKey("value", rollbackCnt);	

	--skill_stat_his
	local cnt = session.playHistory.GetHistoryCount(numArg);
	local maxPage = math.ceil(session.playHistory.GetHistoryTotalCount(numArg) / REQUSET_HISTORY_SKILL_STAT_COUNT);
	local curPage = session.playHistory.GetHistoryCurPage(numArg);
	for i = 0, cnt-1 do
		local info = session.playHistory.GetHistoryByIndex(numArg, i);
		local ctrlSet = gBox:CreateControlSet("skill_stat_his", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		local propName = ctrlSet:GetChild("PropName");
		local preValue = ctrlSet:GetChild("preValue");
		preValue:SetTextByKey("value", info.preValue);
		preValue:ShowWindow(0);
		local data = "None";
		local name = "None";
		if numArg == HISTORY_STAT then
			local sList = StringSplit(info:GetPropName(), "_");
			name = ClMsg(sList[1]);
			data = "-"..string.format("%s", info.value);
		elseif numArg == HISTORY_SKILL then
			local cls = GetClass("Skill", info:GetPropName());
			name = cls.Name;
			data = "-"..string.format("%s", info.value);
		elseif numArg == HISTORY_TP then
			name = info:GetPropName();
			data = info.value;
		end
		propName:SetTextByKey("value", name);

		local value = ctrlSet:GetChild("value");
		value:SetTextByKey("value", data);
		local saveTime = ctrlSet:GetChild("saveTime");
		saveTime:SetTextByKey("value", info:GetSaveTime());

		local button_1 = ctrlSet:GetChild("button_1");
		button_1:ShowWindow(0);
		if numArg ~= HISTORY_TP then
			local data = string.format("%d", rollbackCnt) .. "TP";
			if info.isFree == true then
				preValue:ShowWindow(1);
				data = ClMsg("IsFree");
				preValue:SetTextByKey("value", data);
			else
				preValue:ShowWindow(1);
				preValue:SetTextByKey("value", data);
				rollbackCnt = rollbackCnt+1;
			end

			if 1 == curPage and i == 0 then
			button_1:ShowWindow(1);
				preValue:ShowWindow(0);
			button_1:SetUserValue("propName", info:GetPropName());
			button_1:SetUserValue("value", info.preValue);
			button_1:SetUserValue("RollBackCnt", rollbackCnt);
			button_1:SetUserValue("saveTime", info:GetSaveTime());
				button_1:SetTextByKey("value", data);
			end
		end
	end

	GBOX_AUTO_ALIGN(gBox, 5, 3, 10, true, false);

	-- 페이지 셋팅

	local pagecontrol = GET_CHILD(frame, 'pagecontrol', 'ui::CPageController')
	pagecontrol:SetMaxPage(maxPage);
	pagecontrol:SetCurPage(curPage-1);
end


function HISTORY_PAGE_SELECT_NEXT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage()+1;
	local maxPage = pageControl:GetMaxPage();
	if page+1 > maxPage then
		return;
	end
	local frame = pageControl:GetTopParentFrame();
	local seeStory = frame:GetUserIValue("historyType");
	session.playHistory.ReqPlayHistory(seeStory, page + 1);
end

function HISTORY_PAGE_SELECT_PREV(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage()+1;
	if 0 >= page -1 then
		return;
	end
	local frame = pageControl:GetTopParentFrame();
	local seeStory = frame:GetUserIValue("historyType");
	session.playHistory.ReqPlayHistory(seeStory, page - 1);
end

function HISTORY_PAGE_SELECT(pageControl, numCtrl)
	pageControl = tolua.cast(pageControl, "ui::CPageController");
	local page = pageControl:GetCurPage() + 1;
	local frame = pageControl:GetTopParentFrame();
	local seeStory = frame:GetUserIValue("historyType");
	session.playHistory.ReqPlayHistory(seeStory, page);
end

function HISTORY_TAB_CHANGE(frame, ctrl, argStr, argNum)

	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	HISTORY_DATA_VIEW(frame, curtabIndex);
end

function HISTORY_DATA_VIEW(frame, curtabIndex)
	session.playHistory.ReqPlayHistory(curtabIndex, 1);
end

function HISTORY_REQ_ROLL_BACK(frame, btn)
	local parent = frame:GetTopParentFrame();
	ReserveScript("HISTORY_REQ_ROLL_BACK_BTN_ENALBE()", 3);
	-- 연타방지
	if 1 == parent:GetUserIValue("Enable") then
		ui.SysMsg(ClMsg("Auto_JamSi_Hu_DaSi_SiDoHae_JuSeyo."));	
		return;
	end

	parent:SetUserValue("Enable", 1);

	local accountObj = GetMyAccountObj();
	local rollBackCnt = btn:GetUserIValue("RollBackCnt");
	local saveDBTime = btn:GetUserValue("saveTime");
	local isFree = btn:GetTextByKey("value");
	
	
	if isFree == ClMsg("IsFree") then
		session.playHistory.ReqDataRollBack(parent:GetUserIValue("historyType"), btn:GetUserValue("propName"), btn:GetUserIValue("value"));
		return;
	end

	local diff = GetDBTimeDiff(saveDBTime);
	if FREE_RESPECT_TIME < diff then
		-- 현재는 리스펙 횟수에 따라 메달을 차감하는데 이공식이 어떻게 바뀔지모르겠다.
		-- 어떻게 해야 확장적일까
		if  0 > GET_CASH_POINT_C() - rollBackCnt then
			ui.SysMsg(ClMsg("NotEnoughMedal"));	
			return;
		end
	end
	session.playHistory.ReqDataRollBack(parent:GetUserIValue("historyType"), btn:GetUserValue("propName"), btn:GetUserIValue("value"));
end

function HISTORY_REQ_ROLL_BACK_BTN_ENALBE()
	local frame = ui.GetFrame("history")
	frame:SetUserValue("Enable", 0);
end]]--