function SKILLITEMMAKER_ON_INIT(addon, frame)
	frame = ui.GetFrame('skillitemmaker');
	local richtext_1 = frame:GetChild('richtext_1');
	richtext_1:ShowWindow(1);
	local richtext_1_1 = frame:GetChild('richtext_1_1');
	richtext_1_1:ShowWindow(0);

	frame:SetUserValue("SKLNAME", 'Pardoner_Simony');
end

function OPEN_SKILLITEMMAKER(frame)
	local skillability = ui.GetFrame('skillability');	
	skillability:SetOffset(frame:GetWidth(), skillability:GetY());
	skillability:ShowWindow(1);
end

function SKILLITEMMAKER_FIRST_OPEN(frame)
	CLEAR_SKILLITEMMAKER(frame);
	_SKILLITEMMAKE_RESET(frame);	
end

function POP_SKILLITEM_MAKER(frame)
	_SKILLITEMMAKE_RESET(frame)
end

function DROP_SKILLITEM_MAKER(frame, icon, argStr, argNum)
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	local iconInfo = liftIcon:GetInfo();

	if iconInfo:GetCategory() == "Skill" then
		SKILLITEMMAKER_REGISTER(toFrame, iconInfo.type);
	end
end

function CLEAR_SKILLITEMMAKER(frame)
	frame:GetChild("skilltext"):SetTextByKey("value", "");
	frame:GetChild("skilllevel"):SetTextByKey("value", "");
	frame:GetChild("skillname"):SetTextByKey("value", "");
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(skill_slot);
	local mattext = frame:GetChild("mattext");
	mattext:SetTextByKey("value", "");
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(matslot);
end

function SKILLITEMMAKER_REGISTER(frame, skillType)
	local sklCls = GetClassByType("Simony", skillType);
	if sklCls == nil or 'YES' ~= sklCls.CanMake then
	    ui.SysMsg(ClMsg("CanNotCraftSkill"));
		CLEAR_SKILLITEMMAKER(frame);
		_SKILLITEMMAKE_RESET(frame);
		return;
	end
	
	local skillInfo = session.GetSkill(skillType);
	local sklObj = GetIES(skillInfo:GetObject());
	local skillTreeCls = GET_SKILLTREE_CLS(sklObj.ClassName);
	if sklObj.Level < skillTreeCls.MaxLevel then
		ui.SysMsg(ClMsg("CanOnlyWithMaxLevel"));
		CLEAR_SKILLITEMMAKER(frame);
		_SKILLITEMMAKE_RESET(frame);
		return;
	end
	
	local resultItem = GET_CHILD(frame, "slot_result", "ui::CSlot");
	local resultCls = GetClass("Item", GET_SKILL_SCROLL_ITEM_NAME_BY_SKILL(sklObj));
	SET_SLOT_ITEM_CLS(resultItem, resultCls);
	frame:GetChild("progtime"):SetTextByKey("value", "0");

	frame:SetUserValue("SKILLTYPE", skillType);
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	SET_SLOT_SKILL(skill_slot, sklObj);
	
	local count = sklObj.Level;
	if sklObj.Caption == "None" then
		frame:GetChild("skilltext"):SetTextByKey("value", "");
	else
		frame:GetChild("skilltext"):SetTextByKey("value", sklObj.Caption);		
	end
	
	-- 시모니 레벨만큼 할 것
	frame:GetChild("skilllevel"):SetTextByKey("value", count);
	frame:GetChild("skillname"):SetTextByKey("value", sklObj.Name);
				
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	makecount:SetNumChangeScp("SKILLITEMKAE_NUMCHANGE");
	makecount:SetNumberValue(1);	
	makecount:SetIncrValue(1);

	SKILLITEMKAE_NUMCHANGE(frame);
end

function SKILLITEMMAKE_GET_SKL_OBJ(frame)
	local skillType= frame:GetUserIValue("SKILLTYPE");
	local skillInfo = session.GetSkill(skillType);
	return GetIES(skillInfo:GetObject());
end

function SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame, sklevel)
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local vis = GET_SKILL_MAT_PRICE(sklObj, sklevel);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(frame:GetUserValue("SKLNAME"), sklObj, sklevel);
	if frame:GetUserValue("SKLNAME") == "RuneCaster_CraftMagicScrolls" then
	    bottleCnt = bottleCnt * 2;
	end	
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local totalVis = curCount * vis;
	local totalBottle = curCount * bottleCnt;
	return totalVis, totalBottle;
end

