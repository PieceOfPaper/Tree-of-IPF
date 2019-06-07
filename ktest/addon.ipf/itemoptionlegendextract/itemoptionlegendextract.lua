
function ITEMOPTIONLEGENDEXTRACT_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_ITEMOPTIONLEGENDEXTRACT", "ON_OPEN_DLG_ITEM_OPTION_LEGEND_EXTRACT");

	--성공시 UI 호출
	addon:RegisterMsg("MSG_SUCCESS_ITEM_OPTION_LEGEND_EXTRACT", "SUCCESS_ITEM_OPTION_LEGEND_EXTRACT");
	--실패시 UI 호출
	addon:RegisterMsg("MSG_FAIL_ITEM_OPTION_LEGEND_EXTRACT", "FAIL_ITEM_OPTION_LEGEND_EXTRACT");
end

function OPEN_ITEM_OPTION_LEGEND_EXTRACT()
	ui.OpenFrame("itemoptionlegendextract");
end

function ON_OPEN_DLG_ITEM_OPTION_LEGEND_EXTRACT(frame)
	frame:ShowWindow(1);	
end

function ITEMOPTION_LEGEND_EXTRACT_OPEN(frame)
	ui.CloseFrame('rareoption');
	CLEAR_ITEMOPTION_LEGEND_EXTRACT_UI()
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMOPTION_LEGEND_EXTRACT_INV_RBTN")	
	ui.OpenFrame("inventory");	
end

function ITEMOPTION_LEGEND_EXTRACT_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	RESET_INVENTORY_ICON();
	
	ui.CloseFrame("itemoptionlegendextract");
	ui.CloseFrame("inventory");
end

-- 전체 UI초기화
function CLEAR_ITEMOPTION_LEGEND_EXTRACT_UI()
	if ui.CheckHoldedUI() == true then
		return;
	end

	RESET_INVENTORY_ICON();

	local frame = ui.GetFrame("itemoptionlegendextract");
	frame:SetUserValue("ITEM_EQUIP_CLASSTYPE", "None");
	frame:SetUserValue("TARGET_ITEM_COUNT", 0);
	frame:SetUserValue("isAbleExchange", 0)
	frame:SetUserValue("isRandOption", 0)
	frame:SetUserValue("MATERIAL_ITEM_COUNT", 0)
	frame:SetUserValue("MATERIAL_ITEM_HIGH_GRAD_ITEM_GUID", 0)
	frame:SetUserValue("RATIO", 0)
	frame:SetUserValue("RESULT_ICOR_GUID", "None")
	
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	pic_bg:ShowWindow(1);

	-- 아이템 슬롯 3칸
	local targetitemslot_1 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_1", "ui::CSlot");
	targetitemslot_1:ClearIcon();
	targetitemslot_1:SetUserValue("SELECTED_INV_GUID", "None");
	targetitemslot_1:SetUserValue("TARGET_ITEM_PR", -1);
	ITEMOPTION_LEGEND_EXTRACT_SET_SLOT_ITEM(targetitemslot_1, 0);
	local targetitemslot_1_bg = GET_CHILD_RECURSIVELY(frame, "targetitemslot_1_bg")
	targetitemslot_1_bg:ShowWindow(1);

	local targetitemslot_2 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_2", "ui::CSlot");
	targetitemslot_2:ClearIcon();	
	targetitemslot_2:SetUserValue("SELECTED_INV_GUID", "None");
	targetitemslot_2:SetUserValue("TARGET_ITEM_PR", -1);
	ITEMOPTION_LEGEND_EXTRACT_SET_SLOT_ITEM(targetitemslot_2, 0);
	local targetitemslot_2_bg = GET_CHILD_RECURSIVELY(frame, "targetitemslot_2_bg")
	targetitemslot_2_bg:ShowWindow(1);

	local targetitemslot_3 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_3", "ui::CSlot");
	targetitemslot_3:ClearIcon();
	targetitemslot_3:SetUserValue("SELECTED_INV_GUID", "None");
	targetitemslot_3:SetUserValue("TARGET_ITEM_PR", -1);
	ITEMOPTION_LEGEND_EXTRACT_SET_SLOT_ITEM(targetitemslot_3, 0);
	local targetitemslot_3_bg = GET_CHILD_RECURSIVELY(frame, "targetitemslot_3_bg")
	targetitemslot_3_bg:ShowWindow(1);

	local putonitembg = GET_CHILD_RECURSIVELY(frame, "putonitembg")
	putonitembg:ShowWindow(1);

	-- 아이커 슬롯
	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result", "ui::CSlot");
	slot_result:ClearIcon();
	slot_result:ShowWindow(0);

	local ratiobg = GET_CHILD_RECURSIVELY(frame, "ratiobg")
	ratiobg:ShowWindow(0);

	-- 연성 옵션
	local questionmark = GET_CHILD_RECURSIVELY(frame, "questionmark")
	questionmark:ShowWindow(0);	

	local gBox = GET_CHILD_RECURSIVELY(frame, "extractoptioncaption")
	gBox:RemoveChild('tooltip_equip_property');
	gBox:Resize(gBox:GetWidth(), 0)

	-- 기타 UI
	local downArrowPic = GET_CHILD_RECURSIVELY(frame, "downArrowPic")
	downArrowPic:ShowWindow(0);	

	local send_ok = GET_CHILD_RECURSIVELY(frame, "send_ok")
	send_ok:ShowWindow(0);

	local do_extract = GET_CHILD_RECURSIVELY(frame, "do_extract")
	do_extract:ShowWindow(1)

	-- 재료
	local materialgb = GET_CHILD_RECURSIVELY(frame, 'materialgb')
	materialgb:ShowWindow(1);

	local extractKitSlot = GET_CHILD_RECURSIVELY(frame, 'extractKitSlot')
	extractKitSlot:ClearIcon();

	local extractKitName = GET_CHILD_RECURSIVELY(frame, 'extractKitName')
	extractKitName:SetTextByKey("value", frame:GetUserConfig("EXTRACT_KIT_DEFAULT"))

	local extractkitgb = GET_CHILD_RECURSIVELY(frame, 'extractkitgb')
	extractkitgb:ShowWindow(0);

	local material_2gb = GET_CHILD_RECURSIVELY(frame, "material_2gb")
	material_2gb:ShowWindow(0);

	-- 결과 
	local result_gb = GET_CHILD_RECURSIVELY(frame, "result_gb")
	result_gb:ShowWindow(0)

	local destroy_gb = GET_CHILD_RECURSIVELY(frame, "destroy_gb")
	destroy_gb:ShowWindow(0)
	
