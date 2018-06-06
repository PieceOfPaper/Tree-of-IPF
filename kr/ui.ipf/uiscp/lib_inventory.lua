-- lib_inventory.lua

function GET_PC_ITEM_BY_GUID(guid)
	local invItem = session.GetInvItemByGuid(guid);
	if invItem ~= nil then
		return invItem, nil;
	end

	local eqpItem = session.GetEquipItemByGuid(guid);
	if eqpItem ~= nil then
		return eqpItem , 1;
	end
	return nil;

end

function GET_PC_ITEM_OBJ(itemType)

	local invItem = session.GetInvItemByType(itemType);
	if invItem ~= nil then
		return GetIES(invItem:GetObject());
	end

	local eqpItem = session.GetEquipItemByType(itemType);
	if eqpItem ~= nil then
		return GetIES(eqpItem:GetObject());
	end

	return GetClassByType("Item", itemType);

end

function GET_PC_ITEM_BY_TYPE(type)

	local invItem = session.GetInvItemByType(type);
	if invItem ~= nil then
		return invItem;
	end

	local eqpItem = session.GetEquipItemByType(type);
	if eqpItem ~= nil then
		return eqpItem;
	end
	return nil;

end

function GET_LIST_FUNC_VALUES(list, func, ...)

	local ret = 0;
	local index = list:Head();
	while 1 do
		if index == list:InvalidIndex() then
			break;
		end

		local item = list:Element(index);
		ret = ret + func(item, ...);
		index = list:Next(index);
	end

	return ret;
end

function GET_PC_ITEM_FUNC_VALUES(func, ...)

	local ret = 0;
	ret = ret + GET_LIST_FUNC_VALUES(session.GetInvItemList(), func, ...);
	ret = ret + GET_LIST_FUNC_VALUES(session.GetEquipItemList(), func, ...);
	return ret;

end

function GET_BY_INV_LIST(list, func, ...)

	local index = list:Head();
	while 1 do
		if index == list:InvalidIndex() then
			break;
		end

		local item = list:Element(index);
		if func(item, ...) > 0 then
			return item;
		end

		index = list:Next(index);
	end

	return nil;
end


function GET_PC_ITEM_BY_FUNC(func, ...)
	
	local ret = GET_BY_INV_LIST(session.GetEquipItemList(), func, ...);
	if ret ~= nil then
		return ret;
	end

	return GET_BY_INV_LIST(session.GetInvItemList(), func, ...);
	
end

function GET_EQP_ITEM_CNT(type)

	return GET_TOTAL_ITEM_CNT_LIST(type, session.GetEquipItemList());

end

function GET_TOTAL_ITEM_CNT(type)

	return GET_TOTAL_ITEM_CNT_LIST(type, session.GetInvItemList())
	+ GET_TOTAL_ITEM_CNT_LIST(type, session.GetEquipItemList());

end

function GET_TOTAL_ITEM_CNT_LIST(type, list)

	local cnt = 0;
	local index = list:Head();
	while 1 do
		if index == list:InvalidIndex() then
			break;
		end

		local item = list:Element(index);
		if item.type == type then
			cnt = cnt + 1;
		end

		index = list:Next(index);

	end

	return cnt;

end

function INV_APPLY_TO_ALL_SLOT(func, ...)

	for i = 1 , #SLOTSET_NAMELIST do

		local frame = ui.GetFrame("inventory");
		local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
		

		for typeNo = 1, #g_invenTypeStrList do
			local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
			local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
		local slotSet = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')	

		APPLY_TO_ALL_ITEM_SLOT(slotSet, func, ...);
		end;

		frame:Invalidate();
	end



end

function EQP_APPLY_TO_ALL_SLOT(func, ...)

	local frame = ui.GetFrame("inventory");
	local spotCount = item.GetEquipSpotCount() - 1;
	for i = 0 , spotCount do
		local spotName = item.GetEquipSpotName(i);
		if  spotName  ~=  nil  then
			local slot = GET_CHILD(frame, spotName, "ui::CSlot");
			if slot ~= nil then
				func(slot, ...);
			end
		end
	end

end

function PC_APPLY_TO_ALL_SLOT(func, ...)
	INV_APPLY_TO_ALL_SLOT(func, ...)
	EQP_APPLY_TO_ALL_SLOT(func, ...);
end

function PC_APPLY_TO_ALL_ITEM(func, ...)

	INV_APPLY_TO_ALL_SLOT(func, ...)
	
	local spotCount = item.GetEquipSpotCount() - 1;
	for i = 0 , spotCount do
		local spotName = item.GetEquipSpotName(i);
		if  spotName  ~=  nil  then
			local slot = GET_CHILD(frame, spotName, "ui::CSlot");
			if slot ~= nil then
				local item = GET_SLOT_ITEM(slot);
				if item ~= nil then
					func(item, ...);
				end
			end
		end
	end
