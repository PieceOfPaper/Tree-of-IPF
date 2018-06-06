function ITEMDUNGEON_ON_INIT(addon, frame)

	addon:RegisterMsg('DUNGON_EXIT', 'DUNGON_ON_MSG');
	addon:RegisterMsg('REQ_ITEM_DUNGEON', 'ITEM_DUNGEON_FOR_PARTY_ON_MSG');
	addon:RegisterMsg('EXC_ITEM_DUNGEON', 'ITEM_DUNGEON_FOR_PARTY_ON_MSG');
	addon:RegisterMsg('DISAGREE_ITEM_DUNGEON', 'ITEM_DUNGEON_FOR_PARTY_ON_MSG');

	addon:RegisterMsg('ITEMDUNGEON_DROP_ITEM', 'UPDATEA_ITEMDUNGEON_DROP_ITEM');
	addon:RegisterMsg('ITEMDUNGEON_STONE_ITEM', 'UPDATEA_ITEMDUNGEON_STONE_ITEM');
end

function DUNGON_ON_MSG(fram, msg, argStr, argNum)
	ui.MsgBox(ClMsg("DoYouLeaveFromDungeon"), "DUNGEON_OWER_LEAVE()", "None");
end

function ITEM_DUNGEON_FOR_PARTY_ON_MSG(frame, msg, argStr, argNum)
	if msg == "DISAGREE_ITEM_DUNGEON" then
		ITEMDUNGEN_UI_CLOSE(frame);
		return;
	elseif msg == "EXC_ITEM_DUNGEON" then
		local agrBtn = frame:GetChild("btn_excute");
		agrBtn:SetEnable(1);
	elseif msg == "REQ_ITEM_DUNGEON" then
		-- ���ɹ̽�Ʈ�� ��û�� ����
		if 0 == argNum then
			local str = ScpArgMsg("DoYouOpenItemDungeon{Name}", "Name", argStr);
			local okScript = string.format("AGREE_OPEN_ITEM_DUNGEON_UI('%s', 1)", argStr);
			local noScript = string.format("AGREE_OPEN_ITEM_DUNGEON_UI('%s', 0)", argStr);
			ui.MsgBox(str, okScript, noScript);
			return;	
		end

		local frame = ui.GetFrame("itemdungeon");
		if frame:IsVisible() == 0 then
			frame:ShowWindow(1);
		end

		frame:SetUserValue("Name", argStr);
		return;
	end
end

function AGREE_OPEN_ITEM_DUNGEON_UI(targetName, answer)
	
	if 1 == answer then
		local frame = ui.GetFrame("itemdungeon");
		frame:SetUserValue("Name", targetName);
		frame:SetUserValue("OPEN_UI", 1);
		if frame:IsVisible() == 0 then
			frame:ShowWindow(1);
		end

		local agrBtn = frame:GetChild("btn_excute");
		agrBtn:SetEnable(0);
	end
	
	Alchemist.AnswerItemDungeon(targetName, answer)
end

function DUNGEON_OWER_LEAVE()
	control.RequesDungeonLeave();
end

function SET_LOCK_ITEM_AWEKING(targetItem, stoneItem)
	if nil == targetItem then
		targetItem = 'None'
	end

	if nil == stoneItem then
		stoneItem = "None"
	end
	local invframe = ui.GetFrame("inventory");

	invframe:SetUserValue("ITEM_GUID_IN_AWAKEN", targetItem);
	if "None" ~= stoneItem then
		invframe:SetUserValue("STONE_ITEM_GUID_IN_AWAKEN", stoneItem);
	end

	INVENTORY_ITEM_PROP_UPDATE(invframe, 'ITEM_PROP_UPDATE', targetItem);
	INVENTORY_ITEM_PROP_UPDATE(invframe, 'ITEM_PROP_UPDATE', stoneItem);
end

function OPEN_ITEMDUNGEON(frame)
	ITEMDUNGEON_CLEARUI(frame);
	ui.OpenFrame("inventory");