end

-- 인벤토리에서 마우스 오른쪽 버튼 클릭
function ITEMOPTION_LEGEND_EXTRACT_INV_RBTN(itemobj, invslot, invguid)
	local frame = ui.GetFrame("itemoptionlegendextract");
	if frame == nil then
		return
	end

	if ui.CheckHoldedUI() == true then
		return;
	end

	if invslot:IsSelected() == 1 then
		CLEAR_ITEMOPTION_LEGEND_EXTRACT_UI()
	else
		local slot1 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_1");
		local targetguid1 = slot1:GetUserValue("SELECTED_INV_GUID");
		local slot2 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_2");
		local targetguid2 = slot2:GetUserValue("SELECTED_INV_GUID");
		local slot3 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_3");
		local targetguid3 = slot3:GetUserValue("SELECTED_INV_GUID");
	
		local invitem = session.GetInvItemByGuid(invguid)
		if invitem == nil then
			return;
		end
	
		-- 잠겨있는 아이템인지 확인
		if true == invitem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return;
		end
	
		if targetguid1 == "None" then
			ITEM_OPTION_LEGEND_EXTRACT_REG_TARGETITEM(frame, 1, itemobj, invslot, invguid)
		elseif targetguid2 == "None" then
			ITEM_OPTION_LEGEND_EXTRACT_REG_TARGETITEM(frame, 2, itemobj, invslot, invguid)
		elseif targetguid3 == "None" then
			ITEM_OPTION_LEGEND_EXTRACT_REG_TARGETITEM(frame, 3, itemobj, invslot, invguid)
		elseif targetguid1 ~= "None" and targetguid2 ~= "None" and targetguid3 ~= "None" then
			LEGEND_OPTION_EXTRACT_KIT_REG_TARGET_ITEM(frame, invguid);
		else			
			CLEAR_ITEMOPTION_LEGEND_EXTRACT_UI()
		end
	
	end

end

