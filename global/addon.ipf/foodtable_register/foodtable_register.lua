
function FOODTABLE_REGISTER_ON_INIT(addon, frame)
end

function FOODTABLE_UI_CLOSE()

	local frame = ui.GetFrame("foodtable_register")
	if ui ~= nil then
		ui.CloseFrame("foodtable_register");	
	else
		print("UI(foodtable_register) is nil. Check uiframe.name from foodtable_register.xml file")
	end

end

function FOODTABLE_SKILL_INIT(frame, skillName, sklLevel)

	frame:SetUserValue("SKILL_NAME", skillName);
	frame:SetUserValue("SKILL_LEVEL", sklLevel);
	
	local pc = GetMyPCObject();

	local gbox = GET_CHILD(frame, "gbox");	

	local silver, itemList = FOODTABLE_NEED_PRICE(skillName, sklLevel);
	local silver_text = GET_CHILD(gbox, "silver_text");
	silver_text:SetTextByKey("value", GET_MONEY_IMG(20) .. " " .. silver);

	local gbox_material = GET_CHILD(gbox, "gbox_material");
	gbox_material:RemoveAllChild();

	for i = 1 , #itemList / 2 do
		local itemName = itemList[ i * 2 - 1];
		local itemCount = itemList[ i * 2  ];
		local ctrlSet = gbox_material:CreateControlSet('camp_register_item', "MATERIAL" .. i, 0, 0);
		local itemCls = GetClass("Item", itemName);
		local slot = GET_CHILD(ctrlSet, "slot");
		SET_SLOT_ITEM_CLS(slot, itemCls);
		local itemname = GET_CHILD(ctrlSet, "itemname");
		itemname:SetTextByKey("value", itemCls.Name);
		local count = GET_CHILD(ctrlSet, "count");
		count:SetTextByKey("value", itemCount .. " " .. ClMsg("CountOfThings"));
	end
	
	GBOX_AUTO_ALIGN(gbox_material, 15, 3, 10, true, false);
end

function FOODTABLE_REG_EXEC(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local skillName = frame:GetUserValue("SKILL_NAME");
	local sklLevel = frame:GetUserIValue("SKILL_LEVEL");
	local pc = GetMyPCObject();
	local silver, itemList = FOODTABLE_NEED_PRICE(skillName, sklLevel);
	if IsGreaterThanForBigNumber(silver, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ClMsg('NotEnoughMoney'));
		return;
	end

	for i = 1 , #itemList / 2 do
		local itemName = itemList[ i * 2 - 1];
		local itemCount = itemList[ i * 2  ];
		local invItem = session.GetInvItemByName(itemName);
		if invItem == nil or invItem.count < itemCount then
			ui.SysMsg(ClMsg('NotEnoughRecipe'));
			return;
		end		

		if true == invItem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return;
		end
	end

	local strScp = "_FOODTABLE_REG_EXEC()";
	ui.MsgBox(ScpArgMsg("REALLY_DO"), strScp, "None");
end

function _FOODTABLE_REG_EXEC()
	local frame = ui.GetFrame("foodtable_register");
	local skillName = frame:GetUserValue("SKILL_NAME");
	local sklCls = GetClass("Skill", skillName);
	local tableInfo = session.camp.GetCurrentTableInfo();
    local shared = tableInfo:GetSharedFood();
	local titleEdit = GET_CHILD_RECURSIVELY(frame, 'TitleInput');
    local title = titleEdit:GetText();

    session.camp.RequestBuildFoodTable(sklCls.ClassID, shared, title);
end

function OPEN_FOODTABLE_REGISTER(frame)
	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	local ctrlSet = optionBox:CreateOrGetControlSet('food_check_party', "check_Party", 15 , 0);
	local checkBox = GET_CHILD(ctrlSet, "check_party", "ui::CCheckBox");
	local titleBox = ctrlSet:GetChild('gBox');

	checkBox:SetCheck(0);
	checkBox:ShowWindow(1);
    FOODTABLE_CHECK_BOX(ctrlSet, checkBox);
end

function FOODTABLE_CHECK_BOX(parent, ctrl)
	local tableInfo = session.camp.GetCurrentTableInfo();
	local share = ctrl:IsChecked();
	tableInfo:SetSharedFood(share);

	local titleBox = GET_CHILD(parent, "gBox", "ui::CGroupBox");
	titleBox:SetVisible(share);
end