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
	addon:RegisterMsg('SPECIFIC_SKILL_GET', 'QUICKSLOTNEXPBAR_ON_MSG');
	
	addon:RegisterMsg('REGISTER_QUICK_SKILL', 'QUICKSLOT_REGISTER_Skill');
	addon:RegisterMsg('REGISTER_QUICK_ITEM', 'QUICKSLOT_REGISTER_Item');
	
	addon:RegisterMsg('INV_ITEM_ADD_FOR_QUICKSLOT', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('INV_ITEM_POST_REMOVE', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('INV_ITEM_CHANGE_COUNT', 'QUICKSLOTNEXPBAR_ON_MSG');
	
	addon:RegisterMsg('EQUIP_ITEM_LIST_GET', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('PC_PROPERTY_UPDATE_TO_QUICKSLOT', 'QUICKSLOTNEXPBAR_ON_MSG');
	addon:RegisterMsg('PET_SELECT', 'ON_PET_SELECT');
	
	addon:RegisterMsg('JUNGTAN_SLOT_UPDATE', 'JUNGTAN_SLOT_ON_MSG');
	addon:RegisterMsg('EXP_ORB_ITEM_ON', 'EXP_ORB_SLOT_ON_MSG');
	addon:RegisterMsg('EXP_ORB_ITEM_OFF', 'EXP_ORB_SLOT_ON_MSG');
	
	addon:RegisterMsg('TOGGLE_ITEM_SLOT_ON', 'TOGGLE_ITEM_SLOT_ON_MSG');
	addon:RegisterMsg('TOGGLE_ITEM_SLOT_OFF', 'TOGGLE_ITEM_SLOT_ON_MSG');
	
	addon:RegisterMsg('QUICK_SLOT_LOCK_STATE', 'SET_QUICK_SLOT_LOCK_STATE');
	addon:RegisterMsg('QUICKSLOT_MONSTER_RESET_COOLDOWN', 'QUICKSLOTNEXPBAR_MY_MONSTER_SKILL_RESET_COOLDOWN');
	
	addon:RegisterMsg('RESET_ABILITY_ACTIVE', 'QUICKSLOTNEXPBAR_ON_MSG');
    addon:RegisterMsg('RESET_ALL_SKILL', 'CLEAR_ALL_SKILL_QUICKSLOTBAR');

	addon:RegisterMsg('DELETE_QUICK_SKILL', 'DELETE_SKILLICON_QUICKSLOTBAR');
	addon:RegisterMsg("DELETE_SPECIFIC_SKILL", 'DELETE_SKILLICON_QUICKSLOTBAR');
	
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_QUICKSLOT_OVERHEAT");
	timer:Start(0.3);
	
	QUICKSLOT_TOGGLE_ITEM_LIST={}
	
end

local function quickslot_item_amount_refresh(ies_id, class_id)
    if ies_id == nil then return end
    local frame = ui.GetFrame('quickslotnexpbar')
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i)
        if quickSlotInfo:GetIESID() == ies_id then
            local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot")
			if slot ~= nil then
                SET_QUICK_SLOT(frame, slot, quickSlotInfo.category, quickSlotInfo.type, quickSlotInfo:GetIESID(), 0, false, false)
            end
		elseif class_id ~= nil and quickSlotInfo:GetClassID() == tonumber(class_id) then
            quickSlotInfo:SetIESID(ies_id)
            local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot")
			if slot ~= nil then
                SET_QUICK_SLOT(frame, slot, quickSlotInfo.category, quickSlotInfo.type, quickSlotInfo:GetIESID(), 0, false, false)
            end
        end
	end

    frame = ui.GetFrame('joystickquickslot')
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i)
        if quickSlotInfo:GetIESID() == ies_id then
            local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot")
			if slot ~= nil then
                SET_QUICK_SLOT(frame, slot, quickSlotInfo.category, quickSlotInfo.type, quickSlotInfo:GetIESID(), 0, false, false)
            end
		elseif class_id ~= nil and quickSlotInfo:GetClassID() == tonumber(class_id) then
            quickSlotInfo:SetIESID(ies_id)
            local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot")
			if slot ~= nil then
                SET_QUICK_SLOT(frame, slot, quickSlotInfo.category, quickSlotInfo.type, quickSlotInfo:GetIESID(), 0, false, false)
            end
        end
	end
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

--토글
function TOGGLE_ITEM_SLOT_ON_MSG(frame, msg, argstr, argnum)
	if msg == "TOGGLE_ITEM_SLOT_ON" then
		QUICKSLOT_TOGGLE_ITEM_LIST[argnum] = 1;
		imcSound.PlaySoundEvent('sys_atk_booster_on');
	elseif msg == "TOGGLE_ITEM_SLOT_OFF" then
		QUICKSLOT_TOGGLE_ITEM_LIST[argnum] = nil;
		imcSound.PlaySoundEvent('sys_booster_off');
	end

	local cnt = 0;
	for k, v in pairs(QUICKSLOT_TOGGLE_ITEM_LIST) do
		cnt = cnt + 1;
	end
	
	if cnt > 0 then
		frame:RunUpdateScript("UPDATE_QUICKSLOT_TOGGLE_ITEM", 1.0);
	else
		frame:StopUpdateScript("UPDATE_QUICKSLOT_TOGGLE_ITEM");
	end
end

--업데이트
function UPDATE_QUICKSLOT_TOGGLE_ITEM(frame)
	for k, v in pairs(QUICKSLOT_TOGGLE_ITEM_LIST) do
		PLAY_QUICKSLOT_UIEFFECT(frame, k);
	end
	return 1;
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
		local timer = GET_CHILD(frame, "jungtandefti mer", "ui::CAddOnTimer");
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
					-- SLOT 이 활성화 상태일때만 그린다.
					if CHECK_SLOT_ON_ACTIVEQUICKSLOTSET(frame, i) == true then
						-- 스케일이 너무 크게 나와서 조금 줄임. 
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

function _UPDATE_SLOT_OVERHEAT(slot, obj)
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
	if skl == nil then
		return;
	end

	skl = GetIES(skl:GetObject());
	
	local overHeatCount = skl.SklUseOverHeat;
	local sklProp = geSkillTable.Get(obj.ClassName);
    if sklProp ~= nil then
        overHeatCount = sklProp:GetOverHeatCnt();
    end
	
	local curHeat = session.GetSklOverHeat(sklType);
	local resetTime = session.GetSklOverHeatResetTime(sklType);
	local gauge = slot:GetSlotGauge();
	gauge:SetCellPoint(1);

	local count = 0;
	if resetTime ~= 0 and curHeat > 0 then
		count = math.ceil(curHeat/resetTime) - 1;
	end
	gauge:SetPoint(count, overHeatCount);
	slot:InvalidateGauge();
end

function UPDATE_SLOT_OVERHEAT(slot)
	local obj = GET_SLOT_SKILL_OBJ(slot);
	_UPDATE_SLOT_OVERHEAT(slot, obj)
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

function CLEAR_ALL_SKILL_QUICKSLOTBAR()    
    local frame = ui.GetFrame('quickslotnexpbar')
    for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot")
		local icon = slot:GetIcon()
		if icon ~= nil then
		    tolua.cast(icon, "ui::CIcon")
            local skill_id = icon:GetTooltipNumArg()
            if skill_id ~= 0 and GetClassString('Skill', skill_id, 'Icon') ~= 'None' then
                icon:SetTooltipNumArg(0)
                slot:ClearIcon()
                QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
                SET_QUICKSLOT_OVERHEAT(slot)            
            end
		end
	end

    frame = ui.GetFrame('joystickquickslot')
    for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot")
		local icon = slot:GetIcon()
		if icon ~= nil then
		    tolua.cast(icon, "ui::CIcon")
            local skill_id = icon:GetTooltipNumArg()
            if skill_id ~= 0 and GetClassString('Skill', skill_id, 'Icon') ~= 'None' then
                icon:SetTooltipNumArg(0)
                slot:ClearIcon()
                QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
                SET_QUICKSLOT_OVERHEAT(slot)            
            end
		end
	end
end

-- 기간제 아이템을 퀵슬롯에 등록하면 시간 표기
function SET_SLOT_LIFETIME_IMAGE(invItem, icon, slot, force_off)
	if invItem == nil or icon == nil or slot == nil then
		icon:SetDrawLifeTimeText(0);
		slot:SetFrontImage('None');
		return 0;
	end
	if force_off == nil then
		force_off = true;
	end

	local itemIES = GetIES(invItem:GetObject());
	if force_off ~= false and invItem.hasLifeTime == true and invItem.count > 0 then
		ICON_SET_ITEM_REMAIN_LIFETIME(icon);
		slot:SetFrontImage('clock_inven');
		local resultLifeTimeOver = IS_LIFETIME_OVER(itemIES);
		if resultLifeTimeOver == 1 then
			icon:SetColorTone("FFFF0000");	
		end
	elseif force_off == false or invItem.hasLifeTime == false or invItem.count == 0 then
		icon:SetDrawLifeTimeText(0);
		slot:SetFrontImage('None');
		if invItem.count == 0 then
			icon:SetColorTone("FFFF0000");	
		end
	end
end

function QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME(frame)
	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local slot = frame:GetChild("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		local slotString = 'QuickSlotExecute'..(i+1);
		local text = hotKeyTable.GetHotKeyString(slotString);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', ui.LEFT, ui.TOP, 2, 1);
		QUICKSLOT_MAKE_GAUGE(slot);
            end
		end

function QUICKSLOTNEXTBAR_UPDATE_ALL_SLOT()    
	local frame = ui.GetFrame('quickslotnexpbar');
	local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i); 
        if quickSlotInfo.type ~= 0 then
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
				local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot")
			    SET_QUICK_SLOT(frame, slot, quickSlotInfo.category, quickSlotInfo.type, quickSlotInfo:GetIESID(), 0, true, true);
		    end
		else
            local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
            tolua.cast(icon, "ui::CIcon")            
            slot:ClearIcon()                
            QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
            SET_QUICKSLOT_OVERHEAT(slot)            
        end        
	end
end

function SET_QUICK_SLOT(frame, slot, category, type, iesID, makeLog, sendSavePacket, isForeceRegister)
    if frame ~= nil and session.GetSkill(type) ~= nil and is_contain_skill_icon(frame, type) == true and isForeceRegister == false then        
        return 
	end

	local icon = CreateIcon(slot);
	local imageName = "";

	if category ~= 'Item' then
		icon:SetDrawLifeTimeText(0)
		slot:SetFrontImage('None')
	end

	if category == 'Action' then
		icon:SetColorTone("FFFFFFFF");
		icon:ClearText();
	elseif category == 'Skill' then
		local skl = session.GetSkill(type);
		if IS_NEED_CLEAR_SLOT(skl, type) == true then	
            if icon ~= nil then
                tolua.cast(icon, "ui::CIcon");
                icon:SetTooltipNumArg(0)
            end
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
	elseif category == 'Ability' then
		QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
		local abilClass = GetClassByType("Ability", type)
    	local abilIES = GetAbilityIESObject(GetMyPCObject(), abilClass.ClassName);
		if abilIES == nil or HAS_ABILITY_SKILL(abilClass.ClassName) == false then
			slot:ClearIcon();
			return
		end
		imageName = abilClass.Icon;
		icon:SetTooltipType("ability");
		icon:ClearText();
		SET_ABILITY_TOGGLE_COLOR(icon, type)
	elseif category == 'Companion' then
		local monClass = GetClassByType("Monster", type)
		imageName = monClass.Icon;
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_COMPANION_COOLDOWN');
		icon:SetColorTone("FFFFFFFF");
		icon:ClearText();
	elseif category == 'Item' then
		QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);	-- 퀵슬롯에 놓는 것이 아이템이면 게이지를 무조건 안보이게 함
		local itemIES = GetClassByType('Item', type);
		if itemIES ~= nil then		
			imageName = itemIES.Icon;
			
			local invenItemInfo = nil
			local equipItemHave = true

			-- 장착 아이템 특별관리 // Type이 아닌 iesID로만 찾으며, 장착 중이면 미보유 중으로 취급한다.
			if itemIES.ItemType == 'Equip' then
				if iesID == "" then
					equipItemHave = false
				end

				if session.GetInvItemByGuid(iesID) == nil or session.GetEquipItemByGuid(iesID) ~= nil then
					equipItemHave = false
				end
			end

			if iesID == "" then
				invenItemInfo = session.GetInvItemByType(type);
			else
				invenItemInfo = session.GetInvItemByGuid(iesID);
			end

			-- 시모니 스크롤이 아니고 기간제가 아닌 아이템 재검색
			if invenItemInfo == nil and itemIES.LifeTime == 0 then
				if IS_SKILL_SCROLL_ITEM(itemIES) == 0 and IS_CLEAR_SLOT_ITEM(itemIES) ~= true then
					invenItemInfo = session.GetInvItemByType(type);
				end
			end

			if equipItemHave == true and invenItemInfo ~= nil and invenItemInfo.type == math.floor(type) then
				itemIES = GetIES(invenItemInfo:GetObject());
				imageName = GET_ITEM_ICON_IMAGE(itemIES);
				icon:SetEnableUpdateScp('None');

				if itemIES.MaxStack > 0 or itemIES.GroupName == "Material" then
					if itemIES.MaxStack > 1 then -- 개수는 스택형 아이템만 표시해주자
						icon:SetText(invenItemInfo.count, 'quickiconfont', ui.RIGHT, ui.BOTTOM, -2, 1);
					else
					  	icon:SetText(nil, 'quickiconfont', ui.RIGHT, ui.BOTTOM, -2, 1);
					end
					icon:SetColorTone("FFFFFFFF");
				end

				tolua.cast(icon, "ui::CIcon");
				local iconInfo = icon:GetInfo();
				iconInfo.count = invenItemInfo.count;

				if IS_SKILL_SCROLL_ITEM(itemIES) == 1 then
					icon:SetUserValue("IS_SCROLL","YES")
				else
					icon:SetUserValue("IS_SCROLL","NO")
				end
			else
				-- 해당 아이템이 인벤토리에 없을 경우 
				if IS_CLEAR_SLOT_ITEM(itemIES) then
					-- slot을 초기화할 아이템이면 slot clear
					CLEAR_QUICKSLOT_SLOT(slot);
					return;
				else
					imageName = GET_ITEM_ICON_IMAGE(itemIES);
					icon:SetColorTone("FFFF0000");
					icon:SetText(0, 'quickiconfont', ui.RIGHT, ui.BOTTOM, -2, 1);
					SET_SLOT_LIFETIME_IMAGE(invenItemInfo, icon, slot, false);
					icon:SetEnableUpdateScp('None');
				end			
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

		slot:SetPosTooltip(0, 0);
		if category == 'Item' then
			icon:SetTooltipType('wholeitem');
			
			local invItem = nil

			if iesID == '0' or iesID == "" then
				invItem = session.GetInvItemByType(type);
			else
				invItem = session.GetInvItemByGuid(iesID);
			end

			if invItem ~= nil and invItem.type == type then
				iesID = invItem:GetIESID();
			end

			if invItem ~= nil then
				icon:Set(imageName, 'Item', invItem.type, invItem.invIndex, invItem:GetIESID(), invItem.count);

				local result = CHECK_EQUIPABLE(invItem.type);
				icon:SetEnable(1);
				icon:SetEnableUpdateScp('None');
				if result ~= "NOEQUIP" then
					if result == 'OK' then
						icon:SetColorTone("FFFFFFFF");
					else
						icon:SetColorTone("FFFF0000");
					end
				end
			
				SET_SLOT_LIFETIME_IMAGE(invItem, icon, slot);
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
			icon:SetTooltipStrArg("quickslot");
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


		local icon = slot:GetIcon()
		if icon ~= nil then   
		quickslot.SetInfo(slot:GetSlotIndex(), category, type, iesID);
		icon:SetDumpArgNum(slot:GetSlotIndex());
        end
	else
		slot:EnableDrag(0);
	end

	if category == 'Skill' then
		SET_QUICKSLOT_OVERHEAT(slot);
		SET_QUICKSLOT_TOOLSKILL(slot);
	end    
