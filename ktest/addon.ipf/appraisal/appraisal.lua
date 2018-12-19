-- appraisal


function APPRAISAL_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_APPRAISAL", "ON_OPEN_APPRAISAL");
	addon:RegisterMsg("SUCCESS_APPRALSAL", "ON_OPEN_APPRAISAL");
	addon:RegisterMsg('UPDATE_COLONY_TAX_RATE_SET', 'ON_APPRAISAL_UPDATE_COLONY_TAX_RATE_SET');
	
end

function ON_OPEN_APPRAISAL(frame, msg, arg1, arg2)
	if frame:IsVisible() == 0 then
		frame:ShowWindow(1)
		APPRAISAL_RESET_CAL_MONEY(frame)
	end
	if msg == 'SUCCESS_APPRALSAL' then
		APPRAISAL_UPDATE_ITEM_LIST(frame);
	end
end

function APPRAISAL_UI_CLOSE(frame, ctrl)
	ui.EnableSlotMultiSelect(0);
	frame:ShowWindow(0)

	local selectAllBtn = GET_CHILD_RECURSIVELY(frame, "selectAllBtn")

	local isselected = selectAllBtn:GetUserValue("SELECTED")
	

	local slotSet =  GET_CHILD_RECURSIVELY_AT_TOP(selectAllBtn, "slotlist", "ui::CSlotSet")
	local slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "selected" then
				slot:Select(0)
			end
		end
	end
	if isselected == "selected" then
		selectAllBtn:SetUserValue("SELECTED", "notselected");
	end
	TRADE_DIALOG_CLOSE();
end

function APPRAISAL_UI_OPEN(frame, ctrl)
	ui.EnableSlotMultiSelect(1);

	APPRAISAL_UPDATE_ITEM_LIST(frame);
	local invenzenytext = GET_CHILD_RECURSIVELY(frame, "invenzenytext")
	SET_COLONY_TAX_RATE_TEXT(invenzenytext, "tax_rate")
end

function ON_APPRAISAL_UPDATE_COLONY_TAX_RATE_SET(frame)
	local invenzenytext = GET_CHILD_RECURSIVELY(frame, "invenzenytext")
	SET_COLONY_TAX_RATE_TEXT(invenzenytext, "tax_rate")
	session.ResetItemList();
	APPRAISAL_UPDATE_ITEM_LIST(frame);
	CLOSE_MSGBOX_BY_NON_NESTED_KEY("APPRAISAL_EXECUTE");
end

function APPRAISAL_UPDATE_ITEM_LIST(frame)
	--슬롯 셋 및 전체 슬롯 초기화 해야됨
	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	slotSet:ClearIconAll();	
	local invItemList = session.GetInvItemList();
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, slotSet)		
		local tempobj = invItem:GetObject()
		if tempobj ~= nil then		    
			local obj = GetIES(tempobj);
			if IS_NEED_APPRAISED_ITEM(obj) == true or (CHECK_NEED_RANDOM_OPTION(obj) == true and IS_NEED_RANDOM_OPTION_ITEM(obj) == true) then
				local slotcnt = imcSlot:GetEmptySlotIndex(slotSet);
				local slot = slotSet:GetSlotByIndex(slotcnt)
				if slot == nil then
					return 'break';
				end

				local icon = CreateIcon(slot);
				icon:Set(obj.Icon, 'Item', invItem.type, slotcnt, invItem:GetIESID());
				local class = GetClassByType('Item', invItem.type);
				ICON_SET_INVENTORY_TOOLTIP(icon, invItem, "appraisal", class);
			end
		end
	end, false, slotSet);
	APPRAISAL_UPDATE_MONEY(frame);
end

function APPRAISAL_RESET_CAL_MONEY(frame)
	local repairprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "invenZeny", "ui::CRichText")
	repairprice:SetText('0')
end

function APPRAISAL_UPDATE_MONEY(frame)    
	local frame = frame:GetTopParentFrame();
	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	local totalprice = 0;

	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local handle = frame:GetUserIValue('HANDLE');

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		if groupInfo == nil then -- npc 상점의 경우
		totalprice = totalprice + GET_APPRAISAL_PRICE(itemobj, nil, GET_COLONY_TAX_RATE_CURRENT_MAP());
		elseif handle ~= session.GetMyHandle() then -- pc 상점인 경우
			local itemName, cnt = ITEMBUFF_NEEDITEM_Appraiser_Apprise(nil, itemobj);
			totalprice = totalprice + cnt * groupInfo.price;
		end

	end

	local repairprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "invenZeny", "ui::CRichText")
	repairprice:SetText(GET_COMMAED_STRING(totalprice))

	local calcprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "remainInvenZeny", "ui::CRichText")
    
	if totalprice <= 0 then        
		calcprice:SetText(GET_COMMAED_STRING(GET_TOTAL_MONEY_STR()))
		return;
	end
    
	local mymoney = GET_COMMAED_STRING(SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), -1 * totalprice));    
	calcprice:SetText(mymoney)

	frame:SetUserValue('TOTAL_MONEY', totalprice);
end

function APPRAISAL_SELECT_ALL_ITEM(frame, ctrl)
	local isselected =  ctrl:GetUserValue("SELECTED");

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")
	
	local slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "selected" then
				slot:Select(0)
			else
				slot:Select(1)
			end
		end
	end
	slotSet:MakeSelectionList()

	if isselected == "selected" then
		ctrl:SetUserValue("SELECTED", "notselected");
	else
		ctrl:SetUserValue("SELECTED", "selected");
	end

	APPRAISAL_PC_ITEM_LBTDOWN(frame);
end

function APPRAISAL_ITEM_LBTDOWN(frame, ctrl)

	ui.EnableSlotMultiSelect(1);

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")

	APPRAISAL_UPDATE_MONEY(frame);
end

function APPRAISAL_EXECUTE(frame)
	session.ResetItemList();

	local totalprice = 0;

	local slotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_APPRAISAL"))
		return;
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		session.AddItemID(iconInfo:GetIESID());

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		totalprice = totalprice + GET_APPRAISAL_PRICE(itemobj, nil, GET_COLONY_TAX_RATE_CURRENT_MAP());
	end

	if totalprice == 0 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_APPRAISAL"));
		return;
	end
	
	if IsGreaterThanForBigNumber(totalprice, GET_TOTAL_MONEY_STR()) == 1 then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	local txtPrice = GET_COMMAED_STRING(totalprice)
	local msg = ScpArgMsg('AppraisalPrice',"Price", txtPrice)
	local msgBox = ui.MsgBox_NonNested(msg, 'APPRAISAL_EXECUTE', 'APPRAISAL_EXECUTE_COMMIT', "None");
	msgBox:SetYesButtonSound("button_click_repair");
end

function APPRAISAL_EXECUTE_COMMIT()
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("APPRAISAL", resultlist);
end