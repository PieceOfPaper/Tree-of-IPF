
function ITEMOPTIONADD_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_ITEMOPTIONADD", "ON_OPEN_DLG_ITEMOPTIONADD");

	-- 성공시 UI 호출
	addon:RegisterMsg("MSG_SUCCESS_ITEM_OPTION_ADD", "SUCCESS_ITEM_OPTION_ADD");


end

function ON_OPEN_DLG_ITEMOPTIONADD(frame)
	frame:ShowWindow(1);
end

function ITEMOPTIONADD_OPEN(frame)
	ui.CloseFrame('rareoption');
	SET_OPTIONADD_RESET(frame);
	CLEAR_ITEMOPTIONADD_UI()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMOPTIONADD_INV_RBTN")	
	ui.OpenFrame("inventory");	
end

function ITEMOPTIONADD_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
		control.DialogOk();
	ui.CloseFrame("inventory");
 end

function OPTIONADD_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemoptionadd");
	UPDATE_OPTIONADD_ITEM(frame);
	UPDATE_OPTIONADD_RESULT(frame, isSuccess);
end

function CLEAR_ITEMOPTIONADD_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end
	
	local frame = ui.GetFrame("itemoptionadd");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	slot:ClearIcon();
	slot:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT)

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(0)

	local do_add = GET_CHILD_RECURSIVELY(frame, "do_add")
	do_add : ShowWindow(1)

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(1)

	local text_beforeadd = GET_CHILD_RECURSIVELY(frame, "text_beforeadd")
	text_beforeadd:ShowWindow(1)
	local text_afteradd = GET_CHILD_RECURSIVELY(frame, "text_afteradd")
	text_afteradd:ShowWindow(0)

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image:ShowWindow(1)
		
	local arrowbox = GET_CHILD_RECURSIVELY(frame, "arrowbox")
	arrowbox:ShowWindow(0)

	local slot_add = GET_CHILD_RECURSIVELY(frame, "slot_add")
	slot_add:ClearIcon()
	slot_add:ShowWindow(0)

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText("")

	local pic_bg = GET_CHILD_RECURSIVELY(frame, "pic_bg")
	pic_bg:ShowWindow(1)

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(1)
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3');
	bodyGbox3:ShowWindow(0)


	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:Resize(bodyGbox1:GetWidth(), bodyGbox1:GetHeight())
	bodyGbox1_1 : RemoveAllChild();
	local bodyGbox3_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3_1');
	bodyGbox3_1: RemoveAllChild();

end

function ITEM_OPTIONADD_MAIN_ITEM_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	CLEAR_ITEMOPTIONADD_UI()
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_OPTIONADD_REG_MAIN_ITEM(toFrame, iconInfo:GetIESID());
	end;
end;

function ITEM_OPTIONADD_ADD_ITEM_DROP(frame, icon, argStr, argNum)    
	if ui.CheckHoldedUI() == true then
		return;
	end
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
--	CLEAR_ITEMOPTIONADD_UI()
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_OPTIONADD_REG_ADD_ITEM(toFrame, iconInfo:GetIESID());
	end;
end;

function ITEM_OPTIONADD_REG_MAIN_ITEM(frame, itemID)

	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox1_1")
	gBox:RemoveChild('tooltip_equip_property');


	if ui.CheckHoldedUI() == true then
		return;
	end
	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return;
	end
	
	
	local item = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID)
	if TryGetProp(itemCls, 'NeedRandomOption', 0) == 1 and TryGetProp(itemCls, 'LegendGroup', 'None') == 'None' then
	    ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"));
        return;
	end
	local invitem = item

	
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	local slotInvItemCls = nil
	if slotInvItem ~= nil then
		local tempItem = GetIES(slotInvItem:GetObject());
		slotInvItemCls = GetClass('Item', tempItem.ClassName)
	end

	if slotInvItem ~= nil then
		-- invItem 이 아이커가 아니면 에러 후 리턴 if invItem
		if TryGetProp(item, 'GroupName') ~= 'Icor' then
			ui.SysMsg(ClMsg("MustEquipIcor"));
			return;
		end

		local addSlot = GET_CHILD_RECURSIVELY(frame, "slot_add");

		SET_SLOT_ITEM(addSlot, invItem)
		isMaterial = 1
	else
		-- invitem 이 slot 들어갈 템이 아니면 에러후 리턴
		if TryGetProp(item, 'LegendGroup', 'None') == 'None' then
		--장착 안대는 아이템        
			ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"));
			return;
		end

		CLEAR_ITEMOPTIONADD_UI()
		SET_SLOT_ITEM(slot, invItem)
		slotInvItem = GET_SLOT_ITEM(slot)
		local tempItem = GetIES(slotInvItem:GetObject());
		slotInvItemCls = GetClass('Item', tempItem.ClassName)
		
	end
