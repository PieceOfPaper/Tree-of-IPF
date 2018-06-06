-- ingameeventbanner.lua


function INGAMEEVENTBANNER_ON_INIT(addon, frame)
--	addon:RegisterMsg("MSG_UPDATE_EVENTBANNER_UI", "EVENTBANNER_FRAME_OPEN");
	addon:RegisterMsg("DO_OPEN_EVENTBANNER_UI", "EVENTBANNER_FRAME_OPEN");
end

function EVENTBANNER_FRAME_OPEN(frame)
	ui.OpenFrame("ingameeventbanner")
	UPDATE_EVENTBANNER_UI(frame)
end

function EVENTBANNER_FRAME_CLOSE(frame)
	
end


function SHOW_REMAIN_BANNER_TIME(ctrl)
	local curIndex = ctrl:GetUserIValue("curIndex")
	local banner = GetClassByIndex('event_banner', curIndex)
	local remainEndTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.EndTimeYYYYMM, banner.EndTimeDDHHMM)	
	local remainExchangeTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.ExchangeTimeYYYYMM, banner.ExchangeTimeDDHHMM)
	local flag = 0;
	if remainEndTime == nil or 0 > remainEndTime then
		
		if remainExchangeTime == nil or 0 > remainExchangeTime then
			ctrl:SetTextByKey("remainTime", ScpArgMsg("ThisIsEndedEvent"));
			ctrl:SetFontName("red_18");
			ctrl: StopUpdateScript("SHOW_REMAIN_BANNER_TIME");
	
			return 0;
		end
		flag = 1
	end

	local timeTxt = '';	
	if flag == 0 then
		timeTxt = GET_TIME_TXT_DHM(remainEndTime);
	elseif flag == 1 then
		timeTxt = GET_TIME_TXT_DHM(remainExchangeTime);
	end

	ctrl:SetTextByKey("remainTime", timeTxt);

	return 1;
end


function UPDATE_EVENTBANNER_UI(frame)
	if frame == nil then
		frame = ui.GetFrame('ingameeventbanner');
	end	

	local bannerCtrlIndex = 0
	local bannerList, bannerCnt = GetClassList("event_banner")
	
	local bannerBox = GET_CHILD_RECURSIVELY(frame, 'bannerGbox');
	bannerBox = tolua.cast(bannerBox, "ui::CGroupBox");
	DESTROY_CHILD_BYNAME(bannerBox, "event_banner_");
	for i = 0, bannerCnt - 1 do
		local banner = GetClassByIndex('event_banner', i)
		local bannerCtrl = bannerBox:CreateOrGetControlSet('ingame_event_banner', 'event_banner_' .. bannerCtrlIndex, 0, 180 * bannerCtrlIndex);
		bannerCtrl:SetUserValue("bannerIndex", i)
	
		local bannerImage = GET_CHILD_RECURSIVELY(bannerCtrl, 'banner');
		bannerImage = tolua.cast(bannerImage, "ui::CPicture");
		bannerImage:SetImage(banner.ImagePath)
		bannerImage:SetTextTooltip(banner.Name)
		
		local time_limited_bg = GET_CHILD_RECURSIVELY(bannerCtrl, "time_limited_bg");
		local time_limited_text = GET_CHILD_RECURSIVELY(bannerCtrl, "time_limited_text");
		time_limited_text:SetUserValue("curIndex", i)
		time_limited_text:RunUpdateScript("SHOW_REMAIN_BANNER_TIME");
		
		local new_ribbon = GET_CHILD_RECURSIVELY(bannerCtrl, "new_ribbon");
		local deadline_ribbon = GET_CHILD_RECURSIVELY(bannerCtrl, "deadline_ribbon");
		local exchange_ribbon = GET_CHILD_RECURSIVELY(bannerCtrl, "exchange_ribbon");
		new_ribbon:SetVisible(0);
		deadline_ribbon:SetVisible(0);
		exchange_ribbon:SetVisible(0);

	
		--endTime 이 있어야 exchange 부르고, endtime 있는데 exchange없으면 endtime 만 지나도 안보이게하고
		local remainStartTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.StartTimeYYYYMM, banner.StartTimeDDHHMM)
		if remainStartTime ~= nil and remainStartTime < 0 then
			local remainNewTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.NewTimeYYYYMM, banner.NewTimeDDHHMM)
			local remainDeadlineTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.DeadlineTimeYYYYMM, banner.DeadlineTimeDDHHMM)
			local remainEndTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.EndTimeYYYYMM, banner.EndTimeDDHHMM)
			local remainExchangeTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.ExchangeTimeYYYYMM, banner.ExchangeTimeDDHHMM)

			if remainNewTime ~= nil and remainNewTime >= 0 then
				new_ribbon : SetVisible(1);
			else
				new_ribbon : SetVisible(0);
			end

			if remainDeadlineTime ~= nil and remainDeadlineTime <= 0 then
				deadline_ribbon : SetVisible(1);
			else
				deadline_ribbon : SetVisible(0);
			end
			
			if remainEndTime ~= nil and remainEndTime >= 0 then
				bannerCtrl:ShowWindow(1)
				--endtime ribbon, timer 넣자
				bannerCtrlIndex = bannerCtrlIndex + 1
			elseif remainEndTime ~= nil and remainEndTime < 0 then
				if remainExchangeTime ~= nil and remainExchangeTime >= 0 then
					bannerCtrl:ShowWindow(1)
					--exchangetime ribbon 넣자
					exchange_ribbon : SetVisible(1);
					bannerCtrlIndex = bannerCtrlIndex + 1
				else
					bannerCtrl:ShowWindow(0)
					bannerBox: RemoveChild('event_banner_' ..bannerCtrlIndex)
				end
			else
				bannerCtrl:ShowWindow(0)
				bannerBox: RemoveChild('event_banner_' ..bannerCtrlIndex)
			end
		else
			bannerCtrl:ShowWindow(0)
			bannerBox: RemoveChild('event_banner_' ..bannerCtrlIndex)
		end

	
	end
