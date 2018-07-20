-- packagelist.lua

function PACKAGELIST_SHOW(itemID, argStr, selectedCtrlSetName)
	local packageName = GET_PACKAGE_ITEM_NAME(itemID);	
	if packageName == 'None' then	
		return;
	end
	local frame = ui.GetFrame('packagelist');    
	PACKAGELIST_INIT(frame, itemID, argStr, packageName, selectedCtrlSetName);
	frame:ShowWindow(1);	
end

g_packageList = nil;
function GET_PACKAGE_CACHE_MAP()	
	if g_packageList == nil then -- build
		g_packageList ={}
		local clslist, cnt = GetClassList('Package_Item_List');	
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clslist, i);
			local itemInfo = g_packageList[cls.Group];            
			if itemInfo == nil then
				g_packageList[cls.Group] = {};
				itemInfo = g_packageList[cls.Group];
			end
			itemInfo[#itemInfo + 1] = { 
				ItemName = cls.ItemName,
				EquipType = cls.EquipType,
			}
		end
	end
	return g_packageList;
end

function GET_PACKAGE_ITEM_NAME(itemID)
	local packageItemMap = GET_PACKAGE_CACHE_MAP();	
	local itemCls = GetClassByType('Item', itemID);
	if packageItemMap[itemCls.ClassName] ~= nil then
		return itemCls.ClassName;
	end

    -- 패키지를 공유하는 아이템이 있을 수 있음
    local packageCls = GetClass('Beauty_Shop_Package_Cube', itemCls.ClassName);    
    if packageCls ~= nil and packageItemMap[packageCls.PackageList] ~= nil then
        return packageCls.PackageList;
    end

	return 'None';
end

