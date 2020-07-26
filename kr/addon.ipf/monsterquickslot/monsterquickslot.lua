function MONSTERQUICKSLOT_ON_INIT(addon, frame)
	MONSTERQUICKSLOT_UPDATE_HOTKEYNAME(frame)
end

function MONSTER_QUICKSLOT(isOn, monName, buffType, ableToUseSkill)
	local frame = ui.GetFrame("monsterquickslot");
	if isOn == 1 then
		-- 라이칸스트로피 거나 쉐이프쉬프팅, 트랜스폼 ,서모닝이면
		-- monsterquickslot을 사용하지 않겠다.
		local monsterQuickslotNotUse = false;
		if buffType == 6012 or buffType == 6026 or buffType == 3038 then
			monsterQuickslotNotUse = true;
		end

		-- 기본 퀵슬롯
		local beforeframe = ui.GetFrame("quickslotnexpbar")
		if beforeframe:IsVisible() == 1 then
			frame:SetUserValue("BEFORE_FRAME", "quickslotnexpbar");
			if monsterQuickslotNotUse == true then
				QUICKSLOTNEXPBAR_MY_MONSTER_SKILL(isOn, monName, buffType)
				frame:SetUserValue('BUFFTYPE', buffType);
				return;
			end
			beforeframe:ShowWindow(0)
		end

		-- 조이패드 퀵슬롯
		local isjoystick = false;
		beforeframe = ui.GetFrame("joystickquickslot")
		if beforeframe:IsVisible() == 1 then
			frame:SetUserValue("BEFORE_FRAME", "joystickquickslot");
			if monsterQuickslotNotUse == true then
				JOYSTICK_QUICKSLOT_MY_MONSTER_SKILL(isOn, monName, buffType)
				frame:SetUserValue('BUFFTYPE', buffType);
				return;
			end
			beforeframe:ShowWindow(0)
			isjoystick = true;
		end

		frame:ShowWindow(1);

		local slotset = GET_CHILD(frame, "slotset", "ui::CSlotSet");
		for i = 0 , slotset:GetSlotCount() - 1 do
			local slot = slotset:GetSlotByIndex(i);
			CLEAR_SLOT_ITEM_INFO(slot);
		end		

		slotset:RemoveAllChild();
		if ableToUseSkill == 1 then
			local monCls = GetClass("Monster", monName);
			local list = GetMonsterSkillList(monCls.ClassID);
			slotset:SetColRow(list:Count() + 1, 1);
			slotset:CreateSlots();
		
			for i = 0, list:Count() - 1 do
				local sklName = list:Get(i);
				local sklCls = GetClass("Skill", sklName);
				local slot = slotset:GetSlotByIndex(i);
				if slot ~= nil then
					local type = sklCls.ClassID;
					local icon = CreateIcon(slot);
					local imageName = 'icon_' .. sklCls.Icon;
					icon:Set(imageName, "Skill", type, 0);
					local slotString 	= 'QuickSlotExecute'.. (i+1);
					local hotKey = nil

					if isjoystick == false then
						hotKey = hotKeyTable.GetHotKeyString(slotString, 0);	
					else				
						hotKey = hotKeyTable.GetHotKeyString(slotString, 1);	
					end

					-- monster quick slot에 cooltime 추가
					QUICKSLOT_MAKE_GAUGE(slot)
					QUICKSLOT_SET_GAUGE_VISIBLE(slot, 1)
					icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_SKILL_COOLDOWN');
					icon:SetEnableUpdateScp('MONSTER_ICON_UPDATE_SKILL_ENABLE');
					icon:SetColorTone("FFFFFFFF");
					icon:ClearText();
					quickslot.OnSetSkillIcon(slot, type);
					
					-- 이 땜빵을 어찌해아 하나? 제일 좋은건 hotkey_joystic.xml의 Key, PressedKey를 예쁘게 정리하는 것이다.
					hotKey = JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(true, hotKey);
					
					slot:SetText('{s14}{ol}{b}'..hotKey, 'count', ui.LEFT, ui.TOP, 2, 1);
					slot:EnableDrag(0);
				end
			end
		else
			slotset:SetColRow(1, 1);
			slotset:CreateSlots();
		end

		local lastSlot = slotset:GetSlotByIndex(slotset:GetSlotCount() - 1);
		local icon = CreateIcon(lastSlot);
		local lastSlotIconName = "druid_del_icon";
		if monName == "Colony_Siege_Tower" then
			lastSlotIconName = "Icon_common_get_off";
		end	
		icon:SetImage(lastSlotIconName);
		local slotString 	= 'QuickSlotExecute'.. slotset:GetSlotCount();
		local hotKey = nil;

		if isjoystick == false then
			hotKey = hotKeyTable.GetHotKeyString(slotString, 0);	
		else				
			hotKey = hotKeyTable.GetHotKeyString(slotString, 1);	
		end

		hotKey = JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(true, hotKey);

		lastSlot:SetText('{s14}{ol}{b}'..hotKey, 'count', ui.LEFT, ui.TOP, 2, 1);
		lastSlot:EnableDrag(0);
	else
		local beforeframename = frame:GetUserValue("BEFORE_FRAME");
		local preBuff = frame:GetUserIValue('BUFFTYPE');
		if preBuff == 6012 or preBuff == 6026 or preBuff == 3038 then
			if beforeframename == "joystickquickslot" then
				JOYSTICK_QUICKSLOT_MY_MONSTER_SKILL(isOn, monName, buffType);
				DebounceScript("JOYSTICK_QUICKSLOT_UPDATE_ALL_SLOT", 0.1);
			else
				QUICKSLOTNEXPBAR_MY_MONSTER_SKILL(isOn, monName, buffType);
				DebounceScript("QUICKSLOTNEXTBAR_UPDATE_ALL_SLOT", 0.1, 0);
			end
			frame:SetUserValue('BUFFTYPE', 0);
			return;
		end

		if beforeframename ~= "None" then
			ui.OpenFrame(beforeframename);
		else
			ui.OpenFrame("quickslotnexpbar");
		end
			
		frame:ShowWindow(0);
	end
