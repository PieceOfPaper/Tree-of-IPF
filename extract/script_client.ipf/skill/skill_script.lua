-- skill_script.lua

function EquipSkill_C_Chronomancer_BackMasking(actor, obj)

	hardSkill.EnableRecordPosition_C(5);

end

function BACKMASKING_READY(actor, obj, range)
	hardSkill.ExecRecordedPos(range)
end

function SKL_OPEN_UI_C(actor, obj, uiName, subUi)
	if GetMyActor() == actor then
		ui.OpenFrame(uiName);

		if nil ~= subUi then	
			ui.OpenFrame(subUi);
		end
	end

end

function SCR_ITEMDUNGEON_SKL_UI(skillType)
	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end
	ui.OpenFrame("itemdungeon");
	return 0;
end

function SKL_RUN_SCRIPT_C(actor, obj, funcName)
	local func = _G[funcName];
	func(actor, obj);
end

function RUN_BUFF_SELLER(actor, obj)
	if GetMyActor() == actor then
		BUFFSELLER_OPEN("buff");
	end
end

function EQUIP_MENDING_SKL(skillType)
	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end
		-- 방향은 정면과 대각정면까지만 허용. 상점을 뒤로 개설 할 필욘없음.
	local myActor = GetMyActor();
	local rotateAngle = fsmactor.GetAngle(myActor);

	-- 귀찮으니 걍 각도로 때려넣음
--			135
--		180		90
--	-135			45
--		-90		0
--			-45

	if rotateAngle < 100 and rotateAngle > 20 then
		myActor:SetRotate(0);
	elseif rotateAngle > 30 and rotateAngle < 100 then
		myActor:SetRotate(-90);
	elseif rotateAngle > 150 then
		myActor:SetRotate(-90);
	elseif rotateAngle > 100 and rotateAngle < 180 then
		myActor:SetRotate(-45);
	elseif rotateAngle < -60 then
		myActor:SetRotate(-90);
	end

	local obj = GetIES(skill:GetObject());
	local clsName = obj.ClassName;

	if "Pardoner_SpellShop" == clsName then
		local frame = ui.GetFrame("buffseller_register");
		BUFFSELLER_INIT(frame);
		frame:ShowWindow(1);
		return;
	end

	if "Oracle_SwitchGender" == clsName then
		local frame = ui.GetFrame("buffseller_register");
		BUFFSELLER_INIT(frame);
		BUFFSELLER_SET_CUSTOM_SKILL_TYPE(frame, clsName, obj.ClassID);
		frame:ShowWindow(1);
		return;
	end

	local frame = ui.GetFrame("itembuff");
	if nil == frame then
		return 0;
	end

	ITEMBUFF_SET_SKILLTYPE(frame, obj.ClassName, obj.Level, obj.Name);
	frame:ShowWindow(1);
	ITEMBUFF_REFRESH_LIST(frame);
	return 0;
end

function SCR_SKILL_BRIQUITE(skillType)
	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end

	local obj = GetIES(skill:GetObject());
	local frame = ui.GetFrame("briquetting");
	if nil == frame then
		return 0;
	end

	frame:ShowWindow(1);
	BRIQUETTING_SET_SKILLTYPE(frame, obj.ClassName, obj.Level);
	BRIQUETTING_UI_RESET(frame);
	ui.OpenFrame("inventory");
	return 0;
end


function CAMP_SKILL(skillType)
	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end

	local obj = GetIES(skill:GetObject());
	local frame = ui.GetFrame("camp_register");
	if nil == frame then
		return 0;
	end

	CAMP_REG_INIT(frame, obj.ClassName, obj.Level);
	frame:ShowWindow(1);
	return 0;
end

function FOODTABLE_SKILL(skillType)
	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end

	local obj = GetIES(skill:GetObject());
	local frame = ui.GetFrame("foodtable_register");
	if nil == frame then
		return 0;
	end

	FOODTABLE_SKILL_INIT(frame, obj.ClassName, obj.Level);
	frame:ShowWindow(1);
	return 0;
end


function OBLATION_RUN_CLIENT(skillType)
	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end

	local obj = GetIES(skill:GetObject());
	local frame = ui.GetFrame("oblation");
	if nil == frame then
		return 0;
	end

	OBLATION_INIT(frame, obj.ClassName, obj.Level);
	frame:ShowWindow(1);
	return 0;
end


function SET_ENABLESKILLCANCEL_HITINDEX_C(actor, obj, cancelHitIndex)

	actor:SetEnableSkillCancelHitIndex(cancelHitIndex);
end