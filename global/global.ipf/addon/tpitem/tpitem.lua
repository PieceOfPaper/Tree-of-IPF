function TP_SHOP_DO_OPEN(frame, msg, shopName, argNum)
	
	ui.CloseAllOpenedUI();
	ui.OpenIngameShopUI();	-- Tpshop을 열었을때에 Tpitem에 대한 정보와 NexonCash 정보 등을 서버에 요청한다.

	frame:ShowWindow(1);
	local leftgFrame = frame:GetChild("leftgFrame");	
	local leftgbox = leftgFrame:GetChild("leftgbox");
	local shopTab = leftgbox:GetChild('shopTab');
	local itembox_tab		= tolua.cast(shopTab, "ui::CTabControl");
	if (1 == IsMyPcGM_FORNISMS()) and ((config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP")) then		
		local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
		banner:SetImage("market_event_test");	--market_default
		banner:SetUserValue("URL_BANNER", "");
		banner:SetUserValue("NUM_BANNER", 0);
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
	else
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
	
	buyBtn = GET_CHILD_RECURSIVELY(frame,"specialBuyBtn");	
	buyBtn:ShowWindow(0);
	
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
	
	itembox_tab:SelectTab(0);
	TPSHOP_TAB_VIEW(frame, 0);
	
	local input = GET_CHILD_RECURSIVELY(frame, "input");
	local editDiff = GET_CHILD_RECURSIVELY(frame, "editDiff");
	input:ClearText();
	editDiff:SetVisible(1);
		
	local basketslotset = GET_CHILD_RECURSIVELY(frame,"basketslotset")
	basketslotset:ClearIconAll();
	local rcycle_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketbuyslotset")
	rcycle_basketbuyslotset:ClearIconAll();
	local rcycle_basketsellslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset")
	rcycle_basketsellslotset:ClearIconAll();
	
	local specialGoods = GET_CHILD_RECURSIVELY(frame,"specialGoods");	
	specialGoods:SetImage("market_default2");
		
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

	control.EnableControl(0);
	ui.SetUILock(true);
end