end

function SET_MON_QUICK_SLOT(frame, slot, category, type)   
	if frame ~= nil and session.GetSkill(type) ~= nil and is_contain_skill_icon(frame, type) == true and isForeceRegister == false then
        return 
	end
	local flag = 0
	if slot:GetIcon() == nil then
		flag = 1
	end
	local icon = CreateIcon(slot);
	
	if icon ~= nil then
		local iconInfo = icon:GetInfo();
		slot:SetUserValue('ICON_CATEGORY', iconInfo:GetCategory());
		slot:SetUserValue('ICON_TYPE', iconInfo.type);
		icon:SetTooltipType("")
	end

	local imageName = "";

	local skl = session.GetSkill(type);
	if IS_NEED_CLEAR_SLOT(skl, type) == true then	
		if icon ~= nil then
			tolua.cast(icon, "ui::CIcon");
			icon:SetTooltipNumArg(0)
		end
		slot:ClearIcon();
		QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
		return;
	end
	imageName = 'icon_' .. GetClassString('Skill', type, 'Icon');
	icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_SKILL_COOLDOWN');
	icon:SetEnableUpdateScp('MONSTER_ICON_UPDATE_SKILL_ENABLE');
	icon:SetColorTone("FFFFFFFF");
	icon:ClearText();
	quickslot.OnSetSkillIcon(slot, type);
	
	if imageName ~= "" then

		icon:Set(imageName, category, type, 0);
		
		INIT_QUICKSLOT_SLOT(slot, icon);
		local icon = slot:GetIcon()
		if icon ~= nil then   
			if flag == 1 then
				quickslot.SetInfo(slot:GetSlotIndex(), category, type, "");            
			end
		    icon:SetDumpArgNum(slot:GetSlotIndex());
        end
	end
	slot:EnableDrag(0);
	slot:EnableDrop(0);
	SET_QUICKSLOT_OVERHEAT(slot);
