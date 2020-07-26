function ITEMTRANSCEND_ON_INIT(addon, frame)
	addon:RegisterMsg("OPEN_DLG_ITEMTRANSCEND", "ON_OPEN_DLG_ITEMTRANSCEND");
end

function ON_OPEN_DLG_ITEMTRANSCEND(frame, msg, argStr, isLegendShop)
	frame:SetUserValue('IS_LEGEND_SHOP', isLegendShop);
	frame:ShowWindow(1);	
	ui.SetHoldUI(false);
end

function ITEMTRASCEND_OPEN(frame)	
	local slot = GET_CHILD(frame, "slot");
	slot:StopActiveUIEffect();
	slot:ClearIcon();
	ITEMTRANSCEND_LOCK_ITEM("None");
	SET_TRANSCEND_RESET(frame);
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_GUIDE_FIRST"));	

	UPDATE_TRANSCEND_ITEM(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN("ITEMTRANSCEND_INV_RBTN");
	ui.OpenFrame("inventory");	
	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	
	local slotTemp = GET_CHILD(frame, "slotTemp");
	slotTemp:StopActiveUIEffect();
	slotTemp:ShowWindow(0);	
	frame:SetUserValue("ONANIPICTURE_PLAY", 0);
	frame:SetUserValue("REQ_LEGEND_ITEM_DIALOG_TYPE", 0);

	local text_bg = GET_CHILD_RECURSIVELY(frame, "text_bg")
	text_bg:ShowWindow(0);

	local textEdit = GET_CHILD_RECURSIVELY(frame, "textEdit");
	textEdit:SetTextByKey("value", " ");

	local richtext_1 = GET_CHILD_RECURSIVELY(frame, 'richtext_1');
	if frame:GetUserIValue('IS_LEGEND_SHOP') ~= 1 then	
		richtext_1:SetTextByKey('value', ClMsg('itemtranscend'));
	else
		richtext_1:SetTextByKey('value', ClMsg('legenditemtranscend'));
	end
end

function ITEMTRANSCEND_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	ITEMTRANSCEND_LOCK_ITEM("None");

	control.DialogOk();

	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:StopActiveUIEffect();
	
	-- DialogOk()를 실행하면 다이얼로그가 전부 닫힙니다.
	-- 추가적인 다이얼로그를 띄우고 싶으시다면 반드시 DialogOK() 하단에 실행해주세요.
	local dialog_type = frame:GetUserValue("REQ_LEGEND_ITEM_DIALOG_TYPE");
	control.CustomCommand("REQ_LEGEND_ITEM_DIALOG", dialog_type);

	frame:ShowWindow(0);
	frame:SetUserValue("ONANIPICTURE_PLAY", 0);
	frame:SetUserValue("REQ_LEGEND_ITEM_DIALOG_TYPE", 0);

	ui.CloseFrame("inventory");
 end

function TRANSCEND_UPDATE(isSuccess)
	local frame = ui.GetFrame("itemtranscend");	
	UPDATE_TRANSCEND_ITEM(frame);
	UPDATE_TRANSCEND_RESULT(frame, isSuccess);
end

function ITEM_TRANSEND_DROP(frame, icon, argStr, argNum)
	if ui.CheckHoldedUI() == true then
		return;
	end
	
	if frame:GetUserIValue("ONANIPICTURE_PLAY") == 1 then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();

	-- 드레그 드롭이 인벤토리에서만 가능하게
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_TRANSCEND_REG_TARGETITEM(frame, iconInfo:GetIESID());
	end
end

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

	if frame:GetUserIValue('IS_LEGEND_SHOP') ~= 1 and TryGetProp(obj, 'LegendGroup', 'None') ~= 'None' then
		frame:SetUserValue("REQ_LEGEND_ITEM_DIALOG_TYPE", 1);
		ui.CloseFrame('itemtranscend');
		ui.CloseFrame('inventory');
		return;
	end

	local invframe = ui.GetFrame("inventory");
	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local slot = GET_CHILD(frame, "slot");
	SET_SLOT_ITEM(slot, invItem);
	ITEMTRANSCEND_LOCK_ITEM(invItem:GetIESID());
	SET_TRANSCEND_RESET(frame);	
	ITEM_TRANSCEND_NEED_GUIDE(frame, obj);
	UPDATE_TRANSCEND_ITEM(frame);	
	
	local transcend = obj.Transcend;
	ITEM_TRANSCEND_NEEDMATERIAL_TEXT_UPDATE(frame, obj);

	--local transcendCls = GetClass("ItemTranscend", transcend + 1);
	--if transcendCls == nil then
		--return;
	--end
		
	--EVENT_1804_TRANSCEND_DISCOUNT
	--SCR_EVENT_TRANSCEND_DISCOUNT_TEXT(frame, obj)

    -- EVENT_1903_WEEKEND
    --if SCR_EVENT_1903_WEEKEND_CHECK('TRANSCEND', false) == 'YES' then
    --    SCR_EVENT_TRANSCEND_DISCOUNT_TEXT(frame, obj)
    --end
    
	local msg = ScpArgMsg('ItemDecomposeWarningProp_Transcend')
    --burning event
    local pc = GetMyPCObject()
	if IsBuffApplied(pc, "Event_Even_Transcend_Discount_50") == "YES" then
		local transcendCount = TryGetProp(itemObj, "Transcend");
		if transcendCount % 2 == 1 then
			msg = msg..ScpArgMsg('EVENT_REINFORCE_DISCOUNT_MSG1')
		end
	end
	--steam_new_world
	if IsBuffApplied(pc, "Event_Steam_New_World_Buff") == "YES" then
		msg = msg..ScpArgMsg('EVENT_REINFORCE_DISCOUNT_MSG1')
	end
	SCR_EVENT_TRANSCEND_DISCOUNT_TEXT(frame, msg)
end

-- 아아템 초월시 여신의 축복석 Text 갱신 함수.
function ITEM_TRANSCEND_NEEDMATERIAL_TEXT_UPDATE(frame, targetobj)
	local material_MaxCnt = GET_TRANSCEND_MAXCOUNT(targetobj);
	local material_MaxCnt_Text = tostring(material_MaxCnt);

	local slot_mtrl = GET_CHILD_RECURSIVELY(frame, "slot_material");
	local count = slot_mtrl:GetUserIValue("MTRL_COUNT");
	local count_text = tostring(count);

	local ret = count_text .. "/" .. material_MaxCnt_Text;
	local textEdit = GET_CHILD_RECURSIVELY(frame, "textEdit");
	textEdit:SetTextByKey("value", ret);
end

--EVENT_1811_WEEKEND
function SCR_EVENT_TRANSCEND_DISCOUNT_TEXT(frame, msg)
    local gbox = GET_CHILD(frame, "gbox");
    local gbox2 = GET_CHILD(gbox, "gbox2");
	local reg = GET_CHILD(gbox2, "reg");
	reg:SetTextByKey("value",msg)
end


-- 안내메세지로 필요한 아이템을 보여주기 위함. 
function ITEM_TRANSCEND_NEED_GUIDE(frame, obj)
	local mtrlName = GET_TRANSCEND_MATERIAL_ITEM(obj);	
	if string.len(mtrlName) <= 0 then
		return;		
	end;	
	local mtrlCls = GetClass("Item", mtrlName);
	if mtrlCls == nil then
		return;
	end		
		
	local needTxt = "";
	needTxt = string.format("{img %s 30 30}{/}{@st43_green}{s16}%s{/}{@st42b}{s16}%s{nl}%s{/}", mtrlCls.Icon, mtrlCls.Name, ScpArgMsg("Need_Item"), GET_TRANSCEND_MAXCOUNT_TXT(obj));				
end;

-- 초월 성공률 100%에 필요한 갯수 얻기
function GET_TRANSCEND_MAXCOUNT(obj)
	return GET_TRANSCEND_MATERIAL_COUNT(obj, nil);
end;

-- 초월 성공률 100%에 필요한 갯수 표시
function GET_TRANSCEND_MAXCOUNT_TXT(obj)
	local numColor = "{#FFE400}";
	local mtrl_num = ScpArgMsg("ITEMTRANSCEND_MTRL_NUM{color}{num}", "num", GET_TRANSCEND_MAXCOUNT(obj), "color", numColor);
	local guideTxt = string.format("{@st43b}{s16}{#FFE400}%s{/}{@st42b}{s16}%s{/}{@st42b}{s16}%s{/}", ScpArgMsg("TranscendSuccessRatio{P}%", "P", 100), mtrl_num, ScpArgMsg("ITEMTRANSCEND_MTRL_NUM"));
	return guideTxt;
end;

-- 초월 아이템 에 대한 안내메세지.
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

-- 초월 아이템 제거시
function REMOVE_TRANSCEND_TARGET_ITEM(frame)

	if ui.CheckHoldedUI() == true then
		return;
	end

	frame = frame:GetTopParentFrame();
	local slot = GET_CHILD(frame, "slot");
	slot:ClearIcon();
	ITEMTRANSCEND_LOCK_ITEM("None");
	SET_TRANSCEND_RESET(frame);
	UPDATE_TRANSCEND_ITEM(frame);
	
	local needTxt = string.format("{@st43b}{s16}%s{/}", ScpArgMsg("ITEMTRANSCEND_GUIDE_FIRST"));	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);	

	local textEdit = GET_CHILD_RECURSIVELY(frame, "textEdit");
	textEdit:SetTextByKey("value", " ");

