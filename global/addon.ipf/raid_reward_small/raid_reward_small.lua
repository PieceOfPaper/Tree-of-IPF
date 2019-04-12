

function RAID_REWARD_SMALL_ON_INIT(addon, frame)


end

function ITEM_BALLOON_CLEAR(handle)
	local customName = string.format("ITEM_COMMON_%d", handle);
	local frame = ui.GetFrame(customName);
	if frame ~= nil then
		local itemcontainer = GET_CHILD(frame, "itemcontainer", "ui::CGroupBox");
		itemcontainer:RemoveAllChild();
		frame:ShowWindow(0);
	end
end

function ITEM_BALLOON_COMMON(handle, itemCls, tooltipEnum, duration, delaySec, skinName, msgText)
  if world.GetLayer() ~= 0 then
		return 0;
	end

	if nil == itemCls then
		return;
	end

	local scp = _G[itemCls.RefreshScp];
	if nil ~= scp then
		scp(itemCls);
	end

	delaySec = 0.0;

	local customName = string.format("ITEM_COMMON_%d", handle);
	local frame = ui.GetFrame(customName);
	local isFirstItem = false;
	if frame == nil then
		frame = ui.CreateNewFrame("raid_reward_small", customName, 0);
		isFirstItem = true;
	else
		if frame:IsVisible() == 0 then
			isFirstItem = true;
		end
	end

	if delaySec == 0 then
		frame:ShowWindow(1);
	else
		frame:ReserveScript("OPEN_WINDOW", delaySec, 1);
		frame:ShowWindow(0);
	end

	frame:EnableInstanceMode(1);

	frame:EnableHideProcess(1);
	frame:SetDuration(duration + delaySec);
	frame:SetUserValue("HANDLE", handle);
	frame:RunUpdateScript("RAID_REWARD_BAL_POS");
	local descText = frame:GetChild("desctext");

	local itemcontainer = GET_CHILD(frame, "itemcontainer", "ui::CGroupBox");
	if isFirstItem == true then
		itemcontainer:RemoveAllChild();
	end

	local ctrlSetWidth = ui.GetControlSetAttribute(skinName, 'width');
	local ctrlSetHeight = ui.GetControlSetAttribute(skinName, 'height');
	local cnt = itemcontainer:GetChildCount();
	
	local heightCnt = 0;
	local widthCnt = cnt;
	local maxWidthCnt = cnt;
	if(widthCnt > 2) then
		heightCnt = 1;
		widthCnt = widthCnt-3;
		maxWidthCnt = 2;
	end
	if(widthCnt > 2) then
		heightCnt = 2;
		widthCnt = widthCnt-3;
	end

	descText:SetText(msgText);
	local ctrlSet = itemcontainer:CreateControlSet(skinName, "BOX_" .. cnt, widthCnt * ctrlSetWidth, descText:GetHeight() + ctrlSetHeight * heightCnt);
	local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
	local itemSlot = GET_CHILD(ctrlSet, "itemslot", "ui::CSlot");
	local itemtext = GET_CHILD(ctrlSet, "itemtext", "ui::CRichText");	
	if itemCls ~= nil then
		SET_SLOT_ITEM_OBJ(itemSlot, itemCls);
		itemSlot:EnableDrag(0);

		local gradeTxt = GET_ITEM_GRADE_TXT(itemCls, 24);
		itemtext:SetTextByKey("txt", gradeTxt);
	else
		CLEAR_SLOT_ITEM_INFO(itemSlot);
		itemtext:SetTextByKey("txt", "");
	end
	
	local width = maxWidthCnt * ctrlSetWidth + ctrlSetWidth;
	local height = heightCnt * ctrlSetHeight + ctrlSetHeight;
	itemcontainer:Resize(width, height);


	frame:Resize(itemcontainer:GetWidth(), itemcontainer:GetHeight() + 50);
	itemSlot:EnableHitTest(1)
	RAID_REWARD_BAL_POS(frame);

end

function REWARD_ITEM_BALLOON(handle, rewardList)

	local customName = string.format("RAID_RESULT_%d", handle);
	local frame = ui.CreateNewFrame("raid_reward_small", customName);
	frame:GetChild("desctext"):SetText("{@sti7}{s24}" .. ClMsg("ReceivedReward!!!"));
	frame:ShowWindow(1);
	--frame:SetDuration(3);
	frame:SetUserValue("HANDLE", handle);
	frame:RunUpdateScript("RAID_REWARD_BAL_POS");

	local itemcontainer = frame:GetChild("itemcontainer");
	itemcontainer:RemoveAllChild();
	local ctrlSetWidth = ui.GetControlSetAttribute(skinName, 'width');

	for i = 0 , rewardList:size() - 1 do
		local rItem = rewardList:at(i);
		local itemCls = GetClassByType("Item", rItem.itemType);

		local ctrlSet = itemcontainer:CreateControlSet('reward_itembox', "BOX_" .. i, i * ctrlSetWidth, 0);
		local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
		local itemSlot = GET_CHILD(ctrlSet, "itemslot", "ui::CSlot");
		local itemtext = GET_CHILD(ctrlSet, "itemtext", "ui::CRichText");

		SET_SLOT_ITEM_CLS(itemSlot, itemCls);
		local gradeTxt = GET_ITEM_GRADE_TXT(itemCls, 24);
		itemtext:SetTextByKey("txt", gradeTxt .. GET_FULL_NAME(itemCls));
	end

	local width = (itemcontainer:GetChildCount() - 1) * ctrlSetWidth;
	itemcontainer:Resize(width, ctrlSet:GetHeight());

	frame:Resize(itemcontainer:GetWidth(), itemcontainer:GetHeight() + 50);

end

function RAID_REWARD_BAL_POS(frame)

	frame = tolua.cast(frame, "ui::CFrame");
	local handle = frame:GetUserIValue("HANDLE");
	local point = info.GetPositionInUI(handle, 2);
	local x = point.x - frame:GetWidth() / 2;
	local y = point.y - frame:GetHeight() - 40;
	frame:MoveFrame(x, y);
	return 1;
end
