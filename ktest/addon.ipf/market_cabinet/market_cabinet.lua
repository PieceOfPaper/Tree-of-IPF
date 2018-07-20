
function MARKET_CABINET_ON_INIT(addon, frame)
		addon:RegisterMsg("CABINET_ITEM_LIST", "ON_CABINET_ITEM_LIST");
end

function MARKET_CABINET_OPEN(frame)
	market.ReqCabinetList();
end

function SHOW_REMAIN_NEXT_TIME_GET_CABINET(ctrl)
	if nil == ctrl then
		return 0;
	end
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;

	if 0 >= startSec then
		local frame = ctrl:GetParent();
		local btn = frame:GetChild("btn");
		btn:SetEnable(1);
		ctrl:SetTextByKey("value", ClMsg("Receieve"));
		ctrl:StopUpdateScript("SHOW_REMAIN_NEXT_TIME_GET_CABINET");
		return 0;
	end
	local timeTxt = GET_TIME_TXT(startSec);
	ctrl:SetTextByKey("value", "{s16}{#ffffcc}(" .. timeTxt..")");
	return 1;
end

function ON_CABINET_ITEM_LIST(frame)
	local itemGbox = GET_CHILD(frame, "itemGbox");
	local itemlist = GET_CHILD(itemGbox, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();

	local cnt = session.market.GetCabinetItemCount();
	local sysTime = geTime.GetServerSystemTime();		
	for i = 0 , cnt - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		local itemID = cabinetItem:GetItemID();
		local itemObj = GetIES(cabinetItem:GetObject());
		local registerTime = cabinetItem:GetRegSysTime();
		local difSec = imcTime.GetDifSec(registerTime, sysTime);
		if 0 >= difSec then
			difSec =0;
		end
		local timeString = GET_TIME_TXT(difSec);

		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_cabinet_item_detail");
		ctrlSet:Resize(itemlist:GetWidth() - 20, ctrlSet:GetHeight());		
		AUTO_CAST(ctrlSet);

		-- get skin and text style
		local BUY_SUCCESS_IMAGE = ctrlSet:GetUserConfig('BUY_SUCCESS_IMAGE');
		local SELL_SUCCESS_IMAGE = ctrlSet:GetUserConfig('SELL_SUCCESS_IMAGE');
		local SELL_CANCEL_IMAGE = ctrlSet:GetUserConfig('SELL_CANCEL_IMAGE');
		local DEFAULT_TYPE_IMAGE = ctrlSet:GetUserConfig('DEFAULT_TYPE_IMAGE');
        local BUY_SUCCESS_TEXT_STYLE = ctrlSet:GetUserConfig('BUY_SUCCESS_TEXT_STYLE');
        local SELL_SUCCESS_TEXT_STYLE = ctrlSet:GetUserConfig('SELL_SUCCESS_TEXT_STYLE');
        local SELL_CANCEL_TEXT_STYLE = ctrlSet:GetUserConfig('SELL_CANCEL_TEXT_STYLE');

        -- type
        local typeBox = GET_CHILD_RECURSIVELY(ctrlSet, 'typeBox');
        local typeText = typeBox:GetChild('typeText');
        local whereFrom = cabinetItem:GetWhereFrom();
        ctrlSet:SetUserValue('CABINET_TYPE', whereFrom);
        if whereFrom == 'market_sell' then -- 판매 완료
            typeBox:SetImage(SELL_SUCCESS_IMAGE);
            typeText:SetTextByKey('textStyle', SELL_SUCCESS_TEXT_STYLE);
            typeText:SetTextByKey('type', ClMsg('SellSuccess'));
        elseif whereFrom == 'market_buy' then -- 구매 완료
            typeBox:SetImage(BUY_SUCCESS_IMAGE);
            typeText:SetTextByKey('textStyle', BUY_SUCCESS_TEXT_STYLE);
            typeText:SetTextByKey('type', ClMsg('BuySuccess'));
        elseif whereFrom == 'market_cancel' or whereFrom == 'market_expire' then -- 판매 취소, 판매 기한 완료
            typeBox:SetImage(SELL_CANCEL_IMAGE);
            typeText:SetTextByKey('textStyle', SELL_CANCEL_TEXT_STYLE);
            typeText:SetTextByKey('type', ClMsg('SellCancel'));
        else
            typeBox:SetImage(DEFAULT_TYPE_IMAGE);
        end

        -- item picture and name
		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
        local itemImage = GET_ITEM_ICON_IMAGE(itemObj);
		pic:SetImage(itemImage);
		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		-- etc box
		local etcBox = GET_CHILD_RECURSIVELY(ctrlSet, 'etcBox');
		local etcShow = false;
		if whereFrom ~= 'market_sell' and whereFrom ~= 'market_buy' and itemObj.ClassName ~= MONEY_NAME then
			local etcText = etcBox:GetChild('etcText');
			etcText:SetTextByKey('count', cabinetItem.count);
			etcBox:ShowWindow(1);
			etcShow = true;
		else
			etcBox:ShowWindow(0);
		end

        -- buy count
        local buyBox = GET_CHILD_RECURSIVELY(ctrlSet, 'buyBox');
        if whereFrom == 'market_buy' then
        	local buyCount = buyBox:GetChild('buyCount');
            buyCount:SetTextByKey('count', cabinetItem.count);
        elseif etcShow == true then
            buyBox:ShowWindow(0);
        end
   
        -- sell count
        local sellBox = GET_CHILD_RECURSIVELY(ctrlSet, 'sellBox');
        if whereFrom == 'market_sell' then
        	local sellCount = sellBox:GetChild('sellCount');
            local sellItemAmount = math.max(1, cabinetItem.sellItemAmount); -- 비스택형 아이템은 0으로 전달됨
        	sellCount:SetTextByKey('count', sellItemAmount);
        elseif etcShow == true then
        	sellBox:ShowWindow(0);
        end

        -- time
        local timeBox = GET_CHILD_RECURSIVELY(ctrlSet, 'timeBox');
        local endTime = timeBox:GetChild("endTime");
        if etcShow == true and difSec <= 0 then
        	timeBox:ShowWindow(0);
        else
        	endTime:SetTextByKey("value", timeString);
			if 0 == difSec then
				endTime:SetTextByKey("value", ClMsg("Auto_JongLyo"));
			else
				endTime:SetUserValue("REMAINSEC", difSec);
				endTime:SetUserValue("STARTSEC", imcTime.GetAppTime());
				SHOW_REMAIN_NEXT_TIME_GET_CABINET(medalFreeTime);
				endTime:RunUpdateScript("SHOW_REMAIN_NEXT_TIME_GET_CABINET");
			end
        end		

        -- price
		local totalPrice = GET_CHILD_RECURSIVELY(ctrlSet, "totalPrice");
        if itemObj.ClassName == MONEY_NAME or (whereFrom == 'market_sell' and etcShow == false) then
			if cabinetItem.count < 70 then
				ClientRemoteLog("CABINET_ITEM_PRICE_ERROR - ".. cabinetItem.count);
			end

		    totalPrice:SetTextByKey("value", GetMonetaryString(cabinetItem.count));
        else
            totalPrice:ShowWindow(0);
        end

		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, cabinetItem, itemObj.ClassName, "cabinet", cabinetItem.itemType, cabinetItem:GetItemID());		
		
		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Receieve"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "CABINET_ITEM_BUY");
		btn:SetEventScriptArgString(ui.LBUTTONUP,cabinetItem:GetItemID());

		if 0 >= difSec then
			btn:SetEnable(1);
		else
			btn:SetEnable(0);
		end
		
	end
	GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, true, true);
	itemlist:RealignItems();

    -- default filter
    local buySuccessCheckBox = GET_CHILD_RECURSIVELY(frame, 'buySuccessCheckBox');
    local sellSuccessCheckBox = GET_CHILD_RECURSIVELY(frame, 'sellSuccessCheckBox');
    local sellCancelCheckBox = GET_CHILD_RECURSIVELY(frame, 'sellCancelCheckBox');
    local etcCheckBox = GET_CHILD_RECURSIVELY(frame, 'etcCheckBox');
    buySuccessCheckBox:SetCheck(1);
    sellSuccessCheckBox:SetCheck(1);
    sellCancelCheckBox:SetCheck(1);
    etcCheckBox:SetCheck(1);
    MARKET_CABINET_FILTER(frame);
