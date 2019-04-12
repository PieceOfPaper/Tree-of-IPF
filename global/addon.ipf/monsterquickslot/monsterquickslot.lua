function MONSTERQUICKSLOT_ON_INIT(addon, frame)

end


function MONSTER_QUICKSLOT(isOn, monName, buffType, ableToUseSkill)

	local frame = ui.GetFrame("monsterquickslot");

	if isOn == 1 then

		local beforeframe = ui.GetFrame("quickslotnexpbar")
		
		if beforeframe:IsVisible() == 1 then
			beforeframe:ShowWindow(0)
			frame:SetUserValue("BEFORE_FRAME", "quickslotnexpbar");
		end


		local isjoystick = false;

		beforeframe = ui.GetFrame("joystickquickslot")
		
		if beforeframe:IsVisible() == 1 then
			beforeframe:ShowWindow(0)
			frame:SetUserValue("BEFORE_FRAME", "joystickquickslot");
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

					
					-- 이 땜빵을 어찌해아 하나? 제일 좋은건 hotkey_joystic.xml의 Key, PressedKey를 예쁘게 정리하는 것이다.
					hotKey = string.gsub(hotKey, "JOY_BTN_1", "X");
					hotKey = string.gsub(hotKey, "JOY_BTN_2", "A");
					hotKey = string.gsub(hotKey, "JOY_BTN_3", "Y");
					hotKey = string.gsub(hotKey, "JOY_BTN_4", "B");
					hotKey = string.gsub(hotKey, "JOY_BTN_5", "L1");
					
					slot:SetText('{s14}{ol}{b}'..hotKey, 'count', 'left', 'top', 2, 1);
					slot:EnableDrag(0);
				end
			end
		else
			slotset:SetColRow(1, 1);
			slotset:CreateSlots();
		end

		local lastSlot = slotset:GetSlotByIndex(slotset:GetSlotCount() - 1);
		local icon = CreateIcon(lastSlot);
		icon:SetImage("druid_del_icon");		
		local slotString 	= 'QuickSlotExecute'.. slotset:GetSlotCount();
		local hotKey = nil;

		if isjoystick == false then
			hotKey = hotKeyTable.GetHotKeyString(slotString, 0);	
		else				
			hotKey = hotKeyTable.GetHotKeyString(slotString, 1);	
		end

		hotKey = string.gsub(hotKey, "JOY_BTN_1", "X");
		hotKey = string.gsub(hotKey, "JOY_BTN_2", "A");
		hotKey = string.gsub(hotKey, "JOY_BTN_3", "Y");
		hotKey = string.gsub(hotKey, "JOY_BTN_4", "B");
		hotKey = string.gsub(hotKey, "JOY_BTN_5", "L1");

		lastSlot:SetText('{s14}{ol}{b}'..hotKey, 'count', 'left', 'top', 2, 1);
		lastSlot:EnableDrag(0);

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