end

function _CHECK_INVITEM_LV(invitem, clsId, lv)
	local obj = GetIES(invitem:GetObject());
	if clsId == obj.ClassID and TryGet(obj, "Level") >= lv then
		return invitem.count;
	end

	return 0;
end

function GET_PC_ITEM_BY_LEVEL(type, level)
	return GET_PC_ITEM_BY_FUNC(_CHECK_INVITEM_LV, type, level);
end

function GET_PC_ITEM_COUNT_BY_LEVEL(type, level)
	return GET_PC_ITEM_FUNC_VALUES(_CHECK_INVITEM_LV, type, level);
end

function _CHECK_IS_EQUIP(invItem)
	local obj = GetIES(invItem:GetObject());
	if IS_EQUIP(obj) then
		return 1;
	end

	return 0;
end

function GET_INV_EQUIP_ITEM_COUNT(type, level)
	return GET_LIST_FUNC_VALUES(session.GetInvItemList(), _CHECK_IS_EQUIP);
end

function _CHECK_INVITEM_UPGRADABLE(invItem)
	local obj = GetIES(invItem:GetObject());
	if IS_ITEM_UPGRADABLE(obj) then
		return 1;
	end

	return 0;
end

function GET_PC_UPGRDABLE_ITEM_COUNT(type)
	return GET_PC_ITEM_FUNC_VALUES(_CHECK_INVITEM_UPGRADABLE);
end