end

-- 재료 슬롯과 성공률, 버튼을 초기화 시킴.
function SET_TRANSCEND_RESET(frame)
	local slot_material = GET_CHILD(frame, "slot_material");
	slot_material:SetUserValue("MTRL_COUNT", 0);
	slot_material:StopActiveUIEffect();
	slot_material:ClearIcon();
	slot_material:SetText("");
			
	local text_bg = GET_CHILD_RECURSIVELY(frame, "text_bg")
	text_bg:ShowWindow(0);

	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD_RECURSIVELY(gbox, "reg");
	reg:SetTextByKey("value", ScpArgMsg('ItemDecomposeWarningProp_Transcend'))
end

-- 올려져있는 재료 아이템 클릭시 
function REMOVE_TRANSCEND_MTRL_ITEM(frame, slot)
	local materialItem = GET_SLOT_ITEM(slot);	
	if materialItem == nil then
		return;
	end
	local count = slot:GetUserIValue("MTRL_COUNT");		
	if keyboard.IsKeyPressed("LSHIFT") == 1 then
		count = count - 5;
	elseif keyboard.IsKeyPressed("LALT") == 1 then
		count = 0;
	else
		count = count - 1;
	end
	
	--초월석 갯수 표시
	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then
		return;
	end
	
	local targetobj = GetIES(invItem:GetObject());
	if targetobj == nil then
		return;
	end

	local material_MaxCnt = GET_TRANSCEND_MAXCOUNT(targetobj);
	local material_MaxCnt_Text = tostring(material_MaxCnt);
	local count_text = tostring(count);
	local textEdit = GET_CHILD_RECURSIVELY(frame, "textEdit")

	if count <= 0 then
		local frame = ui.GetFrame("itemtranscend");
		SET_TRANSCEND_RESET(frame);
		local slot = GET_CHILD(frame, "slot");
		invItem = GET_SLOT_ITEM(slot);
		if invItem == nil then
			return;
		end
		ITEM_TRANSCEND_NEED_GUIDE(frame, GetIES(invItem:GetObject()));
		textEdit:SetTextByKey("value", " ");
		return;
	else
		local ret = count_text .. "/" .. material_MaxCnt_Text;
		textEdit:SetTextByKey("value", ret);
	end
	
		
	local text_itemtranscend = GET_CHILD_RECURSIVELY(frame, "text_itemtranscend");
	text_itemtranscend:StopColorBlend();
	EXEC_INPUT_CNT_TRANSCEND_MATERIAL(materialItem:GetIESID(), count);
