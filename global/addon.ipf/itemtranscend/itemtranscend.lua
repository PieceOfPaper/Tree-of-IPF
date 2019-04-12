
function ITEMTRANSCEND_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_DLG_ITEMTRANSCEND", "ON_OPEN_DLG_ITEMTRANSCEND");

end

function ON_OPEN_DLG_ITEMTRANSCEND(frame)
	frame:ShowWindow(1);	
	ui.SetHoldUI(false);
end

function ITEMTRASCEND_OPEN(frame)
	
	local slot = GET_CHILD(frame, "slot");
	slot:StopActiveUIEffect();
	slot:ClearIcon();
	SET_TRANSCEND_RESET(frame);
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);

	UPDATE_TRANSCEND_ITEM(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMTRANSCEND_INV_RBTN")	
	ui.OpenFrame("inventory");	
	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	
	local slotTemp = GET_CHILD(frame, "slotTemp");
	slotTemp:StopActiveUIEffect();
	slotTemp:ShowWindow(0);	
	frame:SetUserValue("ONANIPICTURE_PLAY", 0);
end

function ITEMTRANSCEND_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:StopActiveUIEffect();
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	frame:ShowWindow(0);
	control.DialogOk();
	ui.CloseFrame("inventory");
	frame:SetUserValue("ONANIPICTURE_PLAY", 0);
 end

function TRANSCEND_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemtranscend");
	UPDATE_TRANSCEND_ITEM(frame);
	UPDATE_TRANSCEND_RESULT(frame, isSuccess);
end

function ITEM_TRANSEND_DROP(frame, icon, argStr, argNum)

	if frame:GetUserIValue("ONANIPICTURE_PLAY") == 1 then
		return;
	end
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();

	-- ?�레�??�롭???�벤?�리?�서�?가?�하�?
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_TRANSCEND_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end;
end;

function ITEM_TRANSCEND_REG_TARGETITEM(frame, itemID)

	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if IS_TRANSCEND_ABLE_ITEM(obj) == 0 then
		ui.MsgBox(ScpArgMsg("ThisItemIsNotAbleToTranscend"));
		return;
	end

	if IS_NEED_APPRAISED_ITEM(obj) == true or IS_NEED_RANDOM_OPTION_ITEM(obj) == true then 
		ui.SysMsg(ClMsg("NeedAppraisd"));
		return;
	end

	local invframe = ui.GetFrame("inventory");
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local slot = GET_CHILD(frame, "slot");
	SET_SLOT_ITEM(slot, invItem);
	SET_TRANSCEND_RESET(frame);	
	ITEM_TRANSCEND_NEED_GUIDE(frame, obj);
	UPDATE_TRANSCEND_ITEM(frame);	
end

-- ?�내메세지�??�요???�이?�을 보여주기 ?�함. 
function ITEM_TRANSCEND_NEED_GUIDE(frame, obj)
	local mtrlName = GET_TRANSCEND_MATERIAL_ITEM(obj);	
	if string.len(mtrlName) <= 0 then
		return;		
	end;	
	local mtrlCls = GetClass("Item", mtrlName);
	if mtrlCls == nil then
		return;
	end		
		
	if obj.Transcend >= 10 then		
		SETTEXT_GUIDE(frame, 1, string.format("{@st43b}{s16}%s{/}", ScpArgMsg("CantTrasncendMore")));
		return;
	end
		
	local needTxt = "";
	needTxt = string.format("{img %s 30 30}{/}{@st43_green}{s16}%s{/}{@st42b}{s16}%s{nl}%s{/}", mtrlCls.Icon, mtrlCls.Name, ScpArgMsg("Need_Item"), GET_TRANSCEND_MAXCOUNT_TXT(obj));			
	SETTEXT_GUIDE(frame, 1, needTxt);
end;

-- 초월 ?�공�?100%???�요??�?�� ?�기
function GET_TRANSCEND_MAXCOUNT(obj)
	return GET_TRANSCEND_MATERIAL_COUNT(obj, nil);
end;

-- 초월 ?�공�?100%???�요??�?�� ?�시
function GET_TRANSCEND_MAXCOUNT_TXT(obj)
	local numColor = "{#FFE400}";
	local mtrl_num = ScpArgMsg("ITEMTRANSCEND_MTRL_NUM{color}{num}", "num", GET_TRANSCEND_MAXCOUNT(obj), "color", numColor);
	local guideTxt = string.format("{@st43b}{s16}{#FFE400}%s{/}{@st42b}{s16}%s{/}{@st42b}{s16}%s{/}", ScpArgMsg("TranscendSuccessRatio{P}%", "P", 100), mtrl_num, ScpArgMsg("ITEMTRANSCEND_MTRL_NUM"));
	return guideTxt;
end;

-- 초월 ?�이?????�???�내메세지.
function SETTEXT_GUIDE(frame, type, text)
	local title_result = frame:GetChildRecursively("title_result");
	local txt_result = frame:GetChildRecursively("txt_result");
	
	title_result:ShowWindow(0);
	txt_result:ShowWindow(0);
	if (type == 0) or (text == nil) or (string.len(text) <= 0) then
		return;
	end;

	if type == 1 then
		title_result:SetTextByKey("value", ScpArgMsg("ITEMtranscend_PROCESS"));
		txt_result:SetTextByKey("value", text);
	elseif type == 2 then
		title_result:SetTextByKey("value", ScpArgMsg("ITEMtranscend_RESULT"));	
		txt_result:SetTextByKey("value", text);	
	elseif type == 3 then
		title_result:SetTextByKey("value", ScpArgMsg("ITEMtranscend_GUIDE"));	
		txt_result:SetTextByKey("value", text);		
	end
	title_result:ShowWindow(1);
	txt_result:ShowWindow(1);
end;

-- 초월 ?�이???�거??
function REMOVE_TRANSCEND_TARGET_ITEM(frame)
	
	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	slot:ClearIcon();
	SET_TRANSCEND_RESET(frame);
	UPDATE_TRANSCEND_ITEM(frame);
	
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_GUIDE_FIRST"));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);	
end

-- ?�료 ?�롯�??�공�? 버튼??초기???�킴.
function SET_TRANSCEND_RESET(frame)
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:SetUserValue("MTRL_COUNT", 0);
	slot_material:StopActiveUIEffect();
	slot_material:ClearIcon();
	slot_material:SetText("");
		
	local text_successratio = frame:GetChild("text_successratio");	
	text_successratio:ShowWindow(0);

	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);
