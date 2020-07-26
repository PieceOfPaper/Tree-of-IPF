function SCR_CLIENT_Premium_Change_Guild_Emblem(invItem)
    session.party.DeleteGuildEmblem()
 end

-- 특성 초기화
 function ABILITY_POINT_RESET_C(invItem)
	local frame = ui.GetFrame("skillstat");
 	if invItem.isLockState == true then
		frame:ShowWindow(0);
 		ui.SysMsg(ClMsg('MaterialItemIsLock'));
 		return;
 	end

 	local itemObj = GetIES(invItem:GetObject());
 	if itemObj.ItemLifeTimeOver > 0 then
 		ui.SysMsg(ClMsg('LessThanItemLifeTime'));
		return;
 	end 	

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local richtext = frame:GetChild("richtext");
	richtext:SetTextByKey("value", itemObj.Name);

	local str = frame:GetChild("str");
	str:SetTextByKey("value", itemObj.Name);

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 1,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	
	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("AbillityReset_skin");

	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value", ClMsg("AllAbilityWithoutArts"));
    endTxt2:SetTextByKey("msg", "");

    local prop = ctrlSet:GetChild("prop");
    prop:SetTextByKey("value", ClMsg("Premium_AbilityResetLng")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemObj.ClassName);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, true);
	SKILLSTAT_RESIZE(frame, frame:GetUserConfig("HEIGHT_STATRESET"))

	local getAbilPoint = GetTotalAbilityPoint(GetMyPCObject(), 0);
	if getAbilPoint == nil then
		getAbilPoint = 0;
	end
	local curAbilPoint = session.ability.GetAbilityPoint();

	local detail = GET_CHILD_RECURSIVELY(frame, "detail");
	local font = frame:GetUserConfig("FONT_STATCOUNT");

	detail:SetTextByKey("value", ScpArgMsg("UseItemToReset{value}AbilityPoints", "value", font..GET_COMMAED_STRING(getAbilPoint).."{/}", "value2", font..GET_COMMAED_STRING(getAbilPoint).."{/}", "value3", font..GET_COMMAED_STRING(curAbilPoint).."{/}"));
	detail:ShowWindow(1);
end

function _ABILITY_POINT_RESET_C(frame, itemGuid)
	-- 변경된 마진을 초기화
	local detail = GET_CHILD_RECURSIVELY(frame, "detail");
	local curMargin = detail:GetMargin();
	local originTop = frame:GetUserConfig("DETAIL_TOP");
	detail:SetMargin(curMargin.left, originTop, curMargin.right, curMargin.bottom);

	pc.ReqExecuteTx_Item("ABILITY_POINT_RESET", itemGuid, '0');
end

-- 아츠 특성 초기화
function ABILITY_POINT_RESET_ARTS_C(invItem)
	local frame = ui.GetFrame("skillstat");
	if invItem.isLockState == true then
		frame:ShowWindow(0);
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	if itemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('LessThanItemLifeTime'));
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local richtext = frame:GetChild("richtext");
	richtext:SetTextByKey("value", itemObj.Name);

	local str = frame:GetChild("str");
	str:SetTextByKey("value", itemObj.Name);

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 1,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	
	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("ArtsReset_skin");

	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value", ClMsg("AllArtsAbility"));
    endTxt2:SetTextByKey("msg", "");

    local prop = ctrlSet:GetChild("prop");
    prop:SetTextByKey("value", ClMsg("Premium_JobArtsResetLng")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemObj.ClassName);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, true);
	SKILLSTAT_RESIZE(frame, frame:GetUserConfig("HEIGHT_ABILRESET"))
	
	local jobName = "Char"..TryGetProp(itemObj, 'NumberArg1', 0).."_"..TryGetProp(itemObj, 'NumberArg2', 0);
	local getAbilPoint = GetTotalAbilityPointByJob(GetMyPCObject(), jobName, 1);
	if getAbilPoint == nil then
		getAbilPoint = 0;
	end
	local curAbilPoint = session.ability.GetAbilityPoint();

	local detail = GET_CHILD_RECURSIVELY(frame, "detail");
	local font = frame:GetUserConfig("FONT_STATCOUNT");
	
	local giveItemCls = GetClass("Item", "HiddenAbility_MasterPiece");
	local giveItemCount = GetTotalAbilityLevelByJob(GetMyPCObject(), jobName, 1);

	detail:SetTextByKey("value", ScpArgMsg("UseItemToReset{value}Arts", "value", font..GET_COMMAED_STRING(getAbilPoint).."{/}", "name", TryGetProp(giveItemCls, "Name", "None"), "count", font..tostring(giveItemCount).."{/}", "value2", font..GET_COMMAED_STRING(getAbilPoint).."{/}", "value3", font..GET_COMMAED_STRING(curAbilPoint).."{/}"));

	local curMargin = detail:GetMargin();
	local abilMarginTop = frame:GetUserConfig("DETAIL_ARTS_TOP");
	detail:SetMargin(curMargin.left, abilMarginTop, curMargin.right, curMargin.bottom);
	detail:ShowWindow(1);
end

function _ABILITY_POINT_RESET_ARTS_C(frame, itemGuid)
	-- 변경된 마진을 초기화
	local detail = GET_CHILD_RECURSIVELY(frame, "detail");
	local curMargin = detail:GetMargin();
	local originTop = frame:GetUserConfig("DETAIL_TOP");
	detail:SetMargin(curMargin.left, originTop, curMargin.right, curMargin.bottom);

	pc.ReqExecuteTx_Item("ABILITY_POINT_RESET_ARTS", itemGuid, '0');
end

-- 특성 초기화(단일)
function ABILITY_POINT_RESET_ONE_ABILITY_C(invItem)
	if invItem.isLockState == true then
		ui.SysMsg(ClMsg('MaterialItemIsLock'));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	if itemObj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ClMsg('LessThanItemLifeTime'));
		return;
	end 	

	local yesscp = string.format('_ABILITY_POINT_RESET_ONE_ABILITY_C("%s")', invItem:GetIESID());
	ui.MsgBox(ClMsg('ReallyUseAbilityPointResetItem_OneAbility'), yesscp, 'None');
end

function _ABILITY_POINT_RESET_ONE_ABILITY_C(itemGuid)
	pc.ReqExecuteTx_Item("ABILITY_POINT_RESET_ONE_ABILITY", itemGuid, '0');
end