end

function CABINET_GET_ALL_ITEM(parent, ctrl)
    local pc = GetMyPCObject();
    local now = pc.NowWeight
    local flag = 0
    local moneyItem = GetClass('Item', MONEY_NAME);
    if moneyItem == nil then
        return;
    end 

    local sysTime = geTime.GetServerSystemTime();		
	for i = 0 , session.market.GetCabinetItemCount() - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		local registerTime = cabinetItem:GetRegSysTime();
		local difSec = imcTime.GetDifSec(registerTime, sysTime);
		if 0 >= difSec then
		    local itemObj = GetIES(cabinetItem:GetObject());
            local itemWeight = itemObj.Weight;
            if cabinetItem:GetWhereFrom() == 'market_sell' then
                itemWeight = moneyItem.Weight;
            end
		    if pc.MaxWeight < now + (itemWeight * cabinetItem.count) then
		        flag = 1
		    else
		        market.ReqGetCabinetItem(cabinetItem:GetItemID());
		        now  = now + (itemWeight * cabinetItem.count)
		    end
        end
	end
	if flag == 1 then
	    addon.BroadMsg("NOTICE_Dm_!", ScpArgMsg("MAXWEIGHTMSG"), 10);
	end
	market.ReqCabinetList();
end

function CABINET_ITEM_BUY(frame, ctrl, guid)
	market.ReqGetCabinetItem(guid);