-- 인벤 음영처리
	INVENTORY_SET_ICON_SCRIPT("INVENTORY_ADD_ITEM_CHECK");
------
--
	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
		
	local invframe = ui.GetFrame("inventory");
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemOptionExtractMaterial = nil;
	local isAbleExchange = 1;

	local materialItemSlot = 2;
	frame:SetUserValue('MAX_EXCHANGEITEM_CNT', exchangeItemSlot);
	frame:SetUserValue("isAbleExchange", isAbleExchange)


	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image:ShowWindow(0)

	local arrowbox = GET_CHILD_RECURSIVELY(frame, "arrowbox")
	arrowbox:ShowWindow(1)

	local slot_add = GET_CHILD_RECURSIVELY(frame, "slot_add")
	slot_add:ShowWindow(1)

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText(obj.Name)

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:SetGravity(ui.LEFT, ui.CENTER_VERT)
	local slot_add = GET_CHILD_RECURSIVELY(frame, "slot_add");
	local icor_img = nil
	if itemCls.GroupName == "Weapon" then
		icor_img = frame:GetUserConfig("ICOR_IMAGE_WEAPON")
	else
		icor_img = frame:GetUserConfig("ICOR_IMAGE_ARMOR")
	end

	SET_OPTIONADD_RESET(frame);	
end

function ITEM_OPTIONADD_REG_ADD_ITEM(frame, itemID)    
	if ui.CheckHoldedUI() == true then
		return;
	end

	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox1_1")
	gBox:RemoveChild('tooltip_equip_property');

	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return;
	end

	local item = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID)
	local invitem = item

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

