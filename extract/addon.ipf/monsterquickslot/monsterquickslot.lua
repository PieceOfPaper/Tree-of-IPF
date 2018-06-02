function MONSTERQUICKSLOT_ON_INIT(addon, frame)

end



function MONSTER_QUICKSLOT(isOn, monName, buffType, ableToUseSkill)

	local frame = ui.GetFrame("monsterquickslot");
	if isOn == 1 then
		ui.CloseFrame("quickslotnexpbar");

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
					SET_SLOT_SKILL(slot, sklCls);
					local slotString 	= 'QuickSlotExecute'.. (i+1);
					local hotKey = hotKeyTable.GetHotKeyString(slotString);	
					slot:SetText('{s14}{ol}{b}'..hotKey, 'count', 'left', 'top', 2, 1);
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
		local hotKey = hotKeyTable.GetHotKeyString(slotString);	
		lastSlot:SetText('{s14}{ol}{b}'..hotKey, 'count', 'left', 'top', 2, 1);

	else
		ui.OpenFrame("quickslotnexpbar");
		frame:ShowWindow(0);
	end
	

end

