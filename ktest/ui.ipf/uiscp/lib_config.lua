---- lib_config.lua

function UPDATE_CONTROL_MODE()

	SetLockKeyboardSelectMode(0);
	local controlmodeType = tonumber(config.GetXMLConfig("ControlMode"));

	SetChangeUIMode(controlmodeType);

	if controlmodeType == 1 then
		--조이패드
		SetJoystickMode(1)
		UI_MODE_CHANGE(1)
	elseif controlmodeType == 2 then
		--키보드
		SetJoystickMode(0)
		UI_MODE_CHANGE(2)
	elseif controlmodeType == 3 then
		SetLockKeyboardSelectMode(1);
		SetJoystickMode(0);
		UI_MODE_CHANGE(2)
	end

	if controlmodeType == 3 then
		session.config.SetMouseMode(true);
	else
		session.config.SetMouseMode(false);
	end

	local modetime = session.GetModeTime();
	if modetime > 0 then
		local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
        if quickSlotFrame ~= nil and QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME ~= nil then
		    QUICKSLOTNEXPBAR_UPDATE_HOTKEYNAME(quickSlotFrame);
		    quickSlotFrame:Invalidate();
        end
				
		local restquickslot = ui.GetFrame('restquickslot');
        if restquickslot ~= nil and RESTQUICKSLOT_UPDATE_HOTKEYNAME ~= nil then
		    RESTQUICKSLOT_UPDATE_HOTKEYNAME(restquickslot);
		    restquickslot:Invalidate();
        end

		local fluting_keyboard = ui.GetFrame('fluting_keyboard');
        if fluting_keyboard ~= nil and FLUTING_KEYBOARD_UPDATE_HOTKEYNAME ~= nil then
		    FLUTING_KEYBOARD_UPDATE_HOTKEYNAME(fluting_keyboard);
		    fluting_keyboard:Invalidate();
        end
	end
end

function UPDATE_SNAP()
	config.UpdateSnap()
end

function UPDATE_OTHER_PC_EFFECT(value)
	config.EnableOtherPCEffect(tonumber(value));
end

function ENABLE_OTHER_PC_EFFECT_UNCHECK()
	config.EnableOtherPCEffect(0);
	local frame = ui.GetFrame("systemoption");
	if frame ~= nil then
		local otherPCDamage = GET_CHILD_RECURSIVELY(frame, "check_ShowOtherPCEffect", "ui::CCheckBox");
		if otherPCDamage ~= nil then
			otherPCDamage:SetCheck(0);
		end
	end
end

function ENABLE_OTHER_PC_EFFECT_CHECK()
	config.EnableOtherPCEffect(1);
	local frame = ui.GetFrame("systemoption");
	if frame ~= nil then
		local otherPCDamage = GET_CHILD_RECURSIVELY(frame, "check_ShowOtherPCEffect", "ui::CCheckBox");
		if otherPCDamage ~= nil then
			otherPCDamage:SetCheck(1);
		end
	end
end

function UPDATE_NATURAL_EFFECT(value)
	config.EnableNaturalEffect(tonumber(value));
end

function UPDATE_OTHER_PC_DAMAGE_EFFECT(value)
	config.EnableOtherPCDamageEffect(tonumber(value));
end

function UPDATE_DEAD_PARTS(value)
	config.EnableDeadParts(tonumber(value));
end

function UPDATE_SILHOUETTE(value)
	config.EnableCharSilhouette(tonumber(value));
end

function UPDATE_GIZMOTARGETAIM(value)
	config.EnableSkillGizmoTargetAim(tonumber(value));
end

function UPDATE_ENABLE_RENDERSHADOW(value)
	config.SetRenderShadow(tonumber(value));
	imcperfOnOff.EnableRenderShadow(tonumber(value));
end