end

function QUICKSLOTNEXPBAR_ON_MSG(frame, msg, argStr, argNum)    
	local joystickquickslotFrame = ui.GetFrame('joystickquickslot');
	JOYSTICK_QUICKSLOT_ON_MSG(joystickquickslotFrame, msg, argStr, argNum)
		
	local skillList = session.GetSkillList();
	local skillCount = skillList:Count();
	local MySession = session.GetMyHandle();
	local MyJobNum = info.GetJob(MySession);
	local JobName = GetClassString('Job', MyJobNum, 'ClassName');

	if msg == 'GAME_START' then
		ON_PET_SELECT(frame);
	end

	if msg == 'QUICKSLOT_LIST_GET' or msg == 'GAME_START' or msg == 'EQUIP_ITEM_LIST_GET' or msg == 'PC_PROPERTY_UPDATE_TO_QUICKSLOT'
    then
		DebounceScript("QUICKSLOTNEXTBAR_UPDATE_ALL_SLOT", 0.1, 0);        
    elseif msg == 'INV_ITEM_CHANGE_COUNT' or msg == 'INV_ITEM_POST_REMOVE' then
        quickslot_item_amount_refresh(argStr)    
    elseif msg == 'INV_ITEM_ADD_FOR_QUICKSLOT' then
        -- argStr = iesID, argNum = classID
        quickslot_item_amount_refresh(argStr, argNum)
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
		quickslot.SetInfo(slot:GetSlotIndex(), iconInfo:GetCategory(), iconInfo.type, changeIndex);
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
						quickslot.SetInfo(slot:GetSlotIndex(), iconInfo:GetCategory(), iconInfo.type, iconInfo.ext);
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

	if ui.CheckHoldedUI() == true then
		return;
	end

	tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then
		return;
	end

	local iconInfo = icon:GetInfo();
	local joystickquickslotRestFrame = ui.GetFrame("joystickrestquickslot");
	if iconInfo:GetCategory() == 'Skill' and joystickquickslotRestFrame:IsVisible() == 0 then
		ICON_USE(icon);
		return;
	end

	if iconInfo:GetCategory() == 'Ability' and joystickquickslotRestFrame:IsVisible() == 0 then
		ICON_USE(icon);
		return;
	end

	if iconInfo:GetCategory() == 'Companion' and joystickquickslotRestFrame:IsVisible() == 0 then
		ICON_USE(icon);
		return;
	end
	
	if icon:GetStringColorTone() == "FFFF0000" then
		return;
	end

	local invenItemInfo = session.GetInvItem(iconInfo.ext);
	if invenItemInfo == nil then
		invenItemInfo = session.GetInvItemByType(iconInfo.type);
	elseif invenItemInfo.type ~= iconInfo.type then
		return;
	end

	if invenItemInfo == nil then
		if iconInfo:GetCategory() == 'Item' then
			icon:SetColorTone("FFFF0000");
			icon:SetText('0', 'quickiconfont', ui.RIGHT, ui.BOTTOM, -2, 1);
		end
		return;
	end

	local itemobj = GetIES(invenItemInfo:GetObject());
	if TRY_TO_USE_WARP_ITEM(invenItemInfo, itemobj) == 1 then
		return;
	end
		
	if invenItemInfo.count == 0 then
		icon:SetColorTone("FFFF0000");
		icon:SetText(invenItemInfo.count, 'quickiconfont', ui.RIGHT, ui.BOTTOM, -2, 1);
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
	icon:SetText(argNum, 'quickiconfont', ui.RIGHT, ui.BOTTOM, -2, 1);
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
		iconCategory = liftIconiconInfo:GetCategory();
		iconType = liftIconiconInfo.type;
		iconGUID = liftIconiconInfo:GetIESID();

		if iconGUID ~= '0' then		
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
                                    --GuildColony_soulCrystal
                                    local coolDownGroup = TryGetProp(obj, "CoolDownGroup");
                                    if coolDownGroup ~= "GuildColony_soulCrystal" then
                                        return;
                                    end
								end
							else
								return;
							end
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
				if iconInfo:GetImageName() == "None" then
					oldIcon = nil;
				end
			end
			local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');
			if sklCnt > 0 and sklCnt >= slot:GetSlotIndex() then
				return;
			end
			--옛날거 등록
			QUICKSLOTNEXPBAR_SETICON(popSlot, oldIcon, 1, false);
            local joystickFrame = ui.GetFrame("joystickquickslot");
		    QUICKSLOT_REGISTER(joystickFrame, iconType, slot:GetSlotIndex() + 1, iconCategory, true);
		end
	elseif iconParentFrame:GetName() == 'status' then
		STATUS_EQUIP_SLOT_SET(iconParentFrame);
		return;
	elseif iconParentFrame:GetName() == "skillability" then
		local joystickFrame = ui.GetFrame("joystickquickslot");
		QUICKSLOT_REGISTER(joystickFrame, iconType, slot:GetSlotIndex() + 1, iconCategory, true);        
	elseif iconParentFrame:GetName() == "companionlist" then
		local joystickFrame = ui.GetFrame("joystickquickslot");
		QUICKSLOT_REGISTER(joystickFrame, iconType, slot:GetSlotIndex() + 1, iconCategory, true); 
    else
        local joystickFrame = ui.GetFrame("joystickquickslot");
		QUICKSLOT_REGISTER(joystickFrame, iconType, slot:GetSlotIndex() + 1, iconCategory, true);        
	end

	--새거 등록
	QUICKSLOTNEXPBAR_NEW_SETICON(frame, slot, iconCategory, iconType, iconGUID);
    DebounceScript("JOYSTICK_QUICKSLOT_UPDATE_ALL_SLOT", 0.1);