end

function CLICKED_EVENTBANNER(parent, ctrl)
	local bannerIndex = parent:GetUserIValue("bannerIndex")			
	local banner = GetClassByIndex('event_banner', bannerIndex)
	login.OpenURL(banner.url);
end

function CHECK_EVENTBANNER_REMAIN_TIME(timeYYYYMM, timeDDHHMM)

	if timeYYYYMM == nil or timeDDHHMM == nil then
		return nil;
	end

	if timeYYYYMM == "None" or timeDDHHMM == "None" then
		return nil;
	end

	if timeYYYYMM == 0 or timeDDHHMM == 0 then		
		return nil;
	end

	local targetTimeYYYYMM = tonumber(timeYYYYMM);
	local targetTimeDDHHMM = tonumber(timeDDHHMM);
	local targetTimeStr = string.format("%06d%01d%06d%02d", targetTimeYYYYMM, 0 , targetTimeDDHHMM, 00)
	local curTime = geTime.GetServerSystemTime();
	local curTimeYYYYMM = tonumber(string.format("%04d%02d", curTime.wYear, curTime.wMonth))
	local curTimeDDHHMM = tonumber(string.format("%02d%02d%02d", curTime.wDay, curTime.wHour, curTime.wMinute))
	local curTimeStr = string.format("%04d%02d%01d%02d%02d%02d%02d", curTime.wYear, curTime.wMonth, '0', curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)

	-- target time 에 startTime 를 넣으면 difSec(남은시간)이 음수, endTime, exchangeTime 을 넣으면 difSec 가 양수일것이다
	local targetSysTime = imcTime.GetSysTimeByStr(targetTimeStr)
	local curSysTime = imcTime.GetSysTimeByStr(curTimeStr)
	
	local difSec = imcTime.GetDifSec(targetSysTime, curSysTime);

	return difSec;
	
end


function TEST_OPEN_URLLL(parent, ctrl)
	local slot = tolua.cast(ctrl, 'ui::CSlot');
	local clickedIndex = slot:GetSlotIndex() + 1
	local clickedEventBanner = GetClassByIndex('event_banner', clickedIndex)

	login.OpenURL(clickedEventBanner.url);
end

function SCP_LBTDOWN_EVENTBANNER(frame, ctrl)
	
	ui.EnableSlotMultiSelect(1);

end

function EXECUTE_EVENTBANNER(frame)

	session.ResetItemList();

	local totalprice = 0;

	local slotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg("SelectSomeItemPlz"))
		return;
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();
		
		local  cnt = slot:GetSelectCount();
		session.AddItemID(iconInfo:GetIESID(), cnt );
	end

	local msg = ScpArgMsg('AreYouSerious')
	ui.MsgBox(msg, 'EXECUTE_EVENTBANNER_COMMIT', "None");
end

function EXECUTE_EVENTBANNER_COMMIT()

	local resultlist = session.GetItemIDList();

	item.DialogTransaction("EVENTBANNER", resultlist);
end

function SET_EVENTBANNER_CARD_COMMIT(slotname, type)

	local resultlist = session.GetItemIDList();

	local iType = 1;
	if "UnEquip" == type then
		iType = 0;
	end

	local argStr = string.format("%s %s", slotname, iType);
--	item.DialogTransaction("SET_POISON_CARD", resultlist, argStr); 

end

function EVENTBANNER_HUD_CONFIG_CHANGE(frame)
    EVENTBANNER_HUD_CHECK_VISIBLE();
end

function EVENTBANNER_CHECK_OPEN(propname, propvalue)

end