function PUZZLECRAFT_ON_INIT(addon, frame)

	
end

function PUZZLECRAFT_CLEAR_ALL_SLOT(frame)
	frame = frame:GetTopParentFrame();
	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	CLEAR_SLOTSET(slotset);
	local results = bg:GetChild("results");
	local slots = GET_CHILD(results, "slots", "ui::CSlotSet");
	CLEAR_SLOTSET(slots);
	CHECK_NEW_PUZZLE(frame, nil);
end

function PUZZLECRAFT_OPEN(frame)
	if frame:GetUserIValue("ANI_DOING") == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		frame:ShowWindow(0);
		return;
	end
	ui.OpenFrame("inventory");
end

function PUZZLECRAFT_CLOSE(frame)
	ui.CloseFrame("inventory");
end

function PUZZLECRAFT_SET_MAXSIZE(row, col)
	local frame = ui.GetFrame("puzzlecraft");
	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	frame:SetUserValue("MAXSIZEX", row);
	frame:SetUserValue("MAXSIZEY", col);
	PUZZLECRAFT_INIT_SLOTSKIN(frame);
end	

function PUZZLECRAFT_INIT_SLOTSKIN(frame)
	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	local sizeX = frame:GetUserIValue("MAXSIZEX");
	local sizeY = frame:GetUserIValue("MAXSIZEY");
	local normalSlot = frame:GetUserConfig("NormalSlot");
	local disabledSlot = frame:GetUserConfig("DisabledSlot");
		
	for i = 0, slotset:GetRow()  - 1 do
		for j = 0, slotset:GetCol() - 1 do
			local slot = slotset:GetSlotByRowCol(i, j);
			if i <= sizeX and j <= sizeY then
				slot:SetSkinName(normalSlot);
				slot:SetEnable(1);
			else
				slot:SetSkinName(disabledSlot);
				slot:SetEnable(0);
			end
		end
	end

end