end;

-- ?�려?�있???�료 ?�이???�릭??
function REMOVE_TRANSCEND_MTRL_ITEM(frame, slot)
	local materialItem = GET_SLOT_ITEM(slot);	
	if materialItem == nil then
		return;
	end
	local count = slot:GetUserIValue("MTRL_COUNT");		
	if keyboard.IsPressed(KEY_SHIFT) == 1 then
		count = count - 5;
	elseif keyboard.IsPressed(KEY_ALT) == 1 then
		count = 0;
	else
		count = count - 1;
	end
	
	if count <= 0 then
		local frame = ui.GetFrame("itemtranscend");
		SET_TRANSCEND_RESET(frame);
		local slot = GET_CHILD(frame, "slot");
		local invItem = GET_SLOT_ITEM(slot);
		if invItem == nil then
			return;
		end
		ITEM_TRANSCEND_NEED_GUIDE(frame, GetIES(invItem:GetObject()));
		return;
	end;
	
		
	local text_itemtranscend = frame:GetChild("text_itemtranscend");
	text_itemtranscend:StopColorBlend();
	EXEC_INPUT_CNT_TRANSCEND_MATERIAL(materialItem:GetIESID(), count);
end;

-- ?�료???�른 ?�공률과 ?�이?�의 초월 ?�계 ?�데?�트
function UPDATE_TRANSCEND_ITEM(frame)

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);

	local text_material = frame:GetChild("text_material");
	local text_successratio = frame:GetChild("text_successratio");	
	text_successratio:ShowWindow(0);
	local text_itemstar = frame:GetChild("text_itemstar");
	local text_itemtranscend = frame:GetChild("text_itemtranscend");	
	if invItem == nil then
		text_itemstar:ShowWindow(0);
		text_material:ShowWindow(0);
		text_itemtranscend:ShowWindow(0);	
	else
		local targetObj = GetIES(invItem:GetObject());
		text_itemstar:ShowWindow(1);
		local starTxt = GET_ITEM_GRADE_TXT(targetObj, 24);
		text_itemstar:ShowWindow(1);
		text_itemstar:SetTextByKey("value", starTxt);

		local lev = targetObj.Transcend;
		text_itemtranscend:SetTextByKey("value", string.format("{s20}%s", lev));
		text_itemtranscend:StopColorBlend();
		text_itemtranscend:ShowWindow(1);

		text_material:SetTextByKey("value", GET_FULL_NAME(targetObj));
		text_material:ShowWindow(1);
	end

	if materialItem == nil or invItem == nil then
		slot_material:StopActiveUIEffect();
		text_successratio:ShowWindow(0);
	else
		local targetObj = GetIES(invItem:GetObject());		
		local transcend = targetObj.Transcend;
		local transcendCls = GetClass("ItemTranscend", transcend + 1);
		if transcendCls == nil then
			return;
		end

		local materialCount = slot_material:GetIcon():GetInfo().count;
		local materialObj = GetIES(materialItem:GetObject());
		local successRatio = GET_TRANSCEND_SUCCESS_RATIO(targetObj, transcendCls, materialCount);
		local ratioText = string.format("{s20}%s{/}", ScpArgMsg("TranscendSuccessRatio{P}%", "P", successRatio));
		local color1, color2 = GET_RATIO_FONT_COLOR(successRatio)
		text_successratio:SetTextByKey("value", ratioText);		
		text_successratio:ShowWindow(1);		
		text_successratio:StopColorBlend();
		text_successratio:SetColorBlend(2, color1, color2, true);
	end
