-- moru.lua --

function CLIENT_MORU_UPGRADE(invItem)
	local frame = ui.GetFrame("upgradeitem_2");
	local fromMoruSlot = GET_CHILD(frame, "fromMoruSlot", "ui::CSlot");
	SET_SLOT_ITEM(fromMoruSlot, invItem);
	ui.GuideMsg("SelectItem");

	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "_CHECK_MORU_TARGET_ITEM_UPGRADE");
	SET_INV_LBTN_FUNC(invframe, "MORU_LBTN_CLICK_UPGRADE");
end

function MORU_LBTN_CLICK_UPGRADE(frame, invItem)
	local upgradeitem_2 = ui.GetFrame("upgradeitem_2");
	local fromItemSlot = GET_CHILD(upgradeitem_2, "fromItemSlot", "ui::CSlot");
	SET_SLOT_ITEM(fromItemSlot, invItem);
	upgradeitem_2:ShowWindow(1);
	UPGRADE2_UPDATE_TARGET(upgradeitem_2);
	UPGRADE2_UPDATE_MORU_COUNT(upgradeitem_2);
	
end

function _CHECK_MORU_TARGET_ITEM_UPGRADE(slot)
	local item = GET_SLOT_ITEM(slot);
	if item ~= nil then
		local obj = GetIES(item:GetObject());
		if IS_ITEM_EVOLUTIONABLE(obj) == 1 then
			slot:GetIcon():SetGrayStyle(0);
		else
			slot:GetIcon():SetGrayStyle(1);
		end
	end
end


----- reinforce_131014

function CLIENT_MORU(invItem)
    local zoneCheck = GetZoneName(pc)
    if zoneCheck == "c_barber_dress" then
        ui.SysMsg(ClMsg('ThisLocalUseNot'));
        return;
    end
    if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('CannotUseInPVPZone'));
        return;
    end

	if IsPVPServer() == 1 then	
		ui.SysMsg(ScpArgMsg('CantUseThisInIntegrateServer'));
		return;
	end
    
	local rankresetFrame = ui.GetFrame("rankreset");
	if 1 == rankresetFrame:IsVisible() then
		ui.SysMsg(ScpArgMsg('CannotDoAction'));
		return;
	end
	
	local frame = ui.GetFrame("reinforce_131014");
	local fromMoruSlot = GET_CHILD(frame, "fromMoruSlot", "ui::CSlot");

	local obj = GetIES(invItem:GetObject());
	
	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

	SET_SLOT_ITEM(fromMoruSlot, invItem);
	ui.GuideMsg("SelectItem");

	local invframe = ui.GetFrame("inventory");
	local gbox = invframe:GetChild("inventoryGbox");
	local x, y = GET_GLOBAL_XY(gbox);
	x = x - gbox:GetWidth() * 0.7;
	y = y - 40;
	SET_MOUSE_FOLLOW_BALLOON(ClMsg("ClickItemToReinforce"), 0, x, y);
	ui.SetEscapeScp("CANCEL_MORU()");
		
	local tab = gbox:GetChild("inventype_Tab");	
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(1);

	--SET_SLOT_APPLY_FUNC(invframe, "_CHECK_MORU_TARGET_ITEM");
	SET_INV_LBTN_FUNC(invframe, "MORU_LBTN_CLICK");

	CHANGE_MOUSE_CURSOR("MORU", "MORU_UP", "CURSOR_CHECK_REINF");
end

function CURSOR_CHECK_REINF(slot)
	local item = GET_SLOT_ITEM(slot);
	if item == nil then
		return 0;
	end
	
	local upgradeitem_2 = ui.GetFrame("reinforce_131014");
	local fromItem, fromMoru = REINFORCE_131014_GET_ITEM(upgradeitem_2);
	if fromItem == nil or fromMoru == nil then
		return 0 
	end
	local moruObj = GetIES(fromMoru:GetObject());
	if moruObj == nil then
		return 0
	end

	local obj = GetIES(item:GetObject());
	if moruObj.ClassName == "Moru_Premium" 
	or moruObj.ClassName == "Moru_Gold" 
	or moruObj.ClassName == "Moru_Gold_14d" 
	or moruObj.ClassName == "Moru_Gold_14d_Team" 
	or moruObj.ClassName == "Moru_Gold_TA" 
	or moruObj.ClassName == "Moru_Gold_TA_NR" 
	or moruObj.ClassName == "Moru_Gold_Team_Trade" 
	or moruObj.ClassName == "Moru_Gold_EVENT_1710_NEWCHARACTER"
	or moruObj.ClassName == "Moru_Gold_14d_Team_event1909"
	or IS_MORU_NOT_DESTROY_TARGET_UNIQUE_ITEM(moruObj) == true then
		if 1 == REINFORCE_ABLE_131014(obj) 
			and obj.PR == 0 then
			return 1;
		end
		return 0;
	elseif moruObj.ClassName == "Moru_Potential" or moruObj.ClassName == "Moru_Potential14d" then
		local itemCls = GetClass("Item",obj.ClassName);
		local objPR = TryGetProp(obj, "PR");

		if nil ~= itemCls and nil ~= objPR and tonumber(itemCls.PR) - 1 > objPR then
			return 1;
		end
		return 0;
	end

	local obj = GetIES(item:GetObject());
	return REINFORCE_ABLE_131014(obj);
end

function CANCEL_MORU()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.RemoveGuideMsg("SelectItem");
	SET_MOUSE_FOLLOW_BALLOON();
	ui.SetEscapeScp("");
	local invframe = ui.GetFrame("inventory");
	--SET_SLOT_APPLY_FUNC(invframe, "None");
	SET_INV_LBTN_FUNC(invframe, "None");
	RESET_MOUSE_CURSOR();
