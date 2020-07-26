
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
        if btn == nil then
            return 0;
        end
		btn:SetEnable(1);
		ctrl:SetTextByKey("value", ClMsg("Receieve"));
		ctrl:StopUpdateScript("SHOW_REMAIN_NEXT_TIME_GET_CABINET");
		return 0;
	end
	local timeTxt = GET_TIME_TXT(startSec);
    ctrl:SetTextByKey("value", timeTxt);
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

        --market_cabinet_item_detail / market_cabinet_item_etc
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
            typeText:SetTextByKey('type', ClMsg('SellSuccess'));
        elseif whereFrom == 'market_buy' then -- 구매 완료
            typeText:SetTextByKey('type', ClMsg('BuySuccess'));
        elseif whereFrom == 'market_cancel' or whereFrom == 'market_expire' then -- 판매 취소, 판매 기한 완료
            typeText:SetTextByKey('type', ClMsg('SellCancel'));
        end

        -- item picture and name
		local pic = GET_CHILD(ctrlSet, "pic", "ui::CSlot");
        local itemImage = GET_ITEM_ICON_IMAGE(itemObj);
        local icon = CreateIcon(pic)
        SET_SLOT_ITEM_CLS(pic, itemObj)
        icon:SetImage(itemImage);
        SET_SLOT_STYLESET(pic, itemObj)
        if itemObj.ClassName ~= MONEY_NAME and itemObj.MaxStack > 1 then
            local font = '{s16}{ol}{b}';
            local count = 0;
            if whereFrom == "market_sell" then
                count = cabinetItem.sellItemAmount;
            elseif whereFrom ~= "market_sell" then
                count = tonumber(cabinetItem:GetCount());  
            end

            if 100000 <= count then	-- 6자리 수 폰트 크기 조정
                font = '{s14}{ol}{b}';
            end

            SET_SLOT_COUNT_TEXT(pic, count, font);
		end
	    -- pic:SetImage(itemImage);
		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));

		-- etc box
		local etcBox = GET_CHILD_RECURSIVELY(ctrlSet, 'etcBox');
		local etcShow = false;
		if whereFrom ~= 'market_sell' and whereFrom ~= 'market_buy' and itemObj.ClassName ~= MONEY_NAME then
			local etcText = etcBox:GetChild('etcText');
			etcText:SetTextByKey('count', tonumber(cabinetItem:GetCount()));
			etcBox:ShowWindow(1);
			etcShow = true;
		else
			etcBox:ShowWindow(0);
		end

        -- time
        local timeBox = GET_CHILD_RECURSIVELY(ctrlSet, 'timeBox');
        local endTime = timeBox:GetChild("endTime");        
        if (etcShow == true and difSec <= 0) or whereFrom ~= 'market_sell' then
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

        -- fees / NEXON_PC 조건도 추가해야 된다. / 추후 작업
        --local fees = 0;
        --if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then					
			--fees = tonumber(cabinetItem:GetCount()) * 0.1
		--elseif false == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			--fees = tonumber(cabinetItem:GetCount()) * 0.3   			
		--end

        -- price (count - fees)
        local totalPrice = GET_CHILD_RECURSIVELY(ctrlSet, "totalPrice");            --10,000 처럼 표기
		local totalPriceStr = GET_CHILD_RECURSIVELY(ctrlSet, "totalPriceStr");      --1만    처럼 표기
        if itemObj.ClassName == MONEY_NAME or (whereFrom == 'market_sell' and etcShow == false) then
			if tonumber(cabinetItem:GetCount()) < 70 then
				ClientRemoteLog("CABINET_ITEM_PRICE_ERROR - ".. tonumber(cabinetItem:GetCount()));
            end
		    totalPrice:SetTextByKey("value", GET_COMMAED_STRING(tonumber(cabinetItem:GetCount())));
		    totalPriceStr:SetTextByKey("value", GetMonetaryString(tonumber(cabinetItem:GetCount())));
        else
            totalPrice:ShowWindow(0);
            totalPriceStr:ShowWindow(0);
        end

		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, cabinetItem, itemObj.ClassName, "cabinet", cabinetItem.itemType, cabinetItem:GetItemID());		
		
		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Receieve"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "CABINET_ITEM_BUY");
		btn:SetEventScriptArgString(ui.LBUTTONUP,cabinetItem:GetItemID());

		if 0 >= difSec or whereFrom ~= 'market_sell' then
			btn:SetEnable(1);
		else
			btn:SetEnable(0);
		end
		
	end
	GBOX_AUTO_ALIGN(itemlist:GetGroupBox(), 3, 0, 0, true, true);
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
    --pop up script open (06. 12. 최영준)
    ui.OpenFrame("market_cabinet_soldlist")
    local frame = ui.GetFrame("market_cabinet_soldlist")
    if frame == nil then
        return
    end

    local pc = GetMyPCObject();
    local now = pc.NowWeight
    local flag = 0
    local moneyItem = GetClass('Item', MONEY_NAME);
    if moneyItem == nil then
        return;
    end 

    INPUT_GETALL_MSG_BOX(frame, ctrl, now, flag, moneyItem);