end

-- ?�공률에 ?�른 글????변??
-- ?�정 ?�요 (?�상값이 ?�해지지 ?�아???�직 ?�맞?� 계산?�을 �??�우겠음. ?�선 ?�드코딩 ?�놓겠음.)
function GET_RATIO_FONT_COLOR(ratio)	
	local color1 = 0xFF0000;
	local color2 = 0xFFBB00;
	if ratio < 20 then
		color1 = 0x00D8FF;
		color2 = 0x0054FF;
	elseif ratio < 30 then
		color1 = 0x0054FF;
		color2 = 0x22741C;
	elseif ratio < 50 then
		color1 = 0x1DDB16;
		color2 = 0x5CD1E5;
	elseif ratio < 70 then
		color1 = 0x9FC93C;
		color2 = 0x998A00;
	elseif ratio < 90 then
		color1 = 0xFFE08C;
		color2 = 0xF15F5F;
	end;
	return color1, color2;		
end

-- ?�료 ?�이?�을 ?�을??
function ITEM_TRANSCEND_REG_MATERIAL(frame, itemID)

	local invItem = GET_PC_ITEM_BY_GUID(itemID);
	if invItem == nil then
		return;
	end
	
	local obj = GetIES(invItem:GetObject());

	local slot = GET_CHILD(frame, "slot");
	local targetItem = GET_SLOT_ITEM(slot);
	if targetItem == nil then
		return;
	end
	
	local targetObj = GetIES(targetItem:GetObject());
	local transcend = targetObj.Transcend;
	local transcendCls = GetClass("ItemTranscend", transcend + 1);
	if transcendCls == nil then
		ui.MsgBox(ScpArgMsg("CantTrasncendMore"));
		return;
	end
	
	local matItemName = GET_TRANSCEND_MATERIAL_ITEM(targetObj);
	if obj.ClassName ~= matItemName then
		local msgString = ScpArgMsg("PleaseDropItem{Name}", "Name", GetClass("Item", matItemName).Name);
		ui.MsgBox(msgString);
		return;
	end
	
	local maxItemCount = GET_TRANSCEND_MATERIAL_COUNT(targetObj,nil);
	
	if maxItemCount == nil or maxItemCount == 0 then
	    return 0;
	end
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local count = slot_material:GetUserIValue("MTRL_COUNT");	
	if count >= maxItemCount then
		if maxItemCount > invItem.count then
			ui.MsgBox_NonNested(ScpArgMsg("ITEMTRANSCEND_TOO_LACK"), frame:GetName(), nil, nil);		
			return;
		end;
		ui.MsgBox_NonNested(ScpArgMsg("ITEMTRANSCEND_TOO_MANY"), frame:GetName(), nil, nil);		
		return;
	end;

	local invframe = ui.GetFrame("inventory");
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end		

	if IS_NEED_APPRAISED_ITEM(obj) == true  or IS_NEED_RANDOM_OPTION_ITEM(obj) == true then 
		ui.SysMsg(ClMsg("NeedAppraisd"));
		return;
	end

	if keyboard.IsPressed(KEY_SHIFT) == 1 then
		count = count + 5;
	elseif keyboard.IsPressed(KEY_ALT) == 1 then
		count = maxItemCount;
	else
		count = count + 1;
	end
	
	if count >= maxItemCount then
		count = maxItemCount;
	end;

	EXEC_INPUT_CNT_TRANSCEND_MATERIAL(invItem:GetIESID(), count);
	--[[	
	-- 메세지박스�??�량?�로 ?�는 방법
	INPUT_NUMBER_BOX(frame, string.format("%s(%d ~ %d)", ScpArgMsg("InputCount"), 1, maxItemCount), "EXEC_INPUT_CNT_TRANSCEND_MATERIAL", maxItemCount, 1, maxItemCount, nil, tostring(invItem:GetIESID()));
	]]
