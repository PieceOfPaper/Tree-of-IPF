-- tpitem.lua : (tp shop)
function TPSHOP_TAB_VIEW(frame, curtabIndex)
	local frame = ui.GetFrame("tpitem");
	local rightFrame = frame:GetChild('rightFrame');
	local rightgbox = rightFrame:GetChild('rightgbox');
	local basketgbox = rightgbox:GetChild('basketgbox');
	local previewgbox = rightgbox:GetChild('previewgbox');
	local previewStaticTitle = rightgbox:GetChild('previewStaticTitle');
	local cashInvGbox = rightgbox:GetChild('cashInvGbox');	
	local screenbgTemp = frame:GetChild('screenbgTemp');
	screenbgTemp:ShowWindow(0);
	local tpSubgbox = GET_CHILD_RECURSIVELY(frame,"tpSubgbox");	
	local rcycle_basketgbox = GET_CHILD_RECURSIVELY(frame,'rcycle_basketgbox');
	
	local rcycle_toitemBtn = GET_CHILD_RECURSIVELY(frame, 'rcycle_toitemBtn');
	local basketBuyBtn = GET_CHILD_RECURSIVELY(frame, 'basketBuyBtn');
	basketBuyBtn:SetEnable(1);
	rcycle_toitemBtn:SetEnable(1);
		
	if (1 == IsMyPcGM_FORNISMS()) and ((config.GetServiceNation() == "KOR") or (config.GetServiceNation() == "JP")) then		
	if curtabIndex == 0 then	
		TPITEM_DRAW_NC_TP();
		TPSHOP_SHOW_CASHINVEN_ITEMLIST();
		basketgbox:SetVisible(0);
		previewgbox:SetVisible(0);
		previewStaticTitle:SetVisible(0);	
		cashInvGbox:SetVisible(1);
		rcycle_basketgbox:SetVisible(0);
			tpSubgbox:StopUpdateScript("_PROCESS_ROLLING_SPECIALGOODS");
			tpSubgbox:RunUpdateScript("_PROCESS_ROLLING_SPECIALGOODS",  3, 0, 1, 1);
	elseif curtabIndex == 1 then
		basketgbox:SetVisible(1);
		previewgbox:SetVisible(1);
		previewStaticTitle:SetVisible(1);
		cashInvGbox:SetVisible(0);
		rcycle_basketgbox:SetVisible(0);
	elseif curtabIndex == 2 then -- 리사이클 샵
		rcycle_basketgbox:SetVisible(1);
		previewStaticTitle:SetVisible(1);	
		previewgbox:SetVisible(1);
		basketgbox:SetVisible(0);
		cashInvGbox:SetVisible(0);
		RECYCLE_SHOW_TO_ITEM()
	elseif curtabIndex == 3 then
		basketBuyBtn:SetEnable(0);
		rcycle_toitemBtn:SetEnable(0);
	end
	else
	if curtabIndex == 0 then
		basketgbox:SetVisible(1);
		previewgbox:SetVisible(1);
		previewStaticTitle:SetVisible(1);
		cashInvGbox:SetVisible(0);
		rcycle_basketgbox:SetVisible(0);
	elseif curtabIndex == 1 then -- 리사이클 샵
		rcycle_basketgbox:SetVisible(1);
		previewStaticTitle:SetVisible(1);	
		previewgbox:SetVisible(1);
		basketgbox:SetVisible(0);
		cashInvGbox:SetVisible(0);
		RECYCLE_SHOW_TO_ITEM()
	end
end
end

function TP_SHOP_DO_OPEN(frame, msg, shopName, argNum)
	
	ui.CloseAllOpenedUI();
	ui.OpenIngameShopUI();	-- Tpshop을 열었을때에 Tpitem에 대한 정보와 NexonCash 정보 등을 서버에 요청한다.
	session.shop.RequestLoadShopBuyLimit();
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
	        local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
		banner:SetImage("market_event_test");
		
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
		
		if itembox_tab:GetItemCount() == 4 then
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
				return false;
			end
		end
	end
	return false;