end

function MARKET_CABINET_FILTER(parent, checkBox)
    -- get check box
    local topFrame = parent:GetTopParentFrame();
    local buySuccessCheckBox = GET_CHILD_RECURSIVELY(topFrame, 'buySuccessCheckBox');
    local sellSuccessCheckBox = GET_CHILD_RECURSIVELY(topFrame, 'sellSuccessCheckBox');
    local sellCancelCheckBox = GET_CHILD_RECURSIVELY(topFrame, 'sellCancelCheckBox');
    local etcCheckBox = GET_CHILD_RECURSIVELY(topFrame, 'etcCheckBox');

    -- get checked value
    local showBuySuccess = buySuccessCheckBox:IsChecked();
    local showSellSuccess = sellSuccessCheckBox:IsChecked();
    local showSellCancel = sellCancelCheckBox:IsChecked();
    local showEtc = etcCheckBox:IsChecked();

    -- filter
    local itemlist = GET_CHILD_RECURSIVELY(topFrame, "itemlist", "ui::CDetailListBox");
    local rowCount = itemlist:GetRowCount();
    for i = 0, rowCount do
        local item = itemlist:GetObjectByRowCol(i, 0);
        local itemCtrlSet = tolua.cast(item, 'ui::CControlSet');
        if itemCtrlSet ~= nil then
            local cabinetType = itemCtrlSet:GetUserValue('CABINET_TYPE');
            itemCtrlSet:ShowWindow(1);
            if cabinetType == 'market_sell' and showSellSuccess == 0 then
                itemCtrlSet:ShowWindow(0);
            elseif cabinetType == 'market_buy' and showBuySuccess == 0 then
                itemCtrlSet:ShowWindow(0);
            elseif (cabinetType == 'market_cancel' or cabinetType == 'market_expire') and showSellCancel == 0 then
                itemCtrlSet:ShowWindow(0);
            elseif cabinetType ~= 'market_sell' and cabinetType ~= 'market_buy' and cabinetType ~= 'market_cancel' and cabinetType ~= 'market_expire' and showEtc == 0 then
                itemCtrlSet:ShowWindow(0);
            end
        end
    end

    GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, true, true, true);
	itemlist:RealignItems();
end