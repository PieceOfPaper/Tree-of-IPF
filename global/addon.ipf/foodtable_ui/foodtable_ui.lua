
function FOODTABLE_UI_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_FOOD_TABLE_UI", "ON_OPEN_FOOD_TABLE_UI");
	addon:RegisterMsg("FOOD_ADD_SUCCESS", "ON_FOOD_ADD_SUCCESS");
	addon:RegisterMsg("FOODTABLE_HISTORY_UI", "ON_FOODTABLE_HISTORY_UI");
		
end

function ON_FOODTABLE_HISTORY_UI(frame, msg, handle)
	if frame:GetUserValue("HANDLE") ~= handle then
		return;
	end
	local cnt = session.camp.GetFoodTableHistoryCount();
	local gbox = frame:GetChild("gbox");
	local gbox_log = gbox:GetChild("gbox_log");
	local log_gbox = gbox_log:GetChild("log_gbox");
	log_gbox:RemoveAllChild();
	
	for i = cnt -1 , 0, -1 do
		local str = session.camp.GetFoodHistoryByIndex(i);
		if nil ~= str then
local ctrlSet = log_gbox:CreateControlSet("squire_foodcamp_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 55, 0, 0, 0);
			local sList = StringSplit(str, "#");
			local txt = ctrlSet:GetChild("txt");
			txt:SetTextByKey("text", sList[1]);
			txt:SetTextByKey("value", sList[2]);
		end
	end
	
	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end

function SET_FOOD_TABLE_BASE_INFO(ctrlSet, cls, tableInfo)
		local slot = GET_CHILD(ctrlSet, "slot");
		local icon = CreateIcon(slot);
		icon:SetImage(cls.Icon);
		local itemname = GET_CHILD(ctrlSet, "itemname");
		itemname:SetTextByKey("value", cls.Name);
		local itemdesc = GET_CHILD(ctrlSet, "itemdesc");

		local descFunc = "DESC_FOOD_" .. cls.ClassName;
		descFunc = _G[descFunc];
		local descStr = descFunc(tableInfo:GetSkillType(), tableInfo:GetSkillLevel());
		itemdesc:SetTextByKey("value", descStr);

		ctrlSet:SetUserValue("FOOD_TYPE", cls.ClassID);
end

function FOODTABLE_CHECK_BOX(parent, ctrl)
	local tableInfo = session.camp.GetCurrentTableInfo();

	local isMyFoodTable = false;
	if session.loginInfo.GetAID() == tableInfo:GetAID() then
		isMyFoodTable = true;
	end

	if false == isMyFoodTable then
		return;
	end

	-- 일단 모드 변경됬다 하고,
	tableInfo:SetSharedFood();

	local titleBox = GET_CHILD(parent, "gBox", "ui::CGroupBox");
	titleBox:SetVisible(tableInfo:GetSharedFood());

	if 0 == tableInfo:GetSharedFood() then
		local frame = parent:GetTopParentFrame();
		local handle = frame:GetUserIValue("HANDLE");	
		packet.ReqFoodTableTitle(handle, tableInfo:GetSharedFood(), "None");
	end

end

function CHANGE_FOOD_TABE_TITLE(parent, ctrl)
	local tableInfo = session.camp.GetCurrentTableInfo();

	local isMyFoodTable = false;
	if session.loginInfo.GetAID() == tableInfo:GetAID() then
		isMyFoodTable = true;
	end

	if false == isMyFoodTable then
		return;
	end

	local frame = parent:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");	
	if 0 == tableInfo:GetSharedFood() then
		packet.ReqFoodTableTitle(handle, tableInfo:GetSharedFood(), "None");
		return;
	end

	local edit =  GET_CHILD(parent, "TitleInput")
	if nil == edit then
		return;
	end

	packet.ReqFoodTableTitle(handle, tableInfo:GetSharedFood(), edit:GetText());
end


function ON_OPEN_FOOD_TABLE_UI(frame, msg, handle, forceOpenUI)
	
	if forceOpenUI == 1 then
		frame:ShowWindow(1);
	else
		if frame:IsVisible() == 0 then
			return;
		end	
	end

	frame:SetUserValue("HANDLE", handle);
	REGISTERR_LASTUIOPEN_POS(frame);

	local tableInfo = session.camp.GetCurrentTableInfo();
	local cnt = tableInfo:GetFoodItemCount();
	local gbox = frame:GetChild("gbox");
	local gbox_table = gbox:GetChild("gbox_table");
	gbox_table:RemoveAllChild();

	
	local isMyFoodTable = false;
	if session.loginInfo.GetAID() == tableInfo:GetAID() then
		isMyFoodTable = true;
	end

	if true == isMyFoodTable then
		local ctrlSet = gbox_table:CreateControlSet('food_check_party', "check_Party", 15 , 0);
		local checkBox = GET_CHILD(ctrlSet, "check_party", "ui::CCheckBox");
		checkBox:SetCheck(tableInfo:GetSharedFood());
		local titleBox = GET_CHILD(ctrlSet, "gBox", "ui::CGroupBox");
		if 0 == tableInfo:GetSharedFood() then
			titleBox:SetVisible(0);
		else
			titleBox:SetVisible(1);
		end
	end

	for i = 0 , cnt - 1 do
		local foodItem = tableInfo:GetFoodItem(i);
		local ctrlSet = gbox_table:CreateControlSet('camp_food_item', "FOOD" .. i, 0, 0);
		local cls = GetClassByType("FoodTable", foodItem.type);
		SET_FOOD_TABLE_BASE_INFO(ctrlSet, cls, tableInfo);
		local itemcount = GET_CHILD(ctrlSet, "itemcount");
		itemcount:SetTextByKey("value", foodItem.remainCount);

	end	

	GBOX_AUTO_ALIGN(gbox_table, 15, 3, 10, true, false);

	if isMyFoodTable == true then
		local gbox_make = gbox:GetChild("gbox_make");
		gbox_make:RemoveAllChild();

		local clslist, cnt  = GetClassList("FoodTable");
		for i = 0 , cnt - 1 do
			local cls = GetClassByIndexFromList(clslist, i);
			
			local skillInfo = session.GetSkill(tableInfo:GetSkillType());
			if skillInfo ~= nil then
				local sklObj = GetIES(skillInfo:GetObject());

				-- 음식 제작의 필요 스킬레벨이 pc의 스킬 레벨 이하일때 출력
				if cls.SkillLevel <= sklObj.Level then
					local ctrlSet = gbox_make:CreateControlSet('camp_food_register', "FOOD_" .. cls.ClassName, 0, 0);
					SET_FOOD_TABLE_BASE_INFO(ctrlSet, cls, tableInfo);
					SET_FOOD_TABLE_MATAERIAL_INFO(ctrlSet, cls);		
				end
			end
		end

		GBOX_AUTO_ALIGN(gbox_make, 15, 3, 10, true, false);
	else
		local tab = gbox:GetChild("itembox");
		if nil == tab then
			return;
		end
		--gbox_table
		tolua.cast(tab, 'ui::CTabControl');
		local index = tab:GetIndexByName("tab_normal")
		tab:SetTabVisible(2, false);
		tab:SelectTab(index);
		tab:ShowWindow(1);
		
	end
	
end

function SET_FOOD_TABLE_MATAERIAL_INFO(ctrlSet, cls)
	local materials = ctrlSet:GetChild("materials");
	materials:RemoveAllChild();

	local list = StringSplit(cls.Material, "/");
	for i = 1,  #list / 2 do
		local itemName = list[2 * i - 1];
		local itemCount = list[2 * i];

		local slot = materials:CreateControl("slot", "SLOT_" .. i, 40, 40, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		slot:ShowWindow(1);
		local itemCls = GetClass("Item", itemName);
		SET_SLOT_ITEM_CLS(slot, itemCls);
		SET_SLOT_COUNT_TEXT(slot, itemCount);
	end

	GBOX_AUTO_ALIGN_HORZ(materials, 10, 10, 0, true, false);
end

function EAT_FOODTABLE(parent, ctrl)

	local type = parent:GetUserIValue("FOOD_TYPE");

	local frame = parent:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	control.CustomCommand("EAT_FOODTABLE", handle, type);
		

end

function MAKE_FOODTABLE_ITEM(parent, ctrl)

	local foodType = parent:GetUserValue("FOOD_TYPE");
	local makecount = GET_CHILD(parent, "makecount");
	local cnt = makecount:GetNumber();
	
	local cls = GetClassByType("FoodTable", foodType);
	local list = StringSplit(cls.Material, "/");
	for i = 1,  #list / 2 do
		local itemName = list[2 * i - 1];
		local itemCount = list[2 * i];
		local invItem = session.GetInvItemByName(itemName);
		if invItem == nil or invItem.count < tonumber(itemCount) * cnt then
			ui.SysMsg(ClMsg("NotEnoughRecipe"));
			return;
		end

		if true == invItem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return;
		end
	end

	local frame = parent:GetTopParentFrame();
	local strScp = string.format("EXEC_MAKE_FOODTABLE_ITEM(%d, %d, %d)", foodType, cnt, frame:GetUserIValue("HANDLE"));
	ui.MsgBox(ScpArgMsg("REALLY_DO"), strScp, "None");

end

function EXEC_MAKE_FOODTABLE_ITEM(foodType, cnt, handle)

	control.CustomCommand("MAKE_FOODTABLE_FOOD", foodType, cnt, handle);

end

function ON_FOOD_ADD_SUCCESS(frame)
	local frame = ui.GetFrame("foodtable_ui");
	local gbox = frame:GetChild("gbox");
	local itembox = GET_CHILD(gbox, "itembox");
	itembox:SelectTab(1);

	ui.SysMsg(ClMsg("MakingFoodIsCompleted"));
end

function REMOVE_FOOD_TABLE(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	control.CustomCommand("REMOVE_FOODTABLE", handle);	

end

function DESC_FOOD_salad(skillType, skillLevel)
    local value = 7.5 + skillLevel * 2.5;
	return ScpArgMsg("IncreaseHP{Value}For{Time}Minute", "Value", value, "Time", 30);
end

function DESC_FOOD_sandwich(skillType, skillLevel)
    local value = 7.5 + skillLevel * 2.5;
	return ScpArgMsg("IncreaseSP{Value}For{Time}Minute", "Value", value, "Time", 30);
end

function DESC_FOOD_soup(skillType, skillLevel)
    local value = skillLevel;
	return ScpArgMsg("IncreaseRHPTIME{Value}For{Time}Minute", "Value", value, "Time", 30);
end

function DESC_FOOD_yogurt(skillType, skillLevel)
    local value = skillLevel;
	return ScpArgMsg("IncreaseRSPTIME{Value}For{Time}Minute", "Value", value, "Time", 30);
end