end

function UPDATE_ITEMDUNGEON_CURRENT_ITEM(frame)
	local targetSlot = GET_CHILD(frame, "targetSlot");
	local invItem = GET_SLOT_ITEM(targetSlot);
	local itemGUID = "None";
	if invItem == nil then
		ITEMDUNGEON_CLEARUI(frame);
	else
		local obj = GetIES(invItem:GetObject());
		itemGUID = invItem:GetIESID();
		local slotName = GET_CHILD(frame, "slotName");
		slotName:SetTextByKey("value", GET_FULL_NAME(obj));
		local pr_txt = GET_CHILD(frame, "nowPotentialStr");
		pr_txt:ShowWindow(1);

		local tempObj = CreateIESByID("Item", obj.ClassID);
		if nil == tempObj then
			return;
		end

		local refreshScp = tempObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(tempObj);
		end	

		frame:RemoveChild('tooltip_only_pr');
		local nowPotential = frame:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 30, pr_txt:GetY() - pr_txt:GetHeight());
		tolua.cast(nowPotential, "ui::CControlSet");
		local pr_gauge = GET_CHILD(nowPotential,'pr_gauge','ui::CGauge')
		pr_gauge:SetPoint(obj.PR, tempObj.PR);
		pr_txt = GET_CHILD(nowPotential,'pr_text','ui::CGauge')
		pr_txt:SetVisible(0);
		
		DestroyIES(tempObj);

		local needItem, needCount = GET_ITEM_AWAKENING_PRICE(obj);
		local needItemCls = GetClass("Item", needItem);

		local slot_needitem = GET_CHILD(frame, "slot_needitem"); 
		SET_SLOT_ITEM_CLS(slot_needitem, needItemCls);
		SET_SLOT_COUNT_TEXT(slot_needitem, needCount);

		local needitemcount = GET_CHILD(frame, "needitemcount");
		local txt = needItemCls.Name .. " - " .. needCount .. " " .. ClMsg("Piece");
		needitemcount:SetTextByKey("value", txt);
	end

	local name = frame:GetUserValue("Name");
	if "None" ~= name then
		local stoneSlot = GET_CHILD(frame, "stoneSlot");
		stonItem = GET_SLOT_ITEM(stoneSlot);
		local stonGUID = nil;
		if stonItem ~= nil then
			Alchemist.SendStoentemProp(name, stonItem:GetIESID())
		end
		Alchemist.SendTargetItemProp(name, itemGUID)
		
	end
end

function UPDATEA_ITEMDUNGEON_DROP_ITEM(frame, msg, argStr, agrNum)
	local name = frame:GetUserValue("Name");
	if argStr ~= name then
		ITEMDUNGEN_UI_CLOSE(frame);
		return;
	end

	local targetItem = session.hardSkill.GetReciveItem();
	local frame = ui.GetFrame("itemdungeon");
	if nil == targetItem then
		ITEMDUNGEON_CLEARUI(frame);
		return;
	end

	local obj = GetIES(targetItem);
	local itemCls = GetClass("Item", obj.ClassName);
	local slot = frame:GetChild("targetSlot");
	slot = tolua.cast(slot, slot:GetClassString());
	SET_SLOT_ITEM_CLS(slot, itemCls);
	local slotName = GET_CHILD(frame, "slotName");
	slotName:SetTextByKey("value", GET_FULL_NAME(obj));
	local pr_txt = GET_CHILD(frame, "nowPotentialStr");
	pr_txt:ShowWindow(1);

	local tempObj = CreateIESByID("Item", obj.ClassID);
	if nil == tempObj then
		return;
	end

	local refreshScp = tempObj.RefreshScp;
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(tempObj);
	end	

	frame:RemoveChild('tooltip_only_pr');
	local nowPotential = frame:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 30, pr_txt:GetY() - pr_txt:GetHeight());
	tolua.cast(nowPotential, "ui::CControlSet");
	local pr_gauge = GET_CHILD(nowPotential,'pr_gauge','ui::CGauge')
	pr_gauge:SetPoint(obj.PR, tempObj.PR);
	pr_txt = GET_CHILD(nowPotential,'pr_text','ui::CGauge')
	pr_txt:SetVisible(0);
	
	DestroyIES(tempObj);

	local needItem, needCount = GET_ITEM_AWAKENING_PRICE(obj);
	local needItemCls = GetClass("Item", needItem);

	local slot_needitem = GET_CHILD(frame, "slot_needitem"); 
	SET_SLOT_ITEM_CLS(slot_needitem, needItemCls);
	SET_SLOT_COUNT_TEXT(slot_needitem, needCount);

	local needitemcount = GET_CHILD(frame, "needitemcount");
	local txt = needItemCls.Name .. " - " .. needCount .. " " .. ClMsg("Piece");
	needitemcount:SetTextByKey("value", txt);
