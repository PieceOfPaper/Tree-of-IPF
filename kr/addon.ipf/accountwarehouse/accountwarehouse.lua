function ACCOUNTWAREHOUSE_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_ACCOUNTWAREHOUSE", "ON_OPEN_ACCOUNTWAREHOUSE");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_LIST", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_ADD", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_REMOVE", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_CHANGE_COUNT", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_IN", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
	addon:RegisterOpenOnlyMsg("ACCOUNT_WAREHOUSE_VIS", "ACCOUNT_WAREHOUSE_UPDATE_VIS_LOG");
end

local new_add_item = {}
local new_stack_add_item = {}

local function is_new_item(id)    
    for k, v in pairs(new_add_item) do
        if v == id then
            return true
        end
    end    
    return false
end

local function is_stack_new_item(class_id)
    for k, v in pairs(new_stack_add_item) do
        if v == class_id then
            return true
        end
    end
    return false
end

function ON_OPEN_ACCOUNTWAREHOUSE(frame)
    new_add_item = {}
    new_stack_add_item = {}
	ui.OpenFrame("accountwarehouse");
end

function ACCOUNTWAREHOUSE_OPEN(frame)
	ui.OpenFrame("inventory");
	packet.RequestItemList(IT_ACCOUNT_WAREHOUSE);
	ui.EnableSlotMultiSelect(1);
	INVENTORY_SET_CUSTOM_RBTNDOWN("ACCOUNT_WAREHOUSE_INV_RBTN")	
	packet.RequestAccountWareVisLog();
    new_add_item = {}
    new_stack_add_item = {}
end
   
function ACCOUNTWAREHOUSE_CLOSE(frame)
	ui.EnableSlotMultiSelect(0);
	ui.CloseFrame("inventory");
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	TRADE_DIALOG_CLOSE();
    new_add_item = {}
    new_stack_add_item = {}
end

function PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, slot, fromFrame)
    local obj = GetIES(invItem:GetObject())
    if CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT(obj) == false then
        return;
    end

	if CHECK_EMPTYSLOT(frame, obj) == 1 then
		return
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local itemCls = GetClassByType("Item", invItem.type);
	if itemCls.ItemType == 'Quest' then
		ui.MsgBox(ScpArgMsg("IT_ISNT_REINFORCEABLE_ITEM"));
		return;
	end

	local enableTeamTrade = TryGetProp(itemCls, "TeamTrade");
	if enableTeamTrade ~= nil and enableTeamTrade == "NO" then
		ui.SysMsg(ClMsg("ItemIsNotTradable"));	
		return;
	end
	
	if fromFrame:GetName() == "inventory" then
		local maxCnt = invItem.count;
		if TryGetProp(obj, "BelongingCount") ~= nil then
			maxCnt = invItem.count - obj.BelongingCount;
			if maxCnt <= 0 then
				maxCnt = 0;
			end
		end

		if invItem.count > 1 then            
			INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE", maxCnt, 1, maxCnt, nil, tostring(invItem:GetIESID()));
		else
			if maxCnt <= 0 then
				ui.SysMsg(ClMsg("ItemIsNotTradable"));	
				return;
			end
			item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invItem:GetIESID(), invItem.count, frame:GetUserIValue("HANDLE"));
            new_add_item[#new_add_item + 1] = invItem:GetIESID()
            
            if geItemTable.IsStack(obj.ClassID) == 1 then
                 new_stack_add_item[#new_stack_add_item + 1] = obj.ClassID
            end
		end
	else
		if slot ~= nil then
			AUTO_CAST(slot);
	
			local iconSlot = liftIcon:GetParent();
			AUTO_CAST(iconSlot);
			item.SwapSlotIndex(IT_ACCOUNT_WAREHOUSE, slot:GetSlotIndex(), iconSlot:GetSlotIndex());
			ON_ACCOUNT_WAREHOUSE_ITEM_LIST(frame);
		end
	end

end

function PUT_ACCOUNT_ITEM_TO_WAREHOUSE(parent, slot)

	local frame = parent:GetTopParentFrame();

	local liftIcon 			= ui.GetLiftIcon();
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());

	if invItem == nil then
		return;
	end

	local fromFrame = liftIcon:GetTopParentFrame();
	PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, slot, fromFrame);

end

