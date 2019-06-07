
function ITEMOPTIONEXTRACT_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_ITEMOPTIONEXTRACT", "ON_OPEN_DLG_ITEMOPTIONEXTRACT");

	--성공시 UI 호출
	addon:RegisterMsg("MSG_SUCCESS_ITEM_OPTION_EXTRACT", "SUCCESS_ITEM_OPTION_EXTRACT");
	--실패시 UI 호출
	addon:RegisterMsg("MSG_FAIL_ITEM_OPTION_EXTRACT", "FAIL_ITEM_OPTION_EXTRACT");
    addon:RegisterMsg("MSG_RUN_FAIL_EFFECT", 'RUN_FAIL_EFFECT');
    addon:RegisterMsg("MSG_RUN_SUCCESS_EFFECT", 'RUN_SUCCESS_EFFECT');
end

function ON_OPEN_DLG_ITEMOPTIONEXTRACT(frame)
	frame:ShowWindow(1);	
end

function ITEMOPTIONEXTRACT_OPEN(frame)
	ui.CloseFrame('rareoption');
	SET_OPTIONEXTRACT_RESET(frame);
	CLEAR_ITEMOPTIONEXTRACT_UI()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMOPTIONEXTRACT_INV_RBTN")	
	ui.OpenFrame("inventory");	
end

function ITEMOPTIONEXTRACT_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
	ui.CloseFrame("inventory");
 end

function OPTIONEXTRACT_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemoptionextract");
	UPDATE_OPTIONEXTRACT_ITEM(frame);
	UPDATE_OPTIONEXTRACT_RESULT(frame, isSuccess);
end

function CLEAR_ITEMOPTIONEXTRACT_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	local frame = ui.GetFrame("itemoptionextract");

	local slot = GET_CHILD_RECURSIVELY(frame, "slot", "ui::CSlot");
	slot:ClearIcon();
	slot:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT)

	local extractKitSlot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot")
	extractKitSlot:ClearIcon()

	local pic_bg = GET_CHILD_RECURSIVELY(frame, "pic_bg")
	pic_bg:ShowWindow(1)

	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok")
	send_ok:ShowWindow(0)

	local do_extract = GET_CHILD_RECURSIVELY(frame, "do_extract")
	do_extract : ShowWindow(1)

	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(0)

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(1)

	local text_material = GET_CHILD_RECURSIVELY(frame, "text_material")
	text_material : ShowWindow(1)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image : ShowWindow(1)

	local text_potential = GET_CHILD_RECURSIVELY(frame, "text_potential")
	text_potential : ShowWindow(0)
	local gauge_potential = GET_CHILD_RECURSIVELY(frame, "gauge_potential")
	gauge_potential : ShowWindow(0)
		
	local arrowbox = GET_CHILD_RECURSIVELY(frame, "arrowbox")
	arrowbox : ShowWindow(0)

	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result")
	slot_result : ShowWindow(0)

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText("")

	local bodyGbox1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1');
	bodyGbox1:ShowWindow(1)
	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(1)
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:ShowWindow(1)
	local extractKitGbox = GET_CHILD_RECURSIVELY(frame, 'extractKitGbox')
	extractKitGbox:ShowWindow(0)
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3');
	bodyGbox3:ShowWindow(0)

	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1');
	bodyGbox1_1:ShowWindow(1)
	bodyGbox1_1:Resize(bodyGbox1:GetWidth(), bodyGbox1:GetHeight())
	bodyGbox1_1:RemoveAllChild();
	local bodyGbox2_2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_2');
	bodyGbox2_2:ShowWindow(1)
	bodyGbox2_2:RemoveAllChild();
	local bodyGbox3_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3_1');
	bodyGbox3_1:ShowWindow(1)
	bodyGbox3_1:RemoveAllChild();

	local destroy_gbox = GET_CHILD_RECURSIVELY(frame, 'destroy_gbox')
	destroy_gbox:ShowWindow(0)

	local extractKitName = GET_CHILD_RECURSIVELY(frame, "extractKitName")
	extractKitName:SetTextByKey("value", frame:GetUserConfig("EXTRACT_KIT_DEFAULT"))

