
function CAMP_REGISTER_ON_INIT(addon, frame)



end

function CAMP_REG_OPEN(frame)

	
	
end

function CAMP_REG_UI_CLOSE()

	local frame = ui.GetFrame("camp_register")
	if ui ~= nil then
		ui.CloseFrame("camp_register");	
	else
		print("UI(camp_register) is nil. Check uiframe.name from camp_register.xml file")
	end

end

function CAMP_REG_INIT(frame, skillName, sklLevel)

	frame:SetUserValue("SKILL_NAME", skillName);
	frame:SetUserValue("SKILL_LEVEL", sklLevel);
	
	local pc = GetMyPCObject();

	local gbox = GET_CHILD(frame, "gbox");	

	local time_text = GET_CHILD(gbox, "time_text");
	local campTime = CAMP_TIME(skillName, sklLevel);
	time_text:SetTextByKey("value", GET_TIME_TXT(campTime));

	local buffTime = CAMP_BUFF_TIME(skillName, sklLevel);
	local effectTxt = ClMsg("BuffMaintainTime") .. " + " ..buffTime .. "%";
	local effect_text = GET_CHILD(gbox, "effect_text");		
	effect_text:SetTextByKey("value", effectTxt);

	local silver, itemList = CAMP_NEED_PRICE(skillName, sklLevel);
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
		slot:SetOverSound('button_cursor_over_3');
		SET_SLOT_ITEM_CLS(slot, itemCls);
		local itemname = GET_CHILD(ctrlSet, "itemname");
		itemname:SetTextByKey("value", itemCls.Name);
		local count = GET_CHILD(ctrlSet, "count");
		count:SetTextByKey("value", itemCount .. " " .. ClMsg("CountOfThings"));
	end
	
	GBOX_AUTO_ALIGN(gbox_material, 15, 3, 10, true, false);
end

function CAMP_REGISTER_EXEC(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local skillName = frame:GetUserValue("SKILL_NAME");
	local sklLevel = frame:GetUserIValue("SKILL_LEVEL");
	local pc = GetMyPCObject();
	local silver, itemList = CAMP_NEED_PRICE(skillName, sklLevel);
	if GET_TOTAL_MONEY() < silver then
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

	local mapCls = GetClass("Map", session.GetMapName());
	if nil == mapCls then
		return;
	end

	if 'Field' ~= mapCls.MapType then
		ui.SysMsg(ClMsg('DontBuildCampThisAria'));
		return;
	end
	local strScp = "_CAMP_REGISTER_EXEC()";
	ui.MsgBox(ScpArgMsg("REALLY_DO"), strScp, "None");
end

function _CAMP_REGISTER_EXEC(destoryOldCamp, sklName)

	local frame = ui.GetFrame("camp_register");
	if nil == destoryOldCamp then
		destoryOldCamp = 0;
	end

	local skillName = frame:GetUserValue("SKILL_NAME");
	if "None" == skillName and nil ~= sklName then
		skillName = sklName;
	end

	local sklCls = GetClass("Skill", skillName);
	if nil == sklCls then
		return;
	end

	control.CustomCommand("BUILD_CAMP", sklCls.ClassID, destoryOldCamp);	
	frame:SetUserValue("SKILL_NAME", "None");
	frame:ShowWindow(0);	
end

function ASK_DESTORY_OLD_CAMP(sklName)

	local scp = string.format("_CAMP_REGISTER_EXEC(1, \"%s\")", sklName);
	ui.MsgBox(ScpArgMsg("OnlyOneCampBuildable"), scp, "None");
end