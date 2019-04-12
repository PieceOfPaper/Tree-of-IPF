function QUESTITEMUSE_ON_INIT(addon, frame)
	addon:RegisterMsg('QUESTITEM_SET', 'QUESTITEMUSE_ON_MSG');
	addon:RegisterMsg('QUESTITEM_EMPTY', 'QUESTITEMUSE_ON_MSG');

	QUEST_CHECK_COUNT = 0;
end

function QUESTITEMUSE_ON_MSG(frame, msg, argStr, argNum)

	if msg == 'QUESTITEM_SET' then
		local itemCtrl = frame:GetChild('itemgroup');
		if tonumber(argStr) == 1 then
			tolua.cast(itemCtrl, 'ui::CGroupBox');
			QUEST_CHECK_COUNT = 0;
		end

		local itemClass = GetClassByType('Item', argNum);
		local invItem = session.GetInvItemByType(argNum);

		if itemClass ~= nil and itemClass.PreCheckScp ~= 'None' and invItem ~= nil then			
			local result = _G[itemClass.PreCheckScp](GetMyPCObject(), itemClass.StringArg, itemClass.NumberArg1, itemClass.NumberArg2);
			if result ~= 0 then
				local xPos = 15;
				local slot = itemCtrl:CreateOrGetControl('slot', 'itemslot_', xPos, 10, 80, 80);
				tolua.cast(slot, 'ui::CSlot');
				local beforeIcon = slot:GetIcon();
				local needToCreateIcon = true;
				if beforeIcon ~= nil then
					if slot:GetValue() == argNum and beforeIcon:GetInfo().imageName == itemClass.Icon then
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
				

				QUEST_CHECK_COUNT = QUEST_CHECK_COUNT + 1;
			else
				local slot = itemCtrl:GetChild('itemslot_'..argNum);

				if slot ~= nil then
					itemCtrl:DeleteControl('itemslot_'..argNum);
				end
			end
		end

		if QUEST_CHECK_COUNT ~= 0 then
			frame:ShowWindow(1);
			frame:SetAlpha(0, 100, 30, 1.0, "None", 1);
		end
	elseif msg == 'QUESTITEM_EMPTY' then
		if QUEST_CHECK_COUNT == 0 or argNum == 0 then
			frame:ShowWindow(0);
			QUEST_CHECK_COUNT = 0;
			frame:StopAlphaBlend();
			frame:SetAlpha(100);
		else
		--	local width = QUEST_CHECK_COUNT * 80 + 30;
			local width = 110;
			frame:Resize(width, frame:GetHeight());
		end
	end

end

function QUESTITEMUSE_EXECUTE()

	local tempItemFrame = ui.GetFrame("tempitemuse")
	--임사사용템, 퀘스트템 중 우선순위 정해야함
	if tempItemFrame ~= nil and tempItemFrame:IsVisible() == 1 then
		TEMPITEMUSE_EXECUTE()
	else
		local frame = ui.GetFrame('questitemuse');
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
end