end

-- ?�료�??�레�??�롭?�을 경우
function DROP_TRANSCEND_MATERIAL(frame, icon, argStr, argNum)

	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();
	
	-- ?�레�??�롭???�벤?�리?�서�?가?�하�?
	if FromFrame:GetName() == 'inventory' then
		ITEM_TRANSCEND_REG_MATERIAL(frame, iconInfo:GetIESID());
	end
end

-- ?�료�??�량???�라 ?�롯???�기
function TRANSCEND_SET_MATERIAL_ITEM(frame, iesID, count)

	local invItem = GET_PC_ITEM_BY_GUID(iesID);
	if invItem == nil then
		return;
	end
	
	if invItem.count < count then
		count = invItem.count;
	end


	local slot_material = GET_CHILD(frame, "slot_material");
	-- ?�량?�시�??�롯???��?분으�??�정 
	SET_SLOT_INVITEM(slot_material, invItem, count);
	slot_material:SetUserValue("MTRL_COUNT", count);
	slot_material:StopActiveUIEffect();
	slot_material:PlayActiveUIEffect();
	
	UPDATE_TRANSCEND_ITEM(frame);
	
	
	local slot = GET_CHILD(frame, "slot");
	local targetItem = GET_SLOT_ITEM(slot);
	if targetItem == nil then
		return;
	end
	local targetObj = GetIES(targetItem:GetObject());
	local tooltipFont = "{@st42b}{s16}";

	local needTxt = string.format("{@st43b}{s16}%s{/}{nl}%s{/}{nl}%s{/}", ScpArgMsg("ITEMTRANSCEND_MTRL_NUM_TOOLTIP{font}", "font", tooltipFont), ScpArgMsg("ITEMTRANSCEND_GUIDE_SECOND"), GET_TRANSCEND_MAXCOUNT_TXT(targetObj));	
	SETTEXT_GUIDE(frame, 3, needTxt);
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(1);
end


function EXEC_INPUT_CNT_TRANSCEND_MATERIAL(iesid, count)
	local frame = ui.GetFrame("itemtranscend");	
	TRANSCEND_SET_MATERIAL_ITEM(frame, iesid, count)	
end

--[[
-- 메세지박스�??�량?�로 ?�는 방법
function EXEC_INPUT_CNT_TRANSCEND_MATERIAL(frame, count, inputframe, fromFrame)
	inputframe:ShowWindow(0);
	local iesid = inputframe:GetUserValue("ArgString");

	local frame = ui.GetFrame("itemtranscend");
	TRANSCEND_SET_MATERIAL_ITEM(frame, iesid, count)	
end
]]