function ITEM_OPTION_LEGEND_EXTRACT_DROP(frame, slot, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	frame = frame:GetTopParentFrame();

	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local guid = iconInfo:GetIESID();
		local invitem = session.GetInvItemByGuid(guid)
		local itemobj = GetIES(invitem:GetObject());

		ITEM_OPTION_LEGEND_EXTRACT_REG_TARGETITEM(frame, argNum, itemobj, liftIcon:GetParent(), guid)
	end
	
end

-- 슬롯에 아이템 등록
function ITEM_OPTION_LEGEND_EXTRACT_REG_TARGETITEM(frame, argNum, itemobj, invslot, guid)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local invitem = session.GetInvItemByGuid(guid)
	if invitem == nil then
		return;
	end

	-- 잠겨있는 아이템인지 확인
	if true == invitem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	-- 이미 등록된 아이템인지 확인
	if ITEMOPTION_LEGEND_EXTRACT_GET_TARGETITEM_LIST(frame, argNum, guid) == false then
		ui.SysMsg(ClMsg('AlreadyEqualItemRegistered'));
		return;
	end

	-- 연성 가능한 아이템인지 확인
	if IS_ENABLE_EXTRACT_OPTION(itemobj) ~= true then
		ui.SysMsg(ClMsg("NotAllowedItemOptionExtract"));
		return;
	end

	local targetitemcount = frame:GetUserIValue("TARGET_ITEM_COUNT");
	local frameItemEquipClassType = frame:GetUserValue("ITEM_EQUIP_CLASSTYPE");
	if frameItemEquipClassType == "None" then
		frame:SetUserValue("ITEM_EQUIP_CLASSTYPE", itemobj.ClassType);		
	else
		if frameItemEquipClassType ~= itemobj.ClassType then
			ui.SysMsg(ClMsg("IcorductilityError01"))
			return;
		end
	end
	
	-- 등록 시작
	local targetslot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..argNum);
	SET_SLOT_ITEM(targetslot, invitem);
	targetslot:SetUserValue("TARGET_ITEM_PR", itemobj.PR);		
	targetslot:SetUserValue("SELECTED_INV_GUID", guid);

	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..argNum.."_bg")
	slot_bg_image:ShowWindow(0)
	
	ITEMOPTION_LEGEND_EXTRACT_SET_SLOT_ITEM(invslot, 1);

	-- 랜덤 옵션 유무 확인
	local maxRandomOptionCnt = 6;
	local CurrentRandomOptionCnt = 0;
	for i = 1, maxRandomOptionCnt do
		if itemobj['RandomOption_'..i] ~= 'None' then
			CurrentRandomOptionCnt = CurrentRandomOptionCnt +1;
		end
	end

	if CurrentRandomOptionCnt > 0 then	
		frame:SetUserValue("isRandOption", 0)
	else
		frame:SetUserValue("isRandOption", 1)
	end

	targetitemcount = targetitemcount + 1;
	frame:SetUserValue("TARGET_ITEM_COUNT", targetitemcount);

	-- 아이템 3개가 모두 등록됬을 경우
	if targetitemcount == 3 then
		_ITEM_OPTION_LEGEND_EXTRACT_REGISTER_ITEM(frame, itemobj)
	end

end

-- 인벤토리에 아이템 표시
function ITEMOPTION_LEGEND_EXTRACT_SET_SLOT_ITEM(slot, isSelect)
	if isSelect == 1 then
		slot:SetSelectedImage('socket_slot_check');
		slot:Select(1);
	else
		local guid = slot:GetUserValue("SELECTED_INV_GUID");
		if guid == 'None' then
			return;
		end
		SELECT_INV_SLOT_BY_GUID(guid, 0);
	end
end

-- 이미 등록된 아이템인지 확인
function ITEMOPTION_LEGEND_EXTRACT_GET_TARGETITEM_LIST(frame, argNum, guid)	
	for i = 1, 3 do
		local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..i);
		local targetguid = slot:GetUserValue("SELECTED_INV_GUID");

		if (guid == targetguid) and (i ~= argNum)then
			return false
		end
	end

	return true;
end