end

function ITEM_OPTIONEXTRACT_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	CLEAR_ITEMOPTIONEXTRACT_UI()
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_OPTIONEXTRACT_REG_TARGETITEM(toFrame, iconInfo:GetIESID());
	end
end

function ITEM_OPTIONEXTRACT_REG_TARGETITEM(frame, itemID)
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
	local invitem = item

	if IS_ENABLE_EXTRACT_OPTION(item) ~= true then
		--추출 안대는 아이템
		ui.SysMsg(ClMsg("NotAllowedItemOptionExtract"));
		return;
	end
	
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
	local yPos = 0
	local basicList = GET_EQUIP_TOOLTIP_PROP_LIST(invitem);
    local list = {};
    local basicTooltipPropList = StringSplit(invitem.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i];
        list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(basicList, basicTooltipProp, list);
    end

	local list2 = GET_EUQIPITEM_PROP_LIST();
	
	local cnt = 0;
	for i = 1 , #list do

		local propName = list[i];
		local propValue = invitem[propName];
		
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
		local propValue = invitem[propName];
		if propValue ~= 0 then

			cnt = cnt +1
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if invitem[propValue] ~= 0 and invitem[propName] ~= "None" then
			cnt = cnt +1
		end
	end

	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property', 'tooltip_equip_property', 0, yPos);
	local labelline = GET_CHILD_RECURSIVELY(tooltip_equip_property_CSet, "labelline")
	labelline:ShowWindow(0)
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')

	local class = GetClassByType("Item", invitem.ClassID);

	local inner_yPos = 0;
	
	local maxRandomOptionCnt = 6;
	local randomOptionProp = {};
	for i = 1, maxRandomOptionCnt do
		if invitem['RandomOption_'..i] ~= 'None' then
			randomOptionProp[invitem['RandomOption_'..i]] = invitem['RandomOptionValue_'..i];
		end
	end

	for i = 1 , #list do
		local propName = list[i];
		local propValue = invitem[propName];

		local needToShow = true;
		for j = 1, #basicTooltipPropList do
			if basicTooltipPropList[j] == propName then
				needToShow = false;
			end
		end

		if needToShow == true and itemCls[propName] ~= 0 and randomOptionProp[propName] == nil then -- 랜덤 옵션이랑 겹치는 프로퍼티는 여기서 출력하지 않음

			if  invitem.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), itemCls[propName]);					
					inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
				end
			elseif  invitem.GroupName == 'Armor' then
				if invitem.ClassType == 'Gloves' then
					if propName ~= "HR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), itemCls[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				elseif invitem.ClassType == 'Boots' then
					if propName ~= "DR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), itemCls[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				else
					if propName ~= "DEF" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), itemCls[propName]);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				end
			else
				local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), itemCls[propName]);
				inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
			end
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if invitem[propValue] ~= 0 and invitem[propName] ~= "None" then
			local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(invitem[propName]));
			local strInfo = ABILITY_DESC_PLUS(opName, invitem[propValue]);
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
		local propValue = invitem[propName];
		if propValue ~= 0 then
			local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), invitem[propName]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	if invitem.OptDesc ~= nil and invitem.OptDesc ~= 'None' then
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, invitem.OptDesc, 0, inner_yPos);
	end

	if invitem.ReinforceRatio > 100 then
		local opName = ClMsg("ReinforceOption");
		local strInfo = ABILITY_DESC_PLUS(opName, math.floor(10 * invitem.ReinforceRatio/100));
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo.."0%"..ClMsg("ReinforceOptionAtk"), 0, inner_yPos);
	end

	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + 40);

	gBox:Resize(gBox:GetWidth(), tooltip_equip_property_CSet:GetHeight())


	local itemOptionExtractMaterial = nil;
	local isAbleExchange = 1;

	local materialItemSlot = 1;
	frame:SetUserValue('MAX_EXCHANGEITEM_CNT', exchangeItemSlot);
	local extractKitGbox = GET_CHILD_RECURSIVELY(frame, 'extractKitGbox')
	extractKitGbox:ShowWindow(1)
	local i = 1
	local materialItemIndex = "MaterialItem_" .. i
	local materialItemCount = 0
	local ItemGrade = itemCls.ItemGrade
	materialItemCount = GET_OPTION_EXTRACT_NEED_MATERIAL_COUNT(item)
	frame:SetUserValue('MATERIAL_ITEM_COUNT', materialItemCount)
	
	local bodyGbox2_2 = GET_CHILD_RECURSIVELY(frame, "bodyGbox2_2")
	local materialClsCtrl = bodyGbox2_2:CreateOrGetControlSet('eachmaterial_in_itemoptionextract', 'MATERIAL_CSET_'..i, 0, 0);
	materialClsCtrl = AUTO_CAST(materialClsCtrl)
	local pos_y = materialClsCtrl:GetUserConfig("POS_Y")
	local material_icon = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_icon", "ui::CPicture");
	local material_questionmark = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_questionmark", "ui::CPicture");
	local material_name = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_name", "ui::CRichText");
	local material_count = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_count", "ui::CRichText");
	local gradetext2 = GET_CHILD_RECURSIVELY(materialClsCtrl, "grade", "ui::CRichText");
	local labelline = GET_CHILD_RECURSIVELY(materialClsCtrl, "labelline2")
	labelline:ShowWindow(0)

	local materialItemName = ScpArgMsg('NotDecidedYet')

	local itemIcon = 'question_mark'
	material_icon:ShowWindow(1)
	material_questionmark : ShowWindow(0)
	if item ~= nil then
		local materialCls = GetClass("Item", GET_OPTION_EXTRACT_MATERIAL_NAME());
		if i <= materialItemSlot and materialCls ~= 'None' then
			materialClsCtrl : ShowWindow(1)
			itemIcon = materialCls.Icon;
			materialItemName = materialCls.Name;
			local itemCount = GetInvItemCount(pc, materialCls.ClassName)
			local invMaterial = session.GetInvItemByName(materialCls.ClassName)

			local type = item.ClassID;
				
			if itemCount < materialItemCount then
				material_count:SetTextByKey("color", "{#EE0000}");
				isAbleExchange = 0;
			elseif invMaterial.isLockState == true then
				isAbleExchange = -1;
			else 
				material_count:SetTextByKey("color", nil);
			end
			material_count:SetTextByKey("curCount", itemCount);
			material_count:SetTextByKey("needCount", materialItemCount)
				
			session.AddItemID(materialCls.ClassID, materialItemCount);
	
		else
			materialClsCtrl : ShowWindow(0)
		end

	else
		materialClsCtrl : ShowWindow(0)
	end

	material_icon : SetImage(itemIcon)
	material_name : SetText(materialItemName)

	frame:SetUserValue("isAbleExchange", isAbleExchange)


	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(0)

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "slot_bg_image")
	slot_bg_image : ShowWindow(0)

	local text_potential = GET_CHILD_RECURSIVELY(frame, "text_potential")
	text_potential : ShowWindow(1)
	local gauge_potential = GET_CHILD_RECURSIVELY(frame, "gauge_potential")
	gauge_potential : ShowWindow(1)

	local arrowbox = GET_CHILD_RECURSIVELY(frame, "arrowbox")
	arrowbox : ShowWindow(1)

	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result")
	slot_result : ShowWindow(1)

	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText(obj.Name)

	gauge_potential:SetPoint(obj.PR, obj.MaxPR);
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:SetGravity(ui.LEFT, ui.CENTER_VERT)
	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result");
	local icor_img = nil
	if itemCls.GroupName == "Weapon" or itemCls.GroupName == "SubWeapon" then
		icor_img = frame:GetUserConfig("ICOR_IMAGE_WEAPON")
	else
		icor_img = frame:GetUserConfig("ICOR_IMAGE_ARMOR")
	end
	

	SET_SLOT_IMG(slot_result, icor_img)
	frame:SetUserValue("icor_img", icor_img)
	SET_SLOT_ITEM(slot, invItem);
	SET_OPTIONEXTRACT_RESET(frame);	
	
