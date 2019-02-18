function TEMPITEMUSE_ON_INIT(addon, frame)
	addon:RegisterMsg('TEMPITEM_SET', 'TEMPITEMUSE_ON_MSG');
	addon:RegisterMsg('TEMPITEM_EMPTY', 'TEMPITEMUSE_ON_MSG');
	addon:RegisterMsg('ADD_TEMP_ITEM', 'ADD_TEMP_ITEM_ID');
	addon:RegisterMsg('REMOVE_TEMP_ITEM', 'REMOVE_TEMP_ITEM_ID');

	addon:RegisterMsg('UPDATE_TEMPITEM_COUNT_BY_PROP', 'UPDATE_TEMPITEM_COUNT_BY_PROP')

	ITEM_CHECK_COUNT = 0;
end

function UPDATE_TEMPITEM_COUNT_BY_PROP(frame, msg, argStr, argNum)
	local frame = ui.GetFrame("tempitemuse")

	if frame == nil or frame:IsVisible() == 0 then
		return
	end

	if argStr == nil then
		return
	end

	frame:SetUserValue("CURRENT_EVENT", argStr)
	local count = frame:GetUserIValue(argStr)
	frame:SetUserValue(argStr, count + argNum)

end

function TEMPITEMUSE_ON_MSG(frame, msg, argStr, argNum)
	if msg == 'TEMPITEM_SET' then
	
		local itemCtrl = frame:GetChild('itemgroup');
		if tonumber(argStr) == 1 then
			tolua.cast(itemCtrl, 'ui::CGroupBox');
			ITEM_CHECK_COUNT = 0;
		end

		local itemClass = GetClassByType('Item', argNum);
		local invItem = session.GetInvItemByType(argNum);
		if itemClass ~= nil and itemClass.PreCheckScp ~= 'None' and invItem ~= nil then			
			local xPos = 10 + 80 * ITEM_CHECK_COUNT;
			local slot = itemCtrl:CreateOrGetControl('slot', 'itemslot_', xPos, 10, 80, 80);
			tolua.cast(slot, 'ui::CSlot');
			local beforeIcon = slot:GetIcon();
			local needToCreateIcon = true;
			if beforeIcon ~= nil then
				if slot:GetValue() == argNum and beforeIcon:GetInfo():GetImageName() == itemClass.Icon then
					needToCreateIcon = false;
				end
			end

			if needToCreateIcon == true then
				slot:ClearIcon();
				slot:SetSkinName('useslot');
				slot:SetFrontImage('None');
				local icon = CreateIcon(slot);
				slot:SetValue(argNum);
				ICON_SET_ITEM_COOLDOWN(icon, argNum);
				icon:Set(itemClass.Icon, 'Item', argNum, 0);
			end
			
			ITEM_CHECK_COUNT = ITEM_CHECK_COUNT + 1;
			
			local CURRENT_EVENT = frame:GetUserValue("CURRENT_EVENT")
			local count = frame:GetUserIValue(CURRENT_EVENT)
			local result = 0
			if CURRENT_EVENT == nil or CURRENT_EVENT == "None" or CURRENT_EVENT == "" then
				result = 0
			else
				result = _G["PRECHECK_" .. CURRENT_EVENT](frame, count, itemClass.NumberArg1)
			end

			if result ~= 0 then
				local icon = slot:GetIcon()
				if icon ~= nil then
					icon:SetColorTone("FFFFFFFF")
				end
			else
				local icon = slot:GetIcon()
				if icon ~= nil then
					icon:SetColorTone("FF111111")
				end
			end
		end

		if ITEM_CHECK_COUNT ~= 0 then
			frame:ShowWindow(1);
		end
	elseif msg == 'TEMPITEM_EMPTY' then
		if ITEM_CHECK_COUNT == 0 or argNum == 0 then
			frame:ShowWindow(0);
			ITEM_CHECK_COUNT = 0;
			frame:StopAlphaBlend();
			frame:SetAlpha(100);
		else
			local width = ITEM_CHECK_COUNT * 80 + 30;
			frame:Resize(width, frame:GetHeight());
		end
	end

end

function PRECHECK_NICOPOLIS_RAID_ITEM(frame, curCount, maxCount)
	if frame == nil then
		return 0
	end

	if curCount >= maxCount then
		return 1
	else
		return 0
	end
end

function TEMPITEMUSE_EXECUTE()

	local frame = ui.GetFrame("tempitemuse");
	if frame ~= nil and frame:IsVisible() == 1 then
		local itemGroup = frame:GetChild('itemgroup');
		imcSound.PlaySoundEvent("button_v_click");
		for i=0, itemGroup:GetChildCount()-1 do
			local childCtrl = itemGroup:GetChildByIndex(i);
			local invItem	= session.GetInvItemByType(childCtrl:GetValue());
			INV_ICON_USE(invItem);
		end
	end
end

function ADD_TEMP_ITEM_ID(frame, msg, argStr, argNum)
	AddTempItemID(argNum)
end

function REMOVE_TEMP_ITEM_ID(frame, msg, argStr, argNum)
	RemoveTempItemID(argNum)
end