end

-- 스킬창에서 스킬을 드랍하였다.
function QUICKSLOTNEXPBAR_NEW_SETICON(frame, slot, category, type, guid)
	SET_QUICK_SLOT(nil, slot, category, type, guid, 1, true, false);
end

function QUICKSLOTNEXPBAR_SETICON(slot, icon, makeLog, sendSavePacket)
	if icon  ~=  nil then
		local iconInfo = icon:GetInfo();
		SET_QUICK_SLOT(nil, slot, iconInfo:GetCategory(), iconInfo.type, iconInfo:GetIESID(), makeLog, sendSavePacket, false);
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

	if quickslot.GetLockState() == 0 then
		slot:EnableDrag(1);
		slot:EnableDrop(1);
	end
end

function INIT_QUICKSLOT_SLOT(slot, icon)
	icon:SetDumpScp('QUICKSLOTNEXPBAR_DUMPICON');
	slot:SetEventScript(ui.RBUTTONUP, 'QUICKSLOTNEXPBAR_SLOT_USE');
end

function is_contain_skill_icon(frame, type)        
    if type == 0 then        
        return true
    end
    if frame == nil then         
        return false 
    end
    for i = 0, MAX_QUICKSLOT_CNT-1 do
		local slot = frame:GetChildRecursively("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		
		if slot ~= nil then
			local icon = slot:GetIcon();        
			if icon ~= nil then
		   	 	if type == icon:GetTooltipNumArg() then
               	 	return true;
            	end
			end
		end
	end
	return false;
end

function QUICKSLOT_GET_EMPTY_SLOT(frame)
	if frame == nil or frame:IsVisible() == 0 then 
		return; 
	end

	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = frame:GetChildRecursively("slot"..i + 1);
		tolua.cast(slot, "ui::CSlot");

		local icon = slot:GetIcon();
		if icon == nil then
			return slot;
		end
        
		if icon ~= nil then
			local iconInfo = icon:GetInfo();        
			if iconInfo:GetCategory() == "None" then
				return slot;
			end
		end
	end

	return nil;
end

function QUICKSLOT_REGISTER_Skill(frame, msg, type, index)
	QUICKSLOT_REGISTER(frame, type, index, "Skill", false);

	local joystickQuickFrame = ui.GetFrame('joystickquickslot');
	QUICKSLOT_REGISTER(joystickQuickFrame, type, index, "Skill", false);
end

function QUICKSLOT_REGISTER_Item(frame, msg, type, index)
	QUICKSLOT_REGISTER(frame, type, index, "Item");

	local joystickQuickFrame = ui.GetFrame('joystickquickslot');
	QUICKSLOT_REGISTER(joystickQuickFrame, type, index, "Item", false);
end

function GET_SLOT_BY_INDEX(frame, index)
	return GET_CHILD_RECURSIVELY(frame, "slot"..index, "ui::CSlot");
end

function QUICKSLOT_REGISTER(frame, type, index, idSpace, isForceRegister)    
    if is_contain_skill_icon(frame, type) == true and isForceRegister == false then
		return;
    end

	local slot = nil;
	if index == -1 then
		slot = QUICKSLOT_GET_EMPTY_SLOT(frame);
	else
		slot = GET_SLOT_BY_INDEX(frame, index);
	end

	if slot == nil then
		return;
	end

	SET_QUICK_SLOT(frame, slot, idSpace, type, "", 0, true, isForceRegister);

	if idSpace == "Skill" and isForeceRegister == false then
		QUICKSLOTNEXPBAR_SKILL_NOTICE(frame, slot, type);
	end
end

function QUICKSLOTNEXPBAR_SKILL_NOTICE(frame, slot, type)

	local text = "None";
	local selectedSlot = nil;
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slotChild = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");

		if slotChild:GetName() == slot:GetName() then
			local slotString = 'QuickSlotExecute'..(i+1);
			text = hotKeyTable.GetHotKeyString(slotString);
			selectedSlot = slotChild;
			break;
		end
	end

	NOTICE_SKILL_USE(type, text, selectedSlot);
end

-- 아이콘 퀵슬롯 바깥으로 보낼때
function QUICKSLOTNEXPBAR_DUMPICON(frame, control, argStr, argNum)
	local icon = AUTO_CAST(control);
	local slot = GET_PARENT(icon);
	CLEAR_QUICKSLOT_SLOT(slot, 0, true);
	
	if frame:GetParent():GetName() == "quickslotnexpbar" then
		local otherFrame = ui.GetFrame("joystickquickslot");
		if otherFrame ~= nil then
			local otherSlot = GET_CHILD_RECURSIVELY(otherFrame, frame:GetName(), "ui::CSlot");
			if otherSlot ~= nil then
				CLEAR_QUICKSLOT_SLOT(otherSlot, 0, true);
			end
		end	
	else
		local otherFrame = ui.GetFrame("quickslotnexpbar");
		if otherFrame ~= nil then
			local otherSlot = GET_CHILD_RECURSIVELY(otherFrame, frame:GetName(), "ui::CSlot");
			if otherSlot ~= nil then
				CLEAR_QUICKSLOT_SLOT(otherSlot, 0, true);
			end
		end	
	end 
end

function QUICKSLOTNEXPBAR_EXECUTE(slotIndex)
	if camera.IsCameraWorkingMode() == true then
		return;
	end

	local chatFrame = ui.GetFrame("chat");
	if chatFrame ~= nil then
		if chatFrame:IsVisible() == 1 then
			return;
		end
	end

	local flutingFrame = ui.GetFrame('fluting_keyboard')
	if flutingFrame ~= nil and flutingFrame:IsVisible() == 1 then
		FLUTING_SLOT_USE(flutingFrame, slotIndex);
		return;
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
		imageItem:SetImage(iconInfo:GetImageName());
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
		local slot = QUICKSLOTNEXPBAR_Frame:GetChild("slot"..i+1);
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

	for i = 1, 40 do
		local slotChild = GET_CHILD(frame, "slot"..i, "ui::CSlot");
        if ableDragDrop == 0 then
            slotChild:SetUserValue('PREV_DROP_VALUE', slotChild:IsEnableDrop());
            slotChild:SetUserValue('PREV_DRAG_VALUE', slotChild:IsEnableDrag());
		    slotChild:EnableDrop(ableDragDrop);
		    slotChild:EnableDrag(ableDragDrop);
        else
            local prevDropValue = slotChild:GetUserValue('PREV_DROP_VALUE');
            local prevDragValue = slotChild:GetUserValue('PREV_DRAG_VALUE');
            if prevDropValue ~= 'None' and prevDragValue ~= 'None' then            	
	            slotChild:EnableDrop(tonumber(prevDropValue));
	            slotChild:EnableDrag(tonumber(prevDragValue));
           	end
        end
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
function QUICKSLOTNEXPBAR_MY_MONSTER_SKILL_RESET_COOLDOWN(frame, msg, monName)
	frame:SetUserValue('MON_RESET_COOLDOWN', 1);
end

function QUICKSLOTNEXPBAR_MY_MONSTER_SKILL(isOn, monName, buffType)
	
	local frame= ui.GetFrame("quickslotnexpbar")
	-- ON 일때.
	if isOn == 1 then
		local icon = nil
		local monCls = GetClass("Monster", monName);
		local list = GetMonsterSkillList(monCls.ClassID);
		list:Add('Common_StateClear')
		for i = 0, list:Count() - 1 do
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			tolua.cast(slot, "ui::CSlot");
			local sklName = list:Get(i);
			local sklCls = GetClass("Skill", sklName);
			local type = sklCls.ClassID;
			SET_MON_QUICK_SLOT(frame, slot, "Skill", type)
			icon = slot:GetIcon();
			slot:SetEventScript(ui.RBUTTONUP, 'None');
		end
		
		if icon ~=nil and monName == "Colony_Siege_Tower" then
			icon:SetImage('Icon_common_get_off')
		end	

		for i = list:Count(), MAX_QUICKSLOT_CNT - 1 do
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			tolua.cast(slot, "ui::CSlot");	
			slot:EnableDrag(0);
			slot:EnableDrop(0);
			local icon = slot:GetIcon();
			if icon ~= nil and icon:GetInfo():GetCategory()=='Skill' then
				icon:SetEnable(0);
				icon:SetEnableUpdateScp('None');
			end
		end
		frame:SetUserValue('SKL_MAX_CNT',list:Count())
		frame:SetUserValue('MON_RESET_COOLDOWN', 0)

		return;
	end

	-- OFF 일때(복구)
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
		tolua.cast(slot, "ui::CSlot");	
		slot:EnableDrag(1);
		slot:EnableDrop(1);
		
		local icon = slot:GetIcon();
		if icon ~= nil and icon:GetInfo():GetCategory()=='Skill' then
			icon:SetEnable(1);
			icon:SetEnableUpdateScp('ICON_UPDATE_SKILL_ENABLE');
		end
	end

	local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');
	for i = 1, sklCnt do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i, "ui::CSlot");		
		CLEAR_QUICKSLOT_SLOT(slot);
		local slotString = 'QuickSlotExecute'..i;
		local text = hotKeyTable.GetHotKeyString(slotString);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', ui.LEFT, ui.TOP, 2, 1);
		local cate = slot:GetUserValue('ICON_CATEGORY');
		if 'None' ~= cate then
			SET_QUICK_SLOT(frame, slot, cate, slot:GetUserIValue('ICON_TYPE'),  "", 0, 0, true);
		end
		slot:SetUserValue('ICON_CATEGORY', 'None');
		slot:SetUserValue('ICON_TYPE', 0);
		SET_QUICKSLOT_OVERHEAT(slot);
	end
	frame:SetUserValue('SKL_MAX_CNT',0)