end;

-- 재료에 따른 성공률과 아이템의 초월 단계 업데이트
function UPDATE_TRANSCEND_ITEM(frame)

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);

	local text_material = frame:GetChild("text_material");

	local text_bg = GET_CHILD_RECURSIVELY(frame, "text_bg")
	text_bg:ShowWindow(0);
	local text_successratio = GET_CHILD_RECURSIVELY(frame, "text_successratio");
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
		text_bg:ShowWindow(0);

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
		text_bg:ShowWindow(1)
		text_successratio:StopColorBlend();
		text_successratio:SetColorBlend(2, color1, color2, true);
	end

	if invItem ~= nil then
		local Obj = GetIES(invItem:GetObject());
		ITEM_TRANSCEND_NEEDMATERIAL_TEXT_UPDATE(frame, Obj);
	end
end

-- 성공률에 따른 글자 색 변환
-- 수정 필요 (색상값이 정해지지 않아서 아직 알맞은 계산식을 못 세우겠음. 우선 하드코딩 해놓겠음.)
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

-- 재료 아이템을 넣을때
function ITEM_TRANSCEND_REG_MATERIAL(frame, itemID, isMax)

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

	if keyboard.IsKeyPressed("LSHIFT") == 1 then
		count = count + 5;
elseif keyboard.IsKeyPressed("LALT") == 1 or isMax == true then
		count = maxItemCount;
	else
		count = count + 1;
	end
	
	if count >= maxItemCount then
		count = maxItemCount;
	end;

	ITEM_TRANSCEND_NEEDMATERIAL_TEXT_UPDATE(frame, targetObj);

	EXEC_INPUT_CNT_TRANSCEND_MATERIAL(invItem:GetIESID(), count);
	