end

function MORU_LBTN_CLICK(frame, invItem)
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("ItemIsNotReinforcable"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if REINFORCE_ABLE_131014(obj) == 0 then
		ui.SysMsg(ClMsg("ItemIsNotReinforcable"));
		return;
	end

	   CANCEL_MORU();
	
	local upgradeitem_2 = ui.GetFrame("reinforce_131014");
	local fromItemSlot = GET_CHILD(upgradeitem_2, "fromItemSlot", "ui::CSlot");
	MORU_SET_SLOT_ITEM(fromItemSlot, invItem);

	local fromItem, fromMoru = REINFORCE_131014_GET_ITEM(upgradeitem_2);
	if fromItem == nil or fromMoru == nil then
		return
	end

	local moruObj = GetIES(fromMoru:GetObject());
	if moruObj == nil then
		return
	end

	if moruObj.ClassName == "Moru_Premium" 
	or moruObj.ClassName == "Moru_Gold" 
	or moruObj.ClassName == "Moru_Gold_14d" 
	or moruObj.ClassName == "Moru_Gold_14d_Team" 
	or moruObj.ClassName == "Moru_Gold_TA" 
	or moruObj.ClassName == "Moru_Gold_TA_NR" 
	or moruObj.ClassName == "Moru_Gold_Team_Trade" 
	or moruObj.ClassName == "Moru_Gold_EVENT_1710_NEWCHARACTER"
	or moruObj.ClassName == "Moru_Gold_14d_Team_event1909"
	or IS_MORU_NOT_DESTROY_TARGET_UNIQUE_ITEM(moruObj) == true then
		if obj.PR > 0 then
		    return;
	    end
	elseif moruObj.ClassName == "Moru_Potential" or moruObj.ClassName == "Moru_Potential14d" then
		local itemObj = GetIES(fromItem:GetObject());
		local itemCls = GetClass("Item",itemObj.ClassName);
		local objPR = TryGetProp(obj, "PR");
		if nil == objPR then
			ui.SysMsg(ClMsg("MaxPR"));
			return;
		end
		if nil ~= itemCls and tonumber(itemCls.PR) - 1 < tonumber(objPR) then
			ui.SysMsg(ClMsg("MaxPR"));
			return;
		end
	end

	local pCls = GetClass("Item", obj.ClassName);
	local Star = TryGetProp(pCls, "ItemStar")
	if Star == nil or tonumber(Star) == 0 then
		return;
	end

	upgradeitem_2:ShowWindow(1);
	REINFORCE_131014_UPDATE_MORU_COUNT(upgradeitem_2);

end

function _CHECK_MORU_TARGET_ITEM(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end
	
	local upgradeitem_2 = ui.GetFrame("reinforce_131014");

	local fromItem, fromMoru = REINFORCE_131014_GET_ITEM(upgradeitem_2);
	if fromItem == nil or fromMoru == nil then
		return
	end

	local moruObj = GetIES(fromMoru:GetObject());
	if moruObj == nil then
		return
	end

	local obj = GetIES(item:GetObject());
	local CanReinforceItem = 0;
	if moruObj.ClassName == "Moru_Premium" 
	or moruObj.ClassName == "Moru_Gold" 
	or moruObj.ClassName == "Moru_Gold_14d" 
	or moruObj.ClassName == "Moru_Gold_14d_Team" 
	or moruObj.ClassName == "Moru_Gold_TA" 
	or moruObj.ClassName == "Moru_Gold_TA_NR" 
	or moruObj.ClassName == "Moru_Gold_Team_Trade" 
	or moruObj.ClassName == "Moru_Gold_EVENT_1710_NEWCHARACTER"
	or moruObj.ClassName == "Moru_Gold_14d_Team_event1909"
	or IS_MORU_NOT_DESTROY_TARGET_UNIQUE_ITEM(moruObj) == true then
	
		if REINFORCE_ABLE_131014(obj) == 1 and obj.PR == 0 then
			CanReinforceItem = 1;
		end
	elseif moruObj.ClassName == "Moru_Potential" or moruObj.ClassName == "Moru_Potential14d" then
		local itemCls = GetClass("Item",obj.ClassName);
		local objPR = TryGetProp(obj, "PR");
		if nil ~= itemCls and nil ~= objPR and tonumber(itemCls.PR) - 1 >= tonumber(objPR) then
			CanReinforceItem = 1;
		end
	elseif REINFORCE_ABLE_131014(obj) == 1 then
		CanReinforceItem =1;
	end

	local pCls = GetClass("Item", obj.ClassName);
	local Star = TryGetProp(pCls, "ItemStar")
	if Star == nil or tonumber(Star) == 0 then
		CanReinforceItem = 0;
	end

	if CanReinforceItem == 1 then
		slot:GetIcon():SetGrayStyle(0);
		slot:SetBlink(60000, 2.0, "FFFFFF00", 1);
	else
		slot:GetIcon():SetGrayStyle(1);
		slot:ReleaseBlink();
	end

end

function MORU_SET_SLOT_ITEM(slot, invItem, count)

	local itemCls = GetClassByType("Item", invItem.type);

	local type = itemCls.ClassID;
	local obj = GetIES(invItem:GetObject());
	local img = GET_ITEM_ICON_IMAGE(obj);
	SET_SLOT_IMG(slot, img)
	SET_SLOT_COUNT(slot, count)
	SET_SLOT_IESID(slot, invItem:GetIESID())
	
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	iconInfo.type = type;

	icon:SetTooltipType('reinforceitem');
	icon:SetTooltipArg('inven',type,invItem:GetIESID());
	
end