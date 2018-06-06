
function BUFFSELLER_MY_ON_INIT(addon, frame)



end

function UPDATE_PERSONALSHOP_CTRLSET_MY(ctrlSet, info)
	local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
	local itemObj = GetClassByType("Item", info.classID);
	SET_SLOT_ITEM_CLS(slot, itemObj);
	ctrlSet:SetUserValue("Type", info.classID);
	ctrlSet:GetChild("itemname"):SetTextByKey("value", itemObj.Name);
	ctrlSet:GetChild("remaincount"):SetTextByKey("value", info.remainCount);
	ctrlSet:GetChild("price"):SetTextByKey("value", info.price);
end

function UPDATE_BUFFSELLER_SLOT_MY(ctrlSet, info)
	local skill_slot = GET_CHILD(ctrlSet, "skill_slot", "ui::CSlot");
	SET_SLOT_SKILL_BY_LEVEL(skill_slot, info.classID, info.level)
	local sklObj = GetClassByType("Skill", info.classID);
	ctrlSet:SetUserValue("Type", info.classID);
	ctrlSet:GetChild("skillname"):SetTextByKey("value", sklObj.Name);
	ctrlSet:GetChild("skilllevel"):SetTextByKey("value", info.level);
	ctrlSet:GetChild("remaincount"):SetTextByKey("value", info.remainCount);
	ctrlSet:GetChild("price"):SetTextByKey("value", info.price);
end

function MY_AUTOSELL_LIST(groupName, sellType)
	if sellType == AUTO_SELL_BUFF then
		ui.CloseFrame("buffseller_register");
	elseif sellType == AUTO_SELL_PERSONAL_SHOP then
		ui.CloseFrame("personal_shop_register");
	end

	local frame = ui.GetFrame("buffseller_my");
	frame:SetUserValue("GroupName", groupName);

	if groupName == "None" then
		frame:ShowWindow(0);
		return;
	end

	frame:SetUserValue("SELLTYPE", sellType);

	local ctrlsetType;
	local ctrlsetUpdateFunc;
	if sellType == AUTO_SELL_BUFF or sellType == AUTO_SELL_ORACLE_SWITCHGENDER then
		ctrlsetType = "buffseller_my";
		ctrlsetUpdateFunc = UPDATE_BUFFSELLER_SLOT_MY;
	elseif sellType == AUTO_SELL_PERSONAL_SHOP then
		ctrlsetType = "personalshop_my";
		ctrlsetUpdateFunc = UPDATE_PERSONALSHOP_CTRLSET_MY;
	end

	local titleName = session.autoSeller.GetTitle(groupName);
	local gBox = frame:GetChild("bodyGbox");
	local shopname = gBox:GetChild("shopname");

	shopname:SetTextByKey("value", titleName);

	local selllist = gBox:GetChild("selllist");
	selllist:RemoveAllChild();
	
	local cnt = session.autoSeller.GetCount(groupName);
	for i = 0 , cnt - 1 do
		local info = session.autoSeller.GetByIndex(groupName, i);
		local ctrlSet = selllist:CreateControlSet(ctrlsetType, "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		ctrlsetUpdateFunc(ctrlSet, info);
	end

	GBOX_AUTO_ALIGN(selllist, 10, 10, 10, true, false);
	frame:ShowWindow(1);

end

function UPDATE_AUTOSELL_HISTORY_CTRLSET(ctrlSet, info)
	local itemCls = GetClassByType("Item", info.itemType);
	local slot = GET_CHILD(ctrlSet, "slot");

	if nil == itemCls then
		itemCls = GetClassByType("Skill", info.itemType);
		imageName = 'icon_' .. GetClassString('Skill', info.itemType, 'Icon');
		SET_SLOT_IMG(slot, imageName);
	else
		SET_SLOT_ITEM_CLS(slot, itemCls);
	end

	local itemname = ctrlSet:GetChild("itemname");
	itemname:SetTextByKey("value", itemCls.Name);

	local countText = "";

	if nil ~= info:GetHistoryStr() then
		countText = info:GetHistoryStr();
	else
		countText = GET_MONEY_IMG(20) .. " " .. info.price .. " * " .. info.count;
	end
	local count = ctrlSet:GetChild("count");
	count:SetTextByKey("value", countText);
end

function MY_AUTOSELL_HISTORY(groupName, sellType)
	if sellType == AUTO_SELL_SQUIRE_BUFF then
		local buff = ui.GetFrame("itembuff");
		local skillName = buff:GetUserValue("SKILLNAME");
		if "Squire_Repair" == skillName then
			local buffFrame = ui.GetFrame("itembuffrepair");
			ITEMBUFF_REPAIR_UPDATE_HISTORY(buffFrame);
		else
			local buffFrame = ui.GetFrame("itembuffopen");
			ITEMBUFF_UPDATE_HISTORY(buffFrame);
		end
		return;

	elseif sellType == AUTO_SELL_GEM_ROASTING then
		local buffFrame = ui.GetFrame("itembuffgemroasting");
		GEMROASTING_UPDATE_HISTORY(buffFrame);
		return;

	elseif sellType == AUTO_SELL_ENCHANTERARMOR then
		local enchantarmoropen = ui.GetFrame("enchantarmoropen");
		ENCHANTARMOROPEN_UPDATE_HISTORY(enchantarmoropen);
		return;

	elseif sellType == AUTO_SELL_ORACLE_SWITCHGENDER then
		local switchgender = ui.GetFrame("switchgender");
		SWITCHGENDER_UPDATE_HISTORY(switchgender);
		return;
	end

	local frame = ui.GetFrame("buffseller_my");
	local gBox = frame:GetChild("bodyGbox");
	local history = gBox:GetChild("history");
	history:RemoveAllChild();

	local ctrlsetType = "autosell_history";
	local cnt = session.autoSeller.GetHistoryCount(groupName);
	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = history:CreateControlSet(ctrlsetType, "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		UPDATE_AUTOSELL_HISTORY_CTRLSET(ctrlSet, info);		
	end

	GBOX_AUTO_ALIGN(history, 10, 10, 10, true, false);
end

function BUFFSELLER_MY_CLOSE(frame)
	frame = frame:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	session.autoSeller.Close(groupName);
	-- frame:ShowWindow(0);
end


