-- tpitem.lua : (tp shop)

local eventUserType = {
	normalUser = 0,		-- 일반
	returnUser = 1, -- 복귀유저
	newbie  = 2,	-- 신규
};


function TPITEM_ON_INIT(addon, frame)
   
	addon:RegisterMsg('TP_SHOP_UI_OPEN', 'TP_SHOP_DO_OPEN');
	addon:RegisterMsg("TPSHOP_BUY_SUCCESS", "ON_TPSHOP_BUY_SUCCESS");
	addon:RegisterMsg("SHOP_BUY_LIMIT_INFO", "ON_SHOP_BUY_LIMIT_INFO");

	addon:RegisterMsg("SHOP_USER_INFO", "ON_SHOP_USER_INFO"); 
	
	if (config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP") then
	addon:RegisterMsg("UPDATE_INGAME_SHOP_ITEM_LIST", "TPITEM_DRAW_NC_TP");
	addon:RegisterMsg("UPDATE_INGAME_SHOP_REMAIN_CASH", "TPSHOP_CHECK_REMAIN_NEXONCASH");
	addon:RegisterMsg("UPDATE_INGAME_SHOP_CASHINVEN", "TPSHOP_SHOW_CASHINVEN_ITEMLIST");
	addon:RegisterMsg("UPDATE_INGAME_SHOP_PURCHASE_RESULT", "_TPSHOP_PURCHASE_RESULT");
	addon:RegisterMsg("UPDATE_INGAME_SHOP_REFUND_RESULT", "_TPSHOP_REFUND_RESULT");
	addon:RegisterMsg("UPDATE_INGAME_SHOP_PICKUP_RESULT", "_TPSHOP_PICKUP_RESULT");
	end

	addon:RegisterMsg("UPDATE_TPITEM_LIST_FOR_TAG", "_TPSHOP_TPITEM_SET_SPECIAL");
	addon:RegisterMsg("UPDATE_TPSHOP_BANNER", "_TPSHOP_BANNER");

	session.ui.Clear_NISMS_CashInven_ItemList();

	if (config.GetServiceNation() == "THI") then
		addon:RegisterMsg("NEXON_AMERICA_LIST", "ON_NEXON_AMERICA_LIST");
		addon:RegisterMsg("NEXON_AMERICA_SELLITEMLIST", "ON_NEXON_AMERICA_SELLITEMLIST");
		addon:RegisterMsg("NEXON_AMERICA_BALANCE", "ON_NEXON_AMERICA_BALANCE");
		addon:RegisterMsg("NEXON_AMERICA_BALANCE_ENOUGH", "ON_NEXON_AMERICA_BALANCE_ENOUGH");
		addon:RegisterMsg("NEXON_AMERICA_BALANCE_NOT_ENOUGH", "ON_NEXON_AMERICA_BALANCE_NOT_ENOUGH");
	end
	
	local limitTime = TPSHOP_ISNEW_CHECK_TIME();	
	local tpitemframe = ui.GetFrame("tpitem");
	tpitemframe:SetUserValue("TPSHOP_LIMIT_TIMEDATE", limitTime);
end

function ON_SHOP_BUY_LIMIT_INFO(frame)	--해당 아이템에 대하여 월별 구매 제한 기능. 으로 추정
	TPSHOP_SORT_TAB(frame)
	TPSHOP_REDRAW_TPITEMLIST();
	
	local tabObj = GET_CHILD_RECURSIVELY(frame, 'shopTab');
	local itembox_tab = tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex = itembox_tab:GetSelectItemIndex();
	if curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox6") then -- 신규 유저 상점
		NEWBIE_CREATE_ITEM_LIST(frame);
	elseif curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox7") then -- 복귀 유저 상점
		RETURNUSER_CREATE_ITEM_LIST(frame);
	end
end

function ON_SHOP_USER_INFO(frame)
	TPSHOP_SORT_TAB(frame)
	
	if session.shop.GetEventUserType() ~= eventUserType.normalUser  then
		TPSHOP_EVENT_USER_TIMER_START(frame)		
	end

	local tabObj = GET_CHILD_RECURSIVELY(frame, 'shopTab');
	local itembox_tab = tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex = itembox_tab:GetSelectItemIndex();
	TPSHOP_TAB_VIEW(frame, curtabIndex); -- 배너 변경을 위해 호출
end

function TPSHOP_EVENT_USER_TIMER_UPDATE()
	local frame = ui.GetFrame("tpitem");
	if frame ~= nil then
		local eventUserRemainTimeText = GET_CHILD_RECURSIVELY(frame,"eventUserRemainTimeText");
		local timer = frame:GetChild("eventUserRemainTimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		local elapsedSeconds = 0;
		
		if session.shop.GetEventUserType() ~= eventUserType.normalUser then
			local endTime = session.shop.GetEventUserEndTime()
			local endTimeStamp = os.time({year = endTime.wYear, month = endTime.wMonth, day = endTime.wDay, hour = endTime.wHour, min = endTime.wMinute, sec = endTime.wSecond})
			elapsedSeconds = endTimeStamp - os.time(os.date('*t'));
		end

		if session.shop.GetEventUserType() == eventUserType.normalUser or elapsedSeconds <= 0 then
			session.shop.RequestEventUserTypeInfo(); -- 신규/복귀/일반 변경정보 요청.
			eventUserRemainTimeText:SetVisible(0);
			timer:Stop(); 
		else
			eventUserRemainTimeText:SetTextByKey("countdown", GET_TIMESTAMP_TO_COUNTDOWN_DATESTR(elapsedSeconds, {noSec = true}))
		end
	end
end

function TPSHOP_EVENT_USER_TIMER_START(frame)
	local timer = frame:GetChild("eventUserRemainTimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:Stop(); 
	timer:SetUpdateScript("TPSHOP_EVENT_USER_TIMER_UPDATE");
	timer:Start(1); 
end

function TPSHOP_REDRAW_ALIGN_LIST()
	local frame = ui.GetFrame("tpitem");
	if frame == nil then
		TPSHOP_REDRAW_TPITEMLIST()
		return
	end

	local tpitemtree = GET_CHILD_RECURSIVELY(frame, "tpitemtree");
	if tpitemtree == nil then
		TPSHOP_REDRAW_TPITEMLIST()
		return
	end

	local tnode = tpitemtree:GetLastSelectedNode();
	if tnode ~= nil then
		TPITEM_SELECT_TREENODE(tnode);
	else 
		TPSHOP_REDRAW_TPITEMLIST()
	end
end

function TPSHOP_REDRAW_TPITEMLIST()
	
	local frame = ui.GetFrame("tpitem");
	local category = frame:GetUserValue("LAST_OPEN_CATEGORY");
	local subcategory = frame:GetUserValue("LAST_OPEN_SUB_CATEGORY");	
	local showTypeList = GET_CHILD_RECURSIVELY(frame,"showTypeList");	
	local typeIndex = showTypeList:GetSelItemIndex();
	session.shop.RequestLoadShopBuyLimit();

	frame:SetUserValue("SHOWITEM_OPTION", typeIndex);	
	
	local tpitemtree = GET_CHILD_RECURSIVELY(frame, "tpitemtree");

	local tnode = tpitemtree:GetLastSelectedNode();
    local obj = nil;
    if tnode ~= nil then
	    obj = tnode:GetObject();
	    local parent_tnode = nil;
	    if obj == nil then
		    parent_tnode = tnode.pParentNode;
		    if parent_tnode ~= nil then			
			    obj = parent_tnode:GetObject();		
		    end
	    end
    end

	if obj ~= nil then
		local gBox = obj:GetChild("group");
		gBox:SetSkinName("baseyellow_btn");
	end

	tpitemtree:CloseNodeAll();
	frame:SetUserValue("LAST_OPEN_SUB_CATEGORY", "None");	
	frame:SetUserValue("SHOWITEM_OPTION", typeIndex);	
	
	TPITEM_DRAW_ITEM_WITH_CATEGORY(frame, category, subcategory, 1, 0, nil, typeIndex);
	
end

function TPSHOP_GET_INDEX_BY_TAB_NAME(name)
	local frame = ui.GetFrame("tpitem");
	local tabObj = GET_CHILD_RECURSIVELY(frame, 'shopTab');
	local itembox_tab = tolua.cast(tabObj, "ui::CTabControl");
	return itembox_tab:GetIndexByName(name);
end

function TPSHOP_TAB_CHANGE(frame, ctrl, argStr, argNum)
	local tabObj		    = frame:GetChild('shopTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	TPSHOP_TAB_VIEW(frame, curtabIndex);
end

function TPITEM_OPEN(frame)
	-- 자동매칭중이면 간소화!
	local indunenter = ui.GetFrame('indunenter');
	if indunenter ~= nil and indunenter:IsVisible() == 1 then
		INDUNENTER_SMALL(indunenter, nil, true);
	end

	if (config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP") then
		if 0 == IsMyPcGM_FORNISMS() then
			local btn1 = GET_CHILD_RECURSIVELY(frame,"ncReflashbtn")
			local btn2 = GET_CHILD_RECURSIVELY(frame,"ncChargebtn")
			btn1:SetEnable(0)
			btn2:SetEnable(0)
		end
	end

	RECYCLE_MAKE_TREE(frame);
	COSTUME_EXCHANGE_MAKE_TREE(frame);
	NEWBIE_MAKE_TREE(frame);
	RETURNUSER_MAKE_TREE(frame);
end

function TPSHOP_TAB_VIEW(frame, curtabIndex)
	local frame = ui.GetFrame("tpitem");
	local rightFrame = frame:GetChild('rightFrame');
	local rightgbox = rightFrame:GetChild('rightgbox');
	local basketgbox = rightgbox:GetChild('basketgbox');
	local previewgbox = rightgbox:GetChild('previewgbox');
	local previewStaticTitle = rightgbox:GetChild('previewStaticTitle');
	local cashInvGbox = rightgbox:GetChild('cashInvGbox');	
	local screenbgTemp = frame:GetChild('screenbgTemp');
	local ncChargebtn = rightgbox:GetChild('ncChargebtn');
	screenbgTemp:ShowWindow(0);
	local tpSubgbox = GET_CHILD_RECURSIVELY(frame,"tpSubgbox");
	local rcycle_basketgbox = GET_CHILD_RECURSIVELY(frame,'rcycle_basketgbox');
	local rcycle_toitemBtn = GET_CHILD_RECURSIVELY(frame, 'rcycle_toitemBtn');
	local costume_exchange_basketgbox =  GET_CHILD_RECURSIVELY(frame,'costume_exchange_basketgbox');
	local costume_exchange_toitemBtn=  GET_CHILD_RECURSIVELY(frame,'costume_exchange_toitemBtn');
	local basketBuyBtn = GET_CHILD_RECURSIVELY(frame, 'basketBuyBtn');
	local newbie_basketgbox =  GET_CHILD_RECURSIVELY(frame,'newbie_basketgbox');
	local newbie_toitemBtn=  GET_CHILD_RECURSIVELY(frame,'newbie_toitemBtn');
	local returnuser_basketgbox =  GET_CHILD_RECURSIVELY(frame,'returnuser_basketgbox');
	local returnuser_toitemBtn=  GET_CHILD_RECURSIVELY(frame,'returnuser_toitemBtn');
	-- 배너
	local banner = GET_CHILD_RECURSIVELY(frame,"banner");
	local eventUserBanner = GET_CHILD_RECURSIVELY(frame,"eventUserBanner");
	local eventUserRemainTimeText = GET_CHILD_RECURSIVELY(frame,"eventUserRemainTimeText");

	eventUserBanner:SetVisible(0);
	eventUserRemainTimeText:SetVisible(0);

	basketBuyBtn:SetEnable(0);
	rcycle_toitemBtn:SetEnable(0);
	costume_exchange_toitemBtn:SetEnable(0);
	newbie_toitemBtn:SetEnable(0);
	returnuser_toitemBtn:SetEnable(0);

	previewgbox:SetVisible(0);
	previewStaticTitle:SetVisible(0);	
	cashInvGbox:SetVisible(0);
	basketgbox:SetVisible(0);
	rcycle_basketgbox:SetVisible(0);
	costume_exchange_basketgbox:SetVisible(0);
	newbie_basketgbox:SetVisible(0);
	returnuser_basketgbox:SetVisible(0);

	ncChargebtn:SetVisible(1); -- 캐시 충전은 기본 활성화.
	banner:SetVisible(1); -- 배너는 기본적으로 활성화.
	
	if (1 == IsMyPcGM_FORNISMS()) and ((config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP")) then		
		if curtabIndex == 0 then
			TPITEM_DRAW_NC_TP();
			TPSHOP_SHOW_CASHINVEN_ITEMLIST();
			cashInvGbox:SetVisible(1);
			tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
			tpSubgbox:RunUpdateScript("_PROCESS_ROLLING_SPECIALGOODS",  3, 0, 1, 1);
		elseif curtabIndex == 1 then
			basketgbox:SetVisible(1);
			previewgbox:SetVisible(1);
			previewStaticTitle:SetVisible(1);
			basketBuyBtn:SetEnable(1);
		elseif curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox5") then -- 계열 코스튬 교환 샵
			costume_exchange_basketgbox:SetVisible(1);
			previewStaticTitle:SetVisible(1);	
			previewgbox:SetVisible(1);
			costume_exchange_toitemBtn:SetEnable(1);
			COSTUME_EXCHANGE_SHOW_TO_ITEM()
		elseif curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox3") then -- 리사이클 샵
			rcycle_basketgbox:SetVisible(1);
			previewStaticTitle:SetVisible(1);	
			previewgbox:SetVisible(1);
			rcycle_toitemBtn:SetEnable(1);
			RECYCLE_SHOW_TO_ITEM()
		elseif curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox6") then -- 신규 유저 상점
			banner:SetVisible(0); -- 기존 배너 비활성화 후 이벤트 상점 배너 활성화.
			eventUserBanner:SetVisible(1);
			eventUserRemainTimeText:SetVisible(1);
			previewStaticTitle:SetVisible(1);	
			previewgbox:SetVisible(1);
			newbie_basketgbox:SetVisible(1);
			newbie_toitemBtn:SetEnable(1);
			NEWBIE_SHOW_TO_ITEM()
		elseif curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox7") then -- 복귀 유저 상점
			banner:SetVisible(0); -- 기존 배너 비활성화 후 이벤트 상점 배너 활성화.
			eventUserBanner:SetVisible(1);
			eventUserRemainTimeText:SetVisible(1);
			previewStaticTitle:SetVisible(1);	
			previewgbox:SetVisible(1);
			returnuser_basketgbox:SetVisible(1);
			returnuser_toitemBtn:SetEnable(1);
			RETURNUSER_SHOW_TO_ITEM()
		end

		-- 이벤트 유저면 배너를 이벤트 유저 전용 배너로 변경
		if session.shop.GetEventUserType() ~= eventUserType.normalUser then
			banner:SetVisible(0)
			eventUserBanner:SetVisible(1)
			eventUserRemainTimeText:SetVisible(1)
		end
	elseif (config.GetServiceNation() == "THI") then	
		if curtabIndex == 0 then
			UPDATE_NEXON_AMERICA_SELLITEMLIST();
			TPSHOP_SHOW_CASHINVEN_ITEMLIST();
			ncChargebtn:SetVisible(0);
		elseif curtabIndex == 1 then
			basketgbox:SetVisible(1);
			previewgbox:SetVisible(1);
			previewStaticTitle:SetVisible(1);
			basketBuyBtn:SetEnable(1);
			ncChargebtn:SetVisible(0);
		elseif curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox3") then -- 리사이클 샵
			rcycle_basketgbox:SetVisible(1);
			previewStaticTitle:SetVisible(1);	
			previewgbox:SetVisible(1);
			rcycle_toitemBtn:SetEnable(1);
			ncChargebtn:SetVisible(0);
			RECYCLE_SHOW_TO_ITEM()
		end
	else
		if curtabIndex == 0 then
			basketgbox:SetVisible(1);
			previewgbox:SetVisible(1);
			previewStaticTitle:SetVisible(1);
			basketBuyBtn:SetEnable(1);
		elseif curtabIndex == TPSHOP_GET_INDEX_BY_TAB_NAME("Itembox3") then -- 리사이클 샵
			rcycle_basketgbox:SetVisible(1);
			previewStaticTitle:SetVisible(1);	
			previewgbox:SetVisible(1);
			rcycle_toitemBtn:SetEnable(1);
			RECYCLE_SHOW_TO_ITEM()
		end
	end
end

function TPSHOP_IS_EXIST_COSTUME_EXCHANGE_COUPON()
	local isCostumeExchangeCoupon = false;
	local CostumeExchangeCoupon = session.GetInvItemByName("Costume_Exchange_Coupon");
	if CostumeExchangeCoupon ~= nil and CostumeExchangeCoupon.count > 0 then
		isCostumeExchangeCoupon = true;
	end

	return isCostumeExchangeCoupon
end

function TPSHOP_SORT_TAB(frame)

	-- 프리미엄
	-- 리사이클
	-- 계열 코스튬
	-- 꾸미기
	-- 전용상점

	local shopTab = GET_CHILD_RECURSIVELY(frame, "shopTab");
	local itembox_tab = tolua.cast(shopTab, "ui::CTabControl");
	local itemCount = itembox_tab:GetItemCount();

	-- 1. 꾸미기를 리사이클 뒤로 이동시킴.
	local recycleTabIndex = itembox_tab:GetIndexByName("Itembox3") -- 리사이클샵
	local beautyshopTabIndex = itembox_tab:GetIndexByName("Itembox4");
	if recycleTabIndex ~= -1 and beautyshopTabIndex ~= -1 then
		if recycleTabIndex + 1 <= itemCount and recycleTabIndex + 1 ~= beautyshopTabIndex then
			itembox_tab:SwapTab(recycleTabIndex + 1, beautyshopTabIndex )
			frame:Invalidate();
		end
	end

	-- 2. 계열 코스튬 쿠폰 확인 후 뷰티샵 앞으로 이동. (뷰티샵 뒤에 탭하고 스왑후, 뷰티샵하고 스왑)
	local isExistCoupon = TPSHOP_IS_EXIST_COSTUME_EXCHANGE_COUPON()
	local costumeExchangeShopTabIndex = itembox_tab:GetIndexByName("Itembox5")
	if costumeExchangeShopTabIndex ~= -1 then
		if isExistCoupon == true then
			-- beuatyshop + 1위치와 스왑
			beautyshopTabIndex = itembox_tab:GetIndexByName("Itembox4");
			if beautyshopTabIndex + 1 <= itemCount then
				itembox_tab:SwapTab(costumeExchangeShopTabIndex, beautyshopTabIndex + 1 )
				frame:Invalidate();
			end
			-- 뷰티샵과 스왑
			costumeExchangeShopTabIndex = itembox_tab:GetIndexByName("Itembox5")
			if beautyshopTabIndex + 1 <= itemCount and costumeExchangeShopTabIndex ~= -1 then
				itembox_tab:SetTabVisible(costumeExchangeShopTabIndex, true)

				itembox_tab:SwapTab(costumeExchangeShopTabIndex, beautyshopTabIndex )
				frame:Invalidate();
			end
		else
			itembox_tab:SetTabVisible(costumeExchangeShopTabIndex, false)
		end
		
	end

	-- 3. 전용 상점 확인 후 뷰티샵 뒤로 붙임.
	local userType = session.shop.GetEventUserType()
	local newbieTabIndex = itembox_tab:GetIndexByName("Itembox6")
	local returnuserTabIndex = itembox_tab:GetIndexByName("Itembox7")
	beautyshopTabIndex = itembox_tab:GetIndexByName("Itembox4");

	-- 우선 둘다 숨김.
	if newbieTabIndex ~= -1 and returnuserTabIndex ~= -1 then	
		itembox_tab:SetTabVisible(newbieTabIndex, false)
		itembox_tab:SetTabVisible(returnuserTabIndex, false)
	end
	-- 타입에 따라 스왑후 보이기.
	if userType == eventUserType.newbie then
		if newbieTabIndex ~= -1 then
			-- 꾸미기 다음 슬롯이 자신이면 무시
			if newbieTabIndex ~= beautyshopTabIndex +1 then
				-- 꾸미기 다음 index와 스왑. 
				if itemCount >= beautyshopTabIndex +1 then 
					itembox_tab:SwapTab(newbieTabIndex, beautyshopTabIndex +1 )
					frame:Invalidate();
				end
			end
			newbieTabIndex = itembox_tab:GetIndexByName("Itembox6")
			if newbieTabIndex ~= -1 then
				itembox_tab:SetTabVisible(newbieTabIndex, true)
			end
		end
	
	 elseif userType == eventUserType.returnUser then
		if returnuserTabIndex ~= -1 then
			-- 꾸미기 다음 슬롯이 자신이면 무시
			if returnuserTabIndex ~= beautyshopTabIndex +1 then
				-- 꾸미기 다음 index와 스왑. 
				if itemCount >= beautyshopTabIndex +1 then 
					itembox_tab:SwapTab(returnuserTabIndex, beautyshopTabIndex +1 )
					
					frame:Invalidate();
				end
			end			
			returnuserTabIndex = itembox_tab:GetIndexByName("Itembox7")
			if returnuserTabIndex ~= -1 then
				itembox_tab:SetTabVisible(returnuserTabIndex, true)
			end
		end
	end
end

function TP_SHOP_DO_OPEN(frame, msg, shopName, argNum)
	ui.CloseAllOpenedUI();
	ui.OpenIngameShopUI();	-- Tpshop을 열었을때에 Tpitem에 대한 정보와 NexonCash 정보 등을 서버에 요청한다.

	-- 탭정렬 먼저 한번 하고 요청.
	TPSHOP_SORT_TAB(frame)
	-- 요청
	session.shop.RequestLoadShopBuyLimit();
	session.shop.RequestEventUserTypeInfo(); -- 신규/복귀/일반 변경정보 요청.

	frame:ShowWindow(1);
	local leftgFrame = frame:GetChild("leftgFrame");	
	local leftgbox = leftgFrame:GetChild("leftgbox");
	local rightFrame = frame:GetChild('rightFrame');
	local rightgbox = rightFrame:GetChild('rightgbox');
	local shopTab = leftgbox:GetChild('shopTab');
	local itembox_tab = tolua.cast(shopTab, "ui::CTabControl");

	if (1 == IsMyPcGM_FORNISMS()) and ((config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP")) then		
		local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
		banner:SetImage("market_event_test");	--market_default
		banner:SetUserValue("URL_BANNER", "");
		banner:SetUserValue("NUM_BANNER", 0);
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");	
	elseif config.GetServiceNation() == "THI" then 
		local banner_offset_y = frame:GetUserConfig("banner_offset_y")
		local balance_resize_width = frame:GetUserConfig("balance_resize_width")
		local balance_offset_y = frame:GetUserConfig("balance_offset_y")
		local refresh_offset_x = frame:GetUserConfig("refresh_offset_x")
		local balance_resize_height = frame:GetUserConfig("balance_resize_height")

		local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
		banner:SetImage("market_event_test");	--market_default
		banner:SetUserValue("URL_BANNER", "");
		banner:SetUserValue("NUM_BANNER", 0);
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
		banner:SetOffset(banner:GetOriginalX(), banner:GetOriginalY()+banner_offset_y)

		local haveStaticNCbox = GET_CHILD_RECURSIVELY(frame,"haveStaticNCbox");	
		haveStaticNCbox:SetText("  Total          {img THB_cash_mark 30 30}{/}{/}"); -- //memo nxa clientmessage
		haveStaticNCbox:SetOffset(haveStaticNCbox:GetOriginalX(), haveStaticNCbox:GetOriginalY()+balance_offset_y)
		haveStaticNCbox:Resize(haveStaticNCbox:GetOriginalWidth()+balance_resize_width, haveStaticNCbox:GetOriginalHeight()+balance_resize_height)
		local haveStaticNCbox_prepaid = GET_CHILD(rightgbox, 'haveStaticNCbox_prepaid');
		haveStaticNCbox_prepaid:SetVisible(1);
		haveStaticNCbox_prepaid:Resize(haveStaticNCbox_prepaid:GetOriginalWidth(), haveStaticNCbox_prepaid:GetOriginalHeight()+balance_resize_height)
		local haveStaticNCbox_credit = GET_CHILD(rightgbox, 'haveStaticNCbox_credit');
		haveStaticNCbox_credit:SetVisible(1);
		haveStaticNCbox_credit:Resize(haveStaticNCbox_credit:GetOriginalWidth(), haveStaticNCbox_credit:GetOriginalHeight()+balance_resize_height)
		local ncReflashbtn = GET_CHILD_RECURSIVELY(frame,"ncReflashbtn");	
		ncReflashbtn:SetOffset(ncReflashbtn:GetOriginalX()+refresh_offset_x, ncReflashbtn:GetOriginalY()+balance_offset_y)
	else
		local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
		banner:ShowWindow(0);
		local haveStaticNCbox = GET_CHILD_RECURSIVELY(frame,"haveStaticNCbox");	
		haveStaticNCbox:ShowWindow(0);
		local ncReflashbtn = GET_CHILD_RECURSIVELY(frame,"ncReflashbtn");	
		ncReflashbtn:ShowWindow(0);
		local ncChargebtn = GET_CHILD_RECURSIVELY(frame,"ncChargebtn");	
		ncChargebtn:ShowWindow(0);
		local remainNexonCash = GET_CHILD_RECURSIVELY(frame,"remainNexonCash");	
		remainNexonCash:ShowWindow(0);
		local ncReflashbtn = GET_CHILD_RECURSIVELY(frame,"ncReflashbtn");	
		ncReflashbtn:ShowWindow(0);
		
		if itembox_tab:GetItemCount() == 3 then
			itembox_tab:DeleteTab(0);
			itembox_tab:SetItemsFixWidth(170);
		end
	end
	
	MAKE_CATEGORY_TREE();
	
	frame:SetUserValue("CASHINVEN_PAGENUMBER", 1);

	local screenbgTemp = GET_CHILD_RECURSIVELY(frame, 'screenbgTemp');
	screenbgTemp:ShowWindow(0);
	
	--buyBtn = GET_CHILD_RECURSIVELY(frame,"specialBuyBtn");	
	--buyBtn:ShowWindow(0);
	
	local ratio = option.GetClientHeight()/option.GetClientWidth();	
	local limitMaxWidth = ui.GetSceneWidth() / ui.GetRatioWidth();
	local limitMaxHeight = limitMaxWidth * ratio;
	
	if limitMaxWidth < option.GetClientWidth() then
		limitMaxWidth = option.GetClientWidth();
	end
	
	local div = 2;
	if limitMaxHeight < option.GetClientHeight() then
		limitMaxHeight = option.GetClientHeight();
		div = 6;
	end
	frame:Resize(0,0 , limitMaxWidth * 1.2, limitMaxHeight * 1.2);	
	
	--session.shop.RequestLoadShopBuyLimit();
	SET_TOPMOST_FRAME_SHOWFRAME(0);	
	
	itembox_tab:SelectTab(1);
	TPSHOP_TAB_VIEW(frame, 1);
	
	local input = GET_CHILD_RECURSIVELY(frame, "input");
	local editDiff = GET_CHILD_RECURSIVELY(frame, "editDiff");
	input:ClearText();
	editDiff:SetVisible(1);
		
	local basketslotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")	
	TPITEM_CLEAR_SLOTSET(basketslotset);

	local newbie_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"newbie_basketbuyslotset")	
	TPITEM_CLEAR_SLOTSET(newbie_basketbuyslotset);
	local returnuser_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"returnuser_basketbuyslotset")	
	TPITEM_CLEAR_SLOTSET(returnuser_basketbuyslotset);

	local rcycle_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketbuyslotset")
	rcycle_basketbuyslotset:ClearIconAll();
	local rcycle_basketsellslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset")
	rcycle_basketsellslotset:ClearIconAll();
	
	local specialGoods = GET_CHILD_RECURSIVELY(frame,"specialGoods");	
	specialGoods:SetImage("market_default4");
		
	local basketTP = GET_CHILD_RECURSIVELY(frame,"basketTP")
	basketTP:SetText(tostring(0))	

	ON_TPSHOP_RESET_PREVIEWMODEL();	
	
	local tpPackageGbox = GET_CHILD_RECURSIVELY(frame,"tpPackageGbox");		
	tpPackageGbox:ShowWindow(0);	

	--ui.SetHoldUI(frame:GetName());
	UPDATE_BASKET_MONEY(frame);
	UPDATE_RECYCLE_BASKET_MONEY(frame,"sell");
	
	local rightFrame = frame:GetChild('rightFrame');
	local leftgFrame = frame:GetChild("leftgFrame");	
	local leftgbox = leftgFrame:GetChild("leftgbox");
	local alignmentgbox = GET_CHILD(leftgbox,"alignmentgbox");				
	local alignTypeList = GET_CHILD_RECURSIVELY(frame,"alignTypeList");	
	local showTypeList = GET_CHILD_RECURSIVELY(frame,"showTypeList");	
	showTypeList:ClearItems();

	local resol = math.floor((limitMaxHeight - leftgFrame:GetHeight()) / div);
	if resol < 0  then
		resol = 0;
	end
	
	--leftgFrame:SetOffset(leftgFrame:GetOffsetX(), resol);
	--rightFrame:SetOffset(rightFrame:GetOffsetX(), resol);

	for i = 0 , 3 do
	local resString = string.format("{@st42b}{s16}%s{/}", ScpArgMsg("SHOWLIST_ITEM_TYPE_" .. i));
		showTypeList:AddItem(i, resString);
	end
	showTypeList:SelectItem(0);

	local alignTypeList = GET_CHILD_RECURSIVELY(frame,"alignTypeList");	
	alignTypeList:ClearItems();

	for i = 0 , 3 do
	local resString = string.format("{@st42b}{s16}%s{/}", ScpArgMsg("ALIGN_ITEM_TYPE_" .. i));
		alignTypeList:AddItem(i, resString);
	end
	alignTypeList:SelectItem(0);
	
	local tempGbox_for_scroll = GET_CHILD_RECURSIVELY(frame,"tempGbox_for_scroll")
	tempGbox_for_scroll:SetEventScript(ui.MOUSEWHEEL, "TPSHOP_PREVIEW_ZOOM");
end

function TPITEM_CLEAR_SLOTSET(slotset)
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot = slotset:GetSlotByIndex(i);
		slot:SetUserValue('TPITEMNAME', 'None');
	end
	slotset:ClearIconAll();
end

function SET_TOPMOST_FRAME_SHOWFRAME(show)
	local sysmenu = ui.GetFrame("sysmenu");
	local charbaseinfo = ui.GetFrame("charbaseinfo");
	local apps = ui.GetFrame("apps");
	sysmenu:ShowWindow(show);	
	charbaseinfo:ShowWindow(show);
	apps:ShowWindow(show);	
end

function ON_TPSHOP_BUY_SUCCESS(frame)
	local basketslotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	basketslotset:ClearIconAll();
	local rcycle_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketbuyslotset")
	rcycle_basketbuyslotset:ClearIconAll();
	local rcycle_basketsellslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset")
	rcycle_basketsellslotset:ClearIconAll();

	local costume_exchange_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"costume_exchange_basketbuyslotset")
	costume_exchange_basketbuyslotset:ClearIconAll();

	UPDATE_BASKET_MONEY(frame);
	UPDATE_RECYCLE_BASKET_MONEY(frame,"sell")	
	UPDATE_RECYCLE_BASKET_MONEY(frame,"buy")
	UPDATE_COSTUME_EXCHANGE_BASKET_MONEY(frame)
end

function ON_TPSHOP_RESET_PREVIEWMODEL()

	local frame = ui.GetFrame("tpitem");
	local previewslotset0 = GET_CHILD_RECURSIVELY(frame,"previewslotset0")
	local previewslotset1 = GET_CHILD_RECURSIVELY(frame,"previewslotset1")	-- 보류
		
	previewslotset0:ClearIconAll();
	previewslotset1:ClearIconAll();

	for j = 0, 1 do
		local slotset = GET_CHILD_RECURSIVELY(frame,"previewslotset" .. j);
		for i = 0, 2 do
			local slot  = slotset:GetSlotByIndex(i);
			if slot ~= nil then
				slot:SetUserValue("CLASSNAME", "None");
				slot:SetUserValue("TPITEMNAME", "None");
			end
		end
	end
	
	TPSHOP_SET_PREVIEW_APC_IMAGE(frame);

end

function TPITEM_ADD_CONTROL(obj, tpitemtree)
    local category  = obj.Category;
    local subcategory  = obj.SubCategory;
	local categoryCset = nil;
	categoryCset = GET_CHILD(tpitemtree, "TPSHOP_CT_" .. category )
	if categoryCset == nil then -- is equal tpitemtree:FindByName(ctrlSet:GetName()) == nil
	    categoryCset = tpitemtree:CreateControlSet("tpshop_tree", "TPSHOP_CT_" .. category, ui.LEFT, 0, 0, 0, 0, 0);
        local part = GET_CHILD(categoryCset, "part");
		part:SetTextByKey("value", ScpArgMsg(category));
		local foldimg = GET_CHILD(categoryCset,"foldimg");
		foldimg:ShowWindow(0);
    end

	local htreeitem = tpitemtree:FindByValue(category);
	local tempFirstValue = nil

	if tpitemtree:IsExist(htreeitem) == 0 then
	    htreeitem = tpitemtree:Add(categoryCset, category);
		tempFirstValue = tpitemtree:GetItemValue(htreeitem)	
    end
		
	local hsubtreeitem = tpitemtree:FindByCaption("{@st42b}"..ScpArgMsg(subcategory));
		
	if tpitemtree:IsExist(hsubtreeitem) == 0 and subcategory ~= "None" then

	    local added = tpitemtree:Add(htreeitem, "{@st66}"..ScpArgMsg(subcategory), category.."#"..subcategory, "{#000000}");
			
	    tpitemtree:SetFitToChild(true,10);
	    tpitemtree:SetFoldingScript(htreeitem, "KEYCONFIG_UPDATE_FOLDING");
	    local foldimg = GET_CHILD(categoryCset,"foldimg");
	    foldimg:ShowWindow(1);

	    tempFirstValue = tpitemtree:GetItemValue(added)
			
	end
end

function MAKE_CATEGORY_TREE()

	local frame = ui.GetFrame("tpitem")

	local categorySubGbox = GET_CHILD_RECURSIVELY(frame, "categorySubGbox")
	categorySubGbox:SetUserValue("CTRLNAME", "None");
	local tpitemtree = GET_CHILD(categorySubGbox, "tpitemtree")
	tpitemtree:Clear();
	DESTROY_CHILD_BYNAME(tpitemtree, "TPSHOP_CT_");

	local clsList, cnt = GetClassList('TPitem');	
	if cnt == 0 or clsList == nil then
		return;
	end

	local firstTreeItem = nil;
    local itemOnSale= {};
	for i = 0, cnt - 1 do
		local obj = GetClassByIndexFromList(clsList, i);

		if obj.Category == 'TP_Premium_Sale' then
            itemOnSale[#itemOnSale + 1] = obj;
	    else
            
            firstTreeItem = CREATE_TPITEM_TREE(obj, tpitemtree, i, firstTreeItem);
        end
	end
    --할인카테고리 추가
    for i = 1, #itemOnSale do
        firstTreeItem = CREATE_TPITEM_TREE(itemOnSale[i], tpitemtree, i, firstTreeItem);
    end
	tpitemtree:Select(firstTreeItem);
	local tnode = tpitemtree:GetLastSelectedNode();
	TPITEM_SELECT_TREENODE(tnode);	
end

function CREATE_TPITEM_TREE(obj, tpitemtree, i, firstTreeItem)
    local category  = obj.Category;
	local subcategory  = obj.SubCategory;
	local categoryCset = nil;
	categoryCset = GET_CHILD(tpitemtree, "TPSHOP_CT_" .. category )
	if categoryCset == nil then -- is equal tpitemtree:FindByName(ctrlSet:GetName()) == nil
	    categoryCset = tpitemtree:CreateControlSet("tpshop_tree", "TPSHOP_CT_" .. category, ui.LEFT, 0, 0, 0, 0, 0);
        local part = GET_CHILD(categoryCset, "part");
		part:SetTextByKey("value", ScpArgMsg(category));
		local foldimg = GET_CHILD(categoryCset,"foldimg");
		foldimg:ShowWindow(0);
    end

	local htreeitem = tpitemtree:FindByValue(category);
	local tempFirstValue = nil

	if tpitemtree:IsExist(htreeitem) == 0 then
	    htreeitem = tpitemtree:Add(categoryCset, category);
		tempFirstValue = tpitemtree:GetItemValue(htreeitem)	
    end
	
	local hsubtreeitem = tpitemtree:FindByCaption("{@st42b}"..ScpArgMsg(subcategory));
		
	if tpitemtree:IsExist(hsubtreeitem) == 0 and subcategory ~= "None" then

		local added = tpitemtree:Add(htreeitem, "{@st66}"..ScpArgMsg(subcategory), category.."#"..subcategory, "{#000000}");
			
		tpitemtree:SetFitToChild(true,10);
		tpitemtree:SetFoldingScript(htreeitem, "KEYCONFIG_UPDATE_FOLDING");
		local foldimg = GET_CHILD(categoryCset,"foldimg");
		foldimg:ShowWindow(1);

		tempFirstValue = tpitemtree:GetItemValue(added)
			
    end
		
	if i == 0 then
        return htreeitem;
    end
    return firstTreeItem;
end

function TPITEM_CLOSE(frame)
	local tpSubgbox = GET_CHILD_RECURSIVELY(frame,"tpSubgbox");	
	tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");

	if (1 == IsMyPcGM_FORNISMS()) and (config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP") then
		local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
		banner:SetUserValue("URL_BANNER", "");
		banner:SetUserValue("NUM_BANNER", 0);
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
	elseif (config.GetServiceNation() == "THI") then
		local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
		banner:SetUserValue("URL_BANNER", "");
		banner:SetUserValue("NUM_BANNER", 0);
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
	end
	
	SET_TOPMOST_FRAME_SHOWFRAME(1);
	session.ui.Clear_NISMS_ItemList();
	ui.OpenAllClosedUI();

	session.ui.Clear_NISMS_CashInven_ItemList();	

	local timer = GET_CHILD_RECURSIVELY(frame, "eventUserRemainTimer")
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:Stop();

	ui.CloseFrame("recycleshop_popupmsg");
	ui.CloseFrame("costume_exchangeshop_popupmsg")
	ui.CloseFrame("tpitem_popupmsg");
	ui.CloseFrame('packagelist');
end

-- 분류에 따라 항목의 아이템들을 그리기 설정
function CHECK_SUBCATEGORY_N_DRAW_ITEMS(frame, value, initDraw, isSub)
	if value ~= nil  then
		local tpitemtree = GET_CHILD_RECURSIVELY(frame, "tpitemtree");
		local sList = StringSplit(value, "#");
		if #sList <= 0 then
			return;
		elseif #sList == 1 then -- 서브카테고리 없음. 그냥 열어라.

			local htreeitem = tpitemtree:FindByValue(value);	
			if tpitemtree:IsExist(htreeitem) == 1 then				
				if tpitemtree:GetChildItemCount(htreeitem) < 1 then
					TPITEM_DRAW_ITEM_WITH_CATEGORY(frame, sList[1], "None", initDraw, isSub)
				end
			end
		elseif #sList == 2 then
		
			-- 서브카테고리 포함해서 열어라
			TPITEM_DRAW_ITEM_WITH_CATEGORY(frame, sList[1], sList[2], initDraw, isSub)
		end
	end
end

-- 노드 선택에 따른 작동 분류 (버튼색과 아이템 그리기)
function TPITEM_SELECT_TREENODE(tnode)

	local frame = ui.GetFrame("tpitem");
	local categorySubGbox = GET_CHILD_RECURSIVELY(frame, "categorySubGbox");
	local tree = GET_CHILD_RECURSIVELY(frame, "tpitemtree");
	local obj = tnode:GetObject();
	
	if obj ~= nil then
		-- 상위항목 클릭시에 대한 그의 하위항목들의 모든 아이템들을 그리기
		local cnt = tnode:GetChildNodeCount();		
		for i = 0, cnt - 1 do
			local tnodeChild = tnode:GetChildNodeByIndex(i);	
			if tnodeChild ~= nil then 	
				if i == 0 then			
					CHECK_SUBCATEGORY_N_DRAW_ITEMS(frame, tnodeChild:GetValue(), 1, 0);		
					tree:Select(tree:FindByValue(tnodeChild:GetValue()));
				end
			end;
		end;
		
		-- 상위 항목의 버튼 색 변경
		local gBox = obj:GetChild("group");
		gBox:SetSkinName("baseyellow_btn");
		tree:OpenNode(tnode, true, true);
	else	
		--검색결과 적용
		local input = GET_CHILD_RECURSIVELY(frame, "input");
		if input ~= nil then
			local inputTxt = input:GetText();
			if inputTxt ~= nil and string.len(inputTxt) > 0 then
				-- 검색했으면 검색 결과만 띄워준다
				local btn_find = GET_CHILD_RECURSIVELY(frame, "btn_find");
				TPSHOP_ITEMSEARCH_ENTER(frame, btn_find)
			else
				-- 하위항목 클릭시에 대한 그의 모든 아이템들을 그리기
				local selValue = tnode:GetValue();
				CHECK_SUBCATEGORY_N_DRAW_ITEMS(frame, selValue, 1, 1);
			end
		end
		
		-- 하위 항목의 상위 항목을 알아내야 한다. (현재 클릭된 하위 항목의 상위 항목 기억하기 위함)
		local parent_tnode = tnode.pParentNode;
		if parent_tnode == nil then
			return;
		end
		obj = parent_tnode:GetObject();		

		-- 상위 항목의 버튼 색 변경
		local gBox = obj:GetChild("group");
		gBox:SetSkinName("baseyellow_btn_cursoron");
	end
	
	-- 이전에 클릭된 다른 상위 버튼이 자신의 상위 버튼과 다를 경우, 이전 클릭된 버튼 스킨 변경시켜주기
	
	local btnName = categorySubGbox:GetUserValue("CTRLNAME");
	if ("None" ~= btnName) and (btnName ~= nil) then	-- 하위 항목을 "None"이다.
		if btnName ~= obj:GetName() then
			local htreeitem = tree:FindByName(btnName);
			local oldObj = tree:GetNodeObject(htreeitem);
			local gBox = oldObj:GetChild("group");
			gBox:SetSkinName("base_btn");
			tree:ShowTreeNode(htreeitem, 0);
		end;
	end;

	-- 현재 클릭된 하위 항목의 상위 항목 기억하기
	categorySubGbox:SetUserValue("CTRLNAME", obj:GetName());
	tree:InvalidateTree();
end

--TP상점의 카테고리 트리에서 항목 클릭시
function TPITEM_TREE_CLICK(parent, ctrl, str, num)
	local tree = AUTO_CAST(ctrl);
	local tnode = tree:GetLastSelectedNode();
	if tnode == nil then
		return;
	end

	-- 버튼분류 및 그리기
	RESET_SORTLIST_INPUT();
	TPITEM_SELECT_TREENODE(tnode);	
end

function RESET_SORTLIST_INPUT()
	local parent = ui.GetFrame("tpitem");
	local input = GET_CHILD_RECURSIVELY(parent, "input");
	local showTypeList = GET_CHILD_RECURSIVELY(parent, "showTypeList");
	local alignTypeList = GET_CHILD_RECURSIVELY(parent, "alignTypeList");

	local inputTxt = input:GetText();
	if inputTxt ~= nil and string.len(inputTxt) > 0 then
		input:SetText("");
	end

	showTypeList:SelectItem(0);
	alignTypeList:SelectItem(0);
	
end

function IS_ITEM_WILL_CHANGE_APC(type)
	
	local item = GetClassByType("Item",type)

	local defaultEqpSlot = TryGetProp(item,'DefaultEqpSlot')

	if defaultEqpSlot == nil then
		return 0
	end

	local pc = GetMyPCObject();
	if pc == nil then
		return 0
	end

	local useGender = TryGetProp(item,'UseGender')

	if useGender =="Male" and pc.Gender ~= 1 then
		return 0
	end

	if useGender =="Female" and pc.Gender ~= 2 then
		return 0
	end
	

	if defaultEqpSlot == "RH" or defaultEqpSlot == "LH" or defaultEqpSlot == "HAT_L" or defaultEqpSlot == "HAT_T" or defaultEqpSlot == "HAIR" or defaultEqpSlot == "HAT" or defaultEqpSlot ==  "OUTER" or defaultEqpSlot ==  "ARMBAND" then
		return 1
	end

	return 0

end

--tp상점의 아이템들을 그리는 함수  
function TPITEM_DRAW_ITEM_WITH_CATEGORY(frame, category, subcategory, initdraw, isSub, filter, allFlag)
	local mainText = GET_CHILD_RECURSIVELY(frame,"mainText");
	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"mainSubGbox");
	local leftgFrame = frame:GetChild("leftgFrame");	
	local leftgbox = leftgFrame:GetChild("leftgbox");
	local bPass = false;

	if isSub == nil then
		mainText:ClearText();
		frame:SetUserValue("LAST_OPEN_CATEGORY", "None");
		frame:SetUserValue("LAST_OPEN_SUB_CATEGORY", "None");		
	elseif isSub == 0 then
		mainText:SetText(ScpArgMsg(category))
		frame:SetUserValue("LAST_OPEN_CATEGORY", category);
		frame:SetUserValue("LAST_OPEN_SUB_CATEGORY", "None");	
	elseif isSub == 1 then
		mainText:SetText(ScpArgMsg(category).." > "..ScpArgMsg(subcategory))
		frame:SetUserValue("LAST_OPEN_CATEGORY", category);
		frame:SetUserValue("LAST_OPEN_SUB_CATEGORY", subcategory);	
	elseif isSub == 2 then
		if subcategory ~= "None" then
			mainText:SetText(ScpArgMsg(category).." > "..ScpArgMsg(subcategory));
		elseif category ~= "None" then
			mainText:SetText(ScpArgMsg(category));
			bPass = true;
		else			
			local input = GET_CHILD_RECURSIVELY(frame, "input");
			local searchFortext = input:GetText();
			if string.len(searchFortext) > 0 then
				filter = input:GetText();
			end
			mainText:ClearText();
		end
	end
	
	local index = 0;
	if initdraw == 1 then
		-- 초기화
		DESTROY_CHILD_BYNAME(mainSubGbox, "eachitem_");
		frame:SetUserValue("CHILD_ITEM_INDEX", index);
	else
		-- 처음이 아니라면 현재 마지막의 인덱스의 다음부터
		index = frame:GetUserIValue("CHILD_ITEM_INDEX");	
	end
	
	local clsList, cnt = GetClassList('TPitem');	
	if cnt == 0 or clsList == nil then
		return;
	end

	local x, y;
	local alignmentgbox = GET_CHILD(leftgbox,"alignmentgbox");	
	-- 해당 카테고리의 노드들의 프레임을 만들기.
	for i = 0, cnt - 1 do
		local obj = GetClassByIndexFromList(clsList, i);
		local itemobj = GetClass("Item", obj.ItemClassName)
		local isFounded = false;
    if itemobj == nil then
      IMC_LOG("INFO_NORMAL", "ItemClassName not found in item.xml:TPITEM_DRAW_ITEM_WITH_CATEGORY. obj.ItemClassName:" ..obj.ItemClassName);
    else
		  if filter ~= nil then
			  local targetItemName = itemobj.Name;			
			  if config.GetServiceNation() ~= "KOR" then
				  targetItemName = dic.getTranslatedStr(targetItemName);				
			  end
			  local startNum, endNum = string.find(targetItemName, filter);
			  if (startNum ~= nil) or (endNum ~= nil) then
			  	isFounded = true;					
			  end
		  end
          local itemcset = nil;
		      if (allFlag == nil) then	
			      if CHECK_TPITEM_ENABLE_VIEW(obj) == true then
				      if ( ((obj.Category == category) and ((obj.SubCategory == subcategory) or (bPass == true))) or ((filter ~= nil) and (isFounded == true)) ) then			
					      if (TPSHOP_TPITEMLIST_TYPEDROPLIST(alignmentgbox,obj.ClassID) == true) then
					        index = index + 1
					        x = ( (index-1) % 3) * ui.GetControlSetAttribute("tpshop_item", 'width');
						    y = (math.ceil( (index / 3) ) - 1) * (ui.GetControlSetAttribute("tpshop_item", 'height') * 1)
                            itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_item', 'eachitem_'..index, x, y);                            
						    TPITEM_DRAW_ITEM_DETAIL(obj, itemobj, itemcset);
					      end
				      end
			      end
		      else
			      if (obj.Category == category) then
				      if CHECK_TPITEM_ENABLE_VIEW(obj) == true then
					      if (TPSHOP_TPITEMLIST_TYPEDROPLIST(alignmentgbox,obj.ClassID) == true) then			
						      index = index + 1
						      x = ( (index-1) % 3) * ui.GetControlSetAttribute("tpshop_item", 'width')
						      y = (math.ceil( (index / 3) ) - 1) * (ui.GetControlSetAttribute("tpshop_item", 'height') * 1)
						      itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_item', 'eachitem_'..index, x, y);
						      TPITEM_DRAW_ITEM_DETAIL(obj, itemobj, itemcset);
					      end
				      end
			      end
		      end
        end
	end

	--mainSubGbox:Resize(mainSubGbox:GetOriginalWidth(), y + ui.GetControlSetAttribute("tpshop_item", 'height'))
	
	--모든 아이템을 출력할때에 컨트롤셋 인덱스를 기억해냄.
	frame:SetUserValue("CHILD_ITEM_INDEX", index);
	TPSHOP_TPITEM_ALIGN_LIST(index);
	mainSubGbox:Invalidate()
	frame:Invalidate()
end

function GET_DATE_FROM_NEWTIME_FORMAT(date)
    local token = StringSplit(date, ' ')
    if #token ~= 2 then 
        ShowMessageBox('date and time format error')
        return
        -- error
    end

    local d = token[1]
    local d_token = StringSplit(d, '-')
    if #d_token ~= 3 then
        ShowMessageBox('date format error')
        return
        -- error
    end
    local year = tonumber(d_token[1])
    if year < 2000 then
        ShowMessageBox('year should be larger than in 2000')
        return
        -- error
    end

    local month = tonumber(d_token[2])
    if month < 1 or month > 12 then
        ShowMessageBox('month is out of bounds')
        return
        -- error
    end

    local day = tonumber(d_token[3])
    if day < 1 then
        ShowMessageBox('day is out of bounds')
        return
        -- error
    end

    local pivot_day = 0

    if month == 1 then
        pivot_day = 31    
    elseif month == 2 then
        local is_moreday = false
        if year % 4 == 0 then            
            is_moreday = true
        end
        if year % 100 == 0 then
            is_moreday = false
        end
        if year % 400 == 0 then
            is_moreday = true
        end
        
        if is_moreday == true then
            pivot_day = 29
        else
            pivot_day = 28
        end
    elseif month == 3 then
        pivot_day = 31
    elseif month == 4 then
        pivot_day = 30
    elseif month == 5 then
        pivot_day = 31
    elseif month == 6 then
        pivot_day = 30
    elseif month == 7 then
        pivot_day = 31
    elseif month == 8 then
        pivot_day = 31
    elseif month == 9 then
        pivot_day = 30
    elseif month == 10 then
        pivot_day = 31
    elseif month == 11 then
        pivot_day = 30
    elseif month == 12 then
        pivot_day = 31    
    end

    if pivot_day == 0 then
        ShowMessageBox('month is out of bounds')
        return
        -- error
    end
    
    if day > pivot_day then
        ShowMessageBox('day is out of bounds')
        return
        -- error
    end
    
    local t = token[2]
    local t_token = StringSplit(t, ':')
    if #t_token ~= 3 then
        ShowMessageBox('time format error')
        return
        -- error
    end
    local hour = tonumber(t_token[1])
    local minute = tonumber(t_token[2])
    local seconds = tonumber(t_token[3])
    if hour < 0 or hour > 24 then
        ShowMessageBox('hour is out of bounds')
        return
        -- error
    end

    if minute < 0 or minute > 59 then
        ShowMessageBox('minute is out of bounds')
        return
        -- error
    end

    if seconds < 0 or seconds > 59 then        
        -- error
    end
    
    return year, month, day, hour, minute, seconds
end

function CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT(date)
    local token = StringSplit(date, ' ')    
    if #token ~= 2 then
        ShowMessageBox('date and time format error')
        return
        -- error
    end

    local d = token[1]
    local d_token = StringSplit(d, '-')
    if #d_token ~= 3 then
        ShowMessageBox('date format error')
        return
        -- error
    end
    local year = tonumber(d_token[1])
    if year < 2000 then
        ShowMessageBox('year should be larger than in 2000')
        return
        -- error
    end

    local month = tonumber(d_token[2])
    if month < 1 or month > 12 then
        ShowMessageBox('minute is out of bounds')
        return
        -- error
    end

    local day = tonumber(d_token[3])
    if day < 1 then
        ShowMessageBox('day is out of bounds')
        return
        -- error
    end

    local pivot_day = 0

    if month == 1 then
        pivot_day = 31    
    elseif month == 2 then
        local is_moreday = false
        if year % 4 == 0 then            
            is_moreday = true
        end
        if year % 100 == 0 then
            is_moreday = false
        end
        if year % 400 == 0 then
            is_moreday = true
        end
        
        if is_moreday == true then
            pivot_day = 29
        else
            pivot_day = 28
        end
    elseif month == 3 then
        pivot_day = 31
    elseif month == 4 then
        pivot_day = 30
    elseif month == 5 then
        pivot_day = 31
    elseif month == 6 then
        pivot_day = 30
    elseif month == 7 then
        pivot_day = 31
    elseif month == 8 then
        pivot_day = 31
    elseif month == 9 then
        pivot_day = 30
    elseif month == 10 then
        pivot_day = 31
    elseif month == 11 then
        pivot_day = 30
    elseif month == 12 then
        pivot_day = 31    
    end

    if pivot_day == 0 then
        ShowMessageBox('month is out of bounds')
        return
        -- error
    end
    
    if day > pivot_day then
        ShowMessageBox('day is out of bounds')
        return
        -- error
    end
    
    local t = token[2]
    local t_token = StringSplit(t, ':')
    if #t_token ~= 3 then
        ShowMessageBox('time format error')
        return
        -- error
    end
    local hour = tonumber(t_token[1])
    local minute = tonumber(t_token[2])
    local seconds = tonumber(t_token[3])
    if hour < 0 or hour > 24 then
        ShowMessageBox('hour is out of bounds')
        return
        -- error
    end

    if minute < 0 or minute > 59 then
        ShowMessageBox('minute is out of bounds')
        return
        -- error
    end

    if seconds < 0 or seconds > 59 then
        
    end
    
    local old_format = string.format("%02d%01d%02d%02d%02d", month, 0, day, hour, minute)
    return old_format, year
end

function IS_BETWEEN_DAY(start_date, end_date, now)    
    local start_year, start_month, start_day, start_hour, start_minute, start_second = GET_DATE_FROM_NEWTIME_FORMAT(start_date)
    local end_year, end_month, end_day, end_hour, end_minute, end_second = GET_DATE_FROM_NEWTIME_FORMAT(end_date)
    
    local pivot_start = string.format("%04d%02d%02d%02d%02d", start_year, start_month, start_day, start_hour, start_minute)
    local pivot_end = string.format("%04d%02d%02d%02d%02d", end_year, end_month, end_day, end_hour, end_minute)
    local now = string.format("%04d%02d%02d%02d%02d", now.wYear, now.wMonth, now.wDay, now.wHour, now.wMinute)
    
    if pivot_start <= now and now <= pivot_end then
        return true
    end
    return false
end


function CHECK_TPITEM_ENABLE_VIEW(itemObj)    
	local startProp = TryGetProp(itemObj, "SellStartTime")
	local endProp = TryGetProp(itemObj, "SellEndTime")

	if startProp == nil or endProp == nil then
		return true;
	end

	if startProp == "None" or endProp == "None" then
		return true;
	end
    local curYear = 0
    local endYear = 0
    local ret = IS_BETWEEN_DAY(startProp, endProp, geTime.GetServerSystemTime())    
    return ret
end

function IS_TIME_SALE_ITEM(classID)
	local tpitemframe = ui.GetFrame("tpitem");
	local itemObj = GetClassByType("TPitem", classID);

	local startProp = TryGetProp(itemObj, "SellStartTime");
	local endProp = TryGetProp(itemObj, "SellEndTime");

	if startProp == nil or endProp == nil then
		return false;
	end

	if startProp == "None" or endProp == "None" then
		return false;
	else
		return true;
	end
end

function SHOW_REMAIN_SALE_TIME(ctrl)
	local curTime = geTime.GetServerSystemTime()
	local curSysTimeStr = string.format("%04d%02d%01d%02d%02d%02d%02d", curTime.wYear, curTime.wMonth, '0', curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)
	local startTime = ctrl:GetUserValue("SELL_START_TIME")
	local endTime = ctrl:GetUserValue("SELL_END_TIME")
	
    local curYear = curTime.wYear
    local endYear = curTime.wYear
    startTime, curYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT(startTime)        
    endTime, endYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT(endTime)
    startTime = tonumber(startTime)
    endTime = tonumber(endTime)

	local endSysTimeStr = string.format("%04d%09d%02d", endYear, endTime, '00')
	local curSysTime = imcTime.GetSysTimeByStr(curSysTimeStr)
	local endSysTime = imcTime.GetSysTimeByStr(endSysTimeStr)
	local difSec = imcTime.GetDifSec(endSysTime, curSysTime);

	local remainSec = difSec

	if 0 > remainSec then
		
		ctrl:SetTextByKey("remainTime", ScpArgMsg("LessThanItemLifeTime"));
		ctrl:SetFontName("red_18");
		ctrl: StopUpdateScript("SHOW_REMAIN_SALE_TIME");
	
		return 0;
	end

	local timeTxt = GET_TIME_TXT_DHM(remainSec);
	ctrl:SetTextByKey("remainTime", timeTxt);

	return 1;
end

function TPITEM_DRAW_ITEM_DETAIL(obj, itemobj, itemcset)
	-- 프리미엄 아이템 확인
	local IsPremiumCase = 0;
	if itemobj.ItemGrade == 0 then
		IsPremiumCase = 1;
	end

	-- 프리미엄 여부에 따라 분류되느 UI를 일괄적으로 받아오고
	local title = GET_CHILD_RECURSIVELY(itemcset,"title");
	local subtitle = GET_CHILD_RECURSIVELY(itemcset,"subtitle");
	local nxp = GET_CHILD_RECURSIVELY(itemcset,"nxp")
	local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");
	local pre_Line = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_1");
	local limited_line = GET_CHILD_RECURSIVELY(itemcset, "titleLine_limited");
	local limited_case = GET_CHILD_RECURSIVELY(itemcset, "case_limited");
	local limited_bg = GET_CHILD_RECURSIVELY(itemcset, "bg_limited");
	local time_limited_bg = GET_CHILD_RECURSIVELY(itemcset, "time_limited_bg");
	local time_limited_text = GET_CHILD_RECURSIVELY(itemcset, "time_limited_text");
	local pre_Box = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_2");
	local pre_Text = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_3");
	local isNew_mark = GET_CHILD_RECURSIVELY(itemcset,"isNew_mark");
	local isLimit_mark = GET_CHILD_RECURSIVELY(itemcset,"isLimit_mark");
	local isHot_mark = GET_CHILD_RECURSIVELY(itemcset,"isHot_mark");
	local isEvent_mark = GET_CHILD_RECURSIVELY(itemcset,"isEvent_mark");
    local isSale_mark = GET_CHILD_RECURSIVELY(itemcset,"isSale_mark");
    isSale_mark:SetVisible(0);

	local itemName = itemobj.Name;
	local itemclsID = itemobj.ClassID;

	local tpitem_clsName = obj.ClassName;
	local tpitem_clsID = obj.ClassID;

	if 1 == IsPremiumCase then	--프리미엄일 경우
		local sucValue = string.format("{@st41b}%s", itemName);
		title:SetText(sucValue);
		pre_Line:SetVisible(1);
		pre_Box:SetVisible(1);
		pre_Text:SetVisible(1);
	else						--프리미엄이 아닐 경우
		title:SetText(itemName);
		pre_Line:SetVisible(0);
		pre_Box:SetVisible(0);
		pre_Text:SetVisible(0);
	end

	-- 구매 여부와 착용 여부를 검사한다.
	itemcset:SetUserValue("TPITEM_CLSID", tpitem_clsID);
	TPITEM_SET_SPECIALMARK(isNew_mark, isHot_mark, isEvent_mark, isLimit_mark, tpitem_clsID);

	if IS_TIME_SALE_ITEM(tpitem_clsID) == true then
		local curTime = geTime.GetServerSystemTime()
		local curSysTimeStr = string.format("%04d%02d%01d%02d%02d%02d%02d", curTime.wYear, curTime.wMonth, '0', curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)
		local startTime = TryGetProp(obj, "SellStartTime");
		local endTime = TryGetProp(obj, "SellEndTime");
                
	    time_limited_text:SetUserValue("SELL_START_TIME", startTime);
		time_limited_text:SetUserValue("SELL_END_TIME", endTime);

        local curYear = curTime.wYear
        local endYear = curTime.wYear
        startTime, curYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT(startTime)        
        endTime, endYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT(endTime)
        startTime = tonumber(startTime)
        endTime = tonumber(endTime)
		
		local endSysTimeStr = string.format("%04d%09d%02d", endYear, endTime, '00')
		local curSysTime = imcTime.GetSysTimeByStr(curSysTimeStr)
		local endSysTime = imcTime.GetSysTimeByStr(endSysTimeStr)
		local difSec = imcTime.GetDifSec(endSysTime, curSysTime);
		
		time_limited_text:SetUserValue("REMAINMIN", difSec);
		time_limited_text:RunUpdateScript("SHOW_REMAIN_SALE_TIME");
		
		title:SetFontName('white_18_ol')
		limited_bg : SetVisible(1);
		limited_case: SetVisible(1);
		limited_line:SetVisible(1);
		time_limited_bg:SetVisible(1);
		time_limited_text:SetVisible(1);
	else		
		itemcset:SetSkinName('test_skin_01_btn')
		limited_bg : SetVisible(0);
		limited_case: SetVisible(0);
		limited_line:SetVisible(0);
		time_limited_bg:SetVisible(0);
		time_limited_text:SetVisible(0);
	end
			
	nxp:SetText("{@st43}{s18}"..obj.Price.."{/}");	
	subtitle:SetVisible(0);	

	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			
	local icon = slot:GetIcon();
	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('', itemclsID, 0);

	local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(itemclsID);
	local result = prop:CheckEquip(lv, job, gender);

	local desc = GET_CHILD_RECURSIVELY(itemcset,"desc")
	if result == "OK" then
		desc:SetText(GET_USEJOB_TOOLTIP(itemobj))
	else
		desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemobj).."{/}")
	end

	local argStr = string.format('%d;%d;', obj.ClassID, obj.Price);
	local tradeable = GET_CHILD_RECURSIVELY(itemcset,"tradeable")
	local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
	if itemProp:IsEnableUserTrade() == true then
		tradeable:ShowWindow(0)
		argStr = argStr..'T';
	else
		tradeable:ShowWindow(1)
		argStr = argStr..'F';
	end

	slot:SetEventScript(ui.LBUTTONDOWN, 'TPITEM_SHOW_PACKAGELIST');
	slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, itemclsID);
	slot:SetEventScriptArgString(ui.LBUTTONDOWN, argStr);

	local buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");
	buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);
	
	local previewbtn = GET_CHILD_RECURSIVELY(itemcset, "previewBtn");
	previewbtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);		
	previewbtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);

	local sucValue = string.format("");	

	local category = obj.Category;
	if category == nil then
		return;
	end

	local subCategory = obj.SubCategory;
	if subCategory == nil then
		return;
	end

	local isPreviewPossible = 0;

	if session.GetEquipItemByType(itemclsID) ~= nil then -- 사용하여 혜택을 받고 있거나, 장비하고 있을때
		SWITCH(subCategory)
		{
			['TP_Useable'] = function()
				sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsUsed"));				
			end,

			['TP_Consume'] = function()
				sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsUsed"));				
			end,

			['TP_Petitem'] = function()
				sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsUsed"));				
			end,

			default = function()
				if itemobj.ItemType  == 'Equip' then
					if subCategory ~= 'TP_Costume_Hairacc' then
						if (subCategory == 'TP_Costume_Lens') then
							isPreviewPossible = 1;
						end
						sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsEquiped"));							
					end
				end
			end,
		}
	else
		if result == "OK" then
			isPreviewPossible = IS_ITEM_WILL_CHANGE_APC(itemclsID);
		end
					
		-- 카테고리 단위
		SWITCH(category)
		{
			['TP_Character'] = function() 
				-- 서브카테고리 단위
				SWITCH(subCategory)
				{
					['TP_Costume_Color'] = function() 	
						isPreviewPossible = 1;
						sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsPurchased"..isPreviewPossible));
 					end,

					['TP_Costume_Hairacc'] = function()
						isPreviewPossible = 1;
 					end,

					['TP_Costume_Lens'] = function()
						if session.GetInvItemByType(itemclsID) ~= nil then
							sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsPurchased1"));
						end
						isPreviewPossible = 1;
 					end,

					default = function()	-- / TP_Hair_M / TP_Hair_F / TP_Hair_M_Premium / TP_Hair_F_Premium
						if session.GetInvItemByType(itemclsID) ~= nil then
							isPreviewPossible = IS_ITEM_WILL_CHANGE_APC(itemclsID);
							sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsPurchased"..isPreviewPossible));
						else
							if result == "OK" then
								sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsPurchased"..isPreviewPossible));
							end
						end
					end,
				}
			end,

			['TP_Costume_F'] = function()
				sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsPurchased".. isPreviewPossible));	
			end,

			['TP_Costume_M'] = function()
				sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsPurchased".. isPreviewPossible));	
			end,
            ['TP_Premium_Sale'] = function()
                isSale_mark:SetVisible(1);

				sucValue = string.format("{@st41b}{s18}%s{/}", ScpArgMsg("ITEM_IsPurchased".. isPreviewPossible));	
            end,
		}
	end

	buyBtn:SetSkinName("test_red_button");	
	buyBtn:EnableHitTest(1);
	
	local obj = GetClassByType("TPitem", tpitem_clsID)
	if obj == nil then
		return;
	end

    TPITEM_SET_ENABLE_BY_LIMITATION(buyBtn, obj);

	previewbtn:ShowWindow(isPreviewPossible);
end

function TPSHOP_ISNEW_CHECK_TIME()
	local now_time = os.date("%y%m%d");
	local old_time_y = os.date("%y");
	local old_time_m = os.date("%m");
	local old_time_d = os.date("%d") - 30;
	if old_time_d <= 0 then
		old_time_d = 30 + old_time_d;
		old_time_m =  old_time_m -1;
		if old_time_m <= 0 then			
			old_time_m = 12 + old_time_m;
			old_time_y = old_time_y - 1;
		end
	end
	return tonumber(string.format("%02d%02d%02d", old_time_y, old_time_m, old_time_d));
end

function TPSHOP_ISNEW_CHECK(clsID)
	local tpitemframe = ui.GetFrame("tpitem");
	local limitTime = tpitemframe:GetUserIValue("TPSHOP_LIMIT_TIMEDATE");

	if limitTime <= 0 then
		limitTime = TPSHOP_ISNEW_CHECK_TIME();
	end
	local tpobj = GetClassByType("TPitem", clsID);
	if tpobj ~= nil then		
		if tpobj and limitTime <= tpobj.Itemdate then			
			return true;
		end
	end
		
	return false;
end

function TPSHOP_TPITEMLIST_TYPEDROPLIST(alignmentgbox, clsID)
	local frame = ui.GetFrame("tpitem");
	local showTypeList = GET_CHILD_RECURSIVELY(frame,"showTypeList");	
	local typeIndex = showTypeList:GetSelItemIndex();
	
	if typeIndex == 0 then
		return true;
	end;
		
	local bisHot = false;
	local bisRecom = false;
	
	local founded_info = session.ui.Getlistitem_TPITEM_ADDITIONAL_INFO_Map_byID(clsID);
	if founded_info ~= nil then
		if founded_info.nIsHot > 0 then
			bisHot = true;
		end
		bisRecom = founded_info.bRecommandNO;
	end;
	
	if typeIndex == 1 then
		if TPSHOP_ISNEW_CHECK(clsID) == true then
			return true;
		end
	elseif typeIndex == 2 then
		if bisHot == true then
			return true
		end
	elseif typeIndex == 3 then
		if bisRecom == true then
			return true;
		end
	end

	return false;
end

function TPSHOP_SORT_LIST(a, b)
	local frame = ui.GetFrame("tpitem");
	local leftgFrame = frame:GetChild("leftgFrame");	
	local leftgbox = leftgFrame:GetChild("leftgbox");
	local alignmentgbox = GET_CHILD(leftgbox,"alignmentgbox");	
	local alignTypeList = GET_CHILD_RECURSIVELY(frame,"alignTypeList");	
	local typeIndex = alignTypeList:GetSelItemIndex();
	
	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"mainSubGbox");
	local itemcset1 = mainSubGbox:GetControlSet('tpshop_item', 'eachitem_'..a);
	local itemcset2 = mainSubGbox:GetControlSet('tpshop_item', 'eachitem_'..b);
	if (itemcset1 == nil) or  (itemcset2 == nil)then
		return false;
	end
	
	local clsId1 = itemcset1:GetUserIValue("TPITEM_CLSID");
	local clsId2 = itemcset2:GetUserIValue("TPITEM_CLSID");

	local obj1 = GetClassByType("TPitem", clsId1);
	local obj2 = GetClassByType("TPitem", clsId2);
	if (obj1 == nil) or (obj2 == nil) then
		return false;
	end
	
	local itemobj1 = GetClass("Item", obj1.ItemClassName);
	local itemobj2 = GetClass("Item", obj2.ItemClassName);
	if (itemobj1 == nil) or (itemobj2 == nil) then
		return false;
	end
		

	if typeIndex == 5 then	
		return itemobj1.Name < itemobj2.Name;
	elseif typeIndex == 6 then
		return itemobj1.Name > itemobj2.Name;
	elseif typeIndex == 1 then
		return obj1.Price > obj2.Price;
	elseif typeIndex == 2 then
		return obj1.Price < obj2.Price;
	else
		local founded_info1 = session.ui.Getlistitem_TPITEM_ADDITIONAL_INFO_Map_byID(clsId1);
		local founded_info2 = session.ui.Getlistitem_TPITEM_ADDITIONAL_INFO_Map_byID(clsId2);
		if typeIndex == 3 then
		
			local d1 = 0;
			local d2 = 0;
			if founded_info1 ~= nil then
					d1 = founded_info1.nIsHot;
			end
			
			if founded_info2 ~= nil then
					d2 = founded_info2.nIsHot;
			end
			
			return d1 > d2;
		elseif typeIndex == 4 then
		
			local d1 = 0;
			local d2 = 0;
			if founded_info1 ~= nil then
					d1 = founded_info1.nIsHot;
			end
			
			if founded_info2 ~= nil then
					d2 = founded_info2.nIsHot;
			end

			return d1 < d2;
		elseif typeIndex == 0 then
			return obj1.Itemdate > obj2.Itemdate;
		end
	end;

	
	return false;
