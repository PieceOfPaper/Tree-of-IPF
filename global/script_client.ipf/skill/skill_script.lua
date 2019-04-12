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

function C_SCR_OPEN_SAGE_PORTAL(skillType)
    if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('ThisLocalUseNot'));
        return 0;
    end

	local skil = session.GetSkill(skillType);
	if nil == skil then
		return 0;
	end

	ui.OpenFrame("sageportal")
end

function C_SCR_SORCERER_CARD_CHECK(skillType)
	local skil = session.GetSkill(skillType);
	if nil == skil then
		ui.SysMsg(ClMsg("Auto_SeuKil_eopeum"));
		return 0;
	end

	local etc_pc = GetMyEtcObject();
	if nil == etc_pc then
		return 0;
	end

	local cardGUID = etc_pc.Sorcerer_bosscardGUID2;
	-- Name으로 비교하려 했으나, Name은 NT가 안붙어있음.
	if cardGUID == "None" then
		ui.SysMsg(ClMsg("NoCardAvailable"));
		return 0;
	end

	local invitem = session.GetInvItemByGuid(cardGUID);
	if nil == invitem then
		ui.SysMsg(ClMsg("DontHaveBossCard"));
		return 0;
	end
	return 1;
end

function SCR_ITEMDUNGEON_SKL_UI(skillType)
    if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('ThisLocalUseNot'));
        return 0;
    end

	local zoneName = session.GetMapName();
	if SCR_ZONE_KEYWORD_CHECK(zoneName, "NoShop") == "YES" then
		ui.SysMsg(ClMsg('DontOpenThisAria'));
		return;
	end

	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end
	OPEN_ITEMDUNGEON_SELLER();
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

function OPEN_MAGIC_SKL_UI()	
	local frame = ui.GetFrame('skillitemmaker');
	local richtext_1 = frame:GetChild('richtext_1');
	richtext_1:ShowWindow(0);
	local richtext_1_1 = frame:GetChild('richtext_1_1');
	richtext_1_1:ShowWindow(1);
	frame:SetUserValue('MODE', 'CraftSpellBook');
	frame:SetUserValue('SKLNAME', 'RuneCaster_CraftMagicScrolls');
	_SKILLITEMMAKE_RESET(frame);
	frame:ShowWindow(1)

	ui.OpenFrame('skillability');
end

function EQUIP_MENDING_SKL(skillType)
	local skill = session.GetSkill(skillType);
	if skill == nil then
		return 0;
	end
	
	local zoneName = session.GetMapName();
	if SCR_ZONE_KEYWORD_CHECK(zoneName, "NoShop") == "YES" then
		ui.SysMsg(ClMsg('DontOpenThisAria'));
		return;
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
	elseif "Oracle_SwitchGender" == clsName then
		local frame = ui.GetFrame("switchgender");
		SWITCHGENDER_OPEN_UI_SET(frame, clsName, true);
		frame:ShowWindow(1);
		return;
	elseif "Enchanter_EnchantArmor" == clsName then
		local frame = ui.GetFrame("enchantarmor");
		ENCHANTARMOR_OPEN_UI_SET(frame, obj)
		frame:ShowWindow(1);
		return;
    elseif "Sage_PortalShop" == clsName then
        PORTAL_SHOP_REGISTER_OPEN(obj);
        return;
	end

	local frame = ui.GetFrame("itembuff");
	if nil == frame then
		return 0;
	end

	if clsName == 'Appraiser_Apprise' then
		local moneyInput = GET_CHILD_RECURSIVELY(frame, 'MoneyInput');
		moneyInput:SetNumberMode(1);
		moneyInput:SetTypingScp("APPRAISAL_PC_ON_TYPING");	
	end

    local titleName = obj.Name;
    if clsName == 'Squire_WeaponTouchUp' or clsName == 'Squire_ArmorTouchUp' then
        titleName = ClMsg('EqiupmentTouchUp');
    end

	ITEMBUFF_SET_SKILLTYPE(frame, obj.ClassName, obj.Level, titleName);
	ITEMBUFF_INIT_USER_PRICE(frame, obj.ClassName);
	frame:ShowWindow(1);
	ITEMBUFF_REFRESH_LIST(frame);	
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

function GET_LH_SOUND_SKILL(sklID)
	local skillCls = GetClassByType('Skill', sklID);
	if skillCls == nil then
		return 0;
	end

	if skillCls.ClassName == 'Hackapell_Skarphuggning' then
		return 1;
	end

	if skillCls.AttackType == 'Gun' then
		return 1;
	end

	return 0;
end