function MSG_PUTITEM_ACCOUNT_WAREHOUSE(iesID, count, handle)
    if CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT() == false then
        return;
    end

	local frame = ui.GetFrame("accountwarehouse");	
	if count > 1 then
		INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE", count, 1, count, nil, iesID);
	else
		item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesID, count, handle);
        new_add_item[#new_add_item + 1] = iesID
	end
end

function EXEC_PUT_TO_ACCOUNT_WAREHOUSE(iesID, count, handle)
    if CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT() == false then
        return;
    end
	item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesID, count, handle);
    new_add_item[#new_add_item + 1] = iesID
end

function EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE(frame, count, inputframe)    
	inputframe:ShowWindow(0);
	local iesid = inputframe:GetUserValue("ArgString");
	local insertItem = GetObjectByGuid(iesid);
    if CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT(insertItem) == false then
        return;
    end
	item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesid, tonumber(count), frame:GetUserIValue("HANDLE"));
    new_add_item[#new_add_item + 1] = iesid
    if geItemTable.IsStack(insertItem.ClassID) == 1 then
        new_stack_add_item[#new_stack_add_item + 1] = insertItem.ClassID
    end
end

function ACCOUNT_WAREHOUSE_SLOT_RESET(frame, slot)
	slot:SelectBySlotset(false);
end

function ON_ACCOUNT_WAREHOUSE_ITEM_LIST(frame)
	if frame:IsVisible() == 0 then
        new_add_item = {}
        new_stack_add_item = {}
		return;
	end

	local slotset = GET_CHILD_RECURSIVELY(frame, 'slotset');
	if slotset == nil then
		local gbox_warehouse = GET_CHILD_RECURSIVELY(frame, "gbox_warehouse");
		slotset = GET_CHILD_RECURSIVELY(frame, "slotset");
		end
	AUTO_CAST(slotset);
	slotset:ClearIconAll();
    slotset:SetSkinName('accountwarehouse_slot');
    	
	local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
	local index = itemList:Head();
	local itemCnt = itemList:Count();
	local saveMoney = GET_CHILD_RECURSIVELY(frame, "saveMoney");
	saveMoney:SetTextByKey('value', 0)
	local slotIndx = 0;
	while itemList:InvalidIndex() ~= index do
		local invItem = itemList:Element(index);
		local obj = GetIES(invItem:GetObject());
		if obj.ClassName == MONEY_NAME then
			saveMoney:SetTextByKey('value',GetCommaedText(invItem.count))
			itemCnt = itemCnt - 1;
		else
			local slot = slotset:GetSlotByIndex(slotIndx)            
			if slot == nil then
				slot = GET_EMPTY_SLOT(slotset);
			end

			slot:SetSkinName('invenslot2')
			local itemCls = GetIES(invItem : GetObject());
			local iconImg = GET_ITEM_ICON_IMAGE(itemCls);


            if is_new_item(invItem:GetIESID()) == true or is_stack_new_item(obj.ClassID) then
                slot:SetHeaderImage('new_inventory_icon')
            else
                slot:SetHeaderImage('None')
            end

			SET_SLOT_IMG(slot, iconImg)
				SET_SLOT_COUNT(slot, invItem.count)

			SET_SLOT_STYLESET(slot, itemCls)
			SET_SLOT_IESID(slot, invItem:GetIESID())
            SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, nil)
			slot:SetMaxSelectCount(invItem.count);
			local icon = slot:GetIcon();
			icon:SetTooltipArg("accountwarehouse", invItem.type, invItem:GetIESID());
			SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID, itemCls, "accountwarehouse");	
			slotIndx = slotIndx + 1;
		end
		index = itemList:Next(index);
	end

    -- ?„ì´?œì´ ?†ì–´???¬ìš©ê°€?¥í•œ ?¬ë¡¯?´ë©´ ?¤í‚¨ ë³€ê²?
    local account = session.barrack.GetMyAccount();
	local slotCount = account:GetAccountWarehouseSlotCount();
    local availableTakeCount = math.max(slotCount, slotIndx);
    for i = slotIndx , availableTakeCount - 1 do
        local slot = slotset:GetSlotByIndex(i);
        if slot ~= nil then
            slot:SetSkinName('invenslot2');
            slot:RemoveAllChild();
        end
    end

	local itemcnt = GET_CHILD_RECURSIVELY(frame, "itemcnt");
    local currentItemCnt = string.format('%d', itemCnt);
    if itemCnt > slotCount then
        local EXCEED_SLOT_FONT_COLOR = frame:GetUserConfig('EXCEED_SLOT_FONT_COLOR');
        currentItemCnt = '{#'..EXCEED_SLOT_FONT_COLOR..'}'..currentItemCnt..'{/}';
    end

	itemcnt:SetTextByKey('cnt', currentItemCnt);
	itemcnt:SetTextByKey('slotmax', slotCount);

	if gbox_warehouse ~= nil then
		gbox_warehouse:UpdateData();
		gbox_warehouse:SetCurLine(0);	
		gbox_warehouse:InvalidateScrollBar();
		frame:Invalidate();
	end

	ACCOUNT_WAREHOUSE_UPDATE_VIS_LOG(frame)