end

--정렬
function TPSHOP_TPITEM_ALIGN_LIST(cnt)
	local srcTable = {};
	for i = 1, cnt do
		srcTable[#srcTable + 1] = i;
		table.sort(srcTable, TPSHOP_SORT_LIST);
	end
	local frame = ui.GetFrame("tpitem");
	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"mainSubGbox");	
	local x = 0;
	local y = 0;
	for i = 1, cnt do
		local itemcset = mainSubGbox:GetControlSet('tpshop_item', 'eachitem_'..i);
		if itemcset == nil then
			return;
		end
		x = ( (i-1) % 3) * ui.GetControlSetAttribute("tpshop_item", 'width')
		y = (math.ceil( (i / 3) ) - 1) * (ui.GetControlSetAttribute("tpshop_item", 'height') * 1)
		mainSubGbox:CreateOrGetControlSet('tpshop_item', 'eachitem_'..srcTable[i], x, y);
	end;
end	

function _TPSHOP_TPITEM_SET_SPECIAL()	

	local frame = ui.GetFrame("tpitem");
	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"mainSubGbox");
	local index = frame:GetUserIValue("CHILD_ITEM_INDEX");	
	if index == 0 then
		return;
	end
	
	for i = 1, index do
		local itemcset = mainSubGbox:GetControlSet('tpshop_item', 'eachitem_'..i);
		if itemcset == nil then
			return;
		end
		local classID = itemcset:GetUserIValue("TPITEM_CLSID");
		if classID == nil then
			return;
		end
		
		local isEvent_mark = GET_CHILD_RECURSIVELY(itemcset,"isEvent_mark");
		local isHot_mark = GET_CHILD_RECURSIVELY(itemcset,"isHot_mark");
		local isNew_mark = GET_CHILD_RECURSIVELY(itemcset,"isNew_mark");
		local isLimit_mark = GET_CHILD_RECURSIVELY(itemcset,"isLimit_mark");

		TPITEM_SET_SPECIALMARK(isNew_mark, isHot_mark, isEvent_mark, isLimit_mark, classID);
	end	
	
	DebounceScript("TPSHOP_CREATE_TOP5_CTRLSET", 1);
