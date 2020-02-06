
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

	local x, y, z = GetPos(pc);
	if 0 == IsFarFromNPC(pc, x, y, z, 70) then
		ui.SysMsg(ClMsg("TooNearFromNPC"));	
		return 0;
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
	local title = "";
	if shared == 1 then
		local ctrlSet_guild = GET_CHILD_RECURSIVELY(frame, 'check_guild');
		local titleEdit = GET_CHILD_RECURSIVELY(ctrlSet_guild, 'TitleInput');
		title = titleEdit:GetText();
	elseif shared == 2 then
		local ctrlSet_all = GET_CHILD_RECURSIVELY(frame, 'check_all');
		local titleEdit = GET_CHILD_RECURSIVELY(ctrlSet_all, 'TitleInput');
		title = titleEdit:GetText();
	end

    session.camp.RequestBuildFoodTable(sklCls.ClassID, shared, title);
end

function OPEN_FOODTABLE_REGISTER(frame)
	local optionBox = GET_CHILD_RECURSIVELY(frame, 'optionBox');
	
	local ctrlSet_guild = optionBox:CreateOrGetControlSet('food_check_party', "check_guild", 15, 0);
	local checkBox_guild = GET_CHILD(ctrlSet_guild, "check_party", "ui::CCheckBox");
	local titleBox_guild = ctrlSet_guild:GetChild('gBox');
	
	local ctrlSet_all = optionBox:CreateOrGetControlSet('food_check_party', "check_all", 15, 30);
	local checkBox_all = GET_CHILD(ctrlSet_all, "check_party", "ui::CCheckBox");
	local titleBox_all = ctrlSet_all:GetChild('gBox');

	checkBox_guild:SetText(ClMsg('FreeFoodForGuild'));
	checkBox_guild:SetEventScript(ui.LBUTTONUP, 'FOODTABLE_CHECK_BOX_FOR_GUILD');
	checkBox_guild:SetCheck(0);
	checkBox_guild:ShowWindow(1);
	FOODTABLE_CHECK_BOX_FOR_GUILD(ctrlSet_guild, checkBox_guild);
	
	local guildInfo = session.party.GetPartyInfo(PARTY_GUILD);
	if guildInfo ~= nil then
		checkBox_guild:SetEnable(1)
	else
		checkBox_guild:SetEnable(0)
	end
	
	checkBox_all:SetText(ClMsg('FreeFoodForAll'));
	checkBox_all:SetEventScript(ui.LBUTTONUP, 'FOODTABLE_CHECK_BOX_FOR_ALL');
	checkBox_all:SetCheck(0);
	checkBox_all:ShowWindow(1);
    FOODTABLE_CHECK_BOX_FOR_ALL(ctrlSet_all, checkBox_all);
end

function FOODTABLE_CHECK_BOX(parent, ctrl)
	local tableInfo = session.camp.GetCurrentTableInfo();
	local share = ctrl:IsChecked();
	tableInfo:SetSharedFood(share);

	local titleBox = GET_CHILD(parent, "gBox", "ui::CGroupBox");
	titleBox:SetVisible(share);
end

function FOODTABLE_CHECK_BOX_FOR_GUILD(parent, ctrl)
	local topParent = parent:GetTopParentFrame();
	local tableInfo = session.camp.GetCurrentTableInfo();

	local checked_guild = ctrl:IsChecked();
	local share = 0;
	local isVisible = 0;

	local ctrlSet_all = GET_CHILD_RECURSIVELY(topParent, 'check_all');
	local checkBox_all = GET_CHILD(ctrlSet_all, 'check_party', 'ui::CCheckBox');
	
	local checked_all = checkBox_all:IsChecked();
	if checked_guild == 1 then
		if checked_all == 1 then
			checkBox_all:SetCheck(0);
			local titleBox_all = GET_CHILD(ctrlSet_all, "gBox", "ui::CGroupBox");
			titleBox_all:SetVisible(0);
		end

		ctrlSet_all:SetMargin(15, 80, 0, 0);

		share = 1;
		isVisible = 1;
	else
		ctrlSet_all:SetMargin(15, 30, 0, 0);
	end

	tableInfo:SetSharedFood(share);

	local titleBox = GET_CHILD(parent, "gBox", "ui::CGroupBox");
	titleBox:SetVisible(isVisible);
end

function FOODTABLE_CHECK_BOX_FOR_ALL(parent, ctrl)
	local topParent = parent:GetTopParentFrame();
	local tableInfo = session.camp.GetCurrentTableInfo();

	local checked_all = ctrl:IsChecked();
	local share = 0;
	local isVisible = 0;

	local ctrlSet_guild = GET_CHILD_RECURSIVELY(topParent, 'check_guild');
	local checkBox_guild = GET_CHILD(ctrlSet_guild, 'check_party', 'ui::CCheckBox');
	local checked_guild = checkBox_guild:IsChecked();
	if checked_all == 1 then
		if checked_guild == 1 then
			checkBox_guild:SetCheck(0);
			local titleBox_guild = GET_CHILD(ctrlSet_guild, "gBox", "ui::CGroupBox");
			titleBox_guild:SetVisible(0);

			parent:SetMargin(15, 30, 0, 0);
		end

		share = 2;
		isVisible = 1;
	end

	tableInfo:SetSharedFood(share);

	local titleBox = GET_CHILD(parent, "gBox", "ui::CGroupBox");
	titleBox:SetVisible(isVisible);
end