-- invItem 이 아이커가 아니면 에러 후 리턴 if invItem
	if TryGetProp(invitem, 'GroupName') ~= 'Icor' then
		ui.SysMsg(ClMsg("MustEquipIcor"));
		return;
	end
	
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	local slotInvItemCls = nil
	if slotInvItem ~= nil then
		local tempItem = GetIES(slotInvItem:GetObject());
		slotInvItemCls = GetClass('Item', tempItem.ClassName)
	end
    
	--아이커의 atk 과 slot 의 atk 이 맞아야만 장착가능    
	local targetItem = GetClass('Item', invitem.InheritanceItemName);

    if targetItem == nil then
        targetItem = GetClass('Item', invitem.InheritanceRandomItemName);
    end
        
	if targetItem.ClassType ~= slotInvItemCls.ClassType or (IS_ICORABLE_RANDOM_LEGEND_ITEM(slotInvItemCls) and invitem.InheritanceRandomItemName ~= 'None') then
		ui.SysMsg(ClMsg('NotMatchItemClassType')) -- atk 타입이 안맞아서 리턴
		return
	end
	
	local yPos = 0
	local basicList = GET_EQUIP_TOOLTIP_PROP_LIST(targetItem);
    local list = {};
    local basicTooltipPropList = StringSplit(targetItem.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i];
        list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(basicList, basicTooltipProp, list);
    end

	local list2 = GET_EUQIPITEM_PROP_LIST();    
	
	local cnt = 0;
	for i = 1 , #list do

		local propName = list[i];
		local propValue = TryGetProp(targetItem, propName, 0);
		
		if propValue ~= 0 then
            local checkPropName = propName;
            if propName == 'MINATK' or propName == 'MAXATK' then
                checkPropName = 'ATK';
            end
            if EXIST_ITEM(basicTooltipPropList, checkPropName) == false then
                cnt = cnt + 1;
            end
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = TryGetProp(targetItem, propName, 0);
		if propValue ~= 0 then

			cnt = cnt +1
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if targetItem[propValue] ~= 0 and targetItem[propName] ~= "None" then
			cnt = cnt +1
		end
	end

	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property', 'tooltip_equip_property', 0, yPos);
	local labelline = GET_CHILD_RECURSIVELY(tooltip_equip_property_CSet, "labelline")
	labelline:ShowWindow(0)
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')

	local class = GetClassByType("Item", targetItem.ClassID);

	local inner_yPos = 0;
	
	local maxRandomOptionCnt = 6;
	local randomOptionProp = {};
	for i = 1, maxRandomOptionCnt do
		if targetItem['RandomOption_'..i] ~= 'None' then
			randomOptionProp[targetItem['RandomOption_'..i]] = targetItem['RandomOptionValue_'..i];
		end
	end

	for i = 1 , #list do
		local propName = list[i];
		local propValue = TryGetProp(targetItem, propName, 0);

		local needToShow = true;
		for j = 1, #basicTooltipPropList do
			if basicTooltipPropList[j] == propName then
				needToShow = false;
			end
		end

		if needToShow == true and propValue ~= 0 and randomOptionProp[propName] == nil then -- 랜덤 옵션이랑 겹치는 프로퍼티는 여기서 출력하지 않음

			if  targetItem.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
					inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
				end
			elseif  targetItem.GroupName == 'Armor' then
				if targetItem.ClassType == 'Gloves' then
					if propName ~= "HR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				elseif targetItem.ClassType == 'Boots' then
					if propName ~= "DR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				else
					if propName ~= "DEF" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				end
			else
				local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
				inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
			end
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if targetItem[propValue] ~= 0 and targetItem[propName] ~= "None" then
			local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(targetItem[propName]));
			local strInfo = ABILITY_DESC_PLUS(opName, targetItem[propValue]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end
	
	for i = 1 , maxRandomOptionCnt do
	    local propGroupName = "RandomOptionGroup_"..i;
		local propName = "RandomOption_"..i;
		local propValue = "RandomOptionValue_"..i;
		local clientMessage = 'None'
		
		if invitem[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif invitem[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif invitem[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif invitem[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif invitem[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif invitem[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end

		if invitem[propValue] ~= 0 and invitem[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(invitem[propName]));
			local strInfo = ABILITY_DESC_NO_PLUS(opName, invitem[propValue], 0);

			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = TryGetProp(targetItem, propName, 0);
		if propValue ~= 0 then
			local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), targetItem[propName]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	if targetItem.OptDesc ~= nil and targetItem.OptDesc ~= 'None' then
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, targetItem.OptDesc, 0, inner_yPos);
	end

	if targetItem.IsAwaken == 1 then
		local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(targetItem.HiddenProp));
		local strInfo = ABILITY_DESC_PLUS(opName, targetItem.HiddenPropValue);
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
	end

	if targetItem.ReinforceRatio > 100 then
		local opName = ClMsg("ReinforceOption");
		local strInfo = ABILITY_DESC_PLUS(opName, math.floor(10 * targetItem.ReinforceRatio/100));
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo.."0%"..ClMsg("ReinforceOptionAtk"), 0, inner_yPos);
	end

	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + 40);

	gBox:Resize(gBox:GetWidth(), tooltip_equip_property_CSet:GetHeight())


	local slot = GET_CHILD_RECURSIVELY(frame, "slot_add")
	SET_SLOT_ITEM(slot, invItem);
end


function SET_OPTIONADD_RESET(frame)
--	reg:ShowWindow(0);
end;


function ITEMOPTIONADD_EXEC(frame)

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);

	if invItem == nil then
		return
	end

	local isAbleExchange = frame:GetUserIValue("isAbleExchange")

	if isAbleExchange == 0 then
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return
	end

	if isAbleExchange == -1 then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return
	end

	if isAbleExchange == -2 then
		ui.SysMsg(ClMsg("MaxDurUnderflow")); 
		return
	end
	
	local clmsg = ScpArgMsg("DoItemOptionAdd")

	local slot_add = GET_CHILD_RECURSIVELY(frame, "slot_add");
	local invItem_add = GET_SLOT_ITEM(slot_add);
	if invItem_add == nil then
		return
	end

	local obj = GetIES(invItem:GetObject());
	local obj_add = GetIES(invItem_add:GetObject());

	if (TryGetProp(obj, 'InheritanceItemName', 'None') ~= 'None' and TryGetProp(obj_add, 'InheritanceItemName', 'None') ~= 'None')
		or TryGetProp(obj, 'InheritanceRandomItemName', 'None') ~= 'None' and TryGetProp(obj_add, 'InheritanceRandomItemName', 'None') ~= 'None' then 
		ui.SysMsg(ClMsg("AlearyIcorAdded"));
		return;
	end

	ui.MsgBox_NonNested(clmsg, frame:GetName(), "_ITEMOPTIONADD_EXEC", "_ITEMOPTIONADD_CANCEL");
end

function _ITEMOPTIONADD_CANCEL()
	local frame = ui.GetFrame("itemoptionadd");
end;

function _ITEMOPTIONADD_EXEC(checkRebuildFlag)

	local frame = ui.GetFrame("itemoptionadd");


	local isAbleExchange = frame:GetUserIValue("isAbleExchange")

	if isAbleExchange == 0 then
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return
	end

	if isAbleExchange == -1 then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return
	end

	if isAbleExchange == -2 then
		ui.SysMsg(ClMsg("MaxDurUnderflow")); 
		return
	end

	local frame = ui.GetFrame("itemoptionadd");
	if frame:IsVisible() == 0 then
		return;
	end
	

	local mainSlot = GET_CHILD_RECURSIVELY(frame, "slot");
	local mainInvItem = GET_SLOT_ITEM(mainSlot);
	if mainInvItem == nil then
		return;
	end

	if checkRebuildFlag ~= false then
		local targetItemObj = GetIES(mainInvItem:GetObject());
		if TryGetProp(targetItemObj, 'Rebuildchangeitem', 0) > 0 then
			ui.MsgBox(ScpArgMsg('IfUDoCannotExchangeWeaponType'), '_ITEMOPTIONADD_EXEC(false)', 'None');
			return;
		end
	end

	local text_beforeadd = GET_CHILD_RECURSIVELY(frame, "text_beforeadd")
	text_beforeadd:ShowWindow(0)
	local text_afteradd = GET_CHILD_RECURSIVELY(frame, "text_afteradd")
	text_afteradd:ShowWindow(1)
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, "bodyGbox3")
	bodyGbox3:ShowWindow(0)

	local doAdd = GET_CHILD_RECURSIVELY(frame, "do_add")
	doAdd:ShowWindow(0)
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)


	local addSlot = GET_CHILD_RECURSIVELY(frame, "slot_add");
	local addInvItem = GET_SLOT_ITEM(addSlot);
	if addInvItem == nil then
		return;
	end