end

function ACCOUNT_WAREHOUSE_UPDATE_VIS_LOG(frame)
	local gbox = GET_CHILD_RECURSIVELY(frame, 'visgBox')
	gbox:RemoveAllChild();
	local cnt = session.AccountWarehouse.GetCount();

	for i = cnt-1, 0, -1 do
		local log = session.AccountWarehouse.GetByIndex(i);
		local ctrlSet = gbox:CreateControlSet("AccountVisLog", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local sTime = imcTime.GetStringSysTimeYYMMDD(log.regTime);
		local regTime = ctrlSet:GetChild('regTime')
		regTime:SetTextByKey('value', sTime);
		local withdrawVis = ctrlSet:GetChild('withdrawVis')
		local inputVis = ctrlSet:GetChild('inputVis')
		local inputPic = GET_CHILD(ctrlSet, "input", "ui::CPicture");
		if log.takeout == false then
			withdrawVis:ShowWindow(0);
			inputVis:SetTextByKey('value', log:GetAmount());
			inputPic:SetImage('in_arrow');
		else
			inputVis:ShowWindow(0);
			withdrawVis:SetTextByKey('value', log:GetAmount());
			inputPic:SetImage('chul_arrow');
		end

		local result = ctrlSet:GetChild('result')
		result:SetTextByKey('value', log:GetTotalAmount());
	end

	GBOX_AUTO_ALIGN(gbox, 0, 3, 10, true, false);
end

function ACCOUNT_WAREHOUSE_RECEIVE_ITEM(parent, slot)
	
	local frame = parent:GetTopParentFrame();
	local slotset = GET_CHILD_RECURSIVELY(frame, "slotset");
	if slotset == nil then
	local gbox_warehouse = GET_CHILD_RECURSIVELY(frame, "gbox_warehouse");
		slotset = GET_CHILD_RECURSIVELY(frame, "slotset");
	end
	session.ResetItemList();
	AUTO_CAST(slotset);    
	for i = 0, slotset:GetSelectedSlotCount() -1 do
		local slot = slotset:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		session.AddItemID(iconInfo:GetIESID(), slot:GetSelectCount());

	end

	if session.GetItemIDList():Count() == 0 then
		ui.MsgBox(ScpArgMsg("SelectItemByMouseLeftButton"));
		return;
	end

	DISABLE_BUTTON_DOUBLECLICK("accountwarehouse","receiveitem")
	local str = ScpArgMsg("TradeCountWillBeConsumedBy{Value}_Continue?", "Value", "1");
	ui.MsgBox(str, "_EXEC_ACCOUNT_WAREHOUSE_RECEIVE_ITEM", "None");

end

function _EXEC_ACCOUNT_WAREHOUSE_RECEIVE_ITEM()

	local frame = ui.GetFrame("accountwarehouse");
	item.TakeItemFromWarehouse_List(IT_ACCOUNT_WAREHOUSE, session.GetItemIDList(), frame:GetUserIValue("HANDLE"));
end

function ACCOUNT_WAREHOUSE_WITHDRAW(frame, slot)
	frame = frame:GetTopParentFrame();
	local moneyInput = GET_CHILD_RECURSIVELY(frame, 'moneyInput');
	local price = GET_NOT_COMMAED_NUMBER(moneyInput:GetText());
	AUTO_CAST(moneyInput);
	if price <= 0 then
		moneyInput:SetText('0');
		ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
		return;
	end

	local visItem = nil;

	local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
	local index = itemList:Head();
	while itemList:InvalidIndex() ~= index do
		local invItem = itemList:Element(index);
		local obj = GetIES(invItem:GetObject());
		if obj.ClassName == MONEY_NAME then
			visItem = invItem
			break;
		end
		index = itemList:Next(index);
	end

	if visItem == nil then
		moneyInput:SetText('0');
		ui.MsgBox(ClMsg("NotEnoughStoredMoney"));
		return;
	end

	if IsGreaterThanForBigNumber(price, visItem:GetAmountStr()) == 1 then
		moneyInput:SetText('0');
		ui.MsgBox(ClMsg("NotEnoughStoredMoney"));
		return;
	end
	session.ResetItemList();
	session.AddItemID(visItem:GetIESID(), price);
	item.TakeItemFromWarehouse_List(IT_ACCOUNT_WAREHOUSE, session.GetItemIDList(), frame:GetUserIValue("HANDLE"));
	moneyInput:SetText('0');
	DISABLE_BUTTON_DOUBLECLICK("accountwarehouse","Withdraw")
end

function ACCOUNT_WAREHOUSE_DEPOSIT(frame, slot)
	frame = frame:GetTopParentFrame();
	local moneyInput = GET_CHILD_RECURSIVELY(frame, 'moneyInput');
	local price = GET_NOT_COMMAED_NUMBER(moneyInput:GetText());
	AUTO_CAST(moneyInput);
	if price <= 0 then
		moneyInput:SetText('0');
		ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
		return;
	end

	local visItem = session.GetInvItemByName(MONEY_NAME)
	if visItem == nil then
		moneyInput:SetText('0');		
		ui.MsgBox(ClMsg("NOT_ENOUGH_MONEY"));
		return;
	end

	if IsGreaterThanForBigNumber(price, GET_TOTAL_MONEY_STR()) == 1 then		
		moneyInput:SetTempText('0');		
		ui.MsgBox(ClMsg("NOT_ENOUGH_MONEY"));
		return;
	end

	item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, visItem:GetIESID(), price, frame:GetUserIValue("HANDLE"));
	moneyInput:SetText('0');
	DISABLE_BUTTON_DOUBLECLICK("accountwarehouse","Deposit")