end

function UPDATEA_ITEMDUNGEON_STONE_ITEM(frame, msg, argStr, agrNum)
	local name = frame:GetUserValue("Name");
	if argStr ~= name then
		ITEMDUNGEN_UI_CLOSE(frame);
		return;
	end

	local targetItem = session.hardSkill.GetReciveStoneItem();
	local frame = ui.GetFrame("itemdungeon");
	if nil == targetItem then
		ITEMDUNGEON_CLEARUI(frame);
		return;
	end

	local stoneSlot = GET_CHILD(frame, "stoneSlot");
	local obj = GetIES(targetItem);
	local itemCls = GetClass("Item", obj.ClassName);
	stoneSlot = tolua.cast(stoneSlot, stoneSlot:GetClassString());
	SET_SLOT_ITEM_CLS(stoneSlot, itemCls);
end

function SCR_ITEMDUNGEN_UI_CLOSE()
	local frame = ui.GetFrame("itemdungeon");
	ITEMDUNGEN_UI_CLOSE(frame);
end

function ITEMDUNGEN_UI_CLOSE(frame)
	local name = frame:GetUserValue("Name");
	local open = frame:GetUserIValue("OPEN_UI");
	if "None" ~= name  then
		if  1 == open then
			session.hardSkill.CloseItemDungeon();
		end
		
		Alchemist.CloseItemDungeon(name);

		frame:SetUserValue("Name", "None");
		frame:SetUserValue("OPEN_UI", 0);
	end

	ui.CloseFrame("itemdungeon");
end

function ITEMDUNGEON_CLEARUI(frame)

	local targetSlot = GET_CHILD(frame, "targetSlot");
	CLEAR_SLOT_ITEM_INFO(targetSlot);

	local stoneSlot = GET_CHILD(frame, "stoneSlot");
	CLEAR_SLOT_ITEM_INFO(stoneSlot);

	local slotName = GET_CHILD(frame, "slotName");
	slotName:SetTextByKey("value", "");
	GET_CHILD(frame, "nowPotentialStr"):ShowWindow(0);
	frame:RemoveChild('tooltip_only_pr');

	local slot_needitem = GET_CHILD(frame, "slot_needitem"); 
	CLEAR_SLOT_ITEM_INFO(slot_needitem);

	local needitemcount = GET_CHILD(frame, "needitemcount");
	needitemcount:SetTextByKey("value", "");
	
	local skillLevel = GET_CHILD(frame, "SkillLevel");
	local ItemAwakening = GetSkill(GetMyPCObject(), 'Alchemist_ItemAwakening');
	if nil == ItemAwakening or nil == skillLevel then
		return;
	end
	skillLevel:SetTextByKey("value", ItemAwakening.Level);
	local bodyGbox	= frame:GetTopParentFrame();

	local partySlot = GET_CHILD(bodyGbox, "partySlot"); 
	partySlot:RemoveAllChild();
	
	local count = session.party.GetAlivePartyMemberList() -- ��Ƽ���� ������ 0��ī��Ʈ, �뺴 ����
	local number = math.min(ItemAwakening.Level,count); 
	if count == 0 then-- �⺻������ ���� �߰�������
		number = 1;
	end
	local maxCount = 4;

	local color = 0;
	for first = 0, maxCount do
		local pic = partySlot:CreateOrGetControl("picture", "Party"..first , 25, 25, ui.CENTER_HORZ, ui.TOP, first*20, 2, 0, 0)
		pic = tolua.cast(pic, "ui::CPicture");
		pic:SetEnableStretch(1);
		pic:SetImage("house_change_man");

		-- ���� ����� �ֳ�, �̰� �׽�Ʈ��
		if number > 0 then
			pic:SetColorTone("00000000"); 
			number = number - 1;
			color = color + 1;
		else
			pic:SetColorTone("22FFFFFF");
		end
	end
	local partyCount =GET_CHILD(frame, "partyCount");
	partyCount:SetTextByKey("value", "(" .. color .."/"..math.min(maxCount+1, ItemAwakening.Level)..")");