--	--EVENT_1804_TRANSCEND_DISCOUNT
--	SCR_EVENT_TRANSCEND_DISCOUNT_TEXT(frame, targetObj)
    
    -- EVENT_1903_WEEKEND
    --if SCR_EVENT_1903_WEEKEND_CHECK('TRANSCEND', false) == 'YES' then
    --    SCR_EVENT_TRANSCEND_DISCOUNT_TEXT(frame, targetObj)
    --end


	local msg = ScpArgMsg('ItemDecomposeWarningProp_Transcend')
    --burning_event
    local pc = GetMyPCObject()
    if IsBuffApplied(pc, "Event_Even_Transcend_Discount_50") == "YES" then
		local transcendCount = TryGetProp(targetObj, "Transcend");
		if transcendCount % 2 == 1 then
			msg = msg..ScpArgMsg('EVENT_REINFORCE_DISCOUNT_MSG1')
		end
    end

	if IsBuffApplied(pc, "Event_Steam_New_World_Buff") == "YES" then
		msg = msg..ScpArgMsg('EVENT_REINFORCE_DISCOUNT_MSG1')
    end
	SCR_EVENT_TRANSCEND_DISCOUNT_TEXT(frame, msg)
end

-- 재료를 드레그 드롭했을 경우
function DROP_TRANSCEND_MATERIAL(frame, icon, argStr, argNum)

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();
	
	-- 드레그 드롭이 인벤토리에서만 가능하게
	if FromFrame:GetName() == 'inventory' then
		ITEM_TRANSCEND_REG_MATERIAL(frame, iconInfo:GetIESID(), false);
	end
end