end

function ACCOUNT_WAREHOUSE_EXTEND(frame, slot)
	
	local aObj = GetMyAccountObj();
	if nil == aObj then
		return;
	end

	local slotDiff = aObj.AccountWareHouseExtend;
	local price = ACCOUNT_WAREHOUSE_EXTEND_PRICE;
	if slotDiff > 0 then
		if slotDiff >= tonumber(ACCOUNT_WAREHOUSE_MAX_EXTEND_COUNT) then
			ui.SysMsg(ScpArgMsg("WareHouseMax"))
			return;
		end
		if slotDiff < 4 then
		    price = price * GetPow(2, slotDiff);
		else
		    --Form the fifth slot, it will be fixde at 2000000 silver
		    price = price * 10
		end
	end

	local str = ScpArgMsg("ExtendWarehouseSlot{Silver}{SLOT}", "Silver", GetCommaedText(price), "SLOT", 1);
	local yesScp = string.format("CHECK_USER_MEDAL_FOR_EXTEND_ACCOUNT_WAREHOUSE(%d)", price) 
	ui.MsgBox(str, yesScp, "None");

	DISABLE_BUTTON_DOUBLECLICK("accountwarehouse","extend")

end

function CHECK_USER_MEDAL_FOR_EXTEND_ACCOUNT_WAREHOUSE(price)
	if IsGreaterThanForBigNumber(price, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ScpArgMsg("NotEnoughMoney"))
		return;
	end
    
	item.ExtendWareHouse(IT_ACCOUNT_WAREHOUSE);
end

function ACCOUNT_WAREHOUSE_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("accountwarehouse");
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	if CHECK_EMPTYSLOT(frame, obj) == 1 then
		return
	end

	local fromFrame = slot:GetTopParentFrame();	
	if fromFrame:GetName() == "inventory" then
		PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, nil, fromFrame)
	end
end

function CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT(insertItem)
    local account = session.barrack.GetMyAccount();
	local slotCount = account:GetAccountWarehouseSlotCount();
    local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
	local itemCnt = 0;
    local index = itemList:Head();
	while itemList:InvalidIndex() ~= index do
		local invItem = itemList:Element(index);
		local obj = GetIES(invItem:GetObject());
		if insertItem == nil then
		    if obj.ClassName ~= MONEY_NAME then
                itemCnt = itemCnt + 1;
		    end
		else
		    if obj.ClassName ~= MONEY_NAME and insertItem.ClassName ~= obj.ClassName then
                itemCnt = itemCnt + 1;
		    end
		end
		index = itemList:Next(index);
	end

    if slotCount <= itemCnt then
        ui.SysMsg(ClMsg('CannotPutBecauseMasSlot'));
        return false;
    end
    return true;
end