end

-- 현재 활성화된 QUICK 슬롯셋에 속하는 SlotNumber(실제 슬롯 번호가 넘어옴)인지 확인
function CHECK_SLOT_ON_ACTIVEQUICKSLOTSET(frame, slotNumber)
	local curCnt = quickslot.GetActiveSlotCnt();
	if curCnt < MIN_QUICKSLOT_CNT then
		curCnt = MIN_QUICKSLOT_CNT;
	end

	-- 현재 Active된 슬롯의 카운터보다 SlotNumber가 작으면 true
	if curCnt > slotNumber then
		return true;
	end

	return false;
end

function IS_NEED_CLEAR_SLOT(skl, type)
	local sklCls = GetClassByType('Skill', type);
	if TryGetProp(sklCls, 'CommonType', 'None') == 'None' and skl == nil then
		return true;
	end
	return false;
end

function QUICKSLOT_REQUEST_REFRESH(parent, ctrl)
	quickslot.RequestLoad();
	DISABLE_BUTTON_DOUBLECLICK('quickslotnexpbar', ctrl:GetName(), 1);
end

function QUICKSLOT_DRAW(curCnt)    
	QUICKSLOTNEXTBAR_UPDATE_ALL_SLOT();
	QUICKSLOT_REFRESH(curCnt);