function ITEMTRANSCEND_EXEC(frame)
	-- ?�정 버프 ?�용 중에??강화/초월 막아?�라�??�셨??
	local buffState = IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND_C();
	if buffState ~= 'YES' then
		local buffCls = GetClass('Buff', buffState);
		if buffCls ~= nil then
			ui.SysMsg(ScpArgMsg("CannotReinforceAndTranscendBy{BUFFNAME}","BUFFNAME", buffCls.Name));
		end
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if invItem == nil or materialItem == nil then
		ui.MsgBox(ScpArgMsg("DropItemPlz"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OVER_SOUND"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	local potential = TryGetProp(itemObj, "PR");
	if potential == nil then
		return;
	end

	local clmsg = ScpArgMsg("ReallyExecTranscend_PR_ZERO");
	if potential ~= nil and potential > 0  then
		clmsg = ScpArgMsg("ReallyExecTranscend");
	end

	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OK_SOUND"));
	ui.MsgBox_NonNested(clmsg, frame:GetName(), "_ITEMTRANSCEND_EXEC", "_ITEMTRANSCEND_CANCEL");			
end

function _ITEMTRANSCEND_CANCEL()
	local frame = ui.GetFrame("itemtranscend");
end;

function _ITEMTRANSCEND_EXEC()

	local frame = ui.GetFrame("itemtranscend");
	if frame:IsVisible() == 0 then
		return;
	end
	frame:SetUserValue("ONANIPICTURE_PLAY", 1);
	
	ui.SetHoldUI(true);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_EVENT_EXEC"));
	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if slot == nil or materialItem == nil then
		return;
	end
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);

	slot_material:StopActiveUIEffect();
	local materialCount = slot_material:GetIcon():GetInfo().count;	
	session.ResetItemList();	
	session.AddItemID(invItem:GetIESID());
	session.AddItemID(materialItem:GetIESID());	
	local resultlist = session.GetItemIDList();
	local cntText = string.format("%d", materialCount);
	item.DialogTransaction("ITEM_TRANSCEND_TX", resultlist, cntText);
	
	slot_material:SetUserValue("MTRL_COUNT", 0);
	slot_material:ClearIcon();
	slot_material:SetText("");
	UPDATE_TRANSCEND_ITEM(frame);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_CAST"));
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);	
	
	SETTEXT_GUIDE(frame, 0, nil);
end

-- ?�벤?�서 ?�른�??�릭??
function ITEMTRANSCEND_INV_RBTN(itemObj, slot)
	
	local frame = ui.GetFrame("itemtranscend");

	if frame:GetUserIValue("ONANIPICTURE_PLAY") == 1 then
		return;
	end

	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	local obj = GetIES(invItem:GetObject());
	
	local slot = GET_CHILD(frame, "slot");
	local slotInvItem = GET_SLOT_ITEM(slot);
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);
		
	local text_itemtranscend = frame:GetChild("text_itemtranscend");
	text_itemtranscend:StopColorBlend();

	if slotInvItem ~= nil then
		if ("Premium_item_transcendence_Stone" == obj.ClassName) then
			ITEM_TRANSCEND_REG_MATERIAL(frame, iconInfo:GetIESID());	-- ?�료??경우
			return;
		end;
	end;
	ITEM_TRANSCEND_REG_TARGETITEM(frame, iconInfo:GetIESID());  -- ?�료가 ?�닐 �? 초월 ?�하???�이??
end

-- ?�니?�쳐???�니메이???�에 ?�른 결과 UIeffect ?�정
function ITEMTRANSCEND_BG_ANIM_TICK(ctrl, str, tick)

	if tick == 14 then
		local frame = ctrl:GetTopParentFrame();
		local slot_material = GET_CHILD(frame, "slot_material");
		slot_material:StopActiveUIEffect();
		local animpic_slot = GET_CHILD_RECURSIVELY(frame, "animpic_slot");
		animpic_slot:ForcePlayAnimation();	
		ReserveScript("TRANSCEND_EFFECT()", 0.3);
	elseif tick == 15 then	
		local frame = ctrl:GetTopParentFrame();
	end
end

function TRANSCEND_EFFECT()
	local frame = ui.GetFrame("itemtranscend");
	_UPDATE_TRANSCEND_RESULT(frame, 1);	
end

function UPDATE_TRANSCEND_RESULT(frame, isSuccess)
	if isSuccess == 1 then
		local animpic_bg = GET_CHILD_RECURSIVELY(frame, "animpic_bg");
		animpic_bg:ShowWindow(1);
		animpic_bg:ForcePlayAnimation();
	else
		_UPDATE_TRANSCEND_RESULT(frame, 0);
	end;
end