function PUZZLECRAFT_DROP(frame, slot, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	frame = frame:GetTopParentFrame();
	if frame:GetUserIValue("ANI_DOING") == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end
	local iconInfo = liftIcon:GetInfo();
	local guid = iconInfo:GetIESID();
	local invItem = GET_ITEM_BY_GUID(guid);
	slot = tolua.cast(slot, "ui::CSlot");

	if FromFrame:GetName() == 'inventory' then
		if true == invItem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return;
		end
		SET_SLOT_INVITEM(slot, invItem);
		slot:SetText("", 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
		CHECK_NEW_PUZZLE(frame, slot);
		
	elseif FromFrame:GetName() == "puzzlecraft" then
		local captureSlot = ui.GetCapturedSlot();
		if slot == captureSlot then
			return;
		end

		CLEAR_SLOT_ITEM_INFO(captureSlot);
		captureSlot:SetUserValue("SELECTED", 0);

		SET_SLOT_INVITEM(slot, invItem);
		slot:SetText("", 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
		CHECK_NEW_PUZZLE(frame, slot);
	end

end

function PUZZLECRAFT_SLOT_RBTN(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame:GetUserIValue("ANI_DOING") == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end

	ctrl = tolua.cast(ctrl, "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(ctrl);

	local normalSlot = frame:GetUserConfig("NormalSlot");
	ctrl:SetSkinName(normalSlot);
	ctrl:SetUserValue("SELECTED", 0);
	
	if true == CHECK_COMBINATION_BREAK(frame) then
		UPDATE_PUZZLECRAFT_TARGETS();
	end
end

function CHECK_NEW_PUZZLE(frame, checkSlot)

	frame = frame:GetTopParentFrame();
	geItemPuzzle.ClearPuzzleInfo();

	local checkRow = 0;
	local checkCol = 0;
	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	for i = 0 , slotset:GetSlotCount() - 1 do
		local slot = slotset:GetSlotByIndex(i);
		local icon = slot:GetIcon();
		if icon ~= nil then
			if slot:GetUserIValue("SELECTED") == 0 then
				local iconInfo = icon:GetInfo();
				local row = math.floor(i / slotset:GetCol());
				local col = math.mod(i, slotset:GetCol());
				geItemPuzzle.AddPuzzleInfo(row, col, iconInfo.type);

				if checkSlot == slot then
					checkRow = row;
					checkCol = col;
				end
			end
		end
	end
	
	local ret = geItemPuzzle.CheckNewPuzzleInfo(checkRow, checkCol);
	if ret ~= nil then
		local tgt = ret.info:GetTargetItemName();

		local scpString = string.format("SELECT_PUZZLECRAFT_TARGET(%d, %d, %d)", ret.info.classID, ret.row, ret.col)
		local destItem = GetClass("Item", ret.info:GetTargetItemName());
		local msgString = ClMsg("WouldYouSelectThisCombinationAsAlchemystryTarget?");
		msgString = msgString.. "{nl}" ..ClMsg("TargetItem") .. " : " ;
		msgString = msgString .. string.format("{img %s %d %d}%s", destItem.Icon, 40, 40, destItem.Name);
		ui.MsgBox(msgString, scpString, "None");
		
	end

	if true == CHECK_COMBINATION_BREAK(frame) then
		UPDATE_PUZZLECRAFT_TARGETS();
	end
end

function CHECK_COMBINATION_BREAK(frame)

	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	local cnt = geItemPuzzle.GetCombinationCount();
	for i = 0 , cnt - 1 do
		local info = geItemPuzzle.GetCombinationByIndex(i);
		local resultInfo = geItemPuzzle.GetByClassID(info.classID);
		local ptCount = info:GetPointCount();
		for p = 0 , ptCount - 1 do
			local pt = info:GetPointByIndex(p);
			local row = pt.y;
			local col = pt.x;
			local matCnt = resultInfo:GetMaterialCount();
			for j = 0 , matCnt - 1 do
				local mat = resultInfo:GetMaterialByIndex(j);
				local slotRow = mat.row + row;
				local slotCol = mat.col + col;
				local slot = slotset:GetSlotByRowCol(slotRow, slotCol);
				if slot:GetIcon() == nil or slot:GetUserIValue("SELECTED") == 0 or slot:GetIcon():GetInfo().type ~= mat:GetItemType() then
					geItemPuzzle.RemoveCombination(info.classID, row, col);
					return true;
				end
			end
		end
	end

	return false;
end

function SELECT_PUZZLECRAFT_TARGET(classID, row, col)
	geItemPuzzle.AddCombination(classID, row, col);
	UPDATE_PUZZLECRAFT_TARGETS();
end

function UPDATE_PUZZLECRAFT_TARGETS()
	local frame = ui.GetFrame("puzzlecraft");
	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");

	local results = bg:GetChild("results");
	local slots = GET_CHILD(results, "slots", "ui::CSlotSet");
	CLEAR_SLOTSET(slots);

	PUZZLECRAFT_INIT_SLOTSKIN(frame);
	for i = 0 , slotset:GetSlotCount() - 1 do
		local slot = slotset:GetSlotByIndex(i);
		slot:SetUserValue("SELECTED", 0);
	end		
	
	local cnt = geItemPuzzle.GetCombinationCount();
    local totalNeedSecond = 0;
	for i = 0 , cnt - 1 do
		local info = geItemPuzzle.GetCombinationByIndex(i);
		local resultInfo = geItemPuzzle.GetByClassID(info.classID);
		local ptCount = info:GetPointCount();
		for p = 0 , ptCount - 1 do
			local pt = info:GetPointByIndex(p);
			local row = pt.y;
			local col = pt.x;
			local matCnt = resultInfo:GetMaterialCount();
			for j = 0 , matCnt - 1 do
				local mat = resultInfo:GetMaterialByIndex(j);
				local slotRow = mat.row + row;
				local slotCol = mat.col + col;
				local slot = slotset:GetSlotByRowCol(slotRow, slotCol);
				slot:SetUserValue("SELECTED", 1);
				slot:SetSkinName(frame:GetUserConfig("CombinationSlot"));
			end
		end

		local retSlot = slots:GetSlotByIndex(i);
		local itemCls = GetClass("Item", resultInfo:GetTargetItemName());
		SET_SLOT_ITEM_CLS(retSlot, itemCls);
		SET_SLOT_COUNT_TEXT(retSlot, ptCount)

        totalNeedSecond = totalNeedSecond + resultInfo.needSec * ptCount;
	end

    PUZZLECRAFT_UPDATE_TOTAL_TIME(frame, totalNeedSecond);
end

function PUZZLECRAFT_UPDATE_TOTAL_TIME(frame, totalNeedSecond)
    if totalNeedSecond < 0 then
        totalNeedSecond = 0;
    end
    
    local richtext_1 = GET_CHILD_RECURSIVELY(frame, 'richtext_1');
    local minute = totalNeedSecond / 60;
    local second = totalNeedSecond % 60;
    local timeStr = string.format('%d:%02d', minute, second);
    richtext_1:SetTextByKey('value', timeStr);
end

function PUZZLE_ANIM_EXCUTE()
	local frame = ui.GetFrame("puzzlecraft");
	frame:SetUserValue("ANI_DOING", 1);
end

function PUZZLECRAFT_EXEC(frame)
	frame = frame:GetTopParentFrame();

	if frame:GetUserIValue("ANI_DOING") == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end

	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	for i = 0 , slotset:GetSlotCount() - 1 do
		local slot = slotset:GetSlotByIndex(i);
		local icon = slot:GetIcon();
		if icon ~= nil then
			if slot:GetUserIValue("SELECTED") == 0 then
				ui.MsgBox(ClMsg("NotCombinedItemExist"));
				return;
			end
		end
	end

	ui.MsgBox(ClMsg("ReallyManufactureItem?"), "_PUZZLECRAFT_EXEC", "None");
end


function _PUZZLECRAFT_EXEC()
	local frame = ui.GetFrame("puzzlecraft");
	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	if false == geItemPuzzle.ExecCombination(true) then
		return ui.SysMsg(ClMsg("NotEnoughRecipe"));
	end

	frame:ShowWindow(0);
end

function PUZZLE_WAIT_END(result)
	if 1 == tonumber(result) then
		geItemPuzzle.ExecCombination(false);
	end
	local frame = ui.GetFrame("puzzlecraft");
	frame:SetUserValue("ANI_DOING", 0);
end

function PUZZLE_COMPLETE()
	local frame = ui.GetFrame("puzzlecraft");
	local bg = frame:GetChild("bg");
	local slotset = GET_CHILD(bg, "slotset", "ui::CSlotSet");
	geItemPuzzle.ClearCombination();

	local results = bg:GetChild("results");
	local slots = GET_CHILD(results, "slots", "ui::CSlotSet");
	CLEAR_SLOTSET(slots);

	local sysmenu = ui.GetFrame("sysmenu");
	local btn = sysmenu:GetChild("inven");
	local tx, ty = GET_UI_FORCE_POS(btn);

	PUZZLECRAFT_INIT_SLOTSKIN(frame);
	for i = 0 , slotset:GetSlotCount() - 1 do
		local slot = slotset:GetSlotByIndex(i);
		local icon = slot:GetIcon();
		if icon ~= nil then
			-- UI_PLAYFORCE(slot, "shoot_ui_effect", tx, ty)
		end
		CLEAR_SLOT_ITEM_INFO(slot);
		slot:SetUserValue("SELECTED", 0);
	end		
    
    PUZZLECRAFT_UPDATE_TOTAL_TIME(frame, 0);
end

function PUZZLE_MAKING_BALLOON(handle, itemCount)

	local frameName = "PUZZLE_MAKING_" .. handle;
	if itemCount == 0 then
		ui.CloseFrame(frameName)
	else
	
		if FindCmdLine("-VIDEOTEST") > 0 then
			return;
		end

		local balloonFrame = MAKE_BALLOON_FRAME("{s20}{b}" .. ClMsg("ManufacturingItems..."), 0, 0, nil, frameName);
		if balloonFrame == nil then
			return nil;
		end

		local textCtrl = GET_CHILD(balloonFrame, "text", "ui::CRichText");
		textCtrl:SetTooltipType('puzzlecraft');
		textCtrl:SetTooltipArg(0, handle, "");

		balloonFrame:SetUserValue("HANDLE", handle);
		balloonFrame:ShowWindow(1);

		FRAME_AUTO_POS_TO_OBJ(balloonFrame, handle, -balloonFrame:GetWidth() / 2, -100, 3, 1);

	end

end

function UPDATE_PUZZLECRAFT_MAKING_TOOLTIP(frame, strArg, numArg)
	local gbox = frame:GetChild("gbox");
	gbox:RemoveAllChild();


	local cnt = session.bindFunc.GetMakingPuzzleCount(numArg);
	for i = 0 , cnt - 1 do
		local item = session.bindFunc.GetMakingPuzzle(numArg, i);
		local ctrlSet = gbox:CreateControlSet('puzzlecraft_tooltip_set', "ITEM_" .. i, ui.LEFT, ui.TOP, 10, 0, 0, 0);
		ctrlSet:ShowWindow(1);
		local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
		local itemCls = GetClassByType("Item", item.itemType);
		SET_SLOT_ITEM_CLS(slot, itemCls)
		local itemtext = ctrlSet:GetChild("itemtext");
		local txt = itemCls.Name .. " X " .. item.itemCount;
		itemtext:SetTextByKey("txt", txt);
	end

	GBOX_AUTO_ALIGN(gbox, 10, 10, 10, true, true);
	frame:Resize(frame:GetWidth(), gbox:GetY() + gbox:GetHeight() + 10)

end