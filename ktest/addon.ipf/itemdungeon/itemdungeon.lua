function ITEMDUNGEON_ON_INIT(addon, frame)
	addon:RegisterMsg('SUCCESS_ITEM_AWAKENING', 'ITEMDUNGEON_CLEARUI');
	addon:RegisterMsg('UPDATE_SPEND_ITEM', 'ITEMDUNGEON_INIT_NEEDITEM');
end

function UPDATE_ITEMDUNGEON_CURRENT_ITEM(frame)
	local targetSlot = GET_CHILD_RECURSIVELY(frame, "targetSlot");
	local invItem = GET_SLOT_ITEM(targetSlot);
	local itemGUID = "None";
	if invItem == nil then
		ITEMDUNGEON_CLEARUI(frame);
	else
		local obj = GetIES(invItem:GetObject());
		itemGUID = invItem:GetIESID();
		local slotName = GET_CHILD_RECURSIVELY(frame, "slotName");
		slotName:SetTextByKey("value", GET_FULL_NAME(obj));
		local pr_txt = GET_CHILD_RECURSIVELY(frame, "nowPotentialStr");
		pr_txt:ShowWindow(1);

		local tempObj = CreateIESByID("Item", obj.ClassID);
		if nil == tempObj then
			return;
		end

		local refreshScp = tempObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(tempObj);
		end	

		local goodsInfoBox = GET_CHILD_RECURSIVELY(frame, 'goodsInfoBox');
		goodsInfoBox:RemoveChild('tooltip_only_pr');
		local nowPotential = goodsInfoBox:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 30, pr_txt:GetY() - pr_txt:GetHeight());
		tolua.cast(nowPotential, "ui::CControlSet");
		local labelline = GET_CHILD(nowPotential, 'labelline');
		labelline:ShowWindow(0);
		local pr_gauge = GET_CHILD(nowPotential,'pr_gauge','ui::CGauge')
		pr_gauge:SetPoint(obj.PR, tempObj.PR);
		pr_txt = GET_CHILD(nowPotential,'pr_text','ui::CGauge')
		pr_txt:SetVisible(0);
		
		DestroyIES(tempObj);
		
		ITEMDUNGEON_UPDATE_PRICE(frame, obj);
	end
end

function ITEMDUNGEN_UI_CLOSE(frame)
	ui.CloseFrame("itemdungeon");
	ui.CloseFrame('inventory');
end

function ITEMDUNGEON_CLEARUI(frame)
	ITEMDUNGEON_CLEAR_TARGET(frame);
	ITEMDUNGEON_RESET_STONE(frame);

	local slotName = GET_CHILD_RECURSIVELY(frame, "slotName");
	slotName:SetTextByKey("value", "");
	GET_CHILD_RECURSIVELY(frame, "nowPotentialStr"):ShowWindow(0);

	local goodsInfoBox = GET_CHILD_RECURSIVELY(frame, 'goodsInfoBox');
	goodsInfoBox:RemoveChild('tooltip_only_pr');

	ITEMDUNGEON_UPDATE_PRICE(frame);
end

function ITEMDUNGEON_RESET_STONE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local stoneSlot = GET_CHILD_RECURSIVELY(frame, "stoneSlot");
	CLEAR_SLOT_ITEM_INFO(stoneSlot);
end

function ITEMDUNGEON_DROP_ITEM(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local slot = tolua.cast(ctrl, ctrl:GetClassString());
	local iconInfo = liftIcon:GetInfo();
	local invItem, isEquip = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return;
	end

	if nil ~= isEquip then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());	
	if false == IS_EQUIP(itemObj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return;
	end

	if IS_NEED_APPRAISED_ITEM(itemObj) == true or IS_NEED_RANDOM_OPTION_ITEM(itemObj) then 
		ui.SysMsg(ClMsg("NeedAppraisd"));
		return;
	end

	if itemObj.HiddenProp == "None" then
		ui.SysMsg(ClMsg("ThisItemIsNotAbleToWakenUp"));
		return;
	end

	if itemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('LessThanItemLifeTime'));
		return;
	end
	SET_SLOT_ITEM(slot, invItem, invItem.count);	
	UPDATE_ITEMDUNGEON_CURRENT_ITEM(frame);	