end

function TPITEM_SET_SPECIALMARK(isNew_mark, isHot_mark, isEvent_mark, isLimit_mark, classID)
	local founded_info = session.ui.Getlistitem_TPITEM_ADDITIONAL_INFO_Map_byID(classID);
	local bisNew = 0;
	local bisHot = 0;
	local bisEvent = 0;
	local bisLimit = 0;
	if IS_TIME_SALE_ITEM(classID) == true then
	 	bisLimit = 1;
	elseif TPSHOP_ISNEW_CHECK(classID) == true then
		bisNew = 1;
	end
  
	if founded_info ~= nil then	
		if founded_info.nIsHot > 0 then
			bisHot = 1;
		end
		if founded_info.bRecommandNO == true then
			bisEvent = 1;
		end
	end;

	isNew_mark:SetVisible(bisNew);
	isHot_mark:SetVisible(bisHot);		
	isEvent_mark:SetVisible(bisEvent);
	isLimit_mark:SetVisible(bisLimit);
end

function TPSHOP_CREATE_TOP5_CTRLSET()
	local frame = ui.GetFrame("tpitem");
	local top5gBox = GET_CHILD_RECURSIVELY(frame,"top5gBox");
	DESTROY_CHILD_BYNAME(top5gBox, "eachitem_");

	local index = 0;
	local y = 0;
		
	
	local info = session.ui.Pop_GreaterHot_Queue();
	while info do
		if info.nIsHot >= 0 then					
			if index == 5 then
				break;
			end
			local obj = GetClassByType("TPitem", info.nclsID)
			if obj == nil then
				break;
			end
			
			local itemobj = GetClass("Item", obj.ItemClassName)
			if itemobj == nil then
				break;
			end
			
			local clsID = itemobj.ClassID;
			local IsPremiumCase = 0;		
			-- 프리미엄 아이템 확인
			if itemobj.ItemGrade == 0 then
				IsPremiumCase = 1;
			end
			
			index = index + 1;
			y = (math.ceil( index ) - 1) * (ui.GetControlSetAttribute("tpshop_top5item", 'height') * 1)
	
			local itemcset = top5gBox:CreateOrGetControlSet('tpshop_top5item', 'eachitem_'..index, 0, y);

			-- 프리미엄 여부에 따라 분류되느 UI를 일괄적으로 받아오고
			local title = GET_CHILD_RECURSIVELY(itemcset,"title");
			local nxp = GET_CHILD_RECURSIVELY(itemcset,"nxp")
			local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");
			local pre_Box = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_2");
						
			if 1 == IsPremiumCase then	--프리미엄일 경우
				title:SetText(itemobj.Name);
				pre_Box:SetVisible(1);
			else						--프리미엄이 아닐 경우
				title:SetText(itemobj.Name);
				pre_Box:SetVisible(0);
			end			
						
			nxp:SetText(obj.Price);
			SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', clsID, 0);		
			
			local btn = GET_CHILD_RECURSIVELY(itemcset, "btn");
			btn:SetEventScript(ui.LBUTTONUP, 'TPSHOP_SELECTED_TOP5');
			btn:SetEventScriptArgNumber(ui.LBUTTONUP, info.nclsID);
		end		
		info = session.ui.Pop_GreaterHot_Queue();
	end;
	session.ui.Pop_GreaterHot_Queue();
		
	--모든 아이템을 출력할때에 컨트롤셋 인덱스를 기억해냄.
	top5gBox:Invalidate()
	frame:Invalidate()