-- 아이템 등록 해제
function REMOVE_OPTION_LEGEND_EXTRACT_TARGET_ITEM(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();

	-- 아이커 슬롯 관련
	local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..argNum);
	slot:ClearIcon();
	ITEMOPTION_LEGEND_EXTRACT_SET_SLOT_ITEM(slot, 0);
	slot:SetUserValue("SELECTED_INV_GUID", "None");
	slot:SetUserValue("TARGET_ITEM_PR", -1);
	
	local slot_bg_image = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..argNum.."_bg")
	slot_bg_image:ShowWindow(1)

	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result", "ui::CSlot");
	slot_result:ClearIcon();
	slot_result:ShowWindow(0);

	-- 확률 UI
	local ratiobg = GET_CHILD_RECURSIVELY(frame, "ratiobg")
	ratiobg:ShowWindow(0);

	-- 기타 UI
	local downArrowPic = GET_CHILD_RECURSIVELY(frame, "downArrowPic")
	downArrowPic:ShowWindow(0);

	local putonitembg = GET_CHILD_RECURSIVELY(frame, "putonitembg")
	putonitembg:ShowWindow(1);

	-- 재료 UI
	local extractKitSlot = GET_CHILD_RECURSIVELY(frame, 'extractKitSlot')
	extractKitSlot:ClearIcon();

	local extractKitName = GET_CHILD_RECURSIVELY(frame, 'extractKitName')
	extractKitName:SetTextByKey("value", frame:GetUserConfig("EXTRACT_KIT_DEFAULT"))

	local extractkitgb = GET_CHILD_RECURSIVELY(frame, 'extractkitgb')
	extractkitgb:ShowWindow(0);

	local material_2gb = GET_CHILD_RECURSIVELY(frame, "material_2gb")
	material_2gb:ShowWindow(0);

	-- 아이커 옵션
	local questionmark = GET_CHILD_RECURSIVELY(frame, "questionmark")
	questionmark:ShowWindow(0);	

	local gBox = GET_CHILD_RECURSIVELY(frame, "extractoptioncaption")
	gBox:RemoveChild('tooltip_equip_property');
	gBox:Resize(gBox:GetWidth(), 0)

	-- frame UserValue
	frame:SetUserValue("RATIO", 0)

	local targetitemcount = frame:GetUserIValue("TARGET_ITEM_COUNT");
	targetitemcount = targetitemcount - 1;
	frame:SetUserValue("TARGET_ITEM_COUNT", targetitemcount);

	if targetitemcount == 0 then
		frame:SetUserValue("ITEM_EQUIP_CLASSTYPE", "None");
	end
end

-- 3개의 아이템 등록시 호출
function _ITEM_OPTION_LEGEND_EXTRACT_REGISTER_ITEM(frame, itemobj)
	-- 아이커 이미지 관련
	local slot_result = GET_CHILD_RECURSIVELY(frame, "slot_result");
	slot_result:ShowWindow(1);

	local icor_img = nil;
	if itemobj.GroupName == "Weapon" or itemobj.GroupName == "SubWeapon" then
		icor_img = frame:GetUserConfig("ICOR_IMAGE_WEAPON")
	else
		icor_img = frame:GetUserConfig("ICOR_IMAGE_ARMOR")
	end
	
	SET_SLOT_IMG(slot_result, icor_img)
	frame:SetUserValue("icor_img", icor_img)

	-- 확률 UI
	local ratiobg = GET_CHILD_RECURSIVELY(frame, "ratiobg")
	ratiobg:ShowWindow(1);
	
	local text_Ratio = GET_CHILD_RECURSIVELY(frame, "text_Ratio")
	imcRichText:SetColorBlend(text_Ratio, true, 2,  0xFFFFFFFF, 0xFFFFBB00);
	text_Ratio:ShowWindow(1);

	local ratio = OPTION_LEGEND_EXTRACT_RATIO_CALCULATE(frame);
	text_Ratio:SetTextByKey('ratio', ratio);

	-- 기타 UI 
	local downArrowPic = GET_CHILD_RECURSIVELY(frame, "downArrowPic")
	downArrowPic:ShowWindow(1);

	local putonitembg = GET_CHILD_RECURSIVELY(frame, "putonitembg")
	putonitembg:ShowWindow(0);

	-- 아이커 옵션 출력 여부 체크
	LEGEND_EXTRACT_REGISTER_OPTION(frame)

	-- 재료 UI 출력 및 재료 체크
	OPTION_LEGEND_EXTRACT_REGISTER_MATERIAL(frame)	

end

--확률 계산
function OPTION_LEGEND_EXTRACT_RATIO_CALCULATE(frame)
	local targetitemPrAllAdd = 0;
	local targetitemMaxPrAllAdd = 0;
	
	for i = 1, 3 do
		local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..i);
		local targetguid = slot:GetUserValue("SELECTED_INV_GUID");
		local invitem = session.GetInvItemByGuid(targetguid)
		local itemobj = GetIES(invitem:GetObject());
		
		if itemobj == nil then
			return;
		end

		targetitemPrAllAdd = targetitemPrAllAdd + itemobj.PR;
		targetitemMaxPrAllAdd = targetitemMaxPrAllAdd + itemobj.MaxPR;		
	end

	local ratio = targetitemPrAllAdd / targetitemMaxPrAllAdd;
	ratio = ratio * 100;
	
	local string = string.format("%3.0f", ratio);
	frame:SetUserValue("RATIO", ratio)

	return string;