function SKILLITEM_MAKE_START(sec)
	local frame = ui.GetFrame("skillitemmaker");
	local gauge = GET_CHILD(frame, "gauge", "ui::CGauge");
	gauge:SetPoint(0, 100);
    gauge:SetPointWithTime(100, sec, 1);	
end

function SKILLITEMKAE_NUMCHANGE(parent)
	local frame = parent:GetTopParentFrame();	
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	if sklObj == nil then
		return;
	end

	UPDATE_SKILLITEMMAKE_PRICE(parent:GetTopParentFrame(), sklObj, sklObj.Level);
end

function SKILLITEMMAKE_EXEC(frame)
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	if nil == IS_CLEAR_SLOT_ITEM_INFO(skill_slot) then		
		return;
	end

	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	if 0 == makecount:GetNumber() then		
		return;
	end

	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local totalVis, totalBottle = SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame, sklObj.Level);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(frame:GetUserValue("SKLNAME"), sklObj, sklObj.Level);
	if frame:GetUserValue("SKLNAME") == "RuneCaster_CraftMagicScrolls" then
	    bottleCnt = bottleCnt * 2;
	end
	local bottleCls = GetClass("Item", bottle);
	local visCls = GetClass("Item", "Vis");
	local myVis = session.GetInvItemCountByType(visCls.ClassID);
	local myBottle = session.GetInvItemByName(bottleCls.ClassName);
	if myVis < totalVis then
		ui.SysMsg(ClMsg("NotEnoughMoney"));
		return;
	end
	
	if myBottle == nil then
	    ui.SysMsg(ClMsg("NotEnoughMaterial"));
	    return;
	end

	if true == myBottle.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	if myBottle.count < totalBottle  then
		ui.SysMsg(ClMsg("NotEnoughRecipe"));
		return;
	end

	ui.MsgBox(ClMsg("ReallyManufactureItem?"), "_SKILLITEMMAKE_EXEC", "None");
end


function _SKILLITEMMAKE_EXEC()
	local frame = ui.GetFrame("skillitemmaker");
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(frame:GetUserValue("SKLNAME"), sklObj, sklObj.Level);
	if frame:GetUserValue("SKLNAME") == "RuneCaster_CraftMagicScrolls" then
	    bottleCnt = bottleCnt * 2;
	end
	local bottleCls = GetClass("Item", bottle);
	local myBottle = session.GetInvItemByName(bottleCls.ClassName);
	local argList = string.format("%d %d", sklObj.ClassID, curCount);
	pc.ReqExecuteTx_Item("ITEM_SKILL_MAKER", myBottle:GetIESID(), argList);
	_SKILLITEMMAKE_RESET(frame);
end

function _SKILLITEMMAKE_RESET(frame)
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local totalprice = frame:GetChild("totalprice");
	makecount:SetNumberValue(0);
	makecount:SetIncrValue(0);
	totalprice:SetTextByKey("value", 0);

	CLEAR_SKILLITEMMAKER(frame);
end

function UPDATE_SKILLITEMMAKE_PRICE(frame, sklObj, levelSkill)
	local vis = GET_SKILL_MAT_PRICE(sklObj, levelSkill);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(frame:GetUserValue("SKLNAME"), sklObj, levelSkill);
	if frame:GetUserValue("SKLNAME") == "RuneCaster_CraftMagicScrolls" then
	    bottleCnt = bottleCnt * 2;
	end
	local bottleCls = GetClass("Item", bottle);
	local matDesc = ClMsg("Material") .. " : ";
	matDesc = matDesc .. GET_MONEY_IMG(36) .. vis;
	matDesc = matDesc .. "   {img " .. bottleCls.Icon .. " 36 36} " .. bottleCnt;

	local mattext = frame:GetChild("mattext");
	mattext:SetTextByKey("value", matDesc);

	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");
	SET_SLOT_ITEM_CLS(matslot, bottleCls);
	
	local totalprice = frame:GetChild("totalprice");
	local matslot = GET_CHILD(frame, "matslot", "ui::CSlot");

	local totalVis, totalBottle = SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame, levelSkill);
	totalprice:SetTextByKey("value", GetCommaedText(totalVis));
	matslot:SetText('{s20}{ol}{b}'..totalBottle, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);

	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local makeSec = GET_SKILL_ITEM_MAKE_TIME(sklObj, curCount);
	local progtime = frame:GetChild("progtime");
	progtime:SetTextByKey("value", makeSec);
	local gauge = GET_CHILD(frame, "gauge", "ui::CGauge");
    gauge:SetPoint(0, 100);
end