end

function TPSHOP_SELECTED_TOP5(parent, control, tpitemname, classid)
	local obj = GetClassByType("TPitem", classid)
	if obj == nil then
		return;
	end

	TPSHOP_AUTOSELECTED_TREEITEM(obj.Category, obj.SubCategory);
end

function TPSHOP_AUTOSELECTED_TREEITEM(category, subcategory)
	
	MAKE_CATEGORY_TREE();	
	
	local frame = ui.GetFrame("tpitem");
	local categorySubGbox = GET_CHILD_RECURSIVELY(frame, "categorySubGbox");
	local tpitemtree = GET_CHILD(categorySubGbox, "tpitemtree");
	local categoryCset = GET_CHILD(tpitemtree, "TPSHOP_CT_" .. category )
	local htreeitem = tpitemtree:FindByValue(category.."#"..subcategory);	
	local tree = AUTO_CAST(tpitemtree);
	tree:Select(htreeitem);
	local tnode = tree:GetNodeByTreeItem(htreeitem);
	if tnode == nil then
		return;
	end

	TPITEM_SELECT_TREENODE(tnode);
end

function TPSHOP_ITEMSEARCH_CLICK(parent, control, strArg, intArg)
	local editDiff = GET_CHILD(parent, "editDiff");
    if editDiff == nil then
		local frame = parent:GetTopParentFrame();
	  editDiff = GET_CHILD_RECURSIVELY(frame, 'recycle_editDiff');
    end
	editDiff:SetVisible(0);
	control:ClearText();