function _GET_PC_ITEMS_BY_FUNC(invItem, list, func, ...)
	if func(invItem, ...) > 0 then
		list[#list + 1] = invItem;
	end
end

function GET_PC_ITEMS_BY_FUNC(list, func, ...)
	PC_APPLY_TO_ALL_ITEM(_GET_PC_ITEMS_BY_FUNC, list, func, ...);
end

function GET_PC_UPGRADABLE_ITEMS(list)
	GET_PC_ITEMS_BY_FUNC(list, _CHECK_INVITEM_UPGRADABLE);
end

function _ADD_BY_LEVEL(slot, type, level, itemList)
	local invitem = GET_SLOT_ITEM(slot);
	if invitem == nil then
		return;
	end

	local obj = GetIES(invitem:GetObject());
	if obj.ClassID == type and level >= TryGet(obj, "Level") then
		itemList[#itemList + 1] = invitem;
	end
end

function GET_PC_ITEMS_BY_LEVEL(type, level, itemList)
	INV_APPLY_TO_ALL_SLOT(_ADD_BY_LEVEL, type, level, itemList);
end

function _CLEAR_FRONT_IMAGE(slot)
	if slot:GetIcon() ~= nil then
		slot:SetFrontImage('None');
	end
end

function INV_CLEAR_FRONT_IMAGE()
	INV_APPLY_TO_ALL_SLOT(_CLEAR_FRONT_IMAGE, recipeProp);
end

function INV_GET_INVEN_BASEIDCLS_BY_ITEMGUID(itemGUID)

	local itemobj = GetObjectByGuid(itemGUID);
	if itemobj == nil then
		return nil;
	end

	local baseid = GetInvenBaseID(itemobj.ClassID)
	local cls = GetClassByNumProp("inven_baseid", "BaseID", baseid);
	
	return cls
end

function INV_GET_SLOTSET_NAME_BY_ITEMGUID(itemGUID)

	local baseidcls = INV_GET_INVEN_BASEIDCLS_BY_ITEMGUID(itemGUID)
	if baseidcls == nil then
		return nil;
	end

	local slotsetname = 'sset_'..baseidcls.ClassName
	return slotsetname

end

function INV_GET_SLOT_BY_ITEMGUID(itemGUID, frame)

	if frame == nil then
		frame = ui.GetFrame("inventory");
	end

	local invItem = session.GetInvItemByGuid(itemGUID);
	if invItem == nil then
		return;
	end

	local itemCls = GetClassByType("Item", invItem.type);
	local typeStr = "Item"	
	if itemCls.ItemType == "Equip" then
		typeStr = itemCls.ItemType; 
	end	


	local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
	local tree_box = GET_CHILD(group, "treeGbox_" .. typeStr,'ui::CGroupBox')
	local tree = GET_CHILD(tree_box, "inventree_" .. typeStr,'ui::CTreeControl')
	local slotsetname = INV_GET_SLOTSET_NAME_BY_ITEMGUID(itemGUID)
	if slotsetname == nil then
		return nil;
	end

	local slotSet = GET_CHILD(tree, slotsetname, "ui::CSlotSet");
	if slotSet == nil then
		return nil;
	end
	
	return GET_SLOT_BY_ITEMID(slotSet, itemGUID);

end

function INV_GET_SLOTSET_BY_ITEMID(itemGUID)

	local invItem = session.GetInvItemByGuid(itemGUID);
	if invItem == nil then
		return;
	end

	local itemCls = GetClassByType("Item", invItem.type);
	local typeStr = "Item"	
	if itemCls.ItemType == "Equip" then
		typeStr = itemCls.ItemType; 
	end	

	local frame = ui.GetFrame("inventory");
	local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
	local tree_box = GET_CHILD(group, "treeGbox_" .. typeStr,'ui::CGroupBox')
	local tree = GET_CHILD(tree_box, "inventree_" .. typeStr,'ui::CTreeControl')
	local slotsetname = INV_GET_SLOTSET_NAME_BY_ITEMGUID(itemGUID)
	local slotSet	= GET_CHILD(tree, slotsetname, "ui::CSlotSet");
	return slotSet

end


function INV_GET_SLOTSET_BY_INVINDEX(index)

	local invItem = session.GetInvItemByGuid(itemGUID);
	if invItem == nil then
		return;
	end

	local itemCls = GetClassByType("Item", invItem.type);
	local typeStr = "Item"	
	if itemCls.ItemType == "Equip" then
		typeStr = itemCls.ItemType; 
	end	

	local invFrame = ui.GetFrame("inventory");
	local invGbox = invFrame:GetChild('inventoryGbox');
	local treeGbox = invGbox:GetChild("treeGbox_" .. typeStr);
	local tree = treeGbox:GetChild("inventree_" .. typeStr);
	local slotsetname = GET_SLOTSET_NAME(index)
	local slotSet = GET_CHILD(tree,slotsetname,"ui::CSlotSet")

	return slotSet
end

function GET_PC_SLOT_BY_ITEMID(itemID)
	local slot = INV_GET_SLOT_BY_ITEMGUID(itemID);
	if slot ~= nil then
		return slot;
	end

	return GET_PC_EQUIP_SLOT_BY_ITEMID(itemID);

end

function GET_PC_EQUIP_SLOT_BY_ITEMID(itemID)
	local frame = ui.GetFrame("inventory");
	local equipItemList = session.GetEquipItemList();
	for i = 0, equipItemList:Count() - 1 do
		local equipItem = equipItemList:Element(i);
		if itemID == equipItem:GetIESID() then
			local spotName = item.GetEquipSpotName(equipItem.equipSpot);
			if  spotName  ~=  nil  then
				return frame:GetChild(spotName);
			end
		end
	end

	return nil;
end

function INV_NOTIFY_FORCE_FINISH()

	if 0 == ui.IsFrameVisible("inventory") then
		local sysframe = ui.GetFrame("sysmenu");
		if imcTime.GetAppTime() < sysframe:GetUserIValue("_NOTIFY_TIME") then
			return;
		end

		sysframe:SetUserValue("_NOTIFY_TIME", imcTime.GetAppTime() + 2.0);
		sysframe:RunUpdateScript("SYSMENU_PLAY_ITEM_GET", 0.0);		
	end
end

function SYSMENU_PLAY_ITEM_GET(frame, elapsedTime)

	if elapsedTime > 0.2 then
		local btn = frame:GetChild("inven");
		btn:PlayEvent("BIG_ITEM_GET");
		imcSound.PlaySoundEvent('item_insert');
		return 0;
	end

	return 1;

end

function INV_FORCE_NOTIFY(itemID, x, y, delayTime)

	local item = GET_PC_ITEM_BY_GUID(itemID);
	if nil == item then
		return;
	end

	local obj = GetIES(item:GetObject());
	if 0 == ui.IsFrameVisible("inventory") then
		local sysframe = ui.GetFrame("sysmenu");
		local btn = sysframe:GetChild("inven");
		local ix, iy = GET_UI_FORCE_POS(btn);
		UI_FORCE("inv_notify", x, y, ix, iy, 0.0, obj.Icon);	
		return;
	end

	local madeSlot = GET_PC_SLOT_BY_ITEMID(itemID);
	if madeSlot == nil then
		return;
	end

	local ix, iy = GET_GLOBAL_XY(madeSlot);
	UI_FORCE("inv_notify", x, y, ix, iy, 0.0, obj.Icon);
	local invFrame = ui.GetFrame("inventory");
	invFrame:SetUserValue("NOTIFY_INV_ITEM", itemID);

end

function GET_PC_MONEY()
	local prop = geItemTable.GetPropByName("Vis");
	local invItem = session.GetInvItemByType(prop.type);
	if invItem ~= nil then
		return invItem.count;
	end
	
	return 0;
end

function INVSLOT_CLEAR_CUSTOM(slot)
	local icon = slot:GetIcon();
	if icon ~= nil then
		icon:SetColorTone("FFFFFFFF");
	end
end

function INVENTORY_SET_ICON_SCRIPT(scriptName, getArgScript)
	local frame = ui.GetFrame("inventory");
	local curValue = frame:GetUserValue("CUSTOM_ICON_SCP");
	if curValue == scriptName then
		return;
	end

	frame:SetUserValue("CUSTOM_ICON_SCP", scriptName);
	frame:SetUserValue("CUSTOM_ICON_ARG_SCP", getArgScript);
	if scriptName == "None" then
		INV_APPLY_TO_ALL_SLOT(INVSLOT_CLEAR_CUSTOM);
		return;
	end

	INVENTORY_UPDATE_ICONS(frame);
end

function INVENTORY_SET_CUSTOM_RBTNDOWN(scriptName)
	local frame = ui.GetFrame("inventory");
	frame:SetUserValue("CUSTOM_RBTN_SCP", scriptName);
end

function INVENTORY_SET_CUSTOM_RDBTNDOWN(scriptName)
	local frame = ui.GetFrame("inventory");
	frame:SetUserValue("CUSTOM_RDBTN_SCP", scriptName);
end

function GET_ITEM_ICON_IMAGE_BY_TAG_INFO(props, clsID)
    local newobj = CreateIESByID("Item", clsID);
	if props ~= 'nullval' then
		SetModifiedPropertiesString(newobj, props);
	end

	local ret = GET_ITEM_ICON_IMAGE(newobj);
	DestroyIES(newobj);
	return ret;
end

function GET_ITEM_ICON_IMAGE(itemCls, gender)

	local iconImg = itemCls.Icon;
		
	-- costume icon is decided by PC's gender
    if itemCls.ItemType == 'Equip' then
        if itemCls.ClassType == 'Outer' or  itemCls.ClassType  == 'SpecialCostume' then
    
    		local tempiconname = string.sub(itemCls.Icon, string.len(itemCls.Icon) - 1 );
    
    		if tempiconname ~= "_m" and tempiconname ~= "_f" then
    			if gender == nil then
    				gender = GETMYPCGENDER();
    			end
    
        		if gender == 1 then
        			iconImg = itemCls.Icon.."_m"
        		else
        			iconImg = itemCls.Icon.."_f"
        		end
    		end
    	end
	else
		local faceID = TryGetProp(itemCls, 'BriquettingIndex');
		if nil ~= faceID and tonumber(faceID) > 0 then
			faceID = tonumber(faceID);
			 local cls = GetClassByType('Item', faceID)
			 if nil ~= cls then
				iconImg = cls.Icon;
			 end
		end
    end
	return iconImg;

end

function UPDATE_ETC_ITEM_SLOTSET(slotset, etcType, tooltipType)

	slotset:ClearIconAll();

	local itemList = session.GetEtcItemList(etcType);
	local index = itemList:Head();
			
	while itemList:InvalidIndex() ~= index do
		local invItem = itemList:Element(index);
		local slot = slotset:GetSlotByIndex(invItem.invIndex);
		if slot == nil then
			slot = GET_EMPTY_SLOT(slotset);
		end

		local itemCls = GetIES(invItem:GetObject());
		local iconImg = GET_ITEM_ICON_IMAGE(itemCls);
		
		SET_SLOT_IMG(slot, iconImg)
		SET_SLOT_COUNT(slot, invItem.count)
		SET_SLOT_COUNT_TEXT(slot, invItem.count);
		SET_SLOT_IESID(slot, invItem:GetIESID())
        SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemCls, nil)
		slot:SetMaxSelectCount(invItem.count);
		local icon = slot:GetIcon();
		icon:SetTooltipArg(tooltipType, invItem.type, invItem:GetIESID());
		SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID, itemCls, tooltipType);		

		index = itemList:Next(index);
	end
	
end

function GET_DRAG_INVITEM_INFO()
	local liftIcon = ui.GetLiftIcon();
	local iconParentFrame = liftIcon:GetTopParentFrame();
	local slot = tolua.cast(control, 'ui::CSlot');
	local iconInfo = liftIcon:GetInfo();
	local invenItemInfo = session.GetInvItemByGuid(iconInfo:GetIESID());
	return invenItemInfo;
end