end

function ITEMDUNGEON_DROP_WEALTH_ITEM(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local slot = tolua.cast(ctrl, ctrl:GetClassString());
	local iconInfo = liftIcon:GetInfo();
	local invItem, isEquip  = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if nil == invItem then
		return;
	end
	if nil ~= isEquip then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());	
	if false == IS_ITEM_AWAKENING_STONE(itemObj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return;
	end

	if itemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

	SET_SLOT_ITEM(slot, invItem, invItem.count);
end

function EXEC_ITEM_DUNGEON(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local titleInput = GET_CHILD_RECURSIVELY(frame, 'titleInput');	
	if titleInput:GetText() == nil or titleInput:GetText() == '' then
		ui.SysMsg(ClMsg('InputTitlePlease'));
		return;
	end

	local mapCls = GetClass("Map", session.GetMapName());
	if nil == mapCls then
		return;
	end

	if session.IsMissionMap() == true then
		ui.SysMsg(ClMsg('DonExecSkill'));
		return;
	end

	local reqitemCount = GET_CHILD_RECURSIVELY(frame, 'reqitemCount');
	if tonumber(reqitemCount:GetTextByKey('txt')) < 1 then
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return;
	end

	local slot_needitem = GET_CHILD_RECURSIVELY(frame, 'slot_needitem');
	local material = session.GetInvItemByName(slot_needitem:GetUserValue('NEED_ITEM_CLASSNAME'));
	if nil == material then
		return;
	end

	if true == material.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local moneyInput = GET_CHILD_RECURSIVELY(frame, "MoneyInput");
	local price = GET_NOT_COMMAED_NUMBER(moneyInput:GetText());
	if price <= 0 then
		ui.SysMsg(ClMsg("InputPriceMoreThanOne"));
		return;
	end

	local priceInfo = session.autoSeller.CreateToGroup("Awakening");
	priceInfo.classID = GetClass("Skill", 'Alchemist_ItemAwakening').ClassID;
	priceInfo.price = price;
	session.autoSeller.RequestRegister('Awakening', 'Awakening', titleInput:GetText(), 'Alchemist_ItemAwakening');    
end

function OPEN_ITEMDUNGEON_SELLER()
	local frame = ui.GetFrame('itemdungeon');
	ITEMDUNGEON_CLEARUI(frame);
	ITEMDUNGEON_INIT_FOR_SELLER(frame);	
	frame:ShowWindow(1);
	ui.OpenFrame("inventory");
end

function ITEMDUNGEON_INIT_FOR_SELLER(frame)
	ITEMDUNGEON_INIT_TAB(frame, 1);
	ITEMDUNGEON_SHOW_BOX(frame, 1, 0, 1);
	ITEMDUNGEON_INIT_NEEDITEM(frame);
	ITEMDUNGEON_SET_TITLE(frame, true);
	ITEMDUNGEON_INIT_USER_PRICE(frame);
end

function ITEMDUNGEON_SHOW_BOX(frame, seller, buyer, isSeller)
	local buyerBox = GET_CHILD_RECURSIVELY(frame, 'buyerBox');
	local sellerBox = GET_CHILD_RECURSIVELY(frame, 'sellerBox');
	local needBox = GET_CHILD_RECURSIVELY(frame, 'needBox');
	local targetSlot = GET_CHILD_RECURSIVELY(frame, 'targetSlot');
	local titlepicture = GET_CHILD_RECURSIVELY(frame, 'titlepicture');
	local sellerBtnBox = GET_CHILD_RECURSIVELY(frame, 'sellerBtnBox');
	local buyerBtnBox = GET_CHILD_RECURSIVELY(frame, 'buyerBtnBox');
	local goodsInfoBox = GET_CHILD_RECURSIVELY(frame, 'goodsInfoBox');

	sellerBox:ShowWindow(seller);
	needBox:ShowWindow(isSeller);
	sellerBtnBox:ShowWindow(seller);

	titlepicture:ShowWindow(buyer);
	targetSlot:ShowWindow(buyer);
	buyerBox:ShowWindow(buyer);
	buyerBtnBox:ShowWindow(buyer);
	goodsInfoBox:ShowWindow(buyer);
end

function ITEMDUNGEON_INIT_NEEDITEM(frame)
	local slot_needitem = GET_CHILD_RECURSIVELY(frame, 'slot_needitem');
	local reqitemNameStr = GET_CHILD_RECURSIVELY(frame, 'reqitemNameStr');
	local reqitemCount = GET_CHILD_RECURSIVELY(frame, 'reqitemCount');

	local needItemClassName = GET_ITEM_AWAKENING_PRICE();
	local needItemCls = GetClass('Item', needItemClassName);
	SET_SLOT_ITEM_CLS(slot_needitem, needItemCls);
	slot_needitem:SetUserValue('NEED_ITEM_CLASSNAME', needItemClassName);
	reqitemNameStr:SetTextByKey('txt', needItemCls.Name);

	local invItem = session.GetInvItemByName(needItemClassName);
	local count = 0;
	if invItem ~= nil then
		count = invItem.count;
	end
	reqitemCount:SetTextByKey('txt', count);
end

function OPEN_ITEMDUNGEON_BUYER(groupName, sellType, handle)
	if groupName == 'None' then
		return;
	end

	local frame = ui.GetFrame('itemdungeon');
	frame:SetUserValue('HANDLE', handle);

	local sellerMode = 0;
	if handle == session.GetMyHandle() then
		sellerMode = 1;
    	frame:SetUserValue('SELLER_MODE', 1);
    else
    	frame:SetUserValue('SELLER_MODE', 0);
    end
    ITEMDUNGEON_INIT_TAB(frame, 0);
	ITEMDUNGEON_INIT_FOR_BUYER(frame, sellerMode);
	frame:ShowWindow(1);
	ui.OpenFrame('inventory');
end

function ITEMDUNGEON_INIT_FOR_BUYER(frame, isSeller)
	ITEMDUNGEON_SHOW_BOX(frame, 0, 1, isSeller);
	if isSeller == 1 then
		ITEMDUNGEON_INIT_NEEDITEM(frame);
	end
	ITEMDUNGEON_SET_TITLE(frame, false);
	ITEMDUNGEON_SET_OFFSET_BUY_BTN(frame);
end

function ITEMDUNGEON_SET_OFFSET_BUY_BTN(frame)
	local closeShopBtn = GET_CHILD_RECURSIVELY(frame, 'closeShopBtn');
	local buyBtn = GET_CHILD_RECURSIVELY(frame, 'buyBtn');	
	if frame:GetUserIValue('SELLER_MODE') == 1 then
		closeShopBtn:ShowWindow(1);
		buyBtn:SetOffset(buyBtn:GetOriginalX(), buyBtn:GetY());		
	else
		closeShopBtn:ShowWindow(0);
		buyBtn:SetOffset(frame:GetWidth() / 2 - buyBtn:GetWidth() / 2, buyBtn:GetY());		
	end
end

function ITEMDUNGEON_SET_TITLE(frame, isSeller)
	local titleText = GET_CHILD_RECURSIVELY(frame, 'titleText');
	local title = '';
	if isSeller == true then
		title = ClMsg('OpenAwakeningShop');
	else
		local awakeningSkl = GetClass('Skill', 'Alchemist_ItemAwakening');
		title = awakeningSkl.Name;
	end
	titleText:SetTextByKey('title', title);
end

function _ITEMDUNGEON_BUY_ITEM()
	local frame = ui.GetFrame('itemdungeon');
	local targetSlot = GET_CHILD_RECURSIVELY(frame, 'targetSlot');
	local targetIcon = targetSlot:GetIcon();
	if targetIcon == nil then
		ui.SysMsg(ClMsg('NotExistTargetItem'));
		return;
	end

	local targetItemGuid = targetIcon:GetInfo():GetIESID();
	local targetItem = session.GetInvItemByGuid(targetItemGuid);
	if targetItem == nil then
		return;
	end

	local stoneSlot = GET_CHILD_RECURSIVELY(frame, 'stoneSlot');
	local stoneIcon = stoneSlot:GetIcon();
	local materialItemGuid = '0';
	if stoneIcon ~= nil then
		materialItemGuid = stoneIcon:GetInfo():GetIESID();
	end

	local targetItemObj = targetItem:GetObject();
	if targetItemObj == nil then
		return;
	end

	targetItemObj = GetIES(targetItemObj);
	if materialItemGuid == '0' and targetItemObj.PR <= 0 then
		ui.SysMsg(ClMsg("NoMorePotential"));
		return;
	end

	local sklCls = GetClass('Skill', 'Alchemist_ItemAwakening');
	local handle = frame:GetUserIValue('HANDLE');	
	session.autoSeller.BuyWithMaterialItem(handle, sklCls.ClassID, AUTO_SELL_AWAKENING, targetItemGuid, materialItemGuid);
end

function ITEMDUNGEON_BUY_ITEM(parent, ctrl)
	local frame = ui.GetFrame('itemdungeon');
	local stoneSlot = GET_CHILD_RECURSIVELY(frame, 'stoneSlot');
	local stoneIcon = stoneSlot:GetIcon();
	local materialItemGuid = '0';
	if stoneIcon ~= nil then
		materialItemGuid = stoneIcon:GetInfo():GetIESID();
	end
	
	if materialItemGuid == '0' then
        ui.MsgBox(ClMsg("IsSureNotUseStone"), "_ITEMDUNGEON_BUY_ITEM", "None");
	else
		_ITEMDUNGEON_BUY_ITEM();
	end
end

function ITEMDUNGEON_CLOSE_SHOP(parent, ctrl)
	session.autoSeller.Close('Awakening');	
	ITEMDUNGEN_UI_CLOSE(parent:GetTopParentFrame());
end

function ITEMDUNGEON_UPDATE_PRICE(frame, targetItem)
	local priceValueText = GET_CHILD_RECURSIVELY(frame, 'priceValueText');
	if targetItem == nil then
		priceValueText:SetText(0);
		return;
	end

	local clsName, cnt = GET_ITEM_AWAKENING_PRICE(targetItem);
	local groupInfo = session.autoSeller.GetByIndex('Awakening', 0);		
	local price = cnt * groupInfo.price;
	priceValueText:SetText(price);
end

function ITEMDUNGEON_INIT_TAB(frame, sellerMode)	
	local sellerTab = GET_CHILD_RECURSIVELY(frame, 'sellerTab');	
	sellerTab:SelectTab(0);
	if sellerMode == 1 then
		sellerTab:ShowWindow(0);
	else
		if frame:GetUserIValue('SELLER_MODE') ~= 1 then
			sellerTab:ShowWindow(0);
		else
			sellerTab:ShowWindow(1);	
		end
	end
end

function ITEMDUNGEON_UPDATE_HISTORY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local historyStrBox = GET_CHILD_RECURSIVELY(frame, 'historyListBox');
    historyStrBox:RemoveAllChild();
	
	local cnt = session.autoSeller.GetHistoryCount('Awakening');	
	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex('Awakening', i);
		local ctrlSet = historyStrBox:CreateControlSet("squire_rpair_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		local sList = StringSplit(info:GetHistoryStr(), "#");
		local userName = sList[1];
		local UserName = GET_CHILD(ctrlSet, "UserName");
        local itemCls = GetClass('Item', sList[2]);        
		UserName:SetTextByKey("value", ScpArgMsg('{USER}Awaken{ITEM}', 'USER', userName, 'ITEM', itemCls.Name));        
        ctrlSet:Resize(ctrlSet:GetWidth(), UserName:GetHeight());

        local itemName = ctrlSet:GetChild('itemName');
        local price = ctrlSet:GetChild('price');
        itemName:ShowWindow(0);
        price:ShowWindow(0);		
	end

	GBOX_AUTO_ALIGN(historyStrBox, 20, 10, 10, true, false);
end

function ITEMDUNGEON_CLEAR_TARGET(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local targetSlot = GET_CHILD_RECURSIVELY(frame, "targetSlot");
	CLEAR_SLOT_ITEM_INFO(targetSlot);
end

function ITEMDUNGEON_INIT_USER_PRICE(frame)	
	PROCESS_USER_SHOP_PRICE('Alchemist_ItemAwakening', GET_CHILD_RECURSIVELY(frame, 'moneyInput'));
end