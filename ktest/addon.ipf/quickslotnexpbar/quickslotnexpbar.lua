-- quickslotnexpbar.lua

MIN_QUICKSLOT_CNT = 20;
MAX_QUICKSLOT_CNT = 40;
QUICKSLOT_OVERHEAT_GAUGE = "overheat_gauge";

function QUICKSLOTNEXPBAR_ON_INIT(addon, frame)
	QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME(frame);
	
	QUICKSLOTNEXPBAR_Frame = frame;

	addon:RegisterMsg('GAME_START', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('QUICKSLOT_LIST_GET', 'QUICKSLOTNEXPBAR_ON_MSG');

	addon:RegisterMsg('KEYBOARD_INPUT', 'KEYBOARD_INPUT');
	
	addon:RegisterMsg('SKILL_LIST_GET', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('REGISTER_QUICK_SKILL', 'QUICKSLOT_REGISTER_Skill');
	addon:RegisterMsg('REGISTER_QUICK_ITEM', 'QUICKSLOT_REGISTER_Item');

	addon:RegisterMsg('INV_ITEM_ADD', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('INV_ITEM_POST_REMOVE', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('INV_ITEM_CHANGE_COUNT', 'QUICKSLOTNEXPBAR_ON_MSG');
	
	addon:RegisterMsg('EQUIP_ITEM_LIST_GET', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('PC_PROPERTY_UPDATE', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('PET_SELECT', 'ON_PET_SELECT');

	addon:RegisterMsg('JUNGTAN_SLOT_UPDATE', 'JUNGTAN_SLOT_ON_MSG');
	addon:RegisterMsg('REMOVE_SKILL', 'ON_REMOVE_SKILL');

	addon:RegisterMsg('EXP_ORB_ITEM_ON', 'EXP_ORB_SLOT_ON_MSG');
	addon:RegisterMsg('EXP_ORB_ITEM_OFF', 'EXP_ORB_SLOT_ON_MSG');
	addon:RegisterMsg('QUICK_SLOT_LOCK_STATE', 'SET_QUICK_SLOT_LOCK_STATE');


	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_QUICKSLOT_OVERHEAT");
	timer:Start(0.3);


end

function QUICKSLOT_MAKE_GAUGE(slot)

	local x = 2;
	local y = slot:GetHeight() - 11;
	local width  = 45;
	local height = 10;
	local gauge = slot:MakeSlotGauge(x, y, width, height);
	gauge:SetDrawStyle(ui.GAUGE_DRAW_CELL);
	gauge:SetSkinName("dot_skillslot");
	
end

function QUICKSLOT_SET_GAUGE_VISIBLE(slot, isVisible)

	local gauge = slot:GetSlotGauge();
	gauge:ShowWindow(isVisible);
	slot:InvalidateGauge();

end

function EXP_ORB_SLOT_ON_MSG(frame, msg, str, num)
	local timer = GET_CHILD(frame, "exporbtimer", "ui::CAddOnTimer");
	if msg == "EXP_ORB_ITEM_OFF" then
		frame:SetUserValue("EXP_ORB_EFFECT", 0);
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');
	elseif msg == "EXP_ORB_ITEM_ON" then
		frame:SetUserValue("EXP_ORB_EFFECT", str);
		timer:SetUpdateScript("UPDATE_QUICKSLOT_EXP_ORB");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_atk_booster_on');
	end
	DebounceScript("QUICKSLOTNEXTBAR_UPDATE_ALL_SLOT", 0.1);
end

function JUNGTAN_SLOT_ON_MSG(frame, msg, str, itemType)

	-- atk jungtan
	if str == 'JUNGTAN_OFF' then

		frame:SetUserValue("JUNGTAN_EFFECT", 0);
		local timer = GET_CHILD(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');

	elseif str == 'JUNGTAN_ON' then

		frame:SetUserValue("JUNGTAN_EFFECT", itemType);
		local timer = GET_CHILD(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_QUICKSLOT_JUNGTAN");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_atk_booster_on');

	-- def jungtan
	elseif str == 'JUNGTANDEF_OFF' then

		frame:SetUserValue("JUNGTANDEF_EFFECT", 0);
		local timer = GET_CHILD(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');

	elseif str == 'JUNGTANDEF_ON' then

		frame:SetUserValue("JUNGTANDEF_EFFECT", itemType);
		local timer = GET_CHILD(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_QUICKSLOT_JUNGTANDEF");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_def_booster_on');
	
	-- dispel magic
	elseif str == 'DISPELDEBUFF_OFF' then

		frame:SetUserValue("DISPELDEBUFF_EFFECT", 0);
		local timer = GET_CHILD(frame, "dispeldebufftimer", "ui::CAddOnTimer");
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');

	elseif str == 'DISPELDEBUFF_ON' then

		frame:SetUserValue("DISPELDEBUFF_EFFECT", itemType);
		local timer = GET_CHILD(frame, "dispeldebufftimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_QUICKSLOT_DISPEL_DEBUFF");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_def_booster_on');
	
	end
	
end

function PLAY_QUICKSLOT_UIEFFECT(frame, itemID)
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i);
		if quickSlotInfo ~= nil then
			if quickSlotInfo.type == itemID then
				local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
				if slot ~= nil then
					local posX, posY = GET_SCREEN_XY(slot);
					-- SLOT ???úÏÑ±???ÅÌÉú?ºÎïåÎß?Í∑∏Î¶∞??
					if CHECK_SLOT_ON_ACTIVEQUICKSLOTSET(frame, i) == true then
						-- ?§Ï??ºÏù¥ ?àÎ¨¥ ?¨Í≤å ?òÏ???Ï°∞Í∏à Ï§ÑÏûÑ. 
						movie.PlayUIEffect('I_sys_item_slot', posX, posY, 0.8); 
					end
					
				end
			end
		end
	end
end

function PLAY_QUICKSLOT_UIEFFECT_BY_GUID(frame, guid)
	local slotlist = {};
	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i);
		if quickSlotInfo ~= nil then
			if quickSlotInfo:GetIESID() == guid then
				slotlist[#slotlist + 1] = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			end
		end
	end

	for i=1, #slotlist do
		local slot = slotlist[i];
		if slot ~= nil then
			local posX, posY = GET_SCREEN_XY(slot);
			if CHECK_SLOT_ON_ACTIVEQUICKSLOTSET(frame, i) == true then
				movie.PlayUIEffect('I_sys_item_slot', posX, posY, 0.8); 
			end
		end
	end
end

function UPDATE_QUICKSLOT_EXP_ORB(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local expOrb = frame:GetUserValue("EXP_ORB_EFFECT");
	if expOrb ~= "None" then
		PLAY_QUICKSLOT_UIEFFECT_BY_GUID(frame, expOrb);
	end
end

function UPDATE_QUICKSLOT_JUNGTAN(frame, ctrl, num, str, time)

	if frame:IsVisible() == 0 then
		return;
	end

	local jungtanID = tonumber( frame:GetUserValue("JUNGTAN_EFFECT") );
	if jungtanID > 0 then
		PLAY_QUICKSLOT_UIEFFECT(frame, jungtanID);
	end
end

function UPDATE_QUICKSLOT_JUNGTANDEF(frame, ctrl, num, str, time)

	if frame:IsVisible() == 0 then
		return;
	end

	local jungtanDefID = tonumber( frame:GetUserValue("JUNGTANDEF_EFFECT") );
	if jungtanDefID > 0 then
		PLAY_QUICKSLOT_UIEFFECT(frame, jungtanDefID);
	end

end

function UPDATE_QUICKSLOT_DISPEL_DEBUFF(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local dispelmagicID = tonumber( frame:GetUserValue("DISPELDEBUFF_EFFECT") );
	if dispelmagicID > 0 then
		PLAY_QUICKSLOT_UIEFFECT(frame, dispelmagicID);
	end

end


function UPDATE_QUICKSLOT_OVERHEAT(frame, ctrl, num, str, time)
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
		UPDATE_SLOT_OVERHEAT(slot);
	end
end

function SET_QUICKSLOT_OVERHEAT(slot)

	local obj = GET_SLOT_SKILL_OBJ(slot);
	if obj == nil or obj.OverHeatGroup == "None" then
		QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
		return;
	end

	QUICKSLOT_SET_GAUGE_VISIBLE(slot, 1);
	UPDATE_SLOT_OVERHEAT(slot);

end

function UPDATE_SLOT_OVERHEAT(slot)
	local obj = GET_SLOT_SKILL_OBJ(slot);

	local icon = slot:GetIcon()
	local isScroll = nil
	if icon ~= nil then
		 isScroll = icon:GetUserValue("IS_SCROLL")
	end

	if obj == nil or obj.OverHeatGroup == "None" or isScroll == "YES" then
		return;
	end

	local sklType = obj.ClassID;
	local skl = session.GetSkill(sklType);
	skl = GetIES(skl:GetObject());
	local useOverHeat = skl.SklUseOverHeat;
	local curHeat = session.GetSklOverHeat(sklType);
	curHeat = curHeat + useOverHeat - 1;
	local maxOverHeat = session.GetSklMaxOverHeat(sklType);
	local gauge = slot:GetSlotGauge();

	gauge:SetCellPoint(useOverHeat);
	gauge:SetPoint(curHeat, maxOverHeat);
	slot:InvalidateGauge();
end

function GET_SLOT_SKILL_TYPE(slot)
	if nil == slot then
		return 0;
	end
	slot = tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then
		return 0;
	end;

	local category = icon:GetTooltipType();
	if category ~= "skill" then
		return 0;
	end

	return icon:GetTooltipNumArg();
end

function GET_SLOT_SKILL_OBJ(slot)

	local type = GET_SLOT_SKILL_TYPE(slot);
	if type == 0 then
		return nil;
	end

	local skl = session.GetSkill(type);

	if skl == nil then
		return nil;
	end

	return GetIES(skl:GetObject());

end

function SET_QUICK_SLOT(slot, category, type, iesID, makeLog, sendSavePacket)
	local icon 	= CreateIcon(slot);
	local imageName = "";

	if category == 'Action' then
		icon:SetColorTone("FFFFFFFF");
		icon:ClearText();
	elseif category == 'Skill' then
		local skl = session.GetSkill(type);
		if skl == nil then
			slot:ClearIcon();
			QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
			return;
		end
		imageName = 'icon_' .. GetClassString('Skill', type, 'Icon');
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_SKILL_COOLDOWN');
		icon:SetEnableUpdateScp('ICON_UPDATE_SKILL_ENABLE');
		icon:SetColorTone("FFFFFFFF");
		icon:ClearText();
		quickslot.OnSetSkillIcon(slot, type);
	elseif category == 'Item' then
		local itemIES = GetClassByType('Item', type);
		if itemIES ~= nil then			
			imageName = itemIES.Icon;
			
			local invenItemInfo = nil

			if iesID == "" then
				invenItemInfo = session.GetInvItemByType(type);
			else
				invenItemInfo = session.GetInvItemByGuid(iesID);
			end

			local skill_scroll = 910001;
			if invenItemInfo == nil then
				if skill_scroll ~= type then
					invenItemInfo = session.GetInvItemByType(type);
				end
			end

			if invenItemInfo ~= nil and invenItemInfo.type == math.floor(type) then
				itemIES = GetIES(invenItemInfo:GetObject());
				imageName = GET_ITEM_ICON_IMAGE(itemIES);
				local result = CHECK_EQUIPABLE(itemIES.ClassID);
				icon:SetEnable(1);
				icon:SetEnableUpdateScp('None');
				if result == 'OK' then
					icon:SetColorTone("FFFFFFFF");
				else
					icon:SetColorTone("FFFF0000");
				end

				if itemIES.MaxStack > 0 or itemIES.GroupName == "Material" then
					if itemIES.MaxStack > 1 then -- Í∞úÏàò???§ÌÉù???ÑÏù¥?úÎßå ?úÏãú?¥Ï£º??
						icon:SetText(invenItemInfo.count, 'quickiconfont', 'right', 'bottom', -2, 1);
					else
					  icon:SetText(nil, 'quickiconfont', 'right', 'bottom', -2, 1);
					end
					icon:SetColorTone("FFFFFFFF");
				end

				tolua.cast(icon, "ui::CIcon");
				local iconInfo = icon:GetInfo();
				iconInfo.count = invenItemInfo.count;

				if skill_scroll == type then
					icon:SetUserValue("IS_SCROLL","YES")
				else
					icon:SetUserValue("IS_SCROLL","NO")
				end

			else
				icon:SetColorTone("FFFF0000");
				icon:SetText(0, 'quickiconfont', 'right', 'bottom', -2, 1);
			end

			ICON_SET_ITEM_COOLDOWN_OBJ(icon, itemIES);
		end
	end

	if imageName ~= "" then
		if iesID == nil then
			iesID = ""
		end
		
		local category = category;
		local type = type;

		if category == 'Item' then
			icon:SetTooltipType('wholeitem');
			
			local invItem = nil

			if iesID == '0' then
				invItem = session.GetInvItemByType(type);
			elseif iesID == "" then
				invItem = session.GetInvItemByType(type);
			else
				invItem = session.GetInvItemByGuid(iesID);
			end

			if invItem ~= nil and invItem.type == type then
				iesID = invItem:GetIESID();
			end

			if invItem ~= nil then
				icon:Set(imageName, 'Item', invItem.type, invItem.invIndex, invItem:GetIESID(), invItem.count);
				ICON_SET_INVENTORY_TOOLTIP(icon, invItem, "quickslot", GetIES(invItem:GetObject()));
			else
				icon:Set(imageName, category, type, 0, iesID);
				icon:SetTooltipNumArg(type);
				icon:SetTooltipIESID(iesID);
			end
		else
			if category == 'Skill' then
				icon:SetTooltipType('skill');
				local skl = session.GetSkill(type);
				if skl ~= nil then
					iesID = skl:GetIESID();
				end
			end
		
			icon:Set(imageName, category, type, 0, iesID);
			icon:SetTooltipNumArg(type);
			icon:SetTooltipIESID(iesID);		
		end

		local isLockState = quickslot.GetLockState();
		if isLockState == 1 then
			slot:EnableDrag(0);
		else
			slot:EnableDrag(1);
		end

		INIT_QUICKSLOT_SLOT(slot, icon);
		local sendPacket = 1;
		if false == sendSavePacket then
			sendPacket = 0;
		end

		quickslot.SetInfo(slot:GetSlotIndex(), category, type, iesID);

		icon:SetDumpArgNum(slot:GetSlotIndex());
	else
		slot:EnableDrag(0);
	end

	if category == 'Skill' then
		SET_QUICKSLOT_OVERHEAT(slot);
		SET_QUICKSLOT_TOOLSKILL(slot);
	end
end

function QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME(frame)
	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local slot = frame:GetChild("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		local slotString = 'QuickSlotExecute'..(i+1);
		local text = hotKeyTable.GetHotKeyString(slotString);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', 'left', 'top', 2, 1);
		QUICKSLOT_MAKE_GAUGE(slot);
	end
end

function QUICKSLOTNEXTBAR_UPDATE_ALL_SLOT()
	local frame = ui.GetFrame('quickslotnexpbar');
	local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i);
		local updateslot = true;
		if sklCnt > 0 then
			if quickSlotInfo.category == 'Skill' then
			    updateslot = false;
		    end

			if i <= sklCnt then
				updateslot = false;
			end
		end	

		if true == updateslot and quickSlotInfo.category ~= 'NONE' then
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			SET_QUICK_SLOT(slot, quickSlotInfo.category, quickSlotInfo.type, quickSlotInfo:GetIESID(), 0, false);
		end
	end
end

function QUICKSLOTNEXPBAR_ON_MSG(frame, msg, argStr, argNum)
	local joystickquickslotFrame = ui.GetFrame('joystickquickslot');
	JOYSTICK_QUICKSLOT_ON_MSG(joystickquickslotFrame, msg, argStr, argNum)
		
	local skillList = session.GetSkillList();
	local skillCount = skillList:Count();
	local invItemList = session.GetInvItemList();
	local itemCount = invItemList:Count();

	local MySession = session.GetMyHandle();
	local MyJobNum = info.GetJob(MySession);
	local JobName = GetClassString('Job', MyJobNum, 'ClassName');

	if msg == 'GAME_START' then
		ON_PET_SELECT(frame);
	end

	if msg == 'QUICKSLOT_LIST_GET' or msg == 'GAME_START' or msg == 'EQUIP_ITEM_LIST_GET' or msg == 'PC_PROPERTY_UPDATE' 
	or msg == 'INV_ITEM_ADD' or msg == 'INV_ITEM_POST_REMOVE' or msg == 'INV_ITEM_CHANGE_COUNT' then
		DebounceScript("QUICKSLOTNEXTBAR_UPDATE_ALL_SLOT", 0.1);
	end
		
	local curCnt = quickslot.GetActiveSlotCnt();
		
	QUICKSLOT_REFRESH(curCnt);
end

function SET_QUICK_SLOT_LOCK_STATE(frame, msg, argStr, argNum)
	local isLockState = quickslot.GetLockState();
		QUICKSLOT_SET_LOCKSTATE(frame, isLockState);
end

function QUICKSLOTNEXPBAR_CHANGE_INVINDEX(quickslot, quickIndex, changeIndex)
	local slot = quickslot:GetChild("slot" .. quickIndex + 1);
	tolua.cast(slot, "ui::CSlot");	
	local icon = slot:GetIcon();
	if icon ~= nil then
		local iconInfo = icon:GetInfo();
		iconInfo.ext = changeIndex;
		quickslot.SetInfo(slot:GetSlotIndex(), iconInfo.category, iconInfo.type, changeIndex);
	end
end

function QUICKSLOT_ON_CHANGE_INVINDEX(fromIndex, toIndex)
	local frame = ui.GetFrame("quickslotnexpbar");
		local toInvIndex = toIndex;
		local fromInvIndex = fromIndex;
		local toQuickIndex = -1;
		local fromQuickIndex = -1;

		local invenItemInfo = session.GetInvItem(toInvIndex);

		for i = 0, MAX_QUICKSLOT_CNT - 1 do
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			local icon = slot:GetIcon();
			if icon ~= nil then
				local iconInfo = icon:GetInfo();
				if fromInvIndex == 0 then
					if iconInfo.type == invenItemInfo.type then
						iconInfo.ext = toInvIndex;
						quickslot.SetInfo(slot:GetSlotIndex(), iconInfo.category, iconInfo.type, iconInfo.ext);
					end
				else

					if iconInfo.ext == toInvIndex then
						toQuickIndex = i;
					elseif iconInfo.ext == fromInvIndex then
						fromQuickIndex = i;
					end
				end
			end
		end

		if toQuickIndex ~= -1 then
			QUICKSLOTNEXPBAR_CHANGE_INVINDEX(frame, toQuickIndex, fromIndex);
		end

		if fromQuickIndex ~= -1 then
			QUICKSLOTNEXPBAR_CHANGE_INVINDEX(frame, fromQuickIndex, toIndex);
		end
end

function QUICKSLOTNEXPBAR_SLOT_USE(frame, slot, argStr, argNum)
	if GetCraftState() == 1 then
		return;
	end

	tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then
		return;
	end

	local iconInfo = icon:GetInfo();

	if iconInfo.category == 'Skill' then    
		ICON_USE(icon);
		return;
	end

	local invenItemInfo = session.GetInvItem(iconInfo.ext);
	if invenItemInfo == nil then
		invenItemInfo = session.GetInvItemByType(iconInfo.type);
	elseif invenItemInfo.type ~= iconInfo.type then
		return;
	end

	if invenItemInfo == nil then
		if iconInfo.category == 'Item' then
			icon:SetColorTone("FFFF0000");
			icon:SetText('0', 'quickiconfont', 'right', 'bottom', -2, 1);
		end
		return;
	end

	local itemobj = GetIES(invenItemInfo:GetObject());
	if TRY_TO_USE_WARP_ITEM(invenItemInfo, itemobj) == 1 then
		return;
	end
		
	if invenItemInfo.count == 0 then
		icon:SetColorTone("FFFF0000");
		icon:SetText(invenItemInfo.count, 'quickiconfont', 'right', 'bottom', -2, 1);
		return;
	end
		
	if true == BEING_TRADING_STATE() then
		return;
	end

	local invItemAllowReopen = ''
	if itemobj ~= nil then
		invItemAllowReopen = TryGetProp(itemobj, 'AllowReopen')
	end

	local groupName = itemobj.ItemType;
	local gachaCubeFrame = ui.GetFrame('gacha_cube')
	if groupName == 'Consume' and gachaCubeFrame ~= nil and gachaCubeFrame:IsVisible() == 1 and invItemAllowReopen == 'YES' then
		return
	end

	ICON_USE(icon);
end

function QUICKSLOTNEXPBAR_ICON_COUNT(frame, icon, argStr, argNum)
	icon:SetText(argNum, 'quickiconfont', 'right', 'bottom', -2, 1);
end

function QUICKSLOTNEXPBAR_SLOT_RBTNDOWN(frame, control, argStr, argNum)
	local slot	= tolua.cast(control, 'ui::CSlot');
	CLEAR_QUICKSLOT_SLOT(slot, 1, true);

end

function QUICKSLOTNEXPBAR_ON_DROP(frame, control, argStr, argNum)
	local liftIcon = ui.GetLiftIcon();
	local liftIconiconInfo = liftIcon:GetInfo();
	local iconParentFrame = liftIcon:GetTopParentFrame();
	local slot = tolua.cast(control, 'ui::CSlot');
	slot:SetEventScript(ui.RBUTTONUP, 'QUICKSLOTNEXPBAR_SLOT_USE');
	local iconCategory = 0;
	local iconType = 0;
	local iconGUID = "";
	if nil ~= liftIconiconInfo then
		iconCategory = liftIconiconInfo.category;
		iconType = liftIconiconInfo.type;
		iconGUID = liftIconiconInfo:GetIESID();
	
		local invItem = GET_PC_ITEM_BY_GUID(iconGUID);
		if invItem ~= nil then
			local obj = GetIES(invItem:GetObject());
			if obj ~= nil then
				local usable = TryGetProp(obj, "Usable")				
				local groupName = TryGetProp(obj, "GroupName");

				if usable ~= nil and groupName ~= "Premium" and groupName ~= "Material" and groupName ~= "PasteBait" then
					if usable == "NO" then
						local itemType = TryGetProp(obj, "ItemType");
						local classType = TryGetProp(obj, "ClassType");

						if itemType ~= nil and classType ~= nil then
							if itemType ~= "Equip" or (itemType == "Equip" and (classType == "Outer" or classType == "SpecialCostume")) then
								return;
							end
						else
							return;
						end
					end
				end
			end
		end
	end

	if iconParentFrame:GetName() == 'quickslotnexpbar' then
		local popSlotObj = liftIcon:GetParent();
		if popSlotObj:GetName() ~=  slot:GetName() then
			local popSlot = tolua.cast(popSlotObj, "ui::CSlot");
			local oldIcon = slot:GetIcon();
			if oldIcon ~= nil then
				local iconInfo = oldIcon:GetInfo();
				if iconInfo.imageName == "None" then
					oldIcon = nil;
				end
			end
			local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');
			if sklCnt > 0 and sklCnt >= slot:GetSlotIndex() then
				return;
			end
			QUICKSLOTNEXPBAR_SETICON(popSlot, oldIcon, 1, false);
		end
	elseif iconParentFrame:GetName() == 'status' then
		STATUS_EQUIP_SLOT_SET(iconParentFrame);
		return;
	end

	QUICKSLOTNEXPBAR_NEW_SETICON(slot, iconCategory, iconType, iconGUID);
end

function QUICKSLOTNEXPBAR_NEW_SETICON(slot, category, type, guid)
	SET_QUICK_SLOT(slot, category, type, guid, 1, true);
end

function QUICKSLOTNEXPBAR_SETICON(slot, icon, makeLog, sendSavePacket)
	if icon  ~=  nil then
		local iconInfo = icon:GetInfo();
		SET_QUICK_SLOT(slot, iconInfo.category, iconInfo.type, iconInfo:GetIESID(), makeLog, sendSavePacket);
	else
		CLEAR_QUICKSLOT_SLOT(slot, makeLog, sendSavePacket);
	end

end

function CLEAR_QUICKSLOT_SLOT(slot, makeLog, sendSavePacket)
	slot:ReleaseBlink();
	slot:ClearIcon();
	local sendPacket = 1;
	if sendSavePacket == false then
		sendPacket = 0;
	end

	quickslot.SetInfo(slot:GetSlotIndex(), 'None', 0, '0');
	QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);

end

function INIT_QUICKSLOT_SLOT(slot, icon)

	icon:SetOnCoolTimeEndScp('ICON_ON_COOLTIMEEND');
	icon:SetDumpScp('QUICKSLOTNEXPBAR_DUMPICON');
	slot:SetEventScript(ui.RBUTTONUP, 'QUICKSLOTNEXPBAR_SLOT_USE');

end

function QUICKSLOT_GET_EMPTY_SLOT(frame)
	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local slot = frame:GetChildRecursively("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		local icon = slot:GetIcon();

		if icon == nil then
			return slot;
		end

		local iconInfo = icon:GetInfo();
		if iconInfo.category == "None" then
			return slot;
		end
	end

	return nil;
end

function QUICKSLOT_REGISTER_Skill(frame, msg, type, index)
	QUICKSLOT_REGISTER(frame, type, index, "Skill");

	local joystickQuickFrame = ui.GetFrame('joystickquickslot');
	QUICKSLOT_REGISTER(joystickQuickFrame, type, index, "Skill");
end

function QUICKSLOT_REGISTER_Item(frame, msg, type, index)
	QUICKSLOT_REGISTER(frame, type, index, "Item");

	local joystickQuickFrame = ui.GetFrame('joystickquickslot');
	QUICKSLOT_REGISTER(joystickQuickFrame, type, index, "Item");
end

function GET_SLOT_BY_INDEX(frame, index)
	return GET_CHILD_RECURSIVELY(frame, "slot"..index, "ui::CSlot");
end

function QUICKSLOT_REGISTER(frame, type, index, idSpace)

	local slot = nil;
	if index == -1 then
		slot = QUICKSLOT_GET_EMPTY_SLOT(frame);
	else
		slot = GET_SLOT_BY_INDEX(frame, index);
	end

	if slot == nil then
		return;
	end

	SET_QUICK_SLOT(slot, idSpace, type, "", 0, true);

	if idSpace == "Skill" then
		QUICKSLOTNEXPBAR_SKILL_NOTICE(frame, slot, type);
	end
end

function QUICKSLOTNEXPBAR_SKILL_NOTICE(frame, slot, type)

	local text = "None";
	local selectedSlot = nil;
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slotChild = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");

		if slotChild:GetName() == slot:GetName() then
			local slotString 	= 'QuickSlotExecute'..(i+1);
			text 			= hotKeyTable.GetHotKeyString(slotString);
			selectedSlot = slotChild;
			break;
		end
	end

	NOTICE_SKILL_USE(type, text, selectedSlot);
end

function QUICKSLOTNEXPBAR_DUMPICON(frame, control, argStr, argNum)

	local icon = AUTO_CAST(control);
	local slot = GET_PARENT(icon);
	CLEAR_QUICKSLOT_SLOT(slot, 0, true);

end

function QUICKSLOTNEXPBAR_EXECUTE(slotIndex)

	local chatFrame = ui.GetFrame("chat");
	if chatFrame ~= nil then
	if chatFrame:IsVisible() == 1 then
		return;
	end
	end

	local restFrame = ui.GetFrame('restquickslot')
	if restFrame ~= nil and restFrame:IsVisible() == 1 then
		REST_SLOT_USE(restFrame, slotIndex);
		return;
	end	
	
	local quickslotFrame = ui.GetFrame('quickslotnexpbar');
    if quickslotFrame ~= nil and quickslotFrame:IsVisible() == 0 then
        local monsterquickslot = ui.GetFrame('monsterquickslot');
        if monsterquickslot ~= nil and monsterquickslot:IsVisible() == 1 then
            quickslotFrame = monsterquickslot;
        end
    end

	local slot = GET_CHILD_RECURSIVELY(quickslotFrame, "slot"..slotIndex+1, "ui::CSlot");
	QUICKSLOTNEXPBAR_SLOT_USE(quickSlotFrame, slot, 'None', 0);	

end

function QUICKSLOTNEXPBAR_ON_ENABLE(frame, control, argStr, argNum)
	local slot = tolua.cast(control, 'ui::CSlot');
	local iconPt = slot:GetIcon();
	if iconPt  ~=  nil then
		local icon = tolua.cast(iconPt, 'ui::CIcon');

		local iconInfo = icon:GetInfo();

		local x = object:GetGlobalX();
		local y = object:GetGlobalY();

		local imageItem = ui.CreateIImageItem("IconOnEnableItem", x, y);
		imageItem:SetImage(iconInfo.imageName);
		imageItem:SetScale(3.0, 3.0);

		imageItem:SetLifeTime(1.0);
		imageItem:SetAngleSpd(5.0);
		imageItem:SetScaleDest(0.1, 0.1);
		imageItem:SetAlphaBlendDest(0.1);
		imageItem:SetMoveDest(x, y);
	end
end

function QUICKSLOT_ADD(frame, ctrl, argStr, argNum)
	local curCnt = quickslot.GetActiveSlotCnt();
	
	if curCnt < 40 then
		curCnt = curCnt + 10;
	end

	curCnt = QUICKSLOT_REFRESH(curCnt);

	quickslot.SetActiveSlotCnt(curCnt);
end

function QUICKSLOT_REFRESH(curCnt)
	if curCnt < 20 or curCnt > 40 then
		curCnt = 20;
	end

	if curCnt % 10 ~= 0 then
		curCnt = 20;
	end

	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local slot 			= QUICKSLOTNEXPBAR_Frame:GetChild("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		if i < curCnt then
			slot:ShowWindow(1);
		else
			slot:ShowWindow(0);
		end		
	end

	local add = QUICKSLOTNEXPBAR_Frame:GetChild("slot_add");
	if curCnt >= 40 then
		add:SetEnable(0);
	else
		add:SetEnable(1);
	end
	local del = QUICKSLOTNEXPBAR_Frame:GetChild("slot_del");	
	if curCnt <= 20 then		
		del:SetEnable(0);
	else
		del:SetEnable(1);
	end

	return curCnt;
end

function QUICKSLOT_DEL(frame, ctrl, argStr, argNum)
	local curCnt = quickslot.GetActiveSlotCnt();
	
	if curCnt > 20 then
		curCnt = curCnt - 10;
	end

	curCnt = QUICKSLOT_REFRESH(curCnt);	
	quickslot.SetActiveSlotCnt(curCnt);
end

function QUICKSLOT_SET_LOCKSTATE(frame, isLock)

	local slot_lock = GET_CHILD(frame, "slot_lock");
	slot_lock:SetValue(isLock);

	local maskImage = "None";
	local ableDragDrop = 1;
	if isLock == 1 then
		slot_lock:SetTextTooltip(ScpArgMsg("QuickSlotLockOff"));
		maskImage = "slot_lock_frame";
		slot_lock:SetImage("button_lock_disable");
		ableDragDrop = 0;
	else
		slot_lock:SetTextTooltip(ScpArgMsg("QuickSlotLockOn"));
		slot_lock:SetImage("button_lock");		
	end

	for i=1, 40 do
		local slotChild = GET_CHILD(frame, "slot"..i, "ui::CSlot");
		slotChild:EnableDrop(ableDragDrop);
		slotChild:EnableDrag(ableDragDrop);
		slotChild:SetFrontImage(maskImage);
	end

end

function QUICKSLOT_LOCK(frame, ctrl, argStr, argNum)
	tolua.cast(ctrl, "ui::CButton");

	local btnValue = ctrl:GetValue();
	if btnValue == 0 then
		btnValue = 1;
	else
		btnValue = 0;
	end

	QUICKSLOT_SET_LOCKSTATE(frame, btnValue);
	
	frame:Invalidate();
	
	quickslot.SetLockState(btnValue);
	ui.UpdateVisibleToolTips();
end


function SET_QUICKSLOT_TOOLSKILL(slot)

	local obj = GET_SLOT_SKILL_OBJ(slot);
	if obj == nil then
		return;
	end

	local toolProp = geSkillTable.GetToolProp(obj.ClassID);
	if toolProp == nil then
		return;
	end

	if false == toolProp.useToggleEffectByCond then
		return;
	end

	slot:RunUpdateScript("TOGGLE_EFT_UPDATE");

end

function TOGGLE_EFT_UPDATE(slot)
	local obj = GET_SLOT_SKILL_OBJ(slot);
	if obj == nil then
		return 0;
	end

	local toolProp = geSkillTable.GetToolProp(obj.ClassID);
	if toolProp == nil then
		return 0;
	end

	if false == toolProp.useToggleEffectByCond then
		return 0;
	end

	local d = geClientSkill.GetCondSkillIndex(obj.ClassID);
	if d > 0 then
		slot:PlayUIEffect("I_sys_item_slot_loop", 2.2, "ToolSkillToggle");
	else
		slot:StopUIEffect("ToolSkillToggle", true, 0.0);
	end

	return 1;
end

function QUICKSLOTNEXPBAR_MY_MONSTER_SKILL(isOn, monName, buffType)
	local frame= ui.GetFrame("quickslotnexpbar")
	
	if isOn == 1 then
		local monCls = GetClass("Monster", monName);
		local list = GetMonsterSkillList(monCls.ClassID);
		for i = 0, list:Count() - 1 do
			local sklName = list:Get(i);
			local sklCls = GetClass("Skill", sklName);
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			tolua.cast(slot, "ui::CSlot");	
			local icon = slot:GetIcon();
			if icon ~= nil then
				local iconInfo = icon:GetInfo();
				slot:SetUserValue('ICON_CATEGORY', iconInfo.category);
				slot:SetUserValue('ICON_TYPE', iconInfo.type);
			end
			CLEAR_SLOT_ITEM_INFO(slot);
			local slotString 	= 'QuickSlotExecute'..(i+1);
			local text 			= hotKeyTable.GetHotKeyString(slotString);
			slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', 'left', 'top', 2, 1);
			local type = sklCls.ClassID;
			local icon = CreateIcon(slot);
			local imageName = 'icon_' .. sklCls.Icon;
			icon:Set(imageName, "Skill", type, 0);
			icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_SKILL_COOLDOWN');
			icon:SetEnableUpdateScp('MONSTER_ICON_UPDATE_SKILL_ENABLE');
			icon:SetColorTone("FFFFFFFF");
			quickslot.OnSetSkillIcon(slot, type);
			SET_QUICKSLOT_OVERHEAT(slot);

			slot:EnableDrag(0);
		end

		local lastSlot = GET_CHILD_RECURSIVELY(frame, "slot"..list:Count() +1, "ui::CSlot");
		local icon = lastSlot:GetIcon();
		if icon ~= nil then
			local iconInfo = icon:GetInfo();
			lastSlot:SetUserValue('ICON_CATEGORY', iconInfo.category);
			lastSlot:SetUserValue('ICON_TYPE', iconInfo.type);
		end

		CLEAR_SLOT_ITEM_INFO(lastSlot);
		local icon = CreateIcon(lastSlot);
		local slotString 	= 'QuickSlotExecute'..(list:Count() +1);
		local text 			= hotKeyTable.GetHotKeyString(slotString);
		lastSlot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', 'left', 'top', 2, 1);
		icon:SetImage("druid_del_icon");		
		lastSlot:EnableDrag(0);
		SET_QUICKSLOT_OVERHEAT(lastSlot);
		frame:SetUserValue('SKL_MAX_CNT',list:Count() + 1)
		return;
	end

	local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');
	for i = 1, sklCnt do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i, "ui::CSlot");
		CLEAR_SLOT_ITEM_INFO(slot);	
		local slotString 	= 'QuickSlotExecute'..i;
		local text 			= hotKeyTable.GetHotKeyString(slotString);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', 'left', 'top', 2, 1);
		local cate = slot:GetUserValue('ICON_CATEGORY');
		if 'None' ~= cate then
			SET_QUICK_SLOT(slot, cate, slot:GetUserIValue('ICON_TYPE'),  "", 0, 0);
	end
		slot:SetUserValue('ICON_CATEGORY', 'None');
		slot:SetUserValue('ICON_TYPE', 0);
		SET_QUICKSLOT_OVERHEAT(slot)

end
	frame:SetUserValue('SKL_MAX_CNT',0)
end

-- ?ÑÏû¨ ?úÏÑ±?îÎêú QUICK ?¨Î°Ø?ãÏóê ?çÌïò??SlotNumber(?§Ï†ú ?¨Î°Ø Î≤àÌò∏Í∞Ä ?òÏñ¥???∏Ï? ?ïÏù∏
function CHECK_SLOT_ON_ACTIVEQUICKSLOTSET(frame, slotNumber)
	local curCnt = quickslot.GetActiveSlotCnt();
	if curCnt < MIN_QUICKSLOT_CNT then
		curCnt = MIN_QUICKSLOT_CNT;
	end

	-- ?ÑÏû¨ Active???¨Î°Ø??Ïπ¥Ïö¥?∞Î≥¥??SlotNumberÍ∞Ä ?ëÏúºÎ©?true
	if curCnt > slotNumber then
		return true;
	end

	return false;
end
function ON_REMOVE_SKILL(frame, msg, argStr, removeSkillID)
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
		local icon = slot:GetIcon();
		if icon ~= nil then			
			tolua.cast(icon, "ui::CIcon");			
			local iconInfo = icon:GetInfo();
			if iconInfo.category == 'Skill' and iconInfo.type == removeSkillID then			
				slot:ReleaseBlink();
				slot:ClearIcon();

				-- clear overheat
				local gauge = slot:GetSlotGauge();
				gauge:SetPoint(0, 0);				

				quickslot.SetInfo(slot:GetSlotIndex(), 'None', 0, '0');
			end
		end
	end
end