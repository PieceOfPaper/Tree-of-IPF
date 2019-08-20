-- toolskill_input.lua

function SKL_KEY_DYNAMIC_CASTING(actor, obj, dik, movable, rangeChargeTime, maxChargeTime, autoShot, rotateAble, loopingCharge, gotoSkillUse, execByKeyDown, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockwave, intensity, time, frequency, angle, quickCast, checkState, hitCancel)

	if isVisivle == nil then
		isVisivle = 1;
	end

	if isFullCharge == nil then
		isFullCharge = 0;
	end

	if effectName == nil then
		effectName = "None"
	end

	if scale == nil then
		scale = 1.0;
	end

	if nodeName == nil then
		nodeName = "None"
	end

	if lifeTime == nil then
		lifeTime = 0;
	end

	if shockwave == nil then
		shockwave = 0
	end

	if intensity == nil then 
		intensity = 0
	end
	
	if time == nil then
		time = 0
	end	
	if	frequency == nil then
		frequency = 0;
	end 

	if angle == nil then
		angle = 0;
	end

	if quickCast == nil then
		quickCast = 1
	end

	if quickCast ~= nil and quickCast == false then
		quickCast = 0;
	elseif quickCast ~= nil and quickCast == true then
		quickCast = 1;
	end

	local useMouseDir = 0;
	if obj ~= nil and obj.type == 21614 and session.config.IsMouseMode() == true then
		useMouseDir = 1;		
	end

	geSkillControl.DynamicCastingSkill(actor, obj.type, dik, movable, rotateAble, rangeChargeTime, maxChargeTime, autoShot, loopingCharge, gotoSkillUse, execByKeyDown, upAbleSec, isVisivle, useDynamicLevel, isFullCharge, effectName, nodeName, lifeTime, scale,1,1,1, shockwave, intensity, time, frequency, angle, quickCast, useMouseDir);

	if nil ~= hitCancel and hitCancel == 1 then
		actor:SetHitCancelCast(false)
	end

	if gotoSkillUse == 1 then
		return 0, 0;
	end
	return 1, 0;
end

function SKL_KEY_SELECT_CELL(actor, obj, dik, cellCount, cellSize, chargeTime, autoShot, cellEft, cellEftScale, selCellEft, selCellEftScale, selectionEft, selectionEftScale, backSelect, drawSelectablePos, hitCancel)
	geSkillControl.CellSelectCasting(actor, obj.type, dik, cellCount, cellSize, chargeTime, autoShot, cellEft, cellEftScale, selCellEft, selCellEftScale, selectionEft, selectionEftScale, backSelect, drawSelectablePos);
	if nil ~= hitCancel and hitCancel == 1 then
		actor:SetHitCancelCast(true)
	end
	return 1;
end

function SKL_KEY_GROUND_EVENT(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockWave, shockPower, shockTime, shockFreq, shockAngle, onlyMouseMode, quickCast, hitCancel, isScroll, abilName)

	if onlyMouseMode == 1 and session.config.IsMouseMode() == false then
		geSkillControl.SendGizmoPosByCurrentTarget(actor, obj.type);
		return 0, 1;
	end

	if useDynamicLevel == nil then
		useDynamicLevel = 1.0;
	end

	if isVisivle == nil then
		isVisivle = 1;
	end

	if isFullCharge == nil then
		isFullCharge = 0;
	end

	if effectName == nil then
		effectName = "None"
	end

	if scale == nil then
		scale = 1.0;
	end

	if nodeName == nil then
		nodeName = "None"
	end

	if lifeTime == nil then
		lifeTime = 0;
	end

	if shockwave == nil then
		shockwave = 0
	end

	if intensity == nil then 
		intensity = 0
	end
	
	if time == nil then
		time = 0
	end	
	
	if frequency == nil then
		frequency = 0;
	end 

	if angle == nil then
		angle = 0;
	end

	if quickCast == nil or quickCast == true then
		quickCast = 1;
	elseif quickCast == false then
	    quickCast = 0;
	end

	if isScroll == nil or isScroll == 0 then
		isScroll = false;
	end

	if abilName ~= nil then
		local abil = session.GetAbilityByName(abilName);
		if abil ~= nil then
			local obj = GetIES(abil:GetObject());
			if obj.ActiveState == 1 then
				return 0, 1;
			end
		end
	end

	geSkillControl.GroundSelecting(actor, obj.type, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, isVisivle, useDynamicLevel, isFullCharge, effectName, nodeName, lifeTime, scale,1,1,1, shockwave, intensity, time, frequency, angle, nil, quickCast, isScroll);

	if nil ~= hitCancel and hitCancel == 1 then
		actor:SetHitCancelCast(true)
	end

	return 1, 0;
