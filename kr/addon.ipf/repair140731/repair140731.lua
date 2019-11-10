
function REPAIR140731_ON_INIT(addon, frame)

	addon:RegisterMsg('DIALOG_CLOSE', 'REPAIR140731_ON_MSG');
	addon:RegisterMsg('OPEN_DLG_REPAIR', 'REPAIR140731_ON_MSG');
	addon:RegisterMsg('UPDATE_DLG_REPAIR', 'REPAIR140731_ON_MSG');
	addon:RegisterMsg('UPDATE_ITEM_REPAIR', 'REPAIR140731_ON_MSG');
	addon:RegisterOpenOnlyMsg("UPDATE_COLONY_TAX_RATE_SET", "REPAIR140731_ON_MSG");
end

function REPAIR140731_ON_MSG(frame, msg, argStr, argNum)
	if msg == 'DIALOG_CLOSE'  then
		frame:OpenFrame(0);
    elseif msg == 'OPEN_DLG_REPAIR' then
    	UPDATE_REPAIR140731_LIST(frame);
		frame:OpenFrame(1);
	elseif msg == 'UPDATE_DLG_REPAIR' then
		UPDATE_REPAIR140731_LIST(frame);
	elseif msg == 'UPDATE_ITEM_REPAIR' then
		if argNum == 90000 then
			DRAW_TOTAL_VIS_OTHER_FRAME(frame, 'sys_silver');
		else
			UPDATE_REPAIR140731_LIST(frame);
		end
	elseif msg == 'UPDATE_COLONY_TAX_RATE_SET' then
		UPDATE_REPAIR140731_LIST(frame);
	end
end

function REPAIR140731_OPEN(frame)
	frame:SetUserValue("SELECTED", "NotSelected");
	ui.EnableSlotMultiSelect(1);

	UPDATE_REPAIR140731_LIST(frame);
end

function REPAIR140731_CLOSE(frame)
	ui.EnableSlotMultiSelect(0);
end

function UPDATE_REPAIR140731_LIST(frame)
	--슬롯 셋 및 전체 슬롯 초기화 해야됨
	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	slotSet:ClearIconAll();
	local equiplist = session.GetEquipItemList()
	local isSquire = 0;

	if "itembuffrepair" == frame:GetName() then
		isSquire = 1;
	end

	for i = 0, equiplist:Count() - 1 do
		local equipItem = equiplist:GetEquipItemByIndex(i);
		local tempobj = equipItem:GetObject()
		if tempobj ~= nil then
			local obj = GetIES(tempobj);
			if IS_NEED_REPAIR_ITEM(obj, isSquire) == true then
				local slotcnt = imcSlot:GetEmptySlotIndex(slotSet);
				local slot = slotSet:GetSlotByIndex(slotcnt)
				slot:SetClickSound('button_click_stats');
				while slot == nil do 
					slotSet:ExpandRow()
					slot = slotSet:GetSlotByIndex(slotcnt)
				end

				local icon = CreateIcon(slot);
				local iconValue = obj.Icon;
				if obj.BriquettingIndex > 0 then
					local briquettingItemCls = GetClassByType('Item', obj.BriquettingIndex);
					iconValue = briquettingItemCls.Icon;
				end
				icon:Set(iconValue, 'Item', equipItem.type, slotcnt, equipItem:GetIESID());
				local class = GetClassByType('Item', equipItem.type);
				ICON_SET_INVENTORY_TOOLTIP(icon, equipItem, "repair", class);
			end
		end
	end

	local invItemList = session.GetInvItemList();	
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, isSquire, slotSet)
		local tempobj = invItem:GetObject()
		if tempobj ~= nil then
			local obj = GetIES(tempobj);
			if IS_NEED_REPAIR_ITEM(obj, isSquire) == true then
				local slotcnt = imcSlot:GetEmptySlotIndex(slotSet);
				local slot = slotSet:GetSlotByIndex(slotcnt);

				while slot == nil do 
					slotSet:ExpandRow()
					slot = slotSet:GetSlotByIndex(slotcnt)
				end

				local icon = CreateIcon(slot);
                local iconValue = obj.Icon;
				if obj.BriquettingIndex > 0 then
					local briquettingItemCls = GetClassByType('Item', obj.BriquettingIndex);
					iconValue = briquettingItemCls.Icon;
				end
				icon:Set(iconValue, 'Item', invItem.type, slotcnt, invItem:GetIESID());
				local class = GetClassByType('Item', invItem.type);
				ICON_SET_INVENTORY_TOOLTIP(icon, invItem, "repair", class);
			end
		end
	end, false, isSquire, slotSet);

	local invFrame = ui.GetFrame("inventory")
	if invFrame ~= nil then
		INVENTORY_ON_MSG(invFrame, "UPDATE_ITEM_REPAIR", "Equip")
	end

	UPDATE_REPAIR140731_MONEY(frame)
	
	local invenzenytext = GET_CHILD_RECURSIVELY(frame, "invenzenytext")
	if invenzenytext ~= nil then
		SET_COLONY_TAX_RATE_TEXT(invenzenytext, "tax_rate", isSquire ~= 1)
	end
end