-- 재료를 수량에 따라 슬롯에 넣기
function TRANSCEND_SET_MATERIAL_ITEM(frame, iesID, count)

	local invItem = GET_PC_ITEM_BY_GUID(iesID);
	if invItem == nil then
		return;
	end
	
	if invItem.count < count then
		count = invItem.count;
	end


	local slot_material = GET_CHILD(frame, "slot_material");
	-- 수량표시를 슬롯의 위부분으로 수정 
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
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD_RECURSIVELY(gbox, "reg");
	reg:SetTextByKey("value", ScpArgMsg('ItemDecomposeWarningProp_Transcend'))
end


function EXEC_INPUT_CNT_TRANSCEND_MATERIAL(iesid, count)
	local frame = ui.GetFrame("itemtranscend");	
	TRANSCEND_SET_MATERIAL_ITEM(frame, iesid, count)	
end

function ITEMTRANSCEND_EXEC(frame)
	-- 특정 버프 사용 중에는 강화/초월 막아달라고 하셨음.
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
    
    local legendGroup = TryGetProp(itemObj, "LegendGroup");
	if legendGroup == nil then
		return;
	end
    
	if frame:GetUserIValue('IS_LEGEND_SHOP') == 1 and  legendGroup ~= nil and legendGroup ~= 'None' then
		clmsg = ClMsg('LegendItemCannotBreakOrRemove');
	end	

	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_BTN_OK_SOUND"));
	--ui.MsgBox_NonNested(clmsg, frame:GetName(), "_ITEMTRANSCEND_EXEC", "_ITEMTRANSCEND_CANCEL");	
	WARNINGMSGBOX_FRAME_OPEN(clmsg, "_ITEMTRANSCEND_EXEC", "_ITEMTRANSCEND_CANCEL")		
end

function _ITEMTRANSCEND_CANCEL()
	local frame = ui.GetFrame("itemtranscend");
end;

function _ITEMTRANSCEND_EXEC(checkRebuildFlag)
	local frame = ui.GetFrame("itemtranscend");
	if frame:IsVisible() == 0 then
		return;
	end

	local slot = GET_CHILD(frame, "slot");
	local invItem = GET_SLOT_ITEM(slot);
	if checkRebuildFlag ~= false then
		local invItemObj = GetIES(invItem:GetObject());
		if TryGetProp(invItemObj, 'Rebuildchangeitem', 0) > 0 then		
			ui.MsgBox(ScpArgMsg('IfUDoCannotExchangeWeaponType'), '_ITEMTRANSCEND_EXEC(false)', 'None');
			return;
		end
	end

	frame:SetUserValue("ONANIPICTURE_PLAY", 1);
	
	ui.SetHoldUI(true);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_EVENT_EXEC"));
	
	
	local slot_material = GET_CHILD(frame, "slot_material");
	local materialItem = GET_SLOT_ITEM(slot_material);	
	if slot == nil or materialItem == nil then
		return;
	end
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD_RECURSIVELY(gbox, "reg");
	reg:SetTextByKey("value", ScpArgMsg('ItemDecomposeWarningProp_Transcend'))

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
	ITEMTRANSCEND_LOCK_ITEM("None");
	slot_material:SetText("");
	UPDATE_TRANSCEND_ITEM(frame);
	imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_CAST"));
	
	local popupFrame = ui.GetFrame("itemtranscendresult");
	popupFrame:ShowWindow(0);	

	local textEdit = GET_CHILD_RECURSIVELY(frame, "textEdit");
	textEdit:SetTextByKey("value", " ");
end

-- 인벤에서 오른쪽 클릭시 
function ITEMTRANSCEND_INV_RBTN(itemObj, slot)
	if ui.CheckHoldedUI() == true then
		return;
	end

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
			ITEM_TRANSCEND_REG_MATERIAL(frame, iconInfo:GetIESID(), false);	-- 재료일 경우
			return;
		end;
	end;
	ITEM_TRANSCEND_REG_TARGETITEM(frame, iconInfo:GetIESID());  -- 재료가 아닐 경, 초월 당하는 아이템