end

-- 재료 관련 
function OPTION_LEGEND_EXTRACT_REGISTER_MATERIAL(frame)

	-- 연성 키트
	local extractkitgb = GET_CHILD_RECURSIVELY(frame, 'extractkitgb')
	extractkitgb:ShowWindow(1)

	-- 시에라 가루
	-- 3개의 아이템중 가장 높은 등급을 기준으로 재료 선정
	local isAbleExchange = 1;
	local materialItemCount = 0;
	local grade = 0;
	local itemobj;

	for i = 1, 3 do
		local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..i);
		local targetguid = slot:GetUserValue("SELECTED_INV_GUID");
		local targetinvitem = session.GetInvItemByGuid(targetguid)
		local targetitemobj = GetIES(targetinvitem:GetObject());

		if grade < targetitemobj.ItemGrade then
			grade = targetitemobj.ItemGrade;
			itemobj = targetitemobj;

			materialItemCount = GET_OPTION_LEGEND_EXTRACT_NEED_MATERIAL_COUNT(itemobj)
			frame:SetUserValue("MATERIAL_ITEM_COUNT", materialItemCount)
			frame:SetUserValue("MATERIAL_ITEM_HIGH_GRAD_ITEM_GUID", targetguid)
		end
	end
	
	local materialItemSlot = 1;
	local i = 1;	

	local material_2gb = GET_CHILD_RECURSIVELY(frame, "material_2gb")
	material_2gb:ShowWindow(1)
	local materialClsCtrl = material_2gb:CreateOrGetControlSet('eachmaterial_in_itemoptionextract', 'MATERIAL_CSET_'..i, 0, 0);
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
	if itemobj ~= nil then
		local materialCls = GetClass("Item", GET_OPTION_LEGEND_EXTRACT_MATERIAL_NAME());
		if i <= materialItemSlot and materialCls ~= 'None' then
			
			local pc = GetMyPCObject();
			if pc == nil then
				return;
			end
		
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

	material_icon:SetImage(itemIcon)
	material_name:SetText(materialItemName)

	frame:SetUserValue("isAbleExchange", isAbleExchange)

end

-- 아이커 옵션 출력 여부 체크
function LEGEND_EXTRACT_REGISTER_OPTION(frame)
	local isRandOption = frame:GetUserValue("isRandOption");
	if isRandOption == 0 then
		local questionmark = GET_CHILD_RECURSIVELY(frame, "questionmark")
		questionmark:ShowWindow(1);
		return;
	end

	-- 3개의 아이템이 동일한지 확인
	local ClassNameList = {}
	for i = 1, 3 do
		local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..i);
		local targetguid = slot:GetUserValue("SELECTED_INV_GUID");
		local invitem = session.GetInvItemByGuid(targetguid)
		local itemobj = GetIES(invitem:GetObject());
		if itemobj == nil then
			return;
		end

		ClassNameList[i] = itemobj.ClassName;
	end

	if ClassNameList[1] == ClassNameList[2] and ClassNameList[1] == ClassNameList[3] then
		local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_1");
		local targetguid = slot:GetUserValue("SELECTED_INV_GUID");
		local invitem = session.GetInvItemByGuid(targetguid)
		local invitemobj = GetIES(invitem:GetObject());

		OPTION_LEGEND_EXTRACT_REGISTER_EXTRACTION_OPTION_CAPTION(frame, invitemobj, 0);
	else
		-- 3개의 아이템이 동일하지 않음, ?표시 출력
		local questionmark = GET_CHILD_RECURSIVELY(frame, "questionmark")
		questionmark:ShowWindow(1);
	end
	

end

-- 연성 키트 등록
function OPTION_LEGEND_EXTRACT_EXTRACTKIT_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();

	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local guid = iconInfo:GetIESID();
		LEGEND_OPTION_EXTRACT_KIT_REG_TARGET_ITEM(toFrame, guid);
	end;
end;

function LEGEND_OPTION_EXTRACT_KIT_REG_TARGET_ITEM(frame, guid)
	local invitem = session.GetInvItemByGuid(guid)
	if invitem == nil then
		return;
	end

	local item = GetIES(invitem:GetObject());
	local itemCls = GetClassByType('Item', item.ClassID)

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	-- 키트 조건 확인
	if IS_VALID_OPTION_LEGEND_EXTRACT_KIT(itemCls) ~= true then
		ui.SysMsg(ClMsg("IsNotOptionExtractKit"));
		return
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	SET_SLOT_ITEM(slot, invitem);
	local extractKitName = GET_CHILD_RECURSIVELY(frame, "extractKitName", "ui::CRichText")
	extractKitName:SetTextByKey("value", GET_FULL_NAME(item));	
	local material_2gb = GET_CHILD_RECURSIVELY(frame, "material_2gb")
		
	if IS_ENABLE_NOT_TAKE_MATERIAL_KIT_LEGEND_EXTRACT(itemCls) then
		material_2gb:ShowWindow(0);
	else
		material_2gb:ShowWindow(1)
	end

