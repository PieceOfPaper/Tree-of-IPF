
function DURNOTIFY_ON_INIT(addon, frame)
	
	addon:RegisterOpenOnlyMsg('UPDATE_ITEM_REPAIR', 'DURNOTIFY_UPDATE');
	addon:RegisterOpenOnlyMsg('ITEM_PROP_UPDATE', 'DURNOTIFY_UPDATE');
	addon:RegisterOpenOnlyMsg('EQUIP_ITEM_LIST_GET', 'DURNOTIFY_UPDATE');
	addon:RegisterOpenOnlyMsg('MYPC_CHANGE_SHAPE', 'DURNOTIFY_UPDATE');
	addon:RegisterMsg('GAME_START', 'DURNOTIFY_ON_START');

end

function DURNOTIFY_OPEN(frame)
	DURNOTIFY_UPDATE(frame);
end

function DURNOTIFY_CLOSE(frame)

end

function DURNOTIFY_ON_START(frame)
	
	local initvalue = frame:GetValue()

	if initvalue == 0 then
		frame:SetValue(1)
	end


	DURNOTIFY_UPDATE(frame)
end

function DURNOTIFY_UPDATE(frame, notOpenFrame)

	if frame:IsVisible() == 0 then
		frame:ShowWindow(1);
	end

	local equiplist = session.GetEquipItemList()
	local slotSet = GET_CHILD_RECURSIVELY(frame, 'slotlist', 'ui::CSlotSet')
	slotSet:ClearIconAll();

	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		slot:ShowWindow(0);
	end

	local slotcnt = 0
	
	local nowvalue = frame:GetValue()
	local someflag = 1

	local reverseIndex = 8

	for i = 0, equiplist:Count() - 1 do
		local equipItem = equiplist:Element(i);
		local tempobj = equipItem:GetObject()
		if tempobj ~= nil then
			local obj = GetIES(tempobj);
		
			if IS_DUR_ZERO(obj) == true  then
				
				local slot = slotSet:GetSlotByIndex(reverseIndex - slotcnt)

				local icon = CreateIcon(slot);
				icon:Set(obj.Icon, 'Item', equipItem.type, reverseIndex - slotcnt, equipItem:GetIESID());
				icon:SetColorTone("FF990000");
				
				slotcnt = slotcnt + 1

				
				if someflag < 3 then	
					someflag = 3
				end

				slot:ShowWindow(1);
			elseif IS_DUR_UNDER_10PER(obj) == true  then
				local slot = slotSet:GetSlotByIndex(reverseIndex - slotcnt)

				local icon = CreateIcon(slot);
				icon:Set(obj.Icon, 'Item', equipItem.type, reverseIndex - slotcnt, equipItem:GetIESID());
				icon:SetColorTone("FF999900");
				
				slotcnt = slotcnt + 1

				if someflag < 2  then -- 깨진 템은 없으면서 처음 경고 템 뜰 경우
					someflag = 2
				end

				slot:ShowWindow(1);
			end
		else
			print('error! tempobj == nil')
		end
		
	end

	if someflag == 1 then
		frame:SetValue(1)
	elseif someflag == 2 and nowvalue < someflag then
		frame:SetValue(2)
		ui.SysMsg(ScpArgMsg('DurUnder30'));
	elseif someflag == 3 and nowvalue < someflag then
		frame:SetValue(3)
		ui.SysMsg(ScpArgMsg('DurUnder0'));
	end

	
end

function IS_DUR_UNDER_10PER(itemobj)

	if itemobj == nil then
		return false
	end

	local Itemtype = itemobj.ItemType

	if Itemtype == nil then
		print('If This message has appeared, please tell its ClassId to Young.',itemobj.ClassID)
		return false;
	else
		if itemobj.ItemType ~= 'Equip' then
			return false
		end
	end

	if item.IsNoneItem(itemobj.ClassID) == 0 and itemobj.Dur / itemobj.MaxDur < 0.3 and itemobj.MaxDur ~= -1 then
		return true
	end
	
	return false
end

function IS_DUR_ZERO(itemobj)

	if itemobj == nil then
		return false
	end

	local Itemtype = itemobj.ItemType

	if Itemtype == nil then
		print('If This message has appeared, please tell its ClassId to Young.',itemobj.ClassID)
		return false;
	else
		if itemobj.ItemType ~= 'Equip' then
			return false
		end
	end

	if item.IsNoneItem(itemobj.ClassID) == 0 and itemobj.Dur <= 0 and itemobj.MaxDur ~= -1 then
		return true
	end
	
	return false
end