end

function TPSHOP_ITEMSEARCH_ENTER(parent, control, strArg, intArg)
	local frame = ui.GetFrame("tpitem");
	local input = GET_CHILD_RECURSIVELY(frame, "input");
	local searchFortext = input:GetText();
	
	MAKE_CATEGORY_TREE();	

	if string.len(searchFortext) <= 0 then
		local editDiff = GET_CHILD(parent, "editDiff");
		input:ClearText();
		input:ReleaseFocus();
		editDiff:SetVisible(1);
	else
		TPITEM_DRAW_ITEM_WITH_CATEGORY(frame, "None", "None", 1, nil, searchFortext);
	end
end

--///////////////////////////////////////////////////////////////////////////////////////////미리보기 Code start
function TPSHOP_ITEM_PREVIEW_PREPROCESSOR(parent, control, tpitemname, tpitem_clsID)
	local frame = ui.GetFrame("tpitem");
	local slotset = nil;
	
	local obj = GetClassByType("TPitem", tpitem_clsID)
	if obj == nil then
		return;
	end
	
	local itemobj = GetClass("Item", obj.ItemClassName)
	if itemobj == nil then
		return;
	end
	
	local category = obj.Category;
	if category == nil then
		return;
	end		

	local subCategory = obj.SubCategory;
	if subCategory == nil then
		return;
	end

    if subCategory == 'TP_Costume_Color' then -- EqpType이 nil인 경우는 염색약 말곤 없었다. 
        TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset1"), 1, tpitemname, itemobj); -- 염색약	(보류시 주석처리할 곳)
    else
        SWITCH (itemobj.EqpType)
        {
            ['OUTER'] = function()
			    TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset0"), 1, tpitemname, itemobj);	-- 옷
			end,
            ['HAIR'] = function()
                TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset0"), 0, tpitemname, itemobj);	-- 헤어
            end,
            ['HAT'] = function()
                TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset1"), 0, tpitemname, itemobj);	-- 헤어악세
            end,
            ['LENS'] = function()
                TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset0"), 2, tpitemname, itemobj); -- 렌즈
            end,
            default = function() 
                IMC_LOG("INFO_NORMAL", "EqpType not defined in tpitem.lua:TPSHOP_ITEM_PREVIEW_PREPROCESSOR. item.EqpType:" .. itemobj.EqpType);
			    TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset0"), 0, tpitemname, itemobj); -- 디폴트 헤어
            end,
	    }
    end	
end

-- 미리보기에서 해당 슬롯에 장착
function TPSHOP_PREVIEWSLOT_EQUIP(frame, slotset, slotIndex, tpitemname, itemobj)

	local slotIcon	= slotset:GetIconByIndex(slotIndex);
	if slotIcon ~= nil then
		local slot  = slotset:GetSlotByIndex(slotIndex);
		slot:ClearText();
		slot:ClearIcon();
		slot:SetUserValue("CLASSNAME", "None");
		slot:SetUserValue("TPITEMNAME", "None");
	end
	
	slotIcon = slotset:GetIconByIndex(slotIndex);
	if slotIcon == nil then
		local slot  = slotset:GetSlotByIndex(slotIndex);
		slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_PREVIEWSLOT_REMOVE');
		slot:SetUserValue("CLASSNAME", itemobj.ClassName);
		slot:SetUserValue("TPITEMNAME", tpitemname);

		SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
		local icon = slot:GetIcon();
		icon:SetTooltipType('wholeitem');
		icon:SetTooltipArg('', itemobj.ClassID, 0);
	end
	
	TPSHOP_SET_PREVIEW_APC_IMAGE(frame, 0);
end

-- 미리보기에서 해당 슬롯만 제거
function TPSHOP_PREVIEWSLOT_REMOVE(parent, control, strArg, numArg)

	control:ClearText();
	control:ClearIcon();

	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	TPSHOP_SET_PREVIEW_APC_IMAGE(parent:GetTopParentFrame(), 0);
end

