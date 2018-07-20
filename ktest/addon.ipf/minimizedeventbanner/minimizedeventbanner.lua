function MINIMIZEDEVENTBANNER_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZEDEVENTBANNER_MSG');
end

function MINIMIZEDEVENTBANNER_MSG(frame, msg, argStr, argNum)
	if frame == nil then
		frame = ui.GetFrame('minimizedeventbanner');
	end	
	local bannerList, bannerCnt = GetClassList("event_banner")	

	local eventBannerCnt = 0
	for i = 0, bannerCnt - 1 do
		local banner = GetClassByIndexFromList(bannerList, i);
		
		local remainStartTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.StartTimeYYYYMM, banner.StartTimeDDHHMM)
		local remainEndTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.EndTimeYYYYMM, banner.EndTimeDDHHMM)
		local remainExchangeTime = CHECK_EVENTBANNER_REMAIN_TIME(banner.ExchangeTimeYYYYMM, banner.ExchangeTimeDDHHMM)

		if remainStartTime ~= nil and remainStartTime < 0 then
				
			if remainEndTime ~= nil and remainEndTime >= 0 then
				eventBannerCnt = eventBannerCnt + 1
			elseif remainEndTime ~= nil and remainEndTime < 0 then
				if remainExchangeTime ~= nil and remainExchangeTime >= 0 then
					eventBannerCnt = eventBannerCnt + 1
				end
			end
		end	
	end

	if eventBannerCnt == 0 then
		frame:ShowWindow(0)
	else
		frame:ShowWindow(1)
	end

end

function OPEN_INGAME_EVENTBANNER_FRAME(frame)
	ui.OpenFrame("ingameeventbanner");
end