end

function SET_ABILITY_TOGGLE_COLOR(icon, type)
	local frame = ui.GetFrame("quickslotnexpbar");
	local COLOR_TOGGLE_ABILITY_ON = frame:GetUserConfig("COLOR_TOGGLE_ABILITY_ON")
	local COLOR_TOGGLE_ABILITY_OFF = frame:GetUserConfig("COLOR_TOGGLE_ABILITY_OFF")
    local abilClass = GetClassByType("Ability", type)
    local abilIES = GetAbilityIESObject(GetMyPCObject(), abilClass.ClassName);
    if abilIES ~= nil then
        local isActive = TryGetProp(abilIES, "ActiveState");
        if isActive == nil then
            isActive = abilClass.ActiveState;
        end
        local colorTone = COLOR_TOGGLE_ABILITY_ON;
        if isActive ~= 1 then
            colorTone = COLOR_TOGGLE_ABILITY_OFF;
		end
        icon:SetColorTone(colorTone);
    end
end

function QUICKSLOT_TOGGLE_ABILITY(type)
    local abilCls = GetClassByType("Ability", type)
    TOGGLE_ABILITY(abilCls.ClassName)
end

function DELETE_SKILLICON_QUICKSLOTBAR(frame, msg, argStr, argNum)
	local frame = ui.GetFrame("quickslotnexpbar");
	local joystick_frame = ui.GetFrame("joystickquickslot");
	local isCheckQuickSlot = false; local isCheckJoyStickQuickSlot = false;
	local id = tonumber(argStr);
	if argNum == 1 then
		return;
	end
	
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		if frame ~= nil then 
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i + 1, "ui::CSlot");
			if slot ~= nil then
				local icon = slot:GetIcon();
				if icon ~= nil then
					tolua.cast(icon, "ui::CIcon");
					local skill_id = icon:GetTooltipNumArg();
					if skill_id == id then
						if skill_id ~= 0 and GetClassString('Skill', skill_id, 'Icon') ~= 'None' then
							icon:SetTooltipNumArg(0);
							slot:ClearIcon();
							QUICKSLOT_SET_GAUGE_VISIBLE(slot, 0);
							SET_QUICKSLOT_OVERHEAT(slot);
							CLEAR_QUICKSLOT_SLOT(slot, 0, true);
							isCheckQuickSlot = true;

							slot:Invalidate();
						end
					end
				end
			end
		end

		if joystick_frame ~= nil then
			local jslot = GET_CHILD_RECURSIVELY(joystick_frame, "slot"..i + 1, "ui::CSlot");
			if jslot ~= nil then
				local icon = jslot:GetIcon();
				if icon ~= nil then
					tolua.cast(icon, "ui::CIcon")
					local skill_id = icon:GetTooltipNumArg()
					if skill_id == id then
						if skill_id ~= 0 and GetClassString('Skill', skill_id, 'Icon') ~= 'None' then
							icon:SetTooltipNumArg(0)
							jslot:ClearIcon();
							QUICKSLOT_SET_GAUGE_VISIBLE(jslot, 0);
							SET_QUICKSLOT_OVERHEAT(jslot);
							CLEAR_QUICKSLOT_SLOT(jslot, 0, true);
							isCheckJoyStickQuickSlot = true; 

							jslot:Invalidate();       
						end
					end
				end
			end
		end

		if isCheckQuickSlot == true or isCheckJoyStickQuickSlot == true then
			isCheckQuickSlot = false;
			isCheckJoyStickQuickSlot = false;
			break;
		end
	end
end

function IS_CLEAR_SLOT_ITEM(ItemInfo)
	-- 퀵 슬롯 UI가 갱신될 때 해당 아이템을 인벤토리에서 가지고 있지 않을경우 slot을 초기화 해줄 아이템의 조건을 관리하는 함수

	if ItemInfo.GroupName == "ExpOrb" and ItemInfo.MaxStack == 1 then
		return true;
	end

	return false;
end