function BUFFSELLER_REGISTER_ON_INIT(addon, frame)
end

function BUFFSELLER_DROP(frame, icon, argStr, argNum)
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();

	if iconInfo.category == "Skill" then
		BUFFSELLER_REGISTER(toFrame, iconInfo.type);
	end
end

function BUFFSELLER_REGISTER(frame, skillType)
	local groupName = frame:GetUserValue("GroupName");
	if session.autoSeller.GetByType(groupName, skillType) ~= nil then
		return;
	end
	
	local sklObj = GetClassByType("Skill", skillType);
	local itemCls = GetClass("Item", sklObj.SpendItem);
	if sklObj.ClassName ~= "Priest_Aspersion" and sklObj.ClassName ~= "Priest_Blessing" and sklObj.ClassName ~= "Priest_Sacrament" and sklObj.ClassName ~= "Pardoner_IncreaseMagicDEF" then
		ui.SysMsg(ClMsg("OnlySkillWithSpendItemIsAble"));
		return;
	end
	
	local invItem = session.GetInvItemByName(itemCls.ClassName)
	
	if nil == invItem then
		ui.SysMsg(ClMsg("NotEnoughMaterial"));
		return;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local info = session.autoSeller.CreateToGroup(groupName);
	info.classID = skillType;
	info.price = 0;
	BUFFSELLER_UPDATE_LIST(frame);
end

function UPDATE_BUFFSELLER_SLOT(ctrlSet, info)
	local skill_slot = GET_CHILD(ctrlSet, "skill_slot", "ui::CSlot");
	local skillInfo = session.GetSkill(info.classID);
	local sklObj = GetIES(skillInfo:GetObject());
	SET_SLOT_SKILL(skill_slot, sklObj)
	ctrlSet:SetUserValue("Type", info.classID);
	ctrlSet:GetChild("skillname"):SetTextByKey("value", sklObj.Name);
	ctrlSet:GetChild("skilllevel"):SetTextByKey("value", sklObj.Level);
	local priceinput = GET_CHILD(ctrlSet, "priceinput", "ui::CEditControl");
	priceinput:SetText(info.price);
	priceinput:SetTypingScp("BUFFSELLER_TYPING_PRICE");	

	local mat_item = GET_CHILD(ctrlSet, "mat_item", "ui::CSlot");
	local itemCls = GetClass("Item", sklObj.SpendItem);

	local spendItemCount = GET_BUFFSELLER_SPEND_ITEM_COUNT(sklObj.ClassName);
	SET_SLOT_ITEM_INFO(mat_item, itemCls, spendItemCount);

	SET_ITEM_TOOLTIP_BY_TYPE(mat_item:GetIcon(), itemCls.ClassID);
	SET_SKILL_TOOLTIP_BY_TYPE(skill_slot:GetIcon(), info.classID);
end

function BUFFSELLER_CANCEL_REG(parent, ctrl)
	local skillType = parent:GetUserIValue("Type");
	local groupName = parent:GetTopParentFrame():GetUserValue("GroupName");
	session.autoSeller.RemoveByType(groupName, skillType);

	local frame = parent:GetTopParentFrame();
	BUFFSELLER_UPDATE_LIST(frame);
end

function BUFFSELLER_TYPING_PRICE(parent, ctrl)
	
	local skillType = parent:GetUserIValue("Type");
	local groupName = parent:GetTopParentFrame():GetUserValue("GroupName");
	local info = session.autoSeller.GetByType(groupName, skillType);
	ctrl = tolua.cast(ctrl, "ui::CEditControl");
	info.price = ctrl:GetNumber();

end