end

function CABINET_GET_ITEM()
    local moneyItem = GetClass('Item', MONEY_NAME);
	local count = session.market.GetCabinetItemCount();

    local sysTime = geTime.GetServerSystemTime();		

	local cabinetItem = session.market.GetCabinetItemByIndex(0);
	if cabinetItem ~= nil then
		local registerTime = cabinetItem:GetRegSysTime();
		local difSec = imcTime.GetDifSec(registerTime, sysTime);

		if cabinetItem:GetWhereFrom() ~= 'market_sell' or 0 >= difSec then
			market.ReqGetCabinetItem(cabinetItem:GetItemID());
		end
	end
end

function CABINET_GET_ALL_LIST(frame, control, strarg, now)
    --market cabient 완료 (모두받기)
	local count = session.market.GetCabinetItemCount();
	AddLuaTimerFuncWithLimitCount("CABINET_GET_ITEM", 200, count * 5);

	local frame = ui.GetFrame("market_cabinet_soldlist")
	if frame ~= nil then
		ui.CloseFrame("market_cabinet_soldlist")
	end
end

function CABINET_ITEM_BUY(frame, ctrl, guid)
    local cabinetItem = session.market.GetCabinetItemByItemID(guid);
    local whereFrom = cabinetItem:GetWhereFrom();
    if whereFrom == "market_sell" then
	    INPUT_TEXTMSG_BOX(frame, "_CABINET_ITEM_BUY", charName, jobName, 1, 3, guid)
    elseif whereFrom ~= "market_sell" then
        INPUT_TEXTMSG_BOX(frame, "_CABINET_ITEM_ETC", charName, jobName, 1, 3, guid)
    end
end

function _CABINET_ITEM_BUY(frame, ctrl, guid)
    market.ReqGetCabinetItem(guid);

--  Close popup
    local popUp_frame = ui.GetFrame("market_cabinet_popup")
	if popUp_frame ~= nil then
		ui.CloseFrame("market_cabinet_popup")
	end
end

function _CABINET_ITEM_ETC(frame, ctrl, guid)

    --판매완료 상태의 아이템이 아닌 아이템을 받을 때 발동되는 함수. 
    --이 부분에서 나중에 상태를 "수령 완료" 상태로 변경한 뒤에 대기 시간을 조정하는 부분을 나중에 추가해야 될지도...
    --미리 작업 해보았을 때 마켓을 껏다가 키면 상태가 다시 원상 복귀 되어서 그 부분부터 수정을 해야 될듯 하다.
    --market_cabinet_item_detail 의 typeBox - typeText에 접근하여 상태를 변환 시켜야 된다.
    --Test Get ControlSet
    local marketFrame = ui.GetFrame("market_cabinet")
    local itemGbox = GET_CHILD(marketFrame, 'itemGbox', 'ui::CGroupBox')
    local itemlist = GET_CHILD(itemGbox, 'itemlist', 'ui::CDetailListBox')

    market.ReqGetCabinetItem(guid);
    
--  close popup
    local popup_frame = ui.GetFrame("market_cabinet_popup_etc")
	if popup_frame ~= nil then   
		ui.CloseFrame("market_cabinet_popup_etc")
	end
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

    GBOX_AUTO_ALIGN(itemlist, 3, 0, 0, true, true, true);
	itemlist:RealignItems();
end