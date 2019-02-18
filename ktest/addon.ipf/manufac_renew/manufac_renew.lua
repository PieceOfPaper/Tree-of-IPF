
function MANUFAC_RENEW_ON_INIT(addon, frame)

	addon:RegisterMsg('MANU_START', 'ON_MANU_START');
	addon:RegisterMsg('MANU_STOP', 'ON_MANU_STOP');
	addon:RegisterMsg('MANU_END', 'ON_MANU_END');
	
end

function MANU_CLOSE(frame)
	
	INV_CLEAR_FRONT_IMAGE();
	frame:SetUserValue("RECIPE_TYPE", "0");
end

function MANU_RESET(frame)

	MANU_RESET_ALL_SLOT(frame);

end

function MANU_RESET_ALL_SLOT(frame)
	MANU_APPLY_ALL_SLOT(frame, _MANU_CLEAR_SLOT);
end

function _MANU_SET_POSSIBLE_ICON(slot, recipeProp)

	local item = GET_SLOT_ITEM(slot);
	if item ~= nil and recipeProp:IsReqItem(item.type) == true then
		slot:SetFrontImage('None');
	else
		if slot:GetIcon() ~= nil then	
			slot:SetFrontImage('removed_item');
		end
	end

end

function MANU_SET_CLS(frame, recipeName)
	
	local recipeCls = GetClass("Recipe", recipeName);
	local recipeProp = geItemTable.GetRecipeProp(recipeCls.ClassID);
	INV_APPLY_TO_ALL_SLOT(_MANU_SET_POSSIBLE_ICON, recipeProp);

	frame:SetUserValue("RECIPE_TYPE", recipeCls.ClassID);
	local tgtItemSlot = GET_CHILD(frame, "tgtItemSlot", "ui::CSlot");
	local tgtItemCls = GetClass("Item", recipeCls.TargetItem);
	SET_SLOT_ITEM_CLS(tgtItemSlot, tgtItemCls);
	frame:SetTextByKey("ItemName", tgtItemCls.Name);
	
	local gBox = GET_CHILD(frame, "materialList", "ui::CGroupBox");
	local ypos = 1;
	ypos = DRAW_RECIPE_MATERIAL(gBox, recipeCls, ypos);
	gBox:Resize(gBox:GetWidth(), ypos);
	ypos = ypos + gBox:GetY() + 20;

	-- �� �׷�ڽ��� ũ�Ⱑ ���ؼ� �Ʒ��� ������ �����ش�.
	local bottomUIList = {};
	bottomUIList[#bottomUIList + 1] = "slotlist";
	bottomUIList[#bottomUIList + 1] = "prog_gauge";
	bottomUIList[#bottomUIList + 1] = "exec";

	local firstUI = frame:GetChild(bottomUIList[1]);
	local addypos = ypos - firstUI:GetY();
	for i = 1 , #bottomUIList do
		local bui = frame:GetChild(bottomUIList[i]);
		if bui ~= nil then
			bui:SetOffset(0, bui:GetY() + addypos);
		end
	end
	
	local lastUI = frame:GetChild(bottomUIList[#bottomUIList]);
	frame:Resize(frame:GetWidth(), lastUI:GetY() + lastUI:GetHeight() + 40);

	MANU_AUTO_REGISTER(frame);
	gBox:UpdateData();
	frame:Invalidate();

end

function _MANU_CLEAR_SLOT(slot)
	slot:ClearIcon();
	slot:SetText("");
end

function MANU_SET_ITEM_TO_SLOT(frame, invItem, slot, cnt, updateFrameCnt)
	SET_SLOT_INVITEM(slot, invItem, cnt);
	slot:SetUserValue("ItemCount", cnt);
	if updateFrameCnt ~= false then
		MANU_UPDATE_ABLE_CNT(frame);
	end
end

function MANU_ADD_MATERIAL_ITEM(frame, invItem, addCnt)

	local gBox = MANU_PARENT(frame);
	local slotSet = GET_CHILD(gBox, "slotlist", "ui::CSlotSet");
	local emptySlot = GET_EMPTY_SLOT(slotSet);
	MANU_SET_ITEM_TO_SLOT(frame, invItem, emptySlot, addCnt, false);

end

function MANU_AUTO_REGISTER(frame)

	MANU_APPLY_ALL_SLOT(frame, _MANU_REMOVE_SLOT);

	local recipeType = frame:GetUserIValue("RECIPE_TYPE");
	local recipeProp = geItemTable.GetRecipeProp(recipeType);

	local cnt = recipeProp.reqItemSize;
	for i = 0 , cnt - 1 do
		local item = recipeProp:GetReqItem(i);
		local itemList = {};
		GET_PC_ITEMS_BY_LEVEL(item.type, item.level, itemList);
		
		local remainCnt = item.count;
		for j = 1 , #itemList do
			local invItem = itemList[j];
			if remainCnt > 0 then
				local addCnt = invItem.count;
				if remainCnt < addCnt then
					addCnt = remainCnt;
				end

				remainCnt = remainCnt - addCnt;
				MANU_ADD_MATERIAL_ITEM(frame, invItem, addCnt);
			end
		end
	end

	MANU_UPDATE_ABLE_CNT(frame);

end

function MANU_APPLY_ALL_SLOT(frame, func, ...)

	local gBox = MANU_PARENT(frame);
	local slotSet	= GET_CHILD(gBox, "slotlist", "ui::CSlotSet");
	APPLY_TO_ALL_ITEM_SLOT(slotSet, func, ...);

end

function _MANU_REMOVE_SLOT(slot, itemID)
	local item = GET_SLOT_ITEM(slot);
	if item ~= nil and item:GetIESID() == itemID then
		slot:ClearIcon();
		slot:SetText("");
	end
end

function MANU_REMOVE_MAT_BY_GUID(frame, itemID)
	MANU_APPLY_ALL_SLOT(frame, _MANU_REMOVE_SLOT, itemID);
end

function MANU_MAT_DROP(frame, slot, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	if FromFrame:GetName() ~= 'inventory' then
		return;
	end

	frame = frame:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	local recipeType = frame:GetUserIValue("RECIPE_TYPE");
	local recipeProp = geItemTable.GetRecipeProp(recipeType);
	if false == recipeProp:IsReqItem(invItem.type) then
		return;
	end

	if invItem.count == 1 then
		MANU_REMOVE_MAT_BY_GUID(frame, iconInfo:GetIESID());
		MANU_SET_ITEM_TO_SLOT(frame, invItem, slot, invItem.count);
		return;
	end

	slot = tolua.cast(slot, "ui::CSlot");
	frame:SetUserValue("DROP_SLOT_NAME", slot:GetSlotIndex());
	frame:SetUserValue("DROP_ITEM_ID", iconInfo:GetIESID());
	INPUT_NUMBER_BOX(frame, ClMsg("InputCount"), "MANU_EXEC_DROP_REGISTER", invItem.count, 1, iconInfo.count);
end

function MANU_EXEC_DROP_REGISTER(frame, cnt)

	local slotIndex = frame:GetUserIValue("DROP_SLOT_NAME");
	local gBox = MANU_PARENT(frame);
	local slotSet = GET_CHILD(gBox, "slotlist", "ui::CSlotSet");
	local slot = slotSet:GetSlotByIndex(slotIndex);

	local itemID = frame:GetUserValue("DROP_ITEM_ID");
	MANU_REMOVE_MAT_BY_GUID(frame, itemID);
	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	MANU_SET_ITEM_TO_SLOT(frame, invItem, slot, cnt);

end

function MANU_MAT_REMOVE(frame, slot)
	slot = tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then
		return;
	end

	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	if invItem == nil then
		return;
	end

	slot:ClearIcon();
	slot:SetText("");
	MANU_UPDATE_ABLE_CNT(frame);

end

function MANU_POP_ITEM_FROM_LIST(itemList, reqItem)

	for i = 1, #itemList do
		local invItem = itemList[i]["Item"];
		if itemList[i]["Count"] > 0 and invItem.type == reqItem.type then
			local itemObj = GetIES(invItem:GetObject());
			local itemLv = GET_ITEM_LEVEL(itemObj);
			if itemLv >= reqItem.level then
				local curCnt = itemList[i]["Count"];
				if curCnt >= reqItem.count then
					itemList[i]["Used"] = itemList[i]["Used"] + reqItem.count;
					itemList[i]["Count"] = itemList[i]["Count"] - reqItem.count;
					return true;
				end				
			end
		end
	end

	return false;
end

function _ADD_SLOT_ITEM(slot, itemList)
	local invItem = GET_SLOT_ITEM(slot);
	if invItem ~= nil then
		itemList[#itemList + 1] = {};
		itemList[#itemList]["Item"] = invItem;
		itemList[#itemList]["Count"] = slot:GetIcon():GetInfo().count;
		itemList[#itemList]["Used"] = 0;
	end
end

function _MANU_GET_ABLE_ITEM_LIST(recipeProp, itemList)

	local ableCnt = 0;
	while 1 do
		local allPop = true;
		for i = 0 , recipeProp.reqItemSize - 1 do
			local reqItem = recipeProp:GetReqItem(i);
			if MANU_POP_ITEM_FROM_LIST(itemList, reqItem) == false then
				allPop = false;
				break;
			end
		end

		if allPop == false then
			break;
		end

		ableCnt = ableCnt + 1;
	end

	return ableCnt;
end

function MANU_UPDATE_ABLE_CNT(frame)
	frame = frame:GetTopParentFrame();
	local recipeType = frame:GetUserIValue("RECIPE_TYPE");
	local recipeProp = geItemTable.GetRecipeProp(recipeType);
	if recipeProp == nil or recipeProp.reqItemSize == 0 then
		frame:SetTextByKey("ItemCount", ableCnt);
		return;
	end

	local itemList = {};
	MANU_APPLY_ALL_SLOT(frame, _ADD_SLOT_ITEM, itemList);
	local ableCnt = _MANU_GET_ABLE_ITEM_LIST(recipeProp, itemList);
		
	frame:SetTextByKey("ItemCount", ableCnt);	
	frame:SetUserValue("MakeItemCount", ableCnt);
end

function MANU_EXEC(frame)

	frame = frame:GetTopParentFrame();
	local recipeType = frame:GetUserIValue("RECIPE_TYPE");
	local recipeProp = geItemTable.GetRecipeProp(recipeType);
	if recipeProp == nil or recipeProp.reqItemSize == 0 then
		return;
	end

	local makeCount = frame:GetUserIValue("MakeItemCount");
	local cntText = string.format("%d %d", recipeType, makeCount);
	if makeCount < 1 then
		ui.SysMsg(ScpArgMsg("Auto_JaeLyoLeul_olLyeoJuSeyo"));
		return;
	end

	session.ResetItemList();

	local ableCnt = 0;
	local itemList = {};
	MANU_APPLY_ALL_SLOT(frame, _ADD_SLOT_ITEM, itemList);
	for i = 1, #itemList do
		session.AddItemID(itemList[i]["Item"]:GetIESID());
	end

	local resultlist = session.GetItemIDList();
	item.DialogTransaction("SCR_ITEM_MANUFACTURE", resultlist, cntText);
	frame:SetUserValue("IS_ING", 1);

end

function MANU_PARENT(frame)
	-- return frame:GetChild("bottomList");
	return frame;
end

function ON_MANU_START(frame, msg, str, time)
	if frame:IsVisible() == 0 then
		return;
	end	
	gbox = MANU_PARENT(frame);
	local gauge = GET_CHILD(gbox, "prog_gauge", "ui::CGauge");
	gauge:ShowWindow(1);
	gauge:SetProgressStyle(ui.GAUGE_PROGRESS_RANDOM);
	gauge:SetPoint(0, time);
	gauge:SetPointWithTime(time, time);
	MANU_APPLY_ALL_SLOT(frame, _R_RENEW_START_COOLDOWN, gauge);

end

function ON_MANU_STOP(frame)
	if frame:IsVisible() == 0 then
		return;
	end

	local gbox = MANU_PARENT(frame);
	local prog_gauge = GET_CHILD(gbox, "prog_gauge", "ui::CGauge");
	prog_gauge:StopTimeProcess();
	prog_gauge:ShowWindow(0);

end

function MANU_GET_REAL_MAKE_ITEM(frame, itemList)

	local recipeType = frame:GetUserIValue("RECIPE_TYPE");
	local recipeProp = geItemTable.GetRecipeProp(recipeType);
	if recipeProp == nil or recipeProp.reqItemSize == 0 then
		return;
	end

	MANU_APPLY_ALL_SLOT(frame, _ADD_SLOT_ITEM, itemList);
	local ableCnt = _MANU_GET_ABLE_ITEM_LIST(recipeProp, itemList);

end

function MANU_POP_SLOT(slot)

	slot = tolua.cast(slot, "ui::CSlot");
	local popcnt = slot:GetUserIValue("_POP_COUNT");
	local curCount = slot:GetUserIValue("ItemCount");
	curCount = curCount - popcnt;
	slot:SetUserValue("ItemCount", curCount);

	if curCount <= 0 then
		slot:ClearIcon();
		slot:SetText("");
	else
		SET_SLOT_COUNT_TEXT(slot, curCount);
	end
	
end

function ON_MANU_END(frame, msg, madeItemID)

	if frame:IsVisible() == 0 then
		return;
	end

	if madeItemID == nil then
		madeItemID = "";
	end

	local gbox = MANU_PARENT(frame);
	local prog_gauge = GET_CHILD(gbox, "prog_gauge", "ui::CGauge");
	prog_gauge:ShowWindow(0);
	frame:Invalidate();

	local slotSet = GET_CHILD(gbox, "slotlist", "ui::CSlotSet");
	local tgtItemSlot = GET_CHILD(frame, "tgtItemSlot", "ui::CSlot");
	local x, y = GET_UI_FORCE_POS(tgtItemSlot);

	local itemList = {};
	MANU_GET_REAL_MAKE_ITEM(frame, itemList);
	for i = 1, #itemList do
		local item = itemList[i]["Item"];
		local popcnt = itemList[i]["Used"];
		local slot = GET_SLOT_BY_ITEMID(slotSet, item:GetIESID())
		slot:SetUserValue("_POP_COUNT", popcnt);
		UI_PLAYFORCE(slot, "manu_slot_pop", x, y);
	end

	frame:Invalidate();
	RUN_INVALIDATING(frame, 5.0);
	frame:SetUserValue("FORCE_STARTED", 1);
	frame:SetUserValue("MADE_ITEM_ID", madeItemID);
	
end

function MANU_FORCE_COLLISION(slot)
	
	local frame = ui.GetFrame("manufac_renew");
	if frame:GetUserIValue("FORCE_STARTED") == 0 then
		return;
	end

	frame:SetUserValue("FORCE_STARTED", 0);
	local tgtItemSlot = GET_CHILD(frame, "tgtItemSlot", "ui::CSlot");
	local x, y = GET_GLOBAL_XY(tgtItemSlot);
	local imgName = tgtItemSlot:GetIcon():GetInfo():GetImageName();
	
	local madeItemID = frame:GetUserValue("MADE_ITEM_ID");
	INV_FORCE_NOTIFY(madeItemID, x, y, 0);
	frame:ShowWindow(0);

end

function DRAW_RECIPE_MATERIAL(exinfoGroupBox, recipecls, ypos, drawStartIndex)

	if drawStartIndex == nil then
		drawStartIndex = 0;
	end

	local index = 0;
	local groupboxYPos = 5;
	local recipeItemPicSize = 40;
	local recipeItemPicHorzCount = 3;
	local recipeItemTitleTextHeight = 0;
	local recipeItemXPosInit = (250 - recipeItemPicSize * 3) / (recipeItemPicHorzCount+1);
	local recipeItemXPos = (250 - recipeItemPicSize * 3) / (recipeItemPicHorzCount+1);

	local drawIndex = 0;
	local recipeType = recipecls.RecipeType;

	local row = 1;
	while 1 do
		local col = 1;
		local propCnt = 0;
		while 1 do
			local propname = "Item_" .. row .. "_" .. col;
			local propvalue = recipecls[propname];
			local prop = GetPropType(recipecls, propname);
			if prop == nil or propvalue == "None" then
				break;
			end

			if drawIndex >= drawStartIndex then
				local rem = index % recipeItemPicHorzCount;
				if index ~= 0 and rem == 0 then
					groupboxYPos = groupboxYPos + recipeItemPicSize + 5 + recipeItemTitleTextHeight;
					recipeItemXPos = recipeItemXPosInit * (rem+1) + recipeItemPicSize * rem;
				else
					recipeItemXPos = recipeItemXPosInit * (index+1) + recipeItemPicSize * index;
				end

				local recipeItem = propvalue;
				local recipeItemCls = nil;
				local recipeImageName;
				local recipeItemName;
				if propname == 'NeedWiki' then
					recipeItemCls = GetClass('Wiki', recipeItem);
					recipeImageName = recipeItemCls.Illust;
					recipeItemName = recipeItemCls.Name;
				else
					recipeItemCls = GetClass('Item', recipeItem);
					recipeImageName = recipeItemCls.TooltipImage;
					recipeItemName = recipeItemCls.Name;
				end

				local recipeItemCnt, recipeItemLv = 0, 0;
				if propname == 'FromItem' or propname == 'NeedWiki' then
					recipeItemCnt = 1;
				else
					recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, propname);
				end

				local itemRecipePicCtrl = exinfoGroupBox:CreateOrGetControl('picture', recipeItem, recipeItemXPos, groupboxYPos, recipeItemPicSize, recipeItemPicSize);
				tolua.cast(itemRecipePicCtrl, 'ui::CPicture');
				itemRecipePicCtrl:SetEnableStretch(1);
				itemRecipePicCtrl:SetImage(recipeImageName);

				local itemRecipeNameCtrl = exinfoGroupBox:CreateOrGetControl('richtext', recipeItem..'itemName', recipeItemXPos, groupboxYPos + recipeItemPicSize, 70, 20);
				tolua.cast(itemRecipeNameCtrl, 'ui::CRichText');
				itemRecipeNameCtrl:EnableResizeByText(1);
				itemRecipeNameCtrl:SetTextFixWidth(1);
				itemRecipeNameCtrl:SetLineMargin(-2);
				itemRecipeNameCtrl:SetTextAlign("center", "top");

				local invItem = session.GetInvItemByType(recipeItemCls.ClassID);
				local invCnt = 0;
				if invItem == nil then
					if propname == 'NeedWiki' and recipeItemCls ~= nil then
						invCnt = 1;
					end
				else
					invCnt = GET_PC_ITEM_COUNT_BY_LEVEL(recipeItemCls.ClassID, recipeItemLv);
				end
			
				itemRecipeNameCtrl:SetText('{s18}{#050505}'.. GET_RECIPE_ITEM_TXT(recipeType, recipeItemName, recipeItemCnt, recipeItemLv, invCnt));
				local itemTitleXPos = (itemRecipeNameCtrl:GetWidth() - recipeItemPicSize) / 2;
				itemRecipeNameCtrl:SetOffset(recipeItemXPos - itemTitleXPos, groupboxYPos + recipeItemPicSize);

				recipeItemTitleTextHeight = math.max(recipeItemTitleTextHeight, itemRecipeNameCtrl:GetHeight());
				index = index + 1;
			end

			drawIndex = drawIndex + 1;

			propCnt = propCnt + 1;
			col = col + 1;
		end

		if propCnt == 0 then
			break;
		end
		row = row + 1
	end

	if index ~= 0 then
		groupboxYPos = groupboxYPos + recipeItemPicSize + recipeItemTitleTextHeight;
	end

	ypos = ypos + groupboxYPos;
	return ypos;
end

function GET_RECIPE_ITEM_TXT(recipeType, name, cnt, lv, invcnt)

	local color = '{b}{#003366}';

	if invcnt < cnt then
		color = '{b}{#880000}';
	end

	if lv == 0 then
		return string.format("%s {nl}%s(%d/%d)", name, color, invcnt, cnt);
	else
		return string.format("%s{nl}{#0000FF}(Lv%d){/}{nl}%s(%d/%d)", name, lv, color, invcnt, cnt);
	end

end
