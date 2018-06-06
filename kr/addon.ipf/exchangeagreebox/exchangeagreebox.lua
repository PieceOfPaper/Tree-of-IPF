-- exchangAgreeBox.lua

function EXCHANGEAGREEBOX_ON_INIT(addon, frame)

end

function CHANGEAGREEBOX_FIANLAGREE_CLICK(frame, ctrl)
	ui.CloseFrame('exchangeagreebox');
	exchange.SendFinalAgreeExchangeMsg()
end

function OPEN_EXCHANGE_FILNAL_BOX(oppoTokenState)
	local frame = ui.GetFrame('exchangeagreebox')
	local bg2 = frame:GetChild('bg2');
	local itemList = bg2:GetChild('itemList');

	local myAccount = GetMyAccountObj()
	local myTradeCnt = TryGetProp(myAccount, "TradeCount")
	if myTradeCnt == nil then
		return
	end

	if (0 == oppoTokenState) or (false == session.loginInfo.IsPremiumState(ITEM_TOKEN)) or (myTradeCnt < 1) then
 		local itemCount = exchange.GetExchangeItemCount(1);	
		local listStr = "";
		for i = 0, itemCount-1 do
			local itemData = exchange.GetExchangeItemInfo(1,i);
			local class = GetClassByType('Item', itemData.type);
			if class.ItemType == 'Equip' then
				listStr = listStr .. string.format("%s",class.Name) .. "{nl}";
			end
		end

		local list = itemList:GetChild('list');
		list:SetTextByKey("value", listStr);
		local tokenState = bg2:GetChild('tokenState');
		tokenState:ShowWindow(0);
		local NotokenState = bg2:GetChild('NotokenState');
		NotokenState:ShowWindow(1);

		GBOX_AUTO_ALIGN(itemList, 0, 0, 20, true, true);

		itemList:ShowWindow(1);	
		bg2:Resize(bg2:GetOriginalWidth(), bg2:GetOriginalHeight() + itemList:GetHeight());
		frame:Resize(frame:GetOriginalWidth(), frame:GetOriginalHeight() + itemList:GetHeight() + 30);
		
		local exchange = bg2:GetChild('exchange');
		local exchangeRect = exchange:GetMargin();
		exchange:SetMargin(exchangeRect.left, exchangeRect.top, exchangeRect.right, 22);
		
		local cencel = bg2:GetChild('cencel');
		local cencelRect = cencel:GetMargin();
		cencel:SetMargin(cencelRect.left, 0, cencelRect.right, 22);
		
	else
		local tokenState = bg2:GetChild('tokenState');
		tokenState:ShowWindow(1);
		local NotokenState = bg2:GetChild('NotokenState');
		NotokenState:ShowWindow(0);
		itemList:ShowWindow(0);
		local exchange = bg2:GetChild('exchange');
		local exchangeRect = exchange:GetMargin();
		exchange:SetMargin(exchangeRect.left, 0, exchangeRect.right, exchangeRect.bottom);
		
		local cencel = bg2:GetChild('cencel');
		local cencelRect = cencel:GetMargin();
		cencel:SetMargin(cencelRect.left, 0, cencelRect.right, cencelRect.bottom);
		
		bg2:Resize(bg2:GetOriginalWidth(), bg2:GetOriginalHeight());
		frame:Resize(frame:GetOriginalWidth(), frame:GetOriginalHeight());
	end

	frame:ShowWindow(1);
end