end

-- 연성 키트 등록 취소
function REMOVE_OPTION_LEGEND_EXTRACT_KIT_TARGET_ITEM(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	slot:ClearIcon();

	local material_2gb = GET_CHILD_RECURSIVELY(frame, "material_2gb")
	material_2gb:ShowWindow(1)

	local extractKitName = GET_CHILD_RECURSIVELY(frame, "extractKitName")
	extractKitName:SetTextByKey("value", frame:GetUserConfig("EXTRACT_KIT_DEFAULT"))

end

-- 연성 버튼 눌렀을 때 
function OPTION_LEGEND_EXTRACT_EXEC(frame)
	frame = frame:GetTopParentFrame();

	-- 3개의 슬롯 모두 아이템이 진짜 있는지 확인
	local maxtargetitemcount = frame:GetUserConfig("MAX_TARGET_ITEM_COUNT");
	local iszeroPR = false;
	for i = 1, maxtargetitemcount do
		local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..i);
		local targetguid = slot:GetUserValue("SELECTED_INV_GUID");
		if targetguid == "None" then
			ui.SysMsg("아이템 부족");
			return;
		end
	end

	-- 키트 확인
	local extractkitslot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	local kitinvitem = GET_SLOT_ITEM(extractkitslot);
	if kitinvitem == nil then
		ui.SysMsg(ClMsg("NotHaveExtractKitItem"));
		return;
	end
	
	local clmsg = ScpArgMsg("ItemOptionLegendExtractMessage_2");
	local ratio = frame:GetUserValue("RATIO")	
	if ratio == "100" then
		clmsg = ScpArgMsg("ItemOptionLegendExtractMessage_1")
	end

	WARNINGMSGBOX_FRAME_OPEN(clmsg, "_LEGEND_OPTION_EXTRACT_EXEC", "_OPTION_LEGEND_EXTRACT_CANCEL")

end

function _LEGEND_OPTION_EXTRACT_EXEC()
	local frame = ui.GetFrame("itemoptionlegendextract");
	local extractKitSlot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	local extractKitIcon = extractKitSlot:GetIcon();
	local extractKitIconInfo = extractKitIcon:GetInfo();
	if extractKitIconInfo == nil then
	 	return;
	end
	
	-- 3개의 슬롯 모두 아이템이 진짜 있는지 확인
	local maxtargetitemcount = frame:GetUserConfig("MAX_TARGET_ITEM_COUNT");
	for i = 1, maxtargetitemcount do
		local slot = GET_CHILD_RECURSIVELY(frame, "targetitemslot_"..i);
		local targetguid = slot:GetUserValue("SELECTED_INV_GUID");
		if targetguid == "None" then
			ui.SysMsg("아이템 부족");
			return;
		end
	end

	-- 키트 확인
	local extractkitslot = GET_CHILD_RECURSIVELY(frame, "extractKitSlot");
	local kitinvitem = GET_SLOT_ITEM(extractkitslot);
	local kititem = GetIES(kitinvitem:GetObject());
	if kitinvitem == nil then
		ui.SysMsg(ClMsg("NotHaveExtractKitItem"));
		return;
	end

	-- 재료 확인	
	local isAbleExchange = frame:GetUserIValue("isAbleExchange")
	if IS_ENABLE_NOT_TAKE_MATERIAL_KIT_LEGEND_EXTRACT(kititem) == false and isAbleExchange == 0 then		
		--재료 부족
		ui.SysMsg(ClMsg('NotEnoughRecipe'));
		return
	end

	if isAbleExchange == -1 then
		--재료 잠김
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return
	end

	if isAbleExchange == -2 then
		ui.SysMsg(ClMsg("MaxDurUnderflow")); 
		return
	end
	
	local materialgb = GET_CHILD_RECURSIVELY(frame, "materialgb")
	materialgb:ShowWindow(0)

	local do_extract = GET_CHILD_RECURSIVELY(frame, "do_extract")
	do_extract:ShowWindow(0)

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)

	-- 아이커 연성 시스템 로직 호출
    local slot1 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_1");
	local targetguid1 = slot1:GetUserValue("SELECTED_INV_GUID");
    local slot2 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_2");
	local targetguid2 = slot2:GetUserValue("SELECTED_INV_GUID");
    local slot3 = GET_CHILD_RECURSIVELY(frame, "targetitemslot_3");
	local targetguid3 = slot3:GetUserValue("SELECTED_INV_GUID");
    local argList = string.format("%d", extractKitIconInfo.type);
	pc.ReqExecuteTx_Item2("LEGEND_EXTRACT_ITEM_OPTION", tostring(targetguid1), tostring(targetguid2), tostring(targetguid3), argList)