end

function SKL_KEY_SNIPE(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockWave, shockPower, 
shockTime, shockFreq, shockAngle, onlyMouseMode, hitCancel)

	local time = 0;
	local frequency = 0;
	local angle = 0;
	local intensity = 0;
		if shockwave == nil then
		shockwave = 0
	end


	geSkillControl.GroundSelecting(actor, obj.type, dik, chargeTime, autoShot, 
		shotCasting, lookTargetPos, selRange, upAbleSec, isVisivle, 
		useDynamicLevel, isFullCharge, effectName, nodeName, lifeTime, 
		scale,1,1,1, shockwave, 
		intensity, time, frequency, angle, "Snipe");

	if nil ~= hitCancel and hitCancel == 1 then
		actor:SetHitCancelCast(true)
	end
	return 1, 0;
end

function SKL_KEY_GROUND_ARC(actor, obj, dik, chargeTime,  autoShot, shotCasting, lookTargetPos, upAbleSec, rotatable, minRange, maxRange, linkName, dummyName, eft, eftScale, hitCancel)
	geSkillControl.GroundSelectByArc(actor, obj.type, dik, chargeTime, autoShot, shotCasting, lookTargetPos, upAbleSec, rotatable, minRange, maxRange, linkName, dummyName, eft, eftScale);
	if nil ~= hitCancel and hitCancel == 1 then
		actor:SetHitCancelCast(true)
	end
	return 1, 0;
end

function SKL_KEY_GROUND_CONNECTION(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, x, y, z, moveSpd, hitCancel)
	geSkillControl.GroundConnection(actor, obj.type, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, x, y, z, moveSpd);
	if nil ~= hitCancel and hitCancel == 1 then
		actor:SetHitCancelCast(true)
	end
	return 1, 0;
end

function SKL_KEY_PRESS(actor, obj, dik, startDelay, pressSpd, duration, hitCancel)
	geSkillControl.KeyPress(actor, obj.type, dik, startDelay, pressSpd, duration);
	if nil ~= hitCancel and hitCancel == 1 then
		actor:SetHitCancelCast(true)
	end
return 0, 0;
end

function SKL_SKILL_REUSE_ON_BTN_UP(actor, obj, dik, buffName)
	geSkillControl.SkillReuseOnDikUp(actor, obj.type, dik, buffName);
	return 0;
end

function SKL_PARTY_TARGET_BY_KEY(actor, obj, dik, showHPGauge, isScroll)
	if showHPGauge == nil then
		showHPGauge = 0;
	end
	geSkillControl.SelectTargetFromPartyList(actor, obj.type, showHPGauge, isScroll);
	return 1, 0;
end

function SKL_KEY_DYNAMIC_CASTING_PUNJI(actor, obj, dik, movable, rangeChargeTime, maxChargeTime, autoShot, rotateAble, loopingCharge, gotoSkillUse, execByKeyDown, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockwave, intensity, time, frequency, angle, quickCast, checkState, hitCancel)
	local abil = session.GetAbilityByName("Sapper42");
	if abil ~= nil then
		local obj = GetIES(abil:GetObject());
		if obj.ActiveState == 1 then
			return 0, 1;
		end
	end

	local ret1, ret2 = SKL_KEY_DYNAMIC_CASTING(actor, obj, dik, movable, rangeChargeTime, maxChargeTime, autoShot, rotateAble, loopingCharge, gotoSkillUse, execByKeyDown, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockwave, intensity, time, frequency, angle, quickCast, checkState, hitCancel);
	
	return ret1, ret2;
end

function SKL_KEY_GROUND_EVENT_METEOR(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockWave, shockPower, shockTime, shockFreq, shockAngle, onlyMouseMode, quickCast, hitCancel, isScroll, abilName)
	local buff = info.GetBuffByName(session.GetMyHandle(), "Meteor_FireBall_Buff");
	if buff ~= nil then
		return 0, 1;
	end

	local ret1, ret2 = SKL_KEY_GROUND_EVENT(actor, obj, dik, chargeTime, autoShot, shotCasting, lookTargetPos, selRange, upAbleSec, useDynamicLevel, isVisivle, isFullCharge, effectName, scale, nodeName, lifeTime, shockWave, shockPower, shockTime, shockFreq, shockAngle, onlyMouseMode, quickCast, hitCancel, isScroll, abilName)

	return ret1, ret2;
end