-- padskill_c.lua

function C_EFFECT_REMOVE_KEY()

end

function C_PAD_MONSTER(actor, obj, padGuid, monName, scale, animName, aniXmlKey, lifeTime)
	
	if lifeTime == nil then
		lifeTime = 3.0;
	end

	geClientPadSkill.AddClientMonster(padGuid, monName, scale, animName, aniXmlKey, lifeTime);
end

function C_GET_PAD_GRASS_POS(actor, x, y, z, padName, range)
	local padList = SelectPad_C(actor, padName, x, y, z, range, 'ALL');
	if #padList < 1 then
		return 0, 0, 0
	end

	local pad = tolua.cast(padList[1], "CClientPadSkill");
	local padPos = pad:GetPos();
	return padPos.x, padPos.y, padPos.z;
end

function PAD_SET_HOLD(actor, obj, padGuid)
	
	geClientPadSkill.SetPadHoldMove(padGuid);

end

function C_PAD_EFFECT_POS(actor, obj, padGuid, eftName, scl, x, y, z, lifeTime, activeEffect, activeEffect_arg, isEnablePositionCompensation)
	if isEnablePositionCompensation == nil then
		isEnablePositionCompensation = 1;
	end
	effect.PlayPadEffect(actor, eftName, scl, x, y, z, lifeTime, activeEffect, padGuid, isEnablePositionCompensation);
end

function C_FORM_PAD_CHANGE_ACTIVE_EFFECT(actor, obj, padGuid, index, activeEffect)

	effect.ChangeFormationPadActiveEffect(actor, index, activeEffect, padGuid);
end

function C_PAD_DESTROY_EFFECT_POS(pad, obj, padGuid, x, y, z, eftName, scl, lifeTime, delay)

	local padOwner = geClientPadSkill.GetPadOwner(padGuid);
	if padOwner ~= nil then
		effect.PlayGroundEffect(padOwner, eftName, scl, x, y, z, lifeTime, "None", 0, delay);
	else
		local myActor = GetMyActor();
		effect.PlayGroundEffect(myActor, eftName, scl, x, y, z, lifeTime, "None", 0, delay);
	end
end

function C_PAD_EFFECT_FORCE(actor, obj, padGuid, eftName, scl, fixHeight)
	effect.PlayPadForceEffect(actor, eftName, scl, fixHeight, padGuid);
end

function C_PAD_CHANGE_EFFECT(actor, obj, padGuid, padName, range, padStyle, eftName, scl)
	local pos = actor:GetPos();
	local padList = SelectPad_C(actor, padName, pos.x, pos.y, pos.z, range, padStyle);
	if #padList == 0 then
		return;
	end

	for i = 1, #padList do
		local pad = tolua.cast(padList[i], "CClientPadSkill");
		effect.ChangePadEffect(actor, eftName, scl, pad:GetGuid());
	end
end

function PAD_PLANT_ATTACK_C(actor, obj, padGuid)
	geClientPadSkill.SetPadPlantAttack(padGuid);
end


------ formation
function CREATE_FORMATION_NUM_BTN(uiName, value)
	local frame = ui.GetFrame("fieldui");
	local ctrlSet = frame:CreateOrGetControlSet('formation_btn', uiName, 0, 0);
	local slot = ctrlSet:GetChild("slot");
	slot:SetTextByKey("value", value);
	ctrlSet:ShowWindow(0);

end

function DESTROY_FORMATION_NUM_BTN(uiName)
	local frame = ui.GetFrame("fieldui");
	frame:RemoveChild(uiName);
end

function SELECT_FORMATION_NUM_BTN(uiName, isSelect)
	local frame = ui.GetFrame("fieldui");
	local ctrlSet = frame:GetChild(uiName);
	local slot = ctrlSet:GetChild("slot");
	if isSelect == 1 then
		ctrlSet:PlayUIEffect("I_sys_item_slot_loop", 1, "Formation");
	else
		ctrlSet:StopUIEffect("Formation", true, 0.5);
	end
end