end

function TPSHOP_SELECTED_SPECIALGOODS(parent, control, strArg, numArg)		
	frame = parent:GetTopParentFrame()
	local cnt = frame:GetUserIValue("SpecialGoodCount");
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
	
	local buyBtn = GET_CHILD(tpSubgbox,"specialBuyBtn");	
	buyBtn:ShowWindow(1);									
	buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, numArg);
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, strArg);
	buyBtn:SetUserValue("LISTINDEX", listIndex);
	
	buyBtn:SetEventScript(ui.MOUSEMOVE, '_TPSHOP_STOPROLLING_SPECIALGOODS');
	
	TPSHOP_SET_SPECIALPACKAGES_BANNER_BUTTONSET(tpSubgbox, buyBtn, 0);	
end

function TPSHOP_SELECTED_SPECIALPACKAGES_BANNER(tpSubgbox, control, strArg, numArg)
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
	
	local buyBtn = GET_CHILD(tpSubgbox,"specialBuyBtn");	
	if GETPACKAGE_JOBNUM_BYJOBNGENDER() == retNum then
		buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, productNo);
		buyBtn:SetEventScriptArgString(ui.LBUTTONUP, itemClsID);
		buyBtn:SetUserValue("LISTINDEX", listIndex);
		buyBtn:ShowWindow(1);
	else
		buyBtn:ShowWindow(0);
	end
	buyBtn:SetEventScript(ui.MOUSEMOVE, '_TPSHOP_STOPROLLING_SPECIALGOODS');
			
	local jobCountMax = control:GetUserValue("jobCountMax");	
	TPSHOP_SET_SPECIALPACKAGES_BANNER_BUTTONSET(tpSubgbox, buyBtn, 1, jobCountMax, packageID, control:GetName(), itemClsID, retNum);			
end

--///////////////////////////////////////////////////////////////////////////////////////////TPITEM DRAW Code end

function _TPSHOP_BANNER(parent, control, argStr, argNum)
	local size = session.ui.GetSize_TPITEM_Banner_INFOList();

	local frame = ui.GetFrame("tpitem");
	local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
	banner = tolua.cast(banner, "ui::CWebPicture");	

	if size <= 1 then
		banner:SetImage("market_event_test");	--market_default
	else
		local bannerInfo = session.ui.Getlistitem_TPITEM_Banner_byIndex(0);
		local strImage = bannerInfo.imagePath;
		if string.len(strImage) <= 0 then
			banner:SetImage("market_event_test");	--market_default
		else
			banner:SetUrlInfo(GETBANNERURL(strImage));
		end;
		banner:SetUserValue("URL_BANNER", bannerInfo.clickUrl);
		banner:SetUserValue("NUM_BANNER", 0);
		
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
		banner:RunUpdateScript("_PROCESS_ROLLING_BANNER",  5, 0, 1, 1);
	end
	banner:Invalidate();
end

function _PROCESS_ROLLING_BANNER()
	local size = session.ui.GetSize_TPITEM_Banner_INFOList();
	local frame = ui.GetFrame("tpitem");
	local banner = GET_CHILD_RECURSIVELY(frame,"banner");	
	banner = tolua.cast(banner, "ui::CWebPicture");	
		
	if size <= 0 then
		banner:SetImage("market_event_test");	--market_default
		banner:StopUpdateScript("_PROCESS_ROLLING_BANNER");
		return 0;
	else
		local num =	banner:GetUserIValue("NUM_BANNER");
		num = num + 1;
		if num >= size then 
			num = 0;
		end
		local bannerInfo = session.ui.Getlistitem_TPITEM_Banner_byIndex(num);
		local strImage = bannerInfo.imagePath;
		if strImage == 'None' then
			banner:SetImage("market_event_test");	--market_default	
		else
			banner:SetUrlInfo(GETBANNERURL(strImage));
		end;
		banner:SetUserValue("URL_BANNER", bannerInfo.clickUrl);
		banner:SetUserValue("NUM_BANNER", num);
	end
	banner:Invalidate();
	return 1;
end