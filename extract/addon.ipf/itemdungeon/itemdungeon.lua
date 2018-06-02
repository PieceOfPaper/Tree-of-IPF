function ITEMDUNGEON_ON_INIT(addon, frame)

	addon:RegisterMsg('DUNGON_EXIT', 'DUNGON_ON_MSG');
end

function DUNGON_ON_MSG(fram, msg, argStr, argNum)
	ui.MsgBox(ClMsg("DoYouLeaveFromDungeon"), "DUNGEON_OWER_LEAVE()", "None");
end

function DUNGEON_OWER_LEAVE()
	control.RequesDungeonLeave();
end

function SET_LOCK_ITEM_AWEKING(guid)
	if nil == guid then
		guid = 'None'
	end
	local invframe = ui.GetFrame("inventory");

	invframe:SetUserValue("ITEM_GUID_IN_AWAKEN", guid);
	INVENTORY_ON_MSG(invframe, 'ITEM_PROP_UPDATE');
end

function OPEN_ITEMDUNGEON(frame)
	ITEMDUNGEON_CLEARUI(frame);
	ui.OpenFrame("inventory");
end

function UPDATE_ITEMDUNGEON_CURRENT_ITEM(frame)

	local targetSlot = GET_CHILD(frame, "targetSlot");
	local invItem = GET_SLOT_ITEM(targetSlot);
	if invItem == nil then
		ITEMDUNGEON_CLEARUI(frame);
	else
		local obj = GetIES(invItem:GetObject());

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

end

function ITEMDUNGEN_UI_CLOASE(frame)
	ui.CloseFrame("itemdungeon");
end

function ITEMDUNGEON_CLEARUI(frame)

	local targetSlot = GET_CHILD(frame, "targetSlot");
	CLEAR_SLOT_ITEM_INFO(targetSlot);

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

	local partySlot =GET_CHILD(frame, "partySlot"); 
	partySlot:RemoveAllChild();
	
	local count = session.party.GetAlivePartyMemberList() -- 파티원이 없으면 0을카운트, 용병 포함
	local number = math.min(ItemAwakening.Level,count); 
	if count == 0 then-- 기본적으로 나는 추가해주자
		number = 1;
	end
	local maxCount = 4;

	local color = 0;
	for first = 0, maxCount do
		local pic = partySlot:CreateOrGetControl("picture", "Party"..first , 25, 25, ui.CENTER_HORZ, ui.TOP, first*20, 2, 0, 0)
		pic = tolua.cast(pic, "ui::CPicture");
		pic:SetEnableStretch(1);
		pic:SetImage("house_change_man");

		-- 만약 사람이 있냐, 이건 테스트용
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

	if invItem.isLockState then 
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	if itemObj.HiddenProp == "None" then
		ui.SysMsg(ClMsg("ThisItemIsNotAbleToWakenUp"));
		return;
	end

	if itemObj.IsAwaken == 1 then
		ui.SysMsg(ClMsg("ThisItemIsAlreadyAwaken"));
		return;
	end

	if itemObj.PR <= 0 then
		ui.SysMsg(ClMsg("NoMorePotential"));
		return;
	end

	SET_SLOT_ITEM(slot, invItem, invItem.count);
	UPDATE_ITEMDUNGEON_CURRENT_ITEM(frame);

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
	local targetSlot = GET_CHILD(frame, "targetSlot");
	local invItem = GET_SLOT_ITEM(targetSlot);
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	local needItem, needCount = GET_ITEM_AWAKENING_PRICE(obj);
	local needItemCls = GetClass("Item", needItem);

	local invItem = session.GetInvItemByName(needItemCls.ClassName);
	if invItem.count < needCount then
		ui.SysMsg(ClMsg("NotEnoughRecipe"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end


	ui.MsgBox(ClMsg("IfAwakenItem_PotentialIsConsumed_Continue?"), "_EXEC_ITEM_DUNGEON", "None");
end

function _EXEC_ITEM_DUNGEON()
	
	local frame = ui.GetFrame("itemdungeon");
	local targetSlot = GET_CHILD(frame, "targetSlot");
	local invItem = GET_SLOT_ITEM(targetSlot);
	if invItem == nil then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	session.ResetItemList();
	session.AddItemID(invItem:GetIESID());
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("ITEM_AWAKENING_TX", resultlist);

	ITEMDUNGEON_CLEARUI(frame);
	frame:ShowWindow(0);
end