end

function _OPTION_LEGEND_EXTRACT_CANCEL()

end

-- 연성 성공
function SUCCESS_ITEM_OPTION_LEGEND_EXTRACT(pc, msgname, argStr, argNum)
	local frame = ui.GetFrame("itemoptionlegendextract");
	frame:SetUserValue("RESULT_ICOR_GUID", argStr)

	-- 연성 성공 이미지 출력
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end

	_SUCCESS_ITEM_OPTION_LEGEND_EXTRACT();
end

function _SUCCESS_ITEM_OPTION_LEGEND_EXTRACT()
	local frame = ui.GetFrame("itemoptionlegendextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end

	local sendOK = GET_CHILD_RECURSIVELY(frame, "send_ok")
	sendOK:ShowWindow(1)

	local result_gb = GET_CHILD_RECURSIVELY(frame, 'result_gb')
	result_gb:ShowWindow(1)

	local destroy_gb = GET_CHILD_RECURSIVELY(frame, 'destroy_gb')
	destroy_gb:ShowWindow(0)	
	
	local resultItemImg = GET_CHILD_RECURSIVELY(frame, "result_item_img")
	resultItemImg:ShowWindow(1)

	local icor_img = frame:GetUserValue("icor_img")
	resultItemImg:SetImage(icor_img)
	
	LEGEND_EXTRACT_SUCCESS_EFFECT(frame)

	-- 연성 옵션 내용 출력, 아이커 기준	
	local guid = frame:GetUserValue("RESULT_ICOR_GUID");
	local invitem = session.GetInvItemByGuid(guid)
	local invitemobj = GetIES(invitem:GetObject());
	local targetItem = GetClass('Item', invitemobj.InheritanceItemName);

    if targetItem == nil then
        targetItem = GetClass('Item', invitemobj.InheritanceRandomItemName);
    end 

	if targetItem == nil then
		return;
	end
	
	OPTION_LEGEND_EXTRACT_REGISTER_EXTRACTION_OPTION_CAPTION(frame, targetItem, invitemobj)

	return
end

function LEGEND_EXTRACT_SUCCESS_EFFECT(frame)
	local frame = ui.GetFrame("itemoptionlegendextract");
	local EXTRACT_SUCCESS_EFFECT_NAME = frame:GetUserConfig('LEGEND_EXTRACT_SUCCESS_EFFECT');
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

	result_effect_bg:PlayUIEffect(EXTRACT_SUCCESS_EFFECT_NAME, SUCCESS_EFFECT_SCALE, 'LEGEND_EXTRACT_SUCCESS_EFFECT');

	ReserveScript("_LEGEND_EXTRACT_SUCCESS_EFFECT()", SUCCESS_EFFECT_DURATION)
end

function _LEGEND_EXTRACT_SUCCESS_EFFECT()
	local frame = ui.GetFrame("itemoptionlegendextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local result_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_effect_bg');
	if result_effect_bg == nil then
		return;
	end
	result_effect_bg:StopUIEffect('LEGEND_EXTRACT_SUCCESS_EFFECT', true, 0.5);
	ui.SetHoldUI(false);
end

-- 연성 실패
function FAIL_ITEM_OPTION_LEGEND_EXTRACT(frame)
	frame = ui.GetFrame("itemoptionlegendextract");
	
	local EXTRACT_RESULT_EFFECT_NAME = frame:GetUserConfig('EXTRACT_RESULT_EFFECT');
	local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));
	local EFFECT_DURATION = tonumber(frame:GetUserConfig('EFFECT_DURATION'));

	-- 연성 실패 이미지 출력
	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end

	pic_bg:ShowWindow(1);
	_FAIL_ITEM_OPTION_LEGEND_EXTRACT()
end