-- ?�버???�공?��????�른 UI?�펙?��? 결과 ?�데?�트 
function _UPDATE_TRANSCEND_RESULT(frame, isSuccess)			
	local slot = GET_CHILD(frame, "slot");
	
	local timesecond = 0;
	if isSuccess == 1 then
		ui.SysMsg(ScpArgMsg("SuccessToTranscend"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_SUCCESS_SOUND"));
		slot:StopActiveUIEffect();
		slot:PlayActiveUIEffect();
		timesecond = 2;
	else
		ui.SysMsg(ScpArgMsg("FailedToTranscend"));
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_FAIL_SOUND"));
		local slotTemp = GET_CHILD(frame, "slotTemp");
		slotTemp:ShowWindow(1);
		slotTemp:StopActiveUIEffect();
		slotTemp:PlayActiveUIEffect();
		timesecond = 1;
	end
			
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD(gbox, "reg");
	reg:ShowWindow(0);	
	
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		if isSuccess == 0 then
			ui.SysMsg(ClMsg('ItemDeleted'));
		end
		ui.SetHoldUI(false);
		slot:ClearIcon();
		return;
	end
	local obj = GetIES(invItem:GetObject());
	local transcend = obj.Transcend;
	local tempValue = transcend;
	local beforetranscend;

	if isSuccess == 0 then
		beforetranscend = transcend;
		transcend = transcend + 1;
	else
		beforetranscend = transcend - 1;
	end

	local transcendCls = GetClass("ItemTranscend", transcend  );
	if transcendCls == nil then
		ui.SetHoldUI(false);
		return;
	end

	local resultTxt = "";
	local afterNames, afterValues = GET_ITEM_TRANSCENDED_PROPERTY(obj);
	local upfont = "{@st43_green}{s18}";
	local operTxt = " + ";	
	local text_itemtranscend = frame:GetChild("text_itemtranscend");
	local text_color1 = 0xFF1DDB16;
	local text_color2 = 0xFF22741C;
	if isSuccess == 0 then
		upfont = "{@st43_red}{s18}";
		text_color1 = 0xFFFF0000;
		text_color2 = 0xFFFFBB00;
	end;
	text_itemtranscend:ShowWindow(0);
	text_itemtranscend:StopColorBlend();
	text_itemtranscend:SetColorBlend((11 - beforetranscend) * 0.2, text_color1, text_color2, true);
	text_itemtranscend:ShowWindow(1);
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	local gbox = popupFrame:GetChild("gbox");
	gbox:RemoveAllChild();

	for i = 1 , #afterNames do
		local propName = afterNames[i];
		local addedValue = afterValues[i];

		if resultTxt ~= "" then
			resultTxt = resultTxt .. "{nl}{/}";
		end

		resultTxt = string.format("%s%s%s%s%s", resultTxt, upfont, ScpArgMsg(propName), operTxt, addedValue);
		resultTxt = resultTxt .. "%{/}";
		local ctrlSet = gbox:CreateOrGetControlSet("transcend_result_text", "RV_" .. propName, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local text = ctrlSet:GetChild("text");
		text:SetTextByKey("propname", ScpArgMsg(propName));
		text:SetTextByKey("propoper", operTxt);
		text:SetTextByKey("propvalue", addedValue);
		
	
	end
		
	SETTEXT_GUIDE(frame, 2, resultTxt);
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true , true);
	
	ui.SetTopMostFrame(popupFrame);
	popupFrame:Resize(popupFrame:GetWidth(), gbox:GetHeight());

	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	frame:RunUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND", timesecond);
	frame:SetUserValue("ONANIPICTURE_PLAY", 0);
end

-------------------------
-- 결과???�른 UIeffect가 ?�업 결과 UI�?가리는 ?�유�?
-- ?�간차로 ?�업 결과 UI�??�워주기 ?�한 UpdateScript.
function TIMEWAIT_STOP_ITEMTRANSCEND()
	local frame = ui.GetFrame("itemtranscend");
	local slotTemp = GET_CHILD(frame, "slotTemp");
	slotTemp:ShowWindow(0);
	slotTemp:StopActiveUIEffect();
		
	local popupFrame = ui.GetFrame("itemtranscendresult");
	local gbox = popupFrame:GetChild("gbox");
	popupFrame:ShowWindow(1);	
	popupFrame:SetDuration(6.0);
	
	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	return 1;
end

function ITEMTRANSCEND_FAIL_TO_TRANSCEND()
	ui.SetHoldUI(false);
end

function IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND_C()
	local myHandle = session.GetMyHandle();	
	if info.GetBuffByName(myHandle, 'Forgery_Buff') ~= nil then
		return 'Forgery_Buff';
	end

	if info.GetBuffByName(myHandle, 'OverEstimate_Buff') ~= nil then
		return 'OverEstimate_Buff';
	end

	if info.GetBuffByName(myHandle, 'Devaluation_Debuff') ~= nil then
		return 'Devaluation_Debuff';
	end

	return 'YES';
end