end

function ITEM_OPTIONEXTRACT_KIT_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_OPTIONEXTRACT_KIT_REG_TARGETITEM(toFrame, iconInfo:GetIESID());
	end;
end;

function ITEM_OPTIONEXTRACT_KIT_REG_TARGETITEM(frame, itemID)
	
	local invItem = session.GetInvItemByGuid(itemID)
	if invItem == nil then
		return;
	end

	local item = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID)

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	--재료 관련 여러 처리 해야함
	if IS_VALID_OPTION_EXTRACT_KIT(item) ~= true then
		--옵션 추출용 키트 아이템이 아니야
		ui.SysMsg(ClMsg("IsNotOptionExtractKit"));
		return
	end

	if IS_100PERCENT_SUCCESS_EXTRACT_ICOR_ITEM(item) == true then		
		local slot = GET_CHILD_RECURSIVELY(frame, "slot");
		local targetItem = GET_SLOT_ITEM(slot);
		if targetItem == nil then
			return;
		end

		local targetItemObj = GetIES(targetItem:GetObject());
		if item.ClassName == 'Extract_kit_Gold_NotFail_Rand' then	
			if IS_HAVE_RANDOM_OPTION(targetItemObj) == false then
				ui.SysMsg(ClMsg("IsNotOptionExtractKit"));
				return;
			end
		elseif item.ClassName == 'Extract_kit_Gold_NotFail_Recipe' then
			if IS_HAVE_RANDOM_OPTION(targetItemObj) == true then
				ui.SysMsg(ClMsg("IsNotOptionExtractKit"));
				return;
			end
		end
	end
	
	local invframe = ui.GetFrame("inventory");
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	SET_SLOT_ITEM(slot, invItem);
	local extractKitName = GET_CHILD_RECURSIVELY(frame, "extractKitName", "ui::CRichText")
	extractKitName:SetTextByKey("value", GET_FULL_NAME(item));	
	local bodyGbox2_2 = GET_CHILD_RECURSIVELY(frame, "bodyGbox2_2")
		
	if IS_ENABLE_NOT_TAKE_MATERIAL_KIT(itemCls) then
		bodyGbox2_2:ShowWindow(0);
	else
		bodyGbox2_2:ShowWindow(1)
	end