function _FAIL_ITEM_OPTION_LEGEND_EXTRACT()
	local frame = ui.GetFrame("itemoptionlegendextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local pic_bg = GET_CHILD_RECURSIVELY(frame, 'pic_bg');
	if pic_bg == nil then
		return;
	end
	pic_bg:ShowWindow(1);

	local result_gb = GET_CHILD_RECURSIVELY(frame, 'result_gb')
	result_gb:ShowWindow(0)

	local result_gb = GET_CHILD_RECURSIVELY(frame, 'destroy_gb')
	result_gb:ShowWindow(1)	

	LEGEND_EXTRACT_FAIL_EFFECT(frame)
end

function LEGEND_EXTRACT_FAIL_EFFECT(frame, isDestroy)
	local frame = ui.GetFrame("itemoptionlegendextract");
	local EXTRACT_FAIL_EFFECT_NAME = frame:GetUserConfig('EXTRACT_FAIL_EFFECT');
	local FAIL_EFFECT_SCALE = tonumber(frame:GetUserConfig('FAIL_EFFECT_SCALE'));
	local FAIL_EFFECT_DURATION = tonumber(frame:GetUserConfig('FAIL_EFFECT_DURATION'));
	local result_fail_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_fail_effect_bg');
	if result_fail_effect_bg == nil then
		return;
	end

	result_fail_effect_bg:PlayUIEffect(EXTRACT_FAIL_EFFECT_NAME, FAIL_EFFECT_SCALE, '_LEGEND_EXTRACT_FAIL_EFFECT');

	ReserveScript("_LEGEND_EXTRACT_FAIL_EFFECT()", FAIL_EFFECT_DURATION)
end

function _LEGEND_EXTRACT_FAIL_EFFECT()
	local frame = ui.GetFrame("itemoptionlegendextract");
	if frame:IsVisible() == 0 then
		return;
	end

	local result_fail_effect_bg = GET_CHILD_RECURSIVELY(frame, 'result_fail_effect_bg');
	if result_fail_effect_bg == nil then
		return;
	end

	result_fail_effect_bg:StopUIEffect('_LEGEND_EXTRACT_FAIL_EFFECT', true, 0.5);
	ui.SetHoldUI(false);
end

-- 아이커 옵션관련 내용 작성
function OPTION_LEGEND_EXTRACT_REGISTER_EXTRACTION_OPTION_CAPTION(frame, invitem, itemobj)
	local gBox = GET_CHILD_RECURSIVELY(frame, "extractoptioncaption")
	gBox:RemoveChild('tooltip_equip_property');

	local yPos = 0;
	local inner_yPos = 0;

	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property', 'tooltip_equip_property', 0, yPos);
	local labelline = GET_CHILD_RECURSIVELY(tooltip_equip_property_CSet, "labelline")
	labelline:ShowWindow(0)
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')

	-- 아이커일 경우 랜덤 옵션 출력
	if itemobj ~= 0 and IS_EXIST_RANDOM_OPTION(itemobj) == true then
		for i = 1 , 6 do
		    local propGroupName = "RandomOptionGroup_"..i;
			local propName = "RandomOption_"..i;
			local propValue = "RandomOptionValue_"..i;
			local clientMessage = 'None'

			if itemobj[propGroupName] == 'ATK' then
			    clientMessage = 'ItemRandomOptionGroupATK'
			elseif itemobj[propGroupName] == 'DEF' then
			    clientMessage = 'ItemRandomOptionGroupDEF'
			elseif itemobj[propGroupName] == 'UTIL_WEAPON' then
			    clientMessage = 'ItemRandomOptionGroupUTIL'
			elseif itemobj[propGroupName] == 'UTIL_ARMOR' then
			    clientMessage = 'ItemRandomOptionGroupUTIL'
			elseif itemobj[propGroupName] == 'UTIL_SHILED' then
			    clientMessage = 'ItemRandomOptionGroupUTIL'
			elseif itemobj[propGroupName] == 'STAT' then
			    clientMessage = 'ItemRandomOptionGroupSTAT'
			end

			if itemobj[propValue] ~= 0 and itemobj[propName] ~= "None" then
				local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(itemobj[propName]));
				local strInfo = ABILITY_DESC_NO_PLUS(opName, itemobj[propValue], 0);
				inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
			end
		end	

		property_gbox:Resize(property_gbox:GetWidth(), inner_yPos);
		ypos = property_gbox:GetY() + property_gbox:GetHeight() + 10;
		property_gbox:Resize(property_gbox:GetWidth(), ypos);

	end

	local itemCls = GetClassByType('Item', invitem.ClassID)

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

end
