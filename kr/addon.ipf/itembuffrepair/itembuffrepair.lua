--itembuff.lua

function ITEMBUFF_REPAIR_ON_INIT(addon, frame)
end

function ITEMBUFF_REPAIR_UI_COMMON(groupName, sellType, handle)
	local frame = ui.GetFrame("itembuffrepair");
	frame:ShowWindow(1);
	frame:SetUserValue("GroupName", groupName);
	SQIORE_BUFF_VIEW(frame);

	-- 기본 탭은 "수리"
	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	itembox_tab:ChangeTab(0);
	ITEMBUFF_SHOW_TAB(itembox_tab, handle);

	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local sklName = GetClassByType("Skill", groupInfo.classID).ClassName;
	frame:SetUserValue("SKILLNAME", sklName)
	frame:SetUserValue("SKILLLEVEL", groupInfo.level);
	frame:SetUserValue("HANDLE", handle);

	local bodyBox = frame:GetChild("repair");
	local money = bodyBox:GetChild("reqitemMoney");

	if session.GetMyHandle() == handle then
		local money = bodyBox:GetChild("reqitemMoney");
		money:SetTextByKey("txt", groupInfo.price);
	else
		frame:SetUserValue("PRICE",groupInfo.price);
		money:SetTextByKey("txt", "");
	end

	-- 장비의 list, 같은 함수 내용을 로드함..
	UPDATE_REPAIR140731_LIST(frame);
	SQUIRE_UPDATE_MATERIAL(frame);
	ui.OpenFrame("inventory");

	-- 전체 선택 버튼 기본값은 선택 안된거
	local selectAllBtn = bodyBox:GetChild('selectAllBtn')
	frame:SetUserValue('SELECTED', 'NotSelected')

	local frame = ui.GetFrame("itembuff");
	if nil == frame then
		return 0;
	end
	ITEMBUFF_SET_SKILLTYPE(frame, sklName, groupInfo.level);
end


function SQUIRE_ITEM_REPAIR_SUCCEED()
	local frame = ui.GetFrame("itembuffrepair");
	UPDATE_REPAIR140731_LIST(frame);
	SQUIRE_UPDATE_MATERIAL(frame);
end

function SCP_LBTDOWN_SQIOR_REPAIR(frame, ctrl)

	ui.EnableSlotMultiSelect(1);

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")
	local totalcont = 0;

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();
		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());
		local needItem, needCount = ITEMBUFF_NEEDITEM_Squire_Repair(GetMyPCObject(), itemobj);
		totalcont = totalcont + needCount;
	end

	slotSet:MakeSelectionList();
	UPDATE_SQIOR_REPAIR_MONEY(frame, totalcont);
end

function UPDATE_SQIOR_REPAIR_MONEY(frame, totalcont)

	local repair = frame:GetTopParentFrame();
	local repairbox = repair:GetChild("repair");
	local reqitembox = repairbox:GetChild("materialGbox");
	local reqitemNeed= reqitembox:GetChild("reqitemNeedCount");

	if repair:GetUserIValue("HANDLE") ==  session.GetMyHandle() then
		reqitemNeed:SetTextByKey("txt", totalcont  ..ClMsg("CountOfThings"));
	else
		local money = repairbox:GetChild("reqitemMoney");
		money:SetTextByKey("txt", totalcont*repair:GetUserIValue("PRICE"));
	end
end

function SQUIRE_REAPIR_SELECT_ALL(frame, ctrl)
	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "slotlist", "ui::CSlotSet")	
	local slotCount = slotSet:GetSlotCount();
	local isselected =  frame:GetUserValue("SELECTED");
	
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			slot:Select(0)
		end
	end
	
	local totalcont = 0;
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "SelectedAll" then
				slot:Select(0)
			else
				slot:Select(1)
				local Icon = slot:GetIcon();
				local iconInfo = Icon:GetInfo();
				local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
				local itemobj = GetIES(invitem:GetObject());
				local needItem, needCount = ITEMBUFF_NEEDITEM_Squire_Repair(GetMyPCObject(), itemobj);
				totalcont = totalcont + needCount;
			end
		end
	end
	slotSet:MakeSelectionList();
	
	UPDATE_SQIOR_REPAIR_MONEY(frame, totalcont);
	
	if isSelectAllItem == false or isselected == "SelectedAll" then
		frame:SetUserValue("SELECTED", "NotSelected");
	else
		frame:SetUserValue("SELECTED", "SelectedAll");
	end
end


function SQUIRE_REAPIR_SELECT_EQUIPED_ITEMS(frame, ctrl)
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
	local totalcont = 0;
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "SelectedEquiped" then
				slot:Select(0)
			else

				for i = 0, equipList:Count() - 1 do
					local equipItem = equipList:Element(i);					
					if equipItem:GetIESID() == slot:GetIcon():GetInfo():GetIESID() then						
						slot:Select(1)
						local Icon = slot:GetIcon();
						local iconInfo = Icon:GetInfo();
						local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
						local itemobj = GetIES(invitem:GetObject());
						local needItem, needCount = ITEMBUFF_NEEDITEM_Squire_Repair(GetMyPCObject(), itemobj);
						totalcont = totalcont + needCount;

						isSelectEquipedItem = true;
						break;
					end
				end
				
			end
		end
	end
	slotSet:MakeSelectionList();
	
	UPDATE_SQIOR_REPAIR_MONEY(frame, totalcont);

	if isSelectEquipedItem == false or isselected == "SelectedEquiped" then	
		frame:SetUserValue("SELECTED", "NotSelected");
	else
		frame:SetUserValue("SELECTED", "SelectedEquiped");
	end
end

function SQIORE_REPAIR_CENCEL()
	ui.CloseFrame("itembuffrepair");
end

function SQIORE_REPAIR_EXCUTE(parent)
	local frame = parent:GetTopParentFrame();
	local targetbox = frame:GetChild("repair");
	local handle = frame:GetUserValue("HANDLE");
	local skillName = frame:GetUserValue("SKILLNAME");
	
	session.ResetItemList();
	
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
	end

	session.autoSeller.BuyItems(handle, AUTO_SELL_SQUIRE_BUFF, session.GetItemIDList(), skillName);
end

function ITEMBUFF_REPAIR_UPDATE_HISTORY(frame)
	local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);

	local gboxctrl = frame:GetChild("log");
	local log_gbox = gboxctrl:GetChild("log_gbox");
	log_gbox:RemoveAllChild();

	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = log_gbox:CreateControlSet("squire_rpair_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		local sList = StringSplit(info:GetHistoryStr(), "#");
		local userName = sList[1];
		local property = ctrlSet:GetChild("UserName");
		property:SetTextByKey("value", userName .. ClMsg("ItemRepair"));
		
		local itemStr = "";
		local priceStr = "";

		-- 여기가 확장해 나가야..
		for i = 2, #sList do
			if i % 2 == 0 then
				local itemCls = GetClassByType("Item", sList[i]);
				if nil ~= itemCls then
					itemStr = itemStr.. itemCls.Name.."{nl}" ;
				end
			else
				priceStr = priceStr .. ClMsg("REPAIR_PRICE") .. ":" .. sList[i].."{nl}";
			end

		end

		local itemname = ctrlSet:GetChild("itemName");
		itemname:SetTextByKey("value", itemStr);
		local price = ctrlSet:GetChild("Price");
		price:SetTextByKey("value", priceStr);
		ctrlSet:Resize(ctrlSet:GetWidth(), price:GetY() + price:GetHeight())
		ctrlSet:Invalidate();
	end

	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end