function BUFFSELLER_UPDATE_LIST(frame)

	local gbox = frame:GetChild("gbox");
	local selllist = gbox:GetChild("selllist");
	selllist:RemoveAllChild();

	local groupName = frame:GetUserValue("GroupName");

	local customScp = frame:GetUserValue("CUSTOM_SKILL");
	if customScp ~= "None" then
		session.autoSeller.ClearGroup(groupName);
		local skillType = frame:GetUserIValue("SKILL_TYPE");
		local info = session.autoSeller.CreateToGroup(groupName);
		info.classID = skillType;
		info.price = 0;
	end
	
	local cnt = session.autoSeller.GetCount(groupName);
	for i = 0 , cnt - 1 do
		local autoSellerInfo = session.autoSeller.GetByIndex(groupName, i);
		local ctrlSet = selllist:CreateControlSet("buffseller_reg", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		UPDATE_BUFFSELLER_SLOT(ctrlSet, autoSellerInfo);        
		BUFFSELLER_INIT_USER_PRICE(ctrlSet, autoSellerInfo);
	end

	if customScp == "None" then
		local ctrlSet = selllist:CreateControlSet("buffseller_reg_new", "CTRLSET_NEW",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local slot = ctrlSet:GetChild("slot");
		slot:SetEventScript(ui.DROP, "BUFFSELLER_DROP");
	end

	GBOX_AUTO_ALIGN(selllist, 10, 10, 10, true, false);

end

function BUFFSELLER_REG_EXEC(frame)
	frame = frame:GetTopParentFrame();

	local groupName = frame:GetUserValue("GroupName");
	local serverGroupName = frame:GetUserValue("ServerGroupName");

	local cnt = session.autoSeller.GetCount(groupName);
	local totalPrice = 0;
	for i = 0 , cnt - 1 do
		local info = session.autoSeller.GetByIndex(groupName, i);
		totalPrice = totalPrice + info.price * info.remainCount;
		if info.price <= 0 then
			ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
			return;
		end
	end

	local gbox = frame:GetChild("gbox");
	local inputname = gbox:GetChild("inputname");
	if string.len( inputname:GetText() ) == 0 then
		ui.MsgBox(ClMsg("InputTitlePlease"));
		return;
	end
	
	local serverGroupName = frame:GetUserValue("ServerGroupName");
	if "" == inputname:GetText() then
		return;
	end
	
	if groupName == "PersonalShop" then
		if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			return;
		end
	end

	if serverGroupName == 'Buff' then -- case: pardoner_spell shop
		session.autoSeller.RequestRegister(groupName, serverGroupName, inputname:GetText(), 'Pardoner_SpellShop');
	else
		session.autoSeller.RequestRegister(groupName, serverGroupName, inputname:GetText(), nil);
	end
end

function BUFFSELLER_REG_CANCEL(frame)
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function BUFFSELLER_REG_OPEN(frame)
	ui.OpenFrame("skilltree");

	local customSkill = frame:GetUserValue("CUSTOM_SKILL");
	if customSkill == "None" then
		frame:SetUserValue("GroupName", "BuffRegister");
		frame:SetUserValue("ServerGroupName", "Buff");
	else
		frame:SetUserValue("GroupName", customSkill);
		frame:SetUserValue("ServerGroupName", customSkill);
	end

	BUFFSELLER_UPDATE_LIST(frame);

end

function BUFFSELLER_INIT(frame)
	frame:SetUserValue("CUSTOM_SKILL", "None");
end


function BUFFSELLER_SET_CUSTOM_SKILL_TYPE(frame, clsName, skillType)
	frame:SetUserValue("CUSTOM_SKILL", clsName);
	if skillType ~= nil then
		frame:SetUserValue("SKILL_TYPE", skillType);
	end
end

function BUFFSELLER_INIT_USER_PRICE(ctrlSet, autoSellerInfo)
	local priceinput = GET_CHILD(ctrlSet, 'priceinput');
	PROCESS_USER_SHOP_PRICE('Pardoner_SpellShop', priceinput, autoSellerInfo.ClassID);

	autoSellerInfo.price = tonumber(priceinput:GetText());
end