-- 미리보기 사진찍기
function TPSHOP_SET_PREVIEW_APC_IMAGE(frame, rotDir)
	local pcSession = session.GetMySession();
	if pcSession == nil then
		return
	end
	local apc = pcSession:GetPCDummyApc();
	local invframe = ui.GetFrame("inventory");
	local invSlot = nil;

	-- 내 캐릭터의 가발 보이기/안보이기 설정에 따라 APC도 보이기/안보이기 설정을 해야 한다.
	local myPCetc = GetMyEtcObject();
	local hairWig_Visible = myPCetc.HAIR_WIG_Visible
	if hairWig_Visible == 1 then
		apc:SetHairWigVisible(true);
	else
		apc:SetHairWigVisible(false);
	end
	
	-- 장착 슬롯에 따라 리셋
	for i = 0, ES_LAST do	--  EQUIP_SPOT만이 아닌 ES_LENS 포함
		SWITCH(i) {				
		[ES_HAT] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "HAT");
		end,
		[ES_HAT_L] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "HAT_L");
		end,			
		[ES_HAT_T] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "HAT_T");
		end,
		[ES_HAIR] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "HAIR");
		end,
		[ES_SHIRT] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "SHIRT");
		end,
		[ES_GLOVES] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "GLOVES");
		end,
		[ES_BOOTS] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "BOOTS");
		end,
		[ES_HELMET] = function()
				invSlot = GET_CHILD_RECURSIVELY(invframe, "HAIR");
		end,
		[ES_ARMBAND] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "ARMBAND");
		end,
		[ES_RH] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "RH");
		end,
		[ES_LH] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "LH");
		end,
		[ES_OUTER] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "OUTER");
		end,
		[ES_PANTS] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "PANTS");
		end,
		[ES_RING1] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "RING1");
		end,
		[ES_RING2] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "RING2");
		end,
		[ES_NECK] = function() 
				invSlot = GET_CHILD_RECURSIVELY(invframe, "NECK");
		end,
		[ES_LENS] = function() --ES_LENS
				invSlot = GET_CHILD_RECURSIVELY(invframe, "LENS");
		end,
		[ES_WING] = function() --ES_WING
				invSlot = GET_CHILD_RECURSIVELY(invframe, "WING");
		end,
		[ES_SPECIAL_COSTUME] = function() --ES_SPECIAL_COSTUME
				invSlot = GET_CHILD_RECURSIVELY(invframe, "SPECIAL_COSTUME");
		end,
		[ES_EFFECT_COSTUME] = function() --ES_EFFECT_COSTUME
				invSlot = GET_CHILD_RECURSIVELY(invframe, "EFFECTCOSTUME");
		end,
		--[ES_HELMET] = function() end,		-- 6
		--[ES_OUTERADD1] = function() end,	-- 11
		--[ES_OUTERADD2] = function() end,	-- 12
		--[ES_BODY] = function() end,		-- 13
		--[ES_PANTSADD1] = function() end,	-- 15	
		--[ES_PANTSADD2] = function() end,	-- 16
		--[ES_DOLL] = function() end,
		default = function() invSlot = nil; end,
		}
		if invSlot == nil then
			apc:SetEquipItem(i, 0);		
		else
			invSlot = tolua.cast(invSlot, "ui::CSlot");
			local icon = invSlot:GetIcon();
			if icon ~= nil then
				local info = icon:GetInfo();
				local invIteminfo = GET_PC_ITEM_BY_GUID(info:GetIESID());
				if invIteminfo ~= nil then
					local obj = GetIES(invIteminfo:GetObject());
					if obj ~= nil then
						local spotName = item.GetEquipSpotName(i);
						if spotName == obj.EqpType then
							apc:SetEquipItem(i, obj.ClassID);
						else
							apc:SetEquipItem(i, 0);	
						end
					else
						apc:SetEquipItem(i, 0);	
					end
				else	
					apc:SetEquipItem(i, 0);	
				end			
			else	
				apc:SetEquipItem(i, 0);							
			end		
		end	
	end
	
	-- 헤어 색상 셋팅
	local pc = GetMyPCObject()
	local nowheadindex = item.GetHeadIndex();

	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(pc.Gender);
	local Selectclasslist = Selectclass:GetSubClassList();

	local nowhaircls = Selectclasslist:GetByIndex(nowheadindex-1);
	
	local nowengname = imcIES.GetString(nowhaircls, 'EngName') 
	local nowcolor = imcIES.GetString(nowhaircls, 'ColorE')
	
	local listCount = Selectclasslist:Count();
	
	for i=0, listCount do
		local cls = Selectclasslist:GetByIndex(i);
		if cls ~= nil then
			if nowengname == imcIES.GetString(cls, 'EngName') and nowcolor == imcIES.GetString(cls, 'ColorE') then
				apc:SetHeadType(i + 1);
				break;
			end
		end
	end

	-- 미리보기 물품 장착  	
	if rotDir ~= nil then		-- rotDir 가 nil이면 원래대로 돌아간다. 값이 있다면 미리보기 슬롯에 따라 장착된다.
		for j = 0, 1 do
			local slotset = GET_CHILD_RECURSIVELY(frame,"previewslotset" .. j);
			for i = 0, 2 do
				local slotIcon	= slotset:GetIconByIndex(i);
				if slotIcon ~= nil then
					local slot  = slotset:GetSlotByIndex(i);
					local classname = slot:GetUserValue("CLASSNAME");
					local alreadyItem = GetClass("Item",classname);
					if alreadyItem ~= nil then
						local defaultEqpSlot = TryGetProp(alreadyItem,'DefaultEqpSlot')
						if defaultEqpSlot ~= nil then
							apc:SetEquipItem(item.GetEquipSpotNum(defaultEqpSlot), alreadyItem.ClassID);
						end
					end
				end
			end
		end

		--염색약 확인 부분		(보류시 주석처리할 곳
		local hairName = "None";
		
		local hairslotset = GET_CHILD_RECURSIVELY(frame, "previewslotset0");
		if hairslotset ~= nil then
			local hairslot = hairslotset:GetSlotByIndex(0);
			if hairslot ~= nil then
				
				local classname = hairslot:GetUserValue("CLASSNAME");
		
				local itemobj = GetClass("Item", classname);
				if itemobj ~= nil then
					apc:SetEquipItem(ES_HELMET , 0);
					hairName = itemobj.StringArg;
				end
			end
		end
		
		local slotset = GET_CHILD_RECURSIVELY(frame, "previewslotset1");
		if slotset ~= nil then
			local slot = slotset:GetSlotByIndex(1);
			if slot ~= nil then
				local classname = slot:GetUserValue("CLASSNAME");
				if classname ~= "None" then
					local hairColor = "default";
					local itemobj = GetClass("Item", classname)
					if itemobj ~= nil then
						hairColor = itemobj.StringArg;
					end

					if hairName == "None" then
						hairName = ui._GetHeadEngNameByXML(apc:GetGender(), apc:GetHeadType());
					end

					local headIndexByItem = ui.GetHeadIndexByXML(apc:GetGender(), hairName, hairColor);

					apc:SetHeadType(headIndexByItem);
				end
			end
		end

		--컴페니언 확인 부분	(보류시 주석처리할 곳)
	else
		rotDir = 0;
	end

	local shihouette = GET_CHILD_RECURSIVELY(frame,"shihouette")
	local imgName = ui.CaptureMyFullStdImageByAPC(apc, rotDir, 1);
	shihouette:SetImage(imgName);
	frame:Invalidate();
end

function TPSHOP_PREVIEW_ZOOM(parent, control, argStr, argNum)
	local oriW = parent:GetOriginalWidth();
	local oriH = parent:GetOriginalHeight();
	local offsetResizeW = parent:GetWidth() + (oriW / argNum) * 50;
	local offsetResizeH = parent:GetHeight() + (oriH / argNum)  * 50;	
	local limitNum = 3;
	local limitW = (limitNum * oriW);
	local limitH = (limitNum * oriH);	
		
	if oriW >= offsetResizeW then
		offsetResizeW = oriW;
	end
	if oriH >= offsetResizeH then
		offsetResizeH = oriH;
	end
	if limitW <= offsetResizeW then
		offsetResizeW = limitW;
	end
	if limitH <= offsetResizeH then
		offsetResizeH = limitH;
	end
		
	-- 0 ~ -150
	local limitPos = -100;
	local posY = parent:GetOffsetY() + ((limitPos / argNum)  * 50);

	if posY >= 0 then
		posY = 0;
	end
	if posY <= limitPos then
		posY = limitPos;
	end
	
	parent:Resize(0, posY, offsetResizeW, offsetResizeH);

end

function TPSHOP_HAIR_ROT_PREV(parent)
	TPSHOP_SET_PREVIEW_APC_IMAGE(parent:GetTopParentFrame(), 2);
end

function TPSHOP_HAIR_ROT_NEXT(parent)
	TPSHOP_SET_PREVIEW_APC_IMAGE(parent:GetTopParentFrame(), 1);
end

--///////////////////////////////////////////////////////////////////////////////////////////미리보기 Code end

--///////////////////////////////////////////////////////////////////////////////////////////장바구니 Code start	
-- 장바구니 관련 Code들 모두 TP상점 개선 이후 한번 손 봐야함.
function TPSHOP_ITEM_BASKET_BUY(parent, control)
    local topFrame = parent:GetTopParentFrame();
    local slotset = GET_CHILD_RECURSIVELY(topFrame, 'basketslotset');
    local slotCount = slotset:GetSlotCount();
    local cannotEquip = {};
    local needWarningItemList = {};
    local noNeedWarning = {};
    local itemAndTPItemIDTable = {};
	local allPrice = 0;
	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);
		if slotIcon ~= nil then
			local slot  = slotset:GetSlotByIndex(i);			
            local tpItemName = slot:GetUserValue('TPITEMNAME');
            local itemClassName = slot:GetUserValue('CLASSNAME');
			local item = GetClass("Item", itemClassName);			
            local tpitem = GetClass('TPitem', tpItemName);

            itemAndTPItemIDTable[item.ClassID] = tpitem.ClassID;

			allPrice = allPrice + tpitem.Price

			if TryGetProp(tpitem, 'WarningMsg', 'NO') == 'YES' then
				needWarningItemList[#needWarningItemList + 1] = item;
			else
				noNeedWarning[#noNeedWarning + 1] = item;
			end

            if IS_EQUIP(item) == true then
		        local lv = GETMYPCLEVEL();
		        local job = GETMYPCJOB();
		        local gender = GETMYPCGENDER();
                local itemCls = GetClass('Item', itemClassName);
                local classid = itemCls.ClassID;
		        local prop = geItemTable.GetProp(classid);
		        local result = prop:CheckEquip(lv, job, gender);

		        if result ~= "OK" then
                    cannotEquip[#cannotEquip + 1] = itemCls;
                else
		            local pc = GetMyPCObject();
		            if pc == nil then
			            return;
		            end

		            local needJobClassName = TryGetProp(tpitem, "Job");
		            local needJobGrade = TryGetProp(tpitem, "JobGrade");
		            if IS_ENABLE_EQUIP_CLASS(pc, needJobClassName, needJobGrade) == false then
			            cannotEquip[#cannotEquip + 1] = itemCls;
                    else
		                local useGender = TryGetProp(item,'UseGender');
		                if useGender =="Male" and pc.Gender ~= 1 then
			                cannotEquip[#cannotEquip + 1] = itemCls;
                        else
		                    if useGender =="Female" and pc.Gender ~= 2 then
			                    cannotEquip[#cannotEquip + 1] = itemCls;
		                    end
		                end
		            end
		        end	
	        end
        end
    end

	if #needWarningItemList > 0 or #cannotEquip > 0 then
    	OPEN_TPITEM_POPUPMSG(needWarningItemList, noNeedWarning, cannotEquip, itemAndTPItemIDTable, allPrice);
	else
    	if config.GetServiceNation() == "GLOBAL" then			
			if CHECK_LIMIT_PAYMENT_STATE_C() == true then
        		ui.MsgBox_NonNested_Ex(ScpArgMsg("ReallyBuy?"), 0x00000004, parent:GetName(), "EXEC_BUY_MARKET_ITEM", "TPSHOP_ITEM_BASKET_BUY_CANCEL");	
			else
				POPUP_LIMIT_PAYMENT(ScpArgMsg("ReallyBuy?"), parent:GetName(), allPrice)
			end			
		else
			ui.MsgBox_NonNested_Ex(ScpArgMsg("ReallyBuy?"), 0x00000004, parent:GetName(), "EXEC_BUY_MARKET_ITEM", "TPSHOP_ITEM_BASKET_BUY_CANCEL");	
		end
    end

	control:SetEnable(0);
end

function CHECK_LIMIT_PAYMENT_STATE_C()
	local aObj = GetMyAccountObj();
	if aObj ~= nil then
		local limitPaymentStateBySteam = TryGetProp(aObj, "LimitPaymentStateBySteam");
		local limitPaymentStateByGM = TryGetProp(aObj, "LimitPaymentStateByGM")

		if limitPaymentStateBySteam ~= nil and limitPaymentStateByGM ~= nil then
			if limitPaymentStateBySteam == "Trusted" or limitPaymentStateByGM == "Trusted" then
				return true;
			else
				--return false;
				return true;
			end
		end
	end
	return true;
end

function POPUP_LIMIT_PAYMENT(clientMsg, parentName, allPrice)
	local frame = ui.GetFrame("tpitem");
	frame:SetUserValue("LIMIT_PAYMENT_MSG", clientMsg);
	frame:SetUserValue("PARENT_NAME", parentName);


	local accountObj = GetMyAccountObj();
	local spentPaymentValue = 0;

	if accountObj ~= nil then
		spentPaymentValue = TryGetProp(accountObj, "SpentPaymentValue")
		local nowUsePaymentValue = tonumber(VALVE_PURCHASESTATUS_ACTIVE_MONTHLY_PREMIUM_TP_SPENDLIMIT) - spentPaymentValue;
		local paymentValue = tonumber(VALVE_PURCHASESTATUS_ACTIVE_MONTHLY_PREMIUM_TP_SPENDLIMIT) - (spentPaymentValue + allPrice);
		if paymentValue >= 0 then
			ui.MsgBox_OneBtnScp(ScpArgMsg("LimitPaymentGuidMsg","Value", nowUsePaymentValue), "POPUP_POPUP_LIMIT_PAYMENT_CLICK")
		else
			ui.MsgBox_OneBtnScp(ScpArgMsg("LimitPaymentExcessMsg","Value", paymentValue), "POPUP_POPUP_LIMIT_PAYMENT_CANCEL")
		end
	end
end

function POPUP_POPUP_LIMIT_PAYMENT_CLICK()
	local frame = ui.GetFrame("tpitem");
	local msg = frame:GetUserValue("LIMIT_PAYMENT_MSG");
	local parentName = frame:GetUserValue("PARENT_NAME");
	
	ui.MsgBox_NonNested_Ex(msg, 0x00000004, parentName, "EXEC_BUY_MARKET_ITEM", "TPSHOP_ITEM_BASKET_BUY_CANCEL");	


	local frame = ui.GetFrame("tpitem")
	local btn = GET_CHILD_RECURSIVELY(frame,"basketBuyBtn");
	btn:SetEnable(1);
end

function POPUP_POPUP_LIMIT_PAYMENT_CANCEL()
	local frame = ui.GetFrame("tpitem")
	local btn = GET_CHILD_RECURSIVELY(frame,"basketBuyBtn");
	btn:SetEnable(1);	
end

function TPSHOP_ITEM_BASKET_BUY_CANCEL()
	local frame = ui.GetFrame("tpitem");
	local btn = GET_CHILD_RECURSIVELY(frame,"basketBuyBtn");
	btn:SetEnable(1);

	ui.CloseFrame('tpitem_popupmsg');
end

function TPSHOP_ITEM_TO_BASKET_PREPROCESSOR(parent, control, tpitemname, tpitem_clsID)	
	local tpitem_popupmsg = ui.GetFrame('tpitem_popupmsg');
	if tpitem_popupmsg ~= nil and tpitem_popupmsg:IsVisible() == 1 then
		return false;
	end

	g_TpShopParent = parent;
	g_TpShopcontrol = control;
	
	local obj = GetClassByType("TPitem", tpitem_clsID)
	if obj == nil then
		return false;
	end

	local itemobj = GetClass("Item", obj.ItemClassName)
	if itemobj == nil then
		return false;
	end

	local classid = itemobj.ClassID;
	local item = GetClassByType("Item", classid)

	if item == nil then
		return false;
	end

	if ui.IsMyDefaultHairItem(classid) == true then
        isHave = true;
	end

	local allowDup = TryGetProp(item,'AllowDuplicate')
	
	local isHave = false;
				
	if allowDup == "NO" then
		if session.GetInvItemByType(classid) ~= nil then
			isHave = true;
		end
		if session.GetEquipItemByType(classid) ~= nil then
			isHave = true;
		end
		if session.GetWarehouseItemByType(classid) ~= nil then
			isHave = true;
		end
	end

    local limit = GET_LIMITATION_TO_BUY(obj.ClassID);
	if isHave == true then
		ui.MsgBox(ClMsg("AlearyHaveItemReallyBuy?"), string.format("TPSHOP_ITEM_TO_BASKET('%s', %d)", tpitemname, classid), "None");
    elseif limit == 'ACCOUNT' then
		local curBuyCount = session.shop.GetCurrentBuyLimitCount(0, obj.ClassID, classid);
		if curBuyCount >= obj.AccountLimitCount then
			ui.MsgBox_OneBtnScp(ScpArgMsg("PurchaseItemExceeded","Value", obj.AccountLimitCount), "")
            return false;
		else
			ui.MsgBox(ScpArgMsg("SelectPurchaseRestrictedItem","Value", obj.AccountLimitCount), string.format("TPSHOP_ITEM_TO_BASKET('%s', %d)", tpitemname, classid), "None");
		end
    elseif limit == 'MONTH' then
        local curBuyCount = session.shop.GetCurrentBuyLimitCount(0, obj.ClassID, classid);
		if curBuyCount >= obj.MonthLimitCount then
			ui.MsgBox_OneBtnScp(ScpArgMsg("PurchaseItemExceeded","Value", obj.MonthLimitCount), "")
            return false;
		else
			ui.MsgBox(ScpArgMsg("SelectPurchaseRestrictedItemByMonth","Value", obj.MonthLimitCount), string.format("TPSHOP_ITEM_TO_BASKET('%s', %d)", tpitemname, classid), "None");
		end
	elseif TPITEM_IS_ALREADY_PUT_INTO_BASKET(parent:GetTopParentFrame(), obj) == true then
		ui.MsgBox(ClMsg("AleadyPutInBasketReallyBuy?"), string.format("TPSHOP_ITEM_TO_BASKET('%s', %d)", tpitemname, classid), "None");	
	else
		TPSHOP_ITEM_TO_BASKET(tpitemname, classid)
	end
    return true;
end

function TPSHOP_ITEM_TO_BASKET(tpitemname, classid)	
	
	if g_TpShopParent == nil or g_TpShopcontrol == nil then
		return;
	end

	local parent = g_TpShopParent;
	local control = g_TpShopcontrol;

	g_TpShopParent = nil;
	g_TpShopcontrol = nil;

	local item = GetClassByType("Item", classid)

	if item == nil then
		return;
	end

	local tpitem = GetClass("TPitem", tpitemname);
	if tpitem == nil then
		ui.MsgBox(ScpArgMsg("DataError"))
		return
	end

	local frame = parent:GetTopParentFrame();
	if CHECK_ALREADY_IN_LIMIT_ITEM(frame, tpitem) == false then
		ui.SysMsg(ClMsg('AleadyPutInBasket'));
		return;
	end

	if tpitem.SubCategory == "TP_Costume_Color" then
		local etc = GetMyEtcObject();
		if nil == etc then
			ui.MsgBox(ScpArgMsg("DataError"))
			return;
		end

		local nowAllowedColor = etc['AllowedHairColor']
		if string.find(nowAllowedColor, item.StringArg) ~= nil or TryGetProp(etc, "HairColor_"..item.StringArg) == 1 then
			ui.MsgBox(ScpArgMsg("AlearyEquipColor"))
			return;
		end
           
        if session.GetInvItemByType(item.ClassID) ~= nil then
            ui.MsgBox(ClMsg('CanNotBuyDuplicateItem'));
            return;
        end
	end

	local slotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	local slotCount = slotset:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon == nil then

			local slot  = slotset:GetSlotByIndex(i);

			slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_BASKETSLOT_REMOVE');
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, classid);
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("TPITEMNAME", tpitemname);

			SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(item));
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', item.ClassID, 0);

			break;

		end
	end

	UPDATE_BASKET_MONEY(frame)	
	
end

function TPSHOP_BASKETSLOT_REMOVE(parent, control, strarg, classid)	

	control:ClearText();
	control:ClearIcon();

	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	UPDATE_BASKET_MONEY(parent:GetTopParentFrame())

end

function UPDATE_BASKET_MONEY(frame)

	local slotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	local slotCount = slotset:GetSlotCount();

	local pcSession = session.GetMySession();
	if pcSession == nil then
		return
	end

	local apc = pcSession:GetPCDummyApc();
	
	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("TPitem",classname)

			if alreadyItem ~= nil then

				allprice = allprice + alreadyItem.Price
			
			end

		end
	end

	local basketTP = GET_CHILD_RECURSIVELY(frame,"basketTP")
	basketTP:SetText(tostring(allprice))

	local accountObj = GetMyAccountObj();

	local haveTP = GET_CHILD_RECURSIVELY(frame,"haveTP")
	haveTP:SetText(tostring(GET_CASH_TOTAL_POINT_C()))

	local remainTP = GET_CHILD_RECURSIVELY(frame,"remainTP")
	remainTP:SetText(tostring(GET_CASH_TOTAL_POINT_C() - allprice))

	frame:Invalidate();

end

--///////////////////////////////////////////////////////////////////////////////////////////장바구니 Code end

--///////////////////////////////////////////////////////////////////////////////////////////구매 Code start
function EXEC_BUY_MARKET_ITEM()

	local slotsetname = nil
	local itemListStr = ""
	
	slotsetname = "basketslotset"

	local frame = ui.GetFrame("tpitem")
	local btn = GET_CHILD_RECURSIVELY(frame,"basketBuyBtn");
	local slotset = GET_CHILD_RECURSIVELY(frame,slotsetname)
	if slotset == nil then
		btn:SetEnable(1);
		ui.CloseFrame('tpitem_popupmsg');
		return;
	end
	local slotCount = slotset:GetSlotCount();

	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local tpitemname = slot:GetUserValue("TPITEMNAME");
			local tpitem = GetClass("TPitem",tpitemname)
				

			if tpitem ~= nil then
							
				local startProp = TryGetProp(tpitem, "SellStartTime");
				local endProp = TryGetProp(tpitem, "SellEndTime");

				if startProp ~= nil and endProp ~= nil then
					if startProp ~= "None" and endProp ~= "None" then
						local curTime = geTime.GetServerSystemTime()
						local curSysTimeStr = string.format("%04d%02d%01d%02d%02d%02d%02d", curTime.wYear, curTime.wMonth, '0', curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)
						local startTime = TryGetProp(tpitem, "SellStartTime")
						local endTime = TryGetProp(tpitem, "SellEndTime");
						
                        local curYear = curTime.wYear
                        local endYear = curTime.wYear
                        startTime, curYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT(startTime)                        
                        endTime, endYear = CONVERT_NEWTIME_FORMAT_TO_OLDTIME_FORMAT(endTime)                        
                        startTime = tonumber(startTime)
                        endTime = tonumber(endTime)
						
						local endSysTimeStr = string.format("%04d%09d%02d", endYear, endTime, '00')

						local curSysTime = imcTime.GetSysTimeByStr(curSysTimeStr)
						local endSysTime = imcTime.GetSysTimeByStr(endSysTimeStr)

						local difSec = imcTime.GetDifSec(endSysTime, curSysTime);
						if 0 >= difSec then
							ui.SysMsg(ScpArgMsg("ExistSaleTimeExpiredItem"))
							btn:SetEnable(1);
							ui.CloseFrame(frame:GetName())
							ui.CloseFrame('tpitem_popupmsg');
							return
						end
					end
				end

				allprice = allprice + tpitem.Price

				if itemListStr == "" then
					itemListStr = tostring(tpitem.ClassID)
				else
					itemListStr = itemListStr .." " .. tostring(tpitem.ClassID)
				end
				
			else
				btn:SetEnable(1);
				ui.CloseFrame('tpitem_popupmsg');
				return
			end

		end
	end

	if allprice == 0 then
		btn:SetEnable(1);
		ui.CloseFrame('tpitem_popupmsg');
		return
	end

	if GET_CASH_TOTAL_POINT_C() < allprice then 
		--ui.MsgBox_NonNested(ScpArgMsg("Auto_MeDali_BuJogHapNiDa."), 0x000	00000, frame:GetName(), "WEB_TPSHOP_OPEN_URL_NEXONCASH", "None");	
		ui.MsgBox_NonNested(ScpArgMsg("Auto_MeDali_BuJogHapNiDa."), 0x00000000, frame:GetName(), "None", "None");	
		
		local tabObj		    = GET_CHILD_RECURSIVELY(frame,"shopTab");	
		local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
		itembox_tab:SelectTab(0);
		TPSHOP_TAB_VIEW(frame, 0);

		btn:SetEnable(1);
		ui.CloseFrame('tpitem_popupmsg');
		return;
	end

	pc.ReqExecuteTx_NumArgs("SCR_TX_TP_SHOP", itemListStr);	
	btn:SetEnable(1);
		
	local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(0);
	TPITEM_CLOSE(frame);
end
--///////////////////////////////////////////////////////////////////////////////////////////구매 Code end

--///////////////////////////////////////////////////////////////////////////////////////////TPITEM DRAW Code start
--넥슨 캐쉬 관련 함수
--tp상점의 넥슨 캐쉬 아이템들을 그리기
function TPITEM_DRAW_NC_TP()
	local frame = ui.GetFrame("tpitem");
	local leftgFrame = GET_CHILD(frame,"leftgFrame");	
	local leftgbox = GET_CHILD(leftgFrame,"leftgbox");	
	local tpSubgbox = GET_CHILD(leftgbox,"tpSubgbox");		
	local tpMaingbox = GET_CHILD(leftgbox,"tpMaingbox");	
	local mainSubGbox = GET_CHILD_RECURSIVELY(tpMaingbox,"tpMainSubGbox");	
	local index = 0;
	DESTROY_CHILD_BYNAME(mainSubGbox, "eachitem_");
	DESTROY_CHILD_BYNAME(tpSubgbox, "specialProduct_");

	local cnt = session.ui.Get_NISMS_ItemListSize();
	if cnt == 0 then		
		return;
	end
	
	local index = 5;
	local x, y;

	local specialGoodCount = 0;
	local packageClsID = 0;
	local packageJobCount = 0;
	
	local lastControlset = nil;
	local productNo = nil;
	local itemClsID = nil;
	local clsList, listcnt = GetClassList("item_package");	
	local jobNum = GETPACKAGE_JOBNUM_BYJOBNGENDER();
	-- 해당 카테고리의 노드들의 프레임을 만들기.

	for i = cnt -1,0, -1 do
		local iteminfo = session.ui.Get_NISMS_ItemInfo(i)
		if iteminfo == nil then
			return;
		end
		local ItemClassName = iteminfo.name;
		local categoryNo = iteminfo.categoryNo;
		local buyBtn = nil;
		
		local limitOnce = iteminfo.limitOnce;
		local itemPrice = iteminfo.price;
		local imgURL = iteminfo.imgAddress;
		productNo = iteminfo.itemid;
		itemClsID = iteminfo.tpItemClsId;
		
		if (categoryNo == 2348) or (categoryNo == 805) then
		    index = index - 1
		    x = ( (index-1) % 4) * ui.GetControlSetAttribute("tpshop_itemtp", 'width')
		    y = (math.ceil( (index / 4) ) - 1) * (ui.GetControlSetAttribute("tpshop_itemtp", 'height') * 1)
	
		    local itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_itemtp', 'eachitem_'..index, x, y);

		    local title = GET_CHILD_RECURSIVELY(itemcset,"title");
		    local staticTPbox = GET_CHILD_RECURSIVELY(itemcset,"staticTPbox")
		    local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");
		    			
		    local cls = GetClassByType("Item", itemClsID);
		    if cls == nil  then
		    	return;
		    end
		    SET_SLOT_IMG(slot, cls.Icon);
		    
		    staticTPbox:SetText("{img Nexon_cash_mark 30 30}{/}{@st43}{s18}".. itemPrice .."{/}");
		    title:SetText(ItemClassName);

		    local icon = slot:GetIcon();

		    buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");	
		    buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, productNo);
		    buyBtn:SetEventScriptArgString(ui.LBUTTONUP, string.format("%d", itemClsID));
			buyBtn:SetUserValue("LISTINDEX", i);
		elseif (categoryNo == 806) or (categoryNo == 2349)  then				
		    local specialGoods = GET_CHILD(tpSubgbox,"specialGoods");	
		    if imgURL ~= nil then	
		    	local imgAddress = string.format("%s", imgURL);
		    	if string.len(imgAddress) > 0 then
		    		if listcnt == 0 or clsList == nil then
		    			return;
		    		end	

		    		local retNum = -1;
		    		local jobCountMax = 0;
		    		for j = 0, listcnt - 1 do
		    			local obj = GetClassByIndexFromList(clsList, j);	
						retNum = CHECK_APPLY_PACKAGE_CLSID(itemClsID, obj);	
		    			if retNum > 0 then
		    				ItemClassName = obj.Name;	
		    				item_package = obj;
		    				packageClsID = obj.ClassID;
		    				jobCountMax = obj.jobCount;
		    				packageJobCount = packageJobCount + 1;
		    				break;
		    			end
		    		end	
		    		
		    		local package_Btn = nil;														
		    		local bisCaption = false; 
		    		if retNum > 0 then				
		    			if packageJobCount == 1 then
		    				specialGoodCount = specialGoodCount + 1;
		    				bisCaption = true;											
		    				limitOnce = 0;
		    				itemPrice = 0;
		    				productNo = 0;		
		    				package_Btn = tpSubgbox:CreateOrGetControl('button', 'specialProduct_'..specialGoodCount, 0, 0, ui.RIGHT, ui.TOP, 0, 40, 0, 0);		
		    				
		    				tolua.cast(package_Btn, "ui::CButton");
		    				package_Btn:SetImage("market_number_btn");											
		    				package_Btn:SetText(string.format("{@st66d}{s20}%d{/}", specialGoodCount));

		    				-- 직업과 성별에 따라 디폴트 패키지 를 선정하여 먼저 띄우기
		    				itemClsID = packageClsID;	
		    				local packageCls = GetClassByType("item_package", packageClsID);
		    				local clsID = GET_PACKAGE_CLSID_BYTYPE(jobNum, packageCls);
		    				if clsID == nil then
		    					package_Btn:SetUserValue("DEFAULT_CLSID", iteminfo.tpItemClsId);	
		    				else
		    					package_Btn:SetUserValue("DEFAULT_CLSID", clsID);	
		    				end
		    				package_Btn:SetUserValue("jobCountMax", jobCountMax);					
		    			else
		    				package_Btn = tpSubgbox:GetControlSet('button', 'specialProduct_'..specialGoodCount);
		    			end
		    													
		    			if package_Btn == nil then
		    				break;
		    			end				
		    			package_Btn:SetUserValue("LISTINDEX_"..retNum, i);	
		    		else
		    			bisCaption = true;
		    			packageClsID = 0;
		    			packageJobCount = 0;
		    			specialGoodCount = specialGoodCount + 1;
		    		end		

		    		if bisCaption == true then												
		    			package_Btn = tpSubgbox:CreateOrGetControl('button', 'specialProduct_'..specialGoodCount, 0, 0, ui.RIGHT, ui.TOP, 0, 40, 0, 0);
		    			
		    			tolua.cast(package_Btn, "ui::CButton");
		    			package_Btn:SetImage("market_number_btn");
		    			package_Btn:SetText(string.format("{@st66d}{s20}%d{/}", specialGoodCount));
		    			package_Btn:EnableHitTest(1);
		    			package_Btn:SetEventScript(ui.LBUTTONUP, '_TPSHOP_SELECTED_SPECIALGOODS');
		    			package_Btn:SetEventScriptArgNumber(ui.LBUTTONUP, productNo);
		    			package_Btn:SetEventScriptArgString(ui.LBUTTONUP, string.format("%d", itemClsID));
		    			
		    			package_Btn:SetUserValue("LISTINDEX", i);
		    			package_Btn:SetUserValue("jobCountMax", jobCountMax);
		    												
		    		end
		    		
		    		lastControlset = package_Btn;
		    		if packageJobCount >= jobCountMax then
		    			packageJobCount = 0;
		    			packageClsID = 0;	
		    		end
		    		
		    	end
		    end
		else
							return; 
		end
	end
	
	frame:SetUserValue("SpecialGoodCount", specialGoodCount);
	if lastControlset == nil then
		return;
	end
	
	local right = 0;
	local breakRight = 0;
	for j = 0, specialGoodCount - 1 do
		local goodNumber = specialGoodCount - j;
		local package_Btn = tpSubgbox:CreateOrGetControl('button', 'specialProduct_'..goodNumber, 35, 38, ui.RIGHT, ui.TOP, 0, 25, right, 0);		
		right = right + 35;
		lastControlset = package_Btn;
	end  		
	
	if specialGoodCount > 0 then
		tpSubgbox:SetUserValue("NUM_GOODS", specialGoodCount);
		tpSubgbox:SetUserValue("NUM_GOODNO", 1);
		
		tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
		tpSubgbox:RunUpdateScript("_PROCESS_ROLLING_SPECIALGOODS",  3, 0, 1, 1);
	end
	TPSHOP_SELECTED_SPECIALGOODS(tpSubgbox, lastControlset, lastControlset:GetEventScriptArgString(ui.LBUTTONUP), lastControlset:GetEventScriptArgNumber(ui.LBUTTONUP));		
	mainSubGbox:Invalidate()
	frame:Invalidate()
end

function _TPSHOP_STOPROLLING_SPECIALGOODS(parent, control, strArg, numArg)	
	local frame = ui.GetFrame("tpitem");
	local tpSubgbox = GET_CHILD_RECURSIVELY(frame,"tpSubgbox");	
	tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
end

function _TPSHOP_SELECTED_SPECIALGOODS(parent, control, strArg, numArg)	
	local frame = ui.GetFrame("tpitem");
	local tpSubgbox = GET_CHILD_RECURSIVELY(frame,"tpSubgbox");	
	tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
	TPSHOP_SELECTED_SPECIALGOODS(parent, control, strArg, numArg);
end


function _PROCESS_ROLLING_SPECIALGOODS()
	local frame = ui.GetFrame("tpitem");
	local tpSubgbox = GET_CHILD_RECURSIVELY(frame,"tpSubgbox");	
	local max = tpSubgbox:GetUserIValue("NUM_GOODS");
	local num = tpSubgbox:GetUserIValue("NUM_GOODNO");
	
	local tabObj		    = GET_CHILD_RECURSIVELY(frame,"shopTab");	
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");

	if itembox_tab:GetSelectItemIndex() ~= 0 then
		tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
		return 0;
	end

	local package_Btn = tpSubgbox:GetControlSet('button', 'specialProduct_'..num);
	if package_Btn == nil then
		tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
		return 0;
	end
	TPSHOP_SELECTED_SPECIALGOODS(tpSubgbox, package_Btn, package_Btn:GetEventScriptArgString(ui.LBUTTONUP), package_Btn:GetEventScriptArgNumber(ui.LBUTTONUP));

	num = num + 1;
	if num > max then 
		num = 1;    
	end

	tpSubgbox:SetUserValue("NUM_GOODNO", num);
	tpSubgbox:Invalidate();
	return 1;
end

function GETPACKAGE_JOBNUM_BYJOBNGENDER()
	local gender = GETMYPCGENDER();
	local jobNum = 0;
	local jobCls = GetClassByType("Job", GETMYPCJOB());
	SWITCH(jobCls.CtrlType) {				
	["Warrior"] = function() jobNum = gender; end,				
	["Wizard"] = function() jobNum = (2 * 1) + gender; end,				
	["Archer"] = function() jobNum = (2 * 2) + gender; end,				
	["Cleric"] = function() jobNum = (2 * 3) + gender; end,
	default = function() jobNum = 0 end,
	}	
	return jobNum;
end

function CHECK_APPLY_PACKAGE_CLSID(itemclsID, obj)
	local ret = 0;

	SWITCH(itemclsID) {				
	[obj.War_M] = function() ret = 1; end,				
	[obj.War_F] = function() ret = 2; end,				
	[obj.Wiz_M] = function() ret = 3; end,				
	[obj.Wiz_F] = function() ret = 4; end,				
	[obj.Arc_M] = function() ret = 5; end,				
	[obj.Arc_F] = function() ret = 6; end,				
	[obj.Clr_M] = function() ret = 7; end,			
	[obj.Clr_F] = function() ret = 8; end,				
	default = function() end,
	}	
	return ret;
end

function GET_PACKAGE_CLSID_BYTYPE(typeNum, cls)
	local ret = nil;
	SWITCH(typeNum) {				
	[1] = function() ret = cls.War_M; end,				
	[2] = function() ret = cls.War_F; end,				
	[3] = function() ret = cls.Wiz_M; end,				
	[4] = function() ret = cls.Wiz_F; end,				
	[5] = function() ret = cls.Arc_M; end,				
	[6] = function() ret = cls.Arc_F; end,				
	[7] = function() ret = cls.Clr_M; end,			
	[8] = function() ret = cls.Clr_F; end,				
	default = function() end,
	}	
	return ret;
end

function GETJOBSCP_BYINDEX_FROM_PACKAGELIST(clsID, typeNum)
	local ret = nil;	
	local male = 1;
	local obj = GetClassByType("item_package", clsID)
	if obj == nil then
		return;
	end	
	SWITCH(typeNum) {				
	[1] = function() ret = "market_warrior_btn"; male = 1; end,				
	[2] = function() ret = "market_warrior_btn"; male = 0; end,				
	[3] = function() ret = "market_mage_btn"; male = 1; end,				
	[4] = function() ret = "market_mage_btn"; male = 0; end,				
	[5] = function() ret = "market_archer_btn"; male = 1; end,				
	[6] = function() ret = "market_archer_btn"; male = 0; end,				
	[7] = function() ret = "market_cleric_btn"; male = 1; end,			
	[8] = function() ret = "market_cleric_btn"; male = 0; end,				
	default = function() end,
	}	
	return ret, male;
end

function TPSHOP_SELECTED_SPECIALGOODS(parent, control, strArg, numArg)		
	frame = parent:GetTopParentFrame()
	local cnt = parent:GetUserIValue("NUM_GOODS");
	for i = 1 , cnt do
		 local specialProduct = parent:GetControlSet('button',"specialProduct_" .. i);	
		 if specialProduct ~= nil then
			tolua.cast(specialProduct, "ui::CButton");
			specialProduct:SetImage("market_number_btn");
		 end
	end
	tolua.cast(control, "ui::CButton");
	control:SetImage("market_number2_btn");

	if numArg > 0 then
		TPSHOP_SELECTED_SPECIALGOODS_BANNER(parent, control, strArg, numArg);
	elseif numArg == 0 then
		TPSHOP_SELECTED_SPECIALPACKAGES_BANNER(parent, control, strArg, numArg);		
	end
	parent:Invalidate();
	frame:Invalidate();
end

function TPSHOP_SELECTED_SPECIALGOODS_BANNER(tpSubgbox, control, strArg, numArg)

	if (1 == IsMyPcGM_FORNISMS()) and ((config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP")) then
		local listIndex = control:GetUserValue("LISTINDEX");
		local iteminfo = session.ui.Get_NISMS_ItemInfo(listIndex)
		if iteminfo == nil then
			return;
		end
		
		local limitOnce = iteminfo.limitOnce;
		local price = iteminfo.price;
		local imgAddress = string.format("%d", iteminfo.tpItemClsId);	

		local specialGoods = GET_CHILD(tpSubgbox,"specialGoods");	
		specialGoods = tolua.cast(specialGoods, "ui::CWebPicture");	
		specialGoods:SetUrlInfo(GETBANNERURL(imgAddress));
		specialGoods:Invalidate();

	--local buyBtn = GET_CHILD(tpSubgbox,"specialBuyBtn");	
	--buyBtn:ShowWindow(1);									
	--buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, numArg);
	--buyBtn:SetEventScriptArgString(ui.LBUTTONUP, strArg);
	--buyBtn:SetUserValue("LISTINDEX", listIndex);
		
	--buyBtn:SetEventScript(ui.MOUSEMOVE, '_TPSHOP_STOPROLLING_SPECIALGOODS');
		
	--TPSHOP_SET_SPECIALPACKAGES_BANNER_BUTTONSET(tpSubgbox, buyBtn, 0);

	else
		local specialGoods = GET_CHILD(tpSubgbox,"specialGoods");	
		specialGoods = tolua.cast(specialGoods, "ui::CWebPicture");	
		specialGoods:SetUrlInfo(GETBANNERURL(strArg));
		specialGoods:Invalidate();
	end
end

function TPSHOP_SELECTED_SPECIALPACKAGES_BANNER(tpSubgbox, control, strArg, numArg)
	if (1 == IsMyPcGM_FORNISMS()) and ((config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP")) then	
		local clsList, listcnt = GetClassList('item_package');	
		if listcnt == 0 or clsList == nil then
			return;
		end	
		local retNum = -1;
		local obj = nil;
		local packageID = tonumber(strArg);
		local additionstr = "";
		if numArg <= 0 then
			local Default_itemClsID = control:GetUserIValue("DEFAULT_CLSID");
			obj = GetClassByIndexFromList(clsList, packageID -1);	
			retNum = CHECK_APPLY_PACKAGE_CLSID(Default_itemClsID, obj);	
			if retNum <= 0 then
				return;
			end			
		else
			retNum = numArg;
		end	

		local listIndex = control:GetUserValue("LISTINDEX_".. retNum);
		local iteminfo = session.ui.Get_NISMS_ItemInfo(listIndex)
		if iteminfo == nil then
			return;
		end
		
		local limitOnce = iteminfo.limitOnce;
		local price = iteminfo.price;
		local imgAddress = string.format("%d", iteminfo.tpItemClsId);
		local productNo = iteminfo.itemid;	
		local itemClsID = iteminfo.tpItemClsId;				
												
		local specialGoods = GET_CHILD(tpSubgbox,"specialGoods");	
		specialGoods = tolua.cast(specialGoods, "ui::CWebPicture");	
	specialGoods:SetUrlInfo(GETBANNERURL(imgAddress));

	--local buyBtn = GET_CHILD(tpSubgbox,"specialBuyBtn");	
	--if GETPACKAGE_JOBNUM_BYJOBNGENDER() == retNum then
	--	buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, productNo);
	--	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, itemClsID);
	--	buyBtn:SetUserValue("LISTINDEX", listIndex);
	--	buyBtn:ShowWindow(1);
	--else
	--	buyBtn:ShowWindow(0);
	--end
	--buyBtn:SetEventScript(ui.MOUSEMOVE, '_TPSHOP_STOPROLLING_SPECIALGOODS');
		
	--local jobCountMax = control:GetUserValue("jobCountMax");	
	--TPSHOP_SET_SPECIALPACKAGES_BANNER_BUTTONSET(tpSubgbox, buyBtn, 1, jobCountMax, packageID, control:GetName(), itemClsID, retNum);			
		
	else
		local specialGoods = GET_CHILD(tpSubgbox,"specialGoods");	
		specialGoods = tolua.cast(specialGoods, "ui::CWebPicture");	
		specialGoods:SetUrlInfo(GETBANNERURL(strArg));
		specialGoods:Invalidate();
	end		
end

function TPSHOP_SET_SPECIALPACKAGES_BANNER_BUTTONSET(tpSubgbox, buyBtn, isVisible, cnt, packageID, ctrlName, itemClsID, retNum)	
	local frame = ui.GetFrame("tpitem");
	local marginStr = frame:GetUserConfig("packageBtn_package_".. isVisible);		
	local marginList = StringSplit(marginStr, " ");	
	
	local tpPackageGbox = GET_CHILD(tpSubgbox,"tpPackageGbox");		
	tpPackageGbox:ShowWindow(0);		
	buyBtn:SetMargin(marginList[1], marginList[2], marginList[3], marginList[4]);
	
	if isVisible == 0 then
			DESTROY_CHILD_BYNAME(tpPackageGbox, 'joBtn_');	
		return;
	end

	if (cnt == nil) then
		return;
	end
	
	local width = 170;
	local hight = 45;
	local strSize = frame:GetUserConfig("packageBtn_package_Size");
	if strSize ~= nil then
		local sizeList = StringSplit(strSize, " ");	
		width = tonumber(sizeList[1]);
		hight = tonumber(sizeList[2]);
	end
	local y = 140;
	for i = 0, cnt do
		local strTemp, isMale = GETJOBSCP_BYINDEX_FROM_PACKAGELIST(packageID , i);
		if strTemp ~= nil then
			local jobBtn = tpPackageGbox:CreateOrGetControl('button', 'joBtn_'..i, 0, y, width, hight);
			jobBtn:SetGravity(ui.CENTER_HORZ, ui.TOP);
			jobBtn:SetTabName("gender_"..isMale);
			jobBtn:SetEventScript(ui.LBUTTONUP, 'TPSHOP_SPECIALPACKAGES_BANNER_CLICK_LBTNUP');
			jobBtn:SetEventScriptArgNumber(ui.LBUTTONUP, i);
			jobBtn:SetEventScriptArgString(ui.LBUTTONUP, ctrlName);
			jobBtn:SetUserValue("packageID", packageID);
			
			local strAdded = "";
			if i == retNum then
				strAdded = "Clicked_";
			end
			
			jobBtn = tolua.cast(jobBtn, "ui::CButton");	
			jobBtn:SetImage(strTemp);
			if retNum == i then
				jobBtn:SetColorTone("00000000");
			else
				jobBtn:SetColorTone("FF333333");
			end			

			if i%2 == 0 then
				y = y + 56;
			end;
		else
			DESTROY_CHILD_BYNAME(tpPackageGbox, 'joBtn_'..i);	
		end
		--tpPackageGbox:Resize(tpPackageGbox:GetWidth(), y + 7);
	end
end

function TPSHOP_SPECIALPACKAGES_BANNER_CLICK_LBTNUP(parent, control, strArg, numArg)	
	frame = parent:GetTopParentFrame();
	local text = GET_CHILD_RECURSIVELY(frame,strArg);	
	local tpSubgbox = GET_CHILD_RECURSIVELY(frame,'tpSubgbox');	
	packageID = control:GetUserValue("packageID");
	TPSHOP_SELECTED_SPECIALPACKAGES_BANNER(tpSubgbox, text, string.format("%d", packageID), numArg);
				
	control:SetGrayStyle(0);

	parent:Invalidate();
	frame:Invalidate();
end

--///////////////////////////////////////////////////////////////////////////////////////////TPITEM DRAW Code end

function TPSHOP_REFLASH_REMAINCASH(parent, control, strArg, numArg)
	if (config.GetServiceNation() == "THI") then
		REQ_NEXON_AMERICA_REFRESH();
	elseif 1 == IsMyPcGM_FORNISMS() then
		DebounceScript("ON_TPSHOP_REFLASH_REMAINCASH", 5);
	else
		ui.MsgBox(ClMsg("YouCanChargeOnWeb"));
	end
end

function ON_TPSHOP_REFLASH_REMAINCASH()
	ui.ReqRemainNexonCash();
end

function TPSHOP_SELECTED_SPECIALGOODS_BANNER_CLICK(parent, control, strArg, numArg)	
	local frame = ui.GetFrame("tpitem");
	local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
	local strURL = banner:GetUserValue("URL_BANNER");
	
	if strURL ~= 'None' and strURL ~= '' then
		login.OpenURL(strURL);
	end
end

function TPSHOP_TRY_BUY_TPITEM_BY_NEXONCASH(parent, control, ItemClassIDstr, itemid)
	if (config.GetServiceNation() == "THI") then
		ON_NEXON_AMERICA_BUY_ITEM(parent, control, ItemClassIDstr, itemid)
		return;
	else
		local frame = ui.GetFrame("tpitem");	
		
		local nMaxCnt = session.ui.Get_NISMS_CashInven_ItemListSize();
		if nMaxCnt >= 18 then
			strMsg = string.format("{@st43d}{s20}%s{/}", ScpArgMsg("MAX_CASHINVAN"));
			ui.MsgBox_NonNested(strMsg, 0x00000000, frame:GetName(), "None", "None");	
			return;
		end
		
		local screenbgTemp = frame:GetChild('screenbgTemp');	
		screenbgTemp:ShowWindow(1);	

		local listIndex = control:GetUserValue("LISTINDEX");
		local iteminfo = session.ui.Get_NISMS_ItemInfo(listIndex)
		if iteminfo == nil then
			return;
		end
		
		local amount = iteminfo.limitOnce;-- control:GetUserIValue("LimitOnce");	
		ui.BuyIngameShopItem(itemid, amount);
		return;
	end
end

function _TPSHOP_PURCHASE_RESULT(parent, control, msg, ret)
	local frame = ui.GetFrame("tpitem");

	if frame:IsVisible() == 0 then
		return;
	end

	local screenbgTemp = frame:GetChild('screenbgTemp');
	screenbgTemp:ShowWindow(1);
	local strSCP = "ON_TPSHOP_FREE_UI";
	
	local strMsg = "";
	local retValue = tonumber(ret);
	if retValue == 0 then
		strMsg = string.format("{@st66d}{s20}%s{/}{nl}{s10}{/} {/}{nl}{@st43d}{s18}%s{/}", ScpArgMsg("PutOnTheCashInven"), ScpArgMsg("CashInven_Guide"));
		
		local rightFrame = GET_CHILD(frame,"rightFrame");	
		local rightgbox = GET_CHILD(rightFrame,"rightgbox");	
		local cashInvGbox = GET_CHILD(rightgbox,"cashInvGbox");	
		local cashInvSlotSet = GET_CHILD(cashInvGbox,"cashInvSlotSet");	
		cashInvSlotSet = tolua.cast(cashInvSlotSet, "ui::CSlotSet");	
		cashInvSlotSet:ClearIconAll();	
		TPSHOP_SHOW_CASHINVEN_ITEMLIST();
	else		
		strMsg = string.format("{@st43d}{s18}%s{/}", ScpArgMsg("FAILED_PURCHASED_" .. retValue));
		if retValue == 12040 then		
			strSCP = "WEB_TPSHOP_OPEN_URL_NEXONCASH";	
		end
	end

	ui.MsgBox_NonNested(strMsg, 0x00000000, frame:GetName(), strSCP, "None");		
	return;
end


function _TPSHOP_PICKUP_RESULT(parent, control, msg, ret)
	local frame = ui.GetFrame("tpitem");
	
	if frame:IsVisible() == 0 then
		return;
	end

	local rightFrame = GET_CHILD(frame,"rightFrame");	
	local rightgbox = GET_CHILD(rightFrame,"rightgbox");	
	local cashInvGbox = GET_CHILD(rightgbox,"cashInvGbox");	
	local cashInvSlotSet = GET_CHILD(cashInvGbox,"cashInvSlotSet");	
	cashInvSlotSet = tolua.cast(cashInvSlotSet, "ui::CSlotSet");	
	cashInvSlotSet:ClearIconAll();	
	TPSHOP_SHOW_CASHINVEN_ITEMLIST();
end

function _TPSHOP_REFUND_RESULT(parent, control, msg, ret)
	local frame = ui.GetFrame("tpitem");
	
	if frame:IsVisible() == 0 then
		return;
	end

	local screenbgTemp = frame:GetChild('screenbgTemp');
	screenbgTemp:ShowWindow(1);
	
	local retValue = tonumber(ret);
	local strMsg = "";
	if (retValue == 3) or (retValue == 7) then
		retValue = 0;
	elseif retValue == 1 then		
		local rightFrame = GET_CHILD(frame,"rightFrame");	
		local rightgbox = GET_CHILD(rightFrame,"rightgbox");	
		local cashInvGbox = GET_CHILD(rightgbox,"cashInvGbox");	
		local cashInvSlotSet = GET_CHILD(cashInvGbox,"cashInvSlotSet");	
		cashInvSlotSet = tolua.cast(cashInvSlotSet, "ui::CSlotSet");	
		cashInvSlotSet:ClearIconAll();	
		TPSHOP_SHOW_CASHINVEN_ITEMLIST();
	end	

	strMsg = string.format("{@st43d}{s18}%s{/}", ScpArgMsg("FAILED_REFUND_" .. retValue));
	ui.MsgBox_NonNested(strMsg, 0x00000000, frame:GetName(), "ON_TPSHOP_FREE_UI", "None");		
	return;
end

function ON_TPSHOP_FREE_UI(parent, control, argStr, argNum)
	local frame = ui.GetFrame("tpitem");	
	local screenbgTemp = frame:GetChild('screenbgTemp');
	screenbgTemp:ShowWindow(0);
end

function TPSHOP_CHECK_REMAIN_NEXONCASH()
	local frame = ui.GetFrame("tpitem");
	local rightFrame = GET_CHILD(frame,"rightFrame");	
	local rightgbox = GET_CHILD(rightFrame,"rightgbox");	

	if config.GetServiceNation() == "THI" then
		ON_NEXON_AMERICA_BALANCE(frame)
	elseif 1 == IsMyPcGM_FORNISMS() then
		local haveStaticNCbox = GET_CHILD(rightgbox,"haveStaticNCbox");	
		local remainNexonCash = GET_CHILD_RECURSIVELY(haveStaticNCbox,"remainNexonCash");	
		remainNexonCash:SetText(session.ui.GetRemainCash());
	end

end

function WEB_TPSHOP_OPEN_URL_NEXONCASH()
	if 1 == IsMyPcGM_FORNISMS() then
	ON_TPSHOP_FREE_UI();
	local frame = ui.GetFrame("tpitem");	
	TPSHOP_TAB_VIEW(frame, 0);
	
	local leftgFrame = frame:GetChild("leftgFrame");	
	local leftgbox = leftgFrame:GetChild("leftgbox");
	local shopTab = leftgbox:GetChild('shopTab');
	local itembox_tab		= tolua.cast(shopTab, "ui::CTabControl");
	itembox_tab:SelectTab(0);

	ui.Embedded_Browser_forNC(ui.ExcNCurl());
	else
		ui.MsgBox(ClMsg("YouCanChargeOnWeb"));
	end
end

function TPSHOP_SHOW_CASHINVEN_ITEMLIST()
	local frame = ui.GetFrame("tpitem");
	local rightFrame = GET_CHILD(frame,"rightFrame");	
	local rightgbox = GET_CHILD(rightFrame,"rightgbox");	
	local cashInvGbox = GET_CHILD(rightgbox,"cashInvGbox");	
	local cashInvSlotSet = GET_CHILD(cashInvGbox,"cashInvSlotSet");	
	local currentPage = frame:GetUserValue("CASHINVEN_PAGENUMBER");
		
	local slotSet = tolua.cast(cashInvSlotSet, "ui::CSlotSet");	
	slotSet:ClearIconAll();
	local cnt = session.ui.Get_NISMS_CashInven_ItemListSize();
	if cnt == 0 then		
		return;
	end

	for i = 0, cnt - 1 do
		if i < 18 then
			local slot = cashInvSlotSet:GetSlot("slot".. (i + 1));
			if slot ~= nil then
				local iteminfo = session.ui.Get_NISMS_CashInven_ItemInfo(i);
				if iteminfo == nil then
					return;
				end
				local cls = GetClassByType("Item", iteminfo.ItemClsId);
				if cls == nil  then
					return;
				end
				
				local icon = CreateIcon(slot);
				if icon ~= nil then		
					SET_SLOT_IMG(slot, cls.Icon);
				end;

				icon:SetUserValue("itemClassID", iteminfo.ItemClsId);
				icon:SetUserValue("OrderNo", iteminfo.OrderNo);						
				icon:SetUserValue("ProductNo", iteminfo.ProductNo);					
				icon:SetUserValue("ProductName", iteminfo.ProductName);
				icon:SetUserValue("UnitPrice", iteminfo.UnitPrice);
				icon:SetUserValue("OrderPrice", iteminfo.OrderPrice);
				icon:SetUserValue("OrderDate", iteminfo.OrderDate);
				icon:SetUserValue("OrderQuantity", iteminfo.OrderQuantity);			
			end;			
		end
	end;
	rightgbox:Invalidate()
	frame:Invalidate()
end

function TPSHOP_CASHINVEN_ITEM_CLICKED(parent, ctrl)		

	local icon = ctrl:GetIcon();
	if icon == nil then		
		return;
	end
	TPITEM_SELECTED_OPEN(ctrl);
end

function _TPSHOP_BANNER(parent, control, argStr, argNum)
-- right banner
	local size = session.ui.GetSizeTPItemBannerCategory("Right");

	local frame = ui.GetFrame("tpitem");
	local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
	banner = tolua.cast(banner, "ui::CWebPicture");	
	
	if size <= 1 then
		banner:SetImage("market_event_test");	--market_default
	else
		local bannerInfo = session.ui.GetTPItemBannerCategoryByIndex("Right", 0);
		if bannerInfo ~= nil then
			local strImage = bannerInfo:GetimagePath();
			if string.len(strImage) <= 0 then
				banner:SetImage("market_event_test");	--market_default
			else
				banner:SetUrlInfo(GETBANNERURL(strImage));
			end;
			banner:SetUserValue("URL_BANNER", bannerInfo:GetclickUrl());
			banner:SetUserValue("NUM_BANNER", 0);
			
			banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
			banner:RunUpdateScript("_PROCESS_ROLLING_BANNER",  5, 0, 1, 1);
		end
	end
	banner:Invalidate();

-- bottom banner
	local leftgFrame = GET_CHILD(frame,"leftgFrame");	
	local leftgbox = GET_CHILD(leftgFrame,"leftgbox");	
	local tpSubgbox = GET_CHILD(leftgbox,"tpSubgbox");
	DESTROY_CHILD_BYNAME(tpSubgbox, "specialProduct_");
	local bottomBannerCount = session.ui.GetSizeTPItemBannerCategory("Bottom");
	if bottomBannerCount <= 1 then
		local specialGoods = GET_CHILD_RECURSIVELY(frame,"specialGoods");	
		specialGoods:SetImage("market_default4");
	else
		local last_Btn = nil
		for i = 1 , bottomBannerCount  do 
			local bannerInfo = session.ui.GetTPItemBannerCategoryByIndex("Bottom", i-1)
			if bannerInfo ~= nil then
				local package_Btn = tpSubgbox:CreateOrGetControl('button', 'specialProduct_'..i, 35, 38, ui.RIGHT, ui.TOP, 0, 25, 35 * (bottomBannerCount-i), 0);		
				tolua.cast(package_Btn, "ui::CButton");
				package_Btn:SetImage("market_number_btn");
				package_Btn:SetText(string.format("{@st66d}{s20}%d{/}", i));
				package_Btn:EnableHitTest(1);

				package_Btn:SetEventScript(ui.LBUTTONUP, '_TPSHOP_SELECTED_SPECIALGOODS');
				package_Btn:SetEventScriptArgNumber(ui.LBUTTONUP, 0);
				package_Btn:SetEventScriptArgString(ui.LBUTTONUP, bannerInfo:GetimagePath());
				
				package_Btn:SetUserValue("LISTINDEX", i);
				last_Btn = package_Btn;
			end
		end
		tpSubgbox:SetUserValue("NUM_GOODS", bottomBannerCount);
		tpSubgbox:SetUserValue("NUM_GOODNO", 1);
		tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
		tpSubgbox:RunUpdateScript("_PROCESS_ROLLING_SPECIALGOODS",  3, 0, 1, 1);
		TPSHOP_SELECTED_SPECIALGOODS(tpSubgbox, last_Btn, last_Btn:GetEventScriptArgString(ui.LBUTTONUP), last_Btn:GetEventScriptArgNumber(ui.LBUTTONUP));		
		tpSubgbox:Invalidate()
	end
end

function _PROCESS_ROLLING_BANNER()
	local size = session.ui.GetSizeTPItemBannerCategory("Right");
	local frame = ui.GetFrame("tpitem");
	local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
	banner = tolua.cast(banner, "ui::CWebPicture");	
		
	if size <= 1 then
		banner:SetImage("market_event_test");	--market_default
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
		return 0;
	else
		local num =	banner:GetUserIValue("NUM_BANNER");
		num = num + 1;
		if num >= size then 
			num = 0;
		end
		local bannerInfo = session.ui.GetTPItemBannerCategoryByIndex("Right", num);
		if bannerInfo ~= nil then
			local strImage = bannerInfo:GetimagePath();
			if strImage == 'None' then
				banner:SetImage("market_event_test");	--market_default	
			else
				banner:SetUrlInfo(GETBANNERURL(strImage));
			end;
			banner:SetUserValue("URL_BANNER", bannerInfo:GetclickUrl());
			banner:SetUserValue("NUM_BANNER", num);
		end
	end
	banner:Invalidate();
	return 1;
end

function IS_ENABLE_EQUIP_CLASS(pc, needJobClassName, needJobGrade)
	if pc == nil or needJobClassName == nil or needJobGrade == nil then
		return false;
	end

	local jobGrade, jobTotal = GetJobGradeByName(pc, needJobClassName);
	if jobGrade == nil then
		return false;
	end

	if jobGrade < needJobGrade then
		return false;
	end

	return true
end

function GETBANNERURL(webUrl)
	
	local url = config.GetBannerImgURL();	
	local urlStr = string.format("%s%s.png", url,webUrl );
	return urlStr;
end

function TPITEM_SET_ENABLE_BY_LIMITATION(buyBtn, tpitemCls)
	local itemCls = GetClass('Item', tpitemCls.ItemClassName);	
    local curBuyCount = session.shop.GetCurrentBuyLimitCount(0, tpitemCls.ClassID, itemCls.ClassID);    
    local accountLimitCount = TryGetProp(tpitemCls, 'AccountLimitCount');
    local monthLimitCount = TryGetProp(tpitemCls, 'MonthLimitCount');
	if (accountLimitCount ~= nil and accountLimitCount > 0 and curBuyCount >= accountLimitCount)
        or (monthLimitCount ~= nil and monthLimitCount > 0 and curBuyCount >= monthLimitCount) then
		buyBtn:SetSkinName('test_gray_button');
		buyBtn:SetText(ClMsg('ITEM_IsPurchased0'))
		buyBtn:EnableHitTest(0)
	end
end

function TPITEM_IS_ALREADY_PUT_INTO_BASKET(frame, tpitem)
	local slotset = GET_CHILD_RECURSIVELY(frame, 'basketslotset');
	local slotCount = slotset:GetSlotCount();	
	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);
		if slotIcon ~= nil then
			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			if tpitem.ClassName == classname then
				local alreadyItem = GetClass("TPitem", classname);
				if alreadyItem ~= nil then
					local item = GetClass("Item", alreadyItem.ItemClassName);				
					local allowDup = TryGetProp(item, 'AllowDuplicate');				
					if tpitem.SubCategory == "TP_Costume_Color" then
						return true;
					end				

					if allowDup == "NO" then
						return true;
					end			
				end
			end
		end
	end
	return false;
end

function TPITEM_SHOW_PACKAGELIST(parent, ctrl, argStr, itemID)
	PACKAGELIST_SHOW(itemID, argStr, parent:GetName());
end

g_tpItemMap = {};
function GET_TPITEMID_BY_ITEM_NAME(itemName)
	if #g_tpItemMap < 1 then
		local clslist, cnt = GetClassList('TPitem');
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clslist, i);
			g_tpItemMap[cls.ItemClassName] = cls.ClassID;
		end
	end
	return g_tpItemMap[itemID];
end

function CHECK_ALREADY_IN_LIMIT_ITEM(frame, tpItem)
	local limit = GET_LIMITATION_TO_BUY(tpItem.ClassID);
	if limit == 'NO' then
		return true;
	end

	local basketslotset = GET_CHILD_RECURSIVELY(frame, 'basketslotset');
	local slotCnt = basketslotset:GetSlotCount();
	for i = 0, slotCnt - 1 do
		local slot = basketslotset:GetSlotByIndex(i);
		if slot:GetUserValue('TPITEMNAME') == tpItem.ClassName then
			return false;		
		end	
	end
	return true;
end


function  TPITEM_CREATE_CATEGORY_TREE(categoryTree, categoryKey)
    local categoryCset = GET_CHILD(categoryTree, "TPSHOP_CT_" .. categoryKey)
	if categoryCset == nil then 
	    categoryCset = categoryTree:CreateControlSet("tpshop_tree", "TPSHOP_CT_" .. categoryKey, ui.LEFT, 0, 0, 0, 0, 0);
        local part = GET_CHILD(categoryCset, "part");
        part:SetTextByKey("value", ScpArgMsg(categoryKey));
		local foldimg = GET_CHILD(categoryCset,"foldimg");
		foldimg:ShowWindow(0);
    end
    return categoryCset
end

function TPITEM_CREATE_CATEGORY_ITEM(ctrlSet, categoryTree, categoryKey, subCategoryKey)
    local htreeitem = categoryTree:FindByValue(categoryKey);
    local tempFirstValue = nil
	if categoryTree:IsExist(htreeitem) == 0 then
	    htreeitem = categoryTree:Add(ctrlSet, categoryKey);
		tempFirstValue = categoryTree:GetItemValue(htreeitem)	
    end

    local hsubtreeitem = categoryTree:FindByCaption("{@st42b}"..ScpArgMsg(subCategoryKey));
	if categoryTree:IsExist(hsubtreeitem) == 0 and subCategoryKey ~= "None" then
		local added = categoryTree:Add(htreeitem, "{@st66}"..ScpArgMsg(subCategoryKey), categoryKey.."#"..subCategoryKey, "{#000000}");
			
		categoryTree:SetFitToChild(true,10);
		categoryTree:SetFoldingScript(htreeitem, "KEYCONFIG_UPDATE_FOLDING");
		local foldimg = GET_CHILD(ctrlSet,"foldimg");
		foldimg:ShowWindow(1);
    end
end