function PACKAGELIST_EDIT_ON_TYPING(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local textEdit = GET_CHILD_RECURSIVELY(frame, 'textEdit');
	local curCount = 0;
	local countStr = textEdit:GetText();
	if countStr ~= nil and countStr ~= '' then
		curCount = tonumber(countStr);
	end

	local tpItemID = frame:GetUserIValue('TPITEM_ID');
	local tpItemCls = GetClassByType('TPitem', tpItemID);	
	if tpItemCls ~= nil then
		local limit = GET_LIMITATION_TO_BUY(tpItemID);
		if limit == 'ACCOUNT' and curCount + 1 > tpItemCls.AccountLimitCount then
			textEdit:SetText(tpItemCls.AccountLimitCount);
			ui.SysMsg(ScpArgMsg("PurchaseItemExceeded", "Value", tpItemCls.AccountLimitCount));			
			return;
		elseif limit == 'MONTH' and curCount + 1 > tpItemCls.MonthLimitCount then
			textEdit:SetText(tpItemCls.MonthLimitCount);
			ui.SysMsg(ScpArgMsg("PurchaseItemExceeded", "Value", tpItemCls.MonthLimitCount));
			return;
		end
	end
	local resCnt = math.min(20, curCount); -- 장바구니 개수까지만 
	textEdit:SetText(resCnt);
end

function PACKAGELIST_UP_BTN_CLICK(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local textEdit = GET_CHILD_RECURSIVELY(frame, 'textEdit');
	local curCount = 0;
	local countStr = textEdit:GetText();
	if countStr ~= nil and countStr ~= '' then
		curCount = tonumber(countStr);
	end

	local tpItemID = frame:GetUserIValue('TPITEM_ID');
	local tpItemCls = GetClassByType('TPitem', tpItemID);	
	if tpItemCls ~= nil then
		local limit = GET_LIMITATION_TO_BUY(tpItemID);
		if limit == 'ACCOUNT' and curCount + 1 > tpItemCls.AccountLimitCount then
			textEdit:SetText(tpItemCls.AccountLimitCount);
			ui.SysMsg(ScpArgMsg("PurchaseItemExceeded", "Value", tpItemCls.AccountLimitCount));			
			return;
		elseif limit == 'MONTH' and curCount + 1 > tpItemCls.MonthLimitCount then
			textEdit:SetText(tpItemCls.MonthLimitCount);
			ui.SysMsg(ScpArgMsg("PurchaseItemExceeded", "Value", tpItemCls.MonthLimitCount));
			return;
		end
	end

	local resCnt = math.min(20, curCount + 1); -- 장바구니 개수까지만 
	textEdit:SetText(resCnt);
end

function PACKAGELIST_DOWN_BTN_CLICK(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local textEdit = GET_CHILD_RECURSIVELY(frame, 'textEdit');
	local curCount = 0;
	local countStr = textEdit:GetText();
	if countStr ~= nil and countStr ~= '' then
		curCount = tonumber(countStr);
	end
	local nextCount = curCount - 1;
	if nextCount < 0 then
		nextCount = 0;
	end
	textEdit:SetText(nextCount);
end

function PACKAGELIST_PUT_INTO_BASKET(parent, ctrl)

	-- TPShop하고 같이 쓸 수 없다. 여기서 분기.
	local beautyshopFrame = ui.GetFrame('beautyshop');
	if beautyshopFrame ~= nil then
		if beautyshopFrame:IsVisible() == 1 then
			PACKAGELIST_PUT_INTO_BEAUTYSHOP_BASKET(beautyshopFrame, parent, ctrl)
			return
		end
	end

	local tpitem = ui.GetFrame('tpitem');
	local frame = parent:GetTopParentFrame();	
    local selectedCtrlSetName = frame:GetUserValue('SELECTED_CTRLSET_NAME');
	local tpitemID = frame:GetUserIValue('TPITEM_ID');
	local tpItemCls = GetClassByType('TPitem', tpitemID);

	local mainSubGbox = GET_CHILD_RECURSIVELY(tpitem, 'mainSubGbox');	
	local itemCtrl = GET_CHILD_RECURSIVELY(mainSubGbox, selectedCtrlSetName);    	
	if itemCtrl == nil then
		IMC_LOG('ERROR_LOGIC', 'itemCtrl is nil'); -- UI 컨트롤을 눌러서 이 창을 띄운거라면 이게 없어서는 안됨
		return;
	end

	local textEdit = GET_CHILD_RECURSIVELY(frame, 'textEdit');
	local curCnt = tonumber(textEdit:GetText());	
	for i = 1, curCnt do
		if TPSHOP_ITEM_TO_BASKET_PREPROCESSOR(itemCtrl, itemCtrl:GetChild('buyBtn'), tpItemCls.ClassName, tpitemID) == false then
            break;
        end
	end
end

function PACKAGELIST_PUT_INTO_BEAUTYSHOP_BASKET(beautyshopFrame, parent, ctrl)
	
	if beautyshopFrame == nil then
		return 
	end

	local gbItemList = GET_CHILD_RECURSIVELY(beautyshopFrame,"gbItemList");	
	if gbItemList == nil then
		return;
	end
	local frame = parent:GetTopParentFrame();

	local packageItemClassID = parent:GetUserValue('TPITEM_ID')		 -- Beauty_Shop_Package_Cube.xml의 ClassID
	local indexName = parent:GetUserValue('INDEX_NAME') 			-- 패키지아이템의 상점내 index Name
	local packageItemCls = GetClassByType('Beauty_Shop_Package_Cube', packageItemClassID);

	local itemCtrl = GET_CHILD_RECURSIVELY(gbItemList, indexName);
	if itemCtrl == nil then
		IMC_LOG('ERROR_LOGIC', 'itemCtrl is nil'); -- UI 컨트롤을 눌러서 이 창을 띄운거라면 이게 없어서는 안됨
		return;
	end	

	local textEdit = GET_CHILD_RECURSIVELY(frame, 'textEdit');
	local curCnt = tonumber(textEdit:GetText());	
	for i = 1, curCnt do
		BEAUTYSHOP_ITEM_TO_BASKET_PREPROCESSOR(itemCtrl, itemCtrl:GetChild('buyBtn'), packageItemCls.ItemClassName, packageItemClassID);
	end
	
end

-- 아이템 메인
function PACKAGELIST_INIT(frame, itemID, argStr, packageName, selectedCtrlSetName)	
	local argList = StringSplit(argStr, ';');
	frame:SetUserValue('TPITEM_ID', argList[1]); 
	frame:SetUserValue('ITEM_ID', itemID);	
    frame:SetUserValue('SELECTED_CTRLSET_NAME', selectedCtrlSetName);

	local itemCls = GetClassByType('Item', itemID);
	local itemIconPic = GET_CHILD_RECURSIVELY(frame, 'itemIconPic');
	itemIconPic:SetImage(itemCls.Icon);

	local itemNameText = GET_CHILD_RECURSIVELY(frame, 'itemNameText');
	itemNameText:SetText(itemCls.Name);

	local tpText = GET_CHILD_RECURSIVELY(frame, 'tpText');
	tpText:SetTextByKey('tp', argList[2]);

	local enableTradeText = GET_CHILD_RECURSIVELY(frame, 'enableTradeText');
	if argList[3] == 'T' then
		enableTradeText:ShowWindow(0);
	else
		enableTradeText:ShowWindow(1);
	end
	
	local indexName = argList[4]
	if indexName ~= nil then
		frame:SetUserValue('INDEX_NAME', indexName);
	end

	local textEdit = GET_CHILD_RECURSIVELY(frame, 'textEdit');
	textEdit:SetText('0');
	
	PACKAGELIST_INIT_ITEMLIST(frame, itemCls, packageName);
end

-- 아이템 패키지 목록
function PACKAGELIST_INIT_ITEMLIST(frame, itemCls, packageName)
	local itemListBox = GET_CHILD_RECURSIVELY(frame, 'itemListBox');
	itemListBox:RemoveAllChild();

	local tpitem = ui.GetFrame('tpitem');
	local infoMap = GET_PACKAGE_CACHE_MAP();
	local packageList = infoMap[packageName];
	for i = 1, #packageList do
		local packageItemCls = GetClass('Item', packageList[i].ItemName);
		local ctrlset = itemListBox:CreateOrGetControlSet('packagelist_item', 'ITEM_'..packageItemCls.ClassName, 0, 0);
		local itemSlot = GET_CHILD(ctrlset, 'itemSlot');
		local icon = CreateIcon(itemSlot);
		icon:SetImage(packageItemCls.Icon);
		SET_ITEM_TOOLTIP_BY_NAME(icon, packageItemCls.ClassName);

		local nameText = GET_CHILD(ctrlset, 'nameText');
		nameText:SetText(packageItemCls.Name);

		local typeText = GET_CHILD(ctrlset, 'typeText');
		typeText:SetText(GET_REQ_TOOLTIP(packageItemCls));

		if tpitem:IsVisible() == 1 then
			local previewBtn = GET_CHILD(ctrlset, 'previewBtn');
			previewBtn:ShowWindow(0);
		else
			-- 뷰티샵
			ctrlset:SetUserValue("ITEM_NAME", packageList[i].ItemName)
			ctrlset:SetUserValue("EQUIP_TYPE", packageList[i].EquipType)
			ctrlset:SetUserValue("PACKAGE_NAME", itemCls.ClassName)
		end
	end
	GBOX_AUTO_ALIGN(itemListBox, 0, -5, 0, true, false, false);
end

function PACKAGELIST_ITEM_PREVIEW_CLICK(parent, ctrl)
	local tpitem = ui.GetFrame('tpitem');
	if tpitem:IsVisible() == 1 then
		return;
	end

	local topFrame = ui.GetFrame("beautyshop");
    local gbPreview = GET_CHILD_RECURSIVELY(topFrame,"gbPreview");	
	if gbPreview == nil then
		return 
	end

	local itemName = parent:GetUserValue("ITEM_NAME")
	local packageName = parent:GetUserValue("PACKAGE_NAME")
	local equipType = parent:GetUserValue("EQUIP_TYPE")
	local slotName = BEAUTYSHOP_GET_PREIVEW_SLOT_NAME(equipType)
	local itemobj = GetClass("Item", itemName)
	if itemobj ~= nil then
		local slot = GET_CHILD(gbPreview, slotName);
		slot:SetUserValue("TYPE", equipType)
		slot:SetUserValue("PACKAGE_NAME", packageName)
		BEAUTYSHOP_PREVIEWSLOT_EQUIP(topFrame, slot, itemobj )
	end
end