end

function ITEMTRANSCEND_UPBTN(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	if frame == nil then
		return
	end
		
	local topFrame = frame:GetTopParentFrame()
	if topFrame == nil then
		return
	end

	local item = session.GetInvItemByType(646045);
	
	if item == nil then
		return
	end

	ITEM_TRANSCEND_REG_MATERIAL(topFrame, item:GetIESID(), false)
end

function ITEMTRANSCEND_DOWNBTN(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	if frame == nil then
		return
	end

	local topFrame = frame:GetTopParentFrame()
	if topFrame == nil then
		return
	end

	local slot = GET_CHILD_RECURSIVELY(topFrame, "slot_material")
	REMOVE_TRANSCEND_MTRL_ITEM(topFrame, slot)
end

function ITEMTRANSCEND_MAXBTN(frame)
	if ui.CheckHoldedUI() == true then
		return;
	end

	if frame == nil then
		return
	end
		
	local topFrame = frame:GetTopParentFrame()
	if topFrame == nil then
		return
	end

	local item = session.GetInvItemByType(646045);
	
	if item == nil then
		return
	end

	ITEM_TRANSCEND_REG_MATERIAL(topFrame, item:GetIESID(), true)
end


-- 애니픽쳐의 애니메이션 틱에 따른 결과 UIeffect 설정
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

-- 서버의 성공여부에 따른 UI이펙트와 결과 업데이트 
function _UPDATE_TRANSCEND_RESULT(frame, isSuccess)			
	local slot = GET_CHILD(frame, "slot");
	
	local timesecond = 0;
	if isSuccess == 1 then
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_SUCCESS_SOUND"));
		slot:StopActiveUIEffect();
		slot:PlayActiveUIEffect();
		timesecond = 2;
	else
		imcSound.PlaySoundEvent(frame:GetUserConfig("TRANS_FAIL_SOUND"));
		local slotTemp = GET_CHILD(frame, "slotTemp");
		slotTemp:ShowWindow(1);
		slotTemp:StopActiveUIEffect();
		slotTemp:PlayActiveUIEffect();
		timesecond = 1;
	end
			
	
	local gbox = frame:GetChild("gbox");
	local reg = GET_CHILD_RECURSIVELY(gbox, "reg");

	local invItem = GET_SLOT_ITEM(slot);
	if invItem == nil then		
		ui.SetHoldUI(false);
		slot:ClearIcon();
		ITEMTRANSCEND_LOCK_ITEM("None");
		frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
		frame:SetUserValue("ONANIPICTURE_PLAY", 0);
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
		
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true , true);
	
	ui.SetTopMostFrame(popupFrame);
	popupFrame:Resize(popupFrame:GetWidth(), gbox:GetHeight());

	frame:StopUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND");
	frame:RunUpdateScript("TIMEWAIT_STOP_ITEMTRANSCEND", timesecond);
	frame:SetUserValue("ONANIPICTURE_PLAY", 0);
end

-------------------------
-- 결과에 따른 UIeffect가 팝업 결과 UI를 가리는 이유로 
-- 시간차로 팝업 결과 UI를 띄워주기 위한 UpdateScript.
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
	
	if info.GetBuffByName(myHandle, 'OverReinforce_Buff') ~= nil then
		return 'OverReinforce_Buff';
	end

	if info.GetBuffByName(myHandle, 'Devaluation_Debuff') ~= nil then
		return 'Devaluation_Debuff';
	end

	return 'YES';
end

function ITEMTRANSCEND_LOCK_ITEM(guid)
	local invframe = ui.GetFrame("inventory");
	invframe:SetUserValue("ITEM_GUID_IN_TRANSCEND", guid);
	INVENTORY_ON_MSG(invframe, 'UPDATE_ITEM_REPAIR');
end