------------------------------
--  add 서버 스크립트 호출 부분 --
------------------------------
	session.ResetItemList();
    session.AddItemID(mainInvItem:GetIESID(), 1);
    session.AddItemID(addInvItem:GetIESID(), 1);
    local resultlist = session.GetItemIDList();
    item.DialogTransaction("EQUIP_ITEM_OPTION", resultlist);
end

function SUCCESS_ITEM_OPTION_ADD(frame)
	local ADD_RESULT_EFFECT_NAME = frame:GetUserConfig('ADD_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('RESULT_EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');

	if pic_bg == nil then
		return;
	end

	--pic_bg:PlayUIEffect(ADD_RESULT_EFFECT_NAME, EFFECT_SCALE, 'ADD_RESULT_EFFECT');

	local do_add = GET_CHILD_RECURSIVELY(frame, "do_add")
	do_add : ShowWindow(0)

	ui.SetHoldUI(true);

	ReserveScript("_SUCCESS_ITEM_OPTION_ADD()", 0.01)
end

function _SUCCESS_ITEM_OPTION_ADD()
	ui.SetHoldUI(false);
	local frame = ui.GetFrame("itemoptionadd");
	if frame:IsVisible() == 0 then
		return;
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end

	local ADD_RESULT_EFFECT_NAME = frame:GetUserConfig('ADD_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	--pic_bg:StopUIEffect('ADD_RESULT_EFFECT', true, 0.5);


	local item = GetIES(invItem:GetObject());
	
	local doAdd = GET_CHILD_RECURSIVELY(frame, "do_add")
	doAdd:ShowWindow(0)
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)

	local text_beforeadd = GET_CHILD_RECURSIVELY(frame, "text_beforeadd")
	text_beforeadd:ShowWindow(0)
	local text_afteradd = GET_CHILD_RECURSIVELY(frame, "text_afteradd")
	text_afteradd:ShowWindow(1)

	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, "bodyGbox3")
	bodyGbox3:ShowWindow(0)

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(1)

	local gbox = frame:GetChild("gbox");
	invItem = GET_SLOT_ITEM(slot);
	local invItemGUID = invItem:GetIESID()
	local resetInvItem = session.GetInvItemByGuid(invItemGUID)
	local obj = GetIES(resetInvItem:GetObject());

	local refreshScp = obj.RefreshScp
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(obj);
	end

	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox3_1");
    local ypos = 0;
	for i = 1 , MAX_OPTION_EXTRACT_COUNT do
	    local propGroupName = "RandomOptionGroup_"..i;
		local propName = "RandomOption_"..i;
		local propValue = "RandomOptionValue_"..i;
		local clientMessage = 'None'
		
		if obj[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif obj[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif obj[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'			
		elseif obj[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif obj[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end

		if obj[propValue] ~= 0 and obj[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(obj[propName]));
			local strInfo = ABILITY_DESC_NO_PLUS(opName, obj[propValue], 0);
			local itemClsCtrl = gBox:CreateOrGetControlSet('eachproperty_in_itemrandomreset', 'PROPERTY_CSET_'..i, 0, 0);
			itemClsCtrl = AUTO_CAST(itemClsCtrl)
			local pos_y = itemClsCtrl:GetUserConfig("POS_Y")
			itemClsCtrl:Move(0, i * pos_y);
			local propertyList = GET_CHILD_RECURSIVELY(itemClsCtrl, "property_name", "ui::CRichText");
			propertyList:SetText(strInfo)
            ypos = i * pos_y + propertyList:GetHeight();
		end
	end
    
	local resultItemImg = GET_CHILD_RECURSIVELY(frame, "result_item_img")
	resultItemImg:ShowWindow(1)
	resultItemImg:SetImage(item.Icon)
	ADD_SUCCESS_EFFECT(frame)
end



function ADD_SUCCESS_EFFECT(frame)
	local frame = ui.GetFrame("itemoptionadd");
	local ADD_SUCCESS_EFFECT_NAME = frame:GetUserConfig('ADD_SUCCESS_EFFECT');
	local SUCCESS_EFFECT_SCALE = tonumber(frame:GetUserConfig('SUCCESS_EFFECT_SCALE'));
	local SUCCESS_EFFECT_DURATION = tonumber(frame:GetUserConfig('SUCCESS_EFFECT_DURATION'));
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(1)

	local pic_bg = GET_CHILD_RECURSIVELY(frame, "pic_bg")
	pic_bg:ShowWindow(0)

	--result_effect_bg:PlayUIEffect(ADD_SUCCESS_EFFECT_NAME, SUCCESS_EFFECT_SCALE, 'ADD_SUCCESS_EFFECT');

	ReserveScript("_ADD_SUCCESS_EFFECT()", 0.01)
end

function  _ADD_SUCCESS_EFFECT()
	local frame = ui.GetFrame("itemoptionadd");
	if frame:IsVisible() == 0 then
		return;
	end

	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end
	--result_effect_bg:StopUIEffect('ADD_SUCCESS_EFFECT', true, 0.5);
	
end


function REMOVE_OPTIONADD_MAIN_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:ClearIcon();
	CLEAR_ITEMOPTIONADD_UI()
end

function REMOVE_OPTIONADD_ADD_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot_add");
	slot:ClearIcon();

	local gBox = GET_CHILD_RECURSIVELY(frame, "bodyGbox1_1")
	gBox:RemoveChild('tooltip_equip_property');
--	CLEAR_ITEMOPTIONADD_UI()
end

function ITEMOPTIONADD_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("itemoptionadd");
	if frame == nil then
		return
	end
	
	local itemCls = GetClass('Item', TryGetProp(itemObj, 'ClassName', 'None'))
	if TryGetProp(itemCls, 'NeedRandomOption', 0) == 1 and TryGetProp(itemCls, 'LegendGroup', 'None') == 'None' then    
	    ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"));
        return;
	end
	
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	local slotInvItemCls = nil
	if slotInvItem ~= nil then
		local tempItem = GetIES(slotInvItem:GetObject());
		slotInvItemCls = GetClass('Item', tempItem.ClassName)
	end

	if slotInvItem ~= nil then
		ITEM_OPTIONADD_REG_ADD_ITEM(frame, iconInfo:GetIESID())

	else
		-- invitem 이 slot 들어갈 템이 아니면 에러후 리턴
		if TryGetProp(obj, 'LegendGroup', 'None') == 'None' then
		--장착 안대는 아이템
			ui.SysMsg(ClMsg("NotAllowedItemOptionAdd"));
			return;
		end

		CLEAR_ITEMOPTIONADD_UI()

		ITEM_OPTIONADD_REG_MAIN_ITEM(frame, iconInfo:GetIESID())

		SET_SLOT_ITEM(slot, invItem)
		slotInvItem = GET_SLOT_ITEM(slot)
		local tempItem = GetIES(slotInvItem:GetObject());
		slotInvItemCls = GetClass('Item', tempItem.ClassName)
		
	end

end

function INVENTORY_ADD_ITEM_CHECK(slot, reinfItemObj, invItem, itemobj)
	slot:SetUserValue("INVENTORY_ADD_ITEM_CHECK", 0);
	local icon = slot:GetIcon();
	icon:SetColorTone("FFFFFFFF");
end

-- 인장
local function _INIT_SLOT_FOR_OPTION_ADD(frame)
	local slot = GET_CHILD_RECURSIVELY(frame, 'slot');
	local slot_add = GET_CHILD_RECURSIVELY(frame, 'slot_add');
	local slot_bg_image = GET_CHILD(slot, 'slot_bg_image');
	local arrowbox = GET_CHILD_RECURSIVELY(frame, 'arrowbox');
	slot:SetGravity(ui.LEFT, ui.CENTER_VERT);
	slot:ShowWindow(1);
	slot_bg_image:ShowWindow(0);
	slot_add:ShowWindow(1);
	arrowbox:ShowWindow(1);
end

local function _CREATE_COMPONENT(frame)
	local parent = GET_CHILD_RECURSIVELY(frame, 'bodyGbox4');
	local updownmax = CREATE_UPDOWNMAX_COMPONENT(parent, 'updownmax', {
		x = 0, y = 0, width = 200, height = 36, 
		margin = {0, 210, 0, 0},
		gravity = { horz = ui.CENTER_HORZ, vert = ui.TOP },
		maxBtnUpScp = 'SEAL_REINFORCE_MAX_BTN_CLICK',
		upBtnUpScp = 'SEAL_REINFORCE_UP_BTN_CLICK',
		downBtnUpScp = 'SEAL_REINFORCE_DOWN_BTN_CLICK',
	});


	local itemslotComp_Silver = CREATE_ITEMSLOT_MINMAXCOUNT_COMPONENT(parent, 'itemslotComp_Silver', {
		x = 0, y = 0, width = parent:GetWidth() - 10, height = 80, 
		margin = {0, 0, 0, 90},
		gravity = { horz = ui.CENTER_HORZ, vert = ui.BOTTOM },
	});
	local moneyCls = GetClass('Item', MONEY_NAME);
	itemslotComp_Silver:SetName(moneyCls.Name);

	local itemslotComp_Item = CREATE_ITEMSLOT_MINMAXCOUNT_COMPONENT(parent, 'itemslotComp_Item', {
		x = 0, y = 0, width = parent:GetWidth() - 10, height = 80, 
		margin = {0, 0, 0, 0},
		gravity = { horz = ui.CENTER_HORZ, vert = ui.BOTTOM },
	});
end

function OPEN_SEAL_OPTION_UI()
	local frame = ui.GetFrame('itemoptionadd');
	frame:SetUserValue('MODE', 'REINFORCE_SEAL');
	CLEAR_ITEMOPTIONADD_UI();
	_SET_TITLE(frame, 'ReinforceSeal');	
	_SHOW_MAIN_SLOT(frame, 0);
	_INIT_SLOT_FOR_OPTION_ADD(frame);	
	_CREATE_COMPONENT(frame);
	frame:ShowWindow(1);
end