function UPDATE_REPAIR140731_MONEY(frame)
	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	local totalprice = 0;

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		local repairamount = itemobj.MaxDur - itemobj.Dur		
		totalprice = totalprice + GET_REPAIR_PRICE(itemobj, repairamount, GET_COLONY_TAX_RATE_CURRENT_MAP())

	end

	local repairprice = GET_CHILD_RECURSIVELY(frame, "invenZeny", "ui::CRichText")
	-- 스콰이어 수리 버프 시전시 UPDATE_REPAIR140731_LIST를 가져다써요
	-- 그럼 이 money 함수가 호출이 되는데 이 변수가 없어 경고가 떠서 예외처리 해줬습니다.
	if nil ~= repairprice then
		repairprice:SetText(GET_COMMAED_STRING(totalprice))
	end

	local calcprice = GET_CHILD_RECURSIVELY(frame, "remainInvenZeny", "ui::CRichText")
	-- 스콰이어 수리 버프 시전시 UPDATE_REPAIR140731_LIST를 가져다써요
	-- 그럼 이 money 함수가 호출이 되는데 이 변수가 없어 경고가 떠서 예외처리 해줬습니다.
	if nil ~= calcprice then
		calcprice:SetText(GET_COMMAED_STRING(SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), -1 * totalprice)));
	end

end

function IS_NEED_REPAIR_ITEM(itemobj, isSquireRepair)

	if itemobj == nil then
		return false
	end

	local Itemtype = itemobj.ItemType

	if Itemtype == nil then
		print('If This message has appeared, please tell its ClassId to Young.',itemobj.ClassID)
		return false;
	else
		if itemobj.ItemType ~= 'Equip' then
			return false
		end
	end

	if item.IsNoneItem(itemobj.ClassID) == 0  then
		if itemobj.MaxDur > 0 and itemobj.MaxDur - itemobj.Dur > 0 then
	--if item.IsNoneItem(itemobj.ClassID) == 0 and itemobj.MaxDur > 0  then
		return true
		else
			-- 내구도 는 가득 찾지만, 스콰이어로 부를 때 
			if nil ~= isSquireRepair and isSquireRepair == 1 and itemobj.MaxDur ~= -1 then
				return true
			end
		end
	end
	

	return false
end

function EXECUTE_REPAIR140731(frame)

	session.ResetItemList();

	local totalprice = 0;

	local slotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg("SelectRepairItemPlz"))
		return;
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		session.AddItemID(iconInfo:GetIESID());

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		local repairamount = itemobj.MaxDur - itemobj.Dur
		totalprice = totalprice + GET_REPAIR_PRICE(itemobj,repairamount, GET_COLONY_TAX_RATE_CURRENT_MAP())
	end

	if totalprice == 0 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_REPAIR"));
		return;
	end
	
	if IsGreaterThanForBigNumber(totalprice, GET_TOTAL_MONEY_STR()) == 1 then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	local msg = ScpArgMsg('ReallyRepair',"Price",totalprice)
	local msgBox = ui.MsgBox(msg, 'EXECUTE_REPAIR_COMMIT', "None");
	msgBox:SetYesButtonSound("button_click_repair");
end

function EXECUTE_REPAIR_COMMIT()

	local resultlist = session.GetItemIDList();

	item.DialogTransaction("REPAIR", resultlist);
end


function SCP_LBTDOWN_REPAIR140731(frame, ctrl)

	ui.EnableSlotMultiSelect(1);

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")

	local totalprice = 0;

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		local repairamount = itemobj.MaxDur - itemobj.Dur
		totalprice = totalprice + GET_REPAIR_PRICE(itemobj,repairamount,GET_COLONY_TAX_RATE_CURRENT_MAP())
	end

	local repairprice = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "invenZeny", "ui::CRichText")
	repairprice:SetText(GET_COMMAED_STRING(totalprice));

	local calcprice = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "remainInvenZeny", "ui::CRichText")
	calcprice:SetText(GET_COMMAED_STRING(SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), '-'..totalprice)));


end

function REPAIR140731_SELECT_ALL(frame, ctrl)

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")	
	local slotCount = slotSet:GetSlotCount();
	local isselected =  frame:GetUserValue("SELECTED");
	
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			slot:Select(0)
		end
	end
	
	local isSelectAllItem = false;
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "SelectedAll" then
				slot:Select(0)
			else
				slot:Select(1)
				isSelectAllItem = true;
			end
		end
	end
	slotSet:MakeSelectionList()
		
	if isSelectAllItem == false or isselected == "SelectedAll" then
		frame:SetUserValue("SELECTED", "NotSelected");
	else
		frame:SetUserValue("SELECTED", "SelectedAll");
	end

	UPDATE_REPAIR140731_MONEY(frame)
end

function REPAIR140731_SELECT_EQUIPED_ITEMS(frame, ctrl)

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")	
	local slotCount = slotSet:GetSlotCount();
	local isselected =  frame:GetUserValue("SELECTED");
	
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			slot:Select(0)
		end
	end
	
	local isSelectEquipedItem = false;
	local equipList = session.GetEquipItemList();
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "SelectedEquiped" then
				slot:Select(0)
			else
				for j = 0, equipList:Count() - 1 do
					local equipItem = equipList:GetEquipItemByIndex(j);
					if equipItem:GetIESID() == slot:GetIcon():GetInfo():GetIESID() then
						slot:Select(1);
						isSelectEquipedItem = true;
						break;
					end
				end
			end
		end
	end
	slotSet:MakeSelectionList()

	if isSelectEquipedItem == false or isselected == "SelectedEquiped" then	
		frame:SetUserValue("SELECTED", "NotSelected");
	else
		frame:SetUserValue("SELECTED", "SelectedEquiped");
	end

	UPDATE_REPAIR140731_MONEY(frame)
end