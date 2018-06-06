function PORTAL_SELLER_ON_INIT(addon, frame)
    
end

function PORTAL_SELLER_OPEN_UI(groupName, sellType, handle)
    local frame = ui.GetFrame('portal_seller');
    AUTOSELLER_SET_SELLER_VALUE(frame, groupName, sellType, handle);
    PORTAL_SELLER_SELECT_TAB(frame, 0);
    frame:ShowWindow(1);
end

function PORTAL_SELLER_SELECT_TAB(frame, tabIndex)
    local sellerTab = GET_CHILD(frame, 'sellerTab');
    sellerTab:SelectTab(tabIndex);
end

function PORTAL_SELLER_HIDE_BY_HANDLE(frame, handle)
    local visibleValue = 1;
    if session.GetMyHandle() ~= handle then
        visibleValue = 0;
    end

    local sellerTab = GET_CHILD_RECURSIVELY(frame, 'sellerTab');
    local ingredientBox = GET_CHILD_RECURSIVELY(frame, 'ingredientBox');
    sellerTab:ShowWindow(visibleValue);
    ingredientBox:ShowWindow(visibleValue);
    
    return visibleValue;
end

function PORTAL_SELLER_SELLER_TAB_INIT(frame, sellerBox)
    frame = frame:GetTopParentFrame();
    local handle = frame:GetUserIValue('HANDLE');
    PORTAL_SELLER_INIT_PORTAL_LIST(frame);

    if PORTAL_SELLER_HIDE_BY_HANDLE(frame, handle) == 1 then
        PORTAL_SHOP_REGISTER_INIT_INGREDIENT(frame, 'Sage_PortalShop');        
    end
end

function PORTAL_SELLER_INIT_PORTAL_LIST(frame)    
    local portalListBox = GET_CHILD_RECURSIVELY(frame, 'portalListBox');
    portalListBox:RemoveAllChild();

    local groupName = frame:GetUserValue('GroupName');
    local itemCount = session.autoSeller.GetCount(groupName);
    for i = 0, itemCount - 1 do
        local itemInfo = session.autoSeller.GetByIndex(groupName, i);
        local propValue = itemInfo:GetArgStr();

        local ctrlSet = portalListBox:CreateOrGetControlSet('sage_portal_sell_info', 'PORTAL_'..i, 0, 0);
        ctrlSet:SetUserValue('SELL_ITEM_INDEX', i);

        local portalInfoList = StringSplit(propValue, "@"); -- portalPos@openedTime
		local portalPosList = StringSplit(portalInfoList[1], "#"); -- zoneName#x#y#z

        -- name
        local mapName = portalPosList[1];
        local mapCls = GetClass('Map', mapName);
        local registerCheck = GET_CHILD_RECURSIVELY(ctrlSet, 'registerCheck');
        registerCheck:SetTextByKey('map', mapCls.Name);

        -- position
        local pos = GET_CHILD_RECURSIVELY(ctrlSet, 'pos');
        local x, y, z = portalPosList[2], portalPosList[3], portalPosList[4];
        pos:SetTextByKey('x', x);
        pos:SetTextByKey('y', y);
        pos:SetTextByKey('z', z);

        -- picture
        local isValid = ui.IsImageExist(mapName);
		if isValid == false then
			world.PreloadMinimap(mapName);
		end

        local pic = GET_CHILD_RECURSIVELY(ctrlSet, 'pic');
		pic:SetImage(mapName);

		local mapprop = geMapTable.GetMapProp(mapName);
		local mapPos = mapprop:WorldPosToMinimapPos(x, z, pic:GetWidth(), pic:GetHeight());
		local mark = GET_CHILD_RECURSIVELY(ctrlSet, 'mark');
        local picBox = GET_CHILD_RECURSIVELY(ctrlSet, 'picBox');
		local XC = picBox:GetX() + mapPos.x - 30;	
		local YC = picBox:GetY() + mapPos.y - 40;
		mark:Move(XC, YC);

        -- price
        local pc = GetMyPCObject();
        local priceText = GET_CHILD_RECURSIVELY(ctrlSet, 'priceText');
        local itemName, cnt = ITEMBUFF_NEEDITEM_Sage_PortalShop(pc, mapName);
        local cost = cnt * itemInfo.price;
        priceText:SetTextByKey('price', GET_COMMAED_STRING(cost));
    end
    GBOX_AUTO_ALIGN(portalListBox, 0, 0, 0, true, false);
end

function PORTAL_SELLER_HISTORY_TAB_INIT(frame, historyBox)
    PORTAL_SELLER_UPDATE_HISTORY(frame);   
end

function PORTAL_SELLER_CLOSE_UI()
    ui.CloseFrame('portal_seller');
end

function PORTAL_SELLER_CLOSE(parent, btn)
    local frame = parent:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then    
		return;
	end	
	session.autoSeller.Close(groupName);

	PORTAL_SELLER_CLOSE_UI();
end

function SAGE_PORTAL_SELL_INFO_OK_BTN(ctrlSet, btn)
    local frame = ctrlSet:GetTopParentFrame();
    local handle = frame:GetUserIValue('HANDLE');
    local sellType = frame:GetUserIValue('SELL_TYPE');
    local index = ctrlSet:GetUserIValue('SELL_ITEM_INDEX');
    session.autoSeller.Buy(handle, index, 1, sellType);    
end

function PORTAL_SELLER_UPDATE_HISTORY(frame)
    local historyStrBox = GET_CHILD_RECURSIVELY(frame, 'logBox');
    historyStrBox:RemoveAllChild();

    local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);
	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = historyStrBox:CreateControlSet("squire_rpair_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		local sList = StringSplit(info:GetHistoryStr(), "#");
		local userName = sList[1];
		local UserName = GET_CHILD(ctrlSet, "UserName");
        local mapCls = GetClass('Map', sList[2]);        
		UserName:SetTextByKey("value", ScpArgMsg('{USER}UsePortalTo{MAP}', 'USER', userName, 'MAP', mapCls.Name));        
        ctrlSet:Resize(ctrlSet:GetWidth(), UserName:GetHeight());

        local itemName = ctrlSet:GetChild('itemName');
        local price = ctrlSet:GetChild('price');
        itemName:ShowWindow(0);
        price:ShowWindow(0);		
	end

	GBOX_AUTO_ALIGN(historyStrBox, 20, 10, 10, true, false);
end