end

function ITEMDUNGEON_DROP_ITEM(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	local name = frame:GetUserValue("Name");
	local open = frame:GetUserIValue("OPEN_UI");
	
	if "None" ~= name  and 1 == open then
		local str = ScpArgMsg("WaitDroppingItemFromParty{Name}", "Name", name);
		ui.SysMsg(str);
		return;
	end

	local liftIcon 			= ui.GetLiftIcon();
	local slot 			    = tolua.cast(ctrl, ctrl:GetClassString());
	local iconInfo			= liftIcon:GetInfo();
	local invItem, isEquip = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	if nil == invItem then
		return;
	end

	if nil ~= isEquip then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());	
	if false == IS_EQUIP(itemObj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return;
	end

	if IS_NEED_APPRAISED_ITEM(itemObj) == true then 
		ui.SysMsg(ClMsg("NeedAppraisd"));
		return;
	end

	if itemObj.HiddenProp == "None" then
		ui.SysMsg(ClMsg("ThisItemIsNotAbleToWakenUp"));
		return;
	end

--if itemObj.IsAwaken == 1 then
--	ui.SysMsg(ClMsg("ThisItemIsAlreadyAwaken"));
--	return;
--end

	if itemObj.PR <= 0 then
		ui.SysMsg(ClMsg("NoMorePotential"));
		return;
	end

	SET_SLOT_ITEM(slot, invItem, invItem.count);
	UPDATE_ITEMDUNGEON_CURRENT_ITEM(frame);

end

function ITEMDUNGEON_DROP_WEALTH_ITEM(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	local name = frame:GetUserValue("Name");
	local open = frame:GetUserIValue("OPEN_UI");
	
	if "None" ~= name  and 1 == open then
		local str = ScpArgMsg("WaitDroppingItemFromParty{Name}", "Name", name);
		ui.SysMsg(str);
		return;
	end

	local liftIcon 			= ui.GetLiftIcon();
	local slot 			    = tolua.cast(ctrl, ctrl:GetClassString());
	local iconInfo			= liftIcon:GetInfo();
	local invItem, isEquip  = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	if nil == invItem then
		return;
	end

	if nil ~= isEquip then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());	
	if false == IS_ITEM_AWAKENING_STONE(itemObj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return;
	end

	if itemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

	SET_SLOT_ITEM(slot, invItem, invItem.count);

	if "None" ~= name then
		local targetSlot = GET_CHILD(frame, "targetSlot");
		local invItem = GET_SLOT_ITEM(targetSlot);
		if nil ~= invItem then
			Alchemist.SendTargetItemProp(name, invItem:GetIESID())
		end
		Alchemist.SendStoentemProp(name, iconInfo:GetIESID())
	end
end
function EXEC_ITEM_DUNGEON(parent, ctrl)
	
	local mapCls = GetClass("Map", session.GetMapName());
	if nil == mapCls then
		return;
	end

	if session.IsMissionMap() == true then
		ui.SysMsg(ClMsg('DonExecSkill'));
		return;
	end

	if 'd_itemdungeon_1' == mapCls.ClassName then
		ui.SysMsg(ClMsg('DonExecSkill'));
		return;
	end

	local frame = parent:GetTopParentFrame();
	
	local open = frame:GetUserIValue("OPEN_UI");
	if 1 == open then
		_EXEC_ITEM_DUNGEON();
		return;
	end

	local targetSlot = GET_CHILD(frame, "targetSlot");
	local invItem = GET_SLOT_ITEM(targetSlot);
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	local needItem, needCount = GET_ITEM_AWAKENING_PRICE(obj);
	local needItemCls = GetClass("Item", needItem);
	local name = frame:GetUserValue("Name");
	if "None" == name then
		local nedItem = session.GetInvItemByName(needItemCls.ClassName);
		if nil == nedItem or nedItem.count < needCount then
			ui.SysMsg(ClMsg("NotEnoughRecipe"));
			return;
		end
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local stoneSlot = GET_CHILD(frame, "stoneSlot");
	local stonItem = GET_SLOT_ITEM(stoneSlot);
	if stonItem ~= nil and true == stonItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if "None" == name then
		ui.MsgBox(ClMsg("IfAwakenItem_PotentialIsConsumed_Continue?"), "_EXEC_ITEM_DUNGEON", "None");
	else
		local okScp = string.format("Alchemist.ReqExcItemDungeon('%s')", name);
		local noscp = string.format("Alchemist.CloseItemDungeon('%s')", name);
		ui.MsgBox(ClMsg("IfAwakenItem_PotentialIsConsumed_Continue?"), okScp, noscp);
	end
end

function _EXEC_ITEM_DUNGEON()
	local frame = ui.GetFrame("itemdungeon");
	local name = frame:GetUserValue("Name");
	local invItem = nil;
	local stonItem = nil;
	if "None" == name then
		local targetSlot = GET_CHILD(frame, "targetSlot");
		invItem = GET_SLOT_ITEM(targetSlot);
		if invItem == nil then
			return;
		end
		if true == invItem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return;
		end

		local stoneSlot = GET_CHILD(frame, "stoneSlot");
		stonItem = GET_SLOT_ITEM(stoneSlot);
		if stonItem ~= nil and true == stonItem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
		end
	else
		invItem = session.hardSkill.GetReciveItem();
	end

	if invItem == nil then
		return;
	end

	if "None" == name then
		session.ResetItemList();
		session.AddItemID(invItem:GetIESID());
		if nil ~= stonItem then
			session.AddItemID(stonItem:GetIESID());
		end
		local resultlist = session.GetItemIDList();
		item.DialogTransaction("ITEM_AWAKENING_TX", resultlist);
	else
		local iesID = session.hardSkill.GetReciveItemGUID();
		local obj = GetIES(invItem);
		if nil == iesID or nil == obj then
			return;
		end

		local stoneGUID = session.hardSkill.GetReciveStoneItemGUID();
		
		local needItem, needCount = GET_ITEM_AWAKENING_PRICE(obj);
		local nedItem = session.GetInvItemByName(needItem);
		if nedItem == nil then
			ui.SysMsg(ClMsg("NotEnoughRecipe"));
			Alchemist.RequestItemDungeon(name);
			return;
		end
		if  nedItem.count < needCount then
			ui.SysMsg(ClMsg("NotEnoughRecipe"));
			Alchemist.RequestItemDungeon(name);
			return;
		end

		Alchemist.ExcuteItemDungeon(name, iesID, stoneGUID);
	end

	frame:SetUserValue("Name" , "None");
	frame:SetUserValue("OPEN_UI", 0);
	
	ITEMDUNGEON_CLEARUI(frame);
	session.hardSkill.CloseItemDungeon();
	frame:ShowWindow(0);
end

