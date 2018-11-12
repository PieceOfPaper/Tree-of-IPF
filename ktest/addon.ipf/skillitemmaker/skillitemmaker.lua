function SKILLITEMMAKER_ON_INIT(addon, frame)

	frame = ui.GetFrame('skillitemmaker');
	local richtext_1 = frame:GetChild('richtext_1');
	richtext_1:ShowWindow(1);
	local richtext_1_1 = frame:GetChild('richtext_1_1');
	richtext_1_1:ShowWindow(0);

	frame:SetUserValue("SKLNAME", 'Pardoner_Simony');
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

	if iconInfo.category == "Skill" then
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
	local resultItem = GET_CHILD(frame, "slot_result", "ui::CSlot");
	local resultCls = GetClass("Item", "Scroll_SkillItem");
	SET_SLOT_ITEM_CLS(resultItem, resultCls);
	frame:GetChild("progtime"):SetTextByKey("value", "0");

	local sklCls = GetClassByType("Simony", skillType);

	if sklCls == nil or 'YES' ~= sklCls.CanMake then
	    ui.SysMsg(ClMsg("CanNotCraftSkill"));
		CLEAR_SKILLITEMMAKER(frame);
		_SKILLITEMMAKE_RESET(frame);
		return;
	end
	
	local skillInfo = session.GetSkill(skillType);
	local sklObj = GetIES(skillInfo:GetObject());

	frame:SetUserValue("SKILLTYPE", skillType);
	local skill_slot = GET_CHILD(frame, "skillslot", "ui::CSlot");
	SET_SLOT_SKILL(skill_slot, sklObj);
	
	local count = sklObj.Level;
	if frame:GetUserValue('MODE') ~= 'CraftSpellBook' then
		local sklName = frame:GetUserValue('SKLNAME');
		local mySimonySkill = GetSkill(GetMyPCObject(), sklName);	
		count = mySimonySkill.Level;		
		
		-- 만든 스킬이, 시모니 레벨 보다 클때
		if sklObj.Level >= mySimonySkill.Level then
			count = mySimonySkill.Level;
		elseif sklObj.Level < mySimonySkill.Level then
			count = sklObj.Level;
		end
	end

	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	droplist_level:ClearItems();

	 for i = 1 , count do
	 	droplist_level:AddItem(i,  "{@st42}" .. ClMsg("Level") .. " " .. i, 0);
	 end
	 -- 스킬 레벨 까지
	 droplist_level:SelectItem(count-1);
	 droplist_level:SetSelectedScp("SKILLITEMKAE_NUMCHANGE");
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
	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	local levelSkill = droplist_level:GetSelItemIndex()+1;
	frame:GetChild("skilllevel"):SetTextByKey("value", levelSkill);	
	
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	if sklObj == nil then
		return;
	end

	UPDATE_SKILLITEMMAKE_PRICE(parent:GetTopParentFrame(), sklObj, levelSkill);
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

	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	local levelSkill = droplist_level:GetSelItemIndex()+1;
	local totalVis, totalBottle = SKILLITEMMAKE_GET_TOTAL_MARTERIAL(frame, levelSkill);
	local sklObj = SKILLITEMMAKE_GET_SKL_OBJ(frame);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(frame:GetUserValue("SKLNAME"), sklObj, levelSkill);
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
	local bottleCls = GetClass("Item", bottle);
	local myBottle = session.GetInvItemByName(bottleCls.ClassName);
	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	local level = droplist_level:GetSelItemIndex()+1;
	local argList = string.format("%d %d %d", sklObj.ClassID, level, curCount);
	pc.ReqExecuteTx_Item("ITEM_SKILL_MAKER", myBottle:GetIESID(), argList);

	_SKILLITEMMAKE_RESET(frame);
end

function _SKILLITEMMAKE_RESET(frame)
	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local totalprice = frame:GetChild("totalprice");
	makecount:SetNumberValue(0);
	makecount:SetIncrValue(0);
	totalprice:SetTextByKey("value", 0);

	local droplist_level = GET_CHILD(frame, "droplist_level", "ui::CDropList");
	droplist_level:ClearItems();

	CLEAR_SKILLITEMMAKER(frame);
end

function UPDATE_SKILLITEMMAKE_PRICE(frame, sklObj, levelSkill)
	local vis = GET_SKILL_MAT_PRICE(sklObj, levelSkill);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(frame:GetUserValue("SKLNAME"), sklObj, levelSkill);
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
	matslot:SetText('{s20}{ol}{b}'..totalBottle, 'count', 'right', 'bottom', -2, 1);

	local makecount = GET_CHILD(frame, "makecount", "ui::CNumUpDown");
	local curCount = makecount:GetNumber();
	local makeSec = GET_SKILL_ITEM_MAKE_TIME(sklObj, curCount);
	local progtime = frame:GetChild("progtime");
	progtime:SetTextByKey("value", makeSec);
	local gauge = GET_CHILD(frame, "gauge", "ui::CGauge");
    gauge:SetPoint(0, 100);
end

function IS_SKILL_SCROLL_ITEM(item)
	if TryGetProp(item, 'ClassName') == 'Scroll_SkillItem' then
		return true;
	end
	return false;
end