end

function SET_OPTIONEXTRACT_RESET(frame)
--	reg:ShowWindow(0);
end;


function ITEMOPTIONEXTRACT_EXEC(frame)

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);

	if invItem == nil then
		return
	end

	local item = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID)

	local extractKitSlot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	local kitInvItem = GET_SLOT_ITEM(extractKitSlot);
	if kitInvItem == nil then
		ui.SysMsg(ClMsg("NotHaveExtractKitItem"));
		return;
	end

	local kitInvItemObj = GetIES(kitInvItem:GetObject());
	local clmsg = ScpArgMsg("ItemOptionExtractMessage_1")
	if item.PR == 0 then
		clmsg = ScpArgMsg("ItemOptionExtractMessage_2")
	elseif IS_ENABLE_NOT_TAKE_POTENTIAL_BY_EXTRACT_OPTION(kitInvItemObj) then
		--황금 키트
		clmsg = ScpArgMsg("ItemOptionExtractMessage_3")
	end

	WARNINGMSGBOX_FRAME_OPEN(clmsg, "_ITEMOPTIONEXTRACT_EXEC", "_ITEMOPTIONEXTRACT_CANCEL")
end

function _ITEMOPTIONEXTRACT_CANCEL()
	local frame = ui.GetFrame("itemoptionextract");
end;

function _ITEMOPTIONEXTRACT_EXEC(checkRebuildFlag)
	local frame = ui.GetFrame("itemoptionextract");
	local extractKitSlot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	local extractKitIcon = extractKitSlot:GetIcon();
	local extractKitIconInfo = extractKitIcon:GetInfo();
	if extractKitIconInfo == nil then
		return;
	end

	local extractKitItemCls = GetClassByType('Item', extractKitIconInfo.type);
	if extractKitItemCls == nil then
		return;
	end
	
	local isAbleExchange = frame:GetUserIValue("isAbleExchange")
	if IS_ENABLE_NOT_TAKE_MATERIAL_KIT(extractKitItemCls) == false and isAbleExchange == 0 then		
		--재료가 부족할때
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return
	end

	if isAbleExchange == -1 then
		--재료가 잠겨있을때
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return
	end

	if isAbleExchange == -2 then
		ui.SysMsg(ClMsg("MaxDurUnderflow")); 
		return
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end

	local item = GetIES(invItem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID)

	if checkRebuildFlag ~= false then
		if TryGetProp(item, 'Rebuildchangeitem', 0) > 0 then
			ui.MsgBox(ScpArgMsg('IfUDoCannotExchangeWeaponType'), '_ITEMOPTIONEXTRACT_EXEC(false)', 'None');
			return;
		end
	end
	
	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, "bodyGbox2")
	bodyGbox2:ShowWindow(0)
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, "bodyGbox3")
	bodyGbox3:ShowWindow(0)
	local resultGbox = GET_CHILD_RECURSIVELY(frame, "resultGbox")
	resultGbox:ShowWindow(1)

	local do_extract = GET_CHILD_RECURSIVELY(frame, "do_extract")
	do_extract:ShowWindow(0)
	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)

	local frame = ui.GetFrame("itemoptionextract");
	if frame:IsVisible() == 0 then
		return;
	end
	
		------------------------------
		-- extract 서버 스크립트 호출 부분--
		------------------------------

	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
	resultGbox:ShowWindow(0)

	local argList = string.format("%d", extractKitIconInfo.type);
	pc.ReqExecuteTx_Item("EXTRACT_ITEM_OPTION", invItem:GetIESID(), argList)
	
	return

end

function release_ui_lock()
    ui.SetHoldUI(false)
end

function SUCCESS_ITEM_OPTION_EXTRACT(frame)
	local frame = ui.GetFrame("itemoptionextract");
	local EXTRACT_RESULT_EFFECT_NAME = frame:GetUserConfig('EXTRACT_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	
	pic_bg:ShowWindow(1)
	pic_bg:PlayUIEffect(EXTRACT_RESULT_EFFECT_NAME, EFFECT_SCALE, 'EXTRACT_RESULT_EFFECT');

	local do_extract = GET_CHILD_RECURSIVELY(frame, "do_extract")
	do_extract:ShowWindow(0)
	ui.SetHoldUI(true);

    ReserveScript('release_ui_lock()', EFFECT_DURATION);
end

function _SUCCESS_ITEM_OPTION_EXTRACT()
	
	local frame = ui.GetFrame("itemoptionextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local EXTRACT_RESULT_EFFECT_NAME = frame:GetUserConfig('EXTRACT_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	pic_bg:StopUIEffect('EXTRACT_RESULT_EFFECT', true, 0.5);
	pic_bg:ShowWindow(0)

	local slot = GET_CHILD_RECURSIVELY(frame, "slot_result");

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)


	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(0)
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:ShowWindow(0)
	local text_material = GET_CHILD_RECURSIVELY(frame, "text_material")
	text_material : ShowWindow(0)
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3');
	bodyGbox3:ShowWindow(0)

	local gbox = frame:GetChild("gbox");

	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
	resultGbox:ShowWindow(1)
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg')
	local image_success = GET_CHILD_RECURSIVELY(frame, 'yellow_skin_success')
	local text_success = GET_CHILD_RECURSIVELY(frame, 'text_success')
	result_effect_bg:ShowWindow(1)
	image_success:ShowWindow(1)
	text_success:ShowWindow(1)

	local image_fail = GET_CHILD_RECURSIVELY(frame, 'yellow_skin_fail')
	local text_fail = GET_CHILD_RECURSIVELY(frame, 'text_fail')
	image_fail:ShowWindow(0)
	text_fail:ShowWindow(0)

	local resultItemImg = GET_CHILD_RECURSIVELY(frame, "result_item_img")
	resultItemImg:ShowWindow(1)

	local icor_img = frame:GetUserValue("icor_img")
	resultItemImg:SetImage(icor_img)
				
	EXTRACT_SUCCESS_EFFECT(frame)
end

function EXTRACT_SUCCESS_EFFECT(frame)
	local frame = ui.GetFrame("itemoptionextract");
	local EXTRACT_SUCCESS_EFFECT_NAME = frame:GetUserConfig('EXTRACT_SUCCESS_EFFECT');
	local SUCCESS_EFFECT_SCALE = tonumber(frame:GetUserConfig('SUCCESS_EFFECT_SCALE'));
	local SUCCESS_EFFECT_DURATION = tonumber(frame:GetUserConfig('SUCCESS_EFFECT_DURATION'));
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	pic_bg:ShowWindow(0)


	result_effect_bg:PlayUIEffect(EXTRACT_SUCCESS_EFFECT_NAME, SUCCESS_EFFECT_SCALE, 'EXTRACT_SUCCESS_EFFECT');

	ReserveScript("_EXTRACT_SUCCESS_EFFECT()", SUCCESS_EFFECT_DURATION)
end

function  _EXTRACT_SUCCESS_EFFECT()
	local frame = ui.GetFrame("itemoptionextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end
	result_effect_bg:StopUIEffect('EXTRACT_SUCCESS_EFFECT', true, 0.5);
	ui.SetHoldUI(false);
end

function FAIL_ITEM_OPTION_EXTRACT(frame)
	local EXTRACT_RESULT_EFFECT_NAME = frame:GetUserConfig('EXTRACT_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end

	pic_bg:PlayUIEffect(EXTRACT_RESULT_EFFECT_NAME, EFFECT_SCALE, 'EXTRACT_RESULT_EFFECT');

	local do_extract = GET_CHILD_RECURSIVELY(frame, "do_extract")
	do_extract:ShowWindow(0)
	ui.SetHoldUI(true);
    ReserveScript('release_ui_lock()', EFFECT_DURATION);
end

function RUN_FAIL_EFFECT()
    ReserveScript("_FAIL_ITEM_OPTION_EXTRACT()", 0)
end

function RUN_SUCCESS_EFFECT()
    ReserveScript("_SUCCESS_ITEM_OPTION_EXTRACT()", 0)
end

function _FAIL_ITEM_OPTION_EXTRACT()
	
	local frame = ui.GetFrame("itemoptionextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "slot");	


	local EXTRACT_RESULT_EFFECT_NAME = frame:GetUserConfig('EXTRACT_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	pic_bg : StopUIEffect('EXTRACT_RESULT_EFFECT', true, 0.5);

	pic_bg:ShowWindow(1)

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)


	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:ShowWindow(0)
	local bodyGbox2_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2_1');
	bodyGbox2_1:ShowWindow(0)
	local text_material = GET_CHILD_RECURSIVELY(frame, "text_material")
	text_material:ShowWindow(0)
	local bodyGbox3 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox3');
	bodyGbox3:ShowWindow(0)

	local gbox = frame:GetChild("gbox");

	local resultGbox = GET_CHILD_RECURSIVELY(frame, 'resultGbox')
	resultGbox:ShowWindow(1)
	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg')
	local image_success = GET_CHILD_RECURSIVELY(frame, 'yellow_skin_success')
	local text_success = GET_CHILD_RECURSIVELY(frame, 'text_success')
	result_effect_bg:ShowWindow(0)
	image_success:ShowWindow(0)
	text_success:ShowWindow(0)
	local slot_result = GET_CHILD_RECURSIVELY(frame, 'slot_result')
	slot_result:ClearIcon()

	local bodyGbox1_1 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox1_1')
--	bodyGbox1_1:ShowWindow(0)
	local text_potential = GET_CHILD_RECURSIVELY(frame, "text_potential")
--	text_potential:ShowWindow(0)
	local gauge_potential = GET_CHILD_RECURSIVELY(frame, "gauge_potential")
	--gauge_potential:ShowWindow(0)
	local image_fail = GET_CHILD_RECURSIVELY(frame, 'yellow_skin_fail')
	local text_fail = GET_CHILD_RECURSIVELY(frame, 'text_fail')
	image_fail:ShowWindow(1)
	text_fail:ShowWindow(1)
	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(1)
	local itemName = GET_CHILD_RECURSIVELY(frame, "text_itemname")
	itemName:SetText("")

	local putOnItem = GET_CHILD_RECURSIVELY(frame, "text_putonitem")
	putOnItem:ShowWindow(0)

	local invItem = GET_SLOT_ITEM(slot);
	
	local isDestroy = 0
	if invItem == nil then
		isDestroy = 1
		slot:ClearIcon()
		bodyGbox1_1:ShowWindow(0)
		text_potential:ShowWindow(0)
		gauge_potential:ShowWindow(0)
		local destroy_gbox = GET_CHILD_RECURSIVELY(frame, 'destroy_gbox')
		destroy_gbox:ShowWindow(1)
	else
		isDestroy = 0
		local obj = GetIES(invItem:GetObject());
		gauge_potential:SetPoint(obj.PR, obj.MaxPR);
	end

	EXTRACT_FAIL_EFFECT(frame, isDestroy)
	
	return
end


function EXTRACT_FAIL_EFFECT(frame, isDestroy)
	local frame = ui.GetFrame("itemoptionextract");
	local EXTRACT_FAIL_EFFECT_NAME = frame:GetUserConfig('EXTRACT_FAIL_EFFECT');
	local FAIL_EFFECT_SCALE = tonumber(frame:GetUserConfig('FAIL_EFFECT_SCALE'));
	local FAIL_EFFECT_DURATION = tonumber(frame:GetUserConfig('FAIL_EFFECT_DURATION'));
	local result_fail_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_fail_effect_bg');
	if result_fail_effect_bg == nil then
		return;
	end
	local resultItemImg = GET_CHILD_RECURSIVELY(frame, "result_item_img")

	resultItemImg:ShowWindow(0)
	result_fail_effect_bg:PlayUIEffect(EXTRACT_FAIL_EFFECT_NAME, FAIL_EFFECT_SCALE, 'EXTRACT_FAIL_EFFECT');

	ReserveScript("_EXTRACT_FAIL_EFFECT()", FAIL_EFFECT_DURATION)
end

function  _EXTRACT_FAIL_EFFECT()
	local frame = ui.GetFrame("itemoptionextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local result_fail_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_fail_effect_bg');
	if result_fail_effect_bg == nil then
		return;
	end

	result_fail_effect_bg:StopUIEffect('EXTRACT_FAIL_EFFECT', true, 0.5);
	ui.SetHoldUI(false);
end


function REMOVE_OPTIONEXTRACT_TARGET_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "slot");
	slot:ClearIcon();
	CLEAR_ITEMOPTIONEXTRACT_UI()
end

function REMOVE_OPTIONEXTRACT_KIT_TARGET_ITEM(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	slot:ClearIcon();

	local bodyGbox2_2 = GET_CHILD_RECURSIVELY(frame, "bodyGbox2_2")
	bodyGbox2_2:ShowWindow(1)

	local extractKitName = GET_CHILD_RECURSIVELY(frame, "extractKitName")
	extractKitName:SetTextByKey("value", frame:GetUserConfig("EXTRACT_KIT_DEFAULT"))
end


function ITEMOPTIONEXTRACT_INV_RBTN(itemObj, slot)
	local frame = ui.GetFrame("itemoptionextract");
	if frame == nil then
		return
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	local extractSlot = GET_CHILD_RECURSIVELY(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(extractSlot);
	
	if extractSlot:GetIcon() == nil then

		CLEAR_ITEMOPTIONEXTRACT_UI()
		ITEM_OPTIONEXTRACT_REG_TARGETITEM(frame, iconInfo:GetIESID()); 
	elseif icon ~= nil then
		local extractKitSlot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot")
		local extractKitIcon = extractKitSlot:GetIcon()
		
		ITEM_OPTIONEXTRACT_KIT_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end

end