end

function EXEC_INSTANT_QUICKSLOT(isOn)
	local frame = ui.GetFrame("monsterquickslot");
	if isOn == 1 then
		-- 기본 퀵슬롯
		local beforeframe = ui.GetFrame("quickslotnexpbar");
		if beforeframe:IsVisible() == 1 then
			frame:SetUserValue("BEFORE_FRAME", "quickslotnexpbar");
			beforeframe:ShowWindow(0)
		end

		-- 조이패드 퀵슬롯
		local isjoystick = false;
		beforeframe = ui.GetFrame("joystickquickslot");
		if beforeframe:IsVisible() == 1 then
			frame:SetUserValue("BEFORE_FRAME", "joystickquickslot");
			beforeframe:ShowWindow(0)
			isjoystick = true;
		end

		frame:ShowWindow(1);

		local slotset = GET_CHILD(frame, "slotset", "ui::CSlotSet");
		for i = 0 , slotset:GetSlotCount() - 1 do
			local slot = slotset:GetSlotByIndex(i);
			CLEAR_SLOT_ITEM_INFO(slot);
		end
		slotset:RemoveAllChild();

        local sklCount = geSummonControl.GetInstantSkillCount();        
        slotset:SetColRow(sklCount, 1);
		slotset:CreateSlots();

        for i = 0, sklCount - 1 do
            local sklID = geSummonControl.GetInstantSkillByIndex(i);
            local sklCls = GetClassByType('Skill', sklID);
            local slot = slotset:GetSlotByIndex(i);            
            if sklCls ~= nil and slot ~= nil then
                local type = sklID;
				local icon = CreateIcon(slot);
				local imageName = 'icon_' .. sklCls.Icon;
				icon:Set(imageName, "Skill", type, 0);

				local slotString = 'QuickSlotExecute'.. (i+1);
				local hotKey = nil;

				if isjoystick == false then
					hotKey = hotKeyTable.GetHotKeyString(slotString, 0);	
				else				
					hotKey = hotKeyTable.GetHotKeyString(slotString, 1);
				end

				-- monster quick slot에 cooltime 추가
				QUICKSLOT_MAKE_GAUGE(slot)
				QUICKSLOT_SET_GAUGE_VISIBLE(slot, 1)
				icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_SKILL_COOLDOWN');
				icon:SetEnableUpdateScp('MONSTER_ICON_UPDATE_SKILL_ENABLE');
				icon:SetColorTone("FFFFFFFF");
				icon:ClearText();
				quickslot.OnSetSkillIcon(slot, type);
					
				-- 이 땜빵을 어찌해아 하나? 제일 좋은건 hotkey_joystic.xml의 Key, PressedKey를 예쁘게 정리하는 것이다.
				hotKey = JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(true, hotKey);
					
				slot:SetText('{s14}{ol}{b}'..hotKey, 'count', ui.LEFT, ui.TOP, 2, 1);
				slot:EnableDrag(0);
            end
        end
	else
		local beforeframename = frame:GetUserValue("BEFORE_FRAME");
		if beforeframename ~= "None" then
			ui.OpenFrame(beforeframename);
		else
			ui.OpenFrame("quickslotnexpbar");
		end
		frame:ShowWindow(0);
	end
end

function MONSTERQUICKSLOT_UPDATE_HOTKEYNAME(frame)
	local slotset = GET_CHILD_RECURSIVELY(frame,"slotset")
	for i = 0, slotset:GetSlotCount() - 1 do
		local slot = slotset:GetChild("slot"..i+1)
		tolua.cast(slot, "ui::CSlot");
		local slotString = 'QuickSlotExecute'..(i + 1);
		local hotKey = nil;
		local controlmodeType = tonumber(config.GetXMLConfig("ControlMode"));
		if controlmodeType == 1 then
			hotKey = hotKeyTable.GetHotKeyString(slotString, 1);
		else
			hotKey = hotKeyTable.GetHotKeyString(slotString, 0);
		end
		-- 이 땜빵을 어찌해아 하나? 제일 좋은건 hotkey_joystic.xml의 Key, PressedKey를 예쁘게 정리하는 것이다.
		hotKey = JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(true, hotKey);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..hotKey, 'default', ui.LEFT, ui.TOP, 2, 1);
		QUICKSLOT_MAKE_GAUGE(slot);
	end
end