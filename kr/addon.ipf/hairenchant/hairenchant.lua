function HAIRENCHANT_ON_INIT(addon, frame)

end

function HAIRENCHANT_OK_BTN(frame, ctrl)
	local enchantGuid = frame:GetUserValue("Enchant");
	local itemIES = frame:GetUserValue("itemIES");

	if "None" == itemIES or "None" == enchantGuid then
		return;
	end

	item.DoPremiumItemEnchantchip(itemIES, enchantGuid);
end

function HAIRENCHANT_SUCEECD(itemIES, moruItemClassID)
	HAIRENCHANT_UPDATE_ITEM_OPTION(itemIES);
		
	local invItem = session.GetInvItemByGuid(itemIES);
	if invItem == nil then
		return;
	end

	local itemCls = GetClassByType("Item", invItem.type);
	local typeStr = "Item"	
	if itemCls.ItemType == "Equip" then
		typeStr = itemCls.ItemType; 
	end	

	imcSound.PlaySoundEvent("premium_enchantchip");
	
	local invframe = ui.GetFrame("inventory");
	local inventoryGbox = invframe:GetChild("inventoryGbox");
	local treeGbox = inventoryGbox:GetChild("treeGbox_" .. typeStr);
	local tree = GET_CHILD(treeGbox,"inventree_" .. typeStr);
	tree:CloseNodeAll();

	local treegroup = tree:FindByValue("Premium");
	tree:ShowTreeNode(treegroup, 1);
	treegroup = tree:FindByValue("EquipGroup");
	tree:ShowTreeNode(treegroup, 1);

	local enchantFrame = ui.GetFrame("hairenchant");
	local enchantGuid = enchantFrame:GetUserValue("Enchant");
	local invItem = session.GetInvItemByGuid(enchantGuid)
	local cnt = enchantFrame:GetChild("scrollCnt");
	if invItem ~= nil then
		cnt:SetTextByKey("value", tostring(invItem.count));
	else
		enchantGuid = GET_NEXT_ITEM_GUID_BY_CLASSID(moruItemClassID);
		enchantFrame:SetUserValue("Enchant", enchantGuid);
		local itemHaveCount = GET_INV_ITEM_COUNT_BY_CLASSID(moruItemClassID);

		cnt:SetTextByKey("value", itemHaveCount);
	end
end

function HAIRENCHANT_ITEM_DROP(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	if nil == invItem then
		return;
	end

	HAIRENCHANT_DRAW_HIRE_ITEM(slot, invItem);	
end

function HAIRENCHANT_UPDATE_ITEM_OPTION(itemIES)
	local invItem = session.GetInvItemByGuid(itemIES)
	if nil == invItem then
		return;
	end
	local obj = GetIES(invItem:GetObject());

	local frame = ui.GetFrame("hairenchant");
	local nonOption = false;
	for i = 1, 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;

		local option = frame:GetChild(propName)
		local txt = "";
		if 1 == i and ( obj[propName] == "None" or obj[propName] == nil ) then
			nonOption = true;
		else
			if obj[propName] ~= "None" then
				local opName = string.format("%s",ScpArgMsg(obj[propName]));
				txt = string.format("%s "..ScpArgMsg("PropUp").."%d", opName, tonumber(obj[propValue]));
			end
		end

		if true == nonOption then
			txt = ClMsg("EnchantOptionNone");
		end

		option:SetTextByKey("value", txt);
	end
end

function HAIRENCHANT_DRAW_HIRE_ITEM(slot, invItem)
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if ENCHANTCHIP_ABLIE(obj) ~= 1 then
		ui.SysMsg(ClMsg("MagicEnchant").." "..ClMsg("IT_ISNT_REINFORCEABLE_ITEM"));
		return;
	end

	local itemIES = invItem:GetIESID();
	if nil ~= session.GetEquipItemByGuid(itemIES) then
		ui.SysMsg(ClMsg("CantRegisterEquipItemToEnchant"));
		return;
	end

	local frame = ui.GetFrame("hairenchant");
	frame:SetUserValue("itemIES", itemIES);
	local slot  = frame:GetChild("slot");
	SET_SLOT_ITEM_IMAGE(slot, invItem);

	local itemName = frame:GetChild("itemName")
	itemName:SetTextByKey("value", obj.Name);

	imcSound.PlaySoundEvent('inven_equip');

	HAIRENCHANT_UPDATE_ITEM_OPTION(itemIES);
end

function HAIRENCHANT_UI_RESET()
	local frame = ui.GetFrame("hairenchant");
	frame:SetUserValue("Enchant", "None");
	frame:SetUserValue("itemIES", "None");
	local itemName = frame:GetChild("itemName")
	itemName:SetTextByKey("value", "");

	local slot  = frame:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();

	local nonOption = false;
	for i = 1, 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;

		local option = frame:GetChild(propName)
		option:SetTextByKey("value", "");
	end

	local cnt = frame:GetChild("scrollCnt");
	cnt:SetTextByKey("value", tostring(